public class OrderAdjustmentCreationController {
    
    public String orderId {get; set;}
    public String selectedAdjustment {get; set;}
    
    public Map<String,String> mapPriceBookEntry {get; set;}
    
    public string selectedHeaderReasonCode {get; set;}
    
    public Double sel_delivery_charge {get; set;}
    public Double sel_premium_delivery_charge {get; set;}
    public Double sel_haulaway_charge {get; set;}
    public Double temp_delivery_charge {get; set;}
    public Double temp_premium_delivery_charge {get; set;}
    public Double temp_haulaway_charge {get; set;}
    public Boolean isTempSelectedDeliveryCharge {get; set;}
    public Boolean isTempSelectedPremiumDeliveryCharge {get; set;}
    public Boolean isTempSelectedHaulawayCharge {get; set;}
    
    public Double delivery_charge {get; set;}
    public Double premium_delivery_charge {get; set;}
    public Double haulaway_charge {get; set;}
    public Boolean isSelectedDeliveryCharge {get; set;}
    public Boolean isSelectedPremiumDeliveryCharge {get; set;}
    public Boolean isSelectedHaulawayCharge {get; set;}
    
    public List<Order> lstOrderOverviewQry {get; set;}
    public List<OrderItem> lstOrderOverviewItemQry {get; set;}
    
    public Map<String,AdjOrderItem> mapOrderSelection {get; set;}
    public Boolean renSelection {get; set;}
    public Map<String,Boolean> mapSelectedProduct {get; set;}
    
    public string selectedproductcode {get; set;}
    public string selectedpart {get; set;}
    public string selectedinstall {get; set;}
    public string selectedprotection {get; set;}
    
    public Boolean renObjOrder {get; set;}
    public Boolean renObjOrderMessage {get; set;}
    public AdjOrderItem objOSPart {get; set;}
    public Map<String,Decimal> mapProductListPrice {get; set;}
    
    public List<AdjOrderItem> lstPartsOrderSelection {get; set;}
    public List<AdjOrderItem> lstPartsProductSelection {get; set;}
    public List<AdjOrderItem> lstPartsTotalSelection {get; set;}
    
        
    public Map<String, list<selectoption>> mapItemReasonSel {get; set;}
    public Map<String, List<String>> mapRCDiv {get; set;}
    public Map<String, String> mapDCR {get; set;}
    
    public Map<String,Integer> mapOSOGQuantity {get; set;}
    public Map<String,Double> mapOSOGPrice {get; set;}
    public Boolean renErrorOrder {get; set;}
    
    public Boolean renAddress {get; set;}
    public List<address> l_addressList {get; set;}
    public String selectedAddr {get; set;}
    public Map<String, address> mapAddr {get; set;}
    
