@isTest
public class BatchUpdateQuoteCCTest {

    static testMethod void testMethod1(){
        DataInsertFactory.insertQuote();
               
        Test.startTest();

             BatchUpdateQuoteCC obj = new  BatchUpdateQuoteCC();
            DataBase.executeBatch(obj);
        
           
        Test.stopTest();
    }
    
    static testMethod void testMethod2(){
        DataInsertFactory.insertQuote();
               
        Test.startTest();

             BatchUpdateUniqueOLI obj = new  BatchUpdateUniqueOLI();
            DataBase.executeBatch(obj);
        
           
        Test.stopTest();
    }
    
    static testMethod void testMethod3(){
        DataInsertFactory.insertQuote();
               
        SBQQ__Quote__c objTestQuote = new SBQQ__Quote__c();
        objTestQuote = [SELECT Id, Name, SBQQ__Account__c, Delivery_Total__c, Purchase_Number__c, SBQQ__Status__c FROM SBQQ__Quote__c LIMIT 1 ];
            system.debug('objTestQuote --> ' + objTestQuote );
        objTestQuote.SBQQ__Status__c = 'Add/Edit Products';
        update objTestQuote;
        objTestQuote.SBQQ__Status__c = 'Approval';
        update objTestQuote;
        objTestQuote.SBQQ__Status__c = 'Order';
        update objTestQuote;
        Order objOrderInsert = new Order();
            objOrderInsert.SBQQ__Quote__c = objTestQuote.Id;
        //    objOrderInsert.SBQQ__Contracted__c = false;
            objOrderInsert.AccountId = objTestQuote.SBQQ__Account__c;
            objOrderInsert.Status = 'Submitted';
            objOrderInsert.EffectiveDate = system.today();
            objOrderInsert.Delivery_Date__c = system.today();
            objOrderInsert.Delivery_Instruction__c = '';
            objOrderInsert.Pricebook2Id='01s300000006uBlAAI';
            objOrderInsert.Payment_Type__c = 'Credit Card';
            objOrderInsert.Delivery_Charge__c=objTestQuote.Delivery_Total__c;
            objOrderInsert.Purchase_Number__c=objTestQuote.Purchase_Number__c;
            objOrderInsert.Order_Reference_Number__c='test_orn';
            objOrderInsert.District_Id__c='';
            objOrderInsert.Territory_Id__c='';
            objOrderInsert.Order_Source__c='Salesforce';
            objOrderInsert.Type='Order';
            objOrderInsert.B2B_Order_Id__c='4321';
        insert objOrderInsert;
        
        
        Map<String, String> mapProductPriceBook = new Map<String, String>();
        List<PricebookEntry> lstTestPricebookEntry = new List<PricebookEntry>();
            lstTestPricebookEntry = [SELECT Id, Name, Product2Id  
                                 FROM PricebookEntry 
                                 WHERE  Pricebook2Id='01s300000006uBlAAI'
                                ];
            for(PricebookEntry pb:lstTestPricebookEntry){
                mapProductPriceBook.put(pb.Product2Id, pb.Id);
            }
        
      
        
        SBQQ__QuoteLine__c objQuoteLine = new SBQQ__QuoteLine__c();
        objQuoteLine = [SELECT Id, Name, SBQQ__Quantity__c, SBQQ__Product__c, SBQQ__Product__r.ProductCode, Feature__c, 
                        	ProductParentUnique__c, List_Price__c, Net_Unit_Price__c, Disposable_Fee__c 
                        FROM SBQQ__QuoteLine__c 
                        LIMIT 1 
                       ];
        
                OrderItem objOrderItemInsert = new OrderItem();
                objOrderItemInsert.OrderId = objOrderInsert.id;
                objOrderItemInsert.Quantity = objQuoteLine.SBQQ__Quantity__c;
                objOrderItemInsert.Product2Id = objQuoteLine.SBQQ__Product__c;
                objOrderItemInsert.PriceBookEntryId = mapProductPriceBook.get(objQuoteLine.SBQQ__Product__c);
                objOrderItemInsert.Configuration__c = '';
                objOrderItemInsert.Configuration_Description__c = '';
                objOrderItemInsert.Delivery_Date__c = system.today();
                objOrderItemInsert.Number__c = '10';
                objOrderItemInsert.Feature__c = objQuoteLine.Feature__c;
                objOrderItemInsert.isProductParent__c = true;
                objOrderItemInsert.ProductParentUnique__c = objQuoteLine.ProductParentUnique__c;
                objOrderItemInsert.List_Unit_Price__c = double.valueof(objQuoteLine.List_Price__c);
                objOrderItemInsert.Net_Unit_Price__c = double.valueof(objQuoteLine.Net_Unit_Price__c);
                objOrderItemInsert.UnitPrice = double.valueof(objQuoteLine.Net_Unit_Price__c);
                objOrderItemInsert.Disposable_Fee__c = double.valueof(objQuoteLine.Disposable_Fee__c);
                objOrderItemInsert.Order_Reference_Number__c=objOrderInsert.Order_Reference_Number__c;
                objOrderItemInsert.Unique_Value__c=objOrderInsert.Order_Reference_Number__c + objQuoteLine.SBQQ__Product__r.ProductCode ;
        		objOrderItemInsert.Tax_Rate__c = 0;
        		objOrderItemInsert.SBQQ__TaxAmount__c = 0;
        		objOrderItemInsert.Item_Tax__c = 0;
        
        insert objOrderItemInsert;
        
        
        Test.startTest();

             BatchUpdateMismatchOLI obj = new  BatchUpdateMismatchOLI();
            DataBase.executeBatch(obj);
        
           
        Test.stopTest();
    }
    
