Trigger UpdateSFDCUserID on territory__c (before insert, before update) {
/*-----------------------
  Map<String, Id> EnterpriseIdUserIdMap = new Map<String, Id>();
  Map<String, Id> DistrictManagerUserIdMap = new Map<String, Id>();
  List<Territory_Exception__c> TerritoryExceptions = Territory_Exception__c.getall().values();

  for (User user : [SELECT Id, Sears_Enterprise_Id__c, Name, Upper_Name__c  FROM User WHERE UserType = 'Standard' AND IsActive = True ORDER BY IsActive DESC]) {
    if(!String.isBlank(user.Sears_Enterprise_id__c)) {
      EnterpriseIdUserIdMap.put(user.Sears_Enterprise_Id__c, user.Id);
    }
    DistrictManagerUserIdMap.put(user.Upper_Name__c, user.Id);
  }

  for (territory__c territory : trigger.new) {
    if (EnterpriseIdUserIdMap.containskey(territory.Enterprise_ID__c)) {
      territory.SFDC_User_ID__c = EnterpriseIdUserIdMap.get(territory.Enterprise_ID__c);
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
  --------------*/
}