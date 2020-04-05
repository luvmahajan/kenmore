@isTest
public class CommonUtilsTest {
	public static testMethod void regexTest(){
		Test.startTest();
		System.assert(CommonUtils.checkRegex(CommonUtils.postalCodeRegex, '84040'));
		System.assertEquals(CommonUtils.checkRegex(CommonUtils.postalCodeRegex, '8404'), false);
		System.assertEquals(CommonUtils.isFirstRun('Account'), true);
		System.assert(CommonUtils.getAutomationControl() > 0);

		String automationControlTypes = CommonUtils.getAutomationControlTypes(true, true, false);
		String automationControlTypes2 = CommonUtils.getAutomationControlTypes(true, false, true);
		Test.stopTest();


		System.assert(automationControlTypes.contains('Workflow') && automationControlTypes.contains('Validation'));
		System.assert(automationControlTypes2.contains('Process') && automationControlTypes2.contains('Validation'));
		System.assertEquals(commonUtils.isFirstRun('Account'), false);
	}

	public static testMethod void autoAssignTest(){
		Map<String, Common_Variables__c> commonVariables = TestDataFactory.createCommonVariables();
		insert commonVariables.values();
		UserRole role = [SELECT Id, Name FROM UserRole WHERE Name LIKE '%SR%' LIMIT 1];

		List<User> users = TestDataFactory.createUsers(3);
		users[0].Is_Round_Robin_Active__c = true;
		users[0].LastName = 'A';
		users[0].UserRole = role;
		users[1].Is_Round_Robin_Active__c = true;
		users[1].LastName = 'B';
		users[1].UserRole = role;
		users[2].Is_Round_Robin_Active__c = true;
		users[2].LastName = 'C';
		users[2].UserRole = role;
		insert users;

		List<Lead> leads = TestDataFactory.createLeads(4);
		leads[0].Estimated_Opportunity_Amount__c = 25000;
		leads[1].Estimated_Opportunity_Amount__c = 100000;
		leads[2].Estimated_Opportunity_Amount__c = 100000;
		leads[3].Estimated_Opportunity_Amount__c = 200000;
		insert leads;

		Test.startTest();
		System.assertEquals(String.valueOf(((Lead)(CommonUtils.autoAssignOwner(leads[3], Lead.sObjectType, new List<User>()))).OwnerId), String.valueOf(commonVariables.get('IST Queue Id').Content__c));
		System.assertNotEquals(String.valueOf(((Lead)(CommonUtils.autoAssignOwner(leads[0], Lead.sObjectType, users))).OwnerId), String.valueOf(commonVariables.get('IST Queue Id').Content__c));
		System.assertEquals(String.valueOf(((Lead)(CommonUtils.autoAssignOwner(leads[1], Lead.sObjectType, users))).OwnerId), String.valueOf(users[0].Id));
		users[0].Is_Current_Round_Robin_Selection__c = true;
		update users;
		System.assertEquals(String.valueOf(((Lead)(CommonUtils.autoAssignOwner(leads[2], Lead.sObjectType, users))).OwnerId), String.valueOf(users[1].Id));

		Map<String, Schema.SObjectField> M = Schema.SObjectType.User.fields.getMap();
		Schema.SObjectField field = M.get('LastName');
		System.assertEquals(CommonUtils.getFieldType(field),'String');
		Test.stopTest();
	}

	public static testMethod void getLeadCampaigns(){

		List<Lead> leads = TestDataFactory.createLeads(4);		
		leads[0].Estimated_Opportunity_Amount__c = 25000;
		insert leads;

		List<Campaign> campaigns = TestDataFactory.createCampaigns(1);
		insert campaigns;

		List<CampaignMember> members = TestDataFactory.createCampaignMembers(1);
		members[0].CampaignId = campaigns[0].Id;
		members[0].LeadId = leads[0].Id;
		insert members;

		List<Id> leadIds = new List<Id>();
		for(Lead lds : leads){
			leadIds.add(lds.Id);
		}
		Test.startTest();
		Map<String, List<Campaign>> result = commonUtils.getLeadCampaigns(leadIds);
		Test.stopTest();

		System.assertEquals(1,result.size());
	}
}