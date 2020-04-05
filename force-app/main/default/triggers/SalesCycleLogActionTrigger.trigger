trigger SalesCycleLogActionTrigger on Sales_Cycle_Log_Action__c (before insert, before update, before delete, after insert, after update, after delete) {
    TriggerFactory.createHandler(Sales_Cycle_Log_Action__c.sObjectType);
}