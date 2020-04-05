@isTest
private class TerritoryTriggerTest {

	static testmethod void truncateTerritory() {
		Test.startTest();
		List<Territory__c> territories = TestDataFactory.createTerritories(3);
		insert territories;

		List<Territory__c> territoryResult = [SELECT Id FROM Territory__c];
		System.assertEquals(territoryResult.size(), 3);

		List<Territory__c> territories2 = TestDataFactory.createTerritories(5);
		insert territories2;

		territoryResult = [SELECT Id FROM Territory__c];
	//	System.assertEquals(territoryResult.size(), 5);

		delete territories2;
		Test.stopTest();
	}
	
	static testmethod void updateTerritoryIdForUser() {
		Test.startTest();
		List<User> users = TestDataFactory.createUsers(5);
		insert users;

		List<Territory__c> territories = TestDataFactory.createTerritories(3);
		territories[0].SFDC_USER_ID__c = users[0].Id;
		territories[1].SFDC_USER_ID__c = users[1].Id;
		territories[2].SFDC_USER_ID__c = users[2].Id;
		insert territories;

		List<User> userResult = [SELECT Id, Territory_ID__c FROM User WHERE Id = :users[1].Id];
		System.assertEquals(userResult[0].Territory_ID__c, territories[1].Territory_ID__c);

		territories[0].SFDC_USER_ID__c = users[2].Id;
		territories[1].SFDC_USER_ID__c = users[3].Id;
		territories[2].SFDC_USER_ID__c = users[4].Id;
		update territories;

		userResult = [SELECT Id, Territory_ID__c FROM User WHERE Id = :users[4].Id];
		System.assertEquals(userResult[0].Territory_ID__c, territories[2].Territory_ID__c);
		Test.stopTest();
	}

	static testmethod void userManagerUpdate(){
		TestDataFactory.setupCommonVariables();

		Test.startTest();
		List<User> users = TestDataFactory.createUsers(5);		
		User thisUser = [ select Id from User where Id = :UserInfo.getUserId()];
	//	List<Profile> profiles = [SELECT Id FROM Profile WHERE Name = 'Standard Commercial AM User'];
		List<Profile> profiles = [SELECT Id FROM Profile WHERE Name = 'Standard User'];

		System.runAs ( thisUser ) {
		    insert users;

		    users[0].ManagerId = users[3].Id;
			users[1].ManagerId = users[4].Id;
			users[0].Sears_Enterprise_Id__c = '101010';
			users[1].Sears_Enterprise_Id__c = '202020';
			users[0].ProfileId = profiles[0].Id;
			users[1].ProfileId = profiles[0].Id;
			update users;
		}

		Set<Id> resultIds = (new Map<Id,SObject>(users)).keySet();

		List<User> userResults = [SELECT Id, Name, ManagerId, UserType, IsActive FROM User WHERE Id IN :resultIds ORDER BY Name];
		System.debug('***** UserResults ' + userResults);
		userResults.sort();

		List<Territory__c> territories = TestDataFactory.createTerritories(2);
		territories[0].District_Manager_Name_Short__c = userResults[2].Name;
		territories[0].SFDC_USER_ID__c = userResults[0].Id;
		territories[0].Region_Name__c = 'Sales Operations Region National';
		territories[0].District_Name__c = 'National Accounts District';
		territories[0].Enterprise_ID__c = '101010';
		territories[1].District_Manager_Name_Short__c = userResults[4].Name;
		territories[1].SFDC_USER_ID__c = userResults[1].Id;
		territories[1].Region_Name__c = 'Sales Operations Region West';
		territories[1].District_Name__c = 'Military Accounts District';
		territories[1].Enterprise_ID__c = '202020';
		System.runAs ( thisUser ) {
			insert territories;
		}

		userResults = [SELECT Id, Name, ManagerId FROM User WHERE Id IN :resultIds ORDER BY Name];
		userResults.sort();
		
	//	System.assertEquals(userResults[0].ManagerId, System.Label.National_Account_DM);
	//	System.assertEquals(userResults[1].ManagerId, userResults[4].Id);

		territories[1].District_Manager_Name_Short__c = userResults[3].Name;
		System.runAs ( thisUser ) {
			update territories;
		}
		userResults = [SELECT Id, Name, ManagerId FROM User WHERE Id IN :resultIds ORDER BY Name];
	//	System.assertEquals(userResults[1].ManagerId, userResults[3].Id);


		Test.stopTest();
	}
}