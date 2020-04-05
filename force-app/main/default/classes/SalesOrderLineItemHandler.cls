public class SalesOrderLineItemHandler implements ITrigger {
    private Map<String,Account> accountRecords = new Map<String,Account>();
    private Map<String,Account> accountsToUpdate = new Map<String,Account>();
    private Map<String,Sales_Order_Header__c> headerRecords = new Map<String, Sales_Order_Header__c>();
    private Map<String, Sales_Order_Header__c> headersToUpdate = new Map<String, Sales_Order_Header__c>();

    public SalesOrderLineItemHandler() {
        
    }

    public void bulkBefore(){

    }

    public void bulkAfter(){     
        if(!Trigger.isDelete){ 
            accountRecords = new Map<String,Account>();
            SET<String> accountIds = new SET<String>();
            List<Sales_Order_Header__c> headerIds = new List<Sales_Order_Header__c>();
            
            headerIds = [SELECT Id, Account__c, Requested_Delivery_Date__c FROM Sales_Order_Header__c WHERE Id IN (SELECT Sales_Order_Header__c FROM Sales_Order_Line_Item__c WHERE Id IN :Trigger.newMap.keySet())];        

            for(Sales_Order_Header__c record :headerIds){
                headerRecords.put(record.Id, record);
                accountIds.add(record.Account__c);
            }

            List<Account> accounts = [SELECT Id, Last_Delivery_Requested_Date__c FROM Account WHERE Id IN :accountIds];

            for(Sales_Order_Header__c record :headerIds){
                for(Account account :accounts){
                    if(record.Account__c == account.Id){
                        if(accountRecords.get(record.Id) == null){
                            accountRecords.put(record.Id, account);
                        }
                    }
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
        lastRequestedDateCheck((Sales_Order_Line_Item__c)obj);
    }

    public void afterUpdate(Sobject oldObj, Sobject newObj){
        lastRequestedDateCheck((Sales_Order_Line_Item__c)newObj);
    }

    public void afterDelete(Sobject obj){

    }

    public void andFinally(){
        if(accountsToUpdate.size() > 0){
            update accountsToUpdate.values();
        }

        if(headersToUpdate.size() > 0){
            update headersToUpdate.values();
        }
    }

    private void lastRequestedDateCheck(Sales_Order_Line_Item__c lineItemObject){
        Set<String> itemFilter = new Set<String>{'400', '070','010'};

        if(String.isNotEmpty(lineItemObject.Product_Id__c) && !itemFilter.contains(lineItemObject.Product_Id__c.left(3)) && String.isEmpty(lineItemObject.Item_Reject_Reason_Desc__c)){
            Account accountRecord = accountRecords.get(lineItemObject.Sales_Order_Header__c);
            Sales_Order_Header__c headerRecord = headerRecords.get(lineItemObject.Sales_Order_Header__c);

           
	        if(accountRecord != null){
		        if(!accountsToUpdate.containsKey(accountRecord.Id)){
		        	if(String.isEmpty(accountRecord.Last_Delivery_Requested_Date__c) || accountRecord.Last_Delivery_Requested_Date__c == '//' || accountRecord.Last_Delivery_Requested_Date__c == '1/1/00' || lineItemObject.Last_Confirmed_Date__c > Date.parse(accountRecord.Last_Delivery_Requested_Date__c)){
		        		accountRecord.Last_Delivery_Requested_Date__c = lineItemObject.Last_Confirmed_Date__c.format();
		        		accountsToUpdate.put(accountRecord.Id, accountRecord);
		        	}
		        }
		        else{
		        	if(String.isEmpty(accountsToUpdate.get(accountRecord.Id).Last_Delivery_Requested_Date__c) || lineItemObject.Last_Confirmed_Date__c > Date.parse(accountsToUpdate.get(accountRecord.Id).Last_Delivery_Requested_Date__c)){
		        		accountsToUpdate.get(accountRecord.Id).Last_Delivery_Requested_Date__c = lineItemObject.Last_Confirmed_Date__c.format();
		        	}
		        }
	    	}

	    	if(headerRecord != null){
		        if(!headersToUpdate.containsKey(headerRecord.Id)){
		        	if(headerRecord.Requested_Delivery_Date__c == null || lineItemObject.Last_Confirmed_Date__c > headerRecord.Requested_Delivery_Date__c){
		        		headerRecord.Requested_Delivery_Date__c = lineItemObject.Last_Confirmed_Date__c;
		        		headersToUpdate.put(headerRecord.Id, headerRecord);
		        	}
		        }
		        else{
		        	if(headersToUpdate.get(headerRecord.Id).Requested_Delivery_Date__c == null || lineItemObject.Last_Confirmed_Date__c > headersToUpdate.get(headerRecord.Id).Requested_Delivery_Date__c){
		        		headersToUpdate.get(headerRecord.Id).Requested_Delivery_Date__c = lineItemObject.Last_Confirmed_Date__c;
		        	}	        	
		        }
	        }            
        }
    }
}