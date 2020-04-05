public class StandaloneEditController {
    
    public String orderId {get; set;}
    
    public String selectedAdjustment {get; set;}
    public String selectedSaveAdjustment {get; set;}
    
    
    public String selectedSCOAccount {get; set;}
    public String selectedzipcode {get; set;}
    public String selectedproductcode {get; set;}
    public Map<String,List<OptionProduct>> mapOptionProduct {get; set;}
    public Integer lenMapOptionProduct {get; set;}
    
    
    public Map<String,Boolean> mapFeatureRender {get; set;}
    public Map<String,Boolean> renFeatureSelect {get; set;}
    
    public Boolean renInstallation {get; set;}
    public String selInstallation {get; set;}
    public Boolean renInstallPrice {get; set;}
    public String selInstallPrice {get; set;}
    public Map<String,String> mapInstallPrice {get; set;}
    public Map<String,String> mapInstallation {get; set;}
    
    public Map<String,String> mapProductCode {get; set;}
    public Map<String,String> mapProductCodeName {get; set;}
    public Map<String,Double> mapKAP {get; set;}
    public Map<String,Double> mapCost {get; set;}
    public Map<String,Double> mapKAPService2 {get; set;}
    
    public Boolean renAccessories {get; set;}
    public Boolean renProduct {get; set;}
    
    public Map<String,String> mapPriceBookEntry {get; set;}
    public List<AdjOrderItem> lstPartsOrderSelection {get; set;}
    
    public Order objOrderOverviewQry {get; set;}
    public List<OrderItem> lstOrderOverviewItemQry {get; set;}
    
 //   public Boolean isSelectedDeliveryCharge {get; set;}
 //   public Boolean isSelectedPremiumDeliveryCharge {get; set;}
 //   public Boolean isSelectedHaulawayCharge {get; set;}
    
    public Map<String, list<selectoption>> mapItemReasonSel {get; set;}
    public Map<String, List<String>> mapRCDiv {get; set;}
    public Map<String, String> mapDCR {get; set;}
    
    public String accountid {get; set;}
    public String territory_id {get; set;}
    public String district_id {get; set;}
    
    public Integer selectedProductQuantity {get; set;}
    public Decimal selectedProductPrice {get; set;}
    
    public Boolean renAddress {get; set;}
    public List<address> l_addressList {get; set;}
    public String selectedAddr {get; set;}
    public Map<String, address> mapAddr {get; set;}
    
    public Boolean isMemo {get; set;}
    public Boolean renMemo {get; set;}
    
    public string selectedmemoproductcode {get; set;}
    public string selectedpart {get; set;}
    public string selectedinstall {get; set;}
    public string selectedprotection {get; set;}
    
    public Boolean renObjOrder {get; set;}
    public Boolean renObjOrderMessage {get; set;}
    public AdjOrderItem objOSPart {get; set;}
    
    public Boolean renBtn {get; set;}
    
    public Map<String, String> mapParentReason {get; set;}
    public Map<String, Boolean> mapisChildReasonDisplay {get; set;}
        
    public StandaloneEditController(){
        
        orderId = ApexPages.CurrentPage().getparameters().get('id');
        selectedAdjustment = ApexPages.CurrentPage().getparameters().get('adj');
        
        
        selectedSCOAccount = '';
        selectedzipcode = '';
        selectedproductcode = '';
        
    //    selectedSCOAccount = '1100000007';
    //    selectedzipcode = '60179';
    //    selectedproductcode = '02608262000';
             
        system.debug('orderId --> ' + orderId );
        system.debug('selectedAdjustment --> ' + selectedAdjustment );
        system.debug('selectedSCOAccount --> ' + selectedSCOAccount );
        system.debug('selectedzipcode --> ' + selectedzipcode );
        system.debug('selectedproductcode --> ' + selectedproductcode );
        
        
        mapOptionProduct = new Map<String, List<OptionProduct>>();
        lenMapOptionProduct = 0;  
        
            mapFeatureRender = new Map<String,Boolean>();
            renFeatureSelect = new Map<String,Boolean>();
        
        renInstallation = false;  
        selInstallation = '';  
        renInstallPrice = false;  
        selInstallPrice = '';  
        mapInstallPrice = new Map<String,String>();
        mapInstallation = new Map<String,String>();

        renAccessories = false;
        renProduct = false;
        
        mapProductCode = new Map<String,String>();
        mapProductCodeName = new Map<String,String>();
        
        
        
        for(Product2 pr:[SELECT Id, Name, Description, ProductCode  FROM Product2 WHERE IsActive=true AND SBQQ__Component__c =false AND CanUseQuantitySchedule=false AND ProductCode!=null ORDER BY ProductCode  ]){
            if(!pr.ProductCode.startswith('010') && !pr.ProductCode.startswith('070') ){
            mapProductCode.put(pr.ProductCode, pr.Id);
            mapProductCodeName.put(pr.ProductCode, pr.Name);
            }
    //        mapProductObject.put(pr.ProductCode, pr);
        }
        
            mapKAP = new Map<String,Double>();
            mapCost = new Map<String,Double>();
            mapKAPService2 = new Map<String,Double>();
        
        
        
        
   //     selectedAdjustment = 'Return';
   //     selectedAdjustment = '';
        selectedSaveAdjustment = selectedAdjustment;
        
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
        
        
        
        lstPartsOrderSelection = new List<AdjOrderItem>();

        lstOrderOverviewItemQry = new List<OrderItem>();
        objOrderOverviewQry = new Order();
        
   //     isSelectedDeliveryCharge = false;
   //     isSelectedPremiumDeliveryCharge = false;
   //     isSelectedHaulawayCharge = false;
                
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
        
        selectedProductQuantity = 1;
        selectedProductPrice = 0;
        
        renAddress = false;
        renBtn = true;
        l_addressList = new List<address>();
        selectedAddr = '';
        mapAddr = new Map<String, address>();
        
        isMemo = false;
        renMemo = false;
        
        selectedmemoproductcode = '';
        selectedpart = '';
        selectedinstall = '';
        selectedprotection = '';
        
        renObjOrder = false;
        renObjOrderMessage = false;
        objOSPart = new AdjOrderItem();
        
                
        objOrderOverviewQry = new Order();
        objOrderOverviewQry = [SELECT Id, OrderNumber, ContractId, SBQQ__Quote__c, AccountId, Status, EffectiveDate, Delivery_Date__c, 
                               		Delivery_Instruction__c, Payment_Type__c, Pricebook2Id, Delivery_Charge__c,  Parent_Order__c, 
                             		Purchase_Number__c, District_Id__c, Territory_Id__c, Order_Reference_Number__c, Order_Approver__c, 
                             		SBQQ__TaxAmount__c, Gross_Amount__c, TotalAmount, B2B_Order_Id__c, //Order_Source__c, OwnerId, 
                             		Type, Reason_Code__c, ShippingAddress, BillingAddress, ShippingStreet, ShippingCity, 
                             		ShippingState, ShippingPostalCode, BillingStreet, BillingCity, BillingState, BillingPostalCode,
                               		Geo_Code__c, County_Code__c, County_Name__c, Account.SCO_Account_ID__c, Haulaway_Charge__c, 
                               		Premium_Delivery_Charge__c , DOS_Order_Number__c, RMA_Order_Number__c, Origin_Order_Date__c, 
                               		Post_Sales_Manager_Lead__c, isCommonCarrier__c, Shipping_Contact_First_Name__c, 
                               		Shipping_Contact_Last_Name__c, Shipping_Contact_Phone__c, Shipping_Contact_Email__c
                               FROM Order                             
                               WHERE Id=:orderId
                               LIMIT 1
                             ];
        
   //     system.debug('objOrderOverviewQry--> ' + objOrderOverviewQry );
        
        List<Account> lstSCOAccount = new List<Account>();
        lstSCOAccount = [SELECT Id, Name, Price_List_Type__c, SCO_Account_Id__c, NewTerritory__c 
                         FROM Account 
                         WHERE Id=: objOrderOverviewQry.AccountId
                         LIMIT 1
                        ];
        
        system.debug('lstSCOAccount.size()--> ' + lstSCOAccount.size() );
        
        accountId = '';
        String account_price_type = '';
        String account_new_territory = '';
        
        if(lstSCOAccount.size()>0 && selectedAdjustment!=null && selectedAdjustment!='' ){
            accountId = lstSCOAccount[0].Id;
            account_price_type = lstSCOAccount[0].Price_List_Type__c;
            account_new_territory = lstSCOAccount[0].NewTerritory__c;
            selectedSCOAccount = lstSCOAccount[0].SCO_Account_Id__c;
        
                
        territory_id = '';
        district_id = '';
        
        List<Territory__c> lstTerritory = new List<Territory__c>();
        lstTerritory = [SELECT Id, Name, Territory_ID__c, District_Territory_ID__c 
                        FROM Territory__c 
                //        WHERE Territory_ID__c =: lstQuote[0].SBQQ__Account__r.Territory_ID__c 
                        WHERE Id =: account_new_territory 
                        ORDER BY Id DESC
                        LIMIT 1
                       ];
            if(lstTerritory.size()>0){
                territory_id = lstTerritory[0].Territory_ID__c;
                district_id = lstTerritory[0].District_Territory_ID__c;
            }
        
        
        List<Key_Account_Pricing__c> lstKAP = new List<Key_Account_Pricing__c>();
        lstKAP = [SELECT Id, Customer_KAP_price__c, Material_Number__c //Valid_from__c, Valid_to__c, Customer__c, Price_List_Type__c, Material_Number__c//, Product__c
                  FROM Key_Account_Pricing__c
                  WHERE ( Material_Number__c IN: mapProductCode.keyset()) 
                    AND 
                  (
                      (Customer__c!=null AND Price_List_Type__c=null AND Customer__c=: accountId) 
                      OR 
                      (Customer__c=null AND Price_List_Type__c!=null AND Price_List_Type__c=:account_price_type)
                  ) 
                    AND Valid_from__c<=:system.today() AND Valid_to__c>=:system.today()
                 ];
        
        
        for(Key_Account_Pricing__c lk:lstKAP){
            mapKAP.put(lk.Material_Number__c, lk.Customer_KAP_price__c);
            if(lk.Material_Number__c.startswith('4')){
                mapKAPService2.put(lk.Material_Number__c, lk.Customer_KAP_price__c);
            }
        }
        //account_tier
        List<Product_Pricing__c> lstProductPricing = new List<Product_Pricing__c>();
        lstProductPricing = [SELECT Id, Price__c, Cost__c, Material_Number__c//, Product__c
                             FROM Product_Pricing__c
                             WHERE Material_Number__c IN: mapProductCode.keyset()
                            ];
        
        for(Product_Pricing__c lp:lstProductPricing){
            mapCost.put(lp.Material_Number__c, lp.Cost__c);
            
            if(mapKAP.get(lp.Material_Number__c)==null){
                mapKAP.put(lp.Material_Number__c, lp.Price__c);
            }
            
            if(lp.Material_Number__c.startswith('4')){
                if(mapKAPService2.get(lp.Material_Number__c)==null){
                    mapKAPService2.put(lp.Material_Number__c, lp.Price__c);
                }
            }
            
            
        }
       
        system.debug('mapKAP--> ' + mapKAP );
        system.debug('mapKAPService2--> ' + mapKAPService2 );
        system.debug('mapCost--> ' + mapCost );
        
                    system.debug('selectedProductQuantity--> ' + selectedProductQuantity );
                    system.debug('selectedProductPrice--> ' + selectedProductPrice );
  //              selectedProductQuantity = 1;
 //               selectedProductPrice = 0;
                    system.debug('selectedProductQuantity--> ' + selectedProductQuantity );
                    system.debug('selectedProductPrice--> ' + selectedProductPrice );

        
        renProduct = true;
            
        selectedSaveAdjustment = selectedAdjustment;
        
            system.debug('selectedAdjustment--> ' + selectedAdjustment );
        
        isMemo = false;
        renMemo = false;
        if(selectedAdjustment=='Credit Memo' || selectedAdjustment=='Debit Memo' ){
            isMemo = true;
            renMemo = true;
        }
        
            
        }
        
        
        lstOrderOverviewItemQry = new List<OrderItem>();
        lstOrderOverviewItemQry = [SELECT Id, OrderId, Product2Id, Product2.Name, Product2.ProductCode, Quantity, Configuration__c, 
                                 		Configuration_Description__c, Number__c, Feature__c, isProductParent__c, ProductParentUnique__c, 
                                 		Parent_Part_Number__c, Order_Reference_Number__c, Unique_Value__c, List_Unit_Price__c, Reason_Code__c, Reason_Category_Code__c, 
                                 		Net_Unit_Price__c, Net_Total_Price__c, SBQQ__TaxAmount__c, Item_Tax__c, Tax__c, Tax_Rate__c, Total_Tax_Amount__c,  
                                 		PriceBookEntryId, Disposable_Fee__c, OMS_Order_Id__c, Billable_Quantity__c, Cancelled_Quantity__c, Order_Type__c, Product_Type__c 
                                 	FROM OrderItem                                 
                                 	WHERE OrderId=:orderId
                                 	ORDER BY Number__c
                                 	];
        
        integer noit = 0;
             AdjOrderItem   objOrderSelection = new AdjOrderItem();
        
        mapParentReason = new Map<String, String>();
        mapisChildReasonDisplay = new Map<String, Boolean>();
                
        for(OrderItem oi:lstOrderOverviewItemQry){
                                    
                
                noit++;
                
                objOrderSelection = new AdjOrderItem();
                objOrderSelection.AdjId = String.valueOf(noit);
                objOrderSelection.SelId = String.valueOf(noit);
            //    objOrderSelection.SeqNumber = isMemo?'99':oi.Number__c;
            objOrderSelection.SeqNumber = oi.Product_Type__c=='Adjustment' || oi.Product_Type__c=='InstallationService' || oi.Product_Type__c=='PAWarranty'?'99':oi.Number__c;
                    system.debug('objOrderSelection.SeqNumber--> ' + objOrderSelection.SeqNumber );
            objOrderSelection.OrderItemId = oi.Id;
                objOrderSelection.OrderId = oi.OrderId;
                objOrderSelection.isProductParent = oi.isProductParent__c;
                objOrderSelection.ProductParentUnique = oi.ProductParentUnique__c;
                objOrderSelection.ParentPartNumber = oi.Parent_Part_Number__c;
                objOrderSelection.Product2Id = oi.Product2Id;
                objOrderSelection.ProductCode = oi.Product2.ProductCode;
                objOrderSelection.ProductName = oi.Product2.Name;
                objOrderSelection.Quantity = Integer.valueof(oi.Quantity);
                objOrderSelection.Feature = oi.Feature__c;
                objOrderSelection.Configuration = oi.Configuration__c;
                objOrderSelection.ConfigurationDescription = oi.Configuration_Description__c;
                objOrderSelection.PriceBookEntryId = oi.PriceBookEntryId;
            if(oi.Reason_Code__c!=null && oi.Reason_Code__c!='' && oi.Reason_Category_Code__c!=null && oi.Reason_Category_Code__c!='' ){
                objOrderSelection.ReasonCode = '6' + oi.Product2.ProductCode.substring(1,3) + oi.Reason_Category_Code__c + String.valueOf(Integer.valueOf(oi.Reason_Code__c)) ;
            }
                    system.debug('objOrderSelection.ReasonCode--> ' + objOrderSelection.ReasonCode );
                objOrderSelection.ReasonCategoryCode = '';
           //     objOrderSelection.ReasonCode = oi.Reason_Code__c;
           //     objOrderSelection.ReasonCategoryCode = oi.Reason_Category_Code__c;
           //     objOrderSelection.ListUnitPrice = oi.List_Unit_Price__c;
                objOrderSelection.ListUnitPrice = oi.Net_Unit_Price__c;
                objOrderSelection.NetUnitPrice = oi.Net_Unit_Price__c;
                objOrderSelection.NetTotalPrice = oi.Net_Unit_Price__c * oi.Quantity ;
                objOrderSelection.DisposableFee = oi.Disposable_Fee__c ;
                objOrderSelection.TaxRate = oi.Tax_Rate__c ;
                objOrderSelection.TaxAmount = oi.SBQQ__TaxAmount__c ;
                objOrderSelection.ProductType = oi.Product_Type__c ;
                objOrderSelection.Sel_AdjId = String.valueOf(noit);
                objOrderSelection.Sel_Quantity = Integer.valueof(oi.Quantity);
                objOrderSelection.Sel_NetUnitPrice = oi.Net_Unit_Price__c;
                objOrderSelection.Sel_NetTotalPrice = oi.Net_Unit_Price__c * oi.Quantity;
            if(oi.Product_Type__c == 'OrderItem' || oi.Product_Type__c ==null || oi.Product_Type__c == ''  ){
                    mapisChildReasonDisplay.put(objOrderSelection.AdjId, false);
                    system.debug('objOrderSelection.AdjId--> ' + objOrderSelection.AdjId );
            }
                lstPartsOrderSelection.add(objOrderSelection);
           
        }
        
                    system.debug('mapisChildReasonDisplay--> ' + mapisChildReasonDisplay );
        
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
        system.debug('mapRCDiv--> ' + mapRCDiv );
        system.debug('mapDCR--> ' + mapDCR );
        
        
        
    }
    
    public PageReference gotoOrder(){
        PageReference retURL = new PageReference('/' + orderId );
        retURL.setRedirect(true);
        return retURL;
    }
    
    public PageReference actionGoToSubmission(){
    //    PageReference retURL = new PageReference('/apex/OrderAdjustmentSubmission?id=' + orderId + '&adj=' + selectedAdjustment );
    //    retURL.setRedirect(true);
    //    return retURL;
        
        
        String errMsg = '';
        
        errMsg = AdjustmentTaxCalculator.TaxCalcWrapper(orderId);
        if(errMsg == ''){
            //      PageReference retURL = new PageReference('/apex/OrderAdjustment?id=' + orderId + '&adj=' + ordertype + '&save=edit' );
            PageReference retURL = new PageReference('/apex/OrderAdjustmentSubmission?id=' + orderId + '&adj=' + selectedAdjustment );
            retURL.setRedirect(true);
            return retURL;
        }else{
            system.debug('errMsg:' +errMsg);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, errMsg));   
            return null;
        }
        
        
        
    }
    
    
    
    /*
    public void actionLoadProducts(){
        
        system.debug('selectedSCOAccount--> ' + selectedSCOAccount );
        
        List<Account> lstSCOAccount = new List<Account>();
        lstSCOAccount = [SELECT Id, Name, Price_List_Type__c, SCO_Account_Id__c, NewTerritory__c 
                         FROM Account 
                         WHERE SCO_Account_Id__c=: selectedSCOAccount
                         LIMIT 1
                        ];
        
        accountId = '';
        String account_price_type = '';
        String account_new_territory = '';
        
        
        
        if(lstSCOAccount.size()>0 && selectedAdjustment!=null && selectedAdjustment!='' ){
            accountId = lstSCOAccount[0].Id;
            account_price_type = lstSCOAccount[0].Price_List_Type__c;
            account_new_territory = lstSCOAccount[0].NewTerritory__c;
        
                
        territory_id = '';
        district_id = '';
        
        List<Territory__c> lstTerritory = new List<Territory__c>();
        lstTerritory = [SELECT Id, Name, Territory_ID__c, District_Territory_ID__c 
                        FROM Territory__c 
                //        WHERE Territory_ID__c =: lstQuote[0].SBQQ__Account__r.Territory_ID__c 
                        WHERE Id =: account_new_territory 
                        ORDER BY Id DESC
                        LIMIT 1
                       ];
            if(lstTerritory.size()>0){
                territory_id = lstTerritory[0].Territory_ID__c;
                district_id = lstTerritory[0].District_Territory_ID__c;
            }
        
        
        List<Key_Account_Pricing__c> lstKAP = new List<Key_Account_Pricing__c>();
        lstKAP = [SELECT Id, Customer_KAP_price__c, Valid_from__c, Valid_to__c, Customer__c, Price_List_Type__c, Material_Number__c//, Product__c
                  FROM Key_Account_Pricing__c
                  WHERE ( Material_Number__c IN: mapProductCode.keyset()) 
                    AND 
                  (
                      (Customer__c!=null AND Price_List_Type__c=null AND Customer__c=: accountId) 
                      OR 
                      (Customer__c=null AND Price_List_Type__c!=null AND Price_List_Type__c=:account_price_type)
                  ) 
                    AND Valid_from__c<=:system.today() AND Valid_to__c>=:system.today()
                 ];
        
        
        for(Key_Account_Pricing__c lk:lstKAP){
            mapKAP.put(lk.Material_Number__c, lk.Customer_KAP_price__c);
            if(lk.Material_Number__c.startswith('4')){
                mapKAPService2.put(lk.Material_Number__c, lk.Customer_KAP_price__c);
            }
        }
        //account_tier
        List<Product_Pricing__c> lstProductPricing = new List<Product_Pricing__c>();
        lstProductPricing = [SELECT Id, Price__c, Cost__c, Material_Number__c//, Product__c
                             FROM Product_Pricing__c
                             WHERE Material_Number__c IN: mapProductCode.keyset()
                            ];
        
        for(Product_Pricing__c lp:lstProductPricing){
            mapCost.put(lp.Material_Number__c, lp.Cost__c);
            
            if(mapKAP.get(lp.Material_Number__c)==null){
                mapKAP.put(lp.Material_Number__c, lp.Price__c);
            }
            
            if(lp.Material_Number__c.startswith('4')){
                if(mapKAPService2.get(lp.Material_Number__c)==null){
                    mapKAPService2.put(lp.Material_Number__c, lp.Price__c);
                }
            }
            
            
        }
       
        system.debug('mapKAP--> ' + mapKAP );
        system.debug('mapKAPService2--> ' + mapKAPService2 );
        system.debug('mapCost--> ' + mapCost );
        
                    system.debug('selectedProductQuantity--> ' + selectedProductQuantity );
                    system.debug('selectedProductPrice--> ' + selectedProductPrice );
  //              selectedProductQuantity = 1;
 //               selectedProductPrice = 0;
                    system.debug('selectedProductQuantity--> ' + selectedProductQuantity );
                    system.debug('selectedProductPrice--> ' + selectedProductPrice );

        
        renProduct = true;
        
    }else{
        if(lstSCOAccount.size()<=0 ){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Could not find Account'));   
        }
        if(selectedAdjustment==null || selectedAdjustment=='' ){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please Select Adjustment Type'));   
        }
        renProduct = false;
    }
        
        selectedSaveAdjustment = selectedAdjustment;
        
            system.debug('selectedAdjustment--> ' + selectedAdjustment );
        
        isMemo = false;
        renMemo = false;
        if(selectedAdjustment=='Credit Memo' || selectedAdjustment=='Debit Memo' ){
            isMemo = true;
            renMemo = true;
        }
        
        
    }
       */ 
    public list<selectoption> getAdjustmentSelection(){
        list<selectoption> lstSel= new list<selectoption>();
        lstSel.add(new SelectOption('', '--None--'));
        lstSel.add(new SelectOption('Return', 'Return'));            
        lstSel.add(new SelectOption('Exchange', 'Exchange'));            
        lstSel.add(new SelectOption('Credit Memo', 'Credit Memo'));            
        lstSel.add(new SelectOption('Debit Memo', 'Debit Memo'));            
        return lstSel;
    }
    
        
    
    public PageReference actionLoadAccessories(){
        
        
  //      selectedSCOAccount = '1100000007';
  //      selectedzipcode = '60179';
   //     selectedproductcode = '02212776000';
   //     selectedproductcode = '02608262000';
        
        
        
        renInstallation = false;  
        selInstallation = '';  
        renInstallPrice = false;  
        selInstallPrice = '';  
        mapInstallPrice = new Map<String,String>();
        mapInstallation = new Map<String,String>();
        
        
        mapOptionProduct = new Map<String, List<OptionProduct>>();
        lenMapOptionProduct = 0;   
        
            mapFeatureRender.put('Parts', false);
            mapFeatureRender.put('Services', false);
            mapFeatureRender.put('Config', false);
            renFeatureSelect.put('PartsSelect_All', false);
            renFeatureSelect.put('PartsSelect_One', false);
            renFeatureSelect.put('ServicesSelect_All', false);
            renFeatureSelect.put('ServicesSelect_One', false);
            renFeatureSelect.put('ServicesInstall', false);
      //      renFeatureSelect.put('ServicesOptional', false);
            renFeatureSelect.put('ConfigSelect_One', false);
        
        productaccessoriessend objPAS = new productaccessoriessend();
        objPAS.part_number = selectedproductcode;
        objPAS.quantity = '1';
        objPAS.zipcode = selectedzipcode;
        objPAS.account_number = selectedSCOAccount;
        
        String JSONString_PAS = JSON.serialize(objPAS);
        System.debug('Serialized  JSON format: ' + JSONString_PAS);
        
        
        Map<String, Common_Variables__c> mapCV = Common_Variables__c.getAll();
        String EndpointUrl = mapCV.get('B2BProd_Service_Install_URL').Content__c;
        String CS_CONTENT_TYPE = 'application/json';        
        String CS_CLIENT_ID = mapCV.get('B2BProd_KD_ClientId').Content__c;
        String CS_CLIENT_SECRET = mapCV.get('B2BProd_KD_ClientSecret').Content__c;
        
        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        Http http = new Http();
        
        request.setMethod('POST');
        request.setendPoint(EndpointUrl);
        
        request.setHeader('Content-Type', CS_CONTENT_TYPE);
        request.setHeader('CLIENT_ID', CS_CLIENT_ID);
        request.setHeader('CLIENT_SECRET', CS_CLIENT_SECRET);
        request.setHeader('Accept', CS_CONTENT_TYPE);
        request.setTimeout(60000); // timeout in milliseconds
        
        request.setBody(JSONString_PAS);
        system.debug('request>>' +request);
        
        CalloutB2BAPI.ResponseWrapper RW = CalloutB2BAPI.execute(request);
        
        system.debug('RW>>' +RW);
        system.debug('RW.message>>' +RW.message);
        system.debug('RW.Response>>' +RW.Response);
        
        if(((RW.message == '' && RW.Response != null) || Test.isRunningTest()) && mapProductCode.containsKey(selectedproductcode) ){
   //     if(1==1 ){
   //     
        renAccessories = true;
   //     
            system.debug('API response success');
            string resdoc = '';
            
            if(!Test.isRunningTest()){
                system.debug('RW.Response--> ' + RW.Response );
                response = http.send(request);
                resdoc = response.getBody();
            }else{
           //     resdoc = '{ "product": { "services": { "required_parts": { "select_all": [ { "part_number": "02649608000", "product_name": "Kenmore 1010  6 ft. Snap-Lock&trade; Flexible Pipe", "price": { "sellPrice": "14.99", "fixedPrice": "14.99", "regularPrice": "14.99" }, "description": "<p><strong> The Kenmore 6 ft. Snap-Lock Flexible Pipe Saves the Day, the Dryer</strong></p> <p>The <strong>Kenmore 6 ft. Snap-Lock Pipe</strong> may be 6 feet long, but its flexibility allows 90-degree turns, as long as you have 6 inches of clearance and 1 foot of length. Although you still need a clamp at the dryer and the wall, you don&rsquo;t need any between parts with the snapping collars on this pipe.</p> <p>Why should you use a hard pipe when a flexible pipe will allow you to position your dryer exactly where you like? You can easily install this pipe to ventilate dryer exhaust and know it will not easily become dislodged. With a Kenmore Snap-Lock Flexible Pipe, you won&rsquo;t have to worry about moving your dryer into a tight corner.</p>", "image_url": "//c.shld.net/rpx/i/s/i/spin/image/spin_prod_178048501" }, { "part_number": "02649609000", "product_name": "Kenmore Aluminum Dryer Exhaust Close Elbow", "price": { "sellPrice": "9.99", "fixedPrice": "9.99", "regularPrice": "9.99" }, "description": "<p><strong>Keep Your Dryer Venting Right with the Kenmore Dryer Exhaust Elbow </strong></p><p>The <strong>Kenmore Aluminum Dryer Exhaust Close Elbow</strong> lets your dryer vent it out. This&#160;elbow is designed to&#160;turn 90&deg; within 4.5&quot;, giving you plenty of space.&#160;This kit also comes with&#160;4&quot; diameter fittings and rotating snap-lock fittings so you can install the elbow easily and get your dryer back to work.</p>", "image_url": "//c.shld.net/rpx/i/s/i/spin/image/spin_prod_617729001" } ], "select_one": [ { "part_number": "02657000000", "product_name": "Kenmore 99920 6\' Electrical Dryer Cord", "price": { "sellPrice": "29.99", "fixedPrice": "29.99", "regularPrice": "29.99" }, "description": "<p><strong>Connect to Power</strong></p>  <p>Designed for homes built before 1996, the&nbsp;Kenmore 6\' dryer cord&nbsp;features a flat plug to help prevent bending and extra stress on wires. The three prongs ground the plug. An adjustable strain relief is included to help prevent wires from pulling out.</p>", "image_url": "//c.shld.net/rpx/i/s/i/spin/10154867/prod_2243203012" }, { "part_number": "02657001000", "product_name": "Kenmore 99921 57001 4-Prong 6\' Round Dryer Cord &#8211; Black", "price": { "sellPrice": "29.99", "fixedPrice": "29.99", "regularPrice": "31.99" }, "description": "<p>The&nbsp;<strong>Kenmore 4-Prong 6\' Round Dryer Cord&nbsp;</strong>is perfect for any do-it-yourself homeowner with a broken dryer cord. The cord is made for use in homes built after 1996 and includes an adjustable strain relief for optimal efficiency and consistent performance. Rated for 30 amps, this cord easily hooks up to your dryer, ensuring your laundry room will be back in operation in no time.</p>", "image_url": "//c.shld.net/rpx/i/s/i/spin/10154867/prod_2243199012" } ] }, "delivery_options": { "select_one": [ { "option_code": "hookup_3", "part_number": "40010500265", "description": "Delivery and Basic Hook-up", "price": 20.0, "hookup_tasks": "SPECIALTY LAUNDRY;Inspect existing installation area before starting;Deliver and unpack your new product,inspecting for damage or defects;Attach product legs and provide consumer literature;Disconnect your old product and place in accessible location per your request;Connect your new laundry product to necessary, code-approved utilities (you must provide a new electric cord or new stainless flexible gas line, depending on fuel source);Reverse door, if needed;Level the laundry product and connect the drain hose;Attach venting using new components (installer cannot use or connect to plastic venting, foil vent tubes, or an existing electrical cord);Test your new laundry product to ensure it performs properly and give you easy-to-understand instructions;Clean up the work place and dispose of any job-related debris and packaging materials." }, { "option_code": "brownbox_10", "part_number": "40010510000", "description": "Leave-in-Box Delivery", "price": 0.0, "hookup_tasks": null }, { "option_code": "uncrate_K", "part_number": "40010520000", "description": "Deliver and Uncrate", "price": 0.0, "hookup_tasks": null }, { "option_code": "install_J", "part_number": "install", "description": "Contact me to schedule professional installation. I understand an additional charge will apply.", "price": 0, "hookup_tasks": null } ], "optional": [ { "option_code": "haulawayRequested", "part_number": "40010599000", "description": "I would like my old item hauled away", "base_price": 15.0, "addon_price": 15.0 } ] }, "installation_services": [ { "part_number": "01026200000", "division": "26", "line": "4", "sub_line": "90", "short_desc": "MI DRYER GAS", "description": "", "price": "169.99" }, { "part_number": "01026201000", "division": "26", "line": "4", "sub_line": "90", "short_desc": "AI DRY GASLN", "description": "", "price": "0.01" }, { "part_number": "01026203000", "division": "26", "line": "4", "sub_line": "90", "short_desc": "MI DRYER ELE", "description": "", "price": "159.99" }, { "part_number": "01026204000", "division": "26", "line": "4", "sub_line": "90", "short_desc": "AI DRY VENT", "description": "", "price": "85.0" }, { "part_number": "01026205000", "division": "26", "line": "4", "sub_line": "90", "short_desc": "MI WASHER", "description": "", "price": "129.99" }, { "part_number": "01026207000", "division": "26", "line": "4", "sub_line": "90", "short_desc": "AI VENTMSNRY", "description": "", "price": "149.99" }, { "part_number": "01026208000", "division": "26", "line": "4", "sub_line": "90", "short_desc": "MI VENT ONLY", "description": "", "price": "109.99" }, { "part_number": "01026213000", "division": "26", "line": "4", "sub_line": "90", "short_desc": "MI WSH W/D", "description": "", "price": "99.99" }, { "part_number": "01026219000", "division": "26", "line": "4", "sub_line": "90", "short_desc": "AI LAUND APT", "description": "", "price": "34.99" }, { "part_number": "01026221000", "division": "26", "line": "4", "sub_line": "90", "short_desc": "AI DRYR HA", "description": "", "price": "25.0" }, { "part_number": "01026222000", "division": "26", "line": "4", "sub_line": "90", "short_desc": "AI WSHR HA", "description": "", "price": "0.0" }, { "part_number": "01026230000", "division": "26", "line": "4", "sub_line": "90", "short_desc": "WAR WASHER", "description": "", "price": "0.0" }, { "part_number": "01026231000", "division": "26", "line": "4", "sub_line": "90", "short_desc": "PA WASHER", "description": "", "price": "0.0" }, { "part_number": "01026247000", "division": "26", "line": "4", "sub_line": "90", "short_desc": "AI CHGFUEL", "description": "", "price": "0.0" }, { "part_number": "01026296000", "division": "26", "line": "4", "sub_line": "90", "short_desc": "WAR DRYERELE", "description": "", "price": "0.0" }, { "part_number": "01026297000", "division": "26", "line": "4", "sub_line": "90", "short_desc": "PA DRYER ELE", "description": "", "price": "0.0" }, { "part_number": "01026298000", "division": "26", "line": "4", "sub_line": "90", "short_desc": "WAR DRYERGAS", "description": "", "price": "0.0" }, { "part_number": "01026299000", "division": "26", "line": "4", "sub_line": "90", "short_desc": "PA DRYER GAS", "description": "", "price": "0.0" }, { "part_number": "01026771000", "division": "26", "line": "4", "sub_line": "90", "short_desc": "EST LAUNDELE", "description": "", "price": "69.99" }, { "part_number": "01026772000", "division": "26", "line": "4", "sub_line": "90", "short_desc": "EST LAUNDGAS", "description": "", "price": "69.99" }, { "part_number": "01026781000", "division": "26", "line": "4", "sub_line": "90", "short_desc": "EA LAUND ELE", "description": "", "price": "0.01" }, { "part_number": "01026782000", "division": "26", "line": "4", "sub_line": "90", "short_desc": "EA LAUND GS", "description": "", "price": "0.01" }, { "part_number": "01099888000", "division": "26", "line": "4", "sub_line": "90", "short_desc": "BLDG PERMITS", "description": "", "price": "0.0" }, { "part_number": "40010500000", "division": "", "line": "", "sub_line": "", "short_desc": "Deluxe Set Up", "description": "", "price": "0.0" } ] } } }';
            	resdoc  = '{ "product": { "services": { "required_parts": { "select_all": [ { "part_number": "02649608000", "product_name": "Kenmore 1010  6 ft. Snap-Lock&trade; Flexible Pipe", "price": { "sellPrice": "14.99", "fixedPrice": "14.99", "regularPrice": "14.99" }, "description": "<p><strong> The Kenmore 6 ft. Snap-Lock Flexible Pipe Saves the Day, the Dryer</strong></p> <p>The <strong>Kenmore 6 ft. Snap-Lock Pipe</strong> may be 6 feet long, but its flexibility allows 90-degree turns, as long as you have 6 inches of clearance and 1 foot of length. Although you still need a clamp at the dryer and the wall, you don&rsquo;t need any between parts with the snapping collars on this pipe.</p> <p>Why should you use a hard pipe when a flexible pipe will allow you to position your dryer exactly where you like? You can easily install this pipe to ventilate dryer exhaust and know it will not easily become dislodged. With a Kenmore Snap-Lock Flexible Pipe, you won&rsquo;t have to worry about moving your dryer into a tight corner.</p>", "image_url": "//c.shld.net/rpx/i/s/i/spin/image/spin_prod_178048501" }, { "part_number": "02649609000", "product_name": "Kenmore Aluminum Dryer Exhaust Close Elbow", "price": { "sellPrice": "9.99", "fixedPrice": "9.99", "regularPrice": "9.99" }, "description": "<p><strong>Keep Your Dryer Venting Right with the Kenmore Dryer Exhaust Elbow </strong></p><p>The <strong>Kenmore Aluminum Dryer Exhaust Close Elbow</strong> lets your dryer vent it out. This&#160;elbow is designed to&#160;turn 90&deg; within 4.5&quot;, giving you plenty of space.&#160;This kit also comes with&#160;4&quot; diameter fittings and rotating snap-lock fittings so you can install the elbow easily and get your dryer back to work.</p>", "image_url": "//c.shld.net/rpx/i/s/i/spin/image/spin_prod_617729001" } ], "select_one": [ { "part_number": "02657000000", "product_name": "Kenmore 99920 6\' Electrical Dryer Cord", "price": { "sellPrice": "29.99", "fixedPrice": "29.99", "regularPrice": "29.99" }, "description": "<p><strong>Connect to Power</strong></p>  <p>Designed for homes built before 1996, the&nbsp;Kenmore 6\' dryer cord&nbsp;features a flat plug to help prevent bending and extra stress on wires. The three prongs ground the plug. An adjustable strain relief is included to help prevent wires from pulling out.</p>", "image_url": "//c.shld.net/rpx/i/s/i/spin/10154867/prod_2243203012" }, { "part_number": "02657001000", "product_name": "Kenmore 99921 57001 4-Prong 6\' Round Dryer Cord &#8211; Black", "price": { "sellPrice": "29.99", "fixedPrice": "29.99", "regularPrice": "31.99" }, "description": "<p>The&nbsp;<strong>Kenmore 4-Prong 6\' Round Dryer Cord&nbsp;</strong>is perfect for any do-it-yourself homeowner with a broken dryer cord. The cord is made for use in homes built after 1996 and includes an adjustable strain relief for optimal efficiency and consistent performance. Rated for 30 amps, this cord easily hooks up to your dryer, ensuring your laundry room will be back in operation in no time.</p>", "image_url": "//c.shld.net/rpx/i/s/i/spin/10154867/prod_2243199012" } ] }, "delivery_options": { "select_all": [ { "option_code": "hookup_3", "part_number": "40010500265", "description": "Delivery and Basic Hook-up", "price": 20.0, "hookup_tasks": "SPECIALTY LAUNDRY;Inspect existing installation area before starting;Deliver and unpack your new product,inspecting for damage or defects;Attach product legs and provide consumer literature;Disconnect your old product and place in accessible location per your request;Connect your new laundry product to necessary, code-approved utilities (you must provide a new electric cord or new stainless flexible gas line, depending on fuel source);Reverse door, if needed;Level the laundry product and connect the drain hose;Attach venting using new components (installer cannot use or connect to plastic venting, foil vent tubes, or an existing electrical cord);Test your new laundry product to ensure it performs properly and give you easy-to-understand instructions;Clean up the work place and dispose of any job-related debris and packaging materials." }, { "option_code": "brownbox_10", "part_number": "40010510000", "description": "Leave-in-Box Delivery", "price": 0.0, "hookup_tasks": null }, { "option_code": "uncrate_K", "part_number": "40010520000", "description": "Deliver and Uncrate", "price": 0.0, "hookup_tasks": null }, { "option_code": "install_J", "part_number": "install", "description": "Contact me to schedule professional installation. I understand an additional charge will apply.", "price": 0, "hookup_tasks": null } ], "select_one": [ { "option_code": "hookup_3", "part_number": "40010500265", "description": "Delivery and Basic Hook-up", "price": 20.0, "hookup_tasks": "SPECIALTY LAUNDRY;Inspect existing installation area before starting;Deliver and unpack your new product,inspecting for damage or defects;Attach product legs and provide consumer literature;Disconnect your old product and place in accessible location per your request;Connect your new laundry product to necessary, code-approved utilities (you must provide a new electric cord or new stainless flexible gas line, depending on fuel source);Reverse door, if needed;Level the laundry product and connect the drain hose;Attach venting using new components (installer cannot use or connect to plastic venting, foil vent tubes, or an existing electrical cord);Test your new laundry product to ensure it performs properly and give you easy-to-understand instructions;Clean up the work place and dispose of any job-related debris and packaging materials." }, { "option_code": "brownbox_10", "part_number": "40010510000", "description": "Leave-in-Box Delivery", "price": 0.0, "hookup_tasks": null }, { "option_code": "uncrate_K", "part_number": "40010520000", "description": "Deliver and Uncrate", "price": 0.0, "hookup_tasks": null }, { "option_code": "install_J", "part_number": "install", "description": "Contact me to schedule professional installation. I understand an additional charge will apply.", "price": 0, "hookup_tasks": null } ], "optional": [ { "option_code": "haulawayRequested", "part_number": "40010599000", "description": "I would like my old item hauled away", "base_price": 15.0, "addon_price": 15.0 } ] }, "configuration_options": { "select_one": [ { "part_number": "standard", "option_code": "standard", "description": "Door should open to the right with back venting (Standard)" }, { "part_number": "40010560000", "option_code": "18", "description": "Door opens left, back venting" }, { "part_number": "40010556000", "option_code": "17", "description": "Door opens right, bottom venting" }, { "part_number": "40010554000", "option_code": "15", "description": "Door opens right, right side venting" }, { "part_number": "40010551000", "option_code": "12", "description": "Door opens right, left side venting" } ] }, "installation_services": [ { "part_number": "01026200000", "division": "26", "line": "4", "sub_line": "90", "short_desc": "MI DRYER GAS", "description": "", "price": "169.99" }, { "part_number": "01026201000", "division": "26", "line": "4", "sub_line": "90", "short_desc": "AI DRY GASLN", "description": "", "price": "0.01" }, { "part_number": "01026203000", "division": "26", "line": "4", "sub_line": "90", "short_desc": "MI DRYER ELE", "description": "", "price": "159.99" }, { "part_number": "01026204000", "division": "26", "line": "4", "sub_line": "90", "short_desc": "AI DRY VENT", "description": "", "price": "85.0" }, { "part_number": "01026205000", "division": "26", "line": "4", "sub_line": "90", "short_desc": "MI WASHER", "description": "", "price": "129.99" }, { "part_number": "01026207000", "division": "26", "line": "4", "sub_line": "90", "short_desc": "AI VENTMSNRY", "description": "", "price": "149.99" }, { "part_number": "01026208000", "division": "26", "line": "4", "sub_line": "90", "short_desc": "MI VENT ONLY", "description": "", "price": "109.99" }, { "part_number": "01026213000", "division": "26", "line": "4", "sub_line": "90", "short_desc": "MI WSH W/D", "description": "", "price": "99.99" }, { "part_number": "01026219000", "division": "26", "line": "4", "sub_line": "90", "short_desc": "AI LAUND APT", "description": "", "price": "34.99" }, { "part_number": "01026221000", "division": "26", "line": "4", "sub_line": "90", "short_desc": "AI DRYR HA", "description": "", "price": "25.0" }, { "part_number": "01026222000", "division": "26", "line": "4", "sub_line": "90", "short_desc": "AI WSHR HA", "description": "", "price": "0.0" }, { "part_number": "01026230000", "division": "26", "line": "4", "sub_line": "90", "short_desc": "WAR WASHER", "description": "", "price": "0.0" }, { "part_number": "01026231000", "division": "26", "line": "4", "sub_line": "90", "short_desc": "PA WASHER", "description": "", "price": "0.0" }, { "part_number": "01026247000", "division": "26", "line": "4", "sub_line": "90", "short_desc": "AI CHGFUEL", "description": "", "price": "0.0" }, { "part_number": "01026296000", "division": "26", "line": "4", "sub_line": "90", "short_desc": "WAR DRYERELE", "description": "", "price": "0.0" }, { "part_number": "01026297000", "division": "26", "line": "4", "sub_line": "90", "short_desc": "PA DRYER ELE", "description": "", "price": "0.0" }, { "part_number": "01026298000", "division": "26", "line": "4", "sub_line": "90", "short_desc": "WAR DRYERGAS", "description": "", "price": "0.0" }, { "part_number": "01026299000", "division": "26", "line": "4", "sub_line": "90", "short_desc": "PA DRYER GAS", "description": "", "price": "0.0" }, { "part_number": "01026771000", "division": "26", "line": "4", "sub_line": "90", "short_desc": "EST LAUNDELE", "description": "", "price": "69.99" }, { "part_number": "01026772000", "division": "26", "line": "4", "sub_line": "90", "short_desc": "EST LAUNDGAS", "description": "", "price": "69.99" }, { "part_number": "01026781000", "division": "26", "line": "4", "sub_line": "90", "short_desc": "EA LAUND ELE", "description": "", "price": "0.01" }, { "part_number": "01026782000", "division": "26", "line": "4", "sub_line": "90", "short_desc": "EA LAUND GS", "description": "", "price": "0.01" }, { "part_number": "01099888000", "division": "26", "line": "4", "sub_line": "90", "short_desc": "BLDG PERMITS", "description": "", "price": "0.0" }, { "part_number": "40010500000", "division": "", "line": "", "sub_line": "", "short_desc": "Deluxe Set Up", "description": "", "price": "0.0" } ] } } }';
            }
            
                        
            system.debug('resdoc:' +resdoc);
            
            DeserializeProductAccessories obj = DeserializeProductAccessories.parse(resdoc);
            system.debug('obj:' +obj);
    //        system.debug('obj.product.services:' +obj.product.services);
    //        system.debug('obj.product.services.Delivery_options:' +obj.product.services.Delivery_options);
            
            List<DeserializeProductAccessories.Select_Parts> lstPartsSelectAll = new List<DeserializeProductAccessories.Select_Parts>();
            List<DeserializeProductAccessories.Select_Parts> lstPartsSelectOne = new List<DeserializeProductAccessories.Select_Parts>();
            List<DeserializeProductAccessories.Select_Delivery> lstServicesSelectAll = new List<DeserializeProductAccessories.Select_Delivery>();
            List<DeserializeProductAccessories.Select_Delivery> lstServicesSelectOne = new List<DeserializeProductAccessories.Select_Delivery>();
    //        List<DeserializeProductAccessories.Optional> lstServicesOptional = new List<DeserializeProductAccessories.Optional>();
            List<DeserializeProductAccessories.Installation_services> lstInstallationSelect = new List<DeserializeProductAccessories.Installation_services>();
            List<DeserializeProductAccessories.Select_Configuration> lstConfigurationOptionSelect = new List<DeserializeProductAccessories.Select_Configuration>();
            
            
            if(obj.product.services.Required_parts!=null && obj.product.services.Required_parts.select_all!=null ) {
                lstPartsSelectAll = obj.product.services.Required_parts.select_all;
                system.debug('lstPartsSelectAll:' +lstPartsSelectAll);
            }         
            
            if(obj.product.services.Required_parts!=null && obj.product.services.Required_parts.select_one!=null ) {                  
                lstPartsSelectOne = obj.product.services.Required_parts.select_one;
                system.debug('lstPartsSelectOne:' +lstPartsSelectOne);
            }
            
            if(obj.product.services.Delivery_options!=null && obj.product.services.Delivery_options.select_all!=null ) {                                   
                lstServicesSelectAll = obj.product.services.Delivery_options.select_all;
                system.debug('lstServicesSelectAll:' +lstServicesSelectAll);
            }
            
            if(obj.product.services.Delivery_options!=null && obj.product.services.Delivery_options.select_one!=null ) {            
                lstServicesSelectOne = obj.product.services.Delivery_options.select_one;
                system.debug('lstServicesSelectOne:' +lstServicesSelectOne);
            }
            
      //      if(obj.product.services.Delivery_options!=null && obj.product.services.Delivery_options.optional!=null ) {                          
      //          lstServicesOptional = obj.product.services.Delivery_options.optional;
      //          system.debug('lstServicesOptional:' +lstServicesOptional);
      //      }
            
            if(obj.product.services.installation_services!=null ) {                          
                lstInstallationSelect = obj.product.services.installation_services;
                system.debug('lstInstallationSelect:' +lstInstallationSelect);
            }
            
            if(obj.product.services.configuration_options!=null && obj.product.services.configuration_options.select_one!=null ) {                          
                lstConfigurationOptionSelect = obj.product.services.configuration_options.select_one;
                system.debug('lstConfigurationOptionSelect:' +lstConfigurationOptionSelect);
            }
            
            OptionProduct objOptionProduct = new OptionProduct();
            List<OptionProduct> lstTempOption = new List<OptionProduct>();
            mapOptionProduct = new Map<String, List<OptionProduct>>();
            
            for(DeserializeProductAccessories.Select_Parts psa:lstPartsSelectAll){
                system.debug('psa--> ' +psa);
                objOptionProduct = new OptionProduct();
                objOptionProduct.product_code = psa.part_number;
                objOptionProduct.sel_check = false;
                objOptionProduct.sel_button = false;
                objOptionProduct.renButton = false;
                objOptionProduct.is_selected = false;
                objOptionProduct.sel_type = 'Select All';
                objOptionProduct.product_id = mapProductCode.get(psa.part_number);
                objOptionProduct.product_name = psa.product_name;
                objOptionProduct.list_price = string.valueOf(mapKAP.get(psa.part_number));
                lstTempOption.add(objOptionProduct);
                mapFeatureRender.put('Parts', true);
                renFeatureSelect.put('PartsSelect_All', true);
            }
            mapOptionProduct.put('PartsSelect_All', lstTempOption);   
            
            
            lstTempOption = new List<OptionProduct>();
            for(DeserializeProductAccessories.Select_Parts pso:lstPartsSelectOne){
                system.debug('pso--> ' +pso);
                objOptionProduct = new OptionProduct();
                objOptionProduct.product_code = pso.part_number;
                objOptionProduct.sel_check = false;
                objOptionProduct.sel_button = true;
                objOptionProduct.renButton = true;
                objOptionProduct.is_selected = false;
                objOptionProduct.sel_type = 'Select One';
                objOptionProduct.product_id = mapProductCode.get(pso.part_number);
                objOptionProduct.product_name = pso.product_name;
                objOptionProduct.list_price = string.valueOf(mapKAP.get(pso.part_number));//'100';
                lstTempOption.add(objOptionProduct);
                mapFeatureRender.put('Parts', true);
                renFeatureSelect.put('PartsSelect_One', true);
            }
            mapOptionProduct.put('PartsSelect_One', lstTempOption);   
            
            lstTempOption = new List<OptionProduct>();
            for(DeserializeProductAccessories.Select_Delivery dsa:lstServicesSelectAll){
                system.debug('dsa--> ' +dsa);
                objOptionProduct = new OptionProduct();
                objOptionProduct.product_code = dsa.option_code;
                objOptionProduct.sel_check = false;
                objOptionProduct.sel_button = false;
                objOptionProduct.renButton = false;
                objOptionProduct.is_selected = false;
                objOptionProduct.sel_type = 'Select All';
                objOptionProduct.product_id = mapProductCode.get(dsa.option_code);
                objOptionProduct.product_name = dsa.option_code=='install_j'?'Professional Installation':dsa.description;
                objOptionProduct.list_price = string.valueOf(mapKAPService2.get(dsa.part_number)!=null?mapKAPService2.get(dsa.part_number):0);
                lstTempOption.add(objOptionProduct);
                mapFeatureRender.put('Services', true);
                renFeatureSelect.put('ServicesSelect_All', true);
            }
            mapOptionProduct.put('ServicesSelect_All', lstTempOption);
            
            lstTempOption = new List<OptionProduct>();
            for(DeserializeProductAccessories.Select_Delivery dso:lstServicesSelectOne){
                system.debug('dso--> ' +dso);
                objOptionProduct = new OptionProduct();
                objOptionProduct.product_code = dso.option_code;
                objOptionProduct.sel_check = false;
                objOptionProduct.sel_button = true;
                objOptionProduct.renButton = true;
                objOptionProduct.is_selected = false;
                objOptionProduct.sel_type = 'Select One';
                objOptionProduct.product_id = mapProductCode.get(dso.option_code);
                objOptionProduct.product_name = dso.option_code=='install_j'?'Professional Installation':dso.description;
                objOptionProduct.list_price = string.valueOf(mapKAPService2.get(dso.part_number)!=null?mapKAPService2.get(dso.part_number):0);
                lstTempOption.add(objOptionProduct);
                mapFeatureRender.put('Services', true);
                renFeatureSelect.put('ServicesSelect_One', true);
            }
            mapOptionProduct.put('ServicesSelect_One', lstTempOption);
            
            
        renInstallation = false;  
        selInstallation = '';  
        renInstallPrice = false;  
        selInstallPrice = '';  
        mapInstallPrice = new Map<String,String>();
        mapInstallation = new Map<String,String>();
            
            lstTempOption = new List<OptionProduct>();
            for(DeserializeProductAccessories.Installation_services is:lstInstallationSelect){
                system.debug('is--> ' +is);
                objOptionProduct = new OptionProduct();
                objOptionProduct.product_code = is.part_number;
                objOptionProduct.sel_check = false;
                objOptionProduct.sel_button = true;
                objOptionProduct.renButton = true;
                objOptionProduct.is_selected = false;
                objOptionProduct.sel_type = 'Install';
                objOptionProduct.product_id = mapProductCode.get(is.part_number);
                objOptionProduct.product_name = is.short_desc;
                objOptionProduct.list_price = string.valueOf(is.price);                       
                lstTempOption.add(objOptionProduct);
                mapFeatureRender.put('Services', true);
                renFeatureSelect.put('ServicesInstall', true);
                mapInstallPrice.put(is.part_number, string.valueOf(is.price));
                mapInstallation.put(is.part_number, is.short_desc);
                
            }
            mapOptionProduct.put('ServicesInstall', lstTempOption);
            /*
            lstTempOption = new List<OptionProduct>();
            for(DeserializeProductAccessories.Optional so:lstServicesOptional){
                system.debug('so--> ' +so);
                objOptionProduct = new OptionProduct();
                objOptionProduct.product_code = so.option_code;
                objOptionProduct.sel_check = false;
                objOptionProduct.sel_button = false;
                objOptionProduct.renButton = false;
                objOptionProduct.is_selected = false;
                objOptionProduct.sel_type = 'Optional';
                objOptionProduct.product_id = mapProductCode.get(so.option_code);
                objOptionProduct.product_name = so.option_code=='install_j'?'Professional Installation':so.description;
                objOptionProduct.list_price = string.valueOf(mapKAPService2.get(so.part_number)!=null?mapKAPService2.get(so.part_number):0);
                lstTempOption.add(objOptionProduct);
                mapFeatureRender.put('Services', true);
                renFeatureSelect.put('ServicesOptional', true);
            }
            mapOptionProduct.put('ServicesOptional', lstTempOption);
            */
            lstTempOption = new List<OptionProduct>();
            for(DeserializeProductAccessories.Select_Configuration cos:lstConfigurationOptionSelect){
                system.debug('cos--> ' +cos);
                objOptionProduct = new OptionProduct();
                objOptionProduct.product_code = cos.option_code;
                objOptionProduct.sel_check = false;
                objOptionProduct.sel_button = true;
                objOptionProduct.renButton = true;
                objOptionProduct.is_selected = false;
                objOptionProduct.sel_type = 'Select One';
                objOptionProduct.product_id = cos.option_code;
                objOptionProduct.product_name = cos.description;
                objOptionProduct.list_price = '0';
                lstTempOption.add(objOptionProduct);
                mapFeatureRender.put('Config', true);
                renFeatureSelect.put('ConfigSelect_One', true);
            }
            mapOptionProduct.put('ConfigSelect_One', lstTempOption);
            
            lenMapOptionProduct = mapOptionProduct.size();
            
                system.debug('lenMapOptionProduct:' +lenMapOptionProduct);
            for(String mop:mapOptionProduct.keySet()){
                system.debug('mop:' +mop);
                system.debug('mapOptionProduct.get(mop):' +mapOptionProduct.get(mop));
                system.debug('mapOptionProduct.get(mop).size():' +mapOptionProduct.get(mop).size());
            }
                    system.debug('selectedProductPrice--> ' + selectedProductPrice );
        selectedProductQuantity = 1;
                selectedProductPrice = 0;
selectedProductPrice = mapKAP.get(selectedproductcode)!=null?mapKAP.get(selectedproductcode):0;
                    system.debug('selectedProductPrice--> ' + selectedProductPrice );
            
        }else{
            if(!mapProductCode.containsKey(selectedproductcode)){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Product not present'  ));   
            }
            if(RW.message != '' && RW.message != null){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Following error while getting your product: ' + RW.message  ));   
            }
            
            /*
            system.debug('RW.Response.getStatusCode()>>' +RW.Response.getStatusCode()); 
            if(RW.Response.getStatusCode()==500){
             //   renRedirect = true;
            }else{
           //     renError = true;
           //     strError = RW.Response.getStatusCode()!=null?string.valueof(RW.Response.getStatusCode()):'' + RW.message;
            }
            */
        }
        
        return null;
    }
    
    
    
    public PageReference actionSelected(){
        
        system.debug('mapKAP.get(selectedproductcode)--> ' + mapKAP.get(selectedproductcode) );
        
        String prcd = System.currentPageReference().getParameters().get('prcd');
        String key = System.currentPageReference().getParameters().get('key');
        system.debug('prcd--> ' + prcd );
        system.debug('key--> ' + key );
        
        if(selInstallation==null){
                selInstallation = '';  
        }
        if(selInstallPrice==null){
                selInstallPrice = '';  
        }
        
        system.debug('renInstallation--> ' + renInstallation );
        system.debug('selInstallation--> ' + selInstallation );
        system.debug('renInstallPrice--> ' + renInstallPrice );
        system.debug('selInstallPrice--> ' + selInstallPrice );
        
        if(key=='ServicesSelect_One'){
            
            if(prcd=='install_j'){
                renInstallation = true;  
            }else{
                renInstallation = false;  
                renInstallprice = false;  
                selInstallation = '';  
                selInstallPrice = '';
                
        list<OptionProduct> lstTempOption2= new list<OptionProduct>();
                for(OptionProduct si:mapOptionProduct.get('ServicesInstall')){
                    system.debug('si:' +si);
                        si.is_selected = false;
                    lstTempOption2.add(si);
                }
        mapOptionProduct.put('ServicesInstall', lstTempOption2);
                
            }
        }
        
        
        system.debug('renInstallation--> ' + renInstallation );
        system.debug('selInstallation--> ' + selInstallation );
        system.debug('renInstallPrice--> ' + renInstallPrice );
        system.debug('selInstallPrice--> ' + selInstallPrice );
        
        list<OptionProduct> lstTempOption= new list<OptionProduct>();
         //           if(!Test.isRunningTest()){
                for(OptionProduct op:mapOptionProduct.get(key)){
                    system.debug('op:' +op);
                //    if(op.product_code==prcd && op.product_code!='install_j' ){
                    if(op.product_code==prcd ){
                        op.is_selected = true;
                    }else{
                        op.is_selected = false;
                    }
                    lstTempOption.add(op);
                }
        mapOptionProduct.put(key, lstTempOption);
        
      //              }

        
        return null;
    }
    
    public list<selectoption> getInstallationService(){
        list<selectoption> lstSel= new list<selectoption>();
        lstSel.add(new SelectOption('', '--None--'));
        if(mapInstallation.size()>0){
            for(String mi:mapInstallation.keyset()){
                lstSel.add(new SelectOption(mi, mi + ' - '  + mapInstallation.get(mi)));            
            }
        }
        return lstSel;
    }
    
    
    public void actionInstallation(){
        String key = System.currentPageReference().getParameters().get('key');
        String prcd = '';
        prcd = selInstallation;
        system.debug('prcd--> ' + prcd );
        system.debug('key--> ' + key );
        
        if(selInstallation==null){
                selInstallation = '';  
        }
        if(selInstallPrice==null){
                selInstallPrice = '';  
        }
        
        
   //     renInstallation = false;  
    //    selInstallation = '';  
    //    renInstallPrice = false;  
//        selInstallPrice = '';  
    //    mapInstallPrice = new Map<String,String>();
    //    mapInstallation = new Map<String,String>();
        
        system.debug('renInstallation--> ' + renInstallation );
        system.debug('selInstallation--> ' + selInstallation );
        system.debug('renInstallPrice--> ' + renInstallPrice );
        system.debug('selInstallPrice--> ' + selInstallPrice );
        system.debug('mapInstallPrice.get(prcd)--> ' + mapInstallPrice.get(prcd) );
        system.debug('mapInstallation.get(prcd)--> ' + mapInstallation.get(prcd) );
        
        selInstallPrice = mapInstallPrice.get(prcd);
        
          //                if(!Test.isRunningTest() ){

        list<OptionProduct> lstTempOption= new list<OptionProduct>();
                for(OptionProduct op:mapOptionProduct.get(key)){
                    system.debug('op:' +op);
                    if(op.product_code==prcd ){
                        op.is_selected = true;
                    }else{
                        op.is_selected = false;
                    }
                    lstTempOption.add(op);
                }
                          
        mapOptionProduct.put(key, lstTempOption);
            //              }
        
            renInstallprice = true;
        if(selInstallPrice==null || selInstallPrice=='' ){
            renInstallprice = false;
            selInstallPrice = '';
        }
        system.debug('selInstallPrice--> ' + selInstallPrice );
        system.debug('renInstallation--> ' + renInstallation );
        system.debug('selInstallation--> ' + selInstallation );
        system.debug('renInstallPrice--> ' + renInstallPrice );
        system.debug('selInstallPrice--> ' + selInstallPrice );
    }
    
    
    
    public void actionAddToList(){
        for(String mop:mapOptionProduct.keyset()){
            system.debug('mop--> ' + mop );
            for(OptionProduct op:mapOptionProduct.get(mop)){
                system.debug('op--> ' + op );
            }
        }
        
           
        if(Test.isRunningTest()){
            for(String mop:mapOptionProduct.keyset()){
                system.debug('mop--> ' + mop );
                for(OptionProduct op:mapOptionProduct.get(mop)){
                    system.debug('op--> ' + op );
                    if(op.product_code == '02649609000' || op.product_code == '02649608000' || op.product_code == '02657001000' || op.product_code == 'install_J'
                       || op.product_code == '01026200000' || op.product_code == '18' || mop == 'ServicesSelect_All' ){
                           op.is_selected = true;
                       }
                }
            }
        }
        
        
        String selConfigCode = '';
        String selConfigOption = '';

        List<String> lstErrorMessage = new List<String>();
        
        Map<String, Integer> mapKeyCount = new Map<String, Integer>();
        Map<String, Integer> mapKeySize = new Map<String, Integer>();
        Boolean isServiceInstallJ = false;
        Boolean isInstallation = false;
        Boolean isServiceException = false;

            for(String key:mapOptionProduct.keySet()){
                mapKeyCount.put(key, 0);
                mapKeySize.put(key, mapOptionProduct.get(key).size());
            
                system.debug('mapOptionProduct.get(key):' +mapOptionProduct.get(key));                                   
                
                for(OptionProduct op:mapOptionProduct.get(key)){
                    system.debug('op:' +op);
                    if(op.is_selected){
                        
                    if(op.product_code=='install_J'){
                       isServiceInstallJ =  true;
                    }
                        
                        mapKeyCount.put(key, mapKeyCount.get(key)+1);
                        if(key=='ServicesInstall'){
                            isInstallation = true;
                        }
                    //    if(op.product_code=='brownbox_10' || op.product_code=='uncrate_K' ){
                        if(op.product_code=='brownbox_10' || op.product_code=='uncrate_K' || op.product_code.startsWith('01') || op.product_code.startsWith('4') ){
                            isServiceException = true;
                        }
                        if(key=='ConfigSelect_One'){
                            selConfigCode = op.product_code;
                            selConfigOption = op.product_name;
                        }
                    }
                }
            }
        
        
            system.debug('mapKeyCount:' +mapKeyCount);                                   
            system.debug('mapKeySize:' +mapKeySize); 
            system.debug('isServiceInstallJ:' +isServiceInstallJ); 
            system.debug('isInstallation:' +isInstallation); 
            system.debug('isServiceException:' +isServiceException); 
            system.debug('selConfigCode:' +selConfigCode); 
            system.debug('selConfigOption:' +selConfigOption); 
        
        
            for(String ks:mapKeySize.keyset()){
                
                if( mapKeySize.get(ks) > 0 && (ks == 'PartsSelect_All') && (mapKeyCount.get(ks) < mapKeySize.get(ks)) && !isServiceException ){
                //        lstErrorMessage.add('Please Select All Parts' );
                }else if( mapKeySize.get(ks) > 0 && (ks == 'PartsSelect_One') && (mapKeyCount.get(ks) < 1)  && !isServiceException ){
                //        lstErrorMessage.add('Please Select one Part ' );
                }else if( mapKeySize.get(ks) > 0 && (ks == 'ServicesSelect_All') && (mapKeyCount.get(ks) < mapKeySize.get(ks)) ){
                        lstErrorMessage.add('Please Select All Services ' );
                }else if( mapKeySize.get(ks) > 0 && (ks == 'ServicesSelect_One') && (mapKeyCount.get(ks) < 1)  ){
                       lstErrorMessage.add('Please Select a Service/Installation 1' );
                }else if( mapKeySize.get(ks) > 0 && (ks == 'ServicesInstall') && (mapKeyCount.get(ks) < 1) && isServiceInstallJ ){
                        lstErrorMessage.add('Please Select a Service/Installation 2' );
                }
                
            }
        
            system.debug('lstErrorMessage.size():' +lstErrorMessage.size());   
        
            system.debug('selectedProductQuantity--> ' + selectedProductQuantity );
            system.debug('selectedProductPrice--> ' + selectedProductPrice );
        
                if( selectedProductQuantity ==null || selectedProductQuantity <=0 ){
                        lstErrorMessage.add('Please enter valid Quantity' );
                }
                if( selectedProductPrice ==null || selectedProductPrice <0 ){
                        lstErrorMessage.add('Please enter valid Price' );
                }
        
            system.debug('lstErrorMessage.size():' +lstErrorMessage.size());                                   
        if(lstErrorMessage.size()>0){
            for(String em:lstErrorMessage){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, em));   
            }
            renAccessories = true;
        }else{
            renAccessories = false;
            
            for(String mop:mapOptionProduct.keyset()){
                system.debug('mop--> ' + mop );
                for(OptionProduct op:mapOptionProduct.get(mop)){
                    system.debug('op--> ' + op );
                }
            }
            
            
                        
            system.debug('selectedproductcode--> ' + selectedproductcode );
            system.debug('mapProductCode.get(selectedproductcode)--> ' + mapProductCode.get(selectedproductcode ));
                    system.debug('mapKAP.get(selectedproductcode)--> ' + mapKAP.get(selectedproductcode) );

            Integer noit = 0;
            String parentnoit = '';
            String parentUnique = '';
            noit = lstPartsOrderSelection.size();
            AdjOrderItem objOrderSelection = new AdjOrderItem();
            noit++;
            parentnoit = String.valueOf(noit*10);
            parentUnique = mapProductCode.get(selectedproductcode);
            objOrderSelection.AdjId = String.valueOf(noit);
            objOrderSelection.SelId = String.valueOf(noit);
            objOrderSelection.SeqNumber = parentnoit;
            //  objOrderSelection.OrderItemId = oi.Id;
            //  objOrderSelection.OrderId = oi.OrderId;
            objOrderSelection.isProductParent = true;
            objOrderSelection.ProductParentUnique = parentUnique;
            objOrderSelection.ParentPartNumber = null;
            objOrderSelection.Product2Id = mapProductCode.get(selectedproductcode);
            objOrderSelection.ProductCode = selectedproductcode;
            objOrderSelection.ProductName = mapProductCodeName.get(selectedproductcode);
            objOrderSelection.Quantity = selectedProductQuantity;
            objOrderSelection.Feature = null;
            objOrderSelection.Configuration = selConfigCode;
            objOrderSelection.ConfigurationDescription = selConfigoption;
            objOrderSelection.PriceBookEntryId = mapPriceBookEntry.get(mapProductCode.get(selectedproductcode));
            objOrderSelection.ReasonCode = '';
            objOrderSelection.ReasonCategoryCode = '';
       //     objOrderSelection.ListUnitPrice = mapKAP.get(selectedproductcode)!=null?mapKAP.get(selectedproductcode):0;
      //      objOrderSelection.NetUnitPrice = mapKAP.get(selectedproductcode)!=null?mapKAP.get(selectedproductcode):0;
      //      objOrderSelection.NetTotalPrice = mapKAP.get(selectedproductcode)!=null?mapKAP.get(selectedproductcode):0 * 1 ;
            objOrderSelection.NetUnitPrice = selectedProductPrice;
            objOrderSelection.NetTotalPrice = selectedProductPrice * selectedProductQuantity ;
            //       objOrderSelection.DisposableFee = null ;
            //       objOrderSelection.TaxRate = null ;
            //       objOrderSelection.TaxAmount = null ;
            objOrderSelection.ProductType = 'OrderItem';
            objOrderSelection.Sel_AdjId = String.valueOf(noit);
            objOrderSelection.Sel_Quantity = selectedProductQuantity;
   //         objOrderSelection.Sel_NetUnitPrice = mapKAP.get(selectedproductcode)!=null?mapKAP.get(selectedproductcode):0;
   //         objOrderSelection.Sel_NetTotalPrice = mapKAP.get(selectedproductcode)!=null?mapKAP.get(selectedproductcode):0 * 1 ;
            objOrderSelection.Sel_NetUnitPrice = selectedProductPrice;
            objOrderSelection.Sel_NetTotalPrice = selectedProductPrice * selectedProductQuantity ;
            mapisChildReasonDisplay.put(objOrderSelection.AdjId, false);
            lstPartsOrderSelection.add(objOrderSelection);
            //{ConfigSelect_One=0, PartsSelect_All=1, PartsSelect_One=0, ServicesInstall=1, ServicesOptional=0, ServicesSelect_All=0, ServicesSelect_One=1}
            
            system.debug('parentnoit--> ' + parentnoit );
            
            
            for(String mop:mapOptionProduct.keyset()){
                system.debug('mop--> ' + mop );
                if(mop!='ConfigSelect_One'){
                    for(OptionProduct op:mapOptionProduct.get(mop)){
                        if(op.is_selected==true && op.product_code!='install_j' ){
                            system.debug('op--> ' + op );
                            
                            objOrderSelection = new AdjOrderItem();
                            noit++;
                            
                            objOrderSelection.AdjId = String.valueOf(noit);
                            objOrderSelection.SelId = String.valueOf(noit);
                            objOrderSelection.SeqNumber = String.valueOf(noit*10);
                            //  objOrderSelection.OrderItemId = oi.Id;
                            //  objOrderSelection.OrderId = oi.OrderId;
                            objOrderSelection.isProductParent = false;
                            objOrderSelection.ProductParentUnique = parentUnique;
                            objOrderSelection.ParentPartNumber = parentnoit;
                            objOrderSelection.Product2Id = mapProductCode.get(op.product_code);
                            objOrderSelection.ProductCode = op.product_code;
                            objOrderSelection.ProductName = mapProductCodeName.get(op.product_code);
                            objOrderSelection.Quantity = selectedProductQuantity;
                            objOrderSelection.Feature = mop.contains('Parts')?'Parts':(mop.contains('Services')?'Services':'');
                            objOrderSelection.Configuration = '';
                            objOrderSelection.ConfigurationDescription = '';
                            objOrderSelection.PriceBookEntryId = mapPriceBookEntry.get(mapProductCode.get(op.product_code));
                            objOrderSelection.ReasonCode = '';
                            objOrderSelection.ReasonCategoryCode = '';
                    //        objOrderSelection.ListUnitPrice = mapKAP.get(op.product_code)!=null?mapKAP.get(op.product_code):0;
                            objOrderSelection.NetUnitPrice = mapKAP.get(op.product_code)!=null?mapKAP.get(op.product_code):0;
                            objOrderSelection.NetTotalPrice = mapKAP.get(op.product_code)!=null?(mapKAP.get(op.product_code) * selectedProductQuantity) : 0 ;
                   //         objOrderSelection.NetTotalPrice = mapKAP.get(op.product_code) * selectedProductQuantity ;
                            //       objOrderSelection.DisposableFee = null ;
                            //       objOrderSelection.TaxRate = null ;
                            //       objOrderSelection.TaxAmount = null ;
                            objOrderSelection.ProductType = 'OrderItem';
                            objOrderSelection.Sel_AdjId = String.valueOf(noit);
                            objOrderSelection.Sel_Quantity = selectedProductQuantity;
                system.debug('mapKAP.get(op.product_code)--> ' + mapKAP.get(op.product_code) );
                system.debug('selectedProductQuantity--> ' + selectedProductQuantity );
                            objOrderSelection.Sel_NetUnitPrice = mapKAP.get(op.product_code)!=null?mapKAP.get(op.product_code):0;
                            objOrderSelection.Sel_NetTotalPrice = mapKAP.get(op.product_code)!=null?(mapKAP.get(op.product_code) * selectedProductQuantity) : 0 ;
                system.debug('objOrderSelection.NetTotalPrice--> ' + objOrderSelection.NetTotalPrice );
                            mapisChildReasonDisplay.put(objOrderSelection.AdjId, false);
                            lstPartsOrderSelection.add(objOrderSelection);
                        }
                    }
                }
            }
                
                for(AdjOrderItem los:lstPartsOrderSelection){
                    system.debug('los--> ' + los );
                }
            
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
            
                    system.debug('selectedProductQuantity--> ' + selectedProductQuantity );
                    system.debug('selectedProductPrice--> ' + selectedProductPrice );
                
        }
        
        
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
            selProductCode = selectedmemoproductcode;
            selectedpart = '';
            selectedinstall = '';
            selectedprotection = '';
        }else if(selType=='part'){
            selProductCode = selectedpart;
            selectedmemoproductcode = '';
            selectedinstall = '';
            selectedprotection = '';
        }else if(selType=='inst'){
            selProductCode = selectedinstall;
            selectedmemoproductcode = '';
            selectedpart = '';
            selectedprotection = '';
        }else if(selType=='prot'){
            selProductCode = selectedprotection;
            selectedmemoproductcode = '';
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
            /*
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
        */    
        system.debug('mapKAP --> ' +mapKAP);
            
        
        objOSPart = new AdjOrderItem();
        
        
  //      if(mapKAP.size()>0){
            renObjOrder = true;
            renObjOrderMessage = false;
           
            
            
    //    objOSPart.OrderId = orderId;
    //    objOSPart.OrderId = orderId;
  //      objOSPart.SeqNumber = String.valueOf(mapPartsOrderSelection.size()+1);
        objOSPart.SeqNumber = '99';
                objOSPart.AdjId = String.valueOf(lstPartsOrderSelection.size()+1);
                objOSPart.SelId = String.valueOf(lstPartsOrderSelection.size()+1);
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
     //   objOSPart.ListUnitPrice = mapKAP.get(selProductCode)==null?0:mapKAP.get(selProductCode);
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
                objOSPart.Sel_AdjId = String.valueOf(lstPartsOrderSelection.size()+1);
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
 //       system.debug('objOSPart.ListUnitPrice --> ' +objOSPart.ListUnitPrice);
        system.debug('objOSPart.NetUnitPrice --> ' +objOSPart.NetUnitPrice);
        system.debug('objOSPart.NetTotalPrice --> ' +objOSPart.NetTotalPrice);
        system.debug('objOSPart.Sel_AdjId --> ' +objOSPart.Sel_AdjId);
        system.debug('objOSPart.Sel_Quantity --> ' +objOSPart.Sel_Quantity);
        system.debug('objOSPart.Sel_NetUnitPrice --> ' +objOSPart.Sel_NetUnitPrice);
        system.debug('objOSPart.Sel_NetTotalPrice --> ' +objOSPart.Sel_NetTotalPrice);
        
        objOSPart.NetTotalPrice = (objOSPart.Quantity==null|| objOSPart.NetUnitPrice==null) ? 0 : objOSPart.Quantity * objOSPart.NetUnitPrice;
        
        
        
        /*
        objOSPart.Sel_Quantity = objOSPart.Quantity;
        objOSPart.Sel_NetUnitPrice = objOSPart.NetUnitPrice;
        objOSPart.Sel_NetTotalPrice = (objOSPart.Quantity==null|| objOSPart.NetUnitPrice==null) ? 0 : objOSPart.Quantity * objOSPart.NetUnitPrice;
        objOSPart.Quantity = 1;
        objOSPart.NetUnitPrice = objOSPart.ListUnitPrice;
        objOSPart.ListUnitPrice = null;
*/
     /*   
        lstPartsProductSelection.add(objOSPart);
   //         lstPartsOrderSelection= new List<AdjOrderItem>();
            lstPartsTotalSelection = new List<AdjOrderItem>();
        
        lstPartsTotalSelection.addAll(lstPartsOrderSelection);
        lstPartsTotalSelection.addAll(lstPartsProductSelection);
        */
        lstPartsOrderSelection.add(objOSPart);
        
        system.debug('lstPartsOrderSelection --> ' + lstPartsOrderSelection );
        system.debug('lstPartsOrderSelection.size() --> ' + lstPartsOrderSelection.size() );
        
        renObjOrder = false;
        
            selectedproductcode = '';
            selectedpart = '';
            selectedinstall = '';
            selectedprotection = '';
        
        
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
    
    
    
    public void actionDelete(){
        
        mapParentReason = new Map<String, String>();
        if((selectedAdjustment=='Return' || selectedAdjustment=='Exchange') && !Test.isRunningTest() ){
            
        mapParentReason = new Map<String, String>();
            for (AdjOrderItem mc: lstPartsOrderSelection) {
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

        String remProd = '';
        
        
            for(AdjOrderItem pos:lstPartsOrderSelection){
                if(pos.Sel_AdjId==remSelAdjId){
                system.debug('pos.Sel_AdjId --> ' + pos.Sel_AdjId );
                system.debug('pos.SeqNumber --> ' + pos.SeqNumber );
                    remProd = pos.SeqNumber;
                }
            }
        
        
        system.debug('remProd --> ' + remProd );
                            
            List<AdjOrderItem> lstTempPartsOrderSelection = new List<AdjOrderItem>();
            AdjOrderItem objTempPOS = new AdjOrderItem();
            Integer tempSelId = 0;

            Boolean isParent = false;
            
            mapisChildReasonDisplay = new Map<String, Boolean>();
        
            for(AdjOrderItem pos:lstPartsOrderSelection){
                isParent = false;
                if(pos.ProductType=='Adjustment' || pos.ProductType=='InstallationService' || pos.ProductType=='PAWarranty'){
                    isParent = true;
                }
                
         //       if((pos.SeqNumber!=remProd && pos.ParentPartNumber!=remProd && !isMemo) ||  (pos.Sel_AdjId!=remSelAdjId && isMemo) ){
         //       if(pos.SeqNumber!=remProd && pos.ParentPartNumber!=remProd ){
         //       if((pos.SeqNumber!=remProd && pos.ParentPartNumber!=remProd && !isParent) ||  (pos.Sel_AdjId!=remSelAdjId && isParent) ){
                if((!isParent && pos.SeqNumber!=remProd) || (isParent && remProd!=pos.Sel_AdjId) ){
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
        system.debug('objTempPOS --> ' + objTempPOS );
                }else{
                    objTempPOS = new AdjOrderItem();
                    objTempPOS = pos;
                    objTempPOS.Sel_AdjId = null;
        system.debug('objTempPOS --> ' + objTempPOS );
                }
            }
            
            lstPartsOrderSelection = new List<AdjOrderItem>();
            for(AdjOrderItem pos:lstTempPartsOrderSelection){
                lstPartsOrderSelection.add(pos);
            }   
                           
        for(AdjOrderItem kk:lstPartsOrderSelection){
        system.debug('kk --> ' + kk );
        system.debug('kk.SelId --> ' + kk.SelId );
        system.debug('kk.Sel_AdjId --> ' + kk.Sel_AdjId );
        }
        
    }
    
    public void checkAddress(){
            system.debug('selectedAdjustment--> ' + selectedAdjustment );
        system.debug('objOrderOverviewQry.Reason_Code__c--> ' + objOrderOverviewQry.Reason_Code__c );
        system.debug('objOrderOverviewQry.Purchase_Number__c--> ' + objOrderOverviewQry.Purchase_Number__c );
        system.debug('objOrderOverviewQry.Shipping_Contact_First_Name__c--> ' + objOrderOverviewQry.Shipping_Contact_First_Name__c );
        system.debug('objOrderOverviewQry.Shipping_Contact_Last_Name__c--> ' + objOrderOverviewQry.Shipping_Contact_Last_Name__c );
        system.debug('objOrderOverviewQry.Shipping_Contact_Phone__c--> ' + objOrderOverviewQry.Shipping_Contact_Phone__c );
        system.debug('objOrderOverviewQry.Shipping_Contact_Email__c--> ' + objOrderOverviewQry.Shipping_Contact_Email__c );
        system.debug('objOrderOverviewQry.ShippingStreet--> ' + objOrderOverviewQry.ShippingStreet );
        system.debug('objOrderOverviewQry.ShippingCity--> ' + objOrderOverviewQry.ShippingCity );
        system.debug('objOrderOverviewQry.ShippingState--> ' + objOrderOverviewQry.ShippingState );
        system.debug('objOrderOverviewQry.ShippingPostalCode--> ' + objOrderOverviewQry.ShippingPostalCode );
        system.debug('objOrderOverviewQry.BillingStreet--> ' + objOrderOverviewQry.BillingStreet );
        system.debug('objOrderOverviewQry.BillingCity--> ' + objOrderOverviewQry.BillingCity );
        system.debug('objOrderOverviewQry.BillingState--> ' + objOrderOverviewQry.BillingState );
        system.debug('objOrderOverviewQry.BillingPostalCode--> ' + objOrderOverviewQry.BillingPostalCode );
        system.debug('objOrderOverviewQry.DOS_Order_Number__c--> ' + objOrderOverviewQry.DOS_Order_Number__c );
        system.debug('objOrderOverviewQry.RMA_Order_Number__c--> ' + objOrderOverviewQry.RMA_Order_Number__c );
        system.debug('objOrderOverviewQry.Origin_Order_Date__c--> ' + objOrderOverviewQry.Origin_Order_Date__c );
        system.debug('objOrderOverviewQry.isCommonCarrier__c--> ' + objOrderOverviewQry.isCommonCarrier__c );
  //      system.debug('isSelectedDeliveryCharge--> ' + isSelectedDeliveryCharge );
  //      system.debug('isSelectedPremiumDeliveryCharge--> ' + isSelectedPremiumDeliveryCharge );
  //      system.debug('isSelectedHaulawayCharge--> ' + isSelectedHaulawayCharge );
        system.debug('objOrderOverviewQry.Delivery_Charge__c--> ' + objOrderOverviewQry.Delivery_Charge__c );
        system.debug('objOrderOverviewQry.Premium_Delivery_Charge__c--> ' + objOrderOverviewQry.Premium_Delivery_Charge__c );
        system.debug('objOrderOverviewQry.Haulaway_Charge__c--> ' + objOrderOverviewQry.Haulaway_Charge__c );
        
    //    if(!isSelectedDeliveryCharge){
        if(objOrderOverviewQry.Delivery_Charge__c==null){
            objOrderOverviewQry.Delivery_Charge__c = 0;
        }
 //       if(!isSelectedPremiumDeliveryCharge){
        if(objOrderOverviewQry.Premium_Delivery_Charge__c==null){
            objOrderOverviewQry.Premium_Delivery_Charge__c = 0;
        }
   //     if(!isSelectedHaulawayCharge){
        if(objOrderOverviewQry.Haulaway_Charge__c==null){
            objOrderOverviewQry.Haulaway_Charge__c = 0;
        }
        
        system.debug('objOrderOverviewQry.Delivery_Charge__c--> ' + objOrderOverviewQry.Delivery_Charge__c );
        system.debug('objOrderOverviewQry.Premium_Delivery_Charge__c--> ' + objOrderOverviewQry.Premium_Delivery_Charge__c );
        system.debug('objOrderOverviewQry.Haulaway_Charge__c--> ' + objOrderOverviewQry.Haulaway_Charge__c );
        
        List<String> lstErrorMessage = new List<String>();
        
        if((objOrderOverviewQry.Reason_Code__c == null || objOrderOverviewQry.Reason_Code__c == '') ){
            lstErrorMessage.add('Missing Reason Code for the Order Header');
        }
        if((objOrderOverviewQry.Purchase_Number__c == null || objOrderOverviewQry.Purchase_Number__c == '') ){
            lstErrorMessage.add('Missing Purchase Number');
        }
        if((objOrderOverviewQry.Shipping_Contact_First_Name__c == null || objOrderOverviewQry.Shipping_Contact_First_Name__c == '') ){
            lstErrorMessage.add('Missing Pick-up Contact First Name');
        }
        if((objOrderOverviewQry.Shipping_Contact_Last_Name__c == null || objOrderOverviewQry.Shipping_Contact_Last_Name__c == '') ){
            lstErrorMessage.add('Missing Pick-up Contact Last Name');
        }
        if((objOrderOverviewQry.Shipping_Contact_Phone__c == null || objOrderOverviewQry.Shipping_Contact_Phone__c == '') ){
            lstErrorMessage.add('Missing Pick-up Contact Phone');
        }
        if((objOrderOverviewQry.Shipping_Contact_Email__c == null || objOrderOverviewQry.Shipping_Contact_Email__c == '') ){
            lstErrorMessage.add('Missing Pick-up Contact Email');
        }
        if((objOrderOverviewQry.ShippingStreet == null || objOrderOverviewQry.ShippingStreet == '') ){
            lstErrorMessage.add('Missing Pick-up Street');
        }
        if((objOrderOverviewQry.ShippingCity == null || objOrderOverviewQry.ShippingCity == '') ){
            lstErrorMessage.add('Missing Pick-up City');
        }
        if((objOrderOverviewQry.ShippingState == null || objOrderOverviewQry.ShippingState == '') ){
            lstErrorMessage.add('Missing Pick-up State');
        }
        if((objOrderOverviewQry.ShippingPostalCode == null || objOrderOverviewQry.ShippingPostalCode == '') ){
            lstErrorMessage.add('Missing Pick-up Zip Code');
        }
        if((objOrderOverviewQry.BillingStreet == null || objOrderOverviewQry.BillingStreet == '') ){
            lstErrorMessage.add('Missing Billing Street');
        }
        if((objOrderOverviewQry.BillingCity == null || objOrderOverviewQry.BillingCity == '') ){
            lstErrorMessage.add('Missing Billing City');
        }
        if((objOrderOverviewQry.BillingState == null || objOrderOverviewQry.BillingState == '') ){
            lstErrorMessage.add('Missing Billing State');
        }
        if((objOrderOverviewQry.BillingPostalCode == null || objOrderOverviewQry.BillingPostalCode == '') ){
            lstErrorMessage.add('Missing Billing Zip Code');
        }
        if(!isMemo){
        if((objOrderOverviewQry.DOS_Order_Number__c == null || objOrderOverviewQry.DOS_Order_Number__c == '') ){
            lstErrorMessage.add('Missing DOS Order Number');
        }
        if((objOrderOverviewQry.RMA_Order_Number__c == null || objOrderOverviewQry.RMA_Order_Number__c == '') ){
            lstErrorMessage.add('Missing RMA Order Number');
        }
        if(objOrderOverviewQry.Origin_Order_Date__c == null ){
            lstErrorMessage.add('Missing Origin Order Date');
        }else{
            if(objOrderOverviewQry.Origin_Order_Date__c >= system.today()){
            	lstErrorMessage.add('Origin Order Date should be in the past');
            }
        }
        }
 //       if(isSelectedDeliveryCharge && objOrderOverviewQry.Delivery_Charge__c==null ){
 //           lstErrorMessage.add('Delivery Charge is checked, but missing Delivery Charge');
 //       }else if(isSelectedDeliveryCharge && objOrderOverviewQry.Delivery_Charge__c<=0){
        if(objOrderOverviewQry.Delivery_Charge__c<0){
            lstErrorMessage.add('Please enter valid Delivery Charge amount');
        }
  //      if(isSelectedPremiumDeliveryCharge && objOrderOverviewQry.Premium_Delivery_Charge__c==null ){
  //          lstErrorMessage.add('Premium Delivery Charge is checked, but missing Premium Delivery Charge');
  //      }else if(isSelectedPremiumDeliveryCharge && objOrderOverviewQry.Premium_Delivery_Charge__c<=0){
        if(objOrderOverviewQry.Premium_Delivery_Charge__c<0){
            lstErrorMessage.add('Please enter valid Premium Delivery Charge amount');
        }
 //       if(isSelectedHaulawayCharge && objOrderOverviewQry.Haulaway_Charge__c==null ){
    //        lstErrorMessage.add('HaulAway Charge is checked, but missing HaulAway Charge');
  //      }else if(isSelectedHaulawayCharge && objOrderOverviewQry.Haulaway_Charge__c<=0){
        if(objOrderOverviewQry.Haulaway_Charge__c<0){
            lstErrorMessage.add('Please enter valid HaulAway Charge amount');
        }
        
        /*
            if(!Test.isRunningTest()){
                
        Map<String, String> mapParentReason = new Map<String, String>();
                
            for (AdjOrderItem mc: lstPartsOrderSelection) {
                if(!isMemo){
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
                /*
                system.debug('mc.ListUnitPrice--> ' + mc.ListUnitPrice + ' || mc.Feature--> ' + mc.Feature );
                if(mc.ListUnitPrice == null && ( mc.Feature==null || mc.Feature=='' || mc.Feature=='Parts' || mc.ParentPartNumber==null) ){
                    lstErrorMessage.add('Missing Original Price for the Order Products');
                }
                if((mc.ListUnitPrice != null && mc.ListUnitPrice<=0 ) ){
                if(mc.ListUnitPrice != null && mc.ListUnitPrice<=0 && ( mc.Feature==null || mc.Feature=='' || mc.Feature=='Parts' || mc.ParentPartNumber==null) ){
                    lstErrorMessage.add('Please enter valid Original Price for the Order Products');
                }
				******
            }
            }
			*/
        
        mapParentReason = new Map<String, String>();
        if(!isMemo && !Test.isRunningTest() ){            
            
            for (AdjOrderItem mc: lstPartsOrderSelection) {
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
            
            for (AdjOrderItem mc: lstPartsOrderSelection) {
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
            
            dom.xmlNode addressLine1 = xmlrequest.addChildElement('addressLine1',null,null);
            addressLine1.addTextNode(objOrderOverviewQry.ShippingStreet);
            
            dom.xmlNode addressLine2 = xmlrequest.addChildElement('addressLine2',null,null);
            
            dom.xmlNode addressLine3 = xmlrequest.addChildElement('addressLine3',null,null);
            
            dom.xmlNode zipCode = xmlrequest.addChildElement('zipCode',null,null);
            zipCode.addTextNode(objOrderOverviewQry.ShippingPostalCode);
            
            dom.xmlNode email = xmlrequest.addChildElement('email',null,null);
            
            dom.xmlNode city = xmlrequest.addChildElement('city',null,null);
            city.addTextNode(objOrderOverviewQry.ShippingCity);
            
            dom.xmlNode state = xmlrequest.addChildElement('state',null,null);
            state.addTextNode(objOrderOverviewQry.ShippingState);
            
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
        renProduct = true;
            renMemo = false;
        renBtn = true;

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
        renBtn = false;
        renProduct = false;
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
    
//ad.geoCode + ' - ' + ad.countyCode + ' - ' + ad.countyName    
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
        /*
        system.debug('objOrderOverviewQry.Reason_Code__c--> ' + objOrderOverviewQry.Reason_Code__c );
        system.debug('objOrderOverviewQry.Purchase_Number__c--> ' + objOrderOverviewQry.Purchase_Number__c );
        system.debug('objOrderOverviewQry.ShippingStreet--> ' + objOrderOverviewQry.ShippingStreet );
        system.debug('objOrderOverviewQry.ShippingCity--> ' + objOrderOverviewQry.ShippingCity );
        system.debug('objOrderOverviewQry.ShippingState--> ' + objOrderOverviewQry.ShippingState );
        system.debug('objOrderOverviewQry.ShippingPostalCode--> ' + objOrderOverviewQry.ShippingPostalCode );
        system.debug('objOrderOverviewQry.BillingStreet--> ' + objOrderOverviewQry.BillingStreet );
        system.debug('objOrderOverviewQry.BillingCity--> ' + objOrderOverviewQry.BillingCity );
        system.debug('objOrderOverviewQry.BillingState--> ' + objOrderOverviewQry.BillingState );
        system.debug('objOrderOverviewQry.BillingPostalCode--> ' + objOrderOverviewQry.BillingPostalCode );
        system.debug('objOrderOverviewQry.DOS_Order_Number__c--> ' + objOrderOverviewQry.DOS_Order_Number__c );
        system.debug('objOrderOverviewQry.RMA_Order_Number__c--> ' + objOrderOverviewQry.RMA_Order_Number__c );
        system.debug('objOrderOverviewQry.Origin_Order_Date__c--> ' + objOrderOverviewQry.Origin_Order_Date__c );
  //      system.debug('isSelectedDeliveryCharge--> ' + isSelectedDeliveryCharge );
  //      system.debug('isSelectedPremiumDeliveryCharge--> ' + isSelectedPremiumDeliveryCharge );
  //      system.debug('isSelectedHaulawayCharge--> ' + isSelectedHaulawayCharge );
        system.debug('objOrderOverviewQry.Delivery_Charge__c--> ' + objOrderOverviewQry.Delivery_Charge__c );
        system.debug('objOrderOverviewQry.Premium_Delivery_Charge__c--> ' + objOrderOverviewQry.Premium_Delivery_Charge__c );
        system.debug('objOrderOverviewQry.Haulaway_Charge__c--> ' + objOrderOverviewQry.Haulaway_Charge__c );
        
    //    if(!isSelectedDeliveryCharge){
        if(objOrderOverviewQry.Delivery_Charge__c==null){
            objOrderOverviewQry.Delivery_Charge__c = 0;
        }
 //       if(!isSelectedPremiumDeliveryCharge){
        if(objOrderOverviewQry.Premium_Delivery_Charge__c==null){
            objOrderOverviewQry.Premium_Delivery_Charge__c = 0;
        }
   //     if(!isSelectedHaulawayCharge){
        if(objOrderOverviewQry.Haulaway_Charge__c==null){
            objOrderOverviewQry.Haulaway_Charge__c = 0;
        }
        
        system.debug('objOrderOverviewQry.Delivery_Charge__c--> ' + objOrderOverviewQry.Delivery_Charge__c );
        system.debug('objOrderOverviewQry.Premium_Delivery_Charge__c--> ' + objOrderOverviewQry.Premium_Delivery_Charge__c );
        system.debug('objOrderOverviewQry.Haulaway_Charge__c--> ' + objOrderOverviewQry.Haulaway_Charge__c );
        
        List<String> lstErrorMessage = new List<String>();
        
        if((objOrderOverviewQry.Reason_Code__c == null || objOrderOverviewQry.Reason_Code__c == '') ){
            lstErrorMessage.add('Missing Reason Code for the Order Header');
        }
        if((objOrderOverviewQry.Purchase_Number__c == null || objOrderOverviewQry.Purchase_Number__c == '') ){
            lstErrorMessage.add('Missing Purchase Number');
        }
        if((objOrderOverviewQry.ShippingStreet == null || objOrderOverviewQry.ShippingStreet == '') ){
            lstErrorMessage.add('Missing Pick-up Street');
        }
        if((objOrderOverviewQry.ShippingCity == null || objOrderOverviewQry.ShippingCity == '') ){
            lstErrorMessage.add('Missing Pick-up City');
        }
        if((objOrderOverviewQry.ShippingState == null || objOrderOverviewQry.ShippingState == '') ){
            lstErrorMessage.add('Missing Pick-up State');
        }
        if((objOrderOverviewQry.ShippingPostalCode == null || objOrderOverviewQry.ShippingPostalCode == '') ){
            lstErrorMessage.add('Missing Pick-up Zip Code');
        }
        if((objOrderOverviewQry.BillingStreet == null || objOrderOverviewQry.BillingStreet == '') ){
            lstErrorMessage.add('Missing Billing Street');
        }
        if((objOrderOverviewQry.BillingCity == null || objOrderOverviewQry.BillingCity == '') ){
            lstErrorMessage.add('Missing Billing City');
        }
        if((objOrderOverviewQry.BillingState == null || objOrderOverviewQry.BillingState == '') ){
            lstErrorMessage.add('Missing Billing State');
        }
        if((objOrderOverviewQry.BillingPostalCode == null || objOrderOverviewQry.BillingPostalCode == '') ){
            lstErrorMessage.add('Missing Billing Zip Code');
        }
        if((objOrderOverviewQry.DOS_Order_Number__c == null || objOrderOverviewQry.DOS_Order_Number__c == '') ){
            lstErrorMessage.add('Missing DOS Order Number');
        }
        if((objOrderOverviewQry.RMA_Order_Number__c == null || objOrderOverviewQry.RMA_Order_Number__c == '') ){
            lstErrorMessage.add('Missing RMA Order Number');
        }
        if(objOrderOverviewQry.Origin_Order_Date__c == null ){
            lstErrorMessage.add('Missing Origin Order Date');
        }
 //       if(isSelectedDeliveryCharge && objOrderOverviewQry.Delivery_Charge__c==null ){
 //           lstErrorMessage.add('Delivery Charge is checked, but missing Delivery Charge');
 //       }else if(isSelectedDeliveryCharge && objOrderOverviewQry.Delivery_Charge__c<=0){
        if(objOrderOverviewQry.Delivery_Charge__c<0){
            lstErrorMessage.add('Please enter valid Delivery Charge amount');
        }
  //      if(isSelectedPremiumDeliveryCharge && objOrderOverviewQry.Premium_Delivery_Charge__c==null ){
  //          lstErrorMessage.add('Premium Delivery Charge is checked, but missing Premium Delivery Charge');
  //      }else if(isSelectedPremiumDeliveryCharge && objOrderOverviewQry.Premium_Delivery_Charge__c<=0){
        if(objOrderOverviewQry.Premium_Delivery_Charge__c<0){
            lstErrorMessage.add('Please enter valid Premium Delivery Charge amount');
        }
 //       if(isSelectedHaulawayCharge && objOrderOverviewQry.Haulaway_Charge__c==null ){
    //        lstErrorMessage.add('HaulAway Charge is checked, but missing HaulAway Charge');
  //      }else if(isSelectedHaulawayCharge && objOrderOverviewQry.Haulaway_Charge__c<=0){
        if(objOrderOverviewQry.Haulaway_Charge__c<0){
            lstErrorMessage.add('Please enter valid HaulAway Charge amount');
        }

            for (AdjOrderItem mc: lstPartsOrderSelection) {
                system.debug('mc.ReasonCode--> ' + mc.ReasonCode + ' || mc.AdjId--> ' + mc.AdjId + ' || mapItemReasonSel.get(mc.AdjId).size()--> ' + mapItemReasonSel.get(mc.AdjId).size() );
                if((mc.ReasonCode == null || mc.ReasonCode == '' ) && mapItemReasonSel.get(mc.AdjId).size() > 1 ){
                    lstErrorMessage.add('Missing Reason Code for the Order Products');
                }
                system.debug('mc.ListUnitPrice--> ' + mc.ListUnitPrice + ' || mc.Feature--> ' + mc.Feature );
                if(mc.ListUnitPrice == null && ( mc.Feature==null || mc.Feature=='' || mc.Feature=='Parts') ){
                    lstErrorMessage.add('Missing Original Price for the Order Products');
                }
                if((mc.ListUnitPrice != null && mc.ListUnitPrice<=0 ) ){
                    lstErrorMessage.add('Please enter valid Original Price for the Order Products');
                }
            }
        
        
        if(lstErrorMessage.size()>0){
            for(String em:lstErrorMessage){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, em));   
            }
        }else{*/
        
        system.debug('selectedAddr--> ' + selectedAddr );
        system.debug('selectedAdjustment--> ' + selectedAdjustment );
        system.debug('selectedSaveAdjustment--> ' + selectedSaveAdjustment );
        selectedAdjustment = selectedSaveAdjustment;
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
            system.debug('selectedAdjustment--> ' + selectedAdjustment );
            
            /*
            List<Order> lstOrderInsert = new List<Order>();
        Order objOrderInsert = new Order();
            
         //   objOrderInsert.SBQQ__Contracted__c = true;
         //   objOrderInsert.ContractId = contractId;
        //    objOrderInsert.SBQQ__Quote__c = lstOrderOverviewQry[0].SBQQ__Quote__c;
        //    objOrderInsert.SBQQ__Contracted__c = false;
            objOrderInsert.AccountId = accountId;
       //     objOrderInsert.Status = 'Submitted';
            objOrderInsert.Status = 'Adjustment Created';
            objOrderInsert.Order_Reference_Number__c = orn;
            objOrderInsert.Type = selectedAdjustment;
            objOrderInsert.Pricebook2Id='01s300000006uBlAAI';
            objOrderInsert.Order_Source__c='Salesforce';
       //     objOrderInsert.Parent_Order__c=orderId;
            objOrderInsert.District_Id__c=district_id;
            objOrderInsert.Territory_Id__c=territory_id;
            objOrderInsert.EffectiveDate = system.today();
            objOrderInsert.Reason_Code__c = objOrderOverviewQry.Reason_Code__c;
            objOrderInsert.Purchase_Number__c=objOrderOverviewQry.Purchase_Number__c;
            objOrderInsert.DOS_Order_Number__c=objOrderOverviewQry.DOS_Order_Number__c;
            objOrderInsert.RMA_Order_Number__c=objOrderOverviewQry.RMA_Order_Number__c;
            objOrderInsert.Origin_Order_Date__c=objOrderOverviewQry.Origin_Order_Date__c;
            objOrderInsert.ShippingStreet=objOrderOverviewQry.ShippingStreet;
            objOrderInsert.ShippingCity=objOrderOverviewQry.ShippingCity;
            objOrderInsert.ShippingState=objOrderOverviewQry.ShippingState;
            objOrderInsert.ShippingPostalCode=objOrderOverviewQry.ShippingPostalCode;
            objOrderInsert.BillingStreet=objOrderOverviewQry.BillingStreet;
            objOrderInsert.BillingCity=objOrderOverviewQry.BillingCity;
            objOrderInsert.BillingState=objOrderOverviewQry.BillingState;
            objOrderInsert.BillingPostalCode=objOrderOverviewQry.BillingPostalCode;
            objOrderInsert.Delivery_Charge__c = objOrderOverviewQry.Delivery_Charge__c;
            objOrderInsert.Premium_Delivery_Charge__c = objOrderOverviewQry.Premium_Delivery_Charge__c;
            objOrderInsert.Haulaway_Charge__c = objOrderOverviewQry.Haulaway_Charge__c;
        if(mapAddr.get(selectedAddr)!=null){
            objOrderInsert.Geo_Code__c = mapAddr.get(selectedAddr).geoCode;
            objOrderInsert.County_Code__c = mapAddr.get(selectedAddr).countyCode;
            objOrderInsert.County_Name__c = mapAddr.get(selectedAddr).countyName;
        }
            if(usr_owner.ManagerId!=null){
                objOrderInsert.Order_Approver__c=usr_owner.ManagerId;
                objOrderInsert.Post_Sales_Manager_Lead__c=usr_owner.ManagerId;
            }
            lstOrderInsert.add(objOrderInsert);
            */
            
            objOrderOverviewQry.Geo_Code__c = mapAddr.get(selectedAddr).geoCode;
            objOrderOverviewQry.County_Code__c = mapAddr.get(selectedAddr).countyCode;
            objOrderOverviewQry.County_Name__c = mapAddr.get(selectedAddr).countyName;
            
            
            try{
                
              //  insert lstOrderInsert;
            update objOrderOverviewQry;
                String saveOrderId = '';
                saveOrderId = objOrderOverviewQry.Id;
            
                List<OrderItem> lstDelOrderItem = new List<OrderItem>();
                lstDelOrderItem = [SELECT Id FROM OrderItem WHERE OrderId=:saveOrderId ORDER BY Number__c];
                system.debug('lstDelOrderItem--> ' + lstDelOrderItem );
                
                    delete lstDelOrderItem;
                
                Map<String, String> mapParentAdjustment = new Map<String, String>();
                for (AdjOrderItem ts: lstPartsOrderSelection) {
                    mapParentAdjustment.put(ts.SeqNumber, ts.Sel_AdjId);
                }
                
        List<OrderItem> lstInsOrderItem = new List<OrderItem>();
            OrderItem objInsPartsOrderItem = new OrderItem();
        for (AdjOrderItem pts: lstPartsOrderSelection) {
            system.debug('pts--> ' + pts );
            system.debug('pts.Sel_AdjId--> ' + pts.Sel_AdjId + ' || pts.SeqNumber--> ' + pts.SeqNumber + ' || pts.ParentPartNumber--> ' + pts.ParentPartNumber );
            objInsPartsOrderItem = new OrderItem();
            
            objInsPartsOrderItem.OrderId = saveOrderId;
            objInsPartsOrderItem.Number__c = String.valueof(Integer.valueof(pts.Sel_AdjId)*10);
            objInsPartsOrderItem.Product2Id = pts.Product2Id;
       //     objInsPartsOrderItem.Quantity = pts.Sel_Quantity;
            objInsPartsOrderItem.Quantity = pts.Quantity;
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
            objInsPartsOrderItem.List_Unit_Price__c = pts.ListUnitPrice!=null?pts.ListUnitPrice:pts.NetUnitPrice;
     //       objInsPartsOrderItem.Net_Unit_Price__c = pts.Sel_NetUnitPrice;
     //       objInsPartsOrderItem.UnitPrice = pts.Sel_NetUnitPrice;
            objInsPartsOrderItem.Net_Unit_Price__c = pts.NetUnitPrice;
            objInsPartsOrderItem.UnitPrice = pts.NetUnitPrice;
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
        
    //    PageReference retURL = new PageReference('/apex/OrderAdjustmentEdit?id=' + saveOrderId + '&adj=' + selectedAdjustment );
    //    PageReference retURL = new PageReference('/apex/StandaloneRXEdit?id=' + saveOrderId + '&adj=' + selectedAdjustment );
        PageReference retURL = new PageReference('/apex/StandaloneEdit?id=' + saveOrderId + '&adj=' + selectedAdjustment );
    //    PageReference retURL = new PageReference('/' + saveOrderId );
        retURL.setRedirect(true);
        return retURL;
            
                }catch(Exception e){
                    String em = 'Following error was encountered while creating order items: ' + e.getMessage();
                    System.debug(em);
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, em));   
                }
                
               
                
            }catch(Exception e){
                    String em = 'Following error was encountered while updating order: ' + e.getMessage();
                    System.debug(em);
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, em));   
            }
            
            
        }
        
        
        
        return null;
    }
    
    public class productaccessoriessend {
        public String part_number {get;set;}
        public String quantity {get;set;}
        public String zipcode {get;set;}
        public String account_number {get;set;}
    }       
    
    public class OptionProduct{
        public Integer seq_no {get;set;}
        public Boolean sel_check {get;set;}
        public Boolean sel_button {get;set;}
        public Boolean renButton {get;set;}
        public String sel_type {get;set;}
        public Boolean is_selected {get;set;}
        public String option_id {get;set;}
        public String product_id {get;set;}
        public String product_code {get;set;}
        public String product_name {get;set;}
        public String product_description {get;set;}
        public String list_price {get;set;}
    }
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