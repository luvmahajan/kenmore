public class AdjustmentFactory {

	public static String insertBasics(){
        
        /****************** Insert Common Carrier Override Zipcode ****************/   
        
        List<CommonCarrierOverrideZipcode__c> lstTestCCOZ = new List<CommonCarrierOverrideZipcode__c>();
        
        CommonCarrierOverrideZipcode__c test_ccoz_1 = new CommonCarrierOverrideZipcode__c();
        test_ccoz_1.Zipcode__c = '98161';
        test_ccoz_1.DISTNET__c = 'C';
        test_ccoz_1.PLANT__c = 'ZSDO';
        test_ccoz_1.USLOC__c = '8766';
        test_ccoz_1.Frequency__c = 'WILLCALL';
        test_ccoz_1.Leaddays__c = 0;
        test_ccoz_1.Delzone__c = 1;
        test_ccoz_1.Installzone__c = 1;
        test_ccoz_1.Shipzone__c = 7;
        lstTestCCOZ.add(test_ccoz_1);
        
        CommonCarrierOverrideZipcode__c test_ccoz_2 = new CommonCarrierOverrideZipcode__c();
        test_ccoz_2.Zipcode__c = '60179';
        test_ccoz_2.DISTNET__c = 'M';
        test_ccoz_2.PLANT__c = 'ZMDO';
    //    test_ccoz_2.USLOC__c = null;
        test_ccoz_2.Frequency__c = 'Tes1';
        test_ccoz_2.Leaddays__c = 1;
        test_ccoz_2.Delzone__c = 2;
        test_ccoz_2.Installzone__c = 1;
        test_ccoz_2.Shipzone__c = 2;
        lstTestCCOZ.add(test_ccoz_2);
        
        
        insert lstTestCCOZ;
        
        
        
        /****************** Insert Custom Settings ****************/  
        
        List<Common_Variables__c> lstCommmonVariables = new List<Common_Variables__c>();
        
    //    Common_Variables__c cv_DiscountMargin = new Common_Variables__c(Name = 'Discount_Margin', Content__c = '19');
    //    lstCommmonVariables.add(cv_DiscountMargin);
        Common_Variables__c cv_b2bclientid = new Common_Variables__c(Name = 'B2BProd_ClientId', Content__c = '19');
        lstCommmonVariables.add(cv_b2bclientid);
        Common_Variables__c cv_b2bclientsecret = new Common_Variables__c(Name = 'B2BProd_ClientSecret', Content__c = '19');
        lstCommmonVariables.add(cv_b2bclientsecret);
        Common_Variables__c cv_b2bkdclientid = new Common_Variables__c(Name = 'B2BProd_KD_ClientId', Content__c = '19');
        lstCommmonVariables.add(cv_b2bkdclientid);
        Common_Variables__c cv_b2bkdclientsecret = new Common_Variables__c(Name = 'B2BProd_KD_ClientSecret', Content__c = '19');
        lstCommmonVariables.add(cv_b2bkdclientsecret);
        Common_Variables__c cv_b2bcontenttype = new Common_Variables__c(Name = 'B2BProd_ContentType_XML', Content__c = '19');
        lstCommmonVariables.add(cv_b2bcontenttype);
    //    Common_Variables__c cv_b2bendpoint = new Common_Variables__c(Name = 'B2BProd_EndPoint', Content__c = '19');
        Common_Variables__c cv_b2bendpoint = new Common_Variables__c(Name = 'B2BProd_Address_Val_API_URL', Content__c = '19');
        lstCommmonVariables.add(cv_b2bendpoint);
        Common_Variables__c cv_b2bdeliveryurl = new Common_Variables__c(Name = 'B2BProd_Delivery_Service_URL', Content__c = '19');
        lstCommmonVariables.add(cv_b2bdeliveryurl);
        Common_Variables__c cv_b2btaxurl = new Common_Variables__c(Name = 'B2BProd_Tax_API_URL', Content__c = '19');
        lstCommmonVariables.add(cv_b2btaxurl);
        Common_Variables__c cv_b2bprodavail = new Common_Variables__c(Name = 'B2BProd_ProductAvailability', Content__c = '19');
        lstCommmonVariables.add(cv_b2bprodavail);
        Common_Variables__c cv_b2bstorezip = new Common_Variables__c(Name = 'B2BProd_StoreZip', Content__c = '19');
        lstCommmonVariables.add(cv_b2bstorezip);
        Common_Variables__c cv_delivery_cost = new Common_Variables__c(Name = 'Delivery_Trip_Cost', Content__c = '19');
        lstCommmonVariables.add(cv_delivery_cost);
        Common_Variables__c cv_demar_auth = new Common_Variables__c(Name = 'DEMAR_Authorization', Content__c = '19');
        lstCommmonVariables.add(cv_demar_auth);
        Common_Variables__c cv_demar_content = new Common_Variables__c(Name = 'DEMAR_ContentType', Content__c = '19');
        lstCommmonVariables.add(cv_demar_content);
        Common_Variables__c cv_demar_rating = new Common_Variables__c(Name = 'DEMAR_Rating_URL', Content__c = '19');
        lstCommmonVariables.add(cv_demar_rating);
        Common_Variables__c cv_create_order = new Common_Variables__c(Name = 'B2BProd_Create Order_URL', Content__c = '19');
        lstCommmonVariables.add(cv_create_order);
        Common_Variables__c cv_delivery_dates = new Common_Variables__c(Name = 'B2BProd_Delivery_Dates_URL', Content__c = '19');
        lstCommmonVariables.add(cv_delivery_dates);
        Common_Variables__c cv_service_install = new Common_Variables__c(Name = 'B2BProd_Service_Install_URL', Content__c = '19');
        lstCommmonVariables.add(cv_service_install);
        Common_Variables__c cv_adjustment_calendar_api = new Common_Variables__c(Name = 'Adjustment_Calendar_API', Content__c = '19');
        lstCommmonVariables.add(cv_adjustment_calendar_api);
        Common_Variables__c cv_adjustment_payment_api = new Common_Variables__c(Name = 'Adjustment_Payment_API', Content__c = '19');
        lstCommmonVariables.add(cv_adjustment_payment_api);
        Common_Variables__c cv_adjustment_payment_auth = new Common_Variables__c(Name = 'Adjustment_Payment_Auth', Content__c = '19');
        lstCommmonVariables.add(cv_adjustment_payment_auth);
        Common_Variables__c cv_adjustment_payment_ldap_user = new Common_Variables__c(Name = 'Adjustment_Payment_LDAP_User', Content__c = '19');
        lstCommmonVariables.add(cv_adjustment_payment_ldap_user);
        Common_Variables__c cv_adjustment_order_api = new Common_Variables__c(Name = 'Adjustment_Order_API', Content__c = '19');
        lstCommmonVariables.add(cv_adjustment_order_api);
        Common_Variables__c cv_order_detail_api = new Common_Variables__c(Name = 'Order_Detail_API', Content__c = '19');
        lstCommmonVariables.add(cv_order_detail_api);
        Common_Variables__c cv_order_detail_client_id = new Common_Variables__c(Name = 'Order_Detail_Client_Id', Content__c = '19');
        lstCommmonVariables.add(cv_order_detail_client_id);
        Common_Variables__c cv_order_detail_client_secret = new Common_Variables__c(Name = 'Order_Detail_Client_Secret', Content__c = '19');
        lstCommmonVariables.add(cv_order_detail_client_secret);
        
        insert lstCommmonVariables;
        
        
        /****************** Insert Zip Code ****************/   
        
        List<Zip_Code__c> lstTestZipCode = new List<Zip_Code__c>();
        
        Zip_Code__c test_zipcode_1 = new Zip_Code__c();
        test_zipcode_1.Name = '60179';
        test_zipcode_1.OwnerId = system.UserInfo.getUserId();
        test_zipcode_1.State__c = 'IL';
        
        lstTestZipCode.add(test_zipcode_1);
        
        insert lstTestZipCode;
                
        /****************** Insert Territory ****************/   
        
        List<Territory__c> lstTestTerritory = new List<Territory__c>();
        
        Territory__c test_territory_1 = new Territory__c();
        test_territory_1.Name = '12321';
        test_territory_1.Territory_ID__c = '12321';
        test_territory_1.District_Territory_ID__c = '12321';
        
        lstTestTerritory.add(test_territory_1);
        
        insert lstTestTerritory;
        
        /****************** Insert Account ****************/   
        
        List<Account> lstTestAccount = new List<Account>();
        
        Account test_account_1 = new Account();
        test_account_1.Name = 'Test Account 1';
        test_account_1.Pricing_Tier__c = 'Bronze';
        test_account_1.BillingStreet = '3333 Beverly Road';
        test_account_1.BillingCity = 'Hoffman Estates';
        test_account_1.BillingState = 'IL';
        test_account_1.BillingPostalCode = '60179';
        test_account_1.BillingCountry = 'US';
        test_account_1.ShippingStreet = '3333 Beverly Road';
        test_account_1.ShippingCity = 'Hoffman Estates';
        test_account_1.ShippingState = 'IL';
        test_account_1.ShippingPostalCode = '60179';
        test_account_1.ShippingCountry = 'US';
        test_account_1.SCO_Account_ID__c = '1100000007';
        test_account_1.Territory_ID__c = '12321';
        test_account_1.NewTerritory__c = lstTestTerritory[0].Id;
        
        lstTestAccount.add(test_account_1);
        
        insert lstTestAccount;
        
        /****************** Insert Contact ****************/   
        
        List<Contact> lstTestContact = new List<Contact>();
        Contact test_contact_1 = new Contact();
        test_contact_1.FirstName = 'Test_fn';
        test_contact_1.LastName = 'Test_ln';
        test_contact_1.Email = 'Test@contact.com';
        test_contact_1.Phone = '1234567890';
        
        lstTestContact.add(test_contact_1);
        
        insert lstTestContact;
        
        /****************** Insert Reason Code ****************/   
        
        List<Reason_Code__c> lstTestReasonCode = new List<Reason_Code__c>();
        
        
        Reason_Code__c test_reason_code_1 = new Reason_Code__c();
        test_reason_code_1.Div__c = '622';
        test_reason_code_1.Category_Code__c = '40';
        test_reason_code_1.Category_Description__c = 'Compliance or Satisfaction';
        test_reason_code_1.Reason_Code__c = '4';
        test_reason_code_1.Reason_Description__c = 'Selling Error  SPDCM';
        test_reason_code_1.Reason_Id__c = '79';
        lstTestReasonCode.add(test_reason_code_1);
        
        Reason_Code__c test_reason_code_2 = new Reason_Code__c();
        test_reason_code_2.Code__c = 'C09';
        test_reason_code_2.Reason_Description__c = 'Installation Overcharge/Undercharge';
        test_reason_code_2.Reason_Id__c = '37';
        test_reason_code_2.Reason_Type__c = 'cmr_dmr';
        lstTestReasonCode.add(test_reason_code_2);
        
        Reason_Code__c test_reason_code_3 = new Reason_Code__c();
        test_reason_code_3.Code__c = 'S12';
        test_reason_code_3.Reason_Description__c = 'Material ruined';
        test_reason_code_3.Reason_Id__c = '133';
        test_reason_code_3.Reason_Type__c = 'return_exchange';
        lstTestReasonCode.add(test_reason_code_3);
        
        Reason_Code__c test_reason_code_4 = new Reason_Code__c();
        test_reason_code_4.Div__c = '626';
        test_reason_code_4.Category_Code__c = '51';
        test_reason_code_4.Category_Description__c = 'With other Exchange or Return';
        test_reason_code_4.Reason_Code__c = '11';
        test_reason_code_4.Reason_Description__c = 'Cosmetic Damage Front or Top';
        test_reason_code_4.Reason_Id__c = '83';
        lstTestReasonCode.add(test_reason_code_4);
        
        Reason_Code__c test_reason_code_5 = new Reason_Code__c();
        test_reason_code_5.Div__c = '626';
        test_reason_code_5.Category_Code__c = '30';
        test_reason_code_5.Category_Description__c = 'Product';
        test_reason_code_5.Reason_Code__c = '2';
        test_reason_code_5.Reason_Description__c = 'Will Not Fit SPDCM';
        test_reason_code_5.Reason_Id__c = '115';
        lstTestReasonCode.add(test_reason_code_5);
        
        insert lstTestReasonCode;
        
        
        /****************** Insert Product ****************/   
        
        List<Product2> lstTestProduct = new List<Product2>();
        
        Product2 test_product_1 = new Product2();
        test_product_1.Name = 'GE Appliances DSKS333ECWW 3.6 cu. ft. Electric Dryer - White';
        test_product_1.IsActive = true;
        test_product_1.Family = 'Products';
        test_product_1.ProductCode = '02608262000';
        test_product_1.Fulfillment_Channel__c = 'DDC';
        test_product_1.Description = 'GE Appliances DSKS333ECWW 3.6 cu. ft. Electric Dryer - White';
        lstTestProduct.add(test_product_1);
        
        Product2 test_product_1_1_1 = new Product2();
        test_product_1_1_1.Name = 'Kenmore Aluminum Dryer Exhaust Close Elbow';
        test_product_1_1_1.IsActive = true;
        test_product_1_1_1.Family = 'Products';
        test_product_1_1_1.ProductCode = '02649609000';
        test_product_1_1_1.Fulfillment_Channel__c = 'DDC';
        test_product_1_1_1.Description = 'Kenmore Aluminum Dryer Exhaust Close Elbow';
        lstTestProduct.add(test_product_1_1_1);
        
        Product2 test_product_1_1_2 = new Product2();
        test_product_1_1_2.Name = 'Kenmore 1010  6 ft. Snap-Lock&trade; Flexible Pipe';
        test_product_1_1_2.IsActive = true;
        test_product_1_1_2.Family = 'Products';
        test_product_1_1_2.ProductCode = '02649608000';
        test_product_1_1_2.Fulfillment_Channel__c = 'DDC';
        test_product_1_1_2.Description = 'Kenmore 1010  6 ft. Snap-Lock&trade; Flexible Pipe';
        lstTestProduct.add(test_product_1_1_2);
        
        Product2 test_product_1_1_3 = new Product2();
        test_product_1_1_3.Name = 'Kenmore 99921 57001 4-Prong 6\' Round Dryer Cord &#8211; Black';
        test_product_1_1_3.IsActive = true;
        test_product_1_1_3.Family = 'Products';
        test_product_1_1_3.ProductCode = '02657001000';
        test_product_1_1_3.Fulfillment_Channel__c = 'DDC';
        test_product_1_1_3.Description = 'Kenmore 99921 57001 4-Prong 6\' Round Dryer Cord &#8211; Black';
        lstTestProduct.add(test_product_1_1_3);
        
        Product2 test_product_1_1_4 = new Product2();
        test_product_1_1_4.Name = 'Kenmore 99920 6\' Electrical Dryer Cord';
        test_product_1_1_4.IsActive = true;
        test_product_1_1_4.Family = 'Products';
        test_product_1_1_4.ProductCode = '02657000000';
        test_product_1_1_4.Fulfillment_Channel__c = 'DDC';
        test_product_1_1_4.Description = 'Kenmore 99920 6\' Electrical Dryer Cord';
        lstTestProduct.add(test_product_1_1_4);
        
        Product2 test_product_1_2_1 = new Product2();
        test_product_1_2_1.Name = 'Leave-in-Box Delivery';
        test_product_1_2_1.IsActive = true;
        test_product_1_2_1.Family = 'Services';
        test_product_1_2_1.ProductCode = 'brownbox_10';
        test_product_1_2_1.Fulfillment_Channel__c = 'DDC';
        test_product_1_2_1.Description = 'Leave-in-Box Delivery';
        lstTestProduct.add(test_product_1_2_1);
        
        Product2 test_product_1_2_2 = new Product2();
        test_product_1_2_2.Name = 'Deliver and Uncrate';
        test_product_1_2_2.IsActive = true;
        test_product_1_2_2.Family = 'Services';
        test_product_1_2_2.ProductCode = 'uncrate_K';
        test_product_1_2_2.Fulfillment_Channel__c = 'DDC';
        test_product_1_2_2.Description = 'Deliver and Uncrate';
        lstTestProduct.add(test_product_1_2_2);
        
        Product2 test_product_1_2_3 = new Product2();
        test_product_1_2_3.Name = 'Delivery and Basic Hook-up';
        test_product_1_2_3.IsActive = true;
        test_product_1_2_3.Family = 'Services';
        test_product_1_2_3.ProductCode = 'hookup_3';
        test_product_1_2_3.Fulfillment_Channel__c = 'DDC';
        test_product_1_2_3.Description = 'Delivery and Basic Hook-up';
        lstTestProduct.add(test_product_1_2_3);
        
        Product2 test_product_1_2_4 = new Product2();
        test_product_1_2_4.Name = 'Professional Installation';
        test_product_1_2_4.IsActive = true;
        test_product_1_2_4.Family = 'Services';
        test_product_1_2_4.ProductCode = 'install_J';
        test_product_1_2_4.Fulfillment_Channel__c = 'DDC';
        test_product_1_2_4.Description = 'Professional Installation';
        lstTestProduct.add(test_product_1_2_4);
        
        Product2 test_product_1_2_5 = new Product2();
        test_product_1_2_5.Name = 'I would like my old item hauled away';
        test_product_1_2_5.IsActive = true;
        test_product_1_2_5.Family = 'Services';
        test_product_1_2_5.ProductCode = 'haulawayRequested';
        test_product_1_2_5.Fulfillment_Channel__c = 'DDC';
        test_product_1_2_5.Description = 'I would like my old item hauled away';
        lstTestProduct.add(test_product_1_2_5);
        
        Product2 test_product_1_3_1 = new Product2();
        test_product_1_3_1.Name = 'MI DRYER GAS';
        test_product_1_3_1.IsActive = true;
        test_product_1_3_1.Family = 'Services';
        test_product_1_3_1.ProductCode = '01026200000';
        test_product_1_3_1.Fulfillment_Channel__c = 'DDC';
        test_product_1_3_1.Description = 'MI DRYER GAS';
        lstTestProduct.add(test_product_1_3_1);
        
        Product2 test_product_1_3_2 = new Product2();
        test_product_1_3_2.Name = 'Deluxe Set Up';
        test_product_1_3_2.IsActive = true;
        test_product_1_3_2.Family = 'Services';
        test_product_1_3_2.ProductCode = '40010500000';
        test_product_1_3_2.Fulfillment_Channel__c = 'DDC';
        test_product_1_3_2.Description = 'Deluxe Set Up';
        lstTestProduct.add(test_product_1_3_2);
        
        Product2 test_product_1_3_3 = new Product2();
        test_product_1_3_3.Name = 'PA; 5YR; LAUNDRY';
        test_product_1_3_3.IsActive = true;
        test_product_1_3_3.Family = 'Services';
        test_product_1_3_3.ProductCode = '07062376000';
        test_product_1_3_3.Fulfillment_Channel__c = 'DDC';
        test_product_1_3_3.Description = 'PA; 5YR; LAUNDRY';
        lstTestProduct.add(test_product_1_3_3);
        
        insert lstTestProduct;
        
        
        
        
        
        /****************** Insert KAP && PP ****************/   
        
        List<Key_Account_Pricing__c> lstTestKAP = new List<Key_Account_Pricing__c>();
        Key_Account_Pricing__c objtestKAP = new Key_Account_Pricing__c();
        
        List<Product_Pricing__c> lstTestPP = new List<Product_Pricing__c>();
        Product_Pricing__c objTestPP = new Product_Pricing__c();
        
        
        Boolean isNextReady = false;
        
        for(Product2 pr:lstTestProduct){
            
            objtestKAP = new Key_Account_Pricing__c();
            objtestKAP.Material_Number__c = pr.ProductCode;
            objtestKAP.Customer__c = lstTestAccount[0].Id;
            objtestKAP.Valid_from__c = system.today().addDays(-1);
            objtestKAP.Valid_to__c = system.today().addYears(1).addDays(-1);
            
            objTestPP = new Product_Pricing__c();
            objTestPP.Material_Number__c = pr.ProductCode;
            
            if(pr.Family == 'Products' && isNextReady == false ){
                objtestKAP.Customer_KAP_price__c = 450;
                objTestPP.Price__c = 500;
                objTestPP.Cost__c = 200;
                isNextReady = true;
            }else if(pr.Family == 'Products' ){
                objtestKAP.Customer_KAP_price__c = 45;
                objTestPP.Price__c = 50;
                objTestPP.Cost__c = 20;
            }else if(pr.Family == 'Services' ){
                objtestKAP.Customer_KAP_price__c = 9;
                objTestPP.Price__c = 10;
                objTestPP.Cost__c = 4;
                isNextReady = false;
            }
        
            lstTestKAP.add(objtestKAP);
            lstTestPP.add(objTestPP);
            system.debug('objtestKAP --> ' + objtestKAP );
            system.debug('objTestPP --> ' + objTestPP );
        }
        
        insert lstTestKAP;
        insert lstTestPP;
        
        
        
        /****************** Insert Opportunity ****************/   
        
        List<Opportunity> lstTestOpportunity = new List<Opportunity>();
        
        Opportunity test_opportunity_1 = new Opportunity();
        test_opportunity_1.Name = 'Test Opportunity';
        test_opportunity_1.AccountId = lstTestAccount[0].Id;
        test_opportunity_1.StageName = 'Proposal';
        test_opportunity_1.CloseDate = system.today().addMonths(1);
        lstTestOpportunity.add(test_opportunity_1);
        
        insert lstTestOpportunity;
        
        
        
        return null;        
    }
    
	public static String insertQuote(){
        
        
        
        return null;        
    }    
    
}