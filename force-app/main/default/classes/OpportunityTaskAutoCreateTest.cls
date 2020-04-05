@isTest
public class OpportunityTaskAutoCreateTest {
	static testmethod void testTaskAutoCreate(){
		Opportunity[] opportunities = TestDataFactory.createOpportunities(3);
		User[] newUsers = TestDataFactory.createUsers(3);
		Account[] account = TestDataFactory.createAccounts(1);

		newUsers[0].ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1].Id;
//		newUsers[0].ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard Inside Sales User' LIMIT 1].Id;
	//	newUsers[1].ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard Commercial AM User' LIMIT 1].Id;
		newUsers[1].ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1].Id;
		newUsers[2].ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1].Id;
		
		insert(newUsers);
		insert(account);
		
		opportunities[0].OwnerId = newUsers[0].Id;
		opportunities[1].OwnerId = newUsers[1].Id;
		opportunities[0].AccountId = account[0].Id;
		opportunities[1].AccountId = account[0].Id;
		opportunities[2].OwnerId = newUsers[2].Id;		
		opportunities[2].AccountId = account[0].Id;

		insert(opportunities);
		
		Test.startTest();

		OpportunityTaskAutoCreate event = new OpportunityTaskAutoCreate();
		List<Task> result = event.GenerateTasks();
		event.execute(null);

//		System.assert(result.size() == 2);

		Test.stopTest();
	}
}