    static testMethod void testMethod4(){
        DataInsertFactory.insertQuote();
               
        SBQQ__Quote__c objTestQuote = new SBQQ__Quote__c();
        objTestQuote = [SELECT Id, Name, SBQQ__Account__c, Delivery_Total__c, Purchase_Number__c, SBQQ__Status__c FROM SBQQ__Quote__c LIMIT 1 ];
            system.debug('objTestQuote --> ' + objTestQuote );
        objTestQuote.SBQQ__Status__c = 'Add/Edit Products';
        update objTestQuote;
        objTestQuote.SBQQ__Status__c = 'Approval';
        update objTestQuote;
        objTestQuote.SBQQ__Status__c = 'Order';
        update objTestQuote;
        Order objOrderInsert = new Order();
            objOrderInsert.SBQQ__Quote__c = objTestQuote.Id;
        //    objOrderInsert.SBQQ__Contracted__c = false;
            objOrderInsert.AccountId = objTestQuote.SBQQ__Account__c;
            objOrderInsert.Status = 'Submitted';
            objOrderInsert.EffectiveDate = system.today();
            objOrderInsert.Delivery_Date__c = system.today();
            objOrderInsert.Delivery_Instruction__c = '';
            objOrderInsert.Pricebook2Id='01s300000006uBlAAI';
            objOrderInsert.Payment_Type__c = 'Credit Card';
            objOrderInsert.Delivery_Charge__c=objTestQuote.Delivery_Total__c;
            objOrderInsert.Purchase_Number__c=objTestQuote.Purchase_Number__c;
            objOrderInsert.Order_Reference_Number__c='test_orn';
            objOrderInsert.District_Id__c='';
            objOrderInsert.Territory_Id__c='';
            objOrderInsert.Order_Source__c='Salesforce';
            objOrderInsert.Type='Order';
            objOrderInsert.B2B_Order_Id__c='4321';
        insert objOrderInsert;
        
        
        Map<String, String> mapProductPriceBook = new Map<String, String>();
        List<PricebookEntry> lstTestPricebookEntry = new List<PricebookEntry>();
            lstTestPricebookEntry = [SELECT Id, Name, Product2Id  
                                 FROM PricebookEntry 
                                 WHERE  Pricebook2Id='01s300000006uBlAAI'
                                ];
            for(PricebookEntry pb:lstTestPricebookEntry){
                mapProductPriceBook.put(pb.Product2Id, pb.Id);
            }
        
      
        
        SBQQ__QuoteLine__c objQuoteLine = new SBQQ__QuoteLine__c();
        objQuoteLine = [SELECT Id, Name, SBQQ__Quantity__c, SBQQ__Product__c, SBQQ__Product__r.ProductCode, Feature__c, 
                        	ProductParentUnique__c, List_Price__c, Net_Unit_Price__c, Disposable_Fee__c 
                        FROM SBQQ__QuoteLine__c 
                        LIMIT 1 
                       ];
        
                OrderItem objOrderItemInsert = new OrderItem();
                objOrderItemInsert.OrderId = objOrderInsert.id;
                objOrderItemInsert.Quantity = objQuoteLine.SBQQ__Quantity__c;
                objOrderItemInsert.Product2Id = objQuoteLine.SBQQ__Product__c;
                objOrderItemInsert.PriceBookEntryId = mapProductPriceBook.get(objQuoteLine.SBQQ__Product__c);
                objOrderItemInsert.Configuration__c = '';
                objOrderItemInsert.Configuration_Description__c = '';
                objOrderItemInsert.Delivery_Date__c = system.today();
                objOrderItemInsert.Number__c = '10';
                objOrderItemInsert.Feature__c = objQuoteLine.Feature__c;
                objOrderItemInsert.isProductParent__c = true;
                objOrderItemInsert.ProductParentUnique__c = objQuoteLine.ProductParentUnique__c;
                objOrderItemInsert.List_Unit_Price__c = double.valueof(objQuoteLine.List_Price__c);
                objOrderItemInsert.Net_Unit_Price__c = double.valueof(objQuoteLine.Net_Unit_Price__c);
                objOrderItemInsert.UnitPrice = double.valueof(objQuoteLine.Net_Unit_Price__c);
                objOrderItemInsert.Disposable_Fee__c = double.valueof(objQuoteLine.Disposable_Fee__c);
                objOrderItemInsert.Order_Reference_Number__c=objOrderInsert.Order_Reference_Number__c;
                objOrderItemInsert.Unique_Value__c=objOrderInsert.Order_Reference_Number__c + objQuoteLine.SBQQ__Product__r.ProductCode ;
        		objOrderItemInsert.Tax_Rate__c = 0;
        		objOrderItemInsert.SBQQ__TaxAmount__c = 0;
        		objOrderItemInsert.Item_Tax__c = 0;
        
        insert objOrderItemInsert;
               
        Test.startTest();

             BatchUpdateDuplicateProducts obj = new  BatchUpdateDuplicateProducts();
            DataBase.executeBatch(obj);
        
           
        Test.stopTest();
    }
    
