public class QuoteLineEditorController {
    
    public String quoteId {get; set;}
    public Boolean renTable {get; set;}
    public Map<String, String> mapHeader {get; set;}
    public Map<String, LineEditor> mapLineEditor {get; set;}
    
    public List<Quote_Line_Staging__c> lstQuoteLineStaging {get; set;}
    public List<String> lstParentProduct {get; set;}
    public Map<String, Quote_Line_Staging__c> mapParentProduct {get; set;}
    
    public Double sub_total {get; set;}
    public Double grand_total {get; set;}
    public Double grand_total_non_disc {get; set;}
    public Double target_amount {get; set;}
    public Double tax_total {get; set;}
    public Double discount {get; set;}
    public Double disc_mrgn {get; set;}
    
    public boolean displayPopup {get; set;} 
    public boolean displayPopup2 {get; set;} 
    public boolean displayDonePopup {get; set;} 
//    public Double margin_percent {get; set;}
//    public Double order_margin_percent {get; set;}
    public Decimal margin_percent {get; set;}
    public Decimal order_margin_percent {get; set;}
    public String discount_reason {get; set;}
    public SBQQ__Quote__c objQuote {get; set;}
    public SBQQ__Quote__c objQuoteMargin {get; set;}
    public List<SBQQ__Quote__c> lstQuote {get; set;}
    public String btn_press {get; set;}

    public boolean displayDescPopup {get; set;}     
    public String displayDescription {get; set;}     
    public String displayName {get; set;}     
    public boolean displaySubstitute {get; set;} 
    
    public String delivery_method {get; set;}     
    public String delivery_message {get; set;}     
    public Double delivery_charge {get; set;}     
    public Double delivery_discount {get; set;} 
    public Boolean isDeliveryEstimate {get; set;} 
    public boolean renClearDiscount {get; set;}     
    public boolean isShippingMDO {get; set;}   
    public boolean displayTrips {get; set;}     
    public Integer qty_trips {get; set;}     
    public Double trips_cost {get; set;} 

    public Decimal setdelivery {get; set;}
    public Decimal deliveryTaxRate {get; set;}
    
    public String quoteRecordType {get; set;}

    public Map<String, String> mapConfiguration {get; set;}
    
    public boolean renLock {get; set;}     
    
    public String selSubstituteReason {get; set;}
    public String sel_sid {get; set;}
    
    public boolean isCostZero {get; set;}
    
    public String quoteMasterContract {get; set;}
    public Map<String, Decimal> mapCLIQuantity {get; set;}
    public Map<String, Boolean> mapIsParentSubstitute {get; set;}
    
    public boolean isMarginEmpty {get; set;}
    
