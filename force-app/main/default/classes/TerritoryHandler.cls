public without sharing class TerritoryHandler implements ITrigger {/*
    List<Territory__c> territoriesToDelete = new List<Territory__c>();
    List<Territory__c> territoryCache = new List<Territory__c>();   
    List<String> territoryUsers = new List<String>();
    List<String> territoryManagerNames = new List<String>();
    MAP<String, User> territoryManagerCache = new MAP<String, User>();
    MAP<String,User> territoryUserCache = new MAP<String,User>();
    Map<String, User> usersToUpdate = new Map<String, User>();
    //Tests failed since i create all data dynamically and the query never pulled records to delete. So i adjust the search date depending on what mode we're in.
    Datetime dt = Test.isRunningTest() ? Datetime.now().addMinutes(2) : Datetime.now().addMinutes(-2);
    Map<String, Id> EnterpriseIdUserIdMap = new Map<String, Id>();
    Map<String, Id> DistrictManagerUserIdMap = new Map<String, Id>();
    List<Territory_Exception__c> TerritoryExceptions = Territory_Exception__c.getall().values();
*/
    public TerritoryHandler() {     
    }

    public void bulkBefore(){/*
        if(!Trigger.isDelete){ 
            territoryCache  = [SELECT Id, CreatedDate FROM Territory__c WHERE CreatedDate < :dt ];

            for (User user : [SELECT Id, Sears_Enterprise_Id__c, Name, Upper_Name__c  FROM User WHERE UserType = 'Standard' AND IsActive = True ORDER BY IsActive DESC]) {
                if(!String.isBlank(user.Sears_Enterprise_id__c)) {
                    EnterpriseIdUserIdMap.put(user.Sears_Enterprise_Id__c, user.Id);
                }
                DistrictManagerUserIdMap.put(user.Upper_Name__c, user.Id);
            }
        }*/
    }

    public void bulkAfter(){  /* 
        if(!Trigger.isDelete){ 
            for (territory__c newterr : (List<Territory__c>)Trigger.new) {
                territoryUsers.add(newterr.SFDC_USER_ID__c);
                territoryManagerNames.add(newterr.District_Manager_Name_Short__c);
            }
            
            for(User user :[SELECT Id, Territory_ID__c, Territory_Name__c, District_Territory_ID__c, District_Name__c, Region__c, Region_Name__c, DISTRICT_MGR_NO__c, DISTRICT_MGR_NAME__c, SEARCH_TERM1__c FROM User WHERE id IN :territoryUsers]){
                territoryUserCache.put(user.Id, user);
            }

            for(User manager :[SELECT Id, Name FROM User WHERE Name IN :territoryManagerNames]){                
                territoryManagerCache.put(manager.Name.toLowerCase(), manager);
            }

            System.debug('***** Managers: ' + territoryManagerCache.values());
        }*/
    }

    public void beforeInsert(Sobject obj){
   //     territoriesToDelete = territoryCache;
   //     updateSFDCUserId((Territory__c)obj);
    }

    public void beforeUpdate(Sobject oldObj, Sobject newObj){
  //      updateSFDCUserId((Territory__c)newObj);
    }

    public  void beforeDelete(Sobject obj){

    }

    public void afterInsert(Sobject obj){
  //      Territory__c territoryObj = (Territory__c)obj;
  //      updateTerritoryIDforUser(territoryObj);
  //      updateManager(territoryObj);
    }

    public void afterUpdate(Sobject oldObj, Sobject newObj){
   //     Territory__c territoryObj = (Territory__c)newObj;
   //     updateTerritoryIDforUser(territoryObj);
   //     updateManager(territoryObj);
    }

    public void afterDelete(Sobject obj){

    }

    public void andFinally(){/*
        try{
            if(territoriesToDelete.size() > 0){
                delete territoriesToDelete;
            }
            if (usersToUpdate.size() > 0) {
                update usersToUpdate.values();
                System.debug('***** updating: ' + usersToUpdate.values());
            }
        }
        catch(DmlException de){
            System.debug(de);
        }
        catch(Exception e){
            System.debug(e);
        }*/
    }

/*
    // ***************************Helper Methods******************************
    private void updateTerritoryIDforUser(Territory__c territory){
        //System.debug('***** Start updateTerritoryIDforUser()');
        if(territoryUserCache.containskey(territory.SFDC_USER_ID__c)){
            User user = territoryUserCache.get(territory.SFDC_USER_ID__c);
            //System.debug('***** Updating Territory for User: ' + user.Id);
            user.Territory_ID__c = territory.Territory_ID__c;
            user.Territory_Name__c = territory.Name;
            user.District_Territory_ID__c = territory.District_Territory_ID__c;
            user.District_Name__c = territory.District_Name__c;
            user.Region__c = territory.Region_Territory_ID__c;
            user.Region_Name__c = territory.Region_Name__c;
            user.DISTRICT_MGR_NO__c = territory.District_Manager_Number__c;
            user.DISTRICT_MGR_NAME__c = territory.District_Manager_Name__c;
            user.SEARCH_TERM1__c = territory.Search_Term1__c;
            usersToUpdate.put(user.Id, user);
        }       
        //System.debug('***** End updateTerritoryIDforUser()');
    }
    //before insert, before update
    private void updateSFDCUserId(territory__c territory){
        System.debug('***** tenterprise: ' + territory.Enterprise_ID__c);
        if (EnterpriseIdUserIdMap.containskey(territory.Enterprise_ID__c)) {
            territory.SFDC_User_ID__c = EnterpriseIdUserIdMap.get(territory.Enterprise_ID__c);
            System.debug('***** updatesfdcuserid ' + EnterpriseIdUserIdMap.get(territory.Enterprise_ID__c));
        } 
        else if (DistrictManagerUserIdMap.containskey(territory.Upper_District_short_name__c)) {
            territory.SFDC_User_ID__c = DistrictManagerUserIdMap.get(territory.Upper_District_short_name__c);
        }
        else {
          for(Territory_Exception__c te: TerritoryExceptions) {
            if(territory.get(te.Field__c) == te.Value__c) {
              territory.SFDC_USER_ID__c = te.User_Id__c;
            }
            }
        }
    }

    private void updateManager(Territory__c territory){
        System.debug('***** updateManager() start');
        if(String.isNotBlank(territory.District_Manager_Name_Short__c) && territoryManagerCache.containskey(territory.District_Manager_Name_Short__c.toLowerCase())){           
            User manager = territoryManagerCache.get(territory.District_Manager_Name_Short__c.toLowerCase());
            System.debug('***** manager found: ' + territory.District_Manager_Name_Short__c);
            if(String.isNotBlank(territory.SFDC_USER_ID__c) && territoryUserCache.containskey(territory.SFDC_USER_ID__c)){
                User user = territoryUserCache.get(territory.SFDC_USER_ID__c);
                if(territory.SFDC_USER_ID__c == user.Id){
                    if(user.ManagerId != manager.Id && user.Id != manager.Id && !territory.District_Name__c.containsIgnoreCase('Inside Sales')){
                        if(usersToUpdate.containsKey(user.Id)){
                            //National accounts have a different manager in Salesforce than SAP, skip normal process and auto assign the current manager by using a Labal
                            //The label can be updated on the fly through the normail SF UI
                            usersToUpdate.get(user.Id).ManagerId = territory.District_Name__c.containsIgnoreCase('National Accounts') ? System.Label.National_Account_DM : manager.Id;
                        }
                        else{
                            user.ManagerId = territory.District_Name__c.containsIgnoreCase('National Accounts') ? System.Label.National_Account_DM : manager.Id;
                            usersToUpdate.put(user.Id, user);
                        }
                        
                    }
                }
            }
        }
    }*/
}