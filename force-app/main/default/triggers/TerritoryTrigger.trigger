trigger TerritoryTrigger on Territory__c (before insert, before update, before delete, after insert, after update, after delete) {
    TriggerFactory.createHandler(Territory__c.sObjectType);
}