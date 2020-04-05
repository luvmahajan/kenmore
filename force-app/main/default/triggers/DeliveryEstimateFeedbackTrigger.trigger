trigger DeliveryEstimateFeedbackTrigger on Delivery_Estimate_Feedback__c (before insert, before update, before delete, after insert, after update, after delete) {
	TriggerFactory.createHandler(Delivery_Estimate_Feedback__c.sObjectType);
}