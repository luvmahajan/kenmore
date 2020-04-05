public class DeliveryEstimateFeedbackHandler implements ITrigger {
    
        public void bulkBefore() {}
    
    public void bulkAfter() {}
    
    public void beforeInsert(Sobject obj) {/*
        system.debug('Delivery_Estimate__c--> ' +  String.valueOf(obj.getSObject('Delivery_Estimate__c').get('Quote__c')) );
        List<SBQQ__Quote__c> lstQuoteDeliveryUpdate = new List<SBQQ__Quote__c>();
        lstQuoteDeliveryUpdate = [SELECT Id, Name, isDeliveryEstimate__c, Delivery_Charge__c FROM SBQQ__Quote__c WHERE Id=:String.valueOf(obj.getSObject('Delivery_Estimate__c').get('Quote__c')) LIMIT 1];
        system.debug('lstQuoteDeliveryUpdate.size()--> ' +  lstQuoteDeliveryUpdate.size() );
        if(lstQuoteDeliveryUpdate.size()>0){
            for(SBQQ__Quote__c ld:lstQuoteDeliveryUpdate){
                if(Double.valueOf(Obj.get('Recommended_Delivery__c'))!=null  ){
                ld.isDeliveryEstimate__c = false;
                ld.Delivery_Charge__c = Double.valueOf(Obj.get('Recommended_Delivery__c'));
                }
            }
            update lstQuoteDeliveryUpdate;
        }*/
    }
    
    public void beforeUpdate(Sobject oldObj, Sobject newObj) {}
    
    public void beforeDelete(Sobject obj) {}
    
    public void afterInsert(Sobject obj) {
        
        String quoteId='';
        List<Delivery_Estimate__c> lstDeliveryEstimate = new List<Delivery_Estimate__c>();
        lstDeliveryEstimate = [SELECT Id, Quote__c FROM Delivery_Estimate__c WHERE Id=:String.valueOf(obj.get('Delivery_Estimate__c')) LIMIT 1];
        if(lstDeliveryEstimate.size()>0){
            for(Delivery_Estimate__c de:lstDeliveryEstimate){
                if(de.Quote__c!=null  ){
                	quoteId = de.Quote__c;
                }
            }
        }
        
        
        system.debug('quoteId--> ' +  quoteId );
        List<SBQQ__Quote__c> lstQuoteDeliveryUpdate = new List<SBQQ__Quote__c>();
        lstQuoteDeliveryUpdate = [SELECT Id, Name, isDeliveryEstimate__c, Delivery_Charge__c FROM SBQQ__Quote__c WHERE Id=:quoteId LIMIT 1];
        if(lstQuoteDeliveryUpdate.size()>0){
            for(SBQQ__Quote__c ld:lstQuoteDeliveryUpdate){
                if(Double.valueOf(Obj.get('Recommended_Delivery__c'))!=null  ){
                ld.isDeliveryEstimate__c = false;
                ld.Delivery_Charge__c = Double.valueOf(Obj.get('Recommended_Delivery__c'));
                }
            }
            update lstQuoteDeliveryUpdate;
        }
    }
    
    public void afterUpdate(Sobject oldObj, Sobject newObj) {}
    
    public void afterDelete(Sobject obj) {}
    
    public void andFinally() {}

}