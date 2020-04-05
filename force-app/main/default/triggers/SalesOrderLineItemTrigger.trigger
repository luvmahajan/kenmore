trigger SalesOrderLineItemTrigger on Sales_Order_Line_Item__c (before insert, before update, before delete, after insert, after update, after delete) {
	TriggerFactory.createHandler(Sales_Order_Line_Item__c.sObjectType);
}