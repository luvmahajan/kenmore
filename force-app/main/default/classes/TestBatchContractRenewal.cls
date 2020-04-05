public with sharing class TestBatchContractRenewal 
{
	static testMethod void testContractRenewal()
	{

		//create test data
		List<Account> acc = TestDataFactory.createAccounts(1);
		insert acc;
		
		Contract contract = new Contract();
		contract.Name = 'Test';
		contract.AccountId = acc[0].Id;
		contract.Status = 'Draft';
		//Use query for unit test instead of Dates
		contract.StartDate = Date.today();
		contract.ContractTerm = 3;
		contract.Contract_End_Date__c = Date.today().addDays(90);
        contract.Purchase_Number__c = 'PO_C_00' ;
		insert contract;
		
		ContractRenewalOpportunityFields__c crof = new ContractRenewalOpportunityFields__c();
		crof.Name = 'Defaults';
		crof.Opportunity_Business__c = 'Home Services';
		crof.Opportunity_Stage__c = 'Determine Solution';
		crof.Opportunity_Record_Type__c = [select Id from RecordType where SObjectType = 'Opportunity'  AND DeveloperName = 'Home_Services'].Id;
		insert crof;
				
		//test
		BatchContractRenewal bcr = new BatchContractRenewal();
		Test.startTest();
		Database.executeBatch(bcr);
		Test.stopTest();
		
		//validation
		Integer opportunitiesCreated = [SELECT COUNT() FROM Opportunity WHERE AccountId = :acc[0].Id]; 
		System.assertEquals(1, opportunitiesCreated);
		
	}

}