@isTest
public class OrderTest {
    
    static testMethod void test_OrderQuote1(){
        
        String ran = DataInsertFactory.insertQuote();
            
        List<Territory__c> lstTestTerritory = new List<Territory__c>();
        lstTestTerritory = [SELECT Id FROM Territory__c ORDER BY Id];
        system.debug('lstTestTerritory[0].Id--> ' + lstTestTerritory[0].Id );
        
        List<Account> lstTestAccount = new List<Account>();
        lstTestAccount = [SELECT Id, NewTerritory__c FROM Account ORDER BY Id];
        system.debug('lstTestAccount[0].NewTerritory__c--> ' + lstTestAccount[0].NewTerritory__c );
        
        for(Account acc:lstTestAccount){
            acc.NewTerritory__c = lstTestTerritory[0].Id;
        }
        update lstTestAccount;
        
        
        List<SBQQ__Quote__c> lstTestQuote = new List<SBQQ__Quote__c>();
        lstTestQuote = [SELECT Id FROM SBQQ__Quote__c ORDER BY Id];
        
        List<Product2> lstTestProduct = new List<Product2>();
        lstTestProduct = [SELECT Id FROM Product2 ORDER BY Id];
       
        PageReference pageRef = Page.OrderQuote; 
        pageRef.getParameters().put('id', lstTestQuote[0].Id);
        pageRef.getParameters().put('pay', 'Credit Account');
        Test.setCurrentPage(pageRef);

    //    ApexPages.StandardController sc = new ApexPages.StandardController(lstTestQuote[0]);
    //    OrderQuoteController ctredt = new OrderQuoteController(sc);
   //     ApexPages.StandardController sc = new ApexPages.StandardController(lstTestQuote[0]);
        OrderQuoteController ctredt = new OrderQuoteController();
        pageRef.getParameters().put('id', lstTestQuote[0].Id);
    //    ctredt.isOnboarded = true;
        ctredt.redirectQLE();
        ctredt.paymentType = 'Credit Account';
        ctredt.calculateDeliveryDates();
        ctredt.actionSend();
        ctredt.delDate='12-01-2025';
        ctredt.actionSend();
        ctredt.getDeliveryDate();
        ctredt.getPaymentMethod();
        ctredt.actionSubstitute();
        ctredt.actionCancel();
        
        OrderQuoteController ctredt1 = new OrderQuoteController();
        pageRef.getParameters().put('id', lstTestQuote[0].Id);
        ctredt1.redirectQLE();

    } 
    /*
    static testMethod void test_OrderQuote(){
        
        String ran = DataInsertFactory.insertQuote();
            
        List<SBQQ__Quote__c> lstTestQuote = new List<SBQQ__Quote__c>();
        lstTestQuote = [SELECT Id FROM SBQQ__Quote__c ORDER BY Id];
        
        List<Product2> lstTestProduct = new List<Product2>();
        lstTestProduct = [SELECT Id FROM Product2 ORDER BY Id];
       
        PageReference pageRef = Page.OrderQuote; 
        pageRef.getParameters().put('id', lstTestQuote[0].Id);
        pageRef.getParameters().put('pay', 'Credit Account');
        Test.setCurrentPage(pageRef);

    //    ApexPages.StandardController sc = new ApexPages.StandardController(lstTestQuote[0]);
    //    OrderQuoteController ctredt = new OrderQuoteController(sc);
   //     ApexPages.StandardController sc = new ApexPages.StandardController(lstTestQuote[0]);
        OrderQuoteController ctredt = new OrderQuoteController();
        pageRef.getParameters().put('id', lstTestQuote[0].Id);
    //    ctredt.isOnboarded = true;
        ctredt.redirectQLE();
        ctredt.getPaymentMethod();
        ctredt.getDeliveryDate();
        ctredt.actionSend();
        ctredt.delDate = string.valueof(system.today());
    //    ctredt.actionSend();
        ctredt.actionSubstitute();
        ctredt.actionCancel();
        

    } 
    */
    