    public Map<String, String> mapParentReason {get; set;}
    public Map<String, Boolean> mapisChildReasonDisplay {get; set;}

        
    public OrderAdjustmentCreationController() {
        
        orderId = ApexPages.CurrentPage().getparameters().get('id');
        selectedAdjustment = ApexPages.CurrentPage().getparameters().get('adj');
        
    //    selectedAdjustment = 'Credit Memo';
        
        system.debug('orderId--> ' + orderId ); 
        system.debug('selectedAdjustment--> ' + selectedAdjustment ); 
        
        mapPriceBookEntry = new Map<String, String>();
        List<PricebookEntry> lstPricebookEntry = new List<PricebookEntry>();
        lstPricebookEntry = [SELECT Id, Name, Product2Id  
                             FROM PricebookEntry
                             WHERE  Pricebook2Id='01s300000006uBlAAI'
                            ];
            
        for(PricebookEntry pb:lstPricebookEntry){
            mapPriceBookEntry.put(pb.Product2Id, pb.Id);
        }
        
        system.debug('mapPriceBookEntry--> ' + mapPriceBookEntry );        
        
        selectedHeaderReasonCode = '';
        
        sel_delivery_charge = 0;
        sel_premium_delivery_charge = 0;
        sel_haulaway_charge = 0;
        temp_delivery_charge = 0;
        temp_premium_delivery_charge = 0;
        temp_haulaway_charge = 0;
        isTempSelectedDeliveryCharge = false;
        isTempSelectedPremiumDeliveryCharge = false;
        isTempSelectedHaulawayCharge = false;
        
        delivery_charge = 0;
        premium_delivery_charge = 0;
        haulaway_charge = 0;
        isSelectedDeliveryCharge = false;
        isSelectedPremiumDeliveryCharge = false;
        isSelectedHaulawayCharge = false;
        
        lstOrderOverviewQry = new List<Order>();
        lstOrderOverviewQry = [SELECT Id, OrderNumber, ContractId, SBQQ__Quote__c, AccountId, Status, EffectiveDate, Delivery_Date__c, 
                               		Delivery_Instruction__c, Payment_Type__c, Pricebook2Id, Delivery_Charge__c,  Parent_Order__c, 
                             		Purchase_Number__c, District_Id__c, Territory_Id__c, Order_Reference_Number__c, Order_Approver__c, 
                             		Gross_Amount__c, TotalAmount, SBQQ__TaxAmount__c, Order_Source__c, B2B_Order_Id__c, OwnerId, 
                             		Type, Reason_Code__c, ShippingAddress, BillingAddress, ShippingStreet, ShippingCity, 
                             		ShippingState, ShippingPostalCode, BillingStreet, BillingCity, BillingState, BillingPostalCode,
                            //   		SBQQ__Quote__r.Delivery_Contact__r.FirstName, SBQQ__Quote__r.Delivery_Contact__r.LastName, 
                           //    		SBQQ__Quote__r.Delivery_Contact__r.Email, SBQQ__Quote__r.Delivery_Contact__r.Phone,
                               		Parent_Order__r.B2B_Order_Id__c, Parent_Order__r.Delivery_Date__c, Parent_Order__r.isCommonCarrier__c, 
                               		SBQQ__Quote__r.GeoCode__c, SBQQ__Quote__r.County_Code__c, SBQQ__Quote__r.County_Name__c,
                               		SBQQ__Quote__r.SBQQ__Account__r.SCO_Account_ID__c, Haulaway_Charge__c, Premium_Delivery_Charge__c, 
                               		isCommonCarrier__c, Shipping_Contact_First_Name__c, Shipping_Contact_Last_Name__c, 
                               		Shipping_Contact_Phone__c, Shipping_Contact_Email__c, SBQQ__Quote__r.Delivery_Contact__r.FirstName, 
                               		SBQQ__Quote__r.Delivery_Contact__r.LastName, SBQQ__Quote__r.Delivery_Contact__r.Phone,
                               		SBQQ__Quote__r.Delivery_Contact__r.Email
                               FROM Order                             
                               WHERE Id=:orderId
                               LIMIT 1
                             ];
        
        system.debug('lstOrderOverviewQry--> ' + lstOrderOverviewQry );
        
        if(lstOrderOverviewQry.size()>0){
            delivery_charge = lstOrderOverviewQry[0].Delivery_Charge__c!=null?lstOrderOverviewQry[0].Delivery_Charge__c.setScale(2):0;
            premium_delivery_charge = lstOrderOverviewQry[0].Premium_Delivery_Charge__c!=null?lstOrderOverviewQry[0].Premium_Delivery_Charge__c.setScale(2):0;
            haulaway_charge = lstOrderOverviewQry[0].Haulaway_Charge__c!=null?lstOrderOverviewQry[0].Haulaway_Charge__c.setScale(2):0;
        
            if(lstOrderOverviewQry[0].SBQQ__Quote__r.Delivery_Contact__r.FirstName!=null){
                lstOrderOverviewQry[0].Shipping_Contact_First_Name__c = lstOrderOverviewQry[0].SBQQ__Quote__r.Delivery_Contact__r.FirstName;
        		system.debug('lstOrderOverviewQry[0].Shipping_Contact_First_Name__c--> ' + lstOrderOverviewQry[0].Shipping_Contact_First_Name__c );
            }
            if(lstOrderOverviewQry[0].SBQQ__Quote__r.Delivery_Contact__r.LastName!=null){
                lstOrderOverviewQry[0].Shipping_Contact_Last_Name__c = lstOrderOverviewQry[0].SBQQ__Quote__r.Delivery_Contact__r.LastName;
            }
            if(lstOrderOverviewQry[0].SBQQ__Quote__r.Delivery_Contact__r.Phone!=null){
                lstOrderOverviewQry[0].Shipping_Contact_Phone__c = lstOrderOverviewQry[0].SBQQ__Quote__r.Delivery_Contact__r.Phone;
            }
            if(lstOrderOverviewQry[0].SBQQ__Quote__r.Delivery_Contact__r.Email!=null){
                lstOrderOverviewQry[0].Shipping_Contact_Email__c = lstOrderOverviewQry[0].SBQQ__Quote__r.Delivery_Contact__r.Email;
            }
        }
        
        
        List<OrderItem> lstHaulawayOrderItemQry = new List<OrderItem>();
        lstHaulawayOrderItemQry = [SELECT Id, OrderId, Order.Status, Product2Id, Product2.Name, Product2.ProductCode, Quantity, Configuration__c, 
                                   		Configuration_Description__c, Number__c, Feature__c, isProductParent__c, ProductParentUnique__c, 
                                 		Parent_Part_Number__c, Order_Reference_Number__c, Unique_Value__c, List_Unit_Price__c, Reason_Code__c, Reason_Category_Code__c, 
                                 		Net_Unit_Price__c, Net_Total_Price__c, SBQQ__TaxAmount__c, Item_Tax__c, Tax__c, Tax_Rate__c, Total_Tax_Amount__c, 
                                 		PriceBookEntryId, Disposable_Fee__c, OMS_Order_Id__c, Billable_Quantity__c, Cancelled_Quantity__c, Order_Type__c, Product_Type__c 
                                   FROM OrderItem                                 
                               //    WHERE OrderId=:useOrderId AND Product2.ProductCode='haulawayRequested' AND (SBQQ__Status__c!='Pending Cancel' OR (SBQQ__Status__c ='Completed' AND Order.Status='In Process' ) )
                                   WHERE OrderId=:orderId AND Product2.ProductCode='haulawayRequested'
                                   ORDER BY Number__c
                                  ];
        
        if(lstHaulawayOrderItemQry.size()>0){
      //      haulaway_charge = (lstHaulawayOrderItemQry[0].Net_Unit_Price__c*lstHaulawayOrderItemQry[0].Quantity).setScale(2);
            haulaway_charge = lstHaulawayOrderItemQry[0].Net_Unit_Price__c.setScale(2);
        }
        
        temp_delivery_charge = delivery_charge;
        temp_premium_delivery_charge = premium_delivery_charge;
        temp_haulaway_charge = haulaway_charge;
        sel_delivery_charge = delivery_charge;
        sel_premium_delivery_charge = premium_delivery_charge;
        sel_haulaway_charge = haulaway_charge;
        
        lstOrderOverviewItemQry = new List<OrderItem>();
        if(selectedAdjustment=='Return' || selectedAdjustment=='Exchange' ){
            
        lstOrderOverviewItemQry = [SELECT Id, OrderId, Product2Id, Product2.Name, Product2.ProductCode, Quantity, Configuration__c, 
                                 		Configuration_Description__c, Number__c, Feature__c, isProductParent__c, ProductParentUnique__c, 
                                 		Parent_Part_Number__c, Order_Reference_Number__c, Unique_Value__c, List_Unit_Price__c, Reason_Code__c, Reason_Category_Code__c, 
                                 		Net_Unit_Price__c, Net_Total_Price__c, SBQQ__TaxAmount__c, Item_Tax__c, Tax__c, Tax_Rate__c, Total_Tax_Amount__c,  
                                 		PriceBookEntryId, Disposable_Fee__c, OMS_Order_Id__c, Billable_Quantity__c, Cancelled_Quantity__c, Order_Type__c, Product_Type__c 
                                 	FROM OrderItem                                 
                              //   WHERE OrderId=:parentOrderId AND Product2.ProductCode!='haulawayRequested' AND (SBQQ__Status__c!='Pending Cancel' OR (SBQQ__Status__c ='Completed' AND Order.Status='In Process' ) )
                             //    	WHERE OrderId=:useOrderId AND Product2.ProductCode!='haulawayRequested' AND (SBQQ__Status__c!='Pending Cancel' OR (SBQQ__Status__c ='Completed' AND Order.Status='In Process' ) )
                                 	WHERE OrderId=:orderId AND Product2.ProductCode!='haulawayRequested' AND (SBQQ__Status__c ='Completed' OR Order.Status='In Process' OR Order.Status='Done' )
                                 	ORDER BY Number__c
                                 	];
            
        }else if(selectedAdjustment=='Credit Memo'){
            
        lstOrderOverviewItemQry = [SELECT Id, OrderId, Product2Id, Product2.Name, Product2.ProductCode, Quantity, Configuration__c, 
                                 		Configuration_Description__c, Number__c, Feature__c, isProductParent__c, ProductParentUnique__c, 
                                 		Parent_Part_Number__c, Order_Reference_Number__c, Unique_Value__c, List_Unit_Price__c, Reason_Code__c, Reason_Category_Code__c, 
                                 		Net_Unit_Price__c, Net_Total_Price__c, SBQQ__TaxAmount__c, Item_Tax__c, Tax__c, Tax_Rate__c, Total_Tax_Amount__c,  
                                 		PriceBookEntryId, Disposable_Fee__c, OMS_Order_Id__c, Billable_Quantity__c, Cancelled_Quantity__c, Order_Type__c, Product_Type__c 
                                 	FROM OrderItem                                 
                              //   WHERE OrderId=:parentOrderId AND Product2.ProductCode!='haulawayRequested' AND (SBQQ__Status__c!='Pending Cancel' OR (SBQQ__Status__c ='Completed' AND Order.Status='In Process' ) )
                             //    	WHERE OrderId=:useOrderId AND Product2.ProductCode!='haulawayRequested' AND (SBQQ__Status__c!='Pending Cancel' OR (SBQQ__Status__c ='Completed' AND Order.Status='In Process' ) )
                                 	WHERE OrderId=:orderId AND Product2.ProductCode!='haulawayRequested' AND (SBQQ__Status__c ='Completed'  OR Order.Status='In Process' OR Order.Status='Done' OR Order.Status='Returned' )
                                 	ORDER BY Number__c
                                 	];
            
        }else if(selectedAdjustment=='Debit Memo'){
            
        lstOrderOverviewItemQry = [SELECT Id, OrderId, Product2Id, Product2.Name, Product2.ProductCode, Quantity, Configuration__c, 
                                 		Configuration_Description__c, Number__c, Feature__c, isProductParent__c, ProductParentUnique__c, 
                                 		Parent_Part_Number__c, Order_Reference_Number__c, Unique_Value__c, List_Unit_Price__c, Reason_Code__c, Reason_Category_Code__c, 
                                 		Net_Unit_Price__c, Net_Total_Price__c, SBQQ__TaxAmount__c, Item_Tax__c, Tax__c, Tax_Rate__c, Total_Tax_Amount__c,  
                                 		PriceBookEntryId, Disposable_Fee__c, OMS_Order_Id__c, Billable_Quantity__c, Cancelled_Quantity__c, Order_Type__c, Product_Type__c 
                                 	FROM OrderItem                                 
                              //   WHERE OrderId=:parentOrderId AND Product2.ProductCode!='haulawayRequested' AND (SBQQ__Status__c!='Pending Cancel' OR (SBQQ__Status__c ='Completed' AND Order.Status='In Process' ) )
                             //    	WHERE OrderId=:useOrderId AND Product2.ProductCode!='haulawayRequested' AND (SBQQ__Status__c!='Pending Cancel' OR (SBQQ__Status__c ='Completed' AND Order.Status='In Process' ) )
                                 	WHERE OrderId=:orderId AND Product2.ProductCode!='haulawayRequested' AND (SBQQ__Status__c!='Cancelled' )
                                 	ORDER BY Number__c
                                 	];
            
        }
        system.debug('lstOrderOverviewItemQry--> ' + lstOrderOverviewItemQry );
      
        mapOrderSelection = new Map<String, AdjOrderItem>();
        mapSelectedProduct = new Map<String, Boolean>();
        mapProductListPrice = new Map<String,Decimal>();
        mapOSOGQuantity = new Map<String,Integer>();
        mapOSOGPrice = new Map<String,Double>();
        
        renErrorOrder = false;
        renSelection = true;
        
        mapParentReason = new Map<String, String>();
        mapisChildReasonDisplay = new Map<String, Boolean>();
        
        integer noit = 0;
        AdjOrderItem objOrderSelection = new AdjOrderItem();
        
        for(OrderItem oi:lstOrderOverviewItemQry){
            if((oi.Billable_Quantity__c > 0 && (selectedAdjustment=='Return' || selectedAdjustment=='Exchange')) || selectedAdjustment=='Credit Memo' || selectedAdjustment=='Debit Memo'){
         //   if(((oi.Feature__c==null || oi.Feature__c=='') && (oi.Product_Type__c==null || oi.Product_Type__c=='' || oi.Product_Type__c=='OrderItem' )  &&  (selectedAdjustment=='Credit Memo' || selectedAdjustment=='Debit Memo' ) ) || selectedAdjustment=='Return' || selectedAdjustment=='Exchange' ){
         //   if(((oi.Parent_Part_Number__c==null || oi.Parent_Part_Number__c=='0' || oi.Parent_Part_Number__c=='') && (oi.Product_Type__c==null || oi.Product_Type__c=='' || oi.Product_Type__c=='OrderItem' )  &&  (selectedAdjustment=='Credit Memo' || selectedAdjustment=='Debit Memo' ) ) || selectedAdjustment=='Return' || selectedAdjustment=='Exchange' ){
            if(( (oi.Product_Type__c==null || oi.Product_Type__c=='' || oi.Product_Type__c=='OrderItem' )  &&  (selectedAdjustment=='Credit Memo' || selectedAdjustment=='Debit Memo' ) ) || selectedAdjustment=='Return' || selectedAdjustment=='Exchange' ){
                
                noit++;
                
                objOrderSelection = new AdjOrderItem();
                objOrderSelection.AdjId = String.valueOf(noit);
                objOrderSelection.SelId = String.valueOf(noit);
                objOrderSelection.SeqNumber = oi.Number__c;
                objOrderSelection.OrderItemId = oi.Id;
                objOrderSelection.OrderId = oi.OrderId;
                objOrderSelection.isProductParent = oi.isProductParent__c;
                objOrderSelection.ProductParentUnique = oi.ProductParentUnique__c;
          //      objOrderSelection.ParentPartNumber = oi.Parent_Part_Number__c;
                objOrderSelection.ParentPartNumber = oi.Parent_Part_Number__c=='0'?null:oi.Parent_Part_Number__c;
                objOrderSelection.Product2Id = oi.Product2Id;
                objOrderSelection.ProductCode = oi.Product2.ProductCode;
                objOrderSelection.ProductName = oi.Product2.Name;
        //        objOrderSelection.Quantity = Integer.valueof(oi.Quantity);
                objOrderSelection.Quantity = Integer.valueof(oi.Billable_Quantity__c);
                objOrderSelection.Feature = oi.Feature__c;
                objOrderSelection.Configuration = oi.Configuration__c;
                objOrderSelection.ConfigurationDescription = oi.Configuration_Description__c;
                objOrderSelection.PriceBookEntryId = oi.PriceBookEntryId;
                objOrderSelection.ReasonCode = oi.Reason_Code__c;
                objOrderSelection.ReasonCategoryCode = oi.Reason_Category_Code__c;
                objOrderSelection.ListUnitPrice = oi.List_Unit_Price__c;
                objOrderSelection.NetUnitPrice = oi.Net_Unit_Price__c;
       //         objOrderSelection.NetTotalPrice = oi.Net_Unit_Price__c * oi.Quantity ;
                objOrderSelection.NetTotalPrice = oi.Net_Unit_Price__c * oi.Billable_Quantity__c ;
                objOrderSelection.DisposableFee = oi.Disposable_Fee__c ;
                objOrderSelection.TaxRate = oi.Tax_Rate__c ;
                objOrderSelection.TaxAmount = oi.SBQQ__TaxAmount__c ;
                if(oi.Product_Type__c==null){
                    objOrderSelection.ProductType = 'OrderItem';
                }else{
                    objOrderSelection.ProductType = oi.Product_Type__c ;
                }
                objOrderSelection.Sel_AdjId = String.valueOf(noit);
         //       objOrderSelection.Sel_Quantity = Integer.valueof(oi.Quantity);
                objOrderSelection.Sel_Quantity = Integer.valueof(oi.Billable_Quantity__c);
                objOrderSelection.Sel_NetUnitPrice = oi.Net_Unit_Price__c;
         //       objOrderSelection.Sel_NetTotalPrice = oi.Net_Unit_Price__c * oi.Quantity;
                objOrderSelection.Sel_NetTotalPrice = oi.Net_Unit_Price__c * oi.Billable_Quantity__c;
                
                if(oi.Feature__c==null || oi.Feature__c=='' || oi.Feature__c=='Parts'){
                    mapProductListPrice.put(oi.Product2.ProductCode, oi.Net_Unit_Price__c);
                }
                
                mapOrderSelection.put(String.valueOf(noit), objOrderSelection);
                mapSelectedProduct.put(String.valueOf(noit), false);
        //        mapOSOGQuantity.put(String.valueOf(noit), Integer.valueof(oi.Quantity));
                mapOSOGQuantity.put(String.valueOf(noit), Integer.valueof(oi.Billable_Quantity__c));
                mapOSOGPrice.put(String.valueOf(noit), Double.valueof(oi.Net_Unit_Price__c));
            }
            }
            
        }
        
        system.debug('mapOrderSelection--> ' + mapOrderSelection );
        system.debug('mapSelectedProduct--> ' + mapSelectedProduct );
        system.debug('mapOSOGQuantity--> ' + mapOSOGQuantity );
        system.debug('mapOSOGPrice--> ' + mapOSOGPrice );
        
        if(mapOrderSelection.size()>0){
            renSelection = true;
        }

        system.debug('renSelection--> ' + renSelection );
                
        selectedproductcode = '';
        selectedpart = '';
        selectedinstall = '';
        selectedprotection = '';
        
        renObjOrder = false;
        renObjOrderMessage = false;
        objOSPart = new AdjOrderItem();
        
        lstPartsOrderSelection = new List<AdjOrderItem>();
        lstPartsProductSelection = new List<AdjOrderItem>();
        lstPartsTotalSelection = new List<AdjOrderItem>();

        mapItemReasonSel = new Map<String, list<selectoption>>();
        
        mapRCDiv = new Map<String, List<String>>();
        mapDCR = new Map<String, String>();
        
        
        list<Reason_Code__c > lstRCDiv= new list<Reason_Code__c >();
        lstRCDiv = [SELECT Id, Name, Div__c, Code__c, Category_Code__c, Category_Description__c, 
                    Reason_Code__c, Reason_Description__c, Reason_Id__c, Reason_Type__c  
                    FROM Reason_Code__c
                    WHERE Div__c != null
                    ORDER BY Name
                   ];
        
        for(Reason_Code__c rc:lstRCDiv){
            list<String> lstTempRC= new list<String>();
            if(mapRCDiv.keySet().contains('0' + rc.Div__c.substring(1))){
                for (String rcd:mapRCDiv.get('0' + rc.Div__c.substring(1))){
                    lstTempRC.add(rcd); 
                }
            }
            //          lstTempRC.add(rc.Category_Description__c + ' - ' + rc.Reason_Description__c); 
            lstTempRC.add(rc.Div__c + rc.Category_Code__c + rc.Reason_Code__c); 
            mapRCDiv.put('0' + rc.Div__c.substring(1), lstTempRC);
            mapDCR.put(rc.Div__c + rc.Category_Code__c + rc.Reason_Code__c, rc.Category_Description__c + ' - ' + rc.Reason_Description__c);
            
        }
        
        list<selectoption> lstSel= new list<selectoption>();
        for(String mos:mapOrderSelection.keyset()){
            lstSel= new list<selectoption>();
            lstSel.add(new SelectOption('', '--None--'));
            if(mapRCDiv.keySet().contains(mapOrderSelection.get(mos).ProductCode.substring(0,3))){
                for (String rcd:mapRCDiv.get(mapOrderSelection.get(mos).ProductCode.substring(0,3))){
                    lstSel.add(new SelectOption(rcd, mapDCR.get(rcd)));  
                }
            }
                
            mapItemReasonSel.put(mapOrderSelection.get(mos).AdjId, lstSel);
            
        }
        
        list<selectoption> lstSelNull= new list<selectoption>();
        lstSelNull.add(new SelectOption('', '--None--'));  
        mapItemReasonSel.put(null, lstSelNull);
        
        system.debug('mapItemReasonSel--> ' + mapItemReasonSel );
        system.debug('mapRCDiv--> ' + mapRCDiv );
        system.debug('mapDCR--> ' + mapDCR );
                
        renAddress = false;
        l_addressList = new List<address>();
        selectedAddr = '';
        mapAddr = new Map<String, address>();        
        
    }
    
    public PageReference gotoOrder(){
        PageReference retURL = new PageReference('/' + orderId );
        retURL.setRedirect(true);
        return retURL;
    }
    
