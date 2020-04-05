@isTest
private class AccountTriggerTest {
	private static final Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
	
	static testmethod void changeRequestTest() {	
		TestDataFactory.setupCommonVariables();	
		List<User> users = TestDataFactory.createUsers(4);
		users[0].Sears_Enterprise_Id__c = '101010';
		users[3].ProfileId = p.Id;
		users[1].Sears_Enterprise_Id__c = '202020';
		users[2].Sears_Enterprise_Id__c = '303030';
		insert users;		

		List<Territory__c> territories = TestDataFactory.createTerritories(3);
		territories[0].Territory_ID__c = '01000';
		territories[0].Enterprise_ID__c = '101010';
		territories[0].SFDC_USER_ID__c = users[0].Id;
		territories[1].Territory_ID__c = '02000';
		territories[1].Enterprise_ID__c = '202020';
		territories[1].SFDC_USER_ID__c = users[1].Id;
		territories[2].Territory_ID__c = '30000';
		territories[2].Enterprise_ID__c = '303030';
		territories[2].SFDC_USER_ID__c = users[2].Id;
		insert territories;

		List<Account> accounts = TestDataFactory.createAccounts(3);
		accounts[0].Territory_Id__c = '01000';
		accounts[0].SAP_Account_Id__c = '0010101010';
		accounts[1].Potential_Annual_Sales_Volume__c = 'B';
		accounts[1].SAP_Account_Id__c = '0020202020';
		accounts[2].SAP_Account_Id__c = '0030303030';		
		accounts[2].Potential_Annual_Sales_Volume__c = 'B';
		insert accounts;

		List<Change_Request__c> changeRequests = TestDataFactory.createChangeRequests(3);
		changeRequests[0].Account_Name__c = accounts[0].Id;
		changeRequests[1].Account_Name__c = accounts[1].Id;
		changeRequests[2].Account_Name__c = accounts[2].Id;
		changeRequests[0].New_Account_Owner__c = users[1].Id;
		changeRequests[1].New_Potential_Annual_Sales_Volume__c = 'C';
		changeRequests[2].New_Account_Owner__c = users[2].Id;		
		changeRequests[2].New_Potential_Annual_Sales_Volume__c = 'C';
		insert changeRequests;

		System.runAs(users[3]){
			accounts[0].Territory_Id__c = '02000';
			accounts[1].Potential_Annual_Sales_Volume__c = 'C';		
			accounts[2].Potential_Annual_Sales_Volume__c = 'C';
			update accounts;

			Test.startTest();
				Change_Request__c updatedRequest = [SELECT Id, Current_Request__c FROM Change_Request__c WHERE Id = :changeRequests[0].Id];
	//			System.assertEquals(false, updatedRequest.Current_Request__c);

				updatedRequest = [SELECT Id, Current_Request__c FROM Change_Request__c WHERE Id = :changeRequests[1].Id];
	//			System.assertEquals(false, updatedRequest.Current_Request__c);

				updatedRequest = [SELECT Id, Current_Request__c FROM Change_Request__c WHERE Id = :changeRequests[2].Id];
	//			System.assertEquals(true, updatedRequest.Current_Request__c);
			Test.stopTest();
		}
	}

	static testmethod void OppReassignTest(){
		TestDataFactory.setupCommonVariables();
		List<User> users = TestDataFactory.createUsers(2);
		insert users;
		users[0].ManagerId = users[1].Id;
		update users;	

		Business_Sector__c newBus = new Business_Sector__c();
		newBus.Name = 'Construction';
		insert newBus;

		Industry_Segment__c newInd = new Industry_Segment__c();
		newInd.Business_Sector__c = newBus.Id;
		newInd.Name = 'Construction - Developer Multi Family';
		newInd.Two_Digit_NAICS_Code__c = 23;
		newInd.NAICS_Code__c = '236117';
		insert newInd;

		Business_Sector__c sector = [SELECT Id FROM Business_Sector__c WHERE Name = 'Construction' LIMIT 1];
		Industry_Segment__c segment = [SELECT Id FROM Industry_Segment__c WHERE Name = 'Construction - Developer Multi Family' LIMIT 1];

		List<Account> accs = TestDataFactory.createAccounts(3);
		accs[0].OwnerId = users[0].Id;
		accs[1].OwnerId = users[0].Id;
		accs[2].OwnerId = users[0].Id;
		insert accs;

		List<Contact> contacts = TestDataFactory.createContacts(3);
		contacts[0].OwnerId = users[0].Id;
		contacts[0].AccountId = accs[0].Id;
		contacts[1].OwnerId = users[0].Id;		
		contacts[1].AccountId = accs[1].Id;
		contacts[2].OwnerId = users[0].Id;
		contacts[2].AccountId = accs[2].Id;
		insert contacts;

		List<Opportunity> opps = TestDataFactory.createOpportunities(4);
		opps[0].AccountId = accs[0].Id;
		opps[0].OwnerId = accs[0].OwnerId;
		opps[1].AccountId = accs[1].Id;		
		opps[1].OwnerId = accs[0].OwnerId;
		opps[2].AccountId = accs[2].Id;
		opps[2].OwnerId = accs[0].OwnerId;
		opps[3].AccountId = accs[2].Id;
		opps[3].OwnerId = accs[0].OwnerId;
		insert opps;

		opps[3].StageName = 'Deal Closure/Won';
		update opps[3];

		Test.startTest();
		accs[0].OwnerId = users[1].Id;
		accs[1].OwnerId = users[1].Id;
		accs[2].OwnerId = users[1].Id;
		update accs;

	//	System.assertEquals(3,[SELECT Id FROM Opportunity WHERE OwnerId = :users[1].Id].size());
	//	System.assertEquals(3, [SELECT Id FROM Contact WHERE OwnerId = :users[1].Id].size());
		Test.stopTest();
	}

	static testmethod void AccountTaskownershipChange(){
		List<User> users = TestDataFactory.createUsers(2);
		insert users;

		List<Account> Accounts = TestDataFactory.createAccounts(1);
		Accounts[0].OwnerId = users[0].Id;
		insert Accounts;

		List<Task> tasks = TestDataFactory.createTasks(2);
		tasks[0].OwnerId = users[0].Id;
		tasks[0].whatId = Accounts[0].Id;
		tasks[1].OwnerId = users[0].Id;
		tasks[1].whatId = Accounts[0].Id;
		insert tasks;

		List<Task> result = [SELECT Id FROM Task WHERE OwnerId = :users[0].Id];
		//System.assertEquals(2, result.size());

		Test.startTest();
		tasks[0].Status = 'Completed';
		update tasks[0];

		Accounts[0].OwnerId = users[1].Id;
		update Accounts;


		List<Task> result1 = [SELECT Id,Status FROM Task WHERE OwnerId = :users[1].Id];
		//System.assertEquals(1, result1.size());

		Test.stopTest();

	}
}