    static testMethod void test_OrderContract1(){
        
        String ran = DataInsertFactory.insertQuote();
            
        List<Territory__c> lstTestTerritory = new List<Territory__c>();
        lstTestTerritory = [SELECT Id FROM Territory__c ORDER BY Id];
        system.debug('lstTestTerritory[0].Id--> ' + lstTestTerritory[0].Id );
        
        List<Account> lstTestAccount = new List<Account>();
        lstTestAccount = [SELECT Id, NewTerritory__c FROM Account ORDER BY Id];
        system.debug('lstTestAccount[0].NewTerritory__c--> ' + lstTestAccount[0].NewTerritory__c );
        
        for(Account acc:lstTestAccount){
            acc.NewTerritory__c = lstTestTerritory[0].Id;
        }
        update lstTestAccount;
        
        List<SBQQ__Quote__c> lstTestQuote = new List<SBQQ__Quote__c>();
        lstTestQuote = [SELECT Id FROM SBQQ__Quote__c ORDER BY Id];
        
        List<Product2> lstTestProduct = new List<Product2>();
        lstTestProduct = [SELECT Id FROM Product2 ORDER BY Id];

        List<Contract> lstTestContract = new List<Contract>();
        lstTestContract = [SELECT Id FROM Contract ORDER BY Id];
                
       
        PageReference pageRef = Page.OrderQuote; 
        pageRef.getParameters().put('id', lstTestContract[0].Id);
    //    pageRef.getParameters().put('pay', 'check');
        Test.setCurrentPage(pageRef);

        OrderSelectionController ctredt = new OrderSelectionController();
        ctredt.actionAddSelection();
        ctredt.actionProductAvailability2();
        ctredt.paymentType = 'Credit Account';
     //   ctredt.orderreferencenumber = '1234';
        ctredt.calculateDeliveryDates();
        ctredt.actionSend();
        ctredt.delDate=string.valueof(system.today().month()) + '-' + string.valueof(system.today().day()) + '-' + string.valueof(system.today().year()) ;//'12-01-2018';
        ctredt.actionSend();
        
        
        ctredt.actionCancel();
        ctredt.actionCreateOrder();
    //    ctredt.actionSend();
        ctredt.closePopup();
        ctredt.actionSubstitute();
        ctredt.actionBackOrder();
        ctredt.getPaymentMethod();
        ctredt.getDeliveryDate();
        
        
        OrderSelectionController ctredt1 = new OrderSelectionController();
        pageRef.getParameters().put('id', lstTestContract[0].Id);
      //  ctredt1.redirectQLE();
        
        /*
    //    ctredt.isOnboarded = true;
        ctredt.actionAddSelection();
        ctredt.getPaymentMethod();
        ctredt.getDeliveryDate();
        ctredt.actionSend();
        ctredt.actionSubstitute();
        ctredt.actionCancel();
        */

    } 
    
    
    static testMethod void test_OrderQuote2(){
        
        String ran = DataInsertFactory.insertQuote();

        List<Territory__c> lstTestTerritory = new List<Territory__c>();
        lstTestTerritory = [SELECT Id FROM Territory__c ORDER BY Id];
        system.debug('lstTestTerritory[0].Id--> ' + lstTestTerritory[0].Id );
        
        List<Account> lstTestAccount = new List<Account>();
        lstTestAccount = [SELECT Id, NewTerritory__c FROM Account ORDER BY Id];
        system.debug('lstTestAccount[0].NewTerritory__c--> ' + lstTestAccount[0].NewTerritory__c );
        
        for(Account acc:lstTestAccount){
            acc.NewTerritory__c = lstTestTerritory[0].Id;
        }
        update lstTestAccount;
        
        List<SBQQ__Quote__c> lstTestQuote = new List<SBQQ__Quote__c>();
        lstTestQuote = [SELECT Id FROM SBQQ__Quote__c ORDER BY Id];
        
        List<Product2> lstTestProduct = new List<Product2>();
        lstTestProduct = [SELECT Id FROM Product2 ORDER BY Id];
       
        PageReference pageRef = Page.OrderQuote; 
        pageRef.getParameters().put('id', lstTestQuote[0].Id);
        pageRef.getParameters().put('pay', 'Credit Card');
        Test.setCurrentPage(pageRef);

    //    ApexPages.StandardController sc = new ApexPages.StandardController(lstTestQuote[0]);
    //    OrderQuoteController ctredt = new OrderQuoteController(sc);
   //     ApexPages.StandardController sc = new ApexPages.StandardController(lstTestQuote[0]);
        OrderQuoteController ctredt = new OrderQuoteController();
        pageRef.getParameters().put('id', lstTestQuote[0].Id);
    //    ctredt.isOnboarded = true;
        ctredt.redirectQLE();
        ctredt.getAddressTypeDropDown();
        ctredt.getCommonCarrierDropdown();
        ctredt.getStorePickup();
        pageRef.getParameters().put('selAT', 'Shipping Address');
        ctredt.CCA_Location = '4291';
        ctredt.saveAddressType();
        ctredt.saveLocation();
        pageRef.getParameters().put('selAT', 'Store Pickup');
        ctredt.saveAddressType();
        ctredt.selectedPickupStore = '001570';
        ctredt.pu_firstname = 'fn';
        ctredt.pu_lastname = 'ln';
        ctredt.pu_email = 'fn@ln.com';
        ctredt.pu_phone = '1234567890';
        ctredt.savePickup();
        
        ctredt.paymentType = 'Credit Card';
        ctredt.getPaymentMethod();
        ctredt.getCreditCardPaymentMethod();
        ctredt.actionPayment();
        ctredt.actionCreditCardPayment();
        
        
    } 
    
    
    
    /*
    static testMethod void test_OrderContract(){
        
        String ran = DataInsertFactory.insertQuote();
            
        List<SBQQ__Quote__c> lstTestQuote = new List<SBQQ__Quote__c>();
        lstTestQuote = [SELECT Id FROM SBQQ__Quote__c ORDER BY Id];
        
        List<Product2> lstTestProduct = new List<Product2>();
        lstTestProduct = [SELECT Id FROM Product2 ORDER BY Id];

        List<Contract> lstTestContract = new List<Contract>();
        lstTestContract = [SELECT Id FROM Contract ORDER BY Id];
                
       
        PageReference pageRef = Page.OrderQuote; 
        pageRef.getParameters().put('id', lstTestContract[0].Id);
    //    pageRef.getParameters().put('pay', 'check');
        Test.setCurrentPage(pageRef);

        OrderSelectionController ctredt = new OrderSelectionController();
        ctredt.actionAddSelection();
        ctredt.actionProductAvailability2();
        ctredt.actionCancel();
        ctredt.actionCreateOrder();
        ctredt.actionSend();
        ctredt.closePopup();
        ctredt.actionSubstitute();
        ctredt.actionBackOrder();
        ctredt.getPaymentMethod();
        ctredt.getDeliveryDate();
        /*
    //    ctredt.isOnboarded = true;
        ctredt.actionAddSelection();
        ctredt.getPaymentMethod();
        ctredt.getDeliveryDate();
        ctredt.actionSend();
        ctredt.actionSubstitute();
        ctredt.actionCancel();
        *

    } 
    */
    
}