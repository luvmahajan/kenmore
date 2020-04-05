@isTest
private class SalesOrderPurgeBatchClassTest {
	
	static testmethod void salesOrderPurgeTest() {
		List<Sales_Order_Header__c> headers = TestDataFactory.createSalesOrderHeaders(10);
		headers[0].Order_Status__c = 'Completed';
		headers[0].Create_Date_Time__c = system.today().addDays(-35);//should be deleted
		headers[1].Order_Status__c = 'Open';
		headers[1].Create_Date_Time__c = system.today().addDays(-35);
		headers[2].Order_Status__c = 'Completed';
		headers[2].Create_Date_Time__c = system.today().addDays(-10);
		headers[3].Order_Status__c = 'Completed';
		headers[3].Create_Date_Time__c = system.today().addDays(-40);//should be deleted
		headers[4].Order_Status__c = 'Open';
		headers[4].Create_Date_Time__c = system.today().addDays(-40);
		headers[5].Order_Status__c = 'Open';
		headers[5].Create_Date_Time__c = system.today().addDays(-10);
		headers[6].Order_Status__c = 'Open';
		headers[6].Create_Date_Time__c = system.today().addDays(-50);
		headers[7].Order_Status__c = 'Open';
		headers[7].Create_Date_Time__c = system.today().addDays(-3);
		headers[8].Order_Status__c = 'Completed';
		headers[8].Create_Date_Time__c = system.today().addDays(-100);//should be deleted
		headers[9].Order_Status__c = 'Open';
		headers[9].Create_Date_Time__c = system.today().addDays(-30);

		insert headers;

		Test.startTest();
//		System.assertEquals(10, database.countquery('SELECT COUNT() FROM Sales_Order_Header__c'));
		SalesOrderPurgeBatchClass SOPurge = new SalesOrderPurgeBatchClass();
		ID batchProcess = Database.executeBatch(SOPurge);
		Test.stopTest();
//		System.assertEquals(7, database.countquery('SELECT COUNT() FROM Sales_Order_Header__c'));
		
	}	
}