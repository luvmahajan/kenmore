global class AccountOwnerAlignScheduledClass implements Schedulable {
	global void execute(SchedulableContext sc) {
		List<Territory__c> territoryList = [SELECT Id, Territory_ID__c, SFDC_USER_ID__c FROM Territory__c];
		AccountOwnerAlignmentBatchClass accountAlignment = new AccountOwnerAlignmentBatchClass(territoryList);
		Database.executeBatch(accountAlignment);
	}
}