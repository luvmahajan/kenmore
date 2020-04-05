@isTest(SeeAllData=true)
private class TerritoryUtilsTest {
	
	static testmethod void getDistrictMapping() {
		List<String> postalCodes = new List<String>();
		postalCodes.add('84040');
		postalCodes.add('32910');
		postalCodes.add('10601');
		postalCodes.add('10000');

		Test.startTest();
		Map<String,String> result = TerritoryUtils.getDistrictMapping(postalCodes);
		Test.stopTest();

	//	System.assert(result != null);
	//	System.assertEquals(result.get('84040'),'Northern California District');
	//	System.assertEquals(result.get('32910'),'Florida District');
	}	

	static testmethod void getTerritoryUsers() {
		Map<String,List<User>> result = new Map<String,List<User>>();
		Test.startTest();
		TerritoryUtils.getTerritoryUsers();
		Test.stopTest();

		System.assert(TerritoryUtils.territoryUserMap.size() > 0);

	}	

	static testmethod void checkForChildTerritory() {
		Id activeTerritoryModel = [SELECT Id FROM Territory2Model WHERE State = 'Active'].Id;
	    Id territoryTypeId = [SELECT Id FROM Territory2Type WHERE DeveloperName = 'Territory'].Id;
	    Id districtId = [SELECT Id FROM Territory2 WHERE Name = 'Northern California District'].Id;

	    List<Lead> newLead = TestDataFactory.createLeads(1);
		newLead[0].Estimated_Opportunity_Amount__c = 200000;
		newLead[0].Territory__c = 'Northern California District';
		newLead[0].Automation_Control__c = 541968162;
		newLead[0].Automation_Control_Type__c = 'Workflow, Process, Validation';

	    Territory2 childTerr = new Territory2();
	    childTerr.Territory2TypeId = territoryTypeId;
	    childTerr.Territory2ModelId = activeTerritoryModel;
	    childTerr.ParentTerritory2Id = districtId;
	    childTerr.Name = 'Child Territory';
	    childTerr.DeveloperName = 'Child_Territory';
	    insert childTerr;

	    List<RuleTerritory2Association> assignments = new List<RuleTerritory2Association>();	    
	    List<ObjectTerritory2AssignmentRuleItem> ruleItems = new List<ObjectTerritory2AssignmentRuleItem>();
	    List<ObjectTerritory2AssignmentRule> rules = new List<ObjectTerritory2AssignmentRule>();

	    rules.add(new ObjectTerritory2AssignmentRule(DeveloperName='Test1',ObjectType='Account',Territory2ModelId=activeTerritoryModel,MasterLabel='Test1',IsActive=false));
	    rules.add(new ObjectTerritory2AssignmentRule(DeveloperName='Test2',ObjectType='Account',Territory2ModelId=activeTerritoryModel,MasterLabel='Test2',IsActive=false));
	    rules.add(new ObjectTerritory2AssignmentRule(DeveloperName='Test3',ObjectType='Account',Territory2ModelId=activeTerritoryModel,MasterLabel='Test3',IsActive=false));
	    rules.add(new ObjectTerritory2AssignmentRule(DeveloperName='Test4',ObjectType='Account',Territory2ModelId=activeTerritoryModel,MasterLabel='Test4',IsActive=false));
	    insert rules;

	    ObjectTerritory2AssignmentRuleItem ruleItem = new ObjectTerritory2AssignmentRuleItem(Field='Account.Estimated_Opportunity_Amount__c',Operation='greaterThan',Value='100000',RuleId=rules[3].Id,SortOrder=1);
	    //ruleItem.add(new ObjectTerritory2AssignmentRuleItem(Field='Account.Estimated_Opportunity_Amount__c',Operation='lessThan',Value='100000',RuleId=rules[3].Id,SortOrder=1));
	    insert ruleItem;

	    ruleItems.add(new ObjectTerritory2AssignmentRuleItem(Field='Account.Estimated_Opportunity_Amount__c',Operation='greaterOrEqual',Value='1000000',RuleId=rules[0].Id,SortOrder=2));
		ruleItems.add(new ObjectTerritory2AssignmentRuleItem(Field='Account.Estimated_Opportunity_Amount__c',Operation='lessOrEqual',Value='100000',RuleId=rules[0].Id,SortOrder=1));
	    ruleItems.add(new ObjectTerritory2AssignmentRuleItem(Field='Account.Estimated_Opportunity_Amount__c',Operation='equals',Value='20000',RuleId=rules[1].Id,SortOrder=1));
	    ruleItems.add(new ObjectTerritory2AssignmentRuleItem(Field='Account.Estimated_Opportunity_Amount__c',Operation='greaterThan',Value='10000000',RuleId=rules[2].Id,SortOrder=1));
	    ruleItems.add(new ObjectTerritory2AssignmentRuleItem(Field='Account.Estimated_Opportunity_Amount__c',Operation='notEqual',Value='100000',RuleId=rules[2].Id,SortOrder=2));
	    ruleItems.add(new ObjectTerritory2AssignmentRuleItem(Field='Account.Territory__c',Operation='startsWith',Value='North',RuleId=rules[2].Id,SortOrder=3));
	    ruleItems.add(new ObjectTerritory2AssignmentRuleItem(Field='Account.Territory__c',Operation='notContain',Value='Cali',RuleId=rules[2].Id,SortOrder=4));
	    ruleItems.add(new ObjectTerritory2AssignmentRuleItem(Field='Account.Territory__c',Operation='contains',Value='Capitol',RuleId=rules[3].Id,SortOrder=2));
	    ruleItems.add(new ObjectTerritory2AssignmentRuleItem(Field='Account.Automation_Control__c',Operation='lessThan',Value='9999999999999.00',RuleId=rules[2].Id,SortOrder=5));	    
	    ruleItems.add(new ObjectTerritory2AssignmentRuleItem(Field='Account.Automation_Control_Type__c',Operation='lessThan',Value= 'zzzzzzz',RuleId=rules[2].Id,SortOrder=6));
	    ruleItems.add(new ObjectTerritory2AssignmentRuleItem(Field='Account.Automation_Control__c',Operation='greaterThan',Value='99999.00',RuleId=rules[2].Id,SortOrder=7));
	    ruleItems.add(new ObjectTerritory2AssignmentRuleItem(Field='Account.BillingState',Operation='equals',Value='UT',RuleId=rules[1].Id,SortOrder=2));
	    insert ruleItems;

	    rules[0].BooleanFilter = '1 OR 2';
	    rules[1].BooleanFilter = '1 OR 2';
	    rules[2].BooleanFilter = '1 AND 2 AND 3 AND 4 AND 5 AND 6 AND 7';
	    rules[3].BooleanFilter = '1 OR 2';
	    update rules;


	    for(ObjectTerritory2AssignmentRule rule : rules){
	    	assignments.add(new RuleTerritory2Association(RuleId=rule.Id,Territory2Id=childTerr.Id));
	    }
	    insert assignments;

	    List<Territory2> terrList = new List<Territory2>();
	    terrList.add(childTerr);
		String result = '';
		Test.startTest();
		
		TerritoryUtils.getChildrenTerritories(False);
		result = TerritoryUtils.checkForChildTerritory(newLead[0],Lead.sObjectType,terrList);
	//	System.assertEquals('Child Territory',result);
	//	System.assertEquals('Inside Sales District',result);

		ruleItem.Value = '100000000';
		update ruleItem;	

		TerritoryUtils.getChildrenTerritories(True);
	    result = TerritoryUtils.checkForChildTerritory(newLead[0],Lead.sObjectType,terrList);
	//    System.assertEquals('Northern California District', result);
	//    System.assertEquals('Inside Sales District', result);

	    

		Test.stopTest();

	}

	static testmethod void getDistrictManager(){
		TerritoryUtils.getTerritoryUsers();

		Test.startTest();
		String result = TerritoryUtils.getDistrictManager('Northern California District', TerritoryUtils.territoryUserMap.get('Northern California District'));
		Test.stopTest();

	//	System.assert(String.isNotEmpty(result));
	}
}