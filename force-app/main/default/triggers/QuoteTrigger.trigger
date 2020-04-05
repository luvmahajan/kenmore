trigger QuoteTrigger on SBQQ__Quote__c (before insert, before update, before delete, after insert, after update, after delete) {
	TriggerFactory.createHandler(SBQQ__Quote__c.sObjectType);
}