global class BatchUpdateUnitPrice implements Database.Batchable<sObject>, Database.Stateful{
    global final String Query;
    
    global BatchUpdateUnitPrice(){
        Query = 'SELECT Id, Net_Unit_Price__c, UnitPrice ' 
            + '  FROM OrderItem ' ;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<OrderItem> lstOrderItem ){
        
        for(OrderItem oi:lstOrderItem){
            if(oi.UnitPrice!=oi.Net_Unit_Price__c){
                oi.UnitPrice=oi.Net_Unit_Price__c;
            }
        }
        
        update lstOrderItem;
        
    }
    
    global void finish(Database.BatchableContext BC){
    }
    
}