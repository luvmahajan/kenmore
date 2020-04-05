global class BatchUpdateMismatchOLI implements Database.Batchable<sObject>, Database.Stateful{
      global final String Query;

   global BatchUpdateMismatchOLI(){
       Query = 'SELECT Id, SBQQ__Product__c, ProductParentUnique__c, SBQQ__Quantity__c, ' 
           + '  Net_Unit_Price__c, SBQQ__Number__c ' 
           + '  FROM SBQQ__QuoteLine__c ' 
           + ' WHERE ProductParentUnique__c!=null AND SBQQ__Product__c!=null ' 
           + ' AND SBQQ__Quantity__c!=null AND Net_Unit_Price__c!=null ' ;
   }

   global Database.QueryLocator start(Database.BatchableContext BC){
      return Database.getQueryLocator(query);
   }

    global void execute(Database.BatchableContext BC, List<SBQQ__QuoteLine__c> lstQuoteLine ){
        
        
        Set<String > setProductParentUnique = new Set<String >();
        Map<String, SBQQ__QuoteLine__c > mapQuoteLine = new Map<String, SBQQ__QuoteLine__c >();
        for(SBQQ__QuoteLine__c ql:lstQuoteLine){
            mapQuoteLine.put(ql.SBQQ__Product__c+ql.ProductParentUnique__c, ql);
            setProductParentUnique.add(ql.ProductParentUnique__c);
        }
        
        List<OrderItem > lstOrderItem = new List<OrderItem >();
        lstOrderItem = [SELECT Id, Product2Id, ProductParentUnique__c, Parent_Part_Number__c, Feature__c, 
                        Quantity, Net_Unit_Price__c, Number__c 
                        FROM OrderItem 
                        WHERE ProductParentUnique__c !=null AND ProductParentUnique__c IN: setProductParentUnique 
                        	AND Product2Id!=null AND Quantity!=null AND Net_Unit_Price__c!=null
                       ];
        
        /*
        Map<String, OrderItem > mapOrderItem = new Map<String, OrderItem >();
        for(OrderItem oi:lstOrderItem){
            if(mapQuoteLine.keyset().contains(oi.Product2Id+oi.ProductParentUnique__c)){
                mapOrderItem.put(oi.Product2Id+oi.ProductParentUnique__c, oi);
            }
        }
		*/
        Integer cnt_oi = 0;
        SBQQ__QuoteLine__c objTestQuoteLine = new SBQQ__QuoteLine__c ();
        for(OrderItem oi:lstOrderItem){
            objTestQuoteLine = new SBQQ__QuoteLine__c ();
            if(mapQuoteLine.keyset().contains(oi.Product2Id+oi.ProductParentUnique__c)){
                objTestQuoteLine = mapQuoteLine.get(oi.Product2Id+oi.ProductParentUnique__c);
                if(oi.Quantity!=objTestQuoteLine.SBQQ__Quantity__c || oi.Net_Unit_Price__c!=objTestQuoteLine.Net_Unit_Price__c ){
                    if(oi.Quantity!=objTestQuoteLine.SBQQ__Quantity__c ){
                        oi.Quantity = objTestQuoteLine.SBQQ__Quantity__c;
                    }
                    if(oi.Net_Unit_Price__c!=objTestQuoteLine.Net_Unit_Price__c ){
                        oi.Net_Unit_Price__c = objTestQuoteLine.Net_Unit_Price__c;
                    }
                    system.debug('oi --> ' + oi );
                    cnt_oi++;
                }
            }
        }
        
        system.debug('cnt_oi --> ' + cnt_oi );
        update lstOrderItem;
    
    }
    
    /*
        SBQQ__QuoteLine__c objTestQuoteLine = new SBQQ__QuoteLine__c ();
        List<OrderItem > lstOrderItemUpdate = new List<OrderItem >();
        
        
            Boolean isUpdate = false;
        
        for(OrderItem oi:lstOrderItem){
            objTestQuoteLine = new SBQQ__QuoteLine__c ();
            objTestQuoteLine = mapQuoteLine.get(oi.Product2Id+oi.ProductParentUnique__c);
            isUpdate = false;
            if(objTestQuoteLine!=null){
                if(objTestQuoteLine.SBQQ__Quantity__c!=null && oi.Quantity!=objTestQuoteLine.SBQQ__Quantity__c ){
                        oi.Quantity = objTestQuoteLine.SBQQ__Quantity__c;
                        isUpdate = true;
                }
                
                if(objTestQuoteLine.Net_Unit_Price__c!=null && oi.Net_Unit_Price__c!=objTestQuoteLine.Net_Unit_Price__c  ){
                        oi.Net_Unit_Price__c=objTestQuoteLine.Net_Unit_Price__c;
                        isUpdate = true;
                }
            }
            if(isUpdate){
                lstOrderItemUpdate.add(oi);
                system.debug('oi --> ' + oi );
            }
            
        }
                system.debug('lstOrderItemUpdate.size() --> ' + lstOrderItemUpdate.size() );
        update lstOrderItemUpdate;
    */    
/*

List<SBQQ__QuoteLine__c > lstQuoteLine = new List<SBQQ__QuoteLine__c >();
lstQuoteLine = [SELECT Id, SBQQ__Product__c, ProductParentUnique__c, SBQQ__Quantity__c, 
                	List_Price__c, Net_Unit_Price__c, SBQQ__Number__c, Tax_Rate__c, Tax__c 
                FROM SBQQ__QuoteLine__c 
               ];

         //       WHERE SBQQ__Quote__c IN ('a2i3A000003IJ7RQAW')


Map<String, SBQQ__QuoteLine__c > mapQuoteLine = new Map<String, SBQQ__QuoteLine__c >();
for(SBQQ__QuoteLine__c ql:lstQuoteLine){
    mapQuoteLine.put(ql.SBQQ__Product__c+ql.ProductParentUnique__c, ql);
}

List<OrderItem > lstOrderItem = new List<OrderItem >();
lstOrderItem = [SELECT Id, Product2Id, ProductParentUnique__c, Parent_Part_Number__c, Feature__c, 
                	Quantity, List_Unit_Price__c, Net_Unit_Price__c, Number__c, Tax_Rate__c, Item_Tax__c 
                FROM OrderItem 
               ];

        //        WHERE OrderId IN ('8013A000002txf3QAA')



Map<String, OrderItem > mapOrderItem = new Map<String, OrderItem >();
for(OrderItem oi:lstOrderItem){
    mapOrderItem.put(oi.Product2Id+oi.ProductParentUnique__c, oi);
}

SBQQ__QuoteLine__c objTestQuoteLine = new SBQQ__QuoteLine__c ();

for(OrderItem oi:lstOrderItem){
    objTestQuoteLine = new SBQQ__QuoteLine__c ();
    objTestQuoteLine = mapQuoteLine.get(oi.Product2Id+oi.ProductParentUnique__c);
    
    if(oi.Quantity!=objTestQuoteLine.SBQQ__Quantity__c || oi.Net_Unit_Price__c!=objTestQuoteLine.Net_Unit_Price__c  ){
        system.debug('oi.Id --> ' + oi.Id + ' & oi.ProductParentUnique__c --> ' + oi.ProductParentUnique__c  );
        system.debug('oi.Quantity --> ' + oi.Quantity + ' & objTestQuoteLine.SBQQ__Quantity__c --> ' + objTestQuoteLine.SBQQ__Quantity__c  );
        system.debug('oi.Net_Unit_Price__c --> ' + oi.Net_Unit_Price__c + ' & objTestQuoteLine.Net_Unit_Price__c --> ' + objTestQuoteLine.Net_Unit_Price__c  );
        /*
        system.debug('oi.Id --> ' + oi.Id + ' & oi.ProductParentUnique__c --> ' + oi.ProductParentUnique__c  );
        system.debug('oi.Number__c --> ' + oi.Number__c + ' & oi.Parent_Part_Number__c --> ' + oi.Parent_Part_Number__c  );
        system.debug('objTestQuoteLine.Tax_Rate__c --> ' + objTestQuoteLine.Tax_Rate__c + ' & oi.Tax_Rate__c --> ' + oi.Tax_Rate__c  );
        system.debug('objTestQuoteLine.Tax__c --> ' + objTestQuoteLine.Tax__c + ' & oi.Item_Tax__c --> ' + oi.Item_Tax__c  );
		**************
    }
    
}


*/      
       

   global void finish(Database.BatchableContext BC){
   }

}