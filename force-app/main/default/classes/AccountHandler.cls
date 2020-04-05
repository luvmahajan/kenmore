public without sharing class AccountHandler implements ITrigger {
    List<string> sapcode = new List<string>();
    List<string> accountIds = new List<String>();
    List<string> accOwnerChanged = new List<String>();
    List<Change_Request__c> requestsToUpdate = new List<Change_Request__c>();
    List<Opportunity> oppsToUpdate = new List<Opportunity>();
    List<Contact> contactsToTupdate = new List<Contact>();
    MAP<String, Change_Request__c> changeRequestMap = new Map<String, Change_Request__c>();
    Map<string, Industry_Segment__c>  industrysegmentmap= new Map<string, Industry_Segment__c>();
    Map<Id,List<Opportunity>> oppMap = new Map<Id,List<Opportunity>>();
    Map<Id,List<Contact>> contactMap = new Map<Id,List<Contact>>();
    Map<String, String> postalCodeMap = new Map<String, String>();
    private Boolean isFirstRun;

    List<Territory__c> territories = new List<Territory__c>([SELECT Territory_Id__c, SFDC_User_Id__c FROM Territory__c]);
    Id CommercialCustomerRecordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Commercial Customer').getRecordTypeId();
    Id CommericalProspectRecordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Commercial Prospect').getRecordTypeId();
    Id HomeServicesRecordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Home Services').getRecordTypeId();
    private static final Id sysAdminId = [select Id from Profile where Name = 'System Administrator'].Id;
    private static final Id integrationId = [select Id from Profile where Name = 'Integration'].Id;

	// *** JEEVANA START
	Map<String, List<Task>> accTasks = new Map<String, List<Task>>();
	List<Task> tasksToUpdate = new List<Task>();
	// *** JEEVANA END
    public AccountHandler(){
    }

    public void bulkBefore(){
        isFirstRun = CommonUtils.isFirstRun('Account');
        System.debug('***** Account Trigger Ran');
        if(!Trigger.isDelete){
            if(isFirstRun){
                List<String> postalCodes = new List<String>();
                For( Account newAcc :(List<Account>)Trigger.new){
                    Sapcode.add( newAcc.SAP_NAICS_Code__C);
                    if(String.isNotBlank(newAcc.BillingPostalCode)){
                        postalCodes.add(newAcc.BillingPostalCode.Trim().Left(5));
                        System.debug('*****' + newAcc.BillingPostalCode);
                    }
                }
                System.debug('*****zip list ' + postalCodes.size());
                //If(sapcode.Size()>0){
                //    For(Industry_Segment__c NewIds :[SELECT ID, Business_Sector__c,SAP_NAICS_Code__c FROM Industry_segment__c WHERE SAP_NAICS_Code__c IN: sapcode]){
                //        industrysegmentmap.put(NewIds.SAP_NAICS_Code__c,NewIds);
                //   } 
                //}

               postalCodeMap = TerritoryUtils.getDistrictMapping(postalCodes);
               System.debug('***** map size ' + postalCodeMap.size());
            }
        }
    }

    public void bulkAfter(){   
        if(!Trigger.isDelete){
             For( Account newAcc :(List<Account>)Trigger.new){
                    accountIds.add( newAcc.Id);
                    if(Trigger.isUpdate){
                        For(Account oldAcc :(List<Account>)Trigger.old){
                        //if we are changing ownership, add to list for related object search
                        if(oldAcc.OwnerId != newAcc.OwnerId){
                            accOwnerChanged.add(oldAcc.Id);
                        }
                    }
                }
            }
            

            List<Change_Request__c> changeRequests = [SELECT Account_SAP_ID__c,Account_Name__c,Account_SFDC_ID__c,Current_Request__c,Id,Name,New_Account_Name__c,New_Account_Owner__c,New_Business_Sector__c,
                                    New_City__c,New_Country__c,New_Customer_Group__c,New_Customer_Price_Procedure__c,New_Email__c,New_Industry_Sector__c,New_Industry_Segment__c,
                                    New_NAICS_Code__c,New_Parent_Account_Name__c,New_Payment_Term__c,New_Postal_Code__c,New_Potential_Annual_Sales_Volume__c,New_Price_Group__c,
                                    New_Price_List_Type__c,New_Region__c,New_Street__c,New_Telephone__c,New_Territory_Id__c 
                                    FROM Change_Request__c WHERE Current_Request__c = true AND Account_Name__c in :accountIds];
            if(changeRequests.size() > 0){
                for(Change_Request__c reqeust : changeRequests){
                    System.debug('***** request name' + reqeust.Account_Name__c);
                    changeRequestMap.put(reqeust.Account_Name__c, reqeust);
                }
            }

            if(accOwnerChanged != null && accOwnerChanged.size() > 0){
                List<Opportunity> accOpps = [SELECT AccountId, Id, OwnerId FROM Opportunity WHERE AccountId IN :accOwnerChanged AND IsClosed = false];                
                List<Contact> accContacts= [SELECT Id, OwnerId, AccountId FROM Contact WHERE AccountId IN :accOwnerChanged AND IsDeleted = false];

                System.debug('***** Opp Size:' + accOpps.size());
                for(Opportunity opp :accOpps){
                    if(!oppMap.containsKey(opp.AccountId)){
                        System.debug('***** oppMap updated');
                        oppMap.put(opp.AccountId, new List<Opportunity>());
                    }

                    oppMap.get(opp.AccountId).add(opp);
                }
                for(Contact contact :accContacts){
                    if(!contactMap.containsKey(contact.AccountId)){
                        contactMap.put(contact.AccountId, new List<Contact>());
                    }

                    contactMap.get(contact.AccountId).add(contact);
                }
            }
            

        }
        
      // *** JEEVANA START 01
     if(!Trigger.isDelete){
         if(Trigger.isUpdate){
             List<Id> accId = new List<Id>();
             Map<Id, Id> mapAccoutOwners = new Map<Id, Id>();

             For( Account newacc :(List<Account>)Trigger.new){
                 accId.add(newacc.Id);
                 mapAccoutOwners.put(newacc.Id, newacc.OwnerId);
             }

             //tasksToUpdate = CommonUtils.updateTaskOwner(accId, Account.sObjecttype, mapAccoutOwners);

            }

         }

            // *** JEEVANA END
    }

    public void beforeInsert(Sobject obj){
        Account newObject = (Account)obj;
        
        if(newObject.ParentId == null){
            if(newObject.Delivery_Charge_First__c == null){
            	newObject.Delivery_Charge_First__c = 79;
            }
            if(newObject.Delivery_Charge_Subsequent__c == null){
            	newObject.Delivery_Charge_Subsequent__c = 25;
            }
        }

        if(newObject.BillingCountry != 'US'){
            newObject.BillingCountry = 'US';
        }

        // SCO Account Creation
        if(newObject.SCO_Account_ID__c==null ||  newObject.SCO_Account_ID__c=='' || newObject.SCO_Account_ID__c=='Processing' ){
                newObject.Create_SCO_Account__c = true;
                newObject.SCO_Account_ID__c = 'Processing';
        }
        
        //NAICS Code
        if(String.isNotBlank(newObject.Industry)){
            newObject.SAP_NAICS_Code__c = CommonUtils.getNAICSCode(newObject.Industry);            
        }

        if(newObject.RecordTypeId != HomeServicesRecordTypeId) {
            for(Territory__c territory : territories) {
                if(territory.SFDC_USER_ID__c == newObject.OwnerId) {
                    newObject.Territory_ID__c = territory.Territory_ID__c;
                }
            }

            //Territory Assignment
            if(String.isNotBlank(newObject.BillingPostalCode) && postalCodeMap.containsKey(newObject.BillingPostalCode.Trim().Left(5))){
                System.debug('***** Insert Territory__c');
                newObject.Territory__c = postalCodeMap.get(newObject.BillingPostalCode.Trim().Left(5));
            }

            if(String.isBlank(newObject.Potential_Annual_Sales_Volume__c)){
                newObject.Potential_Annual_Sales_Volume__c = 'D';
                newObject.Pricing_Tier__c = 'Bronze';
            }
        }
    }

    public void beforeUpdate(Sobject oldObj, Sobject newObj){
        Account newObject = (Account)newObj;
        Account oldObject = (Account)oldObj;
        
        if(newObject.ParentId != oldObject.ParentId){
            if(newObject.ParentId == null){
                if(newObject.Delivery_Charge_First__c == null){
                    newObject.Delivery_Charge_First__c = 79;
                }
                if(newObject.Delivery_Charge_Subsequent__c == null){
                    newObject.Delivery_Charge_Subsequent__c = 25;
                }
            }else{
                newObject.Delivery_Charge_First__c = null;
                newObject.Delivery_Charge_Subsequent__c = null;
            }
        }else{
            if(newObject.ParentId == null){
                if(newObject.Delivery_Charge_First__c == null){
                    newObject.Delivery_Charge_First__c = 79;
                }
                if(newObject.Delivery_Charge_Subsequent__c == null){
                    newObject.Delivery_Charge_Subsequent__c = 25;
                }
            }
        }
        
        
        //NAICS Code
        if(String.isNotBlank(newObject.Industry) && newObject.Industry != oldObject.Industry && (String.isBlank(newObject.SAP_Account_ID__c) || !newObject.SAP_Account_ID__c.startsWith('001'))){
            newObject.SAP_NAICS_Code__c = CommonUtils.getNAICSCode(newObject.Industry);            
        }
        else if(String.isNotBlank(newObject.SAP_NAICS_Code__c) && newObject.SAP_NAICS_Code__c != oldObject.SAP_NAICS_Code__c && String.isNotBlank(newObject.SAP_Account_ID__c) && newObject.SAP_Account_ID__c.startsWith('001')){
            newObject.Industry_Segmentation__c = CommonUtils.getIndustry(newObject.SAP_NAICS_Code__c);
        }

        if(isFirstRun){ 
            
            //If(!String.isBlank(newObject.SAP_Account_ID__c)){      
            //    If(industrysegmentmap.containskey(newObject.SAP_NAICS_Code__c)){
            //        newObject.Industry_Segment__c = industrysegmentmap.get(newObject.SAP_NAICS_Code__c).Id;
            //        newObject.Business_Sector__c = industrysegmentmap.get(newObject.SAP_NAICS_Code__c).Business_Sector__c;
            //    }
            //} 

            if(newObject.BillingCountry != 'US'){
                newObject.BillingCountry = 'US';
            }     
            
            if(String.isNotBlank(newObject.BillingPostalCode) && newObject.BillingPostalCode != oldObject.BillingPostalCode && postalCodeMap.containsKey(newObject.BillingPostalCode.Trim().Left(5))){ 
                System.debug('***** Update Territory__c');               
                newObject.Territory__c = postalCodeMap.get(newObject.BillingPostalCode.Trim().Left(5));
            }

            if(String.isNotBlank(newObject.Potential_Annual_Sales_Volume__c)){
                newObject.Pricing_Tier__c = newObject.Potential_Annual_Sales_Volume__c == 'C' ? 'Silver' : newObject.Potential_Annual_Sales_Volume__c == 'B' ? 'Gold' : newObject.Potential_Annual_Sales_Volume__c == 'A' ? 'Platinum' : 'Bronze';
            }

        //    if(String.isNotBlank(newObject.SCO_Account_ID__c) && String.isNotBlank(oldObject.SCO_Account_ID__c) &&  newObject.SCO_Account_ID__c != oldObject.SCO_Account_ID__c){
        //        newObject.Merged_SCO_Account_Id__c = newObject.SCO_Account_ID__c;
        //        newObject.SCO_Account_ID__c = oldObject.SCO_Account_ID__c;
        //    }

            updateTerritoryOwner(newObject);
        }
    }

    public  void beforeDelete(Sobject obj){
        
    }

    public void afterInsert(Sobject obj){
        
    }

    public void afterUpdate(Sobject oldObj, Sobject newObj){
        if((UserInfo.getProfileId() == sysAdminId || UserInfo.getProfileId() == integrationId) && changeRequestMap.size() > 0){            
            System.debug('***** changeRequests: ' + changeRequestMap.size());
            changeRequestDeactivation((Account)newObj);
        }
        
        reassignOpps((Account)oldObj, (Account)newObj);        
    }

    public void afterDelete(Sobject obj){

    }

    public void andFinally(){
        System.debug('***** size to update: ' + requestsToUpdate.size());
        if(requestsToUpdate.size() > 0){
            update requestsToUpdate;
        }
        if(oppsToUpdate.size() > 0){
            update oppsToUpdate;
        }
        if(contactsToTupdate.size() > 0){
            update contactsToTupdate;
        }
         //**** JEEVANA START
        if(tasksToUpdate.size() > 0){
            update tasksToUpdate;
        }
         //**** JEEVANA END
    }

    //***************************Helper Methods******************************
    private void updateTerritoryOwner(Account account){
        System.debug('*****Else If Update Started*******  ');                
        if(account.RecordTypeId == CommercialCustomerRecordTypeId) {
            for(Territory__c territory : territories) {
                if(account.Territory_ID__c == territory.Territory_ID__c) {
                    if(String.isNotBlank(territory.SFDC_USER_ID__c)){
                        System.debug('*****ACCOUNT OWNER UPDATE *******  ' + territory.Territory_ID__c + '  - ' + territory.SFDC_USER_ID__c);
                   //     account.OwnerId = territory.SFDC_USER_ID__c;
                    }
                    break;
                }  
            }
        }
        else if (account.RecordTypeId == CommericalProspectRecordTypeId) {
            for(Territory__c territory : territories) {
                if(account.OwnerId == territory.SFDC_USER_ID__c) {
                    System.debug('*****ACCOUNT OWNER UPDATE *******  ' + territory.Territory_ID__c + '  - ' + territory.SFDC_USER_ID__c);
                    account.Territory_ID__c = territory.Territory_ID__c;
                    break;
                }
            }
        }
    }

    private void changeRequestDeactivation(Account account){
        if(changeRequestMap.containskey(account.Id)){
            System.debug('****** found reqeust');
            Change_Request__c request = changeRequestMap.get(account.Id);
            Boolean needsUpdate = false;
            Boolean noError = true;

            Integer result = checkChangeRequestFields(request.New_Territory_Id__c, account.Territory_ID__c);
            if( result == 1){
                noError = false;
            }
            else if(result == 0){
                needsUpdate = true;
            }

            result = checkChangeRequestFields(request.New_Potential_Annual_Sales_Volume__c, account.Potential_Annual_Sales_Volume__c);
            if( result == 1){
                noError = false;
            }
            else if(result == 0){
                needsUpdate = true;
            }

            if(needsUpdate && noError){
                request.Current_Request__c = false;
                requestsToUpdate.add(request);
                System.debug('***** added request');
           }
        }
    }

    private Integer checkChangeRequestFields(String requestField, String accountField){
        if(String.isNotBlank(requestField)){
            if(requestField == accountField){
                return 0;
            }
            return 1;
        }

        return 2;
    }

    private void reassignOpps(Account oldAcc, Account newAcc){
        if(oldAcc.OwnerId != null && oldAcc.OwnerId != newAcc.OwnerId){
            System.debug('***** Owner Changed');
            List<Opportunity> oppList = oppMap.get(newAcc.Id);
            List<Contact> contactList = contactMap.get(newAcc.Id);

            if(oppList != NULL && oppList.size() > 0){
                for(Opportunity opp :oppList){
                    if(opp.OwnerId != newAcc.OwnerId){
                        opp.OwnerId = newAcc.OwnerId;
                        opp.Automation_Control__c = CommonUtils.getAutomationControl();
                        opp.Automation_Control_Type__c = CommonUtils.getAutomationControlTypes(true,true,true);

                        oppsToUpdate.add(opp);
                    }
                }
            }

            if(contactList != NULL && contactList.size() > 0){
                for(Contact contact :contactList){
                    if(contact.OwnerId != newAcc.OwnerId){
                        contact.OwnerId = newAcc.OwnerId;                    
                        contact.Automation_Control__c = CommonUtils.getAutomationControl();
                        contact.Automation_Control_Type__c = CommonUtils.getAutomationControlTypes(true,true,true);

                        contactsToTupdate.add(contact);
                    }
                }
            }
        }
    }
}