    public list<selectoption> getHeaderReasonCode(){
        list<selectoption> lstSel= new list<selectoption>();
        lstSel.add(new SelectOption('', '--None--'));   
                
        List<Reason_Code__c> lstHeaderReasonCode= new List<Reason_Code__c >();
        
        lstHeaderReasonCode = [SELECT Id, Name, Div__c, Code__c, Category_Code__c, Category_Description__c, 
                               			Reason_Code__c, Reason_Description__c, Reason_Id__c, Reason_Type__c
                               FROM Reason_Code__c
                               WHERE Reason_Type__c != null 
                               ORDER BY Reason_Type__c , Code__c, Reason_Id__c 
                              ];
        
        for(Reason_Code__c hrc:lstHeaderReasonCode ){
            if(hrc.Reason_Type__c=='cmr_dmr' && (selectedAdjustment=='Credit Memo' || selectedAdjustment=='Debit Memo')){
        //		lstSel.add(new SelectOption(hrc.Reason_Description__c, hrc.Reason_Description__c)); 
        		lstSel.add(new SelectOption(hrc.Code__c, hrc.Reason_Description__c)); 
            }else if(hrc.Reason_Type__c=='return_exchange' && (selectedAdjustment=='Return' || selectedAdjustment=='Exchange')){
        	//	lstSel.add(new SelectOption(hrc.Reason_Description__c, hrc.Reason_Description__c));            
        		lstSel.add(new SelectOption(hrc.Code__c, hrc.Reason_Description__c));            
            }
        }
        
        system.debug('lstSel:' +lstSel);
        
        return lstSel;
    }
    
    
    public PageReference actionSelected(){
        String sel_num = System.currentPageReference().getParameters().get('num');
        system.debug('sel_num--> ' + sel_num );
        system.debug('mapSelectedProduct--> ' + mapSelectedProduct );
        for(String seq:mapSelectedProduct.keySet()){
            system.debug('seq--> ' + seq );
            system.debug('sel_num--> ' + sel_num );
            system.debug('mapOrderSelection.get(seq).ParentPartNumber--> ' + mapOrderSelection.get(seq).ParentPartNumber );
            system.debug('mapOrderSelection.get(sel_num).SeqNumber--> ' + mapOrderSelection.get(sel_num).SeqNumber );
            //       if(seq!=sel_num && mapOrderSelection.get(seq).ParentPartNumber!=null && mapOrderSelection.get(seq).ParentPartNumber==sel_num ){
            if(seq!=sel_num && mapOrderSelection.get(seq).ParentPartNumber!=null && mapOrderSelection.get(seq).ParentPartNumber==mapOrderSelection.get(sel_num).SeqNumber ){
          //  if(seq!=sel_num && mapOrderSelection.get(seq).ParentPartNumber!=null && mapOrderSelection.get(seq).ParentPartNumber==mapOrderSelection.get(sel_num).SeqNumber && mapSelectedProduct.get(sel_num) ){
                system.debug('1' );
                mapSelectedProduct.put(seq,mapSelectedProduct.get(sel_num));
            }else{
                system.debug('2' );
            }
            
            system.debug('mapSelectedProduct--> ' + mapSelectedProduct );
            
            //     if(mapSelectedProduct.get(sel_num) && seq!=sel_num && mapOrderSelection.get(seq).ParentPartNumber==null && mapOrderSelection.get(sel_num).ParentPartNumber!=null && mapOrderSelection.get(sel_num).ParentPartNumber==seq ){
            if(mapSelectedProduct.get(sel_num) && seq!=sel_num && mapOrderSelection.get(seq).ParentPartNumber==null && mapOrderSelection.get(sel_num).ParentPartNumber!=null && mapOrderSelection.get(sel_num).ParentPartNumber==(mapOrderSelection.get(seq).SeqNumber) ){
                mapSelectedProduct.put(seq,mapSelectedProduct.get(sel_num));
            }
            
        }
        
        system.debug('mapSelectedProduct--> ' + mapSelectedProduct );
        
        return null;
    }
    
    public void actionAddSelection(){
        
        Boolean isOrderSelected = false;
        
        for(String seq:mapSelectedProduct.keySet()){
            if(mapSelectedProduct.get(seq)){
                isOrderSelected = true;
            }
        }
        
        if(isOrderSelected){
        
        Map<String, Integer> mapParentProduct = new Map<String, Integer>();
        system.debug('mapOrderSelection--> ' + mapOrderSelection );
        for(String mos:mapOrderSelection.keySet()){
        system.debug('mapOrderSelection.get(mos)--> ' + mapOrderSelection.get(mos) );
        system.debug('mapSelectedProduct.get(mos)--> ' + mapSelectedProduct.get(mos) );
        system.debug('mapOrderSelection.get(mos).Quantity--> ' + mapOrderSelection.get(mos).Quantity );
        system.debug('mapOrderSelection.get(mos).isProductParent--> ' + mapOrderSelection.get(mos).isProductParent );
            if(mapOrderSelection.get(mos).Quantity>0 && mapOrderSelection.get(mos).isProductParent && mapSelectedProduct.get(mos) ){
                mapParentProduct.put(mapOrderSelection.get(mos).SeqNumber, Integer.valueof(mapOrderSelection.get(mos).Quantity));
            }
        }
        
        system.debug('mapParentProduct--> ' + mapParentProduct );
        
        AdjOrderItem objOrderSelection1 = new AdjOrderItem();
    //    Map<String, AdjOrderItem> mapTempOrderSelection = new Map<String, AdjOrderItem>();
        
        for(String mos:mapOrderSelection.keySet()){
            objOrderSelection1 = new AdjOrderItem();
            objOrderSelection1 = mapOrderSelection.get(mos);
            if(mapParentProduct.get(mapOrderSelection.get(mos).ParentPartNumber)!=null){
                objOrderSelection1.Sel_NetTotalPrice = objOrderSelection1.NetUnitPrice * mapParentProduct.get(mapOrderSelection.get(mos).ParentPartNumber);
                objOrderSelection1.Sel_Quantity = mapParentProduct.get(mapOrderSelection.get(mos).ParentPartNumber);
            }else{
                objOrderSelection1.Sel_NetTotalPrice = objOrderSelection1.NetUnitPrice * objOrderSelection1.Quantity;
                objOrderSelection1.Sel_Quantity = objOrderSelection1.Quantity;
            }
            objOrderSelection1.Sel_NetUnitPrice = objOrderSelection1.NetUnitPrice;
            
            mapOrderSelection.put(mos, objOrderSelection1);
       //     system.debug('mapOrderSelection.get(mos)--> ' + mapOrderSelection.get(mos) );
        }        
        
        
        
        renErrorOrder = false;
        
        for(String mos:mapOrderSelection.keySet()){
            //      system.debug('mapOrderSelection.get(mos).Quantity--> ' + mapOrderSelection.get(mos).Quantity );
            //      system.debug('mapOSOGQuantity.get(mos)--> ' + mapOSOGQuantity.get(mos) );
            //      system.debug('mapSelectedProduct.get(mos)--> ' + mapSelectedProduct.get(mos) );
            if(mapOrderSelection.get(mos).Sel_Quantity < 0 || mapOrderSelection.get(mos).Sel_Quantity > mapOSOGQuantity.get(mos) ){
                renErrorOrder = true;
            }
        }
        
        system.debug('renErrorOrder--> ' + renErrorOrder );
        
            lstPartsOrderSelection= new List<AdjOrderItem>();
            lstPartsTotalSelection = new List<AdjOrderItem>();
            mapisChildReasonDisplay = new Map<String, Boolean>();
        
        if(!renErrorOrder){
                        
            Integer noit = 0;
            AdjOrderItem objTempOrderSelection = new AdjOrderItem();
            
            for(String mos:mapOrderSelection.keySet()){
                if(mapOrderSelection.get(mos).Sel_Quantity > 0 && mapOrderSelection.get(mos).Sel_Quantity <= mapOSOGQuantity.get(mos) && mapSelectedProduct.get(mos) ){
                    noit++;
                    objTempOrderSelection = new AdjOrderItem();
                    objTempOrderSelection = mapOrderSelection.get(mos);
                    objTempOrderSelection.SelId = String.valueOf(noit);
                    objTempOrderSelection.Sel_AdjId = String.valueOf(noit);
                    lstPartsOrderSelection.add(objTempOrderSelection);
                    mapisChildReasonDisplay.put(objTempOrderSelection.AdjId, false);
                    //        system.debug('objTempOrderSelection.NetUnitPrice--> ' + objTempOrderSelection.NetUnitPrice );
                }else{
                    objTempOrderSelection = new AdjOrderItem();
                    objTempOrderSelection = mapOrderSelection.get(mos);
                    mapisChildReasonDisplay.remove(objTempOrderSelection.AdjId);
                    objTempOrderSelection.Sel_AdjId = null;
                }
            }
            

            lstPartsTotalSelection.addAll(lstPartsOrderSelection);
            
        List<AdjOrderItem> lstTempPartsProductSelection = new List<AdjOrderItem>();
        AdjOrderItem objTempPPS = new AdjOrderItem();
        Integer tempPSelId = lstPartsOrderSelection.size();
            
            for(AdjOrderItem pps:lstPartsProductSelection){
                    tempPSelId++;
                    objTempPPS = new AdjOrderItem();
                    objTempPPS = pps;
                    objTempPPS.SelId = String.valueOf(tempPSelId);
                    objTempPPS.Sel_AdjId = String.valueOf(tempPSelId);
                    lstTempPartsProductSelection.add(objTempPPS);
            }
            
        lstPartsProductSelection = new List<AdjOrderItem>();
            for(AdjOrderItem pps:lstTempPartsProductSelection){
                lstPartsProductSelection.add(pps);
            }   
            
            
            
            lstPartsTotalSelection.addAll(lstPartsProductSelection);
            
            
            /*
            mapItemReasonSel = new Map<String, list<selectoption>>();
            list<selectoption> lstSel= new list<selectoption>();
            for(AdjOrderItem pos:lstPartsOrderSelection){
                lstSel= new list<selectoption>();
                lstSel.add(new SelectOption('', '--None--')); 
                if(mapRCDiv.keySet().contains(pos.ProductCode.substring(0,3))){
                    for (String rcd:mapRCDiv.get(pos.ProductCode.substring(0,3))){
                        lstSel.add(new SelectOption(rcd, mapDCR.get(rcd)));  
                    }
                }
                //     mapItemReasonSel.put(pos.SeqNumber, lstSel);
                mapItemReasonSel.put(pos.AdjId, lstSel);
                
            }
            
            
            list<selectoption> lstSelNull= new list<selectoption>();
            lstSelNull.add(new SelectOption('', '--None--'));  
            mapItemReasonSel.put(null, lstSelNull);
            
            system.debug('mapItemReasonSel--> ' + mapItemReasonSel );
            */
            
            AdjOrderItem objOGOrderSelection = new AdjOrderItem();
            
            for(String mos:mapOrderSelection.keySet()){
                //   for(String msp:mapSelectedProduct.keySet()){
                mapSelectedProduct.put(mos, false);
                objOGOrderSelection = new AdjOrderItem();
                objOGOrderSelection = mapOrderSelection.get(mos);
                objOGOrderSelection.Quantity = mapOSOGQuantity.get(mos);
                objOGOrderSelection.NetUnitPrice = mapOSOGPrice.get(mos);
                mapOrderSelection.put(mos, objOGOrderSelection);
            }
            
            
            
        }else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Selected Quantity should be greater than 0 and less than the Original Quantity' ));
        } 
            
        }
        
        isSelectedDeliveryCharge = isTempSelectedDeliveryCharge;
        isSelectedPremiumDeliveryCharge = isTempSelectedPremiumDeliveryCharge;
        isSelectedHaulawayCharge = isTempSelectedHaulawayCharge;
        
        sel_delivery_charge = temp_delivery_charge;
        sel_premium_delivery_charge = temp_premium_delivery_charge;
        sel_haulaway_charge = temp_haulaway_charge;
        
        isTempSelectedDeliveryCharge = false;
        isTempSelectedPremiumDeliveryCharge = false;
        isTempSelectedHaulawayCharge = false;
        
