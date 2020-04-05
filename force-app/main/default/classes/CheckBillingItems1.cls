global class CheckBillingItems1  implements Database.Batchable<sObject>{
 
global Database.QueryLocator start(Database.BatchableContext BC){
   
    //return Database.getQueryLocator('SELECT id,Bill_To__c, Account__c FROM Line_Of_Billing__c WHERE Bill_To__c != NULL AND Bill_To__c != \'\' AND  Account__c = \'\'');
    return Database.getQueryLocator('SELECT id,Bill_To__c, Account__c FROM Line_Of_Billing__c WHERE Bill_To__c != NULL AND Bill_To__c != \'\'');
}
 
global void execute(Database.BatchableContext BC, List<Line_Of_Billing__c> myItems){
        List<String> billingSAP = new List<String>();
        List<Line_Of_Billing__c> loBill = new List<Line_Of_Billing__c>();
                
        Map<String,id> accSAP = new Map<String,id>();
        for(Line_Of_Billing__c loB :myItems){
            billingSAP.add('00'+loB.Bill_To__c);
        }
        for(Account acc :[SELECT id,SAP_Account_ID__c FROM Account WHERE SAP_Account_ID__c IN :billingSAP AND SAP_Account_ID__c!= NULL AND SAP_Account_ID__c != '']){
            accSAP.put(acc.SAP_Account_ID__c,acc.id);
        }
        for(Line_Of_Billing__c loB1 :myItems){
            if(accSAP.containskey('00'+loB1.Bill_To__c)){
                loB1.Account__c = accSAP.get('00'+loB1.Bill_To__c);
                loBill.add(loB1);
            }
        }
        
        if(loBill.size() > 0){
        update loBill;
        }
   }
global void finish(Database.BatchableContext BC){
 
}
}