    static testMethod void testMethod5(){
        DataInsertFactory.insertQuote();
               
        SBQQ__Quote__c objTestQuote = new SBQQ__Quote__c();
        objTestQuote = [SELECT Id, Name, SBQQ__Account__c, Delivery_Total__c, Purchase_Number__c, SBQQ__Status__c FROM SBQQ__Quote__c LIMIT 1 ];
            system.debug('objTestQuote --> ' + objTestQuote );
        objTestQuote.SBQQ__Status__c = 'Add/Edit Products';
        update objTestQuote;
        objTestQuote.SBQQ__Status__c = 'Approval';
        update objTestQuote;
        objTestQuote.SBQQ__Status__c = 'Order';
        update objTestQuote;
        Order objOrderInsert = new Order();
            objOrderInsert.SBQQ__Quote__c = objTestQuote.Id;
        //    objOrderInsert.SBQQ__Contracted__c = false;
            objOrderInsert.AccountId = objTestQuote.SBQQ__Account__c;
            objOrderInsert.Status = 'Submitted';
            objOrderInsert.EffectiveDate = system.today();
            objOrderInsert.Delivery_Date__c = system.today();
            objOrderInsert.Delivery_Instruction__c = '';
            objOrderInsert.Pricebook2Id='01s300000006uBlAAI';
            objOrderInsert.Payment_Type__c = 'Credit Card';
            objOrderInsert.Delivery_Charge__c=objTestQuote.Delivery_Total__c;
            objOrderInsert.Purchase_Number__c=objTestQuote.Purchase_Number__c;
            objOrderInsert.Order_Reference_Number__c='test_orn';
            objOrderInsert.District_Id__c='';
            objOrderInsert.Territory_Id__c='';
            objOrderInsert.Order_Source__c='Salesforce';
            objOrderInsert.Type='Order';
            objOrderInsert.B2B_Order_Id__c='4321';
        insert objOrderInsert;
        
        
        Map<String, String> mapProductPriceBook = new Map<String, String>();
        List<PricebookEntry> lstTestPricebookEntry = new List<PricebookEntry>();
            lstTestPricebookEntry = [SELECT Id, Name, Product2Id  
                                 FROM PricebookEntry 
                                 WHERE  Pricebook2Id='01s300000006uBlAAI'
                                ];
            for(PricebookEntry pb:lstTestPricebookEntry){
                mapProductPriceBook.put(pb.Product2Id, pb.Id);
            }
        
      
        
        SBQQ__QuoteLine__c objQuoteLine = new SBQQ__QuoteLine__c();
        objQuoteLine = [SELECT Id, Name, SBQQ__Quantity__c, SBQQ__Product__c, SBQQ__Product__r.ProductCode, Feature__c, 
                        	ProductParentUnique__c, List_Price__c, Net_Unit_Price__c, Disposable_Fee__c 
                        FROM SBQQ__QuoteLine__c 
                        LIMIT 1 
                       ];
        
                OrderItem objOrderItemInsert = new OrderItem();
                objOrderItemInsert.OrderId = objOrderInsert.id;
                objOrderItemInsert.Quantity = objQuoteLine.SBQQ__Quantity__c;
                objOrderItemInsert.Product2Id = objQuoteLine.SBQQ__Product__c;
                objOrderItemInsert.PriceBookEntryId = mapProductPriceBook.get(objQuoteLine.SBQQ__Product__c);
                objOrderItemInsert.Configuration__c = '';
                objOrderItemInsert.Configuration_Description__c = '';
                objOrderItemInsert.Delivery_Date__c = system.today();
                objOrderItemInsert.Number__c = '10';
                objOrderItemInsert.Feature__c = objQuoteLine.Feature__c;
                objOrderItemInsert.isProductParent__c = true;
                objOrderItemInsert.ProductParentUnique__c = objQuoteLine.ProductParentUnique__c;
                objOrderItemInsert.List_Unit_Price__c = double.valueof(objQuoteLine.List_Price__c);
                objOrderItemInsert.Net_Unit_Price__c = double.valueof(objQuoteLine.Net_Unit_Price__c);
                objOrderItemInsert.UnitPrice = double.valueof(objQuoteLine.Net_Unit_Price__c);
                objOrderItemInsert.Disposable_Fee__c = double.valueof(objQuoteLine.Disposable_Fee__c);
                objOrderItemInsert.Order_Reference_Number__c=objOrderInsert.Order_Reference_Number__c;
                objOrderItemInsert.Unique_Value__c=objOrderInsert.Order_Reference_Number__c + objQuoteLine.SBQQ__Product__r.ProductCode ;
        		objOrderItemInsert.Tax_Rate__c = 0;
        		objOrderItemInsert.SBQQ__TaxAmount__c = 0;
        		objOrderItemInsert.Item_Tax__c = 0;
        
        insert objOrderItemInsert;
               
        Test.startTest();

             BatchUpdateUnitPrice obj = new  BatchUpdateUnitPrice();
            DataBase.executeBatch(obj);
        
           
        Test.stopTest();
    }
    
    static testMethod void testMethod6(){
        DataInsertFactory.insertQuote();
        Account objAccount = new Account();
        objAccount = [SELECT Id FROM Account LIMIT 1];
        
        Invoice__c inv = new Invoice__c();
        inv.Parent_Account__c = objAccount.Id;
        insert inv;

        Invoice_Line_Item__c ili = new Invoice_Line_Item__c(Invoice__c = inv.Id, Invoice_Date__c = system.today(), Pay_Type__c = 'SCO' );
        insert ili;
        
        Test.startTest();
        BatchInvoiceDatePay obj = new  BatchInvoiceDatePay();
        DataBase.executeBatch(obj);
        Test.stopTest();
    }
    
    
    
    
}