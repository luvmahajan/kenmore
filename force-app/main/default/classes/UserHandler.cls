public class UserHandler implements ITrigger {
    Map<Id,List<Task>> taskMap = new MAP<Id,List<Task>>();
    MAP<Id,List<Account>> accMap = new MAP<Id,List<Account>>();
    MAP<Id, List<Lead>> leadMap = new MAP<Id, List<Lead>>();
    Map<String,String> accToUpdate = new Map<String, String>();
    Map<String,String>  taskToUpdate = new Map<String,String> ();
    Map<String,String>  leadToUpdate = new Map<String,String> ();

    public UserHandler(){
        
    }

    public void bulkBefore(){
        
    }

    public void bulkAfter(){   
        if(!Trigger.isDelete){
            List<Id> inactiveUserIds = new List<Id>();
            For( User user :(List<User>)Trigger.new){                
                if(!user.IsActive){
                    inactiveUserIds.add(user.Id);
                }
            }
            
            if(inactiveUserIds.size() > 0){
                populateUserData(inactiveUserIds);
                List<UserTerritory2Association> result = [SELECT Id FROM UserTerritory2Association WHERE UserId IN :inactiveUserIds AND IsActive = true];

                if(result != null && result.size() > 0){
                    TerritoryUtils.removeTerritoryAssociation(result);
                }
            }
        }
    }

    public void beforeInsert(Sobject obj){
        
    }

    public void beforeUpdate(Sobject oldObj, Sobject newObj){

    }

    public  void beforeDelete(Sobject obj){

    }

    public void afterInsert(Sobject obj){
        User userRecord = (User)obj;
                System.debug('afterInsert userhandler' );
  //     updateBackpage(userRecord);
       updateBackpage(userRecord.Id, userRecord.FirstName, userRecord.LastName, userRecord.Title, userRecord.Email, userRecord.Phone );
    }

@future(callout = true)
    private static void updateBackpage(String usr_Id, String usr_FirstName, String usr_LastName, String usr_Title, String usr_Email, String usr_Phone ){
                System.debug('updateBackpage userhandler' );
             //   System.debug('usr--> ' + usr);
                System.debug('usr_Id--> ' + usr_Id);
                System.debug('usr_FirstName--> ' + usr_FirstName);
                System.debug('usr_LastName--> ' + usr_LastName);
                System.debug('usr_Title--> ' + usr_Title);
                System.debug('usr_Email--> ' + usr_Email);
                System.debug('usr_Phone--> ' + usr_Phone);
        
        String usr_Name = usr_FirstName + ' ' + usr_LastName;
                System.debug('usr_Name--> ' + usr_Name);
        
            if(usr_Name!=null){
        PageReference pdf = Page.UserBackPage;
        pdf.getParameters().put('id',usr_Id);
        
    
            Document doc = new Document();
            Blob body;      
                if(!Test.isRunningTest()){
            body = pdf.getContentAsPDF(); 
                }
            doc.Body = body;
            doc.Name = usr_Name.toUpperCase();
                  string  sysnow = String.valueOf(system.now()).remove(' ').remove('-').remove(':');
            string ran = String.valueOf(Math.mod(Math.round(Math.random()*100+1),100));
                system.debug('USER_' + sysnow + '_' + ran + '_' + usr_Name.toUpperCase().replace(' ','_').replace('-','_').remove('(').remove(')').remove('\''));
            doc.DeveloperName = 'USER_' + sysnow + '_' + ran + '_' + usr_Name.toUpperCase().replace(' ','_').replace('-','_').remove('(').remove(')').remove('\'');
            doc.FolderId = '00l3A000003YY7iQAG';
            doc.ContentType = 'application/pdf';
            doc.Type = 'pdf';
            insert doc;
                System.debug('doc--> ' + doc);
                
                List<Document> qDoc = new List<Document>();
                qDoc = [SELECT Id, Name 
                        FROM Document 
                        WHERE Name =: usr_Name AND Id!=:doc.Id
                       // LIMIT 1
                       ];
                System.debug('qDoc--> ' + qDoc);
                
                if(qDoc.size()>0){
                    
                    List<SBQQ__RelatedContent__c> lstContent = new List<SBQQ__RelatedContent__c>();
                    lstContent = [SELECT Id, Name, SBQQ__ExternalId__c FROM SBQQ__RelatedContent__c WHERE SBQQ__ExternalId__c =: qDoc[0].Id ];
                    for(SBQQ__RelatedContent__c cn:lstContent){
                        cn.SBQQ__ExternalId__c = doc.Id;
                        cn.Name = doc.Name;
                    }
                    
                    update lstContent;
                    
                    delete qDoc;
                }
                
                
            }
        
    }

    
    public void afterUpdate(Sobject oldObj, Sobject newObj){
        User userRecord = (User)newObj;
        User oldRecord = (User)oldObj;

        if(String.isNotEmpty(userRecord.ProfileId) && userRecord.ProfileId == Common_Variables__c.getInstance('Account Manager Profile Id').Content__c && oldRecord.IsActive != userRecord.IsActive && !userRecord.IsActive){
            
            if(userRecord.ManagerId != null){
                Id managerId = userRecord.ManagerId;
                if(accMap.size() > 0){
                    for(Account userAccount : accMap.get(userRecord.Id)){
                        if(managerId != userAccount.OwnerId){
                            accToUpdate.put(userAccount.Id, managerId);
                        }
                    }
                }
                if(taskMap.size() > 0){
                    for(Task userTask : taskMap.get(userRecord.Id)){
                        if(managerId != userTask.OwnerId){
                            taskToUpdate.put(userTask.Id, managerId);
                        }
                    }
                }
                if(leadMap.size() > 0){
                    for(Lead userLead : leadMap.get(userRecord.Id)){
                        if(managerId != userLead.OwnerId){
                            leadToUpdate.put(userLead.Id, managerId);
                        }
                    }
                }
            }
        }
                System.debug('afterUpdate1 userhandler' );
        if(userRecord.Name != oldRecord.Name || userRecord.Title != oldRecord.Title 
           || userRecord.Email != oldRecord.Email || userRecord.Phone != oldRecord.Phone 
          ){
                System.debug('afterUpdate2 userhandler' );
        //      updateBackpage(userRecord);
                if(!Test.isRunningTest()){
              updateBackpage(userRecord.Id, userRecord.FirstName, userRecord.LastName, userRecord.Title, userRecord.Email, userRecord.Phone );
                }
                }
        
    }

    public void afterDelete(Sobject obj){

    }

    public void andFinally(){
        if(accToUpdate.size() > 0){
            updateNonSetupObject(accToUpdate, 'Account');
        }
        if(leadToUpdate.size() > 0){
            updateNonSetupObject(leadToUpdate, 'Lead');
        }
        if(taskToUpdate.size() > 0){
            updateNonSetupObject(taskToUpdate, 'Task');
        }
    }

    //***************************Helper Methods******************************
    private void populateUserData(List<Id> inactiveUserIds){
        Id accRecordType = [SELECT Id FROM RecordType WHERE SobjectType = 'Account' AND Name = 'Commercial Prospect' LIMIT 1].Id;
        List<Account> nonSAPAccounts = [SELECT Id, OwnerId FROM Account WHERE RecordTypeId = :accRecordType AND OwnerId IN :inactiveUserIds ORDER BY OwnerId];
        List<Task> openTasks = [SELECT Id, OwnerId FROM Task WHERE OwnerId IN :inactiveUserIds AND IsClosed = false];
        List<Lead> leads = [SELECT Id, OwnerId FROM Lead WHERE OwnerId IN :inactiveUserIds AND IsConverted = false];

        for(Id userId : inactiveUserIds){           
            List<Account> userAccs = new List<Account>();
            for(Account acc : nonSAPAccounts){
                if(userId == acc.OwnerId){
                    userAccs.add(acc);
                }
            }

            List<Lead> userLeads = new List<Lead>();
            for(Lead lead : leads){
                if(userId == lead.OwnerId){                    
                    userLeads.add(lead);
                }
            }

            List<Task> userTasks = new List<Task>();
            for(Task task : openTasks){
                if(userId == task.OwnerId){                    
                    userTasks.add(task);
                }
            }

            if(userAccs.size() > 0){
                accMap.put(userId, userAccs);
            }
            if(userTasks.size() > 0){
                taskMap.put(userId, userTasks);
            }
            if(userLeads.size() > 0){
                leadMap.put(userId, userLeads);
            }
        }
    }

    @future
    private static void updateNonSetupObject(Map<String, String> objMap, String type){
        if(type == 'Task'){
            List<Task> tasks = [SELECT Id, OwnerId FROM Task WHERE Id IN :objMap.keySet()];
            List<Task> tasksToUpdate = new List<Task>();

            for(Task userTask :tasks){
                if(objMap.get(userTask.Id) != NULL){
                    userTask.OwnerId = objMap.get(userTask.Id);
                    userTask.Automation_Control__c = CommonUtils.getAutomationControl();
                    userTask.Automation_Control_Type__c = CommonUtils.getAutomationControlTypes(true,true,true);
                    tasksToUpdate.add(userTask);
                }
            }

            if(tasksToUpdate.size() > 0){
                update tasksToUpdate;
            }
        }
        else if(type == 'Lead'){
            List<Lead> leads = [SELECT Id, OwnerId FROM Lead WHERE Id IN :objMap.keySet()];
            List<Lead> leadsToUpdate = new List<Lead>();

            for(Lead userLead :leads){
                if(objMap.get(userLead.Id) != NULL){
                    userLead.Automation_Control__c = CommonUtils.getAutomationControl();
                    userLead.Automation_Control_Type__c = CommonUtils.getAutomationControlTypes(true,true,true);
                    userLead.OwnerId = objMap.get(userLead.Id);
                    leadsToUpdate.add(userLead);
                }
            }

            if(leadsToUpdate.size() > 0){
                update leadsToUpdate;
            }
        }
        else if(type == 'Account'){
            List<Account> accs = [SELECT Id, OwnerId FROM Account WHERE Id IN :objMap.keySet()];
            List<Account> accsToUpdate = new List<Account>();

            for(Account userAcc :accs){
                if(objMap.get(userAcc.Id) != NULL){
                    userAcc.OwnerId = objMap.get(userAcc.Id);
                    userAcc.Automation_Control__c = CommonUtils.getAutomationControl();
                    userAcc.Automation_Control_Type__c = CommonUtils.getAutomationControlTypes(true,true,true);
                    accsToUpdate.add(userAcc);
                }
            }

            if(accsToUpdate.size() > 0){
                update accsToUpdate;
            }
        }
    }
    
    
}