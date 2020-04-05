@isTest
public class ButtonGroupControllerTest {
    
    static testMethod void test_QuoteButtonGroup(){
        
        String ran = DataInsertFactory.insertQuote();
            
        List<SBQQ__Quote__c> lstTestQuote = new List<SBQQ__Quote__c>();
        lstTestQuote = [SELECT Id FROM SBQQ__Quote__c ORDER BY Id];
        
        List<Product2> lstTestProduct = new List<Product2>();
        lstTestProduct = [SELECT Id FROM Product2 ORDER BY Id];
        
        PageReference pageRef = Page.QuoteButtonGroup; 
        pageRef.getParameters().put('id', lstTestQuote[0].Id);
        Test.setCurrentPage(pageRef);
        
        QuoteButtonGroupController ctredt = new QuoteButtonGroupController();
        ctredt.gotoQuoteLineEditor();
        ctredt.gotoGenerateDocument();
        ctredt.gotoQuoteOrder();
        ctredt.gotoQuoteContract();
        ctredt.gotoQuoteAttachment();
        ctredt.gotoApprovalProcess();
        
        PageReference pageRef2 = Page.QuoteCredit; 
        pageRef2.getParameters().put('id', lstTestQuote[0].Id);
        Test.setCurrentPage(pageRef2);

        ApexPages.StandardController sc = new ApexPages.StandardController(lstTestQuote[0]);
        QuoteCreditController ctredt2 = new QuoteCreditController(sc);
        ctredt2.isOnboarded = true;
        ctredt2.redirectQLE();
        ctredt2.actionSend();
        ctredt2.selectedPayment = 'Check';
        ctredt2.actionSend();
        ctredt2.actionCancel();
        ctredt2.actionSelected();
        
    }   
    
    static testMethod void test_ContractButtonGroup(){
        
        String ran = DataInsertFactory.insertQuote();
            
        List<SBQQ__Quote__c> lstTestQuote = new List<SBQQ__Quote__c>();
        lstTestQuote = [SELECT Id FROM SBQQ__Quote__c ORDER BY Id];
        
        List<Product2> lstTestProduct = new List<Product2>();
        lstTestProduct = [SELECT Id FROM Product2 ORDER BY Id];
        
        List<Contract> lstTestContract = new List<Contract>();
        lstTestContract = [SELECT Id FROM Contract ORDER BY Id];
        
        PageReference pageRef = Page.ContractButtonGroup; 
        pageRef.getParameters().put('id', lstTestContract[0].Id);
        Test.setCurrentPage(pageRef);
        
        ContractButtonGroupController ctredt = new ContractButtonGroupController();
        ctredt.gotoContractAttachment();
        ctredt.gotoContractRider();
        ctredt.gotoForecast();
        ctredt.gotoCreateOrder();
        ctredt.gotoCustomerSign();
        ctredt.gotoCustomerSign2();
        ctredt.gotoApproval();
        
        PageReference pageRef2 = Page.ContractRiderBuilder; 
        pageRef2.getParameters().put('id', lstTestContract[0].Id);
        pageRef2.getParameters().put('ord', '1');
        Test.setCurrentPage(pageRef2);

        List<Contract_Rider__c> lstSelDefaultRider = new List<Contract_Rider__c>();
        Contract_Rider__c objSelDefaultRider1 = new Contract_Rider__c(Title__c = 'Title 1', Description__c = 'Description 1', Contract__c = lstTestContract[0].Id, Sort_Order__c = 1, isDefault__c = true);
        lstSelDefaultRider.add(objSelDefaultRider1);
        Contract_Rider__c objSelDefaultRider2 = new Contract_Rider__c(Title__c = 'Title 2', Description__c = 'Description 2', Contract__c = lstTestContract[0].Id, Sort_Order__c = 2, isDefault__c = false);
        lstSelDefaultRider.add(objSelDefaultRider2);
        insert lstSelDefaultRider;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(lstTestContract[0]);
        ContractRiderBuilderController ctredt2 = new ContractRiderBuilderController(sc);
        ctredt2.addDefaults2();
        ctredt2.addDefaults();
        ctredt2.addCondition();
        ctredt2.addedTitle = 'addedTitle';
        ctredt2.addSelectedCondition();
        ctredt2.CancelPopup();
        ctredt2.addSelectedCondition2();
        ctredt2.selectAllDefault();
        ctredt2.CancelPopup2();
        ctredt2.actionQuickSave();
        ctredt2.actionSave();
        ctredt2.actionSaveGenerate();
        ctredt2.actionSaveHelper();
        ctredt2.actionCancel();
        ctredt2.GoToDocument();
      //  ctredt2.actionUp();
      //  ctredt2.actionDown();
        ctredt2.actionDelete();
        ctredt2.createDocument();
        
        
    }   
    
    static testMethod void test_OpportunityButtonGroup(){
        
        String ran = DataInsertFactory.insertQuote();
        List<Opportunity> lstTestOpportunity = new List<Opportunity>();
        lstTestOpportunity = [SELECT Id FROM Opportunity ORDER BY Id];
        
        PageReference pageRef = Page.OpportunityButtonGroup; 
        pageRef.getParameters().put('id', lstTestOpportunity[0].Id);
        Test.setCurrentPage(pageRef);
        
        
        OpportunityButtonGroupController ctredt = new OpportunityButtonGroupController();
     ctredt.gotoMSASign();
    }
    
}