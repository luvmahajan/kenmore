@isTest
private class SalesOrderLineItemTriggerTest {
	
	static testmethod void requestedDeliveryDateTestMethod() {
		List<Account> accounts = TestDataFactory.createAccounts(1);
		insert accounts;

		List<Sales_Order_Header__c> headers = TestDataFactory.createSalesOrderHeaders(1);
		headers[0].Account__c = accounts[0].Id;		
		insert headers;

		List<Sales_Order_Line_Item__c> lineItems = TestDataFactory.createSalesOrderLineItems(5, headers[0].Id);
		for(Integer a = 0; a < 5; a++){
			lineItems[a].Last_Confirmed_Date__c = Date.today() + a;
			lineItems[a].Product_Id__c = (a == 4 ? '40010510000':'04660603000');			
		}

		lineItems[3].Item_Reject_Reason_Desc__c = 'Test Reason Code';

		Test.startTest();
		insert lineItems;
		
		List<Account> insertedAccount = [SELECT Id, Last_Delivery_Requested_Date__c FROM Account WHERE Id = :accounts[0].Id];
		System.assertEquals(Date.parse(insertedAccount[0].Last_Delivery_Requested_Date__c), Date.today() + 2);

		LIST<Sales_Order_Header__c> insertedHeaders = [SELECT Id, Requested_Delivery_Date__c FROM Sales_Order_Header__c WHERE Id = :headers[0].Id];
		System.assertEquals(insertedHeaders[0].Requested_Delivery_Date__c, Date.today() + 2);

		lineItems[0].Last_Confirmed_Date__c = Date.today() + 45;
		update lineItems[0];

		List<Account> updatedAccount = [SELECT Id, Last_Delivery_Requested_Date__c FROM Account WHERE Id = :accounts[0].Id];
		System.assertEquals(Date.parse(updatedAccount[0].Last_Delivery_Requested_Date__c),Date.today() + 45);
		
		LIST<Sales_Order_Header__c> updatedHeaders = [SELECT Id, Requested_Delivery_Date__c FROM Sales_Order_Header__c WHERE Id = :headers[0].Id];
		System.assertEquals(updatedHeaders[0].Requested_Delivery_Date__c, Date.today() + 45);

		List<Sales_Order_Line_Item__c> itemsToDelete = [SELECT Id FROM Sales_Order_Line_Item__c WHERE Id = :lineItems[0].Id];
		delete itemsToDelete;

		Test.stopTest();
	}
	
}