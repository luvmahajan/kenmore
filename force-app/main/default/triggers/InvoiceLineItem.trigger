trigger InvoiceLineItem on Invoice_Line_Item__c (after insert, after update, before delete) {
    
	if(trigger.isAfter && trigger.isInsert){
    	InvoiceLineItemTriggerHandler.afterInsert(trigger.new, trigger.newMap);
    }
    
    if(trigger.isAfter && trigger.isUpdate){
    	InvoiceLineItemTriggerHandler.afterUpdate(trigger.new, trigger.newMap, trigger.oldMap);
    }
    
    if(trigger.isBefore && trigger.isDelete){
    	InvoiceLineItemTriggerHandler.beforeDelete(trigger.new, trigger.oldMap);
    }
}