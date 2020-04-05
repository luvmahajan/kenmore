global class BatchUpdateQuoteCC implements Database.Batchable<sObject>, Database.Stateful{
      global final String Query;

   global BatchUpdateQuoteCC(){
       Query = 'Select Id, SBQQ__ShippingPostalCode__c, Fulfillment_Type__c, Location_Number__c ' 
           + '  FROM SBQQ__Quote__c ' 
           + ' WHERE Fulfillment_Type__c=null AND Location_Number__c=null ORDER BY LastModifiedDate DESC ' ;
     //      + ' WHERE Id IN ' 
     //      + '(\'a2i560000031rZlAAI\') ';
   }

   global Database.QueryLocator start(Database.BatchableContext BC){
      return Database.getQueryLocator(query);
   }

   global void execute(Database.BatchableContext BC, List<SBQQ__Quote__c> lstQuoteZip ){
       
       Integer cnt_QuoteZip = lstQuoteZip.size();
       system.debug('cnt_QuoteZip --> ' + cnt_QuoteZip );
       
       
       Set<String> setQuoteZip = new Set<String>();
       
       for(SBQQ__Quote__c zip:lstQuoteZip){
           setQuoteZip.add(zip.SBQQ__ShippingPostalCode__c);
           cnt_QuoteZip++;
       }
   //    system.debug('setQuoteZip --> ' + setQuoteZip );
       
       List<CommonCarrierOverrideZipcode__c> lstCCOZ = new List<CommonCarrierOverrideZipcode__c>();
       lstCCOZ = [SELECT Id, Name, Zipcode__c, PLANT__c, USLOC__c FROM CommonCarrierOverrideZipcode__c where Zipcode__c IN: setQuoteZip];
 //      system.debug('lstCCOZ --> ' + lstCCOZ );
       
       
       Map<String, String> mapFulType = new Map<String, String>();
       Map<String, String> mapLocNum = new Map<String, String>();
       
       for(CommonCarrierOverrideZipcode__c cc:lstCCOZ){
           mapFulType.put(cc.Zipcode__c, cc.PLANT__c);
           mapLocNum.put(cc.Zipcode__c, cc.USLOC__c);
       }
       
   //    system.debug('mapFulType--> ' + mapFulType );
   //    system.debug('mapLocNum--> ' + mapLocNum );
       
       for(SBQQ__Quote__c zp:lstQuoteZip){
           zp.Fulfillment_Type__c = mapFulType.get(zp.SBQQ__ShippingPostalCode__c);
           zp.Location_Number__c = mapLocNum.get(zp.SBQQ__ShippingPostalCode__c);
       }
       
  //     system.debug('lstQuoteZip--> ' + lstQuoteZip );
       
       
       update lstQuoteZip;
       
       
   }

   global void finish(Database.BatchableContext BC){
   }

}