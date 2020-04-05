public class ProductIntegrationController {
    
    public String quoteId {get; set;}
    public List<Quote_Line_Staging__c> lstQuoteLineStaging {get; set;}
    
    public ProductIntegrationController() {
        quoteId = ApexPages.CurrentPage().getparameters().get('id');
        
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
                               Tax_Rate__c, Total_Tax_Amount__c, Tax_Amount__c, Tax__c,Additional_Disc__c, Discount_Operator__c, 
                               isProductParent__c, ProductParent__c, ProductParentUnique__c, Feature__c, 
                               Net_Total_Non_Discount__c, Target_Customer_Amount__c 
                               FROM Quote_Line_Staging__c 
                               WHERE Quote__c = :quoteId
                              ];
        system.debug('lstQuoteLineStaging--> ' + lstQuoteLineStaging );
        
        PageReference retURL = new PageReference('/apex/ProductIntegration2?id=' + quoteId );
        
        if(lstQuoteLineStaging.size()>0){
            
            //     Quotehandler.ProdAvailCheckCallout(qheader.Id);
            SBQQ__Quote__c qheader = new SBQQ__Quote__c();
            qheader = [select SBQQ__NetAmount__c , SBQQ__ShippingCity__c, SBQQ__ShippingPostalCode__c, SBQQ__ShippingState__c, SBQQ__ShippingStreet__c, GeoCode__c, County_Code__c, SBQQ__Account__c, Delivery_Total__c, Delivery_Tax__c, Tax_API_Request__c, Tax_API_Response__c, isTaxError__c from SBQQ__Quote__c where Id = :quoteId LIMIT 1];
            if(qheader!=null && qheader.SBQQ__ShippingPostalCode__c!=null ){
                CalloutTaxCalculationAPI6.TaxCalcWrapper(qheader);
                //  	CalloutProdInventoryCheckAPI6.ProdAvailCheckWrapper(qheader);
            }
            
        }else{
            SBQQ__Quote__c qheader = new SBQQ__Quote__c();
            qheader = [select Id, Delivery_Tax__c from SBQQ__Quote__c where Id = :quoteId LIMIT 1];
        system.debug('qheader--> ' + qheader );
            qheader.Delivery_Tax__c = 0;
        system.debug('qheader--> ' + qheader );
            update qheader;
        system.debug('qheader--> ' + qheader );
            retURL = new PageReference('/apex/QuoteLineEditor?id=' + quoteId );
        }
        retURL.setRedirect(true);
        return retURL;
    }
    
    
    
}