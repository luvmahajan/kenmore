global class BatchUpdateDuplicateProducts implements Database.Batchable<sObject>, Database.Stateful{
      global final String Query;

   global BatchUpdateDuplicateProducts(){
       Query = 'SELECT Id, Product2Id, OrderId ' 
           + ' FROM OrderItem ' 
           + ' WHERE Feature__c=null  AND (Parent_Part_Number__c=\'0\' OR Parent_Part_Number__c=\'\' ) ' 
           + ' ORDER BY OrderId ' ;
   }

   global Database.QueryLocator start(Database.BatchableContext BC){
      return Database.getQueryLocator(query);
   }

   global void execute(Database.BatchableContext BC, List<OrderItem> lstOrderItem ){
       
       Integer cnt_OrderItem = lstOrderItem.size();
       
       String temp_qt_product = '';
       Set<String> setTempProduct = new Set<String>();
       Set<String > lstOI = new Set<String >();
       
       
       for(OrderItem oi:lstOrderItem){
           temp_qt_product = string.valueof(oi.OrderId) + string.valueof(oi.Product2Id);
           if(setTempProduct.contains(temp_qt_product )){
               lstOI.add(oi.OrderId);
               //    system.debug('qp--> ' + ql.SBQQ__Quote__c );
           }
           setTempProduct.add(temp_qt_product);
       }
       
       system.debug('lstOI.size()--> ' + lstOI.size() );
       for(String oi:lstOI){
           system.debug('oi--> ' + oi );
       }
       
       List<Order > lstOrder = new List<Order >();
       lstOrder = [SELECT Id, SBQQ__Quote__c FROM ORDER WHERE Id IN: lstOI];
       system.debug('lstOrder.size()--> ' + lstOrder.size() );
       for(Order ql:lstOrder){
           system.debug('ql--> ' + ql );
       }
             
   }

   global void finish(Database.BatchableContext BC){
   }

}