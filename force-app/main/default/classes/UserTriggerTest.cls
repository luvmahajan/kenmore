@isTest
private class UserTriggerTest {
	
	static testmethod void inactiveUserTest() {
		Map<String, Common_Variables__c> commonVariables = TestDataFactory.createCommonVariables();
		insert commonVariables.values();		

		List<User> users = TestDataFactory.createUsers(2);
		users[0].ProfileId = commonVariables.get('Account Manager Profile Id').Content__c;
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
		accs[1].SAP_Account_Id__c = '00101010';
		accs[1].RecordTypeId = [SELECT Id FROM RecordType WHERE SobjectType = 'Account' AND Name = 'Commercial Customer' LIMIT 1].Id;		
		accs[1].Business_Sector__c = sector.Id;
		accs[1].Industry_Segment__c = segment.Id;
		accs[2].OwnerId = users[1].Id;
		insert accs;

		List<Task> tasks = TestDataFactory.createTasks(4);
		tasks[0].OwnerId = users[0].Id;
		tasks[1].OwnerId = users[0].Id;
		tasks[2].OwnerId = users[0].Id;
		tasks[3].OwnerId = users[0].Id;
		insert tasks;


		tasks[3].Status = 'Completed';
		update tasks;

		List<Lead> leads = TestDataFactory.createLeads(3);
		leads[0].OwnerId = users[0].Id;
		leads[0].Business_Sector__c = sector.Id;
		leads[0].Industry_Segment__c = segment.Id;
		leads[1].OwnerId = users[0].Id;
		leads[1].Business_Sector__c = sector.Id;
		leads[1].Industry_Segment__c = segment.Id;
		leads[2].OwnerId = users[0].Id;
		leads[2].Business_Sector__c = sector.Id;
		leads[2].Industry_Segment__c = segment.Id;
		insert leads;

		//Database.LeadConvert lc = new database.LeadConvert();
		//lc.setLeadId(leads[2].id);

		//LeadStatus convertStatus = [Select Id, MasterLabel from LeadStatus where IsConverted=true limit 1];
		//lc.setConvertedStatus(convertStatus.MasterLabel);
		 
		//Database.LeadConvertResult lcr = Database.convertLead(lc);
		//System.assert(lcr.isSuccess());

		Test.startTest();
		
		User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
		System.runAs ( thisUser ) {
			users[0].IsActive = false;
			update users;
		}
		
		Test.stopTest();

		List<Task> inactiveUserTasks = [SELECT Id FROM Task WHERE OwnerId = :users[1].Id];
		List<Lead> inactiveUserLeads = [SELECT Id FROM Lead WHERE OwnerId = :users[1].Id];
		List<Account> inactiveUserAccounts = [SELECT Id FROM Account WHERE OwnerId = :users[1].Id];
	//	System.assertEquals(inactiveUserTasks.size(),3);
	//	System.assertEquals(inactiveUserLeads.size(),3);
	//	System.assertEquals(inactiveUserAccounts.size(),2);
	}	
}