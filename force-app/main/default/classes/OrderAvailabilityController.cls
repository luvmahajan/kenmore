public class OrderAvailabilityController {
    
    public String quoteId {get; set;}
    public String pay {get; set;}
    public List<Quote_Line_Staging__c> lstQuoteLineStaging {get; set;}
    
    public OrderAvailabilityController() {
        quoteId = ApexPages.CurrentPage().getparameters().get('id');
        pay = ApexPages.CurrentPage().getparameters().get('pay');
        
        lstQuoteLineStaging = new List<Quote_Line_Staging__c>();
        
    //    actionSave();
        
    }  
    
    public PageReference redirectQLE()
    {
        lstQuoteLineStaging = new List<Quote_Line_Staging__c>();
        lstQuoteLineStaging = [SELECT Id, Name, AdditionalDiscountAmount__c, AdditionalDiscountPercent__c, Quote__c, 
                               		Product__c, Quantity__c, List_Unit_Price__c, Product__r.ProductCode, Product__r.Name, 
                               		Product__r.Description, Non_Discountable__c, Quantity_Editable__c, Bundled__c, 
                               		Net_Unit_Price__c, Net_Total__c, Available_Quantity__c, PA_API_Message__c, Available__c, 
                               		Earliest_Available_Date__c, Disposable_Fee__c, //Shipping_Charge__c, 
                               		Tax_Rate__c, Total_Tax_Amount__c, Tax_Amount__c, Tax__c, Additional_Disc__c, Discount_Operator__c, 
                               		isProductParent__c, ProductParent__c, ProductParentUnique__c, Feature__c, 
                               		Net_Total_Non_Discount__c, Target_Customer_Amount__c 
                               FROM Quote_Line_Staging__c 
                               WHERE Quote__c = :quoteId
                              ];
        system.debug('lstQuoteLineStaging--> ' + lstQuoteLineStaging );
        
        if(lstQuoteLineStaging.size()>0){
        
      //     Quotehandler.ProdAvailCheckCallout(qheader.Id);
        SBQQ__Quote__c qheader = new SBQQ__Quote__c();
        qheader = [select SBQQ__NetAmount__c , SBQQ__ShippingCity__c, SBQQ__ShippingPostalCode__c, SBQQ__ShippingState__c, SBQQ__ShippingStreet__c, GeoCode__c, County_Code__c from SBQQ__Quote__c where Id = :quoteId LIMIT 1];
        if(qheader!=null && qheader.SBQQ__ShippingPostalCode__c!=null ){
       // 	CalloutTaxCalculationAPI6.TaxCalcWrapper(qheader);
       // 	CalloutProdInventoryCheckAPI6.ProdAvailCheckWrapper(qheader);
        	CalloutProdInventoryCheckAPI7.ProdAvailCheckWrapper2(qheader);
        }
        
        }
        
        if(pay=='Check' || pay=='Credit Card' ){
            PageReference retURL = new PageReference('/apex/OrderQuote?id=' + quoteId + '&pay=' + pay );
        retURL.setRedirect(true);
        return retURL;
        }else{
            PageReference retURL = new PageReference('/apex/OrderQuote?id=' + quoteId );
        retURL.setRedirect(true);
        return retURL;
        }
   //     return null;
    }
    
    

}