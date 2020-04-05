@isTest
private class AccountOwnerAlignmentBatchTest {
	
	static testmethod void accountOwnerAlignmentTest() {
		TestDataFactory.setupCommonVariables();
		List<User> users = TestDataFactory.createUsers(5);
		insert users;
		users[0].Sears_Enterprise_Id__c = '101010';
		users[1].Sears_Enterprise_Id__c = '202020';
		users[2].Sears_Enterprise_Id__c = '303030';
		users[3].Sears_Enterprise_Id__c = '404040';
		users[4].Sears_Enterprise_Id__c = '505050';
		update users;
		

		List<Territory__c> territories = TestDataFactory.createTerritories(4);
		territories[0].Territory_ID__c = '01000';
		territories[0].Enterprise_ID__c = '101010';
		territories[0].SFDC_USER_ID__c = users[0].Id;
		territories[1].Territory_ID__c = '02000';
		territories[1].Enterprise_ID__c = '202020';
		territories[1].SFDC_USER_ID__c = users[1].Id;
		territories[2].Territory_ID__c = '30000';
		territories[2].Enterprise_ID__c = '303030';
		territories[2].SFDC_USER_ID__c = users[2].Id;
		territories[3].Territory_ID__c = '04000';
		territories[3].Enterprise_ID__c = '404040';
		territories[3].SFDC_USER_ID__c = users[3].Id;
		insert territories;

		Business_Sector__c sector = new Business_Sector__c();
		sector.Name = 'Construction';
		insert sector;

		List<Account> accounts = TestDataFactory.createAccounts(3);
		accounts[0].Territory_ID__c = territories[0].Territory_ID__c;
		accounts[0].OwnerId = territories[0].SFDC_USER_ID__c;
		accounts[0].Sap_Account_ID__C = '0011111111';
		accounts[0].Business_Sector__c = sector.Id;
		accounts[1].Territory_ID__c = territories[1].Territory_ID__c;
		accounts[1].OwnerId = territories[1].SFDC_USER_ID__c;		
		accounts[1].Sap_Account_ID__C = '0022222222';		
		accounts[1].Business_Sector__c = sector.Id;
		accounts[2].Territory_ID__c = territories[2].Territory_ID__c;
		accounts[2].OwnerId = territories[2].SFDC_USER_ID__c;		
		accounts[2].Sap_Account_ID__C = '0033333333';
		accounts[2].Business_Sector__c = sector.Id;
		insert accounts;

		Test.startTest();
		System.assertEquals(users[0].Id, territories[0].SFDC_USER_ID__c);
		System.assertEquals(territories[0].SFDC_USER_ID__c, accounts[0].OwnerId);

		territories[0].Enterprise_ID__c = '505050';
		update territories;

		List<Territory__c> territoryList = [SELECT Id, Territory_ID__c, SFDC_USER_ID__c FROM Territory__c];
		AccountOwnerAlignmentBatchClass accountAlignment = new AccountOwnerAlignmentBatchClass(territoryList);
		ID batchProcess = Database.executeBatch(accountAlignment);
		Test.stopTest();



		Account updatedAccount = [SELECT Id, OwnerId FROM Account WHERE Id = :accounts[0].Id];
	//	System.assertEquals(users[4].Id, updatedAccount.OwnerId);

	}	
}