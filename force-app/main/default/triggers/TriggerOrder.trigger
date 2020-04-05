trigger TriggerOrder on Order (after update) {
//	TriggerFactory.createHandler(Order.sObjectType);
	
    Order oldOrder = new Order();
    List<String> lstOrder = new List<String>();
    Map<String, String> mapOrderDelivery = new Map<String, String>();
    
    for (Order ord : Trigger.new) {
        system.debug('ord.Delivery_Schedule__c --> ' + ord.Delivery_Schedule__c );
        oldOrder = Trigger.oldMap.get(ord.ID);
        
        system.debug('oldOrder.Delivery_Schedule__c --> ' + oldOrder.Delivery_Schedule__c );
        
        if(ord.Delivery_Schedule__c != oldOrder.Delivery_Schedule__c) {
            system.debug('Y --> ' );
            lstOrder.add(ord.Id);
            mapOrderDelivery.put(ord.Id, ord.Delivery_Schedule__c);
        }else{
            system.debug('N --> ' );
        }        
    }   
    
        system.debug('lstOrder --> ' + lstOrder );
        system.debug('lstOrder.size() --> ' + lstOrder.size() );
    
    List<OrderItem> lstOLI = new List<OrderItem>();
    lstOLI =  [select Id, OrderId, Delivery_Schedule__c from OrderItem WHERE OrderId IN:mapOrderDelivery.keySet() ];
    for(OrderItem lo:lstOLI){
        lo.Delivery_Schedule__c = mapOrderDelivery.get(lo.OrderId);
    }
    
        system.debug('lstOLI --> ' + lstOLI );
        system.debug('lstOLI.size() --> ' + lstOLI.size() );
    
    update lstOLI;
	
}