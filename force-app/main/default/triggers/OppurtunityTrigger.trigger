trigger OppurtunityTrigger on Opportunity (before insert, before update, before delete, after insert, after update, after delete) {
    TriggerFactory.createHandler(Opportunity.sObjectType);
}