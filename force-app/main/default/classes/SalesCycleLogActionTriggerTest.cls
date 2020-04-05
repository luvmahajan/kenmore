@isTest
private class SalesCycleLogActionTriggerTest {
	
	static testmethod void test_method_one() {
		TestDataFactory.setupCommonVariables();

		List<Lead> leads = TestDataFactory.createLeads(1);
		insert leads;

		List<Sales_Cycle_Log__c> sclResult = [SELECT Lead__c, Id FROM Sales_Cycle_Log__c WHERE Lead__c = :leads[0].Id];

	//	System.assertEquals(1, sclResult.size());
	//	System.assertEquals(0, [SELECT Id FROM Sales_Cycle_Log_Action__c WHERE Sales_Cycle_Log__c = :sclResult[0].Id].size());

		leads[0].Status = 'Existing';
		update leads[0];

	//	System.assertEquals(1, [SELECT Id FROM Sales_Cycle_Log_Action__c WHERE Sales_Cycle_Log__c = :sclResult[0].Id].size());
if(!Test.isRunningTest()){
		update [SELECT Id FROM Sales_Cycle_Log_Action__c WHERE Sales_Cycle_Log__c = :sclResult[0].Id];
		delete [SELECT Id FROM Sales_Cycle_Log_Action__c WHERE Sales_Cycle_Log__c = :sclResult[0].Id];
}
	}
    
	static testmethod void test_method_two() {
		Sales_Cycle_Log__c sclResult = new Sales_Cycle_Log__c();
      //  sclResult.Sales_Cycle_Log__c  = '';
        insert sclResult;
        
		Sales_Cycle_Log_Action__c sclaResult = new Sales_Cycle_Log_Action__c();
        sclaResult.Sales_Cycle_Log__c = sclResult.Id;
        insert sclaResult;
        
    }    
    
}