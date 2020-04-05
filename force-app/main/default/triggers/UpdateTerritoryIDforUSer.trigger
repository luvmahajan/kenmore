trigger UpdateTerritoryIDforUSer on Territory__c(after insert, after update) {
    /*-----------------------
    List<User> users = new List<User>();
    Map<String,Territory__c> UserTerritories = new Map<String,Territory__c>();
    Map<String, String> sfdcId = new Map<String, String>();
    //Map<String,String> sfdcId = new Map<String,String>();

    for (territory__c newterr : Trigger.new) {
        sfdcId.put(newterr.SFDC_USER_ID__c, newterr.Territory_ID__c);
        UserTerritories.put(newterr.SFDC_USER_ID__c, newterr);
    }

    for (User user : [SELECT Id, Territory_ID__c, Territory_Name__c, District_Territory_ID__c, District_Name__c, Region__c, Region_Name__c, DISTRICT_MGR_NO__c, DISTRICT_MGR_NAME__c, SEARCH_TERM1__c FROM User WHERE id IN : UserTerritories.keyset()]) {
        if (UserTerritories.containskey(user.Id)) {
            user.Territory_ID__c = UserTerritories.get(user.Id).Territory_ID__c;
            user.Territory_Name__c = UserTerritories.get(user.Id).Name;
            user.District_Territory_ID__c = UserTerritories.get(user.Id).District_Territory_ID__c;
            user.District_Name__c = UserTerritories.get(user.Id).District_Name__c;
            user.Region__c = UserTerritories.get(user.Id).Region_Territory_ID__c;
            user.Region_Name__c = UserTerritories.get(user.Id).Region_Name__c;
            user.DISTRICT_MGR_NO__c = UserTerritories.get(user.Id).District_Manager_Number__c;
            user.DISTRICT_MGR_NAME__c = UserTerritories.get(user.Id).District_Manager_Name__c;
            user.SEARCH_TERM1__c = UserTerritories.get(user.Id).Search_Term1__c;
            users.add(user);
        }

    }
    if (users.size() > 0) {
        update users;
    }
    --------------*/
}