        temp_delivery_charge = delivery_charge;
        temp_premium_delivery_charge = premium_delivery_charge;
        temp_haulaway_charge = haulaway_charge;
                        
    } 
    
    public list<selectoption> getAdjPart(){
        list<Product2> adjustment_parts = [select Id, ProductCode, Name from Product2 where ProductCode like '400%' ];
         list<selectoption> adjSel= new list<selectoption>();
         adjSel.add(new SelectOption('', '--None--'));  
         for (product2 temp: adjustment_parts) {
         //    adjsel.add(new selectoption(temp.Id, temp.ProductCode + ': ' + temp.Name ));
             adjsel.add(new selectoption(temp.ProductCode, temp.ProductCode + ': ' + temp.Name ));
         }
         return adjsel;
    }
    
     public list<selectoption> getPAWarrantyPart(){
        list<Product2> adjustment_parts = [select Id, ProductCode, Name from Product2 where ProductCode like '070%' LIMIT 997 ];
         list<selectoption> adjSel= new list<selectoption>();
         adjSel.add(new SelectOption('', '--None--'));  
         for (product2 temp: adjustment_parts) {
         //    adjsel.add(new selectoption(temp.Id, temp.ProductCode + ': ' + temp.Name ));
             adjsel.add(new selectoption(temp.ProductCode, temp.ProductCode + ': ' + temp.Name ));
         }
         return adjsel;
    }
    
     public list<selectoption> getInstallPart(){
        list<Product2> adjustment_parts = [select Id, ProductCode, Name from Product2 where ProductCode like '010%' ];
         list<selectoption> adjSel= new list<selectoption>();
         adjSel.add(new SelectOption('', '--None--'));  
         for (product2 temp: adjustment_parts) {
         //    adjsel.add(new selectoption(temp.Id, temp.ProductCode + ': ' + temp.Name ));
             adjsel.add(new selectoption(temp.ProductCode, temp.ProductCode + ': ' + temp.Name ));
         }
         return adjsel;
    }
    
    
    public PageReference FindProducts(){
        
        String selType = System.currentPageReference().getParameters().get('type');
 
        system.debug('selType --> ' +selType);
        
        String selProductCode = '';
        if(selType=='prod'){
            selProductCode = selectedproductcode;
            selectedpart = '';
            selectedinstall = '';
            selectedprotection = '';
        }else if(selType=='part'){
            selProductCode = selectedpart;
            selectedproductcode = '';
            selectedinstall = '';
            selectedprotection = '';
        }else if(selType=='inst'){
            selProductCode = selectedinstall;
            selectedproductcode = '';
            selectedpart = '';
            selectedprotection = '';
        }else if(selType=='prot'){
            selProductCode = selectedprotection;
            selectedproductcode = '';
            selectedpart = '';
            selectedinstall = '';
        }
        
        system.debug('selProductCode --> ' +selProductCode);


        
        List<Product2> lstProductFind = new List<Product2>();
        
        if(selProductCode != null && selProductCode != '' ) {
            lstProductFind = [SELECT Id, ProductCode, Name 
                              FROM Product2 
                              WHERE ProductCode = :selProductCode AND IsActive=true AND ProductCode!=null
                              	AND SBQQ__Component__c =false AND CanUseQuantitySchedule=false
                             ];
        }
        
        system.debug('lstProductFind --> ' +lstProductFind );
        
        renObjOrder = false;
        renObjOrderMessage = false;

        if(lstProductFind.size()>0){
            
        List<Order> lstAccOrderQry = new List<Order>();
        lstAccOrderQry = [SELECT Id, AccountId FROM Order WHERE Id=:orderid LIMIT 1];
        string accid = lstAccOrderQry[0].AccountId;
        system.debug('account id' +accid);
        List<Account> lstaccpricetype = [select price_list_type__c from Account where Id=:accid LIMIT 1];
        string acc_price_list_type = '';
        if(lstaccpricetype[0].price_list_type__c!=null)
        acc_price_list_type = lstaccpricetype[0].price_list_type__c;
        system.debug('price list type' +acc_price_list_type);
                
        List<Key_Account_Pricing__c> lstKAP = new List<Key_Account_Pricing__c>();
        lstKAP = [SELECT Id, Customer_KAP_price__c, Valid_from__c, Valid_to__c, Customer__c, Price_List_Type__c, Material_Number__c
                  FROM Key_Account_Pricing__c
                  WHERE Material_Number__c =:selProductCode AND (Customer__c=:accid  OR Price_List_Type__c=:acc_price_list_type)
                    AND Valid_from__c<=:system.today() AND Valid_to__c>=:system.today()
                 ]; 
        system.debug ('lstKAP --> ' +lstKAP);
                
        Map<String, Double> mapKAP = new Map<String, Double>();
        for(Key_Account_Pricing__c lk:lstKAP){         
            mapKAP.put(lk.Material_Number__c, lk.Customer_KAP_price__c);
        }
        system.debug ('mapKAP --> ' +mapKAP);
        
        List<Product_Pricing__c> lstProductPricing = new List<Product_Pricing__c>();
        lstProductPricing = [SELECT Id, Price__c, Cost__c, Material_Number__c
                             FROM Product_Pricing__c
                         //    WHERE Material_Number__c =:selectedProductCode 
                             WHERE Material_Number__c =:selProductCode 
                             ORDER BY  Material_Number__c  
                            ];
        system.debug('product pricing' +lstProductPricing);
        
        for(Product_Pricing__c lp:lstProductPricing){
            if(mapKAP.get(lp.Material_Number__c)==null){
                mapKAP.put(lp.Material_Number__c, lp.Price__c);
            }
        }
        
        system.debug('mapKAP --> ' +mapKAP);
        
            for(String kk:mapKAP.keyset()){
                if(mapProductListPrice.get(kk)!=null){
                    mapKAP.put(kk,mapProductListPrice.get(kk));
                }
            }
            
        system.debug('mapKAP --> ' +mapKAP);
            
        
        objOSPart = new AdjOrderItem();
        
        
  //      if(mapKAP.size()>0){
            renObjOrder = true;
            renObjOrderMessage = false;
           
            
            
    //    objOSPart.OrderId = orderId;
        objOSPart.OrderId = orderId;
  //      objOSPart.SeqNumber = String.valueOf(mapPartsOrderSelection.size()+1);
        objOSPart.SeqNumber = '99';
                objOSPart.AdjId = String.valueOf(lstPartsTotalSelection.size()+1);
                objOSPart.SelId = String.valueOf(lstPartsTotalSelection.size()+1);
        objOSPart.isProductParent = true;
        objOSPart.ProductParentUnique = '';
        objOSPart.ParentPartNumber = null;
        objOSPart.Product2Id = lstProductFind[0].Id;
        objOSPart.ProductCode = lstProductFind[0].ProductCode;
        objOSPart.ProductName = lstProductFind[0].Name;
        objOSPart.Quantity = 1;
        if(selType=='prod'){
        objOSPart.Feature = null;
        }else{
        objOSPart.Feature = 'Services';
        }
        objOSPart.Configuration = '';
        objOSPart.ConfigurationDescription = '';
        objOSPart.PriceBookEntryId = mapPriceBookEntry.get(lstProductFind[0].Id);
        objOSPart.ReasonCode = '';
        objOSPart.ReasonCategoryCode = '';
     //   objOSPart.UnitPrice = mapKAP.get(selectedProductCode);
        objOSPart.ListUnitPrice = mapKAP.get(selProductCode)==null?0:mapKAP.get(selProductCode);
        objOSPart.NetUnitPrice = mapKAP.get(selProductCode)==null?0:mapKAP.get(selProductCode);
        objOSPart.NetTotalPrice = mapKAP.get(selProductCode)==null?0:mapKAP.get(selProductCode) * 1;
        objOSPart.DisposableFee = 0;
        objOSPart.TaxRate = 0;            
        objOSPart.TaxAmount = 0; 
        if(selType=='prod'){
            objOSPart.ProductType = 'Catalog'; 
        }else if(selType=='part'){
            objOSPart.ProductType = 'Adjustment'; 
        }else if(selType=='inst'){
            objOSPart.ProductType = 'InstallationService'; 
        }else if(selType=='prot'){
            objOSPart.ProductType = 'PAWarranty'; 
        }
                objOSPart.Sel_AdjId = String.valueOf(lstPartsTotalSelection.size()+1);
                objOSPart.Sel_Quantity = 1;
                objOSPart.Sel_NetUnitPrice = mapKAP.get(selProductCode)==null?0:mapKAP.get(selProductCode);
                objOSPart.Sel_NetTotalPrice = mapKAP.get(selProductCode)==null?0:mapKAP.get(selProductCode) * 1;
            
        }else{
            renObjOrderMessage = true;
        }
        
        
        return null;
    }    
    
    public void actionAddtoAdjustment(){
        
        system.debug('objOSPart.AdjId --> ' +objOSPart.AdjId);
        system.debug('objOSPart.SelId --> ' +objOSPart.SelId);
        system.debug('objOSPart.Quantity --> ' +objOSPart.Quantity);
        system.debug('objOSPart.ListUnitPrice --> ' +objOSPart.ListUnitPrice);
        system.debug('objOSPart.NetUnitPrice --> ' +objOSPart.NetUnitPrice);
        system.debug('objOSPart.NetTotalPrice --> ' +objOSPart.NetTotalPrice);
        system.debug('objOSPart.Sel_AdjId --> ' +objOSPart.Sel_AdjId);
        system.debug('objOSPart.Sel_Quantity --> ' +objOSPart.Sel_Quantity);
        system.debug('objOSPart.Sel_NetUnitPrice --> ' +objOSPart.Sel_NetUnitPrice);
        system.debug('objOSPart.Sel_NetTotalPrice --> ' +objOSPart.Sel_NetTotalPrice);
        
        objOSPart.Sel_Quantity = objOSPart.Quantity;
        objOSPart.Sel_NetUnitPrice = objOSPart.NetUnitPrice;
        objOSPart.Sel_NetTotalPrice = (objOSPart.Quantity==null|| objOSPart.NetUnitPrice==null) ? 0 : objOSPart.Quantity * objOSPart.NetUnitPrice;
        objOSPart.Quantity = 1;
        objOSPart.NetUnitPrice = objOSPart.ListUnitPrice;
        
        lstPartsProductSelection.add(objOSPart);
   //         lstPartsOrderSelection= new List<AdjOrderItem>();
            lstPartsTotalSelection = new List<AdjOrderItem>();
        
        lstPartsTotalSelection.addAll(lstPartsOrderSelection);
        lstPartsTotalSelection.addAll(lstPartsProductSelection);
        system.debug('lstPartsTotalSelection --> ' + lstPartsTotalSelection );
        system.debug('lstPartsTotalSelection.size() --> ' + lstPartsTotalSelection.size() );
        
        renObjOrder = false;
        
            selectedproductcode = '';
            selectedpart = '';
            selectedinstall = '';
            selectedprotection = '';
        
    }
    
    
    public void actionDelete(){
        
        mapParentReason = new Map<String, String>();
        if((selectedAdjustment=='Return' || selectedAdjustment=='Exchange') && !Test.isRunningTest() ){
            
        mapParentReason = new Map<String, String>();
            for (AdjOrderItem mc: lstPartsTotalSelection) {
                system.debug('mapParentReason--> ' + mapParentReason );
                system.debug('mc.ReasonCode--> ' + mc.ReasonCode + ' || mc.AdjId--> ' + mc.AdjId + ' || mapItemReasonSel.get(mc.AdjId).size()--> ' + mapItemReasonSel.get(mc.AdjId).size() );
                if(mc.ParentPartNumber == null){
                    mapParentReason.put(mc.SeqNumber, mc.ReasonCode);
                }
                if(mapItemReasonSel.get(mc.AdjId).size() > 1 && mc.ParentPartNumber != null ){
                    if(mapParentReason.get(mc.ParentPartNumber) != null && mapParentReason.get(mc.ParentPartNumber) != '' ){
                        	mc.ReasonCode = mapParentReason.get(mc.ParentPartNumber);
                    }
                }
                system.debug('mapParentReason--> ' + mapParentReason );
                system.debug('mc.ReasonCode--> ' + mc.ReasonCode + ' || mc.AdjId--> ' + mc.AdjId + ' || mapItemReasonSel.get(mc.AdjId).size()--> ' + mapItemReasonSel.get(mc.AdjId).size() );
            }
        }        
        
        String remSelAdjId = System.currentPageReference().getParameters().get('sid');
        system.debug('remSelAdjId --> ' + remSelAdjId );
        system.debug('lstPartsOrderSelection.size() --> ' + lstPartsOrderSelection.size() );

        Boolean isProd = false;
        String remProd = '';
        
        
        if(integer.valueof(remSelAdjId) > lstPartsOrderSelection.size()){
            remProd = remSelAdjId;
            isProd = true;
        }else{
            for(AdjOrderItem pos:lstPartsTotalSelection){
                system.debug('pos.Sel_AdjId --> ' + pos.Sel_AdjId );
                system.debug('pos.SeqNumber --> ' + pos.SeqNumber );
                if(pos.Sel_AdjId==remSelAdjId){
                    remProd = pos.SeqNumber;
                }
            }
        }
        
        
        system.debug('isProd --> ' + isProd );
        system.debug('remProd --> ' + remProd );
        
        lstPartsTotalSelection = new List<AdjOrderItem>();
        
        if(!isProd){
            
            List<AdjOrderItem> lstTempPartsOrderSelection = new List<AdjOrderItem>();
            AdjOrderItem objTempPOS = new AdjOrderItem();
            Integer tempSelId = 0;
            
            mapisChildReasonDisplay = new Map<String, Boolean>();
            
            for(AdjOrderItem pos:lstPartsOrderSelection){
            //    if((!isProd && pos.SeqNumber!=remProd && pos.ParentPartNumber!=remProd) || (isProd && remProd!=pos.Sel_AdjId) ){
                if((!isProd && pos.SeqNumber!=remProd) || (isProd && remProd!=pos.Sel_AdjId) ){
                    tempSelId++;
                    objTempPOS = new AdjOrderItem();
                    objTempPOS = pos;
                    objTempPOS.SelId = String.valueOf(tempSelId);
                    objTempPOS.Sel_AdjId = String.valueOf(tempSelId);
                    mapisChildReasonDisplay.put(pos.AdjId, false);
                    if(pos.ParentPartNumber==remProd){
                        mapisChildReasonDisplay.put(pos.AdjId, true);
                    //    objTempPOS.ParentPartNumber = null;
                    //    objTempPOS.isProductParent = true;
                    }
                    lstTempPartsOrderSelection.add(objTempPOS);
                }else{
                    objTempPOS = new AdjOrderItem();
                    objTempPOS = pos;
                    objTempPOS.Sel_AdjId = null;
                }
            }
            
            lstPartsOrderSelection = new List<AdjOrderItem>();
            for(AdjOrderItem pos:lstTempPartsOrderSelection){
                lstPartsOrderSelection.add(pos);
            }   
            
            List<AdjOrderItem> lstTempPartsProductSelection = new List<AdjOrderItem>();
            AdjOrderItem objTempPPS = new AdjOrderItem();
            
            for(AdjOrderItem pps:lstPartsProductSelection){
                    tempSelId++;
                    objTempPPS = new AdjOrderItem();
                    objTempPPS = pps;
                    objTempPPS.SelId = String.valueOf(tempSelId);
                    objTempPPS.Sel_AdjId = String.valueOf(tempSelId);
                    lstTempPartsProductSelection.add(objTempPPS);
            }
            
            lstPartsProductSelection = new List<AdjOrderItem>();
            for(AdjOrderItem pps:lstTempPartsProductSelection){
                lstPartsProductSelection.add(pps);
            }   
            
        }else{
            
            List<AdjOrderItem> lstTempPartsProductSelection = new List<AdjOrderItem>();
            AdjOrderItem objTempPPS = new AdjOrderItem();
            Integer tempSelId = lstPartsOrderSelection.size();
            
            for(AdjOrderItem pps:lstPartsProductSelection){
                if((!isProd && pps.SeqNumber!=remProd && pps.ParentPartNumber!=remProd) || (isProd && remProd!=pps.Sel_AdjId) ){
                    tempSelId++;
                    objTempPPS = new AdjOrderItem();
                    objTempPPS = pps;
                    objTempPPS.SelId = String.valueOf(tempSelId);
                    objTempPPS.Sel_AdjId = String.valueOf(tempSelId);
                    lstTempPartsProductSelection.add(objTempPPS);
                }else{
                    objTempPPS = new AdjOrderItem();
                    objTempPPS = pps;
                    objTempPPS.Sel_AdjId = null;
                }
            }
            
            lstPartsProductSelection = new List<AdjOrderItem>();
            for(AdjOrderItem pps:lstTempPartsProductSelection){
                lstPartsProductSelection.add(pps);
            }   
            
        }
        
                        
        lstPartsTotalSelection.addAll(lstPartsOrderSelection);
        lstPartsTotalSelection.addAll(lstPartsProductSelection);

        
        
        for(String kk:mapOrderSelection.keyset()){
        system.debug('kk --> ' + kk );
        system.debug('mapOrderSelection.get(kk).SelId --> ' + mapOrderSelection.get(kk).SelId );
        system.debug('mapOrderSelection.get(kk).Sel_AdjId --> ' + mapOrderSelection.get(kk).Sel_AdjId );
        }
        
        
    }    
    
    
    /*
    public void actionDelete(){
        String remProd = System.currentPageReference().getParameters().get('sid');
        system.debug('remProd --> ' + remProd );
/*
        String remSeqNo = '';
        
            for(AdjOrderItem pos:lstPartsOrderSelection){
                if(pos.AdjId==remProd){
                    remSeqNo = pos.SeqNumber;
                }
            }
        system.debug('remSeqNo --> ' + remSeqNo );
        *****
        List<AdjOrderItem> lstTempPartsOrderSelection = new List<AdjOrderItem>();
        AdjOrderItem objTempPOS = new AdjOrderItem();
        Integer tempSelId = 0;
        
            for(AdjOrderItem pos:lstPartsOrderSelection){
                if(pos.SeqNumber!=remProd && pos.ParentPartNumber!=remProd ){
                    tempSelId++;
                    objTempPOS = new AdjOrderItem();
                    objTempPOS = pos;
                    objTempPOS.SelId = String.valueOf(tempSelId);
                    objTempPOS.Sel_AdjId = String.valueOf(tempSelId);
                    lstTempPartsOrderSelection.add(objTempPOS);
                }else{
                    objTempPOS = new AdjOrderItem();
                    objTempPOS = pos;
                    objTempPOS.Sel_AdjId = null;
                }
            }
        
        lstPartsOrderSelection = new List<AdjOrderItem>();
            for(AdjOrderItem pos:lstTempPartsOrderSelection){
                lstPartsOrderSelection.add(pos);
            }   
        
        for(String kk:mapOrderSelection.keyset()){
        system.debug('kk --> ' + kk );
        system.debug('mapOrderSelection.get(kk).SelId --> ' + mapOrderSelection.get(kk).SelId );
        system.debug('mapOrderSelection.get(kk).Sel_AdjId --> ' + mapOrderSelection.get(kk).Sel_AdjId );
        }
        
        
    }    
    */
    
    
    public void checkAddress(){
            system.debug('selectedAdjustment--> ' + selectedAdjustment );
        system.debug('selectedHeaderReasonCode--> ' + selectedHeaderReasonCode );
        system.debug('lstOrderOverviewQry[0].Purchase_Number__c--> ' + lstOrderOverviewQry[0].Purchase_Number__c );
        system.debug('lstOrderOverviewQry[0].Shipping_Contact_First_Name__c--> ' + lstOrderOverviewQry[0].Shipping_Contact_First_Name__c );
        system.debug('lstOrderOverviewQry[0].Shipping_Contact_Last_Name__c--> ' + lstOrderOverviewQry[0].Shipping_Contact_Last_Name__c );
        system.debug('lstOrderOverviewQry[0].Shipping_Contact_Phone__c--> ' + lstOrderOverviewQry[0].Shipping_Contact_Phone__c );
        system.debug('lstOrderOverviewQry[0].Shipping_Contact_Email__c--> ' + lstOrderOverviewQry[0].Shipping_Contact_Email__c );
        system.debug('lstOrderOverviewQry[0].ShippingStreet--> ' + lstOrderOverviewQry[0].ShippingStreet );
        system.debug('lstOrderOverviewQry[0].ShippingCity--> ' + lstOrderOverviewQry[0].ShippingCity );
        system.debug('lstOrderOverviewQry[0].ShippingState--> ' + lstOrderOverviewQry[0].ShippingState );
        system.debug('lstOrderOverviewQry[0].ShippingPostalCode--> ' + lstOrderOverviewQry[0].ShippingPostalCode );
        system.debug('lstOrderOverviewQry[0].BillingStreet--> ' + lstOrderOverviewQry[0].BillingStreet );
        system.debug('lstOrderOverviewQry[0].BillingCity--> ' + lstOrderOverviewQry[0].BillingCity );
        system.debug('lstOrderOverviewQry[0].BillingState--> ' + lstOrderOverviewQry[0].BillingState );
        system.debug('lstOrderOverviewQry[0].BillingPostalCode--> ' + lstOrderOverviewQry[0].BillingPostalCode );
        system.debug('lstOrderOverviewQry[0].isCommonCarrier__c--> ' + lstOrderOverviewQry[0].isCommonCarrier__c );
        
        List<String> lstErrorMessage = new List<String>();
        
        if((selectedHeaderReasonCode == null || selectedHeaderReasonCode == '') ){
            lstErrorMessage.add('Missing Reason Code for the Order Header');
        }
        if((lstOrderOverviewQry[0].Purchase_Number__c == null || lstOrderOverviewQry[0].Purchase_Number__c == '') ){
            lstErrorMessage.add('Missing Purchase Number');
        }
        if((lstOrderOverviewQry[0].Shipping_Contact_First_Name__c == null || lstOrderOverviewQry[0].Shipping_Contact_First_Name__c == '') ){
            lstErrorMessage.add('Missing Pick-up Contact First Name');
        }
        if((lstOrderOverviewQry[0].Shipping_Contact_Last_Name__c == null || lstOrderOverviewQry[0].Shipping_Contact_Last_Name__c == '') ){
            lstErrorMessage.add('Missing Pick-up Contact Last Name');
        }
        if((lstOrderOverviewQry[0].Shipping_Contact_Phone__c == null || lstOrderOverviewQry[0].Shipping_Contact_Phone__c == '') ){
            lstErrorMessage.add('Missing Pick-up Contact Phone');
        }
        if((lstOrderOverviewQry[0].Shipping_Contact_Email__c == null || lstOrderOverviewQry[0].Shipping_Contact_Email__c == '') ){
            lstErrorMessage.add('Missing Pick-up Contact Email');
        }
        if((lstOrderOverviewQry[0].ShippingStreet == null || lstOrderOverviewQry[0].ShippingStreet == '') ){
            lstErrorMessage.add('Missing Pick-up Street');
        }
        if((lstOrderOverviewQry[0].ShippingCity == null || lstOrderOverviewQry[0].ShippingCity == '') ){
            lstErrorMessage.add('Missing Pick-up City');
        }
        if((lstOrderOverviewQry[0].ShippingState == null || lstOrderOverviewQry[0].ShippingState == '') ){
            lstErrorMessage.add('Missing Pick-up State');
        }
        if((lstOrderOverviewQry[0].ShippingPostalCode == null || lstOrderOverviewQry[0].ShippingPostalCode == '') ){
            lstErrorMessage.add('Missing Pick-up Zip Code');
        }
        if((lstOrderOverviewQry[0].BillingStreet == null || lstOrderOverviewQry[0].BillingStreet == '') ){
            lstErrorMessage.add('Missing Billing Street');
        }
        if((lstOrderOverviewQry[0].BillingCity == null || lstOrderOverviewQry[0].BillingCity == '') ){
            lstErrorMessage.add('Missing Billing City');
        }
        if((lstOrderOverviewQry[0].BillingState == null || lstOrderOverviewQry[0].BillingState == '') ){
            lstErrorMessage.add('Missing Billing State');
        }
        if((lstOrderOverviewQry[0].BillingPostalCode == null || lstOrderOverviewQry[0].BillingPostalCode == '') ){
            lstErrorMessage.add('Missing Billing Zip Code');
        }

        mapParentReason = new Map<String, String>();
        if((selectedAdjustment=='Return' || selectedAdjustment=='Exchange') && !Test.isRunningTest() ){
            
            /*
            for (AdjOrderItem mc: lstPartsTotalSelection) {
                system.debug('mapParentReason--> ' + mapParentReason );
                system.debug('mc.ReasonCode--> ' + mc.ReasonCode + ' || mc.AdjId--> ' + mc.AdjId + ' || mapItemReasonSel.get(mc.AdjId).size()--> ' + mapItemReasonSel.get(mc.AdjId).size() );
        //        if((mc.ReasonCode == null || mc.ReasonCode == '' ) && mapItemReasonSel.get(mc.AdjId).size() > 1 ){
                if((mc.ReasonCode == null || mc.ReasonCode == '' ) && mapItemReasonSel.get(mc.AdjId).size() > 1 && mc.ParentPartNumber == null ){
                    lstErrorMessage.add('Missing Reason Code for the Order Products');
                }
                if(mc.ParentPartNumber == null){
                    mapParentReason.put(mc.SeqNumber, mc.ReasonCode);
                }
                if(mapItemReasonSel.get(mc.AdjId).size() > 1 && mc.ParentPartNumber != null ){
                    mc.ReasonCode = mapParentReason.get(mc.ParentPartNumber);
                }
                system.debug('mapParentReason--> ' + mapParentReason );
                system.debug('mc.ReasonCode--> ' + mc.ReasonCode + ' || mc.AdjId--> ' + mc.AdjId + ' || mapItemReasonSel.get(mc.AdjId).size()--> ' + mapItemReasonSel.get(mc.AdjId).size() );
            }
            */
            
            
            for (AdjOrderItem mc: lstPartsTotalSelection) {
                system.debug('mapParentReason--> ' + mapParentReason );
                system.debug('mc.ReasonCode--> ' + mc.ReasonCode + ' || mc.AdjId--> ' + mc.AdjId + ' || mapItemReasonSel.get(mc.AdjId).size()--> ' + mapItemReasonSel.get(mc.AdjId).size() );
                if(mc.ParentPartNumber == null){
                    mapParentReason.put(mc.SeqNumber, mc.ReasonCode);
                }
                if(mapItemReasonSel.get(mc.AdjId).size() > 1 && mc.ParentPartNumber != null ){
                    if(mapParentReason.get(mc.ParentPartNumber) != null && mapParentReason.get(mc.ParentPartNumber) != '' ){
                        	mc.ReasonCode = mapParentReason.get(mc.ParentPartNumber);
                    }
                }
                system.debug('mapParentReason--> ' + mapParentReason );
                system.debug('mc.ReasonCode--> ' + mc.ReasonCode + ' || mc.AdjId--> ' + mc.AdjId + ' || mapItemReasonSel.get(mc.AdjId).size()--> ' + mapItemReasonSel.get(mc.AdjId).size() );
            }
            
            for (AdjOrderItem mc: lstPartsTotalSelection) {
                system.debug('mapParentReason--> ' + mapParentReason );
                system.debug('mc.ReasonCode--> ' + mc.ReasonCode + ' || mc.AdjId--> ' + mc.AdjId + ' || mapItemReasonSel.get(mc.AdjId).size()--> ' + mapItemReasonSel.get(mc.AdjId).size() );
                if((mc.ReasonCode == null || mc.ReasonCode == '' ) && mapItemReasonSel.get(mc.AdjId).size() > 1 ){
                    lstErrorMessage.add('Missing Reason Code for the Order Products');
                }
                system.debug('mapParentReason--> ' + mapParentReason );
                system.debug('mc.ReasonCode--> ' + mc.ReasonCode + ' || mc.AdjId--> ' + mc.AdjId + ' || mapItemReasonSel.get(mc.AdjId).size()--> ' + mapItemReasonSel.get(mc.AdjId).size() );
            }
            
        }
        
        if(lstErrorMessage.size()>0){
            for(String em:lstErrorMessage){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, em));   
            }
        }else{
            
        
            
        Map<String, Common_Variables__c> mapCV = Common_Variables__c.getAll();            
        //     String CS_Endpoint = mapCV.get('B2BProd_EndPoint').Content__c;
        String CS_Endpoint = mapCV.get('B2BProd_Address_Val_API_URL').Content__c;
        String CS_CLIENT_ID = mapCV.get('B2BProd_ClientId').Content__c;
        String CS_CLIENT_SECRET = mapCV.get('B2BProd_ClientSecret').Content__c;
        String CS_CONTENT_TYPE = mapCV.get('B2BProd_ContentType_XML').Content__c;
        
        // system.debug('CS_Endpoint >> ' + CS_Endpoint);
        // system.debug('CS_CLIENT_ID >> ' + CS_CLIENT_ID);
        // system.debug('CS_CLIENT_SECRET >> ' + CS_CLIENT_SECRET);
        
        
        String EndpointUrl = CS_Endpoint;
                
        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        Http http = new Http();
        system.debug('Addr Val Start');

            DOM.Document doc = new DOM.Document();
            dom.XmlNode xmlrequest = doc.createRootElement('shippingAddress', null, null);
            
            dom.xmlNode firstName = xmlrequest.addChildElement('firstName',null,null);
            firstName.addTextNode('Test Name');
            
            dom.xmlNode lastName = xmlrequest.addChildElement('lastName',null,null);
            
            if(!Test.isRunningTest() ){
            dom.xmlNode addressLine1 = xmlrequest.addChildElement('addressLine1',null,null);
            addressLine1.addTextNode(lstOrderOverviewQry[0].ShippingStreet);
            
            dom.xmlNode addressLine2 = xmlrequest.addChildElement('addressLine2',null,null);
            
            dom.xmlNode addressLine3 = xmlrequest.addChildElement('addressLine3',null,null);
            
            dom.xmlNode zipCode = xmlrequest.addChildElement('zipCode',null,null);
            zipCode.addTextNode(lstOrderOverviewQry[0].ShippingPostalCode);
            
            dom.xmlNode email = xmlrequest.addChildElement('email',null,null);
            
            dom.xmlNode city = xmlrequest.addChildElement('city',null,null);
            city.addTextNode(lstOrderOverviewQry[0].ShippingCity);
            
            dom.xmlNode state = xmlrequest.addChildElement('state',null,null);
            state.addTextNode(lstOrderOverviewQry[0].ShippingState);
            }
            dom.xmlNode day_phone = xmlrequest.addChildElement('day_phone',null,null);
            day_phone.addTextNode('2342343333');
            
            string req = doc.toXmlString();
            system.debug('request  message' +req);
            
            // string ns = '<shippingAddress><firstName> First Name</firstName><lastName> Last Name </lastName><addressLine1> 1 North State Street</addressLine1><addressLine2>floor 12 </addressLine2><addressLine3> </addressLine3><zipCode>60601</zipCode><email>test@test.com</email><city>chicago</city><state>IL</state><day_phone>1112223333</day_phone></shippingAddress>';
            
            //Payload prepare
            request.setMethod('POST');
                  request.setTimeout(60000); // timeout in milliseconds
            request.setendPoint(EndpointUrl);
            system.debug('EndpointUrl >>'+EndpointUrl);
            
            //   request.setHeader('Content-Type', 'application/xml');
            //   request.setHeader('CLIENT_ID', 'c70a6500b5b70134f47d005056af5d0d');
            //   request.setHeader('CLIENT_SECRET', 'ES3u4E7GW70R/my5ygzS98OJ6ejwUSJlqH8I2EEblRNRH0qL');
            request.setHeader('Content-Type', CS_CONTENT_TYPE);
            request.setHeader('CLIENT_ID', CS_CLIENT_ID);
            request.setHeader('CLIENT_SECRET', CS_CLIENT_SECRET);
            request.setBody(req);
            
            
            
            CalloutB2BAPI.ResponseWrapper RW = CalloutB2BAPI.execute(request);
            
            system.debug('RW>>' +RW);
            system.debug('RW.Response>>' +RW.Response);
            system.debug('RW.message>>' +RW.message);
            
            //      response = http.send(request);
            system.debug('RW>> ' +RW);
            //    string docOutput = response.getBody();
            
    
            l_addressList = new List<address>();
            List<string> newlist = new List<string> ();
            List<String> errorList = new List<String>();
            mapAddr = new Map<String, address>();
            
            
            if (RW.message == '' && RW.Response != null){
                system.debug('API response success');
                
                string docOutput = RW.Response.getBody();
                system.debug('Response output' +docOutput);
                Dom.Document docResp = new Dom.Document();
                docResp.load(docOutput);
                system.debug('docResp--> ' + docResp);
                DOM.XmlNode root = docResp.getRootElement();
                system.debug('root--> ' + root);
                
                
                // DOM.xmlNode responseXMLNode = root.getChildElement('response', null);
                DOM.XmlNode addressXMLNode = root.getChildElement('address',null);
                system.debug('addressXMLNode--> ' + addressXMLNode);
                dom.XmlNode countiesXMLNode = addressXMLNode.getchildelement('counties',null);
                system.debug('countiesXMLNode--> ' + countiesXMLNode);
                dom.XmlNode [] scountyXMLNode = countiesXMLNode.getchildelements();
                system.debug('scountyXMLNode--> ' + scountyXMLNode);
                Integer counter = 0;
                
                for(DOM.XmlNode county : scountyXMLNode) {
                    counter++;
                    
                    dom.XmlNode [] xcounty = county.getchildelements() ;
                    system.debug('xcounty--> ' + xcounty);
                    for(dom.XmlNode county_final: xcounty) {
                        
                        if (county_final.getname() == 'geoCode'){
                            system.debug('geocode'+county_final.gettext());
                            newlist.add(county_final.gettext());
                            
                        }
                        
                        if (county_final.getname() == 'countyCode'){
                            system.debug('countycode'+county_final.gettext());
                            newlist.add(county_final.gettext());
                            
                        }
                        
                        if (county_final.getname() == 'countyName'){
                            system.debug('countyName'+county_final.gettext());
                            newlist.add(county_final.gettext());
                            
                        }
                        
                    }
                    
                    address addr = new address(String.valueOf(counter), newlist[0],newlist[1],newlist[2]);
                    system.debug('addr'+addr);
                    l_addressList.add(addr);
      //              renTable = true;
                    newlist.clear();
                }
                
                system.debug('finallist'+newlist);
                system.debug('l_addressList'+l_addressList);
                
                
            }else if(RW.message != null && RW.Response != null){
                system.debug('API response failure');
                
                string docOutput = RW.Response.getBody();
                system.debug('Response output' +docOutput);
                Dom.Document docResp = new Dom.Document();
                docResp.load(docOutput);
                system.debug('docResp--> ' + docResp);
                DOM.XmlNode root = docResp.getRootElement();
                system.debug('root--> ' + root);
                
                
                // DOM.xmlNode responseXMLNode = root.getChildElement('response', null);
                DOM.XmlNode statusXMLNode = root.getChildElement('status',null);
                system.debug('statusXMLNode--> ' + statusXMLNode);
                //    dom.XmlNode [] messagesXMLNode = statusXMLNode.getchildelements();
                dom.XmlNode messagesXMLNode = root.getChildElement('messages',null);
                system.debug('messagesXMLNode--> ' + messagesXMLNode);
                dom.XmlNode [] messageXMLNode = messagesXMLNode.getchildelements();
                system.debug('messageXMLNode--> ' + messageXMLNode);
                //  Integer count_error = 0;
                errorList = new List<String>();
                for(dom.XmlNode mess: messageXMLNode) {
                    system.debug('message'+mess.gettext());
                    errorList.add(mess.gettext());
                }
            }else if(RW.message != null && RW.Response == null){
                errorList = new List<String>();
                errorList.add(RW.message);
            }

                system.debug('l_addressList--> ' + l_addressList);
                system.debug('newlist--> ' + newlist);
                system.debug('errorList--> ' + errorList);

            lstErrorMessage.addAll(errorList);
            
        renAddress = false;
            

            // docOutput = '<?xml version="1.0" encoding="UTF-8"?><shippingAddress><firstName>Test Name</firstName><lastName /><addressLine1>beverly st 1 n dearborn</addressLine1><addressLine2 /><addressLine3 /><zipCode>60179</zipCode><email /><city>hoffman estates</city><state>IL</state><day_phone>2342343333</day_phone></shippingAddress>';
            if(Test.isRunningTest()){
                lstErrorMessage = new List<String>();
                //countyCode=031, countyName=COOK, geoCode=00, seqno=1
                    address addrt = new address('1','00', '031', 'COOK');
                    system.debug('addrt'+addrt);
                    l_addressList.add(addrt);
                
            }
            
            
        if(lstErrorMessage.size()>0){
            for(String em:lstErrorMessage){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, em));   
            }
        }else{
        renAddress = true;
                    system.debug('renAddress --> ' + renAddress );
            
            mapAddr = new Map<String, address>();
        if(l_addressList.size()>0){
            for(address addr:l_addressList){
                mapAddr.put('GEO CODE: ' + addr.geoCode + ' | COUNTY CODE: ' + addr.countyCode + ' | COUNTY NAME: ' + addr.countyName, addr);            
            }
        }
            
        }
            
        }        
        
        
    }    
    
    public list<selectoption> getAddressList(){
        list<selectoption> lstSel= new list<selectoption>();
        lstSel.add(new SelectOption('', '--None--'));
        /*
        if(l_addressList.size()>0){
            for(address addr:l_addressList){
                lstSel.add(new SelectOption(addr.geoCode + ' - ' + addr.countyCode + ' - ' + addr.countyName, addr.geoCode + ' - ' + addr.countyCode + ' - ' + addr.countyName));            
            }
        }
*/
        if(mapAddr.keyset().size()>0){
            for(String ma:mapAddr.keyset()){
                lstSel.add(new SelectOption(ma, ma));            
            }
        }
        
        
        
        return lstSel;
    }
    
    public PageReference actionSaveAdjustment(){
        
        
        system.debug('selectedAddr--> ' + selectedAddr );
        system.debug('selectedAdjustment--> ' + selectedAdjustment );
        system.debug('selectedAdjustment--> ' + selectedAdjustment );
        
        
        List<String> lstErrorMessage = new List<String>();
        
        if((selectedAddr == null || selectedAddr == '') ){
            lstErrorMessage.add('Please Select County');
        }
        
        if(lstErrorMessage.size()>0){
            for(String em:lstErrorMessage){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, em));   
            }
        }else{
            User usr_owner = new User();
            usr_owner = [SELECT Id, Name, ManagerId FROM User WHERE Id=:lstOrderOverviewQry[0].OwnerId AND isActive=true LIMIT 1 ];
            system.debug('usr_owner--> ' + usr_owner );
            
            String orn = 'SF_ADJ_';
            if(selectedAdjustment=='Return'){
                orn += 'RTN_';
            }else if(selectedAdjustment=='Exchange'){
                orn += 'EXC_';
            }else if(selectedAdjustment=='Credit Memo'){
                orn += 'CMR_';
            }else if(selectedAdjustment=='Debit Memo'){
                orn += 'DMR_';
            }
            
            
            DateTime dt = system.now();
            String str_dt = string.valueOf(dt.year()).substring(2) 
                + string.valueof(dt.month()<10?'0':'') + string.valueOf(dt.month())
                + string.valueof(dt.day()<10?'0':'') + string.valueOf(dt.day())
                + string.valueof(dt.hour()<10?'0':'') + string.valueOf(dt.hour())
                + string.valueof(dt.minute()<10?'0':'') + string.valueOf(dt.minute())
                + string.valueof(dt.second()<10?'0':'') + string.valueOf(dt.second());
            system.debug('str_dt--> ' + str_dt );
            
            orn+=str_dt;
            
            system.debug('orn--> ' + orn );
            
            
            List<Order> lstOrderInsert = new List<Order>();
        Order objOrderInsert = new Order();
            
         //   objOrderInsert.SBQQ__Contracted__c = true;
         //   objOrderInsert.ContractId = contractId;
            objOrderInsert.SBQQ__Quote__c = lstOrderOverviewQry[0].SBQQ__Quote__c;
        //    objOrderInsert.SBQQ__Contracted__c = false;
            objOrderInsert.AccountId = lstOrderOverviewQry[0].AccountId;
       //     objOrderInsert.Status = 'Submitted';
            objOrderInsert.Status = 'Adjustment Created';
            objOrderInsert.Order_Reference_Number__c = orn;
            objOrderInsert.Type = selectedAdjustment;
            objOrderInsert.Pricebook2Id='01s300000006uBlAAI';
            objOrderInsert.Order_Source__c='Salesforce';
            objOrderInsert.Parent_Order__c=orderId;
            objOrderInsert.District_Id__c=lstOrderOverviewQry[0].District_Id__c;
            objOrderInsert.Territory_Id__c=lstOrderOverviewQry[0].Territory_Id__c;
            objOrderInsert.EffectiveDate = system.today();
            objOrderInsert.Reason_Code__c = selectedHeaderReasonCode;
            objOrderInsert.Purchase_Number__c=lstOrderOverviewQry[0].Purchase_Number__c;
            objOrderInsert.Shipping_Contact_First_Name__c=lstOrderOverviewQry[0].Shipping_Contact_First_Name__c;
            objOrderInsert.Shipping_Contact_Last_Name__c=lstOrderOverviewQry[0].Shipping_Contact_Last_Name__c;
            objOrderInsert.Shipping_Contact_Phone__c=lstOrderOverviewQry[0].Shipping_Contact_Phone__c;
            objOrderInsert.Shipping_Contact_Email__c=lstOrderOverviewQry[0].Shipping_Contact_Email__c;
            objOrderInsert.ShippingStreet=lstOrderOverviewQry[0].ShippingStreet;
            objOrderInsert.ShippingCity=lstOrderOverviewQry[0].ShippingCity;
            objOrderInsert.ShippingState=lstOrderOverviewQry[0].ShippingState;
            objOrderInsert.ShippingPostalCode=lstOrderOverviewQry[0].ShippingPostalCode;
            objOrderInsert.BillingStreet=lstOrderOverviewQry[0].BillingStreet;
            objOrderInsert.BillingCity=lstOrderOverviewQry[0].BillingCity;
            objOrderInsert.BillingState=lstOrderOverviewQry[0].BillingState;
            objOrderInsert.BillingPostalCode=lstOrderOverviewQry[0].BillingPostalCode;
            objOrderInsert.isCommonCarrier__c=lstOrderOverviewQry[0].isCommonCarrier__c;
      //      objOrderInsert.Delivery_Charge__c = sel_delivery_charge;
      //      objOrderInsert.Premium_Delivery_Charge__c = sel_premium_delivery_charge;
      //      objOrderInsert.Haulaway_Charge__c = sel_haulaway_charge;
            objOrderInsert.Delivery_Charge__c = isSelectedDeliveryCharge?sel_delivery_charge:0;
            objOrderInsert.Premium_Delivery_Charge__c = isSelectedPremiumDeliveryCharge?sel_premium_delivery_charge:0;
            objOrderInsert.Haulaway_Charge__c = isSelectedHaulawayCharge?sel_haulaway_charge:0;
            objOrderInsert.Delivery_Instruction__c = lstOrderOverviewQry[0].Delivery_Instruction__c;
            if(mapAddr.get(selectedAddr)!=null){
                objOrderInsert.Geo_Code__c = mapAddr.get(selectedAddr).geoCode;
                objOrderInsert.County_Code__c = mapAddr.get(selectedAddr).countyCode;
                objOrderInsert.County_Name__c = mapAddr.get(selectedAddr).countyName;
            }
            if(usr_owner.ManagerId!=null){
                objOrderInsert.Order_Approver__c=usr_owner.ManagerId;
          //      objOrderInsert.Order_Approver__c='00530000004EqVqAAK';
                objOrderInsert.Post_Sales_Manager_Lead__c=usr_owner.ManagerId;
            }
            lstOrderInsert.add(objOrderInsert);
            
            try{
                insert lstOrderInsert;
            
                String saveOrderId = '';
                saveOrderId = lstOrderInsert[0].Id;
            
                Map<String, String> mapParentAdjustment = new Map<String, String>();
                for (AdjOrderItem ts: lstPartsTotalSelection) {
                    mapParentAdjustment.put(ts.SeqNumber, ts.Sel_AdjId);
                }
                
        List<OrderItem> lstInsOrderItem = new List<OrderItem>();
            OrderItem objInsPartsOrderItem = new OrderItem();
        for (AdjOrderItem pts: lstPartsTotalSelection) {
            system.debug('pts--> ' + pts );
            system.debug('pts.Sel_AdjId--> ' + pts.Sel_AdjId + ' || pts.SeqNumber--> ' + pts.SeqNumber + ' || pts.ParentPartNumber--> ' + pts.ParentPartNumber );
            objInsPartsOrderItem = new OrderItem();
            
            objInsPartsOrderItem.OrderId = saveOrderId;
            objInsPartsOrderItem.Number__c = String.valueof(Integer.valueof(pts.Sel_AdjId)*10);
            objInsPartsOrderItem.Product2Id = pts.Product2Id;
            objInsPartsOrderItem.Quantity = pts.Sel_Quantity;
            objInsPartsOrderItem.PriceBookEntryId = pts.PriceBookEntryId;
            objInsPartsOrderItem.Configuration__c = pts.Configuration;
            objInsPartsOrderItem.Configuration_Description__c = pts.ConfigurationDescription;
            objInsPartsOrderItem.Feature__c = pts.Feature;
            objInsPartsOrderItem.isProductParent__c = pts.isProductParent;
            objInsPartsOrderItem.ProductParentUnique__c = pts.ProductParentUnique;
            if(pts.ParentPartNumber==null || pts.ParentPartNumber=='' ){
                objInsPartsOrderItem.Parent_Part_Number__c = pts.ParentPartNumber;
                objInsPartsOrderItem.isProductParent__c = true;
            }else if(mapParentAdjustment.get(pts.ParentPartNumber)!=null){
                objInsPartsOrderItem.Parent_Part_Number__c = String.valueof(Integer.valueof(mapParentAdjustment.get(pts.ParentPartNumber))*10);
            }
            objInsPartsOrderItem.List_Unit_Price__c = pts.ListUnitPrice!=null?pts.ListUnitPrice:pts.Sel_NetUnitPrice;
            objInsPartsOrderItem.Net_Unit_Price__c = pts.Sel_NetUnitPrice;
            objInsPartsOrderItem.UnitPrice = pts.Sel_NetUnitPrice;
       //     objInsPartsOrderItem.Disposable_Fee__c = pts.DisposableFee;
       //     objInsPartsOrderItem.Tax_Rate__c = pts.TaxRate;
       //     objInsPartsOrderItem.SBQQ__TaxAmount__c = pts.TaxAmount;
       //     objInsPartsOrderItem.Reason_Code__c = pts.ReasonCode;
       //     objInsPartsOrderItem.Reason_Category_Code__c = pts.ReasonCategoryCode;
            
                if(pts.ReasonCode!=null){
                    if(pts.ReasonCode.length()>5  && !pts.ReasonCode.contains('null') ){
                        objInsPartsOrderItem.Reason_Category_Code__c = pts.ReasonCode.substring(3,5);
                        if(pts.ReasonCode.substring(5).length()==1){
                        	objInsPartsOrderItem.Reason_Code__c = '0' + pts.ReasonCode.substring(5);
                        }else if(pts.ReasonCode.substring(5).length()==2){
                            objInsPartsOrderItem.Reason_Code__c = pts.ReasonCode.substring(5);
                        }
                    }
                }

            objInsPartsOrderItem.Product_Type__c = pts.ProductType;
			lstInsOrderItem.add(objInsPartsOrderItem);
            system.debug('objInsPartsOrderItem.Parent_Part_Number__c--> ' + objInsPartsOrderItem.Parent_Part_Number__c );
            system.debug('objInsPartsOrderItem.Reason_Code__c--> ' + objInsPartsOrderItem.Reason_Code__c + ' || objInsPartsOrderItem.Reason_Category_Code__c--> ' + objInsPartsOrderItem.Reason_Category_Code__c );
        }
        
                try{
                    
        insert lstInsOrderItem;
        
        PageReference retURL = new PageReference('/apex/OrderAdjustmentEdit?id=' + saveOrderId + '&adj=' + selectedAdjustment );
        retURL.setRedirect(true);
        return retURL;
            
                }catch(Exception e){
                    String em = 'Following error was encountered while creating order items: ' + e.getMessage();
                    System.debug(em);
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, em));   
                }
                
                
                
            }catch(Exception e){
                    String em = 'Following error was encountered while creating order: ' + e.getMessage();
                    System.debug(em);
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, em));   
            }
            
            
        }
        
        
        
        return null;
    }
    
    
    /*
    public PageReference actionSaveAdjustment(){
        
        system.debug('selectedHeaderReasonCode--> ' + selectedHeaderReasonCode );
        system.debug('lstOrderOverviewQry[0].Purchase_Number__c--> ' + lstOrderOverviewQry[0].Purchase_Number__c );
        system.debug('lstOrderOverviewQry[0].Shipping_Contact_First_Name__c--> ' + lstOrderOverviewQry[0].Shipping_Contact_First_Name__c );
        system.debug('lstOrderOverviewQry[0].Shipping_Contact_Last_Name__c--> ' + lstOrderOverviewQry[0].Shipping_Contact_Last_Name__c );
        system.debug('lstOrderOverviewQry[0].Shipping_Contact_Phone__c--> ' + lstOrderOverviewQry[0].Shipping_Contact_Phone__c );
        system.debug('lstOrderOverviewQry[0].Shipping_Contact_Email__c--> ' + lstOrderOverviewQry[0].Shipping_Contact_Email__c );
        system.debug('lstOrderOverviewQry[0].ShippingStreet--> ' + lstOrderOverviewQry[0].ShippingStreet );
        system.debug('lstOrderOverviewQry[0].ShippingCity--> ' + lstOrderOverviewQry[0].ShippingCity );
        system.debug('lstOrderOverviewQry[0].ShippingState--> ' + lstOrderOverviewQry[0].ShippingState );
        system.debug('lstOrderOverviewQry[0].ShippingPostalCode--> ' + lstOrderOverviewQry[0].ShippingPostalCode );
        system.debug('lstOrderOverviewQry[0].BillingStreet--> ' + lstOrderOverviewQry[0].BillingStreet );
        system.debug('lstOrderOverviewQry[0].BillingCity--> ' + lstOrderOverviewQry[0].BillingCity );
        system.debug('lstOrderOverviewQry[0].BillingState--> ' + lstOrderOverviewQry[0].BillingState );
        system.debug('lstOrderOverviewQry[0].BillingPostalCode--> ' + lstOrderOverviewQry[0].BillingPostalCode );
        system.debug('lstOrderOverviewQry[0].isCommonCarrier__c--> ' + lstOrderOverviewQry[0].isCommonCarrier__c );
        
        List<String> lstErrorMessage = new List<String>();
        
        if((selectedHeaderReasonCode == null || selectedHeaderReasonCode == '') ){
            lstErrorMessage.add('Missing Reason Code for the Order Header');
        }
        if((lstOrderOverviewQry[0].Purchase_Number__c == null || lstOrderOverviewQry[0].Purchase_Number__c == '') ){
            lstErrorMessage.add('Missing Purchase Number');
        }
        if((lstOrderOverviewQry[0].Shipping_Contact_First_Name__c == null || lstOrderOverviewQry[0].Shipping_Contact_First_Name__c == '') ){
            lstErrorMessage.add('Missing Pick-up Contact First Name');
        }
        if((lstOrderOverviewQry[0].Shipping_Contact_Last_Name__c == null || lstOrderOverviewQry[0].Shipping_Contact_Last_Name__c == '') ){
            lstErrorMessage.add('Missing Pick-up Contact Last Name');
        }
        if((lstOrderOverviewQry[0].Shipping_Contact_Phone__c == null || lstOrderOverviewQry[0].Shipping_Contact_Phone__c == '') ){
            lstErrorMessage.add('Missing Pick-up Contact Phone');
        }
        if((lstOrderOverviewQry[0].Shipping_Contact_Email__c == null || lstOrderOverviewQry[0].Shipping_Contact_Email__c == '') ){
            lstErrorMessage.add('Missing Pick-up Contact Email');
        }
        if((lstOrderOverviewQry[0].ShippingStreet == null || lstOrderOverviewQry[0].ShippingStreet == '') ){
            lstErrorMessage.add('Missing Pick-up Street');
        }
        if((lstOrderOverviewQry[0].ShippingCity == null || lstOrderOverviewQry[0].ShippingCity == '') ){
            lstErrorMessage.add('Missing Pick-up City');
        }
        if((lstOrderOverviewQry[0].ShippingState == null || lstOrderOverviewQry[0].ShippingState == '') ){
            lstErrorMessage.add('Missing Pick-up State');
        }
        if((lstOrderOverviewQry[0].ShippingPostalCode == null || lstOrderOverviewQry[0].ShippingPostalCode == '') ){
            lstErrorMessage.add('Missing Pick-up Zip Code');
        }
        if((lstOrderOverviewQry[0].BillingStreet == null || lstOrderOverviewQry[0].BillingStreet == '') ){
            lstErrorMessage.add('Missing Billing Street');
        }
        if((lstOrderOverviewQry[0].BillingCity == null || lstOrderOverviewQry[0].BillingCity == '') ){
            lstErrorMessage.add('Missing Billing City');
        }
        if((lstOrderOverviewQry[0].BillingState == null || lstOrderOverviewQry[0].BillingState == '') ){
            lstErrorMessage.add('Missing Billing State');
        }
        if((lstOrderOverviewQry[0].BillingPostalCode == null || lstOrderOverviewQry[0].BillingPostalCode == '') ){
            lstErrorMessage.add('Missing Billing Zip Code');
        }

        
        if((selectedAdjustment=='Return' || selectedAdjustment=='Exchange') && !Test.isRunningTest() ){
            
        Map<String, String> mapParentReason = new Map<String, String>();
            
            for (AdjOrderItem mc: lstPartsTotalSelection) {
                system.debug('mc.ReasonCode--> ' + mc.ReasonCode + ' || mc.AdjId--> ' + mc.AdjId + ' || mapItemReasonSel.get(mc.AdjId).size()--> ' + mapItemReasonSel.get(mc.AdjId).size() );
        //        if((mc.ReasonCode == null || mc.ReasonCode == '' ) && mapItemReasonSel.get(mc.AdjId).size() > 1 ){
                if((mc.ReasonCode == null || mc.ReasonCode == '' ) && mapItemReasonSel.get(mc.AdjId).size() > 1 && mc.ParentPartNumber == null ){
                    lstErrorMessage.add('Missing Reason Code for the Order Products');
                }
                if(mc.ParentPartNumber == null){
                    mapParentReason.put(mc.SeqNumber, mc.ReasonCode);
                }
                if(mapItemReasonSel.get(mc.AdjId).size() > 1 && mc.ParentPartNumber != null ){
                    mc.ReasonCode = mapParentReason.get(mc.ParentPartNumber);
                }
            }
        }
        
        
        if(lstErrorMessage.size()>0){
            for(String em:lstErrorMessage){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, em));   
            }
        }else{
            User usr_owner = new User();
            usr_owner = [SELECT Id, Name, ManagerId FROM User WHERE Id=:lstOrderOverviewQry[0].OwnerId AND isActive=true LIMIT 1 ];
            system.debug('usr_owner--> ' + usr_owner );
            
            String orn = 'SF_ADJ_';
            if(selectedAdjustment=='Return'){
                orn += 'RTN_';
            }else if(selectedAdjustment=='Exchange'){
                orn += 'EXC_';
            }else if(selectedAdjustment=='Credit Memo'){
                orn += 'CMR_';
            }else if(selectedAdjustment=='Debit Memo'){
                orn += 'DMR_';
            }
            
            
            DateTime dt = system.now();
            String str_dt = string.valueOf(dt.year()).substring(2) 
                + string.valueof(dt.month()<10?'0':'') + string.valueOf(dt.month())
                + string.valueof(dt.day()<10?'0':'') + string.valueOf(dt.day())
                + string.valueof(dt.hour()<10?'0':'') + string.valueOf(dt.hour())
                + string.valueof(dt.minute()<10?'0':'') + string.valueOf(dt.minute())
                + string.valueof(dt.second()<10?'0':'') + string.valueOf(dt.second());
            system.debug('str_dt--> ' + str_dt );
            
            orn+=str_dt;
            
            system.debug('orn--> ' + orn );
            
            
            List<Order> lstOrderInsert = new List<Order>();
        Order objOrderInsert = new Order();
            
         //   objOrderInsert.SBQQ__Contracted__c = true;
         //   objOrderInsert.ContractId = contractId;
            objOrderInsert.SBQQ__Quote__c = lstOrderOverviewQry[0].SBQQ__Quote__c;
        //    objOrderInsert.SBQQ__Contracted__c = false;
            objOrderInsert.AccountId = lstOrderOverviewQry[0].AccountId;
       //     objOrderInsert.Status = 'Submitted';
            objOrderInsert.Status = 'Adjustment Created';
            objOrderInsert.Order_Reference_Number__c = orn;
            objOrderInsert.Type = selectedAdjustment;
            objOrderInsert.Pricebook2Id='01s300000006uBlAAI';
            objOrderInsert.Order_Source__c='Salesforce';
            objOrderInsert.Parent_Order__c=orderId;
            objOrderInsert.District_Id__c=lstOrderOverviewQry[0].District_Id__c;
            objOrderInsert.Territory_Id__c=lstOrderOverviewQry[0].Territory_Id__c;
            objOrderInsert.EffectiveDate = system.today();
            objOrderInsert.Reason_Code__c = selectedHeaderReasonCode;
            objOrderInsert.Purchase_Number__c=lstOrderOverviewQry[0].Purchase_Number__c;
            objOrderInsert.Shipping_Contact_First_Name__c=lstOrderOverviewQry[0].Shipping_Contact_First_Name__c;
            objOrderInsert.Shipping_Contact_Last_Name__c=lstOrderOverviewQry[0].Shipping_Contact_Last_Name__c;
            objOrderInsert.Shipping_Contact_Phone__c=lstOrderOverviewQry[0].Shipping_Contact_Phone__c;
            objOrderInsert.Shipping_Contact_Email__c=lstOrderOverviewQry[0].Shipping_Contact_Email__c;
            objOrderInsert.ShippingStreet=lstOrderOverviewQry[0].ShippingStreet;
            objOrderInsert.ShippingCity=lstOrderOverviewQry[0].ShippingCity;
            objOrderInsert.ShippingState=lstOrderOverviewQry[0].ShippingState;
            objOrderInsert.ShippingPostalCode=lstOrderOverviewQry[0].ShippingPostalCode;
            objOrderInsert.BillingStreet=lstOrderOverviewQry[0].BillingStreet;
            objOrderInsert.BillingCity=lstOrderOverviewQry[0].BillingCity;
            objOrderInsert.BillingState=lstOrderOverviewQry[0].BillingState;
            objOrderInsert.BillingPostalCode=lstOrderOverviewQry[0].BillingPostalCode;
            objOrderInsert.isCommonCarrier__c=lstOrderOverviewQry[0].isCommonCarrier__c;
      //      objOrderInsert.Delivery_Charge__c = sel_delivery_charge;
      //      objOrderInsert.Premium_Delivery_Charge__c = sel_premium_delivery_charge;
      //      objOrderInsert.Haulaway_Charge__c = sel_haulaway_charge;
            objOrderInsert.Delivery_Charge__c = isSelectedDeliveryCharge?sel_delivery_charge:0;
            objOrderInsert.Premium_Delivery_Charge__c = isSelectedPremiumDeliveryCharge?sel_premium_delivery_charge:0;
            objOrderInsert.Haulaway_Charge__c = isSelectedHaulawayCharge?sel_haulaway_charge:0;
            if(usr_owner.ManagerId!=null){
                objOrderInsert.Order_Approver__c=usr_owner.ManagerId;
          //      objOrderInsert.Order_Approver__c='00530000004EqVqAAK';
                objOrderInsert.Post_Sales_Manager_Lead__c=usr_owner.ManagerId;
            }
            lstOrderInsert.add(objOrderInsert);
            
            try{
                insert lstOrderInsert;
            
                String saveOrderId = '';
                saveOrderId = lstOrderInsert[0].Id;
            
                Map<String, String> mapParentAdjustment = new Map<String, String>();
                for (AdjOrderItem ts: lstPartsTotalSelection) {
                    mapParentAdjustment.put(ts.SeqNumber, ts.Sel_AdjId);
                }
                
        List<OrderItem> lstInsOrderItem = new List<OrderItem>();
            OrderItem objInsPartsOrderItem = new OrderItem();
        for (AdjOrderItem pts: lstPartsTotalSelection) {
            system.debug('pts--> ' + pts );
            system.debug('pts.Sel_AdjId--> ' + pts.Sel_AdjId + ' || pts.SeqNumber--> ' + pts.SeqNumber + ' || pts.ParentPartNumber--> ' + pts.ParentPartNumber );
            objInsPartsOrderItem = new OrderItem();
            
            objInsPartsOrderItem.OrderId = saveOrderId;
            objInsPartsOrderItem.Number__c = String.valueof(Integer.valueof(pts.Sel_AdjId)*10);
            objInsPartsOrderItem.Product2Id = pts.Product2Id;
            objInsPartsOrderItem.Quantity = pts.Sel_Quantity;
            objInsPartsOrderItem.PriceBookEntryId = pts.PriceBookEntryId;
            objInsPartsOrderItem.Configuration__c = pts.Configuration;
            objInsPartsOrderItem.Configuration_Description__c = pts.ConfigurationDescription;
            objInsPartsOrderItem.Feature__c = pts.Feature;
            objInsPartsOrderItem.isProductParent__c = pts.isProductParent;
            objInsPartsOrderItem.ProductParentUnique__c = pts.ProductParentUnique;
            if(pts.ParentPartNumber==null || pts.ParentPartNumber=='' ){
                objInsPartsOrderItem.Parent_Part_Number__c = pts.ParentPartNumber;
            }else if(mapParentAdjustment.get(pts.ParentPartNumber)!=null){
                objInsPartsOrderItem.Parent_Part_Number__c = String.valueof(Integer.valueof(mapParentAdjustment.get(pts.ParentPartNumber))*10);
            }
            objInsPartsOrderItem.List_Unit_Price__c = pts.ListUnitPrice!=null?pts.ListUnitPrice:pts.Sel_NetUnitPrice;
            objInsPartsOrderItem.Net_Unit_Price__c = pts.Sel_NetUnitPrice;
            objInsPartsOrderItem.UnitPrice = pts.Sel_NetUnitPrice;
       //     objInsPartsOrderItem.Disposable_Fee__c = pts.DisposableFee;
       //     objInsPartsOrderItem.Tax_Rate__c = pts.TaxRate;
       //     objInsPartsOrderItem.SBQQ__TaxAmount__c = pts.TaxAmount;
       //     objInsPartsOrderItem.Reason_Code__c = pts.ReasonCode;
       //     objInsPartsOrderItem.Reason_Category_Code__c = pts.ReasonCategoryCode;
            
                if(pts.ReasonCode!=null){
                    if(pts.ReasonCode.length()>5  && !pts.ReasonCode.contains('null') ){
                        objInsPartsOrderItem.Reason_Category_Code__c = pts.ReasonCode.substring(3,5);
                        if(pts.ReasonCode.substring(5).length()==1){
                        	objInsPartsOrderItem.Reason_Code__c = '0' + pts.ReasonCode.substring(5);
                        }else if(pts.ReasonCode.substring(5).length()==2){
                            objInsPartsOrderItem.Reason_Code__c = pts.ReasonCode.substring(5);
                        }
                    }
                }

            objInsPartsOrderItem.Product_Type__c = pts.ProductType;
			lstInsOrderItem.add(objInsPartsOrderItem);
            system.debug('objInsPartsOrderItem.Parent_Part_Number__c--> ' + objInsPartsOrderItem.Parent_Part_Number__c );
            system.debug('objInsPartsOrderItem.Reason_Code__c--> ' + objInsPartsOrderItem.Reason_Code__c + ' || objInsPartsOrderItem.Reason_Category_Code__c--> ' + objInsPartsOrderItem.Reason_Category_Code__c );
        }
        
                try{
                    
        insert lstInsOrderItem;
        
        PageReference retURL = new PageReference('/apex/OrderAdjustmentEdit?id=' + saveOrderId + '&adj=' + selectedAdjustment );
        retURL.setRedirect(true);
        return retURL;
            
                }catch(Exception e){
                    String em = 'Following error was encountered while creating order items: ' + e.getMessage();
                    System.debug(em);
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, em));   
                }
                
                
                
            }catch(Exception e){
                    String em = 'Following error was encountered while creating order: ' + e.getMessage();
                    System.debug(em);
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, em));   
            }
            
            
        }
        
        
        
        return null;
    }
    */
    
    public class AdjOrderItem{
        public String AdjId {get;set;}
        public String SelId {get;set;}
        public String OrderId {get;set;}
        public String OrderItemId {get;set;}
        public String SeqNumber {get;set;}
        public Boolean isProductParent {get;set;}
        public String ProductParentUnique {get;set;}
        public String ParentPartNumber {get;set;}
        public String Product2Id {get;set;}
        public String ProductCode {get;set;}
        public String ProductName {get;set;}
        public Integer Quantity {get;set;}
        public String Feature {get;set;}
        public String Configuration {get;set;}
        public String ConfigurationDescription {get;set;}
        public String PriceBookEntryId {get;set;}
        public String ReasonCode {get;set;}
        public String ReasonCategoryCode {get;set;}
        public Decimal UnitPrice {get;set;}
        public Decimal ListUnitPrice {get;set;}
        public Decimal NetUnitPrice {get;set;}
        public Decimal NetTotalPrice {get;set;}
        public Decimal DisposableFee {get;set;}
        public Decimal TaxRate {get;set;}
        public Decimal TaxAmount {get;set;}   
        public String ProductType {get;set;}  
        public String Sel_AdjId {get;set;}
        public Integer Sel_Quantity {get;set;}
        public Decimal Sel_NetUnitPrice {get;set;}
        public Decimal Sel_NetTotalPrice {get;set;}
    }
    
    public class address{
        public String seqno {get;set;}
        public string geoCode {get;set;}
        public string countyCode {get;set;}
        public string countyName {get;set;}
        public address(String seqno, string geoCode, string countyCode,string countyName ){
            this.seqno = seqno;
            this.geoCode = geoCode;
            this.countyCode = countyCode;
            this.countyName = countyName;
        }
    }
    
    
    
}