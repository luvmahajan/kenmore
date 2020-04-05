trigger LineOfBillingAddAccountRefTrigger on Line_Of_Billing__c (before insert) {

    List<Line_Of_Billing__c> LOBList = new List<Line_Of_Billing__c>();
	List<String> SAPAccountIds = new List<String>();
	List<String> OldSAPAccountIds = new List<String>();
	Map<String,Id> accounts = new Map<String,Id>();

	//Build list of LOB records to update with Account Ids
	for (Line_Of_Billing__c l : Trigger.new) {
	    if(!String.isBlank(l.Bill_To__c)) {
	    	LOBList.add(l);
	    	SAPAccountIds.add('00' + l.Bill_To__c);
	    	OldSAPAccountIds.add(l.Bill_To__c);
	    }
  	}     

  	//Get all accounts that have a matching SAP Id in the LOB records
  	if(!LOBList.isEmpty() && !SAPAccountIds.isEmpty()) {
	    for(Account account :[SELECT Id, SAP_Account_ID__c FROM Account WHERE (SAP_Account_ID__c IN :SAPAccountIds OR SAP_Account_ID__c IN :OldSAPAccountIds )AND SAP_Account_ID__c != null AND SAP_Account_ID__c != '']){
	        accounts.put(account.SAP_Account_ID__c, account.Id);
	    }

	    //Update all LOB records with the proper Account Id
	    if(!accounts.isEmpty()) {
		    for (Line_Of_Billing__c lob : Trigger.new) {
			    if(!String.isBlank(lob.Bill_To__c) && accounts.containskey('00'+lob.Bill_To__c)) {
			    	lob.Account__c = accounts.get('00'+lob.Bill_To__c);
			    }
			    else if(!String.isBlank(lob.Bill_To__c) && accounts.containskey(lob.Bill_To__c)) {
			    	lob.Account__c = accounts.get(lob.Bill_To__c);
			    }
		  	} 
	  	}
  	}   


}