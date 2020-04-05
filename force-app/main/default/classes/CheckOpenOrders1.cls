global class CheckOpenOrders1 implements Database.Batchable<sObject>{
 
global Database.QueryLocator start(Database.BatchableContext BC){
return Database.getQueryLocator('SELECT id,Bill_To__c,Account__c FROM Sales_Order_Header__c WHERE Bill_To__c != NULL AND Bill_To__c != \'\' ');
}
 
global void execute(Database.BatchableContext BC,List<Sales_Order_Header__c> sOrder){
    List<String> salesSAP = new List<String>();
    List<Sales_Order_Header__c> soHead = new List<Sales_Order_Header__c>();
    Map<String,id> accSAP = new Map<String,id>();
        for(Sales_Order_Header__c sO :sOrder){
            salesSAP.add('00'+sO.Bill_To__c);
          
        }
        for(Account acc :[SELECT id,SAP_Account_ID__c FROM Account WHERE SAP_Account_ID__c IN :salesSAP AND SAP_Account_ID__c!= NULL AND SAP_Account_ID__c != ' ']){
            accSAP.put(acc.SAP_Account_ID__c,acc.id);
        }
        for(Sales_Order_Header__c sOH :sOrder){
            if(accSAP.containskey('00'+sOH.Bill_To__c)){
                sOH.Account__c = accSAP.get('00'+sOH.Bill_To__c);
                soHead .add(sOH);
            }
        }
        if(soHead.size() > 0){
        update soHead;
        }
}
global void finish(Database.BatchableContext BC){
 
}
}