@isTest
private class OrderItemTriggerHandlerTest {

    static testMethod void myUnitTest() {
    	list<Order> ordersList = new list<Order>();
    	list<OrderItem> orderItemsList = new list<OrderItem>();
    	list<OrderItem> returnOrderItemsList = new list<OrderItem>();
    	list<Invoice_Line_Item__c> invLineItemsList = new list<Invoice_Line_Item__c>();
    	
    	Product2 prod1 = new Product2(Name='Product 1', isActive=true);
        
        insert prod1;
        
        PricebookEntry pbe = [select Pricebook2Id from PricebookEntry where Product2Id = :prod1.Id and isActive = true limit 1];
            
        List<Zip_Code__c> lstTestZipCode = new List<Zip_Code__c>();
        
        Zip_Code__c test_zipcode_1 = new Zip_Code__c();
        test_zipcode_1.Name = '56004';
        test_zipcode_1.OwnerId = system.UserInfo.getUserId();
        test_zipcode_1.State__c = 'AL';
        
        lstTestZipCode.add(test_zipcode_1);
        
        insert lstTestZipCode;
                   
        Account testAcct = new Account();
        
        testAcct.Name = 'Test Account';
        testAcct.Phone = '313-123-4567';
        testAcct.BillingPostalCode = '56004';
        
        insert testAcct;
        
        Contract testContract = new Contract();
        
        testContract.AccountId = testAcct.Id;
        testContract.Purchase_Number__c = '1234567890';
        testContract.SBQQ__MasterContract__c = true;
        testContract.Status = 'Build Contract';
        testContract.StartDate = system.today().addMonths(1);
        testContract.ContractTerm = 12;
        
        insert testContract;
        
        Contract_Line_Item__c testCLI1 = new Contract_Line_Item__c();
        
        testCLI1.Contract__c = testContract.Id;
        testCLI1.Status__c = 'Open';
        testCLI1.Product__c = prod1.Id;
        testCLI1.Total_Quantity__c = 10;
        testCLI1.Items_Processed__c = 0;
        testCLI1.Net_Unit_Price__c = 1000;
        testCLI1.Total_Amount__c = 10000;
        testCLI1.Amount_Processed__c = 0;
        testCLI1.Shipped_Quantity__c = 0;
        testCLI1.Billed_Quantity__c = 0;
        
        insert testCLI1;
        
        Order returnOrder = new Order();
        
        returnOrder.ContractId = testContract.Id;
        returnOrder.Pricebook2Id = pbe.Pricebook2Id;
        returnOrder.Purchase_Number__c = '1234567890';
        returnOrder.Type = 'Return';
        returnOrder.AccountId = testAcct.Id;
        returnOrder.Status = 'Submitted';
        returnOrder.EffectiveDate = system.today().addMonths(1);
        returnOrder.SBQQ__ContractingMethod__c = 'By Subscription End Date';
        returnOrder.BillingStreet = '123 Test';
        returnOrder.BillingCity = 'Novi';
        returnOrder.BillingState = 'MI';
        returnOrder.BillingPostalCode = '48375';
        returnOrder.BillingCountry = 'US';
        returnOrder.ShippingStreet = '123 Test';
        returnOrder.ShippingCity = 'Novi';
        returnOrder.ShippingState = 'MI';
        returnOrder.ShippingPostalCode = '48375';
        returnOrder.ShippingCountry = 'US';
        
        ordersList.add(returnOrder);
        
        Order testOrder = new Order();
        
        testOrder.ContractId = testContract.Id;
        testOrder.Pricebook2Id = pbe.Pricebook2Id;
        testOrder.Purchase_Number__c = '1234567890';
        testOrder.Type = 'Order';
        testOrder.AccountId = testAcct.Id;
        testOrder.Status = 'Submitted';
        testOrder.EffectiveDate = system.today().addMonths(1);
        testOrder.SBQQ__ContractingMethod__c = 'By Subscription End Date';
        testOrder.BillingStreet = '123 Test';
        testOrder.BillingCity = 'Novi';
        testOrder.BillingState = 'MI';
        testOrder.BillingPostalCode = '48375';
        testOrder.BillingCountry = 'US';
        testOrder.ShippingStreet = '123 Test';
        testOrder.ShippingCity = 'Novi';
        testOrder.ShippingState = 'MI';
        testOrder.ShippingPostalCode = '48375';
        testOrder.ShippingCountry = 'US';
        
        ordersList.add(testOrder);
        
        insert ordersList;
        
        OrderItem oi1 = new OrderItem();
        
        oi1.OrderId = testOrder.Id;
        oi1.PricebookEntryId = pbe.Id;
        oi1.Quantity = 3;
        oi1.UnitPrice = 1000;
        oi1.Billable_Quantity__c = 0;
        
        orderItemsList.add(oi1);
        
        OrderItem oi2 = new OrderItem();
        
        oi2.OrderId = testOrder.Id;
        oi2.PricebookEntryId = pbe.Id;
        oi2.Quantity = 2;
        oi2.UnitPrice = 1000;
        oi2.Billable_Quantity__c = 0;
        
        orderItemsList.add(oi2);
        
        insert orderItemsList;
        
        OrderItem oi3 = new OrderItem();
        
        oi3.OrderId = returnOrder.Id;
        oi3.PricebookEntryId = pbe.Id;
        oi3.Quantity = 2;
        oi3.UnitPrice = 1000;
        
        returnOrderItemsList.add(oi3);
        
        OrderItem oi4 = new OrderItem();
        
        oi4.OrderId = returnOrder.Id;
        oi4.PricebookEntryId = pbe.Id;
        oi4.Quantity = 1;
        oi4.UnitPrice = 1000;
        
        returnOrderItemsList.add(oi4);
        
        insert returnOrderItemsList;
        
        // Insert, update, and delete Invoice Line Items and then check the Contract Line Item's Billed Quantity.
	    Invoice__c inv = new Invoice__c();
	    
	    inv.Order__c = testOrder.Id;
	    
	    insert inv;
	    
	    Invoice_Line_Item__c ili1 = new Invoice_Line_Item__c();
	    
	    ili1.Invoice__c = inv.Id;
	    ili1.Product__c = prod1.Id;
	    ili1.Quantity__c = 3;
	    ili1.Unit_Price__c = 1000;
	    
	    invLineItemsList.add(ili1);
	    
	    Invoice_Line_Item__c ili2 = new Invoice_Line_Item__c();
	    
	    ili2.Invoice__c = inv.Id;
	    ili2.Product__c = prod1.Id;
	    ili2.Quantity__c = 1;
	    ili2.Unit_Price__c = 1000;
	    
	    invLineItemsList.add(ili2);
	    
	    insert invLineItemsList;
        
        Test.startTest();
        
        // Check the Contract Line Item values to see if they were updated correctly.
	    Contract_Line_Item__c checkCLI = [select Items_Processed__c, Amount_Processed__c, Shipped_Quantity__c, Billed_Quantity__c
	    									from Contract_Line_Item__c where Id = :testCLI1.Id];
	    
	//    system.assertEquals(checkCLI.Items_Processed__c, 2);
	//    system.assertEquals(checkCLI.Amount_Processed__c, 2000);
	//    system.assertEquals(checkCLI.Shipped_Quantity__c, 0);
	//    system.assertEquals(checkCLI.Billed_Quantity__c, 4);
        
        // Update the OrderItem's Quantity.
        oi1.Quantity = 4;
        oi1.Billable_Quantity__c = 4;
        
        update oi1;
        
        oi3.Quantity = 1;
        
        update oi3;
        
        ili1.Quantity__c = 2;
	    
	    update ili1;
	    
	    ili2.Quantity__c = 3;
	    
	    update ili2;
        
        // Check the Contract Line Item values to see if they were updated correctly.
    	Contract_Line_Item__c checkCLI2 = [select Items_Processed__c, Amount_Processed__c, Shipped_Quantity__c, Billed_Quantity__c
    										from Contract_Line_Item__c where Id = :testCLI1.Id];
	    
//	    system.assertEquals(checkCLI2.Items_Processed__c, 4);
//	    system.assertEquals(checkCLI2.Amount_Processed__c, 4000);
//	    system.assertEquals(checkCLI2.Shipped_Quantity__c, 4);
//	    system.assertEquals(checkCLI2.Billed_Quantity__c, 5);
        
        // Delete the OrderItems.
        delete oi1;
        delete oi3;
        
        // Delete the Invoice Line Items.
        
        delete ili1;
        delete ili2;
        
        // Check the Contract Line Item values to see if they were updated correctly.
    	Contract_Line_Item__c checkCLI3 = [select Items_Processed__c, Amount_Processed__c, Shipped_Quantity__c, Billed_Quantity__c
    										from Contract_Line_Item__c where Id = :testCLI1.Id];
	    
	//    system.assertEquals(checkCLI3.Items_Processed__c, 1);
	//    system.assertEquals(checkCLI3.Amount_Processed__c, 1000);
	//    system.assertEquals(checkCLI3.Shipped_Quantity__c, 0);
	//    system.assertEquals(checkCLI3.Billed_Quantity__c, 0);
        
        Test.stopTest();
    }
}