trigger ContractTrigger on Contract (before insert, before update, before delete, after insert, after update, after delete) {
	TriggerFactory.createHandler(Contract.sObjectType);
}