 //   public QuoteLineEditorController(ApexPages.StandardController stdController) {
    public QuoteLineEditorController() {
        renTable = false;
    //    target_amount = 0;
        sub_total = 0;
        grand_total = 0;
        grand_total_non_disc = 0;
        tax_total = 0;
        discount = 0;
        margin_percent = 0;
        order_margin_percent = 0;
        disc_mrgn = 0;
        discount_reason = '';
        btn_press = '';
        
        displayDescPopup = false;    
        displayDescription = '';    
        displayName = '';  
        quoteRecordType = '';
        renClearDiscount = false;
        isShippingMDO = false;
        displayTrips = false;
        qty_trips = 0;
        trips_cost = 0;
        displaySubstitute = false;
        
        setdelivery = 0;
        deliveryTaxRate = 0;
        
        isCostZero = false;
        
        quoteMasterContract = '';
        
        mapHeader = new Map<String, String>();
        mapLineEditor = new Map<String, LineEditor>();
        
        lstQuoteLineStaging = new List<Quote_Line_Staging__c>();
        lstParentProduct = new List<String>();
        mapParentProduct = new Map<String, Quote_Line_Staging__c>();
        objQuote = new SBQQ__Quote__c();
        lstQuote = new List<SBQQ__Quote__c>();
        
        mapConfiguration = new Map<String, String>();
        
        renLock = true;
        
        selSubstituteReason = '';
        sel_sid = '';
        
        mapIsParentSubstitute = new Map<String, Boolean>();
        
        isMarginEmpty = false;
        
        quoteId = ApexPages.CurrentPage().getparameters().get('id');
    //   SBQQ__Quote__c objQuoteMargin = new SBQQ__Quote__c();
         objQuoteMargin = new SBQQ__Quote__c();
     //   objQuoteMargin = [SELECT Id, Name, SBQQ__Account__r.Discount_Margin__c, Discount_Margin__c, Discount_Reason__c FROM SBQQ__Quote__c WHERE Id =: quoteId LIMIT 1];
        objQuoteMargin = [SELECT Id, Name, Account_Margin__c, Company_Margin__c, Discount_Margin__c, Discount_Reason__c, isDeliveryEstimate__c, Store_Number__c , Number_of_Trips__c, 
                          		SBQQ__DeliveryMethod__c, Delivery_Charge__c, Delivery_Message__c, Delivery_Discount__c, RecordTypeId, RecordType.Name, RecordType.DeveloperName, 
                          		Approval_Status__c, Sales_Rep_Manager__c, Sales_Rep_Manager_2__c, Sales_Rep_Manager_3__c, Delivery_Tax__c, Delivery_Total__c, SBQQ__Status__c, isTaxError__c,
                          		SBQQ__MasterContract__c
                          FROM SBQQ__Quote__c 
                          WHERE Id =: quoteId LIMIT 1
                         ];
        
        if(objQuoteMargin.Delivery_Tax__c!=null ){
            deliveryTaxRate = objQuoteMargin.Delivery_Total__c!=0?objQuoteMargin.Delivery_Tax__c/objQuoteMargin.Delivery_Total__c:0;
        }
        
        if(objQuoteMargin.SBQQ__MasterContract__c!=null ){
            quoteMasterContract = objQuoteMargin.SBQQ__MasterContract__c;
        }
        
        
                
        string profile_sysadmin = '';
        List<Profile> lstProfile = new List<Profile>();
        lstProfile = [SELECT Id, Name FROM Profile WHERE Name='System Administrator' LIMIT 1];
        if(lstProfile.size()>0){
            profile_sysadmin = lstProfile[0].Id;
        }
                
                
                
     //       if(objQuoteMargin.Approval_Status__c=='Pending' && objQuoteMargin.Sales_Rep_Manager__c != UserInfo.getUserId() 
     //       if(objQuoteMargin.SBQQ__Status__c=='Approval' && objQuoteMargin.Sales_Rep_Manager__c != UserInfo.getUserId() 
     //          && objQuoteMargin.Sales_Rep_Manager_2__c != UserInfo.getUserId() && objQuoteMargin.Sales_Rep_Manager_3__c != UserInfo.getUserId() 
     //          && userinfo.getProfileId()!= profile_sysadmin 
    //          ){
            if((objQuoteMargin.SBQQ__Status__c=='Approval' && objQuoteMargin.Sales_Rep_Manager__c != UserInfo.getUserId() && userinfo.getProfileId()!= profile_sysadmin) 
               || objQuoteMargin.isTaxError__c
              ){
                  if( userinfo.getProfileId()!= profile_sysadmin){
                      renLock = false;
                  }
                  if(objQuoteMargin.isTaxError__c){
                      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'There was an error while calculating Taxes. Please contact the CPQ support team.'));
                  }
              }
        
            
        	//	renLock = false;
        
        
        Map<String, Common_Variables__c> mapCV = Common_Variables__c.getAll(); 
        trips_cost = Double.valueOf(mapCV.get('Delivery_Trip_Cost').Content__c);
        /*
        Map<String, Common_Variables__c> mapCV = Common_Variables__c.getAll(); 
        system.debug('mapCV--> ' + mapCV );
        Double disc_mrgn_org = Double.valueOf(mapCV.get('Discount_Margin').Content__c);
        Double disc_mrgn_act = objQuoteMargin.SBQQ__Account__r.Discount_Margin__c;
        Double disc_mrgn_qt = objQuoteMargin.Discount_Margin__c;
*/
        
        Double disc_mrgn_org = objQuoteMargin.Company_Margin__c;
        Double disc_mrgn_act = objQuoteMargin.Account_Margin__c;
     //   quoteRecordType = objQuoteMargin.RecordType.Name;
        quoteRecordType = objQuoteMargin.RecordType.DeveloperName;
        delivery_method = '';
        delivery_message = '';
        delivery_charge = 0;
        delivery_discount = 0;
        isDeliveryEstimate = false;
        
        if(objQuoteMargin.Store_Number__c==null && objQuoteMargin.RecordType.DeveloperName=='Commercial_Flow_Business' ){
            isShippingMDO = true;
        }
        
        delivery_method = objQuoteMargin.SBQQ__DeliveryMethod__c;
        delivery_message = objQuoteMargin.Delivery_Message__c;
        delivery_charge = objQuoteMargin.Delivery_Charge__c!=null?objQuoteMargin.Delivery_Charge__c.setScale(2):0;
        delivery_discount = objQuoteMargin.Delivery_Discount__c!=null?objQuoteMargin.Delivery_Discount__c.setScale(2):0;
        qty_trips = objQuoteMargin.Number_of_Trips__c!=null?Integer.valueof(objQuoteMargin.Number_of_Trips__c):0;
        isDeliveryEstimate = objQuoteMargin.isDeliveryEstimate__c;
        
        setdelivery = delivery_charge - delivery_discount;
        
        setdelivery = setdelivery.setScale(2);
        
        
        system.debug('disc_mrgn_org--> ' + disc_mrgn_org );
        system.debug('disc_mrgn_act--> ' + disc_mrgn_act );
        
   //     system.debug('disc_mrgn_qt--> ' + disc_mrgn_qt );
        
  //      if(disc_mrgn_qt>0){
  //          disc_mrgn = disc_mrgn_qt;
  //      }else if(disc_mrgn_act>0){
        if(disc_mrgn_act>0){
            disc_mrgn = disc_mrgn_act;
        }else if(disc_mrgn_org>0){
            disc_mrgn = disc_mrgn_org;
        }
        system.debug('disc_mrgn--> ' + disc_mrgn );
        
        mapHeader.put('seq_no', '#');
        mapHeader.put('product_code', 'PRODUCT ID');
        mapHeader.put('product_name', 'PRODUCT NAME');
        mapHeader.put('quantity', 'QTY');
        mapHeader.put('list_unit_price', 'LIST UNIT PRICE');
        mapHeader.put('add_discount', 'ADDITIONAL DISC.');
        mapHeader.put('add_discount_amount', 'ADDITIONAL DISC. (AMT)');
        mapHeader.put('add_discount_percent', 'ADDITIONAL DISC. (%)');
        mapHeader.put('discount_percent', 'DISCOUNT PERCENT');
        mapHeader.put('available', 'AVAILABLE?');
        mapHeader.put('available_quantity', 'AVAIL QTY');
        mapHeader.put('available_date', 'EARLIEST AVAIL DATE');
        mapHeader.put('available_message', 'AVAILABLE MESSAGE');
        mapHeader.put('description', 'PRODUCT DESCRIPTION');
        mapHeader.put('net_unit_price', 'NET UNIT PRICE');
        mapHeader.put('net_total', 'NET TOTAL');
        mapHeader.put('tax_rate', 'TAX RATE');
        mapHeader.put('special_tax', 'SPECIAL TAX');
        mapHeader.put('total_tax', 'TOTAL TAX AMT');
                
        mapConfiguration.put('standard', 'Door should open to the right (Standard)');
        mapConfiguration.put('20', 'The refrigerator door should open to the left (instead of the right) and I have purchased a separate ice-maker, it should be installed prior to delivery.');
        mapConfiguration.put('18', 'Door should open to the left');
        mapConfiguration.put('19', 'I have purchased a separate ice-maker, it should be installed prior to delivery.');
        
        
        lstQuoteLineStaging = [SELECT Id, Name, AdditionalDiscountAmount__c, AdditionalDiscountPercent__c, Quote__c, 
                               		Product__c, Quantity__c, List_Unit_Price__c, List_Unit_Cost__c, Product__r.ProductCode, Product__r.Name, 
                               		Product__r.Description, Non_Discountable__c, Quantity_Editable__c, Bundled__c, 
                               		Net_Unit_Price__c, Net_Total__c, Available_Quantity__c, PA_API_Message__c, Available__c, 
                               		Earliest_Available_Date__c, Disposable_Fee__c,//, Shipping_Charge__c 
                               		Tax_Rate__c, Total_Tax_Amount__c, Tax_Amount__c, Tax__c, Additional_Disc__c, Discount_Operator__c, 
                               		isProductParent__c, ProductParent__c, ProductParentUnique__c, Feature__c, 
                               		Net_Total_Non_Discount__c, Target_Customer_Amount__c, Total_Tax_Amount_Non_Discount__c, 
                               		Configuration_Code__c, Configuration_Option__c, Total_Margin_Percent__c, Set_Unit_Price__c,//, Used_Margin_Percent__c
                               		CreatedDate, LastModifiedDate, Number__c, Price_Source__c, 
                               		Substituted_Product__c, Substituted_Product_Code__c, Substituted_Product_Cost__c, 
                               		Substituted_Product_Created_Date__c, Substituted_Product_Price__c, Substituted_Product_Quantity__c,
                               		Substituted_Product_Source__c, Substitution_Reason__c
                               FROM Quote_Line_Staging__c 
                               WHERE Quote__c = :quoteId
                              ];
        system.debug('lstQuoteLineStaging--> ' + lstQuoteLineStaging );
        
        
   //     grand_total+=delivery_charge - delivery_discount;
   //     grand_total_non_disc+=delivery_charge;
        grand_total += (delivery_charge - delivery_discount + (delivery_charge - delivery_discount)*deliveryTaxRate).setScale(2);//(objQuoteMargin.Delivery_Discount__c!=null?objQuoteMargin.Delivery_Discount__c:0);
        grand_total_non_disc += (delivery_charge + deliveryTaxRate*delivery_charge).setScale(2) ;
        mapParentProduct = new Map<String, Quote_Line_Staging__c>();
        String fea2='';
        integer count_target_amount=0;
        Map<String, DateTime> mapParentCreatedDate = new Map<String, DateTime>();
        
        mapIsParentSubstitute = new Map<String, Boolean>();
        
        for(Quote_Line_Staging__c ls:lstQuoteLineStaging){
            ls.Discount_Operator__c = 'Amount';
            ls.Set_Unit_Price__c = ls.Net_Unit_Price__c;
            fea2=ls.Feature__c==null?'0':(ls.Feature__c=='Parts'?'1':(ls.Feature__c=='Services'?'2':(ls.Feature__c=='Protection Agreements'?'3':'4')));
            mapParentProduct.put(ls.ProductParentUnique__c+fea2+ls.Id,ls);
            if(ls.isProductParent__c){
        system.debug('ls.ProductParentUnique__c--> ' + ls.ProductParentUnique__c );
        system.debug('ls.Substituted_Product_Created_Date__c--> ' + ls.Substituted_Product_Created_Date__c );
                if(ls.Substituted_Product_Created_Date__c==null){
                    mapParentCreatedDate.put(ls.ProductParentUnique__c, ls.CreatedDate);
            		mapIsParentSubstitute.put(ls.ProductParentUnique__c, false );
                }else{
                    mapParentCreatedDate.put(ls.ProductParentUnique__c, ls.Substituted_Product_Created_Date__c);
                    if(ls.Substituted_Product__c==null){
                		mapIsParentSubstitute.put(ls.ProductParentUnique__c, false );
                    }else{
                		mapIsParentSubstitute.put(ls.ProductParentUnique__c, true );
                    }
                }
            }
            
        system.debug('mapIsParentSubstitute--> ' + mapIsParentSubstitute );
            
            sub_total += ls.Net_Total__c;
            grand_total += ls.Net_Total__c + ls.Total_Tax_Amount__c;
            grand_total_non_disc += ls.Net_Total_Non_Discount__c + ls.Total_Tax_Amount_Non_Discount__c;
            tax_total += ls.Total_Tax_Amount__c;
        system.debug('ls.Target_Customer_Amount__c--> ' + ls.Target_Customer_Amount__c );
            
            if(ls.Target_Customer_Amount__c!=null && count_target_amount==0 ){
                target_amount = ls.Target_Customer_Amount__c;
                count_target_amount++;
            }
            
    //        if(ls.Tax_Rate__c!=null && ls.Tax_Rate__c>0){
    //            deliveryTaxRate = ls.Tax_Rate__c;
   //         }

            
        }
        
        tax_total += ((delivery_charge - delivery_discount)*deliveryTaxRate).setScale(2);
   //     tax_total += deliveryTax.setScale(2);
        
            if(count_target_amount==0){
                target_amount = null;
            }

        Quote_Line_Staging__c staging_shipping = new Quote_Line_Staging__c();
		staging_shipping.Quantity__c = 1;
		staging_shipping.List_Unit_Price__c = delivery_charge;
		staging_shipping.Additional_Disc__c = delivery_discount;
     //   if(quoteRecordType=='Commercial_Flow_Business'){
        	mapParentProduct.put('Shipping',staging_shipping);
     //   }
        
        Quote_Line_Staging__c staging_tax = new Quote_Line_Staging__c();
		staging_tax.Quantity__c = 1;
	//	staging_tax.List_Unit_Price__c = tax_total;
        mapParentProduct.put('Tax',staging_tax);
        
        
        
        system.debug('count_target_amount--> ' + count_target_amount );
        system.debug('target_amount--> ' + target_amount );
        system.debug('grand_total--> ' + grand_total );
        system.debug('grand_total_non_disc--> ' + grand_total_non_disc );
        system.debug('mapParentProduct--> ' + mapParentProduct );
        
        
        lstParentProduct = new List<String>();
        /*
        for(String pp:mapParentProduct.keyset()){
            lstParentProduct.add(pp);
        }
        lstParentProduct.sort();
        */
        
        List<String> lstParentProductCreated = new List<String>();
        Map<String, String> mapParentProductCreated = new Map<String, String>();
        for(String pp:mapParentProduct.keyset()){
        //    lstParentProduct.add(pp);
        //    lstParentProductCreated.add(String.valueOf(mapParentProduct.get(pp).Number__c) + String.valueOf(mapParentProduct.get(pp).CreatedDate) + pp);
        //    mapParentProductCreated.put(String.valueOf(mapParentProduct.get(pp).Number__c) + String.valueOf(mapParentProduct.get(pp).CreatedDate) + pp, pp);
            lstParentProductCreated.add(String.valueOf(mapParentCreatedDate.get(mapParentProduct.get(pp).ProductParentUnique__c)) + pp);
            mapParentProductCreated.put(String.valueOf(mapParentCreatedDate.get(mapParentProduct.get(pp).ProductParentUnique__c)) + pp, pp);
        }
  //      lstParentProduct.sort();
        lstParentProductCreated.sort();
        
        system.debug('lstParentProductCreated--> ' + lstParentProductCreated ); 
        
        for(String pc:lstParentProductCreated){
            system.debug('pc--> ' + pc ); 
           lstParentProduct.add(mapParentProductCreated.get(pc));
        }

        
        system.debug('lstParentProduct--> ' + lstParentProduct ); 
        
        
        LineEditor objLineEditor = new LineEditor();
        integer co = 0;
        for(String ls:lstParentProduct){
            objLineEditor = new LineEditor();
            objLineEditor.seq_no = co+1;
            if(ls!='Shipping' && ls!='Tax' ){
            	mapLineEditor.put(mapParentProduct.get(ls).Id, objLineEditor);
            }else{
            	mapLineEditor.put(ls, objLineEditor);
            }
            co++;
        }
        
   //     renTable = lstParentProduct.size()>1?true:false;
   //     renTable = quoteRecordType!='Commercial_Flow_Business'?(lstParentProduct.size()>2?true:false):(lstParentProduct.size()>1?true:false);
  //      renTable = lstParentProduct.size()>(quoteRecordType=='Commercial_Flow_Business'?2:2)?true:false;
        renTable = lstParentProduct.size()>2?true:false;
        
        if(renTable){
            calculateMargin();
        }
        
  //      target_amount = grand_total;
    
        mapCLIQuantity = new Map<String, Decimal>();
        
        if(quoteRecordType == 'Amendment_Quote' && quoteMasterContract!=null && quoteMasterContract != '' ){
                List<Contract_Line_Item__c> lstContractLineItem = new List<Contract_Line_Item__c>();
                lstContractLineItem = [SELECT Id, Name, Contract__c, Amount_Processed__c, Amount_Remaining__c, Disposable_Fee__c, 
                                       Feature__c, Items_Processed__c, Items_Remaining__c, List_Unit_Price__c, Net_Unit_Price__c, 
                                       Number__c, ProductParentUnique__c, Product__c, Requested_Delivery_Date__c, Status__c, 
                                       Tax_Rate__c, Total_Amount__c, Total_Quantity__c, isProductParent__c, Configuration_Code__c, 
                                       Configuration_Option__c, Product_Code__c, Tax_Amount__c, Total_Tax_Amount__c, 
                                       Billed_Quantity__c, Billed_Value__c, Shipped_Quantity__c 
                                       FROM Contract_Line_Item__c 
                                       WHERE Contract__c=:quoteMasterContract
                                       ORDER BY Number__c
                                      ];
                
        for(Contract_Line_Item__c cli:lstContractLineItem){
       //     system.debug('qls.Product__c--> ' + qls.Product__c + ' | qls.ProductParentUnique__c--> ' + qls.ProductParentUnique__c + ' | qls.Quantity__c--> ' + qls.Quantity__c );
            mapCLIQuantity.put(cli.ProductParentUnique__c + cli.Product__c, cli.Items_Processed__c );
        }            
        
        for(String qq:mapCLIQuantity.keyset()){
            system.debug('qq--> ' + qq + ' | mapCLIQuantity.get(qq)--> ' + mapCLIQuantity.get(qq) );
        }        
        }
    
    }
    
    
    public list<selectoption> getDiscountOperator()
    {
        list<selectoption> lstSel= new list<selectoption>();
        lstSel.add(new SelectOption('Amount', '$'));            
        lstSel.add(new SelectOption('Percent', '%'));                    
        return lstSel;
    }
    
    public list<selectoption> getDiscountOperator2()
    {
        list<selectoption> lstSel= new list<selectoption>();
        lstSel.add(new SelectOption('Amount', '$'));            
        return lstSel;
    }
    
    public PageReference calculatePallet(){
        PageReference retURL = new PageReference('/apex/PalletCalculator?id=' + quoteId );
        retURL.setRedirect(true);
        return retURL;
    }
    
    public PageReference calculateDelivery(){
        PageReference retURL = new PageReference('/apex/RouteDelivery?id=' + quoteId );
        retURL.setRedirect(true);
        return retURL;
    }
    
    public PageReference calculateDelivery2(){
        
                system.debug('target_amount--> ' + target_amount );
                system.debug('lstQuoteLineStaging--> ' + lstQuoteLineStaging );
        
        if(delivery_charge==null){
            delivery_charge = 0;
        }
        if(setdelivery==null){
            setdelivery = 0;
        }
        
        setdelivery = setdelivery.setScale(2);
        
        delivery_discount = delivery_charge - setdelivery;
        
   //     if(target_amount==null || target_amount>0){
        if(target_amount==null || target_amount==0 ){
                system.debug('target_amount is null' );
            for(Quote_Line_Staging__c lp:lstQuoteLineStaging){
                lp.Target_Customer_Amount__c = null;
            }
            update lstQuoteLineStaging;
        }
        
                system.debug('target_amount--> ' + target_amount );
                system.debug('lstQuoteLineStaging--> ' + lstQuoteLineStaging );
        if(lstQuoteLineStaging.size()>0){
  //      if(target_amount>0 && grand_total_non_disc>0 && target_amount<grand_total_non_disc ){
        if(target_amount>0 && grand_total_non_disc>0){
                system.debug('target_amount is not null' );
            actionTarget();
        }else{
        List<SBQQ__Quote__c> lstQuoteDiscountUpdate = new List<SBQQ__Quote__c>();
        lstQuoteDiscountUpdate = [SELECT Id, Name, Delivery_Discount__c FROM SBQQ__Quote__c WHERE Id=:quoteId];
        if(lstQuoteDiscountUpdate.size()>0){
            for(SBQQ__Quote__c ld:lstQuoteDiscountUpdate){
                ld.Delivery_Discount__c = delivery_discount;
                system.debug('ld.Delivery_Discount__c--> ' + ld.Delivery_Discount__c );
            }
            update lstQuoteDiscountUpdate;
        }
        }
        }
        
        if(lstQuoteLineStaging.size()>0){
        PageReference retURL = new PageReference('/apex/DemarCharges?id=' + quoteId );
        retURL.setRedirect(true);
        return retURL;
        }else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'No Products Added.'));
        }
        return null;
    }
    
    
    public PageReference calculateDelivery3(){
        
        if(delivery_charge==null){
            delivery_charge = 0;
        }
        if(setdelivery==null){
            setdelivery = 0;
        }
        
        setdelivery = setdelivery.setScale(2);
        
        delivery_discount = delivery_charge - setdelivery;
        
        List<SBQQ__Quote__c> lstQuoteDeliveryUpdate = new List<SBQQ__Quote__c>();
        
        lstQuoteDeliveryUpdate = [SELECT Id, Name, isDeliveryEstimate__c FROM SBQQ__Quote__c WHERE Id=:quoteId];
        
        if(lstQuoteDeliveryUpdate.size()>0){
            for(SBQQ__Quote__c ld:lstQuoteDeliveryUpdate){
                ld.isDeliveryEstimate__c = true;
                system.debug('ld.isDeliveryEstimate__c--> ' + ld.isDeliveryEstimate__c );
            }
            update lstQuoteDeliveryUpdate;
        }
        
        List<Delivery_Estimate__c> lstDeliveryEstimate = new List<Delivery_Estimate__c>();
        
        lstDeliveryEstimate = [SELECT Id, Name FROM Delivery_Estimate__c WHERE Quote__c=:quoteId ORDER BY Id DESC LIMIT 1];
        
        if(lstDeliveryEstimate.size()>0){
        	PageReference retURL = new PageReference('/'+ lstDeliveryEstimate[0].Id  );
        	retURL.setRedirect(true);
        	return retURL;
        }else{
        	PageReference retURL = new PageReference('/'+ Delivery_Estimate__c.sobjecttype.getDescribe().getKeyPrefix() + '/e'  );
        	retURL.setRedirect(true);
        	return retURL;
        }
        
        
    }
    
    public PageReference calculateDelivery4(){
        
        if(delivery_charge==null){
            delivery_charge = 0;
        }
        if(setdelivery==null){
            setdelivery = 0;
        }
        
        setdelivery = setdelivery.setScale(2);
        
        delivery_discount = delivery_charge - setdelivery;
        
        List<SBQQ__Quote__c> lstQuoteDeliveryUpdate = new List<SBQQ__Quote__c>();
        
        lstQuoteDeliveryUpdate = [SELECT Id, Name, isDeliveryEstimate__c FROM SBQQ__Quote__c WHERE Id=:quoteId];
        
        if(lstQuoteDeliveryUpdate.size()>0){
            for(SBQQ__Quote__c ld:lstQuoteDeliveryUpdate){
                ld.isDeliveryEstimate__c = true;
                system.debug('ld.isDeliveryEstimate__c--> ' + ld.isDeliveryEstimate__c );
            }
     //       update lstQuoteDeliveryUpdate;
        }
        
        List<Delivery_Estimate__c> lstDeliveryEstimate = new List<Delivery_Estimate__c>();
        
        lstDeliveryEstimate = [SELECT Id, Name FROM Delivery_Estimate__c WHERE Quote__c=:quoteId ORDER BY Id DESC LIMIT 1];
        
        if(lstDeliveryEstimate.size()>0){
        	PageReference retURL = new PageReference('/'+ lstDeliveryEstimate[0].Id  );
        	retURL.setRedirect(true);
        	return retURL;
        }else{
        	PageReference retURL = new PageReference('/'+ Delivery_Estimate__c.sobjecttype.getDescribe().getKeyPrefix() + '/e'  );
        	retURL.setRedirect(true);
        	return retURL;
        }
        
        
    }
    
    /*
    public PageReference actionEdit(){
        String sid = System.currentPageReference().getParameters().get('sid');
        String pid = System.currentPageReference().getParameters().get('pid');
        
        List<Quote_Line_Staging__c> lstQuoteLineStagingdel = new List<Quote_Line_Staging__c>();
        lstQuoteLineStagingdel = [SELECT Id FROM Quote_Line_Staging__c WHERE ProductParentUnique__c=:sid];
        if(lstQuoteLineStagingdel.size()>0){
            delete lstQuoteLineStagingdel;
        }
        
        List<SBQQ__Quote__c> lstQuoteDiscountUpdate = new List<SBQQ__Quote__c>();
        lstQuoteDiscountUpdate = [SELECT Id, Name, Delivery_Charge__c, Delivery_Discount__c FROM SBQQ__Quote__c WHERE Id=:quoteId];
        if(lstQuoteDiscountUpdate.size()>0){
            for(SBQQ__Quote__c ld:lstQuoteDiscountUpdate){
                ld.Delivery_Charge__c = 0;
                ld.Delivery_Discount__c = 0;
            }
            update lstQuoteDiscountUpdate;
        }

        PageReference retURL = new PageReference('/apex/ProductAccesorries?id=' + quoteId + '&prodid=' + pid );
        retURL.setRedirect(true);
        return retURL;
    }
    */
    
    public PageReference actionEdit(){
        String sid = System.currentPageReference().getParameters().get('sid');
        String pid = System.currentPageReference().getParameters().get('pid');
        
            for(Quote_Line_Staging__c lp:lstQuoteLineStaging){
                if(target_amount==null || target_amount==0){
                    lp.Target_Customer_Amount__c = null;
                }else if(target_amount>0){
                    lp.Target_Customer_Amount__c = target_amount;
                }
            }
            update lstQuoteLineStaging;
        
        List<SBQQ__Quote__c> lstQuoteDiscountUpdate = new List<SBQQ__Quote__c>();
        lstQuoteDiscountUpdate = [SELECT Id, Name, Delivery_Charge__c, Delivery_Discount__c FROM SBQQ__Quote__c WHERE Id=:quoteId];
        if(lstQuoteDiscountUpdate.size()>0){
            for(SBQQ__Quote__c ld:lstQuoteDiscountUpdate){
                ld.Delivery_Charge__c = 0;
                ld.Delivery_Discount__c = 0;
            }
            update lstQuoteDiscountUpdate;
        }
            
         
   //     PageReference retURL = new PageReference('/apex/QuoteLineProducts?id=' + quoteId + '&pu=' + sid );
        PageReference retURL = new PageReference('/apex/ProductAccesorries?id=' + quoteId + '&prodid=' + pid + '&pe=' + sid );
        retURL.setRedirect(true);
        return retURL;
    }
    
    public PageReference actionClone(){
        String sid = System.currentPageReference().getParameters().get('sid');
            system.debug('target_amount--> ' + target_amount );
            for(Quote_Line_Staging__c lp:lstQuoteLineStaging){
                if(target_amount==null || target_amount==0){
                    lp.Target_Customer_Amount__c = null;
                }else if(target_amount>0){
                    lp.Target_Customer_Amount__c = target_amount;
                }
            }
            update lstQuoteLineStaging;
        
        
        List<Quote_Line_Staging__c> lstQuoteLineStagingclone = new List<Quote_Line_Staging__c>();
        lstQuoteLineStagingclone = [SELECT Id, Name, Quote__c, Product__c, Quantity__c, List_Unit_Price__c, List_Unit_Cost__c, Bundled__c, 
                               			Available_Quantity__c, PA_API_Message__c, Available__c, Earliest_Available_Date__c, 
                                    	Disposable_Fee__c, Tax_Rate__c, Tax__c, Total_Tax_Amount__c, Tax_Amount__c,//, Shipping_Charge__c
                                    	Additional_Disc__c, Discount_Operator__c, isProductParent__c, ProductParent__c, 
                                    	ProductParentUnique__c, Feature__c, Target_Customer_Amount__c, Total_Margin_Percent__c, 
                                    	Configuration_Code__c, Configuration_Option__c, Set_Unit_Price__c, Price_Source__c, //, Used_Margin_Percent__c 
                               			Substituted_Product__c, Substituted_Product_Code__c, Substituted_Product_Cost__c, 
                               			Substituted_Product_Created_Date__c, Substituted_Product_Price__c, Substituted_Product_Quantity__c,
                               			Substituted_Product_Source__c, Substitution_Reason__c
                                    FROM Quote_Line_Staging__c
                                    WHERE ProductParentUnique__c=:sid
                                   ];
        
        List<Quote_Line_Staging__c> lstQLStaging = new List<Quote_Line_Staging__c>();
        Quote_Line_Staging__c objQLStaging = new Quote_Line_Staging__c();
        String ran = String.valueOf(Math.mod(Math.round(Math.random()*1000000+1),1000000));
        
        for(Quote_Line_Staging__c cln:lstQuoteLineStagingclone){
                objQLStaging = new Quote_Line_Staging__c();
                objQLStaging.Product__c = cln.Product__c;
                objQLStaging.Quote__c = cln.Quote__c;
                objQLStaging.Quantity__c = (cln.Quantity__c==null?0:cln.Quantity__c);
                objQLStaging.Additional_Disc__c = cln.Additional_Disc__c;
                objQLStaging.Discount_Operator__c = cln.Discount_Operator__c;
                objQLStaging.List_Unit_Price__c = cln.List_Unit_Price__c;
                objQLStaging.List_Unit_Cost__c = cln.List_Unit_Cost__c;
                objQLStaging.Price_Source__c = cln.Price_Source__c;
                objQLStaging.ProductParent__c = cln.ProductParent__c;                
                objQLStaging.ProductParentUnique__c = cln.ProductParent__c + ran;                
                objQLStaging.isProductParent__c = cln.isProductParent__c;                
                objQLStaging.Feature__c = cln.Feature__c;                
                objQLStaging.Bundled__c = cln.Bundled__c;                
                objQLStaging.Available_Quantity__c = cln.Available_Quantity__c;                
                objQLStaging.PA_API_Message__c = cln.PA_API_Message__c;                
                objQLStaging.Available__c = cln.Available__c;                
                objQLStaging.Earliest_Available_Date__c = cln.Earliest_Available_Date__c;                
           //     objQLStaging.Shipping_Charge__c = cln.Shipping_Charge__c;                
                objQLStaging.Disposable_Fee__c = cln.Disposable_Fee__c;                
                objQLStaging.Tax_Rate__c = cln.Tax_Rate__c;                
            //    objQLStaging.Total_Tax_Amount__c = cln.Total_Tax_Amount__c; 
                objQLStaging.Tax_Amount__c = cln.Tax_Amount__c; 
                objQLStaging.Target_Customer_Amount__c = cln.Target_Customer_Amount__c; 
                objQLStaging.Total_Margin_Percent__c = cln.Total_Margin_Percent__c; 
             // objQLStaging.Used_Margin_Percent__c = cln.Used_Margin_Percent__c; 
                objQLStaging.Configuration_Option__c = cln.Configuration_Option__c; 
                objQLStaging.Configuration_Code__c = cln.Configuration_Code__c; 
            system.debug('objQLStaging--> ' + objQLStaging );
                lstQLStaging.add(objQLStaging);
        }
        
        
        
        if(lstQLStaging.size()>0){
            insert lstQLStaging;
        }

        List<SBQQ__Quote__c> lstQuoteDiscountUpdate = new List<SBQQ__Quote__c>();
        lstQuoteDiscountUpdate = [SELECT Id, Name, Delivery_Charge__c, Delivery_Discount__c FROM SBQQ__Quote__c WHERE Id=:quoteId];
        if(lstQuoteDiscountUpdate.size()>0){
            for(SBQQ__Quote__c ld:lstQuoteDiscountUpdate){
                ld.Delivery_Charge__c = 0;
                ld.Delivery_Discount__c = 0;
            }
            update lstQuoteDiscountUpdate;
        }

  //      actionCalculate();
        
        PageReference retURL = new PageReference('/apex/ProductIntegration?id=' + quoteId );
  //      PageReference retURL = new PageReference('/apex/QuoteLineEditor?id=' + quoteId );
        retURL.setRedirect(true);
        return retURL;
  //      return null;
    }
    
    
    
    public PageReference actionDelete(){
        String sid = System.currentPageReference().getParameters().get('sid');
                
            for(Quote_Line_Staging__c lp:lstQuoteLineStaging){
                if(target_amount==null || target_amount==0){
                    lp.Target_Customer_Amount__c = null;
                }else if(target_amount>0){
                    lp.Target_Customer_Amount__c = target_amount;
                }
            }
            update lstQuoteLineStaging;
        
        
        
        List<Quote_Line_Staging__c> lstQuoteLineStagingdel = new List<Quote_Line_Staging__c>();
        lstQuoteLineStagingdel = [SELECT Id FROM Quote_Line_Staging__c WHERE ProductParentUnique__c=:sid];
        
        if(lstQuoteLineStagingdel.size()>0){
            delete lstQuoteLineStagingdel;
        }
        
        List<SBQQ__Quote__c> lstQuoteDiscountUpdate = new List<SBQQ__Quote__c>();
        lstQuoteDiscountUpdate = [SELECT Id, Name, Delivery_Charge__c, Delivery_Discount__c FROM SBQQ__Quote__c WHERE Id=:quoteId];
        if(lstQuoteDiscountUpdate.size()>0){
            for(SBQQ__Quote__c ld:lstQuoteDiscountUpdate){
                ld.Delivery_Charge__c = 0;
                ld.Delivery_Discount__c = 0;
            }
            update lstQuoteDiscountUpdate;
        }
        
        
        
    //    	actionCalculate();
            
        
        PageReference retURL = new PageReference('/apex/ProductIntegration?id=' + quoteId );
   //     PageReference retURL = new PageReference('/apex/QuoteLineEditor?id=' + quoteId );
        retURL.setRedirect(true);
        return retURL;
   //     return null;
    }
    
    public list<selectoption> getDropSubstituteReason()
    {
        list<selectoption> lstSel= new list<selectoption>();
        lstSel.add(new SelectOption('', '--None--'));            
        lstSel.add(new SelectOption('Product Not Available/On Order', 'Product Not Available/On Order'));   
        lstSel.add(new SelectOption('Insufficient Quantity Available', 'Insufficient Quantity Available'));            
        lstSel.add(new SelectOption('Availability Date too late for customer', 'Availability Date too late for customer'));            
        lstSel.add(new SelectOption('Companion Item not available', 'Companion Item not available'));            
    //    lstSel.add(new SelectOption('Services', 'Services'));            
        
        return lstSel;
    }
    
    public void cancelSubstitutePopup() {
        displaySubstitute = false;
    }   
    
    public PageReference actionSubstitute1(){
        String sid = System.currentPageReference().getParameters().get('sid');
        system.debug('sid--> ' + sid );
        system.debug('sel_sid--> ' + sel_sid );
        sel_sid = sid;
        system.debug('sel_sid--> ' + sel_sid );
        displaySubstitute = true;
        return null;
    }
    
    
    public PageReference actionSubstitute(){
        system.debug('selSubstituteReason--> ' + selSubstituteReason );
        String sid = System.currentPageReference().getParameters().get('sid');
        system.debug('sid--> ' + sid );
        system.debug('sel_sid--> ' + sel_sid );
            for(Quote_Line_Staging__c lp:lstQuoteLineStaging){
                if(lp.ProductParentUnique__c == sel_sid && lp.isProductParent__c ){
                    lp.Substitution_Reason__c = selSubstituteReason;
                }
                if(target_amount==null || target_amount==0){
                    lp.Target_Customer_Amount__c = null;
                }else if(target_amount>0){
                    lp.Target_Customer_Amount__c = target_amount;
                }
            }
            update lstQuoteLineStaging;
        
        List<SBQQ__Quote__c> lstQuoteDiscountUpdate = new List<SBQQ__Quote__c>();
        lstQuoteDiscountUpdate = [SELECT Id, Name, Delivery_Charge__c, Delivery_Discount__c FROM SBQQ__Quote__c WHERE Id=:quoteId];
        if(lstQuoteDiscountUpdate.size()>0){
            for(SBQQ__Quote__c ld:lstQuoteDiscountUpdate){
                ld.Delivery_Charge__c = 0;
                ld.Delivery_Discount__c = 0;
            }
            update lstQuoteDiscountUpdate;
        }
        
        displaySubstitute = false;
        
        PageReference retURL = new PageReference('/apex/QuoteLineProducts?id=' + quoteId + '&pu=' + sel_sid );
   //     PageReference retURL = new PageReference('/apex/QuoteLineProducts?id=' + quoteId + '&pu=' + sid );
   //     PageReference retURL = new PageReference('/apex/QuoteLineEditor?id=' + quoteId );
        retURL.setRedirect(true);
        return retURL;
   //     return null;
    }
    
    
    
    
    
    public PageReference actionQuickSave(){
        
        if(delivery_charge==null){
            delivery_charge = 0;
        }
        if(setdelivery==null){
            setdelivery = 0;
        }
        
        setdelivery = setdelivery.setScale(2);
        
        delivery_discount = delivery_charge - setdelivery;
        
        lstQuote = new List<SBQQ__Quote__c>();
        objQuote = new SBQQ__Quote__c();
        objQuote = [SELECT Id, Name, Discount_Reason__c, Delivery_Charge__c, Delivery_Discount__c, Total_Margin_Percent__c, Approval_Stage__c, ScheduledRejectComment__c//, Used_Margin_Percent__c 
                    FROM SBQQ__Quote__c 
                    WHERE Id =: quoteId 
                    LIMIT 1
                   ];
        objQuote.Id = objQuote.Id;
  //      discount_reason = objQuote.Discount_Reason__c;
  //      objQuote.Discount_Reason__c = objQuote.Discount_Reason__c;
        objQuote.Discount_Reason__c = discount_reason;
        objQuote.Approval_Stage__c = 1;
        objQuote.ScheduledRejectComment__c = '';
        
        
            if(objQuote.Total_Margin_Percent__c!=margin_percent){
                objQuote.Total_Margin_Percent__c = margin_percent;
            }else{
                objQuote.Total_Margin_Percent__c = objQuote.Total_Margin_Percent__c;
            }

     // objQuote.Used_Margin_Percent__c = disc_mrgn;
        objQuote.Delivery_Charge__c = delivery_charge;//objQuoteMargin.Delivery_Charge__c;
        objQuote.Delivery_Discount__c = delivery_discount;//objQuoteMargin.Delivery_Discount__c;
        lstQuote.add(objQuote);
        system.debug('discount_reason--> ' + discount_reason );
        system.debug('lstQuote--> ' + lstQuote );
        system.debug('btn_press--> ' + btn_press );
        update lstQuote;
        
        
        
        displayPopup = false;   
        displayPopup2 = false;   
        displayDonePopup = true;   
    //    discount_reason = objQuote.Discount_Reason__c;
            for(Quote_Line_Staging__c lp:lstQuoteLineStaging){
                if(target_amount==null || target_amount==0){
                    lp.Target_Customer_Amount__c = null;
                }else if(target_amount>0){
                    lp.Target_Customer_Amount__c = target_amount;
                }
            }
        update lstQuoteLineStaging;
        actionQuoteLine();
    //    PageReference retURL = new PageReference('/' + quoteId );
        PageReference retURL = new PageReference('/apex/QuoteLineEditor?id=' + quoteId );
        retURL.setRedirect(true);
     //   return retURL;
        return null;
    }
    
    public PageReference actionSave(){
        if(delivery_charge==null){
            delivery_charge = 0;
        }
        if(setdelivery==null){
            setdelivery = 0;
        }
        
        setdelivery = setdelivery.setScale(2);
        
        delivery_discount = delivery_charge - setdelivery;
        
        actionCalculate();
        lstQuote = new List<SBQQ__Quote__c>();
        objQuote = new SBQQ__Quote__c();
        objQuote = [SELECT Id, Name, Discount_Reason__c, Delivery_Charge__c, Delivery_Discount__c, Total_Margin_Percent__c,//, Used_Margin_Percent__c 
                    	isApprovalReady__c, Company_Margin__c, Account_Margin__c, Approval_Submission_Time__c, Approval_Stage__c, ScheduledRejectComment__c 
                    FROM SBQQ__Quote__c 
                    WHERE Id =: quoteId 
                    LIMIT 1
                   ];
        objQuote.Id = objQuote.Id;
  //      discount_reason = objQuote.Discount_Reason__c;
  //      objQuote.Discount_Reason__c = objQuote.Discount_Reason__c;
        objQuote.Discount_Reason__c = discount_reason;
        objQuote.Approval_Stage__c = 1;
        objQuote.ScheduledRejectComment__c = '';
        
            if(objQuote.Total_Margin_Percent__c!=margin_percent){
                objQuote.Total_Margin_Percent__c = margin_percent;
            }else{
                objQuote.Total_Margin_Percent__c = objQuote.Total_Margin_Percent__c;
            }
        
        
      //  objQuote.Used_Margin_Percent__c = disc_mrgn;
        objQuote.Delivery_Charge__c = delivery_charge;//objQuoteMargin.Delivery_Charge__c;
        objQuote.Delivery_Discount__c = delivery_discount;//objQuoteMargin.Delivery_Discount__c;

        if(!objQuote.isApprovalReady__c && !isCostZero && (objQuote.Total_Margin_Percent__c< objQuote.Company_Margin__c || objQuote.Total_Margin_Percent__c< objQuote.Account_Margin__c )){
   //     if(!objQuote.isApprovalReady__c && (objQuote.Total_Margin_Percent__c< objQuote.Company_Margin__c || objQuote.Total_Margin_Percent__c< objQuote.Account_Margin__c )){
  //      if(!objQuote.isApprovalReady__c && (margin_percent< objQuote.Company_Margin__c || margin_percent< objQuote.Account_Margin__c )){
            objQuote.isApprovalReady__c = true;
            objQuote.Approval_Submission_Time__c = system.now();
        }
        
        lstQuote.add(objQuote);
        system.debug('discount_reason--> ' + discount_reason );
        system.debug('lstQuote--> ' + lstQuote );
        system.debug('btn_press--> ' + btn_press );
        update lstQuote;
        
        
        displayPopup = false;   
        displayPopup2 = false;   
        displayDonePopup = true; 
   //     discount_reason = objQuote.Discount_Reason__c;
            for(Quote_Line_Staging__c lp:lstQuoteLineStaging){
                if(target_amount==null || target_amount==0){
                    lp.Target_Customer_Amount__c = null;
                }else if(target_amount>0){
                    lp.Target_Customer_Amount__c = target_amount;
                }
            }
        update lstQuoteLineStaging;
        actionQuoteLine();
        
        
        
   //     PageReference retURL = new PageReference('/' + quoteId );
        PageReference retURL = new PageReference('/apex/RouteQuote?id=' + quoteId );
        retURL.setRedirect(true);
   //     return retURL;
        return null;
    }
    
    public PageReference actionClearDiscount(){
        
        target_amount = null;
        renClearDiscount = true;
        actionCalculate();
        PageReference retURL = new PageReference('/apex/ProductIntegration?id=' + quoteId );
        retURL.setRedirect(true);
        return retURL;
    }    
    /*
    public PageReference actionCalculate1(){
        
        if(delivery_charge==null){
            delivery_charge = 0;
        }
        if(setdelivery==null){
            setdelivery = 0;
        }

        setdelivery = setdelivery.setScale(2);
        
        delivery_discount = delivery_charge - setdelivery;

        Map<String, Decimal> mapParentProduct = new Map<String, Decimal>();
        
        system.debug('lstQuoteLineStaging--> ' + lstQuoteLineStaging );
        for(Quote_Line_Staging__c lp:lstQuoteLineStaging){
            system.debug('lp--> ' + lp );
            system.debug('lp.Quantity__c--> ' + lp.Quantity__c );
            system.debug('lp.ProductParentUnique__c--> ' + lp.ProductParentUnique__c );
                lp.Additional_Disc__c = lp.List_Unit_Price__c - (lp.Set_Unit_Price__c!=null?lp.Set_Unit_Price__c:0);
                if(lp.Quantity__c==null){
                    lp.Quantity__c=0;
                }
            if(lp.isProductParent__c ){
                mapParentProduct.put(lp.ProductParentUnique__c, lp.Quantity__c);
            }
        }
            system.debug('mapParentProduct--> ' + mapParentProduct );
        
        
   //     if(target_amount==null || target_amount>0){
        if(target_amount==null || target_amount==0 ){
                system.debug('target_amount is null' );
            for(Quote_Line_Staging__c lp:lstQuoteLineStaging){
                lp.Target_Customer_Amount__c = null;
                if(lp.Product__r.ProductCode=='haulawayRequested'){
                    lp.Quantity__c = 1;
                }else{
                    lp.Quantity__c = mapParentProduct.get(lp.ProductParentUnique__c);
                }
                if(renClearDiscount){
                lp.Additional_Disc__c = 0;
                lp.Set_Unit_Price__c = lp.List_Unit_Price__c;
                lp.Discount_Operator__c = 'Amount';
                delivery_discount = 0; 
                    setdelivery = delivery_charge - delivery_discount;  
                }
            }
            renClearDiscount = false;
            update lstQuoteLineStaging;
        }else{
            for(Quote_Line_Staging__c lp:lstQuoteLineStaging){
                if(lp.Product__r.ProductCode=='haulawayRequested'){
                    lp.Quantity__c = 1;
                }else{
                    lp.Quantity__c = mapParentProduct.get(lp.ProductParentUnique__c);
                }
            }
            update lstQuoteLineStaging;
        }
        
                system.debug('target_amount--> ' + target_amount );
                system.debug('lstQuoteLineStaging--> ' + lstQuoteLineStaging );
        if(lstQuoteLineStaging.size()>0){
  //      if(target_amount>0 && grand_total_non_disc>0 && target_amount<grand_total_non_disc ){
        if(target_amount>0 && grand_total_non_disc>0){
                system.debug('target_amount is not null' );
            actionTarget();
        }else{
        List<SBQQ__Quote__c> lstQuoteDiscountUpdate = new List<SBQQ__Quote__c>();
        lstQuoteDiscountUpdate = [SELECT Id, Name, Delivery_Discount__c FROM SBQQ__Quote__c WHERE Id=:quoteId];
        if(lstQuoteDiscountUpdate.size()>0){
            for(SBQQ__Quote__c ld:lstQuoteDiscountUpdate){
                ld.Delivery_Discount__c = delivery_discount;
                system.debug('ld.Delivery_Discount__c--> ' + ld.Delivery_Discount__c );
            }
            update lstQuoteDiscountUpdate;
        }
        }
            
          calculateMargin();  
            
        PageReference retURL = new PageReference('/apex/ProductIntegration?id=' + quoteId );
//        PageReference retURL = new PageReference('/apex/QuoteLineEditor?id=' + quoteId );
        retURL.setRedirect(true);
        return retURL;
        }
         return null;
        
    }    
        */
    public PageReference actionCalculate(){
        
        if(delivery_charge==null){
            delivery_charge = 0;
        }
        if(setdelivery==null){
            setdelivery = 0;
        }

        setdelivery = setdelivery.setScale(2);
        
        delivery_discount = delivery_charge - setdelivery;

        Map<String, Decimal> mapParentProduct = new Map<String, Decimal>();
        
   //     system.debug('lstQuoteLineStaging--> ' + lstQuoteLineStaging );
        for(Quote_Line_Staging__c lp:lstQuoteLineStaging){
            system.debug('lp--> ' + lp );
            system.debug('lp.Quantity__c--> ' + lp.Quantity__c );
            system.debug('lp.ProductParentUnique__c--> ' + lp.ProductParentUnique__c );
                lp.Additional_Disc__c = lp.List_Unit_Price__c - (lp.Set_Unit_Price__c!=null?lp.Set_Unit_Price__c:0);
                if(lp.Quantity__c==null){
                    lp.Quantity__c=0;
                }
            if(lp.isProductParent__c ){
                mapParentProduct.put(lp.ProductParentUnique__c, lp.Quantity__c);
            }
        }
            system.debug('mapParentProduct--> ' + mapParentProduct );
        
        
   //     if(target_amount==null || target_amount>0){
        if(target_amount==null || target_amount==0 ){
                system.debug('target_amount is null' );
            for(Quote_Line_Staging__c lp:lstQuoteLineStaging){
                lp.Target_Customer_Amount__c = null;
                if(lp.Product__r.ProductCode=='haulawayRequested'){
                    lp.Quantity__c = 1;
                }else{
                    lp.Quantity__c = mapParentProduct.get(lp.ProductParentUnique__c);
                }
                if(renClearDiscount){
                lp.Additional_Disc__c = 0;
                lp.Set_Unit_Price__c = lp.List_Unit_Price__c;
                lp.Discount_Operator__c = 'Amount';
                delivery_discount = 0; 
                    setdelivery = delivery_charge - delivery_discount;  
                }
            }
            renClearDiscount = false;
        }else{
            for(Quote_Line_Staging__c lp:lstQuoteLineStaging){
                if(lp.Product__r.ProductCode=='haulawayRequested'){
                    lp.Quantity__c = 1;
                }else{
                    lp.Quantity__c = mapParentProduct.get(lp.ProductParentUnique__c);
                }
            }
        }
        
        
        system.debug('quoteRecordType--> ' + quoteRecordType );
        system.debug('quoteMasterContract--> ' + quoteMasterContract );
        
        Map<String, Decimal> mapAmendmentError = new Map<String, Decimal>();
        
        if(quoteRecordType == 'Amendment_Quote' && quoteMasterContract!=null && quoteMasterContract != '' ){
            system.debug('Amendment_Quote' );
            
            for(Quote_Line_Staging__c qls:lstQuoteLineStaging){
                //       system.debug('qls--> ' + qls );
                system.debug('qls.Product__c--> ' + qls.Product__c + ' | qls.ProductParentUnique__c--> ' + qls.ProductParentUnique__c + ' | qls.Quantity__c--> ' + qls.Quantity__c );
                system.debug('mapCLIQuantity.get(qls.ProductParentUnique__c + qls.Product__c)--> ' + mapCLIQuantity.get(qls.ProductParentUnique__c + qls.Product__c) );
                if(mapCLIQuantity.get(qls.ProductParentUnique__c + qls.Product__c) != null){
                    if(mapCLIQuantity.get(qls.ProductParentUnique__c + qls.Product__c) > qls.Quantity__c ){
                        mapAmendmentError.put(qls.Product__r.ProductCode, mapCLIQuantity.get(qls.ProductParentUnique__c + qls.Product__c));
                    }
                }else{
                    if(qls.Quantity__c < 0 ){
                        mapAmendmentError.put(qls.Product__r.ProductCode, 0);
                    }
                }
            }            
            
        }
        
        system.debug('mapAmendmentError--> ' + mapAmendmentError );
        
        
        if(mapAmendmentError.size() > 0 ){
            String msgAmendmentError = '';
            for(String mae:mapAmendmentError.keySet()){
                msgAmendmentError  = '';
                msgAmendmentError = 'For Product ' + mae + ', please select Quantity more than or equal to ' + mapAmendmentError.get(mae) ;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, msgAmendmentError));
            }
        }else{
            
            update lstQuoteLineStaging;
        
                system.debug('target_amount--> ' + target_amount );
                system.debug('lstQuoteLineStaging--> ' + lstQuoteLineStaging );
        if(lstQuoteLineStaging.size()>0){
  //      if(target_amount>0 && grand_total_non_disc>0 && target_amount<grand_total_non_disc ){
        if(target_amount>0 && grand_total_non_disc>0){
                system.debug('target_amount is not null' );
            actionTarget();
        }else{
        List<SBQQ__Quote__c> lstQuoteDiscountUpdate = new List<SBQQ__Quote__c>();
        lstQuoteDiscountUpdate = [SELECT Id, Name, Delivery_Discount__c FROM SBQQ__Quote__c WHERE Id=:quoteId];
        if(lstQuoteDiscountUpdate.size()>0){
            for(SBQQ__Quote__c ld:lstQuoteDiscountUpdate){
                ld.Delivery_Discount__c = delivery_discount;
                system.debug('ld.Delivery_Discount__c--> ' + ld.Delivery_Discount__c );
            }
            update lstQuoteDiscountUpdate;
        }
        }
            
          calculateMargin();  
            
        PageReference retURL = new PageReference('/apex/ProductIntegration?id=' + quoteId );
//        PageReference retURL = new PageReference('/apex/QuoteLineEditor?id=' + quoteId );
        retURL.setRedirect(true);
        return retURL;
        }
            
            
        }
        
        
         return null;
    }
    
    public PageReference actionCancel2(){
        PageReference retURL = new PageReference('/' + quoteId );
        retURL.setRedirect(true);
        return retURL;
    }
    
    public PageReference actionCancel(){

        List<Quote_Line_Staging__c> lstStagingDel = new List<Quote_Line_Staging__c>();
        List<Quote_Line_Staging__c> lstStagingIns = new List<Quote_Line_Staging__c>();
        Quote_Line_Staging__c objStagingIns = new Quote_Line_Staging__c();
        
        lstStagingDel = [SELECT Id, Name FROM Quote_Line_Staging__c WHERE Quote__c=:quoteId];
        
        if(lstStagingDel.size()>0){
            for(Quote_Line_Staging__c del:lstStagingDel){
                system.debug('del--> ' + del );
            }
            
            delete lstStagingDel;
        }
        
        List<SBQQ__QuoteLine__c> lstQuoteLineCancel = new List<SBQQ__QuoteLine__c>();
        
        lstQuoteLineCancel = [SELECT Id, Name, SBQQ__Product__c, SBQQ__Quantity__c, Available__c, Available_Quantity__c, Earliest_Available_Date__c, 
                              	PA_API_Message__c, SBQQ__Description__c, SBQQ__Hidden__c, SBQQ__Quote__c, SBQQ__Number__c, List_Price__c, List_Cost__c, Cost_Price__c, 
                              	SBQQ__CustomerPrice__c, SBQQ__NetPrice__c, SBQQ__SpecialPrice__c, SBQQ__RegularPrice__c, SBQQ__ProratedListPrice__c, Net_Unit_Price__c, Net_Total_Price__c, 
                              	SBQQ__AdditionalDiscountAmount__c, SBQQ__Discount__c, SBQQ__AdditionalDiscount__c, Disposable_Fee__c,//, Shipping_Charge__c
                              	Tax_Rate__c, Target_Customer_Amount__c, SBQQ__ProductOption__r.SBQQ__Feature__r.Name, Feature__c, SBQQ__Bundled__c, ProductParent__c,
                              	ProductParentUnique__c, isProductParent__c, Configuration_Code__c, Configuration_Option__c, Total_Margin_Percent__c,//, Used_Margin_Percent__c
                              	CreatedDate, LastModifiedDate, Price_Source__c,
                              	Substituted_Product__c, Substituted_Product_Code__c, Substituted_Product_Cost__c, 
                              	Substituted_Product_Created_Date__c, Substituted_Product_Price__c, Substituted_Product_Quantity__c,
                              	Substituted_Product_Source__c, Substitution_Reason__c
                              FROM SBQQ__QuoteLine__c 
                              WHERE SBQQ__Quote__c=:quoteId
                             ];
        
        if(lstQuoteLineCancel.size()>0){
            
            for(SBQQ__QuoteLine__c ins:lstQuoteLineCancel){
                objStagingIns = new Quote_Line_Staging__c();
                objStagingIns.Product__c = ins.SBQQ__Product__c;
                objStagingIns.Quote__c = ins.SBQQ__Quote__c;
                objStagingIns.Quantity__c = ins.SBQQ__Quantity__c;
                objStagingIns.Additional_Disc__c = ins.SBQQ__AdditionalDiscountAmount__c;
                if(ins.SBQQ__Discount__c>0){
                    objStagingIns.Discount_Operator__c = 'Percent';
                    objStagingIns.Additional_Disc__c = ins.SBQQ__Discount__c;
                }else if(ins.SBQQ__AdditionalDiscountAmount__c>0){
                    objStagingIns.Discount_Operator__c = 'Amount';
                }
                objStagingIns.List_Unit_Price__c = ins.List_Price__c;
                objStagingIns.List_Unit_Cost__c = ins.List_Cost__c;
                objStagingIns.Price_Source__c = ins.Price_Source__c;
                objStagingIns.Available__c = ins.Available__c;
                objStagingIns.Available_Quantity__c = ins.Available_Quantity__c;
                objStagingIns.PA_API_Message__c = ins.PA_API_Message__c;
                objStagingIns.Earliest_Available_Date__c = ins.Earliest_Available_Date__c;
                objStagingIns.Bundled__c = ins.SBQQ__Bundled__c;
                objStagingIns.ProductParent__c = ins.ProductParent__c;
                objStagingIns.ProductParentUnique__c = ins.ProductParentUnique__c;
                objStagingIns.isProductParent__c = ins.isProductParent__c;
                objStagingIns.Target_Customer_Amount__c = ins.Target_Customer_Amount__c;
          //      objStagingIns.Shipping_Charge__c = ins.Shipping_Charge__c;
                objStagingIns.Disposable_Fee__c = ins.Disposable_Fee__c;
                objStagingIns.Tax_Rate__c = ins.Tax_Rate__c;
             //   objStagingIns.Feature__c = ins.SBQQ__ProductOption__r.SBQQ__Feature__r.Name;
                objStagingIns.Feature__c = ins.Feature__c;
                objStagingIns.Configuration_Option__c = ins.Configuration_Option__c;
                objStagingIns.Configuration_Code__c = ins.Configuration_Code__c; 
                objStagingIns.CreatedDate = ins.CreatedDate;
                objStagingIns.Number__c = ins.SBQQ__Number__c;
                objStagingIns.Substituted_Product__c = ins.Substituted_Product__c;
                objStagingIns.Substituted_Product_Code__c = ins.Substituted_Product_Code__c;
                objStagingIns.Substituted_Product_Cost__c = ins.Substituted_Product_Cost__c;
                objStagingIns.Substituted_Product_Created_Date__c = ins.Substituted_Product_Created_Date__c;
                objStagingIns.Substituted_Product_Price__c = ins.Substituted_Product_Price__c;
                objStagingIns.Substituted_Product_Quantity__c = ins.Substituted_Product_Quantity__c;
                objStagingIns.Substituted_Product_Source__c = ins.Substituted_Product_Source__c;
                objStagingIns.Substitution_Reason__c = ins.Substitution_Reason__c;
            //    Bundled__c, Shipping_Charge__c, Disposable_Fee__c, 
            //    Tax_Rate__c, Total_Tax_Amount__c, Tax_Amount__c, Tax__c, Target_Customer_Amount__c
                system.debug('objStagingIns--> ' + objStagingIns );
                lstStagingIns.add(objStagingIns);
            }
        }
        
        if(lstStagingIns.size()>0){
            insert lstStagingIns;
        }
        

        PageReference retURL = new PageReference('/' + quoteId );
        retURL.setRedirect(true);
        return retURL;
    }
    
    public PageReference gotoProducts()
    {
        PageReference retURL = new PageReference('/apex/QuoteLineProducts?id=' + quoteId );
        retURL.setRedirect(true);
        return retURL;
    }
    
    public PageReference actionTarget(){
        
        sub_total = 0;
        grand_total = 0;
        grand_total_non_disc = 0;
        tax_total = 0;
        
     //   grand_total+=delivery_charge - (objQuoteMargin.Delivery_Discount__c!=null?objQuoteMargin.Delivery_Discount__c:0);
   //     grand_total+=delivery_charge - delivery_discount;
   //     grand_total_non_disc+=delivery_charge;
        grand_total += (delivery_charge - delivery_discount + (delivery_charge - delivery_discount)*deliveryTaxRate).setScale(2);//(objQuoteMargin.Delivery_Discount__c!=null?objQuoteMargin.Delivery_Discount__c:0);
        grand_total_non_disc += (delivery_charge + deliveryTaxRate*delivery_charge).setScale(2) ;
        tax_total += ((delivery_charge - delivery_discount)*deliveryTaxRate).SetScale(2);
   //     tax_total += deliveryTax.SetScale(2);
        for(Quote_Line_Staging__c ls:lstQuoteLineStaging){
       //     grand_total += ls.List_Unit_Price__c-ls.;
       //     grand_total_non_disc += ls.List_Unit_Price__c*ls.Quantity__c;//*(1+ls.Tax_Rate__c);
            sub_total += ls.Net_Total__c;
            tax_total += ls.Total_Tax_Amount__c;
            grand_total += ls.Net_Total__c + ls.Total_Tax_Amount__c;
            grand_total_non_disc += ls.Net_Total_Non_Discount__c + ls.Total_Tax_Amount_Non_Discount__c;
        }
        
        
        
                system.debug('lstQuoteLineStaging--> ' + lstQuoteLineStaging );
                system.debug('target_amount--> ' + target_amount );
                system.debug('grand_total--> ' + grand_total );
                system.debug('grand_total_non_disc--> ' + grand_total_non_disc );
        
        
        //lstQuoteLineStaging
                system.debug('target_amount--> ' + target_amount );
                system.debug('grand_total--> ' + grand_total );
                system.debug('grand_total_non_disc--> ' + grand_total_non_disc );
        double target_disc = 0;
        target_disc = (grand_total_non_disc-target_amount)/grand_total_non_disc;
        
            for(Quote_Line_Staging__c lp:lstQuoteLineStaging){
                lp.Additional_Disc__c = lp.List_Unit_Price__c * target_disc;
                lp.Set_Unit_Price__c = lp.List_Unit_Price__c - (lp.List_Unit_Price__c * target_disc);
                lp.Discount_Operator__c = 'Amount';
                lp.Target_Customer_Amount__c = target_amount;
      //          grand_total += lp.List_Unit_Price__c*(1- target_disc)*lp.Quantity__c;
            }
        update lstQuoteLineStaging;
  //      update objQuoteMargin;
        
        List<SBQQ__Quote__c> lstQuoteDiscountUpdate = new List<SBQQ__Quote__c>();
        lstQuoteDiscountUpdate = [SELECT Id, Name, Delivery_Discount__c FROM SBQQ__Quote__c WHERE Id=:quoteId];
        if(lstQuoteDiscountUpdate.size()>0){
        	delivery_discount = delivery_charge * target_disc;
            delivery_discount = delivery_discount;
            setdelivery = delivery_charge - delivery_discount;
            setdelivery = setdelivery.setScale(2);
            delivery_discount = delivery_charge - setdelivery;
            for(SBQQ__Quote__c ld:lstQuoteDiscountUpdate){
            //    ld.Delivery_Discount__c = delivery_charge * target_disc;
                ld.Delivery_Discount__c = delivery_discount;
                system.debug('ld.Delivery_Discount__c--> ' + ld.Delivery_Discount__c );
            }
            update lstQuoteDiscountUpdate;
        }
        
        return null;
    }
        
    
    public PageReference actionQuoteLine()
    {
        
        List<SBQQ__QuoteLine__c> lstQuoteLineDel = new List<SBQQ__QuoteLine__c>();
        List<SBQQ__QuoteLine__c> lstQuoteLineIns = new List<SBQQ__QuoteLine__c>();
        SBQQ__QuoteLine__c objQuoteLineIns = new SBQQ__QuoteLine__c();
        
        lstQuoteLineDel = [SELECT Id, Name FROM SBQQ__QuoteLine__c WHERE SBQQ__Quote__c=:quoteId];
        
        if(lstQuoteLineDel.size()>0){
            for(SBQQ__QuoteLine__c del:lstQuoteLineDel){
                system.debug('del--> ' + del );
            }
            
            delete lstQuoteLineDel;
        }
         
        List<String> lstOptionalSKU = new List<String>();
        for(Quote_Line_Staging__c fe:lstQuoteLineStaging){
            lstOptionalSKU.add(fe.Product__c);
        }
         
        
        List<SBQQ__ProductOption__c> lstOptionTemp = new List<SBQQ__ProductOption__c>();        
        lstOptionTemp =[SELECT Id, Name, SBQQ__OptionalSKU__c
                        FROM SBQQ__ProductOption__c 
                        WHERE SBQQ__OptionalSKU__c IN: lstOptionalSKU 
                       ];
        
        Map<String, String> mapOptionalSKU = new Map<String, String>();
        for(SBQQ__ProductOption__c op:lstOptionTemp){
            mapOptionalSKU.put(op.SBQQ__OptionalSKU__c, op.Id);
        }
        
        for(Quote_Line_Staging__c ins:lstQuoteLineStaging){
            objQuoteLineIns = new SBQQ__QuoteLine__c();
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
            objQuoteLineIns.SBQQ__Number__c = mapLineEditor.get(ins.Id).seq_no;
            objQuoteLineIns.List_Price__c = ins.List_Unit_Price__c;
            objQuoteLineIns.SBQQ__ListPrice__c = ins.List_Unit_Price__c;
            objQuoteLineIns.Price_Source__c = ins.Price_Source__c;
            if(ins.Feature__c==null || ins.Feature__c=='' || ins.Feature__c=='Parts' ){
                objQuoteLineIns.Product_URL__c = 'https://www.kenmoredirect.com/#/public/product/' + ins.Product__r.ProductCode;
            }
            objQuoteLineIns.Feature__c = ins.Feature__c;
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
            objQuoteLineIns.Total_Margin_Percent__c = margin_percent;
        //    objQuoteLineIns.Used_Margin_Percent__c = disc_mrgn;
            objQuoteLineIns.ProductParent__c = ins.ProductParent__c;
            objQuoteLineIns.ProductParentUnique__c = ins.ProductParentUnique__c;
            objQuoteLineIns.isProductParent__c = ins.isProductParent__c;
            objQuoteLineIns.SBQQ__ProductOption__c = mapOptionalSKU.get(ins.Product__c);
            objQuoteLineIns.Configuration_Option__c = ins.Configuration_Option__c;
            objQuoteLineIns.Configuration_Code__c = ins.Configuration_Code__c; 
             
            if(ins.Discount_Operator__c=='Amount')
            	objQuoteLineIns.SBQQ__AdditionalDiscountAmount__c = ins.Additional_Disc__c;
            if(ins.Discount_Operator__c=='Percent')
            	objQuoteLineIns.SBQQ__Discount__c = ins.Additional_Disc__c;
            
                objQuoteLineIns.Substituted_Product__c = ins.Substituted_Product__c;
                objQuoteLineIns.Substituted_Product_Code__c = ins.Substituted_Product_Code__c;
                objQuoteLineIns.Substituted_Product_Cost__c = ins.Substituted_Product_Cost__c;
                objQuoteLineIns.Substituted_Product_Created_Date__c = ins.Substituted_Product_Created_Date__c;
                objQuoteLineIns.Substituted_Product_Price__c = ins.Substituted_Product_Price__c;
                objQuoteLineIns.Substituted_Product_Quantity__c = ins.Substituted_Product_Quantity__c;
                objQuoteLineIns.Substituted_Product_Source__c = ins.Substituted_Product_Source__c;
                objQuoteLineIns.Substitution_Reason__c = ins.Substitution_Reason__c;
            
            system.debug('objQuoteLineIns--> ' + objQuoteLineIns );
            lstQuoteLineIns.add(objQuoteLineIns);
        }
        
        if(lstQuoteLineIns.size()>0){
            insert lstQuoteLineIns;
        }    

  //      update lstQuote;
 
        
        return null;
        
    }
    /*
    public void closePopup() { 
        system.debug('objQuote--> ' + objQuote );
        system.debug('lstQuote--> ' + lstQuote );
        displayPopup = false;
        displayPopup2 = true; 
        if(btn_press=='Quick Save'){
            actionQuickSave();
        }else if(btn_press=='Save'){
            actionSave();
        }
    }  
*/
    public void closeCancelPopup() { 
        system.debug('btn_press--> ' + btn_press );
        displayPopup = false; 
        displayPopup2 = false;        
        displayDonePopup = false;        
    }     
    
    
    public void calculateMargin() {
        Double total_price = 0;
        Double total_cost = 0;
        Double order_total_price = 0;
        Double order_total_cost = 0;
        Double margin_cost = 0;
        margin_percent = 0;
        order_margin_percent = 0;
        
        isMarginEmpty = false;
        
        for(Quote_Line_Staging__c ins:lstQuoteLineStaging){
            Double tempAD = ins.Additional_Disc__c==null?0:ins.Additional_Disc__c;
            Double tempDisc =  (ins.Discount_Operator__c=='Amount' || ins.Discount_Operator__c==null) ?tempAD:((ins.List_Unit_Price__c*tempAD)/100);
      //      total_price += (ins.List_Unit_Price__c - (tempDisc==null?0:tempDisc)) * (ins.Quantity__c==null?0:ins.Quantity__c) ;
      //      total_cost += ins.List_Unit_Cost__c * (ins.Quantity__c==null?0:ins.Quantity__c) ;
        system.debug('ins.Product__r.ProductCode--> ' + ins.Product__r.ProductCode );
        system.debug('ins.Price_Source__c--> ' + ins.Price_Source__c );
        system.debug('ins.Feature__c--> ' + ins.Feature__c );
        system.debug('tempAD--> ' + tempAD );
        system.debug('tempDisc--> ' + tempDisc );
        system.debug('ins.ProductParentUnique__c--> ' + ins.ProductParentUnique__c );
        system.debug('mapIsParentSubstitute--> ' + mapIsParentSubstitute );
        //    if(ins.Feature__c==null || ins.Feature__c=='Parts' ){
    //            if(ins.Price_Source__c=='List' || (ins.Price_Source__c=='KAP' && tempDisc!=0)  ){
    //        if((ins.Feature__c==null || ins.Feature__c=='Parts') && ins.Substituted_Product__c==null ){
            if(mapIsParentSubstitute.get(ins.ProductParentUnique__c)!=null){
            if((ins.Feature__c==null || ins.Feature__c=='Parts') && !mapIsParentSubstitute.get(ins.ProductParentUnique__c) ){
                if(ins.Price_Source__c==null || ins.Price_Source__c=='' || ins.Price_Source__c=='List' || (ins.Price_Source__c=='KAP' && tempDisc!=0)  ){
        			isMarginEmpty = true;
                    total_price += ((ins.List_Unit_Price__c==null?0:ins.List_Unit_Price__c) - (tempDisc==null?0:tempDisc)) * (ins.Quantity__c==null?0:ins.Quantity__c) ;
                    total_cost += (ins.List_Unit_Cost__c==null?0:ins.List_Unit_Cost__c) * (ins.Quantity__c==null?0:ins.Quantity__c) ;
                } 
            }
            }
        system.debug('total_cost--> ' + total_cost );
        system.debug('total_price--> ' + total_price );
            if(ins.Feature__c==null || ins.Feature__c=='Parts' ){
                    order_total_price += ((ins.List_Unit_Price__c==null?0:ins.List_Unit_Price__c) - (tempDisc==null?0:tempDisc)) * (ins.Quantity__c==null?0:ins.Quantity__c) ;
                    order_total_cost += (ins.List_Unit_Cost__c==null?0:ins.List_Unit_Cost__c) * (ins.Quantity__c==null?0:ins.Quantity__c) ;
            }
        system.debug('order_total_cost--> ' + order_total_cost );
        system.debug('order_total_price--> ' + order_total_price );
            
            
        }
                
        system.debug('setdelivery--> ' + setdelivery );
        system.debug('delivery_charge--> ' + delivery_charge );
        system.debug('delivery_discount--> ' + delivery_discount );
        system.debug('total_cost--> ' + total_cost );
        system.debug('total_price--> ' + total_price );
        system.debug('order_total_cost--> ' + order_total_cost );
        system.debug('order_total_price--> ' + order_total_price );
        
        if(delivery_charge==null){
            delivery_charge = 0;
        }
        if(delivery_discount==null){
            delivery_discount = 0;
        }
        
        
        Double delivery_cost = 0;
        if(delivery_charge!=null && delivery_charge>0){
            delivery_cost = delivery_charge;
        }
        system.debug('delivery_charge--> ' + delivery_charge );
        system.debug('delivery_discount--> ' + delivery_discount );
        system.debug('delivery_cost--> ' + delivery_cost );
        
            isCostZero = false;
        
        if(total_cost>0){
     //       margin_percent = ((total_price - total_cost + delivery_charge - delivery_discount)/(total_cost+ delivery_cost))*100;
     //       margin_percent = ((total_price - total_cost)/total_cost)*100;
            margin_percent = ((total_price - total_cost)/total_price)*100;
    //        order_margin_percent = ((order_total_price - order_total_cost)/order_total_price)*100;
        }else{
            isCostZero = true;
        }
        
        if(order_total_cost>0){
            order_margin_percent = ((order_total_price - order_total_cost)/order_total_price)*100;
            
        }
        
        system.debug('margin_percent--> ' + margin_percent );
        system.debug('order_margin_percent--> ' + order_margin_percent );
        
        margin_percent = margin_percent.setScale(2);
        order_margin_percent = order_margin_percent.setScale(2);
        
        system.debug('margin_percent--> ' + margin_percent );
        system.debug('order_margin_percent--> ' + order_margin_percent );
    }
    
    public PageReference showPopup() {
        
        
        if(delivery_charge==null){
            delivery_charge = 0;
        }
        if(setdelivery==null){
            setdelivery = 0;
        }

        setdelivery = setdelivery.setScale(2);
        
        delivery_discount = delivery_charge - setdelivery;

        Map<String, Decimal> mapParentProduct = new Map<String, Decimal>();
        
   //     system.debug('lstQuoteLineStaging--> ' + lstQuoteLineStaging );
        for(Quote_Line_Staging__c lp:lstQuoteLineStaging){
            system.debug('lp--> ' + lp );
            system.debug('lp.Quantity__c--> ' + lp.Quantity__c );
            system.debug('lp.ProductParentUnique__c--> ' + lp.ProductParentUnique__c );
                lp.Additional_Disc__c = lp.List_Unit_Price__c - (lp.Set_Unit_Price__c!=null?lp.Set_Unit_Price__c:0);
                if(lp.Quantity__c==null){
                    lp.Quantity__c=0;
                }
            if(lp.isProductParent__c ){
                mapParentProduct.put(lp.ProductParentUnique__c, lp.Quantity__c);
            }
        }
            system.debug('mapParentProduct--> ' + mapParentProduct );
        
        
   //     if(target_amount==null || target_amount>0){
        if(target_amount==null || target_amount==0 ){
                system.debug('target_amount is null' );
            for(Quote_Line_Staging__c lp:lstQuoteLineStaging){
                lp.Target_Customer_Amount__c = null;
                if(lp.Product__r.ProductCode=='haulawayRequested'){
                    lp.Quantity__c = 1;
                }else{
                    lp.Quantity__c = mapParentProduct.get(lp.ProductParentUnique__c);
                }
                if(renClearDiscount){
                lp.Additional_Disc__c = 0;
                lp.Set_Unit_Price__c = lp.List_Unit_Price__c;
                lp.Discount_Operator__c = 'Amount';
                delivery_discount = 0; 
                    setdelivery = delivery_charge - delivery_discount;  
                }
            }
            renClearDiscount = false;
        }else{
            for(Quote_Line_Staging__c lp:lstQuoteLineStaging){
                if(lp.Product__r.ProductCode=='haulawayRequested'){
                    lp.Quantity__c = 1;
                }else{
                    lp.Quantity__c = mapParentProduct.get(lp.ProductParentUnique__c);
                }
            }
        }
        
        
        system.debug('quoteRecordType--> ' + quoteRecordType );
        system.debug('quoteMasterContract--> ' + quoteMasterContract );
        
        Map<String, Decimal> mapAmendmentError = new Map<String, Decimal>();
        
        if(quoteRecordType == 'Amendment_Quote' && quoteMasterContract!=null && quoteMasterContract != '' ){
            system.debug('Amendment_Quote' );
            
            for(Quote_Line_Staging__c qls:lstQuoteLineStaging){
                //       system.debug('qls--> ' + qls );
                system.debug('qls.Product__c--> ' + qls.Product__c + ' | qls.ProductParentUnique__c--> ' + qls.ProductParentUnique__c + ' | qls.Quantity__c--> ' + qls.Quantity__c );
                system.debug('mapCLIQuantity.get(qls.ProductParentUnique__c + qls.Product__c)--> ' + mapCLIQuantity.get(qls.ProductParentUnique__c + qls.Product__c) );
                if(mapCLIQuantity.get(qls.ProductParentUnique__c + qls.Product__c) != null){
                    if(mapCLIQuantity.get(qls.ProductParentUnique__c + qls.Product__c) > qls.Quantity__c ){
                        mapAmendmentError.put(qls.Product__r.ProductCode, mapCLIQuantity.get(qls.ProductParentUnique__c + qls.Product__c));
                    }
                }else{
                    if(qls.Quantity__c < 0 ){
                        mapAmendmentError.put(qls.Product__r.ProductCode, 0);
                    }
                }
            }            
            
        }
        
        system.debug('mapAmendmentError--> ' + mapAmendmentError );
        
        
        if(mapAmendmentError.size() > 0 ){
            String msgAmendmentError = '';
            for(String mae:mapAmendmentError.keySet()){
                msgAmendmentError  = '';
                msgAmendmentError = 'For Product ' + mae + ', please select Quantity more than or equal to ' + mapAmendmentError.get(mae) + ' and CLICK on CALCULATE' ;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, msgAmendmentError));
            }
        }else{
            
        
        
        
        
        
        Double total_price = 0;
        Double total_cost = 0;
        Double order_total_price = 0;
        Double order_total_cost = 0;
        Double margin_cost = 0;
        margin_percent = 0;
        order_margin_percent = 0;
        btn_press = '';
                    
        for(Quote_Line_Staging__c ins:lstQuoteLineStaging){
            Double tempAD = ins.Additional_Disc__c==null?0:ins.Additional_Disc__c;
            Double tempDisc =  (ins.Discount_Operator__c=='Amount' || ins.Discount_Operator__c==null) ?tempAD:((ins.List_Unit_Price__c*tempAD)/100);
       //     total_price += (ins.List_Unit_Price__c - (tempDisc==null?0:tempDisc)) * (ins.Quantity__c==null?0:ins.Quantity__c) ;
       //     total_cost += ins.List_Unit_Cost__c * (ins.Quantity__c==null?0:ins.Quantity__c) ;
        system.debug('ins.Price_Source__c--> ' + ins.Price_Source__c );
        system.debug('ins.Feature__c--> ' + ins.Feature__c );
        system.debug('tempAD--> ' + tempAD );
        system.debug('tempDisc--> ' + tempDisc );
        //    if(ins.Feature__c==null || ins.Feature__c=='Parts' ){
    //            if(ins.Price_Source__c=='List' || (ins.Price_Source__c=='KAP' && tempDisc!=0)  ){
    //        if((ins.Feature__c==null || ins.Feature__c=='Parts') && ins.Substituted_Product__c==null ){
            if(mapIsParentSubstitute.get(ins.ProductParentUnique__c)!=null){
            if((ins.Feature__c==null || ins.Feature__c=='Parts') && !mapIsParentSubstitute.get(ins.ProductParentUnique__c) ){
                if(ins.Price_Source__c==null || ins.Price_Source__c=='' || ins.Price_Source__c=='List' || (ins.Price_Source__c=='KAP' && tempDisc!=0)  ){
                    total_price += ((ins.List_Unit_Price__c==null?0:ins.List_Unit_Price__c) - (tempDisc==null?0:tempDisc)) * (ins.Quantity__c==null?0:ins.Quantity__c) ;
                    total_cost += (ins.List_Unit_Cost__c==null?0:ins.List_Unit_Cost__c) * (ins.Quantity__c==null?0:ins.Quantity__c) ;
                } 
            }
            }
            if(ins.Feature__c==null || ins.Feature__c=='Parts' ){
                    order_total_price += ((ins.List_Unit_Price__c==null?0:ins.List_Unit_Price__c) - (tempDisc==null?0:tempDisc)) * (ins.Quantity__c==null?0:ins.Quantity__c) ;
                    order_total_cost += (ins.List_Unit_Cost__c==null?0:ins.List_Unit_Cost__c) * (ins.Quantity__c==null?0:ins.Quantity__c) ;
            }
                        
            
        }
        
        system.debug('total_cost--> ' + total_cost );
        system.debug('total_price--> ' + total_price );
        system.debug('order_total_cost--> ' + order_total_cost );
        system.debug('order_total_price--> ' + order_total_price );
        
        if(delivery_charge==null){
            delivery_charge = 0;
        }
        if(delivery_discount==null){
            delivery_discount = 0;
        }
        
        Double delivery_cost = 0;
        if(delivery_charge!=null && delivery_charge>0){
            delivery_cost = delivery_charge;
        }
        
            isCostZero = false;
        if(total_cost>0){
 //           margin_percent = ((total_price - total_cost)/total_cost)*100;
 //           margin_percent = ((total_price - total_cost)/(total_cost+ delivery_cost))*100;
 //           margin_percent = ((total_price - total_cost + delivery_charge - delivery_discount)/(total_cost+ delivery_cost))*100;
            margin_percent = ((total_price - total_cost)/total_price)*100;
  //          order_margin_percent = ((total_price - total_cost)/total_price)*100;
        }else{
            isCostZero = true;
        }
        
        if(order_total_cost>0){
            order_margin_percent = ((order_total_price - order_total_cost)/order_total_price)*100;
            
        }
        
        
        
        btn_press = System.currentPageReference().getParameters().get('bp');
        displayPopup = false; 
        displayPopup2 = false;  
        displayDonePopup = false;        
        system.debug('btn_press--> ' + btn_press );
        system.debug('margin_percent--> ' + margin_percent );
        system.debug('order_margin_percent--> ' + order_margin_percent );
        system.debug('disc_mrgn--> ' + disc_mrgn );
        system.debug('lstQuoteLineStaging.size()--> ' + lstQuoteLineStaging.size() );
        
        
        /*
    //    if(margin_percent<=disc_mrgn && disc_mrgn>0 ){
        if(margin_percent<=disc_mrgn && disc_mrgn>0 && lstQuoteLineStaging.size()>0 ){
  //      if(margin_percent<0 ){
            if(btn_press=='Quick Save'){
                displayPopup2 = true; 
            }else if(btn_press=='Save'){
                displayPopup = true; 
          //      actionSave();
         //       PageReference retURL = new PageReference('/' + quoteId );
         //       return retURL;
            }
        }else{
          */  
        lstQuote = new List<SBQQ__Quote__c>();
        objQuote = new SBQQ__Quote__c();
        objQuote = [SELECT Id, Name, Discount_Reason__c, Total_Margin_Percent__c, Approval_Stage__c, ScheduledRejectComment__c, 
                    	SBQQ__Status__c, Delivery_Discount__c//, Used_Margin_Percent__c 
                    FROM SBQQ__Quote__c 
                    WHERE Id =: quoteId 
                    LIMIT 1
                   ];
        objQuote.Id = objQuote.Id;
   //         discount_reason = objQuote.Discount_Reason__c;
   //     objQuote.Discount_Reason__c = objQuote.Discount_Reason__c;
   /*     
        objQuote.Discount_Reason__c = discount_reason;
        objQuote.Approval_Stage__c = 1;
        objQuote.ScheduledRejectComment__c = '';
    */        
        system.debug('objQuote.Total_Margin_Percent__c--> ' + objQuote.Total_Margin_Percent__c );
        system.debug('margin_percent--> ' + margin_percent );
        system.debug('order_margin_percent--> ' + order_margin_percent );
        
            if(objQuote.Total_Margin_Percent__c!=margin_percent){
                objQuote.Total_Margin_Percent__c = margin_percent;
            }else{
                objQuote.Total_Margin_Percent__c = objQuote.Total_Margin_Percent__c;
            }

            if(objQuote.Total_Margin_Percent__c!=margin_percent){
                objQuote.Total_Margin_Percent__c = margin_percent;
            }else{
                objQuote.Total_Margin_Percent__c = objQuote.Total_Margin_Percent__c;
            }
            
       //     if(quoteRecordType=='Commercial_Flow_Business'){
       //         objQuote.SBQQ__Status__c = 'Approval';
      //      }
            
                 objQuote.Delivery_Discount__c = delivery_discount;
            

   //     objQuote.Used_Margin_Percent__c = disc_mrgn;
        lstQuote.add(objQuote);
        system.debug('lstQuote--> ' + lstQuote );
        system.debug('objQuote.Total_Margin_Percent__c--> ' + objQuote.Total_Margin_Percent__c );
        system.debug('margin_percent--> ' + margin_percent );
        system.debug('order_margin_percent--> ' + order_margin_percent );
        
            
            
            
            for(Quote_Line_Staging__c lp:lstQuoteLineStaging){
                
                    lp.Total_Margin_Percent__c = margin_percent;
                //    lp.Used_Margin_Percent__c = disc_mrgn;
                if(margin_percent==null || margin_percent==0){
                    lp.Total_Margin_Percent__c = null;
                }else if(margin_percent>0){
                    lp.Total_Margin_Percent__c = target_amount;
                }

                if(target_amount==null || target_amount==0){
                    lp.Target_Customer_Amount__c = null;
                }else if(target_amount>0){
                    lp.Target_Customer_Amount__c = target_amount;
                }
            }
        update lstQuoteLineStaging;
        actionQuoteLine();
        update lstQuote;
      //      if(btn_press=='Quick Save'){
     //           displayPopup2 = true; 
    //        }else if(btn_press=='Save'){
    //            displayPopup = true; 
    //        }
            //    PageReference retURL = new PageReference('/' + quoteId );
           //     return retURL;
           /*     
            for(Quote_Line_Staging__c lp:lstQuoteLineStaging){
                if(target_amount==null || target_amount==0){
                    lp.Target_Customer_Amount__c = null;
                }else if(target_amount>0){
                    lp.Target_Customer_Amount__c = target_amount;
                }
            }
        update lstQuoteLineStaging;
            */
            
        displayDonePopup = true;   
            if(btn_press=='Quick Save'){
        PageReference retURL = new PageReference('/apex/QuoteLineEditor?id=' + quoteId );
        retURL.setRedirect(true);
  //      return retURL;
            }else if(btn_press=='Save'){
    //    PageReference retURL = new PageReference('/' + quoteId );
        PageReference retURL = new PageReference('/apex/RouteQuote?id=' + quoteId );
        retURL.setRedirect(true);
  //      return retURL;
            }
            
            
 //       }
        }
            return null;
    }
    /*
    public PageReference showDonePopup() {
        lstQuote = new List<SBQQ__Quote__c>();
        objQuote = new SBQQ__Quote__c();
        objQuote = [SELECT Id, Name, Total_Margin_Percent__c, Used_Margin_Percent__c, Discount_Reason__c FROM SBQQ__Quote__c WHERE Id =: quoteId LIMIT 1];
        discount_reason = objQuote.Discount_Reason__c;
        objQuote.Id = objQuote.Id;
        objQuote.Discount_Reason__c = objQuote.Discount_Reason__c;
            if(objQuote.Total_Margin_Percent__c!=margin_percent){
                objQuote.Total_Margin_Percent__c = margin_percent;
            }else{
                objQuote.Total_Margin_Percent__c = objQuote.Total_Margin_Percent__c;
            }
        objQuote.Used_Margin_Percent__c = disc_mrgn;
        lstQuote.add(objQuote);
        system.debug('discount_reason--> ' + discount_reason );
        system.debug('lstQuote--> ' + lstQuote );
        update lstQuote;
        return null;
    }
    */
    public PageReference closeDonePopup() {/*
        lstQuote = new List<SBQQ__Quote__c>();
        objQuote = new SBQQ__Quote__c();
        objQuote = [SELECT Id, Name, Total_Margin_Percent__c, Used_Margin_Percent__c, Discount_Reason__c FROM SBQQ__Quote__c WHERE Id =: quoteId LIMIT 1];
        discount_reason = objQuote.Discount_Reason__c;
        objQuote.Id = objQuote.Id;
        objQuote.Discount_Reason__c = objQuote.Discount_Reason__c;
            if(objQuote.Total_Margin_Percent__c!=margin_percent){
                objQuote.Total_Margin_Percent__c = margin_percent;
            }else{
                objQuote.Total_Margin_Percent__c = objQuote.Total_Margin_Percent__c;
            }
        objQuote.Used_Margin_Percent__c = disc_mrgn;
        lstQuote.add(objQuote);
        system.debug('discount_reason--> ' + discount_reason );
        system.debug('lstQuote--> ' + lstQuote );
        system.debug('btn_press--> ' + btn_press );
        update lstQuote;*/
        
            if(btn_press=='Quick Save'){
        PageReference retURL = new PageReference('/apex/QuoteLineEditor?id=' + quoteId );
        retURL.setRedirect(true);
        return retURL;
            }else if(btn_press=='Save'){
     //   PageReference retURL = new PageReference('/' + quoteId );
        PageReference retURL = new PageReference('/apex/RouteQuote?id=' + quoteId );
        retURL.setRedirect(true);
        return retURL;
    }
        return null;
    }
    
    public void closeDescPopup() {        
        displayDescPopup = false; 
        
    }     
    
    public void showDescPopup() {        
        displayDescPopup = true; 
        String pid = System.currentPageReference().getParameters().get('pid');
        String selValue = System.currentPageReference().getParameters().get('value');
        displayDescription = '';    
        displayName = '';    
        system.debug('pid--> ' + pid );
        system.debug('selValue--> ' + selValue );
        if(selValue=='Description'){
        Product2 prDesc = new Product2();
        prDesc = [SELECT Id, Name, Description FROM Product2 WHERE Id=: pid LIMIT 1];
        if(prDesc!=null){
            displayDescription = prDesc.Description;
        	displayName = prDesc.Name;
        }
        
        if(displayDescription==null || displayDescription=='' ){
            displayDescription = 'No Description';
        	displayName = 'No Description';
        }
        }else if(selValue=='Configuration'){
        	Boolean isPar = Boolean.valueOf(System.currentPageReference().getParameters().get('isParent'));
            if(isPar){
        		if(pid!=null){
           		//	displayName = pid;
            		displayName = 'Configuration Option Selected';
           	//		displayDescription = mapConfiguration.get(pid);
           			displayDescription = pid;
        		}
        		if(displayDescription==null || displayDescription=='' ){
            	//	displayName = 'No Configuration';
            		displayName = 'Configuration Option Selected';
            		displayDescription = 'No Configuration';
        		}
            }
        }
    }
    
    public void showTripsPopup() {
        displayTrips = true;
    }   
    
    public void cancelTripsPopup() {
        displayTrips = false;
    }   
    
    public Pagereference closeTripsPopup() {        
        displayTrips = false;
        delivery_charge = qty_trips*trips_cost;
        setdelivery = delivery_charge;
        delivery_discount = delivery_charge - setdelivery;
        
        
        List<SBQQ__Quote__c> lstQuoteTrips = new List<SBQQ__Quote__c>();
        lstQuoteTrips = [SELECT Id, Delivery_Charge__c, Number_of_Trips__c FROM SBQQ__Quote__c WHERE Id =: quoteId LIMIT 1];
        if(lstQuoteTrips.size()>0){
            for(SBQQ__Quote__c qt:lstQuoteTrips){
                qt.Delivery_Charge__c = delivery_charge;
                qt.Number_of_Trips__c = qty_trips;
            }
        }
        update lstQuoteTrips;
        
    //    PageReference retURL = new PageReference('/apex/QuoteLineEditor?id=' + quoteId );
        PageReference retURL = new PageReference('/apex/ProductIntegration?id=' + quoteId );
        retURL.setRedirect(true);
        return retURL;
        
    }     
    
    
    
    
    public class LineEditor{
        public Integer seq_no {get;set;}/*
        public String product_code {get;set;}
        public String product_name {get;set;}
        public Integer quantity {get;set;}
        public double list_unit_price {get;set;}
        public decimal add_discount_amount {get;set;}
        public decimal add_discount_percent {get;set;}
        public decimal discount_percent {get;set;}
        public boolean available {get;set;}
        public integer available_quantity {get;set;}
        public date available_date {get;set;}
        public String available_message {get;set;}
        public String description {get;set;}
        public double net_unit_price {get;set;}
        public double net_total {get;set;}   
        public boolean edit_quantity {get;set;}
        public boolean edit_discount {get;set;}
        */
    }
    
    
    
   
}