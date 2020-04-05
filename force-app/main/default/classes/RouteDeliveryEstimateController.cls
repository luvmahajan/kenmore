public class RouteDeliveryEstimateController {
    
    public String quoteId {get; set;}
    public String deliveryId {get; set;}
    
    public RouteDeliveryEstimateController(ApexPages.StandardController stdController) {
        deliveryId = ApexPages.CurrentPage().getparameters().get('id');
        quoteId = '';
        List<Delivery_Estimate__c> lstDeliveryEstimate = new  List<Delivery_Estimate__c>();
        lstDeliveryEstimate = [SELECT Id, Name, Quote__c FROM Delivery_Estimate__c WHERE Id=:deliveryId LIMIT 1];
        if(lstDeliveryEstimate.size()>0){
            if(lstDeliveryEstimate[0].Quote__c!=null){
                quoteId = lstDeliveryEstimate[0].Quote__c;
            }
        }

    }
    
    public PageReference routeHandler(){
        if(quoteId!=''){
        PageReference retURL = new PageReference('/apex/QuoteLineEditor?id=' + quoteId );
        retURL.setRedirect(true);
        return retURL;
        }else{
        PageReference retURL = new PageReference('/'+deliveryId );
        retURL.setRedirect(true);
        return retURL;
        }
    }    
    
}