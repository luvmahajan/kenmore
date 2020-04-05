trigger SalesOrderHeaderAddAccountRefTrigger on Sales_Order_Header__c (before insert) {

    List<Sales_Order_Header__c> SOHList = new List<Sales_Order_Header__c>();
    List<String> SAPAccountIds = new List<String>();
    List<String> OldSAPAccountIds = new List<String>();
    Map<String,Id> accounts = new Map<String,Id>();

    //Build list of SOH records to update with Account Ids
    for (Sales_Order_Header__c soh : Trigger.new) {
        if(!String.isBlank(soh.Bill_To__c)) {
            SOHList.add(soh);
            SAPAccountIds.add('00' + soh.Bill_To__c);
            OldSAPAccountIds.add(soh.Bill_To__c);

        }
    }     

    //Get all accounts that have a matching SAP Id in the SOH records
    if(!SOHList.isEmpty() && !SAPAccountIds.isEmpty()) {
        for(Account account :[SELECT Id, SAP_Account_ID__c FROM Account WHERE (SAP_Account_ID__c IN :SAPAccountIds OR SAP_Account_ID__c IN :OldSAPAccountIds )AND SAP_Account_ID__c != null AND SAP_Account_ID__c != '']){
            accounts.put(account.SAP_Account_ID__c, account.Id);
        }
        //Update all SOH records with the proper Account Id
        if(!accounts.isEmpty()) {
            for (Sales_Order_Header__c soh : Trigger.new) {
                if(!String.isBlank(soh.Bill_To__c) && accounts.containskey('00'+soh.Bill_To__c)) {
                    soh.Account__c = accounts.get('00'+soh.Bill_To__c);
                }
                else if(!String.isBlank(soh.Bill_To__c) && accounts.containskey(soh.Bill_To__c)) {
                    soh.Account__c = accounts.get(soh.Bill_To__c);
                }
            }
        }
    }   

}