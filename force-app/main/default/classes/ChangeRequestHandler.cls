public without sharing class ChangeRequestHandler implements ITrigger {
    private Map<String, Change_Request__c> requestsToUpdate = new Map<String,Change_Request__c>();
    private Map<String, Account> accountsToUpdate = new Map<String, Account>();
    private List<Change_Request__c> newRequests = new List<Change_Request__c>();
    private List<Change_Request__c> oldRequests = new List<Change_Request__c>();
    private List<User> beforeInsertUsers = new List<User>();
    private Map<Id, Account> ChangeRequestAccountMap;
    private Map<String, Account> allAccounts = new Map<String, Account>();
    private Boolean isFirstRun = true;

    public ChangeRequestHandler() {
        
    }

    public void bulkBefore(){
        if(!Trigger.isDelete){
            isFirstRun = CommonUtils.isFirstRun('Change_Request__c');

           beforeInsertUsers = new List<User>([SELECT Id, Sears_Enterprise_Id__c, Name, Upper_Name__c, ProfileId, ManagerId FROM User WHERE UserType = 'Standard' AND IsActive = True]);
            Set<Id> accountIds = new Set<Id>();

            for (Change_Request__c cr :(List<Change_Request__c>)Trigger.new) {
                accountIds.add(cr.Account_Name__c);
            }

            ChangeRequestAccountMap = new Map<Id, Account>([SELECT Id, OwnerId FROM Account WHERE Id IN :accountIds]);
        }
    }

    public void bulkAfter(){     
        if(!Trigger.isDelete){ 
           Set<Id> accountIds = new Set<Id>();
           Set<Id> parentIds = new Set<Id>();

           newRequests = [SELECT Id, Account_Name__c, Account_Name__r.ParentId, Current_Request__c, Auto_Approve__c, CreatedById FROM Change_Request__c WHERE Id IN :Trigger.newMap.keySet()];
           
           for(Change_Request__c record :newRequests){
                if(record.Account_Name__c != null && !accountIds.contains(record.Account_Name__c)){
                    accountIds.add(record.Account_Name__c);
                    if(record.Account_Name__r.ParentId != null && !parentIds.contains(record.Account_Name__r.ParentId)){
                        parentIds.add(record.Account_Name__r.ParentId);
                    }
                }
            }

            for(Account acc : [SELECT Id, ParentId, Pricing_Tier__c, SAP_Account_ID__c, Pricing_Tier_Assignment_Date__c, Pricing_Tier_Expiration_Date__c, Automation_Control__c, Automation_Control_Type__c FROM Account WHERE Id IN :accountIds OR Id IN :parentIds OR ParentId IN :accountIds OR ParentId IN :parentIds]){
                if(!allAccounts.containsKey(acc.Id)){
                    allAccounts.put(acc.Id, acc);
                }
            }
                

            oldRequests = [Select Id, Account_Name__c, Current_Request__c, Auto_Approve__c FROM Change_Request__c WHERE Current_Request__c = true AND Account_Name__c IN :accountIds AND Id NOT IN :Trigger.newMap.keySet()];
        }           
    }

    public void beforeInsert(Sobject obj){
        Change_Request__c crObject = (Change_Request__c)obj;
        updateApprover(crObject);
    }

    public void beforeUpdate(Sobject oldObj, Sobject newObj){

    }

    public  void beforeDelete(Sobject obj){

    }

    public void afterInsert(Sobject obj){ 
        Change_Request__c crObject = (Change_Request__c)obj;   
        setCurrentRequestFlag(crObject);
        if(crObject.Auto_Approve__c && isFirstRun){
            for(Change_Request__c record :newRequests){
                if(crObject.Id == record.Id){
                    System.debug('***** AfterInsert AccountId : ' + crObject.Account_Name__c);
                    assignTierException(allAccounts.get(crObject.Account_Name__c), record, crObject.New_Pricing_Tier__c);
                }
            }
        }
    }

    public void afterUpdate(Sobject oldObj, Sobject newObj){
        Change_Request__c oldRequest = (Change_Request__c)oldObj;
        Change_Request__c newRequest = (Change_Request__c)newObj;

        if(isFirstRun && oldRequest.Request_Status__c != newRequest.Request_Status__c && newRequest.Request_Status__c == 'Approved' && String.isNotBlank(newRequest.New_Pricing_Tier__c)){
            for(Change_Request__c record :newRequests){
                if(newRequest.Id == record.Id){
                    System.debug('***** AfterUpdate AccountId : ' + newRequest.Account_Name__c);
                    assignTierException(allAccounts.get(newRequest.Account_Name__c), record, newRequest.New_Pricing_Tier__c);
                }
            }
        }
    }

    public void afterDelete(Sobject obj){

    }

    public void andFinally(){
        if(requestsToUpdate.size() > 0){
            update requestsToUpdate.values();
        }
        if(accountsToUpdate.size() > 0){
            update accountsToUpdate.values();
        }
    }    


    //***************************Helper Methods******************************
    private void setCurrentRequestFlag(Change_Request__c crObject){
        for(Change_Request__c record :newRequests){
            if(record.Id == crObject.Id && !requestsToUpdate.containsKey(record.Id)){
                record.Current_Request__c = true;
                requestsToUpdate.put(record.Id, record);
            }
        }

        for(Change_Request__c record :oldRequests){
            if(record.Account_Name__c == crObject.Account_Name__c && !requestsToUpdate.containsKey(record.Id)){
                record.Current_Request__c = false;
                requestsToUpdate.put(record.Id, record);
            }
        }
    }

    private void updateApprover(Change_Request__c crObject){
        for(User u : beforeInsertUsers) {
            if(u.Id == ChangeRequestAccountMap.get(crObject.Account_Name__c).OwnerId) {
                if(u.ProfileId == Common_Variables__c.getInstance('Account Manager Profile Id').Content__c || u.ProfileId == Common_Variables__c.getInstance('IST Profile Id').Content__c) {
                    crObject.Change_Request_Approver__c = u.ManagerId;
                    System.debug('********* Approver Manager Id - ' + u.ManagerId);
                }
                else {
                    crObject.Change_Request_Approver__c = u.Id;
                    System.debug('********* Approver DM Id - ' + u.ManagerId);
                }
            }
        }
    }

    private void assignTierException(Account account, Change_Request__c request, String newTier){
        if(account != null){
            System.debug('***** Update Tier');
            List<Account> caseAccounts = new List<Account>();
            Long randomNumber = CommonUtils.getAutomationControl();
            String automation = CommonUtils.getAutomationControlTypes(true, true, true);
            String annualSalesVolume = newTier == 'Silver' ? 'C' : newTier == 'Gold' ? 'B' : newTier == 'Platinum' ? 'A' : 'D';
            account.Pricing_Tier_Expiration_Date__c = datetime.newInstance(System.now().year() + 1, 1, 31);
            account.Automation_Control__c = randomNumber;
            account.Automation_Control_Type__c = automation;            

            System.debug('***** SAP ID and Check: ' + account.SAP_Account_ID__c + ' : ' + String.isNotBlank(account.SAP_Account_ID__c));
            if(String.isNotBlank(account.SAP_Account_ID__c)){
                System.debug('***** Create Case');
                caseAccounts.add(account);
            }
            else{
                account.Potential_Annual_Sales_Volume__c = annualSalesVolume;
                account.Pricing_Tier__c = request.New_Pricing_Tier__c;
                account.Pricing_Tier_Assignment_Date__c = System.now();
            }

            if(!accountsToUpdate.containsKey(account.Id)){
                accountsToUpdate.put(account.Id, account);
            }
            
            if(!request.Auto_Approve__c){
                /***********************************************
                if(String.isNotBlank(account.ParentId)){
                    Account parentAccount = allAccounts.get(account.ParentId);
                    //parentAccount.Pricing_Tier__c = request.New_Pricing_Tier__c;
                    //parentAccount.Pricing_Tier_Assignment_Date__c = System.now();
                    parentAccount.Pricing_Tier_Expiration_Date__c = datetime.newInstance(System.now().year() + 1, 1, 31);
                    parentAccount.Automation_Control__c = randomNumber;
                    parentAccount.Automation_Control_Type__c = automation;
                    
                    if(!accountsToUpdate.containsKey(parentAccount.Id)){
                        accountsToUpdate.put(parentAccount.Id, parentAccount);
                    }

                    system.debug('***** expiration year: ' + System.now().year() + 1);
                    if(String.isNotBlank(parentAccount.SAP_Account_ID__c)){
                        caseAccounts.add(parentAccount);
                    }

                    for(Account acc : allAccounts.values()){
                        if(acc.ParentId != null && acc.ParentId == parentAccount.Id && acc.Id != account.Id){
                            acc.Pricing_Tier_Expiration_Date__c = datetime.newInstance(System.now().year() + 1, 1, 31);
                            acc.Automation_Control__c = randomNumber;
                            acc.Automation_Control_Type__c = automation;

                            if(!accountsToUpdate.containsKey(acc.Id)){
                                accountsToUpdate.put(acc.Id, acc);
                            }

                            if(String.isNotBlank(acc.SAP_Account_ID__c)){
                                caseAccounts.add(acc);
                            }
                        }
                    }
                }
                else{ *******************************************/
                    for(Account acc : allAccounts.values()){
                        if(acc.ParentId != null && acc.ParentId == account.Id && acc.Id != account.Id){                          
                            
                            acc.Pricing_Tier_Expiration_Date__c = datetime.newInstance(System.now().year() + 1, 1, 31);
                            acc.Automation_Control__c = randomNumber;
                            acc.Automation_Control_Type__c = automation;
                            
                            if(String.isBlank(acc.SAP_Account_ID__c)){
                                acc.Potential_Annual_Sales_Volume__c = annualSalesVolume;
                                acc.Pricing_Tier__c = request.New_Pricing_Tier__c;
                                acc.Pricing_Tier_Assignment_Date__c = System.now();
                            }
                            else{
                                caseAccounts.add(acc);                                
                            }

                            if(!accountsToUpdate.containsKey(acc.Id)){
                                accountsToUpdate.put(acc.Id, acc);
                            }
                        }
                    }
                //}
            }

            if(caseAccounts.size() > 0){
                createCase(caseAccounts, newTier, annualSalesVolume, request.Id, request.Auto_Approve__c, request.CreatedById);
            }
        }
    }

    private void createCase(List<Account> caseAccounts, String tier, String annualSalesVolume, Id requestId, Boolean autoApproved, Id createdById){
        String sapIds = '';
        System.debug('***** createCase ');
        Integer count = 0;        

        //Fetching the assignment rules on case
        AssignmentRule AR = new AssignmentRule();
        AR = [select id from AssignmentRule where SobjectType = 'Case' and Active = true limit 1];

        //Creating the DMLOptions for "Assign using active assignment rules" checkbox
        Database.DMLOptions dmlOpts = new Database.DMLOptions();
        dmlOpts.assignmentRuleHeader.assignmentRuleId= AR.id;
        dmlOpts.EmailHeader.TriggerUserEmail = true;

        for(Account acc : caseAccounts){
            if(count == 0){
                sapIds = sapIds + acc.SAP_Account_ID__c; 
                count = 1;
            }
            else{
                sapIds = sapIds + ', ' + acc.SAP_Account_ID__c;
            }
        }

        String caseDesc = String.format('Please update the "Potential Annual Sales Volume" field to {0} for the following SAP account(s): {1}', new String[]{annualSalesVolume, sapIds});

        if(autoApproved){
            caseDesc += '\n\n' + 'NOTE: Auto approved because of Parent change, do not contact creator';
        }

        caseDesc += '\n\n' + String.format('Change Reqeust: {0}{1}', new String[]{URL.getSalesforceBaseUrl().toExternalForm() + '/', requestId});

        Id createdBy = autoApproved ? Common_Variables__c.getInstance('Integration User').Content__c : createdById;

        Case newCase = CommonUtils.createCase('Submitted','SAP Tier Update',caseDesc, '0123A000001O8qfQAC','General Administration', createdBy);
        
        if(newCase != null){
            System.debug('***** Insert Case');
            newCase.setOptions(dmlOpts);
            insert newCase;
        }
        else{
            //CommonUtils.sendEmailMessage(new String[]{Common_Variables__c.getInstance('Group Email').Content__c}, )
        }
    }
}