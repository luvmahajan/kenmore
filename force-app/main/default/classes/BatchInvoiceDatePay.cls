global class BatchInvoiceDatePay implements Database.Batchable<sObject>, Database.Stateful{
      global final String Query;

   global BatchInvoiceDatePay(){
       Query = 'SELECT Id, Name, Invoice_Date__c, Pay_Type__c ' 
           + '  FROM Invoice__c ' 
           + '  WHERE Invoice_Date__c = null OR Pay_Type__c = null  ' ;
   }

   global Database.QueryLocator start(Database.BatchableContext BC){
      return Database.getQueryLocator(query);
   }

    global void execute(Database.BatchableContext BC, List<Invoice__c> lstInvoice ){
        
  //      system.debug('lstInvoice --> ' + lstInvoice );
        system.debug('lstInvoice.size() --> ' + lstInvoice.size() );
        
        Set<String > setInvoiceId = new Set<String >();
        
        for(Invoice__c inv:lstInvoice){
      //      system.debug('inv --> ' + inv );
            setInvoiceId.add(inv.Id);
        }
        
        List<Invoice_Line_Item__c > lstInvoiceLineItem = new List<Invoice_Line_Item__c >();
        lstInvoiceLineItem = [SELECT Id, Invoice__c, Invoice_Date__c, Pay_Type__c 
                              FROM Invoice_Line_Item__c 
                              WHERE Invoice__c IN: setInvoiceId 
                             ];
        
        Map<String, Date > mapInvoiceDate = new Map<String, Date >();
        Map<String, String > mapPayType = new Map<String, String >();
        
        for(Invoice_Line_Item__c ili:lstInvoiceLineItem){
     //       system.debug('ili --> ' + ili );
            if(ili.Invoice_Date__c!=null){
                mapInvoiceDate.put(ili.Invoice__c, ili.Invoice_Date__c);
            }
            if(ili.Pay_Type__c!=null){
                mapPayType.put(ili.Invoice__c, ili.Pay_Type__c);
            }
        }
        
       //     system.debug('mapInvoiceDate --> ' + mapInvoiceDate );
       //     system.debug('mapPayType --> ' + mapPayType );
            system.debug('mapInvoiceDate.size() --> ' + mapInvoiceDate.size() );
            system.debug('mapPayType.size() --> ' + mapPayType.size() );
        
        for(Invoice__c inv:lstInvoice){
     //       system.debug('inv --> ' + inv );
            if(mapInvoiceDate.get(inv.Id) != null){
                inv.Invoice_Date__c = mapInvoiceDate.get(inv.Id);
            }
            if(mapPayType.get(inv.Id) != null){
                inv.Pay_Type__c = mapPayType.get(inv.Id);
            }
        }
        
        for(Invoice__c inv:lstInvoice){
            system.debug('inv --> ' + inv );
        }
        
        update lstInvoice;
    }
        
       

   global void finish(Database.BatchableContext BC){
   }

}