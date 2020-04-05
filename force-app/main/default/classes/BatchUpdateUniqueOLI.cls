global class BatchUpdateUniqueOLI implements Database.Batchable<sObject>, Database.Stateful{
    global final String Query;
    
    global BatchUpdateUniqueOLI(){
        Query = 'SELECT Id, Product2Id, Product2.ProductCode, OrderId, ' 
            + '  Order.Order_Reference_Number__c, Unique_Value__c, ' 
            + '  Parent_Part_Number__c, Number__c ' 
            + '  FROM OrderItem ' 
            + ' WHERE Order.Order_Reference_Number__c!=null AND Order.Status NOT IN (\'Completed\', \'Done\') ' ;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<OrderItem> lstOIUpdate ){
        List<OrderItem> lstOrderItem = new List<OrderItem>();
        lstOrderItem = [SELECT Id, Product2Id, Product2.ProductCode, OrderId, 
                        Order.Order_Reference_Number__c, Unique_Value__c, 
                        Parent_Part_Number__c, Number__c 
                        FROM OrderItem 
                        WHERE Order.Order_Reference_Number__c!= null AND Order.Status NOT IN ('Completed', 'Done') 
                       ];
        
        Map<String, String> mapParentCode = new Map<String, String>();
        
        for(OrderItem oi:lstOrderItem){
            if(oi.Parent_Part_Number__c=='0' || oi.Parent_Part_Number__c==null){
                mapParentCode.put(oi.Order.Order_Reference_Number__c + oi.Number__c, oi.Product2.ProductCode );
            }
        }
        
        system.debug('lstOrderItem.size() --> ' + lstOrderItem.size() );
        system.debug('mapParentCode.size() --> ' + mapParentCode.size() );
        
        for(OrderItem oiu:lstOIUpdate){
            if(oiu.Parent_Part_Number__c=='0' || oiu.Parent_Part_Number__c==null){
                oiu.Unique_Value__c = oiu.Order.Order_Reference_Number__c + oiu.Product2.ProductCode;
            }else if(oiu.Parent_Part_Number__c!='0' && oiu.Parent_Part_Number__c!=null){
                oiu.Unique_Value__c = oiu.Order.Order_Reference_Number__c + oiu.Product2.ProductCode + mapParentCode.get(oiu.Order.Order_Reference_Number__c + oiu.Parent_Part_Number__c) ;
            }
        }
        system.debug('lstOIUpdate.size() --> ' + lstOIUpdate.size() );
        update lstOIUpdate;
        
    }
    
    global void finish(Database.BatchableContext BC){
    }
    
}