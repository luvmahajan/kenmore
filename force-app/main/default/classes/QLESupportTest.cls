@isTest
public class QLESupportTest {

    static testMethod void ProductAccesorries_Test1(){
        
        DataInsertFactory.insertPricing();
                    
        List<SBQQ__Quote__c> lstTestQuote = new List<SBQQ__Quote__c>();
        lstTestQuote = [SELECT Id FROM SBQQ__Quote__c ORDER BY Id];
        
        List<Product2> lstTestProduct = new List<Product2>();
        lstTestProduct = [SELECT Id FROM Product2 ORDER BY Id];
        
        PageReference pageRef = Page.ProductAccesorries; 
        pageRef.getParameters().put('id', lstTestQuote[0].Id);
        pageRef.getParameters().put('prodid', lstTestProduct[0].Id);
     //   pageRef.getParameters().put('prid', lstTestQuote[0].Id);
     //   pageRef.getParameters().put('feat', 'Parts');
        Test.setCurrentPage(pageRef);
        
            
        ProductAccesorriesController ctredt = new ProductAccesorriesController();
        ctredt.redirectQLE();
        ctredt.actionSave();
  //      ctredt.gotoNext();
        ctredt.gotoProducts();
        ctredt.actionSelected();
        ctredt.getInstallationService();
  //      ctredt.actionInstallation();
    }   
    
    static testMethod void ProductAccesorries_Test2(){
        
        DataInsertFactory.insertPricing();
                    
        List<SBQQ__Quote__c> lstTestQuote = new List<SBQQ__Quote__c>();
        lstTestQuote = [SELECT Id FROM SBQQ__Quote__c ORDER BY Id];
        
        List<Product2> lstTestProduct = new List<Product2>();
        lstTestProduct = [SELECT Id FROM Product2 ORDER BY Id];
        
        PageReference pageRef = Page.ProductAccesorries; 
        pageRef.getParameters().put('id', lstTestQuote[0].Id);
        pageRef.getParameters().put('prodid', lstTestProduct[3].Id);
     //   pageRef.getParameters().put('prid', lstTestQuote[0].Id);
     //   pageRef.getParameters().put('feat', 'Parts');
        Test.setCurrentPage(pageRef);
        
            
        ProductAccesorriesController ctredt = new ProductAccesorriesController();
        ctredt.redirectQLE();
        ctredt.actionSave();
  //      ctredt.gotoNext();
        ctredt.gotoProducts();
        ctredt.actionSelected();
        ctredt.getInstallationService();
   //     ctredt.actionInstallation();
        
    }   
    
    static testMethod void QuoteLineProducts_Test(){
        
        DataInsertFactory.insertPricing();
                    
        List<SBQQ__Quote__c> lstTestQuote = new List<SBQQ__Quote__c>();
        lstTestQuote = [SELECT Id FROM SBQQ__Quote__c ORDER BY Id];
        
        List<Product2> lstTestProduct = new List<Product2>();
        lstTestProduct = [SELECT Id FROM Product2 ORDER BY Id];
        
        PageReference pageRef = Page.QuoteLineProducts; 
        pageRef.getParameters().put('id', lstTestQuote[0].Id);
        pageRef.getParameters().put('pid', lstTestProduct[0].Id);
     //   pageRef.getParameters().put('prid', lstTestQuote[0].Id);
     //   pageRef.getParameters().put('feat', 'Parts');
        Test.setCurrentPage(pageRef);
        
            
        QuoteLineProductsController ctredt = new QuoteLineProductsController();
        
 //       ctredt.showPopup();
        pageRef.getParameters().put('pid', lstTestProduct[3].Id);
//        ctredt.showPopup();
        pageRef.getParameters().put('pid', lstTestProduct[0].Id);
//        ctredt.closePopup();
        ctredt.getProductFamily();
        ctredt.getProductOperator();
        ctredt.actionProduct();
        ctredt.gotoEditor();
        
        ctredt.selFamily = 'Products';
        ctredt.selLength = '5';
        ctredt.selWidth = '5';
        ctredt.selHeight = '5';
        ctredt.selWeight = '5';
        ctredt.actionApplyFilter();
        ctredt.selLength = 's';
        ctredt.selWidth = 's';
        ctredt.selHeight = 's';
        ctredt.selWeight = 's';
        ctredt.actionApplyFilter();
        
        
        ctredt.selWeight_op = 'equals';
        ctredt.actionApplyFilter();
        ctredt.selHeight_op = 'equals';
        ctredt.actionApplyFilter();
        ctredt.selWidth_op = 'equals';
        ctredt.actionApplyFilter();
        ctredt.selLength_op = 'equals';
        ctredt.actionApplyFilter();
    } 
    
    static testMethod void ProductIntegration_Test(){
        
        DataInsertFactory.insertQuote();
                    
        List<SBQQ__Quote__c> lstTestQuote = new List<SBQQ__Quote__c>();
        lstTestQuote = [SELECT Id FROM SBQQ__Quote__c ORDER BY Id];
        
        PageReference pageRef = Page.QuoteLineProducts; 
        pageRef.getParameters().put('id', lstTestQuote[0].Id);
        Test.setCurrentPage(pageRef);
        
            
        ProductIntegrationController ctredt = new ProductIntegrationController();
        ctredt.redirectQLE();
        
        ProductIntegrationController2 ctredt2 = new ProductIntegrationController2();
        ctredt2.redirectQLE();
            
        RouteQuoteController ctredt3 = new RouteQuoteController();
        ctredt3.redirectQLE();
        
        OrderAvailabilityController ctredt4 = new OrderAvailabilityController();
        ctredt4.redirectQLE();
    } 

    
    static testMethod void AddressValidation_Test(){
        DataInsertFactory.insertQuote();
        
        List<SBQQ__Quote__c> lstTestQuote = new List<SBQQ__Quote__c>();
        lstTestQuote = [SELECT Id FROM SBQQ__Quote__c ORDER BY Id];
        
        PageReference pageRef = Page.QuoteLineProducts; 
        pageRef.getParameters().put('id', lstTestQuote[0].Id);
        pageRef.getParameters().put('seqno', '1');
        Test.setCurrentPage(pageRef);
        
        ApexPages.StandardController stdctrlr = new ApexPages.StandardController(lstTestQuote[0]); 
        AddressValidationController ctredt = new AddressValidationController(stdctrlr);   
        
        ctredt.checkAddress();
        ctredt.getaddressList();
        ctredt.selectaddr();
        ctredt.gotoQuote();
        
    }
   
    
    
}