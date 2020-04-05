trigger ChangeRequestTrigger on Change_Request__c (before insert, before update, before delete, after insert, after update, after delete) {
    TriggerFactory.createHandler(Change_Request__c.sObjectType);
}