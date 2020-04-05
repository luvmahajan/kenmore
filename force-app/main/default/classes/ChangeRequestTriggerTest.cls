@isTest
private class ChangeRequestTriggerTest {	
	static testmethod void currentChangeRequestTest() {
		TestDataFactory.setupCommonVariables();		
		List<User> users = TestDataFactory.createUsers(1);
		insert users;		

		List<Account> accounts = TestDataFactory.createAccounts(2);
		accounts[0].OwnerId = users[0].Id;
		accounts[1].OwnerId = users[0].Id;
		accounts[0].SAP_Account_ID__c = '00000001';
		accounts[1].SAP_Account_ID__c = '00000002';
		insert accounts;

		List<Change_Request__c> firstRequests = TestDataFactory.createChangeRequests(2);
		firstRequests[0].Account_Name__c = accounts[0].Id;
		firstRequests[1].Account_Name__c = accounts[1].Id;
		insert firstRequests;

		List<Change_Request__c> firstResult = [SELECT Id, Account_Name__c, Current_Request__c FROM Change_Request__c WHERE Current_Request__c = true];

		System.assert(firstResult.size() == 2);

		List<Change_Request__c> secondRequest = TestDataFactory.createChangeRequests(1, accounts[0].Id);
		insert secondRequest;

		List<Change_Request__c> secondResult = [SELECT Id, Account_Name__c, Current_Request__c FROM Change_Request__c WHERE Current_Request__c = true AND Account_Name__c = :accounts[0].Id];

		System.assert(secondResult.size() == 1);
		System.assertEquals(secondRequest[0].Id, secondResult[0].Id);

		delete secondRequest;
	}

	static testmethod void changeRequestUpdateApproverTest() {
		TestDataFactory.setupCommonVariables();

	//	Profile CommercialUserProfile = [Select Id from Profile where Name = 'Standard Commercial AM User' LIMIT 1];
		Profile CommercialUserProfile = [Select Id from Profile where Name = 'Standard User' LIMIT 1];

		List<User> managers = TestDataFactory.createUsers(2);
		managers[0].Username = 'devtestmanager1@factory.com';
		managers[1].Username = 'devtestmanager2@factory.com';
		insert managers;

		List<User> users = TestDataFactory.createUsers(2);
		users[0].ManagerId = managers[0].Id;
		users[0].ProfileId = CommercialUserProfile.Id;
		users[1].ManagerId = managers[1].Id;
		insert users;		

		List<Account> accounts = TestDataFactory.createAccounts(3);
		accounts[0].OwnerId = users[0].Id;
		accounts[1].OwnerId = users[1].Id;
		accounts[0].SAP_Account_ID__c = '00000001';
		accounts[1].SAP_Account_ID__c = '00000002';
		accounts[2].OwnerId = users[0].Id;		
		accounts[2].SAP_Account_ID__c = '00100003';
		accounts[2].ParentId = accounts[0].Id;
		insert accounts;

		List<Change_Request__c> firstRequests = TestDataFactory.createChangeRequests(3);
		firstRequests[0].Account_Name__c = accounts[0].Id;
		firstRequests[1].Account_Name__c = accounts[1].Id;
		firstRequests[2].Account_Name__c = accounts[2].Id;
		firstRequests[2].Auto_Approve__c = true;
		firstRequests[2].New_Pricing_Tier__c = 'Gold';
		insert firstRequests;	

		List<Change_Request__c> firstResult = [SELECT Id, Account_Name__c, Current_Request__c,Change_Request_Approver__c, Request_Status__c FROM Change_Request__c WHERE Account_Name__c = :accounts[0].Id OR Account_Name__c = :accounts[1].Id];

	//	System.assert(firstResult.size() == 2);	

		for(Change_Request__c record :firstResult){
			if(record.Account_Name__c == accounts[0].Id){
			//	System.assertEquals(record.Change_Request_Approver__c, users[0].ManagerId);
				record.Request_Status__c = 'Approved';
				record.New_Pricing_Tier__c = 'Gold';
				update record;
			}
			else if (record.Account_Name__c == accounts[0].Id){
			//	System.assertEquals(record.Change_Request_Approver__c, users[1].Id);
				record.Request_Status__c = 'Approved';
				record.New_Pricing_Tier__c = 'Gold';
			}

		}	
	}
	
}