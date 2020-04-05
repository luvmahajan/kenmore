public class DataInsertFactory {
    
	public static String insertQuote(){
        
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
        Common_Variables__c cv_adjustment_payment = new Common_Variables__c(Name = 'Adjustment_Payment_API', Content__c = '19');
        lstCommmonVariables.add(cv_adjustment_payment);
        
        insert lstCommmonVariables;
        
        
        
        /****************** Insert Product ****************/   
        
        List<Product2> lstTestProduct = new List<Product2>();
        
        Product2 test_product_1 = new Product2();
        test_product_1.Name = 'Test Product 1';
        test_product_1.IsActive = true;
        test_product_1.Family = 'Products';
        test_product_1.ProductCode = '02600001000';
        test_product_1.Fulfillment_Channel__c = 'DDC';
        test_product_1.Description = 'Test Product Description 1';
        lstTestProduct.add(test_product_1);
        
        Product2 test_product_1_1 = new Product2();
        test_product_1_1.Name = 'Test Product 1 1';
        test_product_1_1.IsActive = true;
     //   test_product_1_1.Family = 'Products';
        test_product_1_1.ProductCode = '02600002000';
        test_product_1_1.Fulfillment_Channel__c = 'DDC';
        test_product_1_1.Description = 'Test Product Description 1 1';
        lstTestProduct.add(test_product_1_1);
        
        Product2 test_product_1_2 = new Product2();
        test_product_1_2.Name = 'Test Product 1 2';
        test_product_1_2.IsActive = true;
        test_product_1_2.Family = 'Services';
    //    test_product_1_2.ProductCode = '02600003000';
        test_product_1_2.ProductCode = '40010100000';
        test_product_1_2.Fulfillment_Channel__c = 'DDC';
        test_product_1_2.Description = 'Test Product Description 1 2';
        lstTestProduct.add(test_product_1_2);
        
        insert lstTestProduct;
        
        
        
        /****************** Insert Product Feature ****************/   
        
        List<SBQQ__ProductFeature__c> lstTestFeature = new List<SBQQ__ProductFeature__c>();
        
        SBQQ__ProductFeature__c test_feature_1 = new SBQQ__ProductFeature__c();
        test_feature_1.SBQQ__Number__c = 1;
        test_feature_1.Name = 'Parts';
        test_feature_1.SBQQ__MinOptionCount__c = 0;
        test_feature_1.SBQQ__MaxOptionCount__c = 10;
        test_feature_1.SBQQ__ConfiguredSKU__c = lstTestProduct[0].Id;
        lstTestFeature.add(test_feature_1);
        
        SBQQ__ProductFeature__c test_feature_2 = new SBQQ__ProductFeature__c();
        test_feature_2.SBQQ__Number__c = 1;
        test_feature_2.Name = 'Services';
        test_feature_2.SBQQ__ConfiguredSKU__c = lstTestProduct[0].Id;
        lstTestFeature.add(test_feature_2);
        
        insert lstTestFeature;
        
        
        /****************** Insert Product Option ****************/   
        
        List<SBQQ__ProductOption__c> lstTestOption = new List<SBQQ__ProductOption__c>();
        
        SBQQ__ProductOption__c test_option_1 = new SBQQ__ProductOption__c();
        test_option_1.SBQQ__Number__c = 1;
        test_option_1.SBQQ__ConfiguredSKU__c = lstTestProduct[0].Id;
        test_option_1.SBQQ__OptionalSKU__c = lstTestProduct[1].Id;
        test_option_1.SBQQ__Feature__c = lstTestFeature[0].Id;
        test_option_1.SBQQ__Type__c = 'Component';
        test_option_1.SBQQ__Bundled__c = false;
        lstTestOption.add(test_option_1);
        
        SBQQ__ProductOption__c test_option_2 = new SBQQ__ProductOption__c();
        test_option_2.SBQQ__Number__c = 1;
        test_option_2.SBQQ__ConfiguredSKU__c = lstTestProduct[0].Id;
        test_option_2.SBQQ__OptionalSKU__c = lstTestProduct[2].Id;
        test_option_2.SBQQ__Feature__c = lstTestFeature[1].Id;
        test_option_2.SBQQ__Type__c = 'Component';
        test_option_2.SBQQ__Bundled__c = false;
        lstTestOption.add(test_option_2);
        
        insert lstTestOption;
        
        
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
        test_account_1.SCO_Account_ID__c = 'sco_123';
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
        
        /****************** Insert Opportunity ****************/   
        
        List<Opportunity> lstTestOpportunity = new List<Opportunity>();
        
        Opportunity test_opportunity_1 = new Opportunity();
        test_opportunity_1.Name = 'Test Opportunity';
        test_opportunity_1.AccountId = lstTestAccount[0].Id;
        test_opportunity_1.StageName = 'Proposal';
        test_opportunity_1.CloseDate = system.today().addMonths(1);
        lstTestOpportunity.add(test_opportunity_1);
        
        insert lstTestOpportunity;
        
        /****************** Insert Quote ****************/    
        
        List<SBQQ__Quote__c> lstTestQuote = new List<SBQQ__Quote__c>();
        
        SBQQ__Quote__c test_Quote_1 = new SBQQ__Quote__c();
        test_Quote_1.SBQQ__Primary__c = true ;
        test_Quote_1.SBQQ__Account__c = lstTestAccount[0].Id ;
        test_Quote_1.SBQQ__Opportunity2__c = lstTestOpportunity[0].Id ;
        test_Quote_1.SBQQ__SalesRep__c = system.UserInfo.getUserId() ;
        test_Quote_1.GeoCode__c = '00' ;
        test_Quote_1.County_Code__c = '031' ;
        test_Quote_1.County_Name__c = 'COOK' ;
        test_Quote_1.Purchase_Number__c = 'PO_Q_00' ;
        test_Quote_1.SBQQ__PrimaryContact__c = lstTestContact[0].Id ;
        test_Quote_1.Delivery_Contact__c = lstTestContact[0].Id ;
        test_Quote_1.Delivery_Charge__c = 100;
        /*
        test_Quote_1.SBQQ__ShippingStreet__c = '3333 Beverly Road';
        test_Quote_1.SBQQ__ShippingCity__c = 'Hoffman Estates';
        test_Quote_1.SBQQ__ShippingState__c = 'IL';
        test_Quote_1.SBQQ__ShippingPostalCode__c = '60179';
        test_Quote_1.SBQQ__ShippingCountry__c = 'US';*/
        lstTestQuote.add(test_Quote_1);
        
        insert lstTestQuote;
        
        /****************** Insert Quote Line Staging ****************/  
        
        List<Quote_Line_Staging__c> lstTestStaging = new List<Quote_Line_Staging__c>();
        
            String ran = String.valueOf(Math.mod(Math.round(Math.random()*1000000+1),1000000));
        
        
        Quote_Line_Staging__c test_Staging_1 = new Quote_Line_Staging__c();
        test_Staging_1.Quote__c = lstTestQuote[0].Id ;
        test_Staging_1.Product__c = lstTestProduct[0].Id ;
        test_Staging_1.Quantity__c = 1 ;
        test_Staging_1.Additional_Disc__c = 0 ;
        test_Staging_1.List_Unit_Price__c = 500 ;
        test_Staging_1.List_Unit_Cost__c = 250 ;
        test_Staging_1.ProductParent__c = lstTestProduct[0].Id ;
        test_Staging_1.ProductParentUnique__c = lstTestProduct[0].Id + ran ;
        test_Staging_1.isProductParent__c = true ;
        test_Staging_1.Bundled__c = false ;
        test_Staging_1.Feature__c = 'Parts' ;
        lstTestStaging.add(test_Staging_1);
        
        insert lstTestStaging;
                
        
        /****************** Insert Quote Line ****************/  
        
        List<Quote_Line_Staging__c> lstTestQuoteLineStaging = new List<Quote_Line_Staging__c>();
        lstTestQuoteLineStaging = [SELECT Id, Name, Quote__c, Product__c, Quantity__c, List_Unit_Price__c, List_Unit_Cost__c, Bundled__c, 
                               			Available_Quantity__c, PA_API_Message__c, Available__c, Earliest_Available_Date__c, 
                                    	Disposable_Fee__c, Tax_Rate__c, Tax__c, Total_Tax_Amount__c, Tax_Amount__c,//, Shipping_Charge__c
                                    	Additional_Disc__c, Discount_Operator__c, isProductParent__c, ProductParent__c, 
                                    	ProductParentUnique__c, Feature__c, Target_Customer_Amount__c, Total_Margin_Percent__c, 
                                    	Configuration_Option__c, Product__r.Description, Net_Unit_Price__c //, Used_Margin_Percent__c 
                                    FROM Quote_Line_Staging__c
                                    ORDER BY Id
                                   ];
        
        List<SBQQ__QuoteLine__c> lstQuoteLineIns = new List<SBQQ__QuoteLine__c>();
        SBQQ__QuoteLine__c objQuoteLineIns = new SBQQ__QuoteLine__c();
        
                for(Quote_Line_Staging__c ins:lstTestQuoteLineStaging){
            objQuoteLineIns = new SBQQ__QuoteLine__c();
            objQuoteLineIns.Feature__c = ins.Feature__c;
            objQuoteLineIns.SBQQ__Product__c = ins.Product__c;
            objQuoteLineIns.SBQQ__Quantity__c = (ins.Quantity__c==null?0:ins.Quantity__c);
            objQuoteLineIns.Available__c = ins.Available__c;
            objQuoteLineIns.Available_Quantity__c = ins.Available_Quantity__c;
            objQuoteLineIns.Earliest_Available_Date__c = ins.Earliest_Available_Date__c;
            objQuoteLineIns.PA_API_Message__c = ins.PA_API_Message__c;
            objQuoteLineIns.SBQQ__Description__c = ins.Product__r.Description;
            objQuoteLineIns.SBQQ__Hidden__c = false;//ins.Product__c;
            objQuoteLineIns.SBQQ__Bundled__c = ins.Bundled__c;
            objQuoteLineIns.SBQQ__Quote__c = ins.Quote__c;
            objQuoteLineIns.SBQQ__Number__c = 1;//mapLineEditor.get(ins.Id).seq_no;
            objQuoteLineIns.List_Price__c = ins.List_Unit_Price__c;
            objQuoteLineIns.SBQQ__ListPrice__c = ins.List_Unit_Price__c;
            objQuoteLineIns.SBQQ__SubscriptionBase__c = 'List';
            objQuoteLineIns.List_Cost__c = ins.List_Unit_Cost__c;
            objQuoteLineIns.SBQQ__CustomerPrice__c = ins.Net_Unit_Price__c;
            objQuoteLineIns.SBQQ__NetPrice__c = ins.Net_Unit_Price__c;
            objQuoteLineIns.SBQQ__SpecialPrice__c = ins.List_Unit_Price__c;
            objQuoteLineIns.SBQQ__RegularPrice__c = ins.List_Unit_Price__c;
            objQuoteLineIns.SBQQ__ProratedListPrice__c = ins.List_Unit_Price__c;
       //     objQuoteLineIns.Shipping_Charge__c = ins.Shipping_Charge__c;
            objQuoteLineIns.Disposable_Fee__c = ins.Disposable_Fee__c;
            objQuoteLineIns.Tax_Rate__c = ins.Tax_Rate__c;
            objQuoteLineIns.Target_Customer_Amount__c = ins.Target_Customer_Amount__c;
            objQuoteLineIns.Total_Margin_Percent__c = 0;
        //    objQuoteLineIns.Used_Margin_Percent__c = disc_mrgn;
            objQuoteLineIns.ProductParent__c = ins.ProductParent__c;
            objQuoteLineIns.ProductParentUnique__c = ins.ProductParentUnique__c;
            objQuoteLineIns.isProductParent__c = ins.isProductParent__c;
      //      objQuoteLineIns.SBQQ__ProductOption__c = mapOptionalSKU.get(ins.Product__c);
            objQuoteLineIns.Configuration_Option__c = ins.Configuration_Option__c;
             
            if(ins.Discount_Operator__c=='Amount')
            	objQuoteLineIns.SBQQ__AdditionalDiscountAmount__c = ins.Additional_Disc__c;
            if(ins.Discount_Operator__c=='Percent')
            	objQuoteLineIns.SBQQ__Discount__c = ins.Additional_Disc__c;
            
            system.debug('objQuoteLineIns--> ' + objQuoteLineIns );
            lstQuoteLineIns.add(objQuoteLineIns);
                }
        insert lstQuoteLineIns;
        
        
        /****************** Insert Contract ****************/  
        
        List<Contract> lstTestContract = new List<Contract>();
                
        
        Contract test_Contract_1 = new Contract();
        test_Contract_1.AccountId = lstTestAccount[0].Id ;
        test_Contract_1.SBQQ__Opportunity__c = lstTestOpportunity[0].Id ;
        test_Contract_1.SBQQ__Quote__c = lstTestQuote[0].Id ;
        test_Contract_1.Status = 'Build Contract' ;
        test_Contract_1.StartDate = system.today() ;
        test_Contract_1.ContractTerm = 12 ;
        test_Contract_1.Purchase_Number__c = 'PO_C_00' ;
        lstTestContract.add(test_Contract_1);
        
        insert lstTestContract;
        
        return ran;        
        
	}
    
    public static void insertPricing(){
        
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
        Common_Variables__c cv_adjustment_payment = new Common_Variables__c(Name = 'Adjustment_Payment_API', Content__c = '19');
        lstCommmonVariables.add(cv_adjustment_payment);
        
        insert lstCommmonVariables;
        
        
        
        /****************** Insert Product ****************/  
        
        List<Product2> lstTestProduct = new List<Product2>();
        
        Product2 test_product_1 = new Product2();
        test_product_1.Name = 'Test Product 1';
        test_product_1.IsActive = true;
        test_product_1.Family = 'Products';
        test_product_1.ProductCode = '02600001000';
        test_product_1.Fulfillment_Channel__c = 'DDC';
        test_product_1.Description = 'Test Product Description 1';
        test_product_1.SBQQ__Component__c = false;
        test_product_1.CanUseQuantitySchedule = false;
        lstTestProduct.add(test_product_1);
        
        Product2 test_product_1_1 = new Product2();
        test_product_1_1.Name = 'Test Product 1 1';
        test_product_1_1.IsActive = true;
     //   test_product_1_1.Family = 'Products';
        test_product_1_1.ProductCode = '02600002000';
        test_product_1_1.Fulfillment_Channel__c = 'DDC';
        test_product_1_1.Description = 'Test Product Description 1 1';
        test_product_1_1.SBQQ__Component__c = false;
        test_product_1_1.CanUseQuantitySchedule = false;
        lstTestProduct.add(test_product_1_1);
        
        Product2 test_product_1_2 = new Product2();
        test_product_1_2.Name = 'Test Product 1 2';
        test_product_1_2.IsActive = true;
        test_product_1_2.Family = 'Services';
  //      test_product_1_2.ProductCode = '02600003000';
        test_product_1_2.ProductCode = '40010100000';
        test_product_1_2.Fulfillment_Channel__c = 'DDC';
        test_product_1_2.Description = 'Test Product Description 1 2';
        test_product_1_2.SBQQ__Component__c = false;
        test_product_1_2.CanUseQuantitySchedule = false;
        lstTestProduct.add(test_product_1_2);
        
        Product2 test_product_2 = new Product2();
        test_product_2.Name = 'Test Product 2';
        test_product_2.IsActive = true;
        test_product_2.Family = 'Products';
        test_product_2.ProductCode = '02600004000';
        test_product_2.Fulfillment_Channel__c = 'DDC';
     //   test_product_2.Description = 'Test Product Description 2';
        test_product_2.SBQQ__Component__c = false;
        test_product_2.CanUseQuantitySchedule = false;
        lstTestProduct.add(test_product_2);
        
        insert lstTestProduct;
        
        
        /****************** Insert Product Feature ****************/   
        
        List<SBQQ__ProductFeature__c> lstTestFeature = new List<SBQQ__ProductFeature__c>();
        
        SBQQ__ProductFeature__c test_feature_1 = new SBQQ__ProductFeature__c();
        test_feature_1.SBQQ__Number__c = 1;
        test_feature_1.Name = 'Parts';
        test_feature_1.SBQQ__MinOptionCount__c = 0;
        test_feature_1.SBQQ__MaxOptionCount__c = 10;
        test_feature_1.SBQQ__ConfiguredSKU__c = lstTestProduct[0].Id;
        lstTestFeature.add(test_feature_1);
        
        SBQQ__ProductFeature__c test_feature_2 = new SBQQ__ProductFeature__c();
        test_feature_2.SBQQ__Number__c = 1;
        test_feature_2.Name = 'Services';
        test_feature_2.SBQQ__ConfiguredSKU__c = lstTestProduct[0].Id;
        lstTestFeature.add(test_feature_2);
        
        insert lstTestFeature;
        
        
        /****************** Insert Product Option ****************/   
        
        List<SBQQ__ProductOption__c> lstTestOption = new List<SBQQ__ProductOption__c>();
        
        SBQQ__ProductOption__c test_option_1 = new SBQQ__ProductOption__c();
        test_option_1.SBQQ__Number__c = 1;
        test_option_1.SBQQ__ConfiguredSKU__c = lstTestProduct[0].Id;
        test_option_1.SBQQ__OptionalSKU__c = lstTestProduct[1].Id;
        test_option_1.SBQQ__Feature__c = lstTestFeature[0].Id;
        test_option_1.SBQQ__Type__c = 'Component';
        test_option_1.SBQQ__Bundled__c = false;
        lstTestOption.add(test_option_1);
        
        SBQQ__ProductOption__c test_option_2 = new SBQQ__ProductOption__c();
        test_option_2.SBQQ__Number__c = 1;
        test_option_2.SBQQ__ConfiguredSKU__c = lstTestProduct[0].Id;
        test_option_2.SBQQ__OptionalSKU__c = lstTestProduct[2].Id;
        test_option_2.SBQQ__Feature__c = lstTestFeature[1].Id;
        test_option_2.SBQQ__Type__c = 'Component';
        test_option_2.SBQQ__Bundled__c = false;
        lstTestOption.add(test_option_2);
        
        insert lstTestOption;
        
        
        /****************** Insert Zip Code ****************/   
        
        List<Zip_Code__c> lstTestZipCode = new List<Zip_Code__c>();
        
        Zip_Code__c test_zipcode_1 = new Zip_Code__c();
        test_zipcode_1.Name = '60179';
        test_zipcode_1.OwnerId = system.UserInfo.getUserId();
        test_zipcode_1.State__c = 'IL';
        
        lstTestZipCode.add(test_zipcode_1);
        
        insert lstTestZipCode;
                
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
        lstTestAccount.add(test_account_1);
        
        insert lstTestAccount;
        
        
        /****************** Insert Opportunity ****************/   
        
        List<Opportunity> lstTestOpportunity = new List<Opportunity>();
        
        Opportunity test_opportunity_1 = new Opportunity();
        test_opportunity_1.Name = 'Test Opportunity';
        test_opportunity_1.AccountId = lstTestAccount[0].Id;
        test_opportunity_1.StageName = 'Proposal';
        test_opportunity_1.CloseDate = system.today().addMonths(1);
        lstTestOpportunity.add(test_opportunity_1);
        
        insert lstTestOpportunity;
        
        
        /****************** Insert Quote ****************/    
        
        List<SBQQ__Quote__c> lstTestQuote = new List<SBQQ__Quote__c>();
        
        SBQQ__Quote__c test_Quote_1 = new SBQQ__Quote__c();
        test_Quote_1.SBQQ__Primary__c = true ;
        test_Quote_1.SBQQ__Account__c = lstTestAccount[0].Id ;
        test_Quote_1.SBQQ__Opportunity2__c = lstTestOpportunity[0].Id ;
        test_Quote_1.SBQQ__SalesRep__c = system.UserInfo.getUserId() ;
        test_Quote_1.Sales_Rep_Manager__c = system.UserInfo.getUserId() ;
        test_Quote_1.Sales_Rep_Manager_2__c = system.UserInfo.getUserId() ;
        test_Quote_1.Sales_Rep_Manager_3__c = system.UserInfo.getUserId() ;
        test_Quote_1.GeoCode__c = '00' ;
        test_Quote_1.County_Code__c = '031' ;
        test_Quote_1.County_Name__c = 'COOK' ;
        test_Quote_1.Purchase_Number__c = 'PO_Q_01' ;
        test_Quote_1.Delivery_Charge__c = 100;
        lstTestQuote.add(test_Quote_1);
        
        insert lstTestQuote;
        
        
        
        
        /****************** Insert KAP ****************/   
        
        List<Key_Account_Pricing__c> lstTestKAP = new List<Key_Account_Pricing__c>();
        
        Key_Account_Pricing__c test_KAP_1 = new Key_Account_Pricing__c();
        test_KAP_1.Material_Number__c = lstTestProduct[0].ProductCode;
        test_KAP_1.Customer__c = lstTestAccount[0].Id;
        test_KAP_1.Customer_KAP_price__c = 450;
        test_KAP_1.Valid_from__c = system.today().addDays(-1);
        test_KAP_1.Valid_to__c = system.today().addYears(1).addDays(-1);
        lstTestKAP.add(test_KAP_1);
        
        Key_Account_Pricing__c test_KAP_2 = new Key_Account_Pricing__c();
        test_KAP_2.Material_Number__c = lstTestProduct[3].ProductCode;
        test_KAP_2.Customer__c = lstTestAccount[0].Id;
   //     test_KAP_2.Customer_KAP_price__c = 450;
        test_KAP_2.Valid_from__c = system.today().addDays(-1);
        test_KAP_2.Valid_to__c = system.today().addYears(1).addDays(-1);
        lstTestKAP.add(test_KAP_2);
        
        insert lstTestKAP;
        
        
        /****************** Insert Product Pricing ****************/   

        List<Product_Pricing__c> lstTestPP = new List<Product_Pricing__c>();
        
        Product_Pricing__c test_PP_1 = new Product_Pricing__c();
        test_PP_1.Material_Number__c = lstTestProduct[0].ProductCode;
        test_PP_1.Price__c = 500;
        test_PP_1.Cost__c = 250;
        lstTestPP.add(test_PP_1);
        
        Product_Pricing__c test_PP_2 = new Product_Pricing__c();
        test_PP_2.Material_Number__c = lstTestProduct[3].ProductCode;
        test_PP_2.Price__c = 500;
        test_PP_2.Cost__c = 250;
        lstTestPP.add(test_PP_2);
        
        Product_Pricing__c test_PP_3 = new Product_Pricing__c();
        test_PP_3.Material_Number__c = lstTestProduct[2].ProductCode;
        test_PP_3.Price__c = 500;
        test_PP_3.Cost__c = 250;
        lstTestPP.add(test_PP_3);
        
        Product_Pricing__c test_PP_4 = new Product_Pricing__c();
        test_PP_4.Material_Number__c = lstTestProduct[1].ProductCode;
        test_PP_4.Price__c = 500;
        test_PP_4.Cost__c = 250;
        lstTestPP.add(test_PP_4);
        
        insert lstTestPP;
        
        
        
    }
    
    

}