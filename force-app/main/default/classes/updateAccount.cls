global class updateAccount implements Database.Batchable<sObject>{
 
global Database.QueryLocator start(Database.BatchableContext BC){
return Database.getQueryLocator('SELECT Id,Territory_ID__c,SAP_Account_ID__c FROM Account where SAP_Account_ID__c!=NULL');
}
 
global void execute(Database.BatchableContext BC, List<Account> myAccs){
List<String> territoryIds = new List<String>();
//Map<String, Territory__c> tIdUIDMap = new Map<String, Territory__c>();
Map<String, Territory__c> terrmap = new Map<String, Territory__c>();
//Map<String, Territory__c> terDistName = new Map<String, Territory__c>();
//Map<String, User> sfdcID = new Map<String, User>();
//Map<String,User> userFirstName = new Map<String,User>();
List<Account> accToUpdate= new List<Account>();
for(Account acc : myAccs){
territoryIds.add(acc.Territory_ID__c);
}
List<Territory__c> allTerri = [SELECT Id,Territory_ID__c ,SFDC_USER_ID__c,District_Manager_Name_Short__c,Enterprise_ID__c,EID_length__c FROM Territory__c where Territory_ID__c IN :territoryIds];
for(Territory__c t : allTerri){
//tIdUIdmap.put(t.Enterprise_ID__c, t);
//terDistName.put(t.District_Manager_Name_Short__c,t);
terrmap.put(t.Territory_ID__c, t);
}

 for(Account acc : myAccs){
     if(terrmap.containskey(acc.Territory_ID__c)){
         acc.ownerID=terrmap.get(acc.Territory_ID__c).SFDC_USER_ID__c;
         accToUpdate.add(acc); 
     }
     
 }

 
 if(accToUpdate.size()> 0){
     //update accToUpdate;
 }
}
 
global void finish(Database.BatchableContext BC){
 
}
}