@isTest
public class QLESupportTest2 {

    static testMethod void ProductAccesorries_Test0_pu(){
        
        DataInsertFactory.insertQuote();
                    
        List<SBQQ__Quote__c> lstTestQuote = new List<SBQQ__Quote__c>();
        lstTestQuote = [SELECT Id FROM SBQQ__Quote__c ORDER BY Id];
        
        List<Product2> lstTestProduct = new List<Product2>();
        lstTestProduct = [SELECT Id, ProductCode FROM Product2 ORDER BY Id];
        
        List<Product_Pricing__c> lstTestPP = new List<Product_Pricing__c>();
        Product_Pricing__c test_PP_1 = new Product_Pricing__c();
        
        for(Product2 tp:lstTestProduct){
            test_PP_1 = new Product_Pricing__c();
        	test_PP_1.Material_Number__c = tp.ProductCode;
        	test_PP_1.Price__c = 500;
        	test_PP_1.Cost__c = 250;
        	lstTestPP.add(test_PP_1);
        }
        insert lstTestPP;
        
        List<Quote_Line_Staging__c> lstTestQLS = new List<Quote_Line_Staging__c>();
        lstTestQLS = [SELECT Id, Product__c, ProductParentUnique__c FROM Quote_Line_Staging__c ORDER BY Id];
        
        PageReference pageRef = Page.ProductAccesorries; 
        pageRef.getParameters().put('id', lstTestQuote[0].Id);
        pageRef.getParameters().put('prodid', lstTestQLS[0].Product__c);
        pageRef.getParameters().put('pu', lstTestQLS[0].ProductParentUnique__c);

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
    
    static testMethod void ProductAccesorries_Test0_pe(){
        
        DataInsertFactory.insertQuote();
                    
        List<SBQQ__Quote__c> lstTestQuote = new List<SBQQ__Quote__c>();
        lstTestQuote = [SELECT Id FROM SBQQ__Quote__c ORDER BY Id];
        
        List<Product2> lstTestProduct = new List<Product2>();
        lstTestProduct = [SELECT Id, ProductCode FROM Product2 ORDER BY Id];
        
        List<Product_Pricing__c> lstTestPP = new List<Product_Pricing__c>();
        Product_Pricing__c test_PP_1 = new Product_Pricing__c();
        
        for(Product2 tp:lstTestProduct){
            test_PP_1 = new Product_Pricing__c();
        	test_PP_1.Material_Number__c = tp.ProductCode;
        	test_PP_1.Price__c = 500;
        	test_PP_1.Cost__c = 250;
        	lstTestPP.add(test_PP_1);
        }
        insert lstTestPP;
        
        List<Quote_Line_Staging__c> lstTestQLS = new List<Quote_Line_Staging__c>();
        lstTestQLS = [SELECT Id, Product__c, ProductParentUnique__c FROM Quote_Line_Staging__c ORDER BY Id];
        
        PageReference pageRef = Page.ProductAccesorries; 
        pageRef.getParameters().put('id', lstTestQuote[0].Id);
        pageRef.getParameters().put('prodid', lstTestQLS[0].Product__c);
        pageRef.getParameters().put('pe', lstTestQLS[0].ProductParentUnique__c);

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
    
    
}