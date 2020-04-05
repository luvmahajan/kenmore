trigger OrderItem on OrderItem (after insert, after update, before delete) {
    
    if(trigger.isAfter && trigger.isInsert){
        OrderItemTriggerHandler.afterInsert(trigger.new, trigger.newMap);
    }
    
    if(trigger.isAfter && trigger.isUpdate){
        OrderItemTriggerHandler.afterUpdate(trigger.new, trigger.newMap, trigger.oldMap);
    }
    
    if(trigger.isBefore && trigger.isDelete){
        OrderItemTriggerHandler.beforeDelete(trigger.new, trigger.oldMap);
    }
}