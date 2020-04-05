@isTest
public class QuoteLineEditorControllerTest {
    
    static testMethod void QLE1(){
        
        String ran = DataInsertFactory.insertQuote();
            
        List<SBQQ__Quote__c> lstTestQuote = new List<SBQQ__Quote__c>();
        lstTestQuote = [SELECT Id FROM SBQQ__Quote__c ORDER BY Id];
        
        List<Product2> lstTestProduct = new List<Product2>();
        lstTestProduct = [SELECT Id FROM Product2 ORDER BY Id];
        
        PageReference pageRef = Page.QuoteLineEditor; 
        pageRef.getParameters().put('id', lstTestQuote[0].Id);
        pageRef.getParameters().put('pid', lstTestProduct[0].Id);
        pageRef.getParameters().put('sid', lstTestProduct[0].Id);
        Test.setCurrentPage(pageRef);
        
        QuoteLineEditorController ctredt = new QuoteLineEditorController();
        ctredt.target_amount = 400;
        ctredt.btn_press = 'Save';
        ctredt.getDiscountOperator();
        ctredt.showPopup();
        ctredt.actionEdit();
        pageRef.getParameters().put('sid', lstTestProduct[0].Id + ran );
        ctredt.actionClone();
        pageRef.getParameters().put('sid', lstTestProduct[0].Id);
        ctredt.actionDelete();
 //      ctredt.actionQuickSave();
    }   
    
    
    static testMethod void QLE2(){
        
        String ran = DataInsertFactory.insertQuote();
        
        List<SBQQ__Quote__c> lstTestQuote = new List<SBQQ__Quote__c>();
        lstTestQuote = [SELECT Id FROM SBQQ__Quote__c ORDER BY Id];
        
        List<Product2> lstTestProduct = new List<Product2>();
        lstTestProduct = [SELECT Id FROM Product2 ORDER BY Id];
        
        PageReference pageRef = Page.QuoteLineEditor; 
        pageRef.getParameters().put('id', lstTestQuote[0].Id);
        pageRef.getParameters().put('pid', lstTestProduct[0].Id);
        pageRef.getParameters().put('sid', lstTestProduct[0].Id);
        Test.setCurrentPage(pageRef);
        
        QuoteLineEditorController ctredt = new QuoteLineEditorController();
        ctredt.target_amount = 400;
        ctredt.btn_press = 'Save';
        ctredt.actionSave();
        ctredt.actionCalculate();
        ctredt.actionCancel();
        ctredt.gotoProducts();
        ctredt.closeCancelPopup();
        ctredt.closeDonePopup();   
        ctredt.closeDescPopup();   
        ctredt.showDescPopup();
    }    
    
    
    static testMethod void QLE3(){
        
        String ran = DataInsertFactory.insertQuote();
            
        List<SBQQ__Quote__c> lstTestQuote = new List<SBQQ__Quote__c>();
        lstTestQuote = [SELECT Id FROM SBQQ__Quote__c ORDER BY Id];
        
        List<Product2> lstTestProduct = new List<Product2>();
        lstTestProduct = [SELECT Id FROM Product2 ORDER BY Id];
        
        PageReference pageRef = Page.QuoteLineEditor; 
        pageRef.getParameters().put('id', lstTestQuote[0].Id);
        pageRef.getParameters().put('pid', lstTestProduct[0].Id);
        pageRef.getParameters().put('sid', lstTestProduct[0].Id);
        Test.setCurrentPage(pageRef);
        
        QuoteLineEditorController ctredt = new QuoteLineEditorController();
        ctredt.btn_press = 'Quick Save';
        ctredt.getDiscountOperator();
        ctredt.showPopup();
        ctredt.actionEdit();
        pageRef.getParameters().put('sid', lstTestProduct[0].Id + ran );
        ctredt.actionClone();
        pageRef.getParameters().put('sid', lstTestProduct[0].Id);
        ctredt.actionDelete();
  //      ctredt.actionQuickSave();
    }   
    
    
    static testMethod void QLE4(){
        
        String ran = DataInsertFactory.insertQuote();
        
        List<SBQQ__Quote__c> lstTestQuote = new List<SBQQ__Quote__c>();
        lstTestQuote = [SELECT Id FROM SBQQ__Quote__c ORDER BY Id];
        
        List<Product2> lstTestProduct = new List<Product2>();
        lstTestProduct = [SELECT Id FROM Product2 ORDER BY Id];
        
        PageReference pageRef = Page.QuoteLineEditor; 
        pageRef.getParameters().put('id', lstTestQuote[0].Id);
        pageRef.getParameters().put('pid', lstTestProduct[0].Id);
        pageRef.getParameters().put('sid', lstTestProduct[0].Id);
        Test.setCurrentPage(pageRef);
        
        QuoteLineEditorController ctredt = new QuoteLineEditorController();
        ctredt.btn_press = 'Quick Save';
        ctredt.actionSave();
        ctredt.actionCalculate();
        ctredt.actionCancel();
        ctredt.gotoProducts();
        ctredt.closeCancelPopup();
        ctredt.closeDonePopup();   
        ctredt.closeDescPopup();   
        ctredt.showDescPopup();
        ctredt.showTripsPopup();
        ctredt.cancelTripsPopup();
        ctredt.closeTripsPopup();
    }    
    
    static testMethod void QLE5(){
        
        String ran = DataInsertFactory.insertQuote();
        
        List<SBQQ__Quote__c> lstTestQuote = new List<SBQQ__Quote__c>();
        lstTestQuote = [SELECT Id FROM SBQQ__Quote__c ORDER BY Id];
        
        List<Product2> lstTestProduct = new List<Product2>();
        lstTestProduct = [SELECT Id FROM Product2 ORDER BY Id];
        
        PageReference pageRef = Page.QuoteLineEditor; 
        pageRef.getParameters().put('id', lstTestQuote[0].Id);
        pageRef.getParameters().put('pid', lstTestProduct[0].Id);
        pageRef.getParameters().put('sid', lstTestProduct[0].Id);
        pageRef.getParameters().put('value', 'Description');
        pageRef.getParameters().put('isParent', 'true');
        Test.setCurrentPage(pageRef);
        
        QuoteLineEditorController ctredt = new QuoteLineEditorController();
        ctredt.btn_press = 'Quick Save';
        ctredt.getDiscountOperator2();
        ctredt.calculatePallet();
        ctredt.calculateDelivery();
        ctredt.calculateDelivery2();
        ctredt.calculateDelivery3();
        ctredt.calculateDelivery4();
        ctredt.actionClearDiscount();
        ctredt.showDescPopup();
        ctredt.getDropSubstituteReason();
        ctredt.cancelSubstitutePopup();
        ctredt.actionSubstitute1();
        ctredt.actionSubstitute();
        ctredt.actionCancel2();
        ctredt.target_amount=500;
        ctredt.actionTarget();
        
        PageReference pageRef1 = Page.QuoteLineEditor; 
        pageRef1.getParameters().put('id', lstTestQuote[0].Id);
        pageRef1.getParameters().put('pid', lstTestProduct[0].Id);
        pageRef1.getParameters().put('sid', lstTestProduct[0].Id);
        pageRef1.getParameters().put('value', 'Configuration');
        pageRef1.getParameters().put('isParent', 'true');
        Test.setCurrentPage(pageRef1);
        
        QuoteLineEditorController ctredt1 = new QuoteLineEditorController();
        ctredt1.showDescPopup();
    }    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}