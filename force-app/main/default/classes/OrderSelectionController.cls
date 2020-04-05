public class OrderSelectionController {
    
    public String contractId {get; set;}
    public String shipZip {get; set;}
    public String quoteId {get; set;}
    public String accountId {get; set;}
    public Boolean isQuotePrimary {get; set;}
    
    public List<Contract_Line_Item__c> lstContractLineItem {get; set;}
    
    public Map<Integer,OrderSelection> mapContractLineItem {get; set;}
    public Map<Integer,OrderSelection> mapOrderSelection {get; set;}
    public List<OrderSelection> lstOrderSelection {get; set;}
    public Map<Integer,Decimal> mapProductQuantity {get; set;}
    
    public Boolean renSelection {get; set;}
    public Boolean displayPopUp {get; set;}
    public Boolean renSubstitute {get; set;}
    public Boolean renOrderCreateError {get; set;}
    
    public String paymentType {get; set;}
    public String delDate {get; set;}
    public String delNote {get; set;}
    
  //  public Map<String, List<String>> mapDeliveryProduct {get; set;}
    public Map<String, Map<String, String>> mapDeliveryProduct {get; set;}
    public Map<String, String> mapConfiguration {get; set;}
    public Map<String, list<selectoption>> mapSel {get; set;}
    public Map<Integer, list<selectoption>> mapSel1 {get; set;}
    public Map<Integer,String> mapSelectedConfiguration {get; set;}
    public Map<String,String> mapProductPriceBook {get; set;}
    public Map<String,String> mapParentNumber {get; set;}
    public Map<String,String> mapParentCode {get; set;}
    public Map<Integer,String> mapParentUnique {get; set;}
    
    public String ordertype {get; set;}
    public String contractName {get; set;}
    public Set<String> setDate {get; set;}
    public Boolean renDelivery {get; set;}
    public Boolean renLoading {get; set;}
    public Double deliverycharge {get; set;}
    public String purchasenumber {get; set;}
    public String territory_id {get; set;}
    public String district_id {get; set;}
    public String payType {get; set;}
    public Double contract_net_total {get; set;}
    public Double selected_net_total {get; set;}
    public Double percent_net_total {get; set;}
    public String orderreferencenumber {get; set;}
    public String b2borderid {get; set;}
    public String insertorderid {get; set;}
    public String b2bOrderErrorMessage {get; set;}
    public String orderapirequest {get; set;}
    
    public List<String> lstOrderType {get; set;}
    public String selectedordertype {get; set;}
    
    public OrderSelectionController() {
        contractId = ApexPages.CurrentPage().getparameters().get('id');
     //   contractId = '800W0000000kquxIAA';
        shipZip = '';
        quoteId = '';
        accountId = '';
        isQuotePrimary = false;
        
        lstContractLineItem = new List<Contract_Line_Item__c>();
        
        mapContractLineItem = new Map<Integer,OrderSelection>();
        mapOrderSelection = new Map<Integer,OrderSelection>();
        lstOrderSelection = new List<OrderSelection>();
        mapProductQuantity = new Map<Integer,Decimal>();
        
        renSelection = false;
        displayPopUp = false;
        renSubstitute = false;
        renOrderCreateError = false;
        
    //    mapDeliveryProduct = new Map<String, List<String>>();
        mapDeliveryProduct = new Map<String, Map<String, String>>();
        mapConfiguration = new Map<String, String>();
        mapSel = new Map<String, list<selectoption>>();
        mapSel1 = new Map<Integer, list<selectoption>>();
        mapSelectedConfiguration = new Map<Integer, String>();
        mapProductPriceBook = new Map<String, String>();
        mapParentNumber = new Map<String, String>();
        mapParentCode = new Map<String, String>();
        mapParentUnique = new Map<Integer, String>();
        
        ordertype = 'Contract';
        setDate = new Set<String>();
        renDelivery = false;
        renLoading = false;
        deliverycharge = 0;
        purchasenumber = '';
        territory_id = '';
        district_id = '';
        payType = '';
        contract_net_total = 0;
        selected_net_total = 0;
        percent_net_total = 0;
        orderreferencenumber = '';
        b2borderid = '';
        insertorderid= '';
        b2bOrderErrorMessage= '';
        orderapirequest= '';
        selectedordertype = '';
        
        lstOrderType = new List<String>();/*
        Schema.DescribeFieldResult field = Order.Type.getDescribe();
        
      for (Schema.PicklistEntry f : field.getPicklistValues())
        lstOrderType.add(f.getLabel());
        
        system.debug('lstOrderType--> ' + lstOrderType );
        
        lstOrderType.clear();
        */
        lstOrderType.add('Order');
        lstOrderType.add('Return');
        lstOrderType.add('Exchange');
        lstOrderType.add('Credit Memo');
        lstOrderType.add('Debit Memo');
        
        system.debug('lstOrderType--> ' + lstOrderType );
        
    //    mapConfiguration.put('standard', 'Door should open to the right (Standard)');
   //     mapConfiguration.put('18', 'Door should open to the left');
   //     mapConfiguration.put('19', 'I have purchased a separate ice-maker, it should be installed prior to delivery.');
   //     mapConfiguration.put('20', 'The refrigerator door should open to the left (instead of the right) and I have purchased a separate ice-maker, it should be installed prior to delivery.');
        
        List<Order_Staging__c> lstOrderStagingQry = new List<Order_Staging__c>();
        lstOrderStagingQry = [SELECT Id, Active__c, Delete_Date__c, Delivery_Dates__c, Quote__c, Contract__c, Payment_Type__c, Order_Reference_Number__c
                              FROM Order_Staging__c
                              WHERE Contract__c=:contractId AND Delete_Date__c >: system.now()
                              LIMIT 1
                             ];
        system.debug('lstOrderStagingQry--> ' + lstOrderStagingQry );
        /*
        if(lstOrderStagingQry.size()>0){
            if(lstOrderStagingQry[0].Order_Reference_Number__c!=null){
                orderreferencenumber = lstOrderStagingQry[0].Order_Reference_Number__c;
            }
            if(lstOrderStagingQry[0].Payment_Type__c!=null){
                payType = lstOrderStagingQry[0].Payment_Type__c;
            }
            if(lstOrderStagingQry[0].Delivery_Dates__c!=null){
                String str_deliverydate = '';
                str_deliverydate = lstOrderStagingQry[0].Delivery_Dates__c;
                renDelivery = true;
                setDate = new Set<String>();
                setDate.addAll(str_deliverydate.split(','));
            //    List<String> lstAlpha = alpha.split(',');
            }
        }
        */
        
        
        lstContractLineItem =[SELECT Id, Name, Contract__c, Status__c, Product__c, 
                              	Product__r.Name, Product__r.ProductCode, Feature__c, Product__r.Fulfillment_Channel__c, 
                              	Total_Quantity__c, Items_Processed__c, Items_Remaining__c, 
                              	Total_Amount__c, Amount_Processed__c, Amount_Remaining__c,
                              	isProductParent__c, Number__c, ProductParentUnique__c, Tax_Rate__c, 
                              	List_Unit_Price__c, Net_Unit_Price__c, Disposable_Fee__c, Configuration_Code__c
                              FROM Contract_Line_Item__c 
                              WHERE Contract__c =: contractId 
                              ORDER BY Number__c
                             ];
        
        List<Contract> lstContract = new List<Contract>();
        lstContract = [SELECT Id, Name, SBQQ__Quote__r.SBQQ__ShippingPostalCode__c, SBQQ__Quote__r.Delivery_Charge__c,  SBQQ__Quote__r.Delivery_Discount__c, 
                       SBQQ__Quote__r.SBQQ__Primary__c, SBQQ__Quote__c, AccountId, Account.Territory_ID__c, Account.NewTerritory__c, Delivery_Charge__c , Purchase_Number__c
                       FROM Contract 
                       WHERE Id=:contractId 
                       LIMIT 1
                      ];
        
        if(lstContract.size()>0){
            shipZip = lstContract[0].SBQQ__Quote__r.SBQQ__ShippingPostalCode__c;
            quoteId = lstContract[0].SBQQ__Quote__c;
            accountId = lstContract[0].AccountId;
            isQuotePrimary = lstContract[0].SBQQ__Quote__r.SBQQ__Primary__c;
            contractName = lstContract[0].Name;
        //    deliverycharge = Double.valueof(lstContract[0].SBQQ__Quote__r.Delivery_Charge__c>0?lstContract[0].SBQQ__Quote__r.Delivery_Charge__c:0 - lstContract[0].SBQQ__Quote__r.Delivery_Discount__c>0?lstContract[0].SBQQ__Quote__r.Delivery_Discount__c:0 ) ;
            Double dlv_charge = 0;
            Double dlv_discount = 0;
            if(lstContract[0].SBQQ__Quote__r.Delivery_Charge__c!=null && Double.valueof(lstContract[0].SBQQ__Quote__r.Delivery_Charge__c)!=0 ){
                dlv_charge = Double.valueof(lstContract[0].SBQQ__Quote__r.Delivery_Charge__c);
            }
            if(lstContract[0].SBQQ__Quote__r.Delivery_Discount__c!=null && Double.valueof(lstContract[0].SBQQ__Quote__r.Delivery_Discount__c)!=0 ){
                dlv_discount = Double.valueof(lstContract[0].SBQQ__Quote__r.Delivery_Discount__c);
            }
            deliverycharge = dlv_charge - dlv_discount ;
            purchasenumber = lstContract[0].Purchase_Number__c;
        //    territory_id = lstContract[0].Account.Territory_ID__c;
            
            
        List<Territory__c> lstTerritory = new List<Territory__c>();
        lstTerritory = [SELECT Id, Name, Territory_ID__c, District_Territory_ID__c 
                        FROM Territory__c 
                   //     WHERE Territory_ID__c =: lstContract[0].Account.Territory_ID__c 
                        WHERE Id =: lstContract[0].Account.NewTerritory__c 
                        ORDER BY Id DESC
                        LIMIT 1
                       ];
            if(lstTerritory.size()>0){
                territory_id = lstTerritory[0].Territory_ID__c;
                district_id = lstTerritory[0].District_Territory_ID__c;
            }
            
        }
            

        
        OrderSelection objOS = new OrderSelection();
        OrderSelection objOS2 = new OrderSelection();
        
        integer cnt = 1;
        for(Contract_Line_Item__c clid:lstContractLineItem){
            if(clid.isProductParent__c){
                mapParentNumber.put(clid.ProductParentUnique__c, string.valueof(clid.Number__c*10));
                mapParentCode.put(clid.ProductParentUnique__c, clid.Product__r.ProductCode);
            }
            contract_net_total += double.valueof(clid.Total_Amount__c!=null?clid.Total_Amount__c:0);
            
            objOS = new OrderSelection();
            objOS.seq_no = cnt;
        //    objOS.selected = false;
            objOS.product_name = clid.Product__r.Name;
            objOS.product_code = clid.Product__r.ProductCode;
            objOS.feature = clid.Feature__c;
            objOS.product = clid.Product__c;
            objOS.Quantity = 0;
            objOS.price = 0;
         //   objOS.list_price = clid.Total_Quantity__c>0 ?clid.Total_Amount__c/clid.Total_Quantity__c:0;
            if(clid.Total_Amount__c!= null && clid.Total_Amount__c!=null ){
            	objOS.list_price = clid.Total_Quantity__c>0 ?(clid.Total_Amount__c>0?clid.Total_Amount__c:0)/clid.Total_Quantity__c:0;
            }else{
                objOS.list_price = 0;
            }
            objOS.tax_rate = clid.Tax_Rate__c!=null?double.valueof(clid.Tax_Rate__c):0;
            objOS.delivery_eligible = clid.Product__r.Fulfillment_Channel__c=='TW'?true:false;
            objOS.isProductParent = clid.isProductParent__c;
            objOS.ProductParentUnique = clid.ProductParentUnique__c;
            objOS.list_unit_price = clid.List_Unit_Price__c;
            objOS.net_unit_price = clid.Net_Unit_Price__c;
            objOS.disposable_fee = clid.Disposable_Fee__c;
 //           objOS.Available = false;
 //           objOS.Available_Quantity = 0;
 //           objOS.Earliest_Available_Date = system.today();
 //           objOS.PA_API_Message = '';
            
            
            objOS2 = new OrderSelection();
            objOS2.seq_no = cnt;
    //        objOS2.selected = false;
            objOS2.product_name = clid.Product__r.Name;
            objOS2.product_code = clid.Product__r.ProductCode;
            objOS2.feature = clid.Feature__c;
            objOS2.product = clid.Product__c;
            objOS2.Quantity = integer.valueOf(clid.Items_Remaining__c);
            objOS2.price = clid.Amount_Remaining__c;
       //     objOS2.list_price = clid.Total_Quantity__c>0 ?clid.Total_Amount__c/clid.Total_Quantity__c:0;
            if(clid.Total_Amount__c!= null && clid.Total_Amount__c!=null ){
            	objOS2.list_price = clid.Total_Quantity__c>0 ?(clid.Total_Amount__c>0?clid.Total_Amount__c:0)/clid.Total_Quantity__c:0;
            }else{
                objOS2.list_price = 0;
            }
            objOS2.tax_rate = clid.Tax_Rate__c!=null?double.valueof(clid.Tax_Rate__c):0;
            objOS2.delivery_eligible = clid.Product__r.Fulfillment_Channel__c=='TW'?true:false;
            objOS2.isProductParent = clid.isProductParent__c;
            objOS2.ProductParentUnique = clid.ProductParentUnique__c;
            objOS2.list_unit_price = clid.List_Unit_Price__c;
            objOS2.net_unit_price = clid.Net_Unit_Price__c;
            objOS2.disposable_fee = clid.Disposable_Fee__c;
 //           objOS2.Available = false;
 //           objOS2.Available_Quantity = 0;
 //           objOS2.Earliest_Available_Date = system.today();
 //           objOS2.PA_API_Message = '';
       //     mapSelectedConfiguration.put(objOS2.seq_no, '');
        	mapSelectedConfiguration.put(objOS2.seq_no, clid.Configuration_Code__c);
            if(mapSelectedConfiguration.get(objOS2.seq_no)==null){
                mapSelectedConfiguration.put(objOS2.seq_no, '');
            }
            cnt++;
            if(clid.Items_Remaining__c>0){
            	mapOrderSelection.put(objOS.seq_no, objOS);
            	mapContractLineItem.put(objOS2.seq_no, objOS2);
            }
        }
       
        if(mapOrderSelection.size()>0){
        	renSelection = true;
        }
        
        paymentType = '';
        delDate = '';
        delNote = '';
        
                system.debug('contract_net_total--> ' + contract_net_total );
        
    }
    
    public void actionAddSelection(){
        
        selected_net_total = 0;
        percent_net_total = 0;
        
        lstOrderSelection = new List<OrderSelection>();
        
        OrderSelection objOrderSelection = new OrderSelection();
        
        List<String> lstProductId = new List<String>();
        Map<String, String> mapProductCode = new Map<String, String>();
        
                system.debug('mapSelectedConfiguration--> ' + mapSelectedConfiguration );
        
        Map<String, Integer> mapParentProduct = new Map<String, Integer>();
        
        Boolean renOrder = true;
        
            for(Integer seq:mapOrderSelection.keySet()){
         //       mapSelectedConfiguration.put(seq, '');
                if(mapSelectedConfiguration.get(seq)==null){
                    mapSelectedConfiguration.put(seq, '');            
                }
             //   if(mapOrderSelection.get(seq).selected==true){
                if(mapOrderSelection.get(seq).Quantity>0 && mapOrderSelection.get(seq).isProductParent ){
                    system.debug('mapOrderSelection.get(seq)--> ' + mapOrderSelection.get(seq) );
                    mapParentProduct.put(mapOrderSelection.get(seq).ProductParentUnique, mapOrderSelection.get(seq).Quantity);
                }
            }
                    
        system.debug('mapParentProduct--> ' + mapParentProduct );
                system.debug('mapSelectedConfiguration--> ' + mapSelectedConfiguration );
        
            for(Integer seq:mapOrderSelection.keySet()){
                    system.debug('mapOrderSelection1.get(seq)--> ' + mapOrderSelection.get(seq) );
            //    if(mapParentProduct.keyset().contains(mapOrderSelection.get(seq).ProductParentUnique)){
                    OrderSelection objOrderSelection1 = new OrderSelection();
                    objOrderSelection1 = mapOrderSelection.get(seq);
                //    objOrderSelection1.Quantity = mapParentProduct.get(mapOrderSelection.get(seq).ProductParentUnique);
                    objOrderSelection1.Quantity = (mapOrderSelection.get(seq).product_code=='haulawayRequested' && mapParentProduct.get(mapOrderSelection.get(seq).ProductParentUnique)!=null && mapParentProduct.get(mapOrderSelection.get(seq).ProductParentUnique)!=0  ) ?1:mapParentProduct.get(mapOrderSelection.get(seq).ProductParentUnique);
                    mapOrderSelection.put(seq, objOrderSelection1);
          //      }
            }        
        
            for(Integer seq:mapOrderSelection.keySet()){
                    system.debug('mapOrderSelection.get(seq)--> ' + mapOrderSelection.get(seq) );
                    selected_net_total += double.valueof((mapOrderSelection.get(seq).Quantity!=null?mapOrderSelection.get(seq).Quantity:0)*(mapOrderSelection.get(seq).net_unit_price!=null?mapOrderSelection.get(seq).net_unit_price:0));
            }
        
        percent_net_total = contract_net_total==0?0:double.valueof(selected_net_total/contract_net_total);
        
        system.debug('selected_net_total--> ' + selected_net_total );
        system.debug('contract_net_total--> ' + contract_net_total );
        system.debug('percent_net_total--> ' + percent_net_total );
        
        
        for(Integer seq:mapOrderSelection.keySet()){
       //     if(mapOrderSelection.get(seq).selected==true && (mapOrderSelection.get(seq).Quantity <= 0 || mapOrderSelection.get(seq).Quantity > mapContractLineItem.get(seq).Quantity ) ){
            if(mapOrderSelection.get(seq).Quantity < 0 || mapOrderSelection.get(seq).Quantity > mapContractLineItem.get(seq).Quantity ){
                renOrder = false;
            }
        }
        
                    system.debug('renOrder--> ' + renOrder );
        
        if(renOrder==false){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Selected Contract items Quantity should be greater than 0, and less than the items remaining'));
        }else{
            
            for(Integer seq:mapOrderSelection.keySet()){
             //   if(mapOrderSelection.get(seq).selected==true){
                if(mapOrderSelection.get(seq).Quantity>0){
                    
                    system.debug('mapOrderSelection.get(seq)--> ' + mapOrderSelection.get(seq) );
                    objOrderSelection = new OrderSelection();
                    objOrderSelection = mapOrderSelection.get(seq);
                    objOrderSelection.price = mapOrderSelection.get(seq).list_price * mapOrderSelection.get(seq).Quantity;
                    lstOrderSelection.add(objOrderSelection);
            		if(mapOrderSelection.get(seq).feature==null){
                		lstProductId.add(mapOrderSelection.get(seq).product);
                        mapProductCode.put(mapOrderSelection.get(seq).product, mapOrderSelection.get(seq).product_code);
            		}
                }
            }
            if(lstOrderSelection.size()>0){
                //	actionProductAvailability();
                actionProductAvailability2();
                
                //   mapDeliveryProduct = new Map<String, List<String>>();
                mapDeliveryProduct = new Map<String, Map<String, String>>();
                mapDeliveryProduct = DeliveryServiceConfiguration.DeliveryServiceWrapper(quoteId, lstProductId);
                system.debug('mapDeliveryProduct--> ' + mapDeliveryProduct );
                
            
                //    for(String pc:mapDeliveryProduct.keySet()){
                for(Integer seq:mapOrderSelection.keySet()){
                    if(mapOrderSelection.get(seq).Quantity>0){
                        list<selectoption> lstSel= new list<selectoption>();
                        lstSel.add(new SelectOption('', '--None--'));  
                        if(mapDeliveryProduct.keySet().contains(mapOrderSelection.get(seq).product_code)){
                            //        for (String conf:mapDeliveryProduct.get(mapOrderSelection.get(seq).product_code)){
                            //            lstSel.add(new SelectOption(conf, mapConfiguration.get(conf))); 
                            //         }
                            for (String conf:mapDeliveryProduct.get(mapOrderSelection.get(seq).product_code).keyset()){
                                lstSel.add(new SelectOption(conf, mapDeliveryProduct.get(mapOrderSelection.get(seq).product_code).get(conf))); 
                                mapConfiguration.put(conf, mapDeliveryProduct.get(mapOrderSelection.get(seq).product_code).get(conf)); 
                            }
                        }
                        //  	mapSel.put(mapOrderSelection.get(seq).product_code, lstSel);
                        // 	mapSel1.put(mapOrderSelection.get(seq).seq_no, lstSel);
                        mapSel1.put(seq, lstSel);
                    }
                }
                system.debug('mapSelectedConfiguration--> ' + mapSelectedConfiguration );
                system.debug('mapSel1--> ' + mapSel1 );
            
                
                
            }
        displayPopup = true; 
        }
        
                system.debug('mapSelectedConfiguration--> ' + mapSelectedConfiguration );
        
    }
    
    public void actionProductAvailability2(){
        
        List<OrderSelection> lst_os = new List<OrderSelection>();
        Map<String, Integer> mapProductCode = new Map<String, Integer>();
        
   //     lst_os.addAll(lstOrderSelection);
        
        
        for(OrderSelection os :lstOrderSelection) {
            if(os.feature==null || os.feature=='Parts' ){
                mapProductCode.put(os.product_code, os.seq_no);
                lst_os.add(os);
            }            
        }
        
        system.debug('lstOrderSelection--> ' + lstOrderSelection);
        
        if(lst_os.size()>0){
        DOM.Document doc = new DOM.Document();
        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        Http http = new Http();
        
        Map<String, Common_Variables__c> mapCV = Common_Variables__c.getAll();
    //    String CS_Endpoint = mapCV.get('B2BProd_Tax_API_URL').Content__c;
   //     String CS_Endpoint = 'https://api.b2b.sears.com/v/2/delivery/earliest-dates';
        String CS_Endpoint = mapCV.get('B2BProd_ProductAvailability').Content__c;
        String CS_CLIENT_ID = mapCV.get('B2BProd_ClientId').Content__c;
        String CS_CLIENT_SECRET = mapCV.get('B2BProd_ClientSecret').Content__c;
        String CS_CONTENT_TYPE = mapCV.get('B2BProd_ContentType_XML').Content__c;

        String EndpointUrl = CS_Endpoint;
        String itemspayload;
        
        request.setMethod('POST');
        request.setendPoint(EndpointUrl);
        system.debug('EndpointUrl >>'+EndpointUrl);
        
        request.setHeader('Content-Type', CS_CONTENT_TYPE);
        request.setHeader('CLIENT_ID', CS_CLIENT_ID);
        request.setHeader('CLIENT_SECRET', CS_CLIENT_SECRET);
        
        dom.XmlNode xmlrequest = doc.createRootElement('request', null, null);
        dom.xmlNode zipCode = xmlrequest.addChildElement('zipCode', null, null);
        zipCode.addTextnode(shipZip);
        dom.xmlNode items = xmlrequest.addChildElement('items',null,null);
        
        Map<String, List<OrderSelection>> mapQuoteLine = new Map<String, List<OrderSelection>>();
        List<OrderSelection> lstTempQL = new List<OrderSelection>();
        
        for(OrderSelection ql :lst_os) {
      //      mapProductQuote.put(ql.SBQQ__Product__r.ProductCode, ql.Id);
            lstTempQL = new List<OrderSelection>();
            String key_ql = ql.product_code;//+string.valueof(Integer.valueof(ql.Quantity__c))+string.valueof(ql.Net_Unit_Price__c);
            if(mapQuoteLine.keySet().contains(key_ql)){
                lstTempQL.addAll(mapQuoteLine.get(key_ql));
            }else{
                mapQuoteLine.put(key_ql, lstTempQL);
            }
            lstTempQL.add(ql);
            
            mapQuoteLine.put(key_ql, lstTempQL);
            
            
            
            System.debug('Callout--> Quote Line Items:'+ql.product_code);   
            //string tempprod = string.valueof(ql.SBQQ__Product__r.ProductCode);
            if(string.ValueOf(ql.product_code).startsWith('0')) {
            system.debug('product code' +ql.product_code);
            dom.XmlNode item = items.addChildElement('item', null, null);

            dom.XmlNode itemId = item.addChildElement('itemId', null, null);
            itemId.addTextNode(ql.product_code);

            dom.XmlNode quantity = item.addChildElement('quantity', null, null);
         //   quantity.addTextNode('1');
            quantity.addTextNode(String.valueof(Integer.valueof(ql.quantity)));

            
            dom.XmlNode dualStockItem = item.addChildElement('dualStockItem', null, null);
            dualStockItem.addTextNode('false');
            
             }
        }  
        
        string req = doc.toXmlString();
        request.setBody(req);
        
        Map<String, Date> mapAvailDate = new Map<String, Date>();
        
        mapAvailDate = CalloutProdInventoryCheckAPI7.ProdAvailCheckAPI(request);
            
                        system.debug('mapAvailDate --> ' + mapAvailDate );
                        system.debug('mapProductCode --> ' + mapProductCode );
            
            
        List<OrderSelection> lstQLStagingUpdate = new List<OrderSelection>();
        OrderSelection objQLStaging = new OrderSelection();
        Map<Integer,OrderSelection> mapOrderSelectionUpdate = new Map<Integer,OrderSelection>();
            
        for(String pid : mapProductCode.keyset()){
            objQLStaging = new OrderSelection();
            objQLStaging.seq_no = mapProductCode.get(pid);
            objQLStaging.PA_API_Message = '';
            objQLStaging.Earliest_Available_Date = null;
            objQLStaging.Available = false;
            objQLStaging.Available_Quantity = 0;
            
            if(mapAvailDate.get(pid)!=null){
                objQLStaging.PA_API_Message = 'Success';
            	objQLStaging.Available = true;
            	objQLStaging.Earliest_Available_Date = mapAvailDate.get(pid);
            }else{
                objQLStaging.PA_API_Message = 'Item Unavailable';
            }
            
            lstQLStagingUpdate.add(objQLStaging);
            mapOrderSelectionUpdate.put(objQLStaging.seq_no,objQLStaging);
                        system.debug('objQLStaging --> ' + objQLStaging );
        }
                        system.debug('lstQLStagingUpdate --> ' + lstQLStagingUpdate );
   //     update lstQLStagingUpdate;
            
                renSubstitute = false;
                        system.debug('lstOrderSelection --> ' + lstOrderSelection );
        for(OrderSelection los : lstOrderSelection) {
            if(mapOrderSelectionUpdate.keyset().contains(los.seq_no)){
                los.PA_API_Message = mapOrderSelectionUpdate.get(los.seq_no).PA_API_Message;
                los.Earliest_Available_Date = mapOrderSelectionUpdate.get(los.seq_no).Earliest_Available_Date;
                los.Available = mapOrderSelectionUpdate.get(los.seq_no).Available;
           //     los.Available = false;
                los.Available_Quantity = mapOrderSelectionUpdate.get(los.seq_no).Available_Quantity;
        //    if(los.Quantity>los.Available_Quantity){
            if(!los.Available){
                renSubstitute = true;
            }
                
            }else if(los.feature!=null && los.feature!='Parts'){
                    los.Available = true;
            }else{
                renSubstitute = true;
            }
        }
        
        
           
            
        }        
        
        /*
        if(lst_os.size()>0){
        
        string tmpprodlist1='';
        string tmpprodlist2='';
        string tmpprodlist3='';
        integer tmp_i2 = 1;
        integer tmp_i3 = 1;
        integer tmp_limit = 25;

        if (lst_os.size()>tmp_limit && lst_os.size()>0 ){
            for(OrderSelection qli2 :lst_os) {
                system.debug('tmp_i2' +tmp_i2);
                system.debug('lt_qli.size()' +lst_os.size());
                if(tmp_i2<tmp_limit){
                    tmpprodlist1 = tmpprodlist1+qli2.product_code+',';
                }else if(tmp_i2==tmp_limit){
                    tmpprodlist1 = tmpprodlist1+qli2.product_code;
                }else if(tmp_i2>tmp_limit){
                    tmpprodlist2 = tmpprodlist2+qli2.product_code;
                    if(tmp_i2<lst_os.size()){
                        tmpprodlist2+=',';
                    }
                }
                tmp_i2++;
            }
        }else if(lst_os.size()>0) {
            for(OrderSelection qli3 :lst_os) {
                system.debug('tmp_i3' +tmp_i3);
                system.debug('lst_os.size()' +lst_os.size());
                tmpprodlist3 = tmpprodlist3+qli3.product_code;
                if(tmp_i3<lst_os.size()){
                    tmpprodlist3+=',';
                }
                tmp_i3++;
            }
        }
        
        system.debug('tmpprodlist1' +tmpprodlist1);
        system.debug('tmpprodlist2' +tmpprodlist2);
        system.debug('tmpprodlist3' +tmpprodlist3);
        system.debug('shipZip' +shipZip);
        
        List<dom.XmlNode> productXMLNode = new List<dom.XmlNode>();
        List<dom.XmlNode> productXMLNode1 = new List<dom.XmlNode>();
        List<dom.XmlNode> productXMLNode2 = new List<dom.XmlNode>();
        List<dom.XmlNode> productXMLNode3 = new List<dom.XmlNode>();
        
        if(tmpprodlist3!=null && tmpprodlist3!='' ){
            
        //    QuoteHandler.ProdTaxCheckCallout3(tmpprodlist3,qheader,mapProductCode,mapProductQuote);
            productXMLNode3 = QuoteHandler.ProdTaxCheckCallout5(tmpprodlist3,shipZip);
            productXMLNode.addAll(productXMLNode3);
        }else{
            
        //    QuoteHandler.ProdTaxCheckCallout3(tmpprodlist1,qheader,mapProductCode,mapProductQuote);
        //    QuoteHandler.ProdTaxCheckCallout3(tmpprodlist2,qheader,mapProductCode,mapProductQuote);
            productXMLNode1 = QuoteHandler.ProdTaxCheckCallout5(tmpprodlist1,shipZip);
            productXMLNode2 = QuoteHandler.ProdTaxCheckCallout5(tmpprodlist2,shipZip);
            productXMLNode.addAll(productXMLNode1);
            productXMLNode.addAll(productXMLNode2);
        }
        
            ProdAvailCheckOrder(productXMLNode,mapProductCode);
        
        }*/
    }    
    
    
    /*
    public void actionProductAvailability(){
        system.debug('lstOrderSelection--> ' + lstOrderSelection);
        List<OrderSelection> lst_os = new List<OrderSelection>();
        Map<String, Integer> mapProductCode = new Map<String, Integer>();
        
   //     lst_os.addAll(lstOrderSelection);
        
        
        for(OrderSelection os :lstOrderSelection) {
            if(os.feature==null || os.feature=='Parts' ){
                mapProductCode.put(os.product_code, os.seq_no);
                lst_os.add(os);
            }            
        }
        
        if(lst_os.size()>0){
        
        string tmpprodlist1='';
        string tmpprodlist2='';
        string tmpprodlist3='';
        integer tmp_i2 = 1;
        integer tmp_i3 = 1;
        integer tmp_limit = 25;

        if (lst_os.size()>tmp_limit && lst_os.size()>0 ){
            for(OrderSelection qli2 :lst_os) {
                system.debug('tmp_i2' +tmp_i2);
                system.debug('lt_qli.size()' +lst_os.size());
                if(tmp_i2<tmp_limit){
                    tmpprodlist1 = tmpprodlist1+qli2.product_code+',';
                }else if(tmp_i2==tmp_limit){
                    tmpprodlist1 = tmpprodlist1+qli2.product_code;
                }else if(tmp_i2>tmp_limit){
                    tmpprodlist2 = tmpprodlist2+qli2.product_code;
                    if(tmp_i2<lst_os.size()){
                        tmpprodlist2+=',';
                    }
                }
                tmp_i2++;
            }
        }else if(lst_os.size()>0) {
            for(OrderSelection qli3 :lst_os) {
                system.debug('tmp_i3' +tmp_i3);
                system.debug('lst_os.size()' +lst_os.size());
                tmpprodlist3 = tmpprodlist3+qli3.product_code;
                if(tmp_i3<lst_os.size()){
                    tmpprodlist3+=',';
                }
                tmp_i3++;
            }
        }
        
        system.debug('tmpprodlist1' +tmpprodlist1);
        system.debug('tmpprodlist2' +tmpprodlist2);
        system.debug('tmpprodlist3' +tmpprodlist3);
        system.debug('shipZip' +shipZip);
        
        List<dom.XmlNode> productXMLNode = new List<dom.XmlNode>();
        List<dom.XmlNode> productXMLNode1 = new List<dom.XmlNode>();
        List<dom.XmlNode> productXMLNode2 = new List<dom.XmlNode>();
        List<dom.XmlNode> productXMLNode3 = new List<dom.XmlNode>();
        
        if(tmpprodlist3!=null && tmpprodlist3!='' ){
            
        //    QuoteHandler.ProdTaxCheckCallout3(tmpprodlist3,qheader,mapProductCode,mapProductQuote);
            productXMLNode3 = QuoteHandler.ProdTaxCheckCallout5(tmpprodlist3,shipZip);
            productXMLNode.addAll(productXMLNode3);
        }else{
            
        //    QuoteHandler.ProdTaxCheckCallout3(tmpprodlist1,qheader,mapProductCode,mapProductQuote);
        //    QuoteHandler.ProdTaxCheckCallout3(tmpprodlist2,qheader,mapProductCode,mapProductQuote);
            productXMLNode1 = QuoteHandler.ProdTaxCheckCallout5(tmpprodlist1,shipZip);
            productXMLNode2 = QuoteHandler.ProdTaxCheckCallout5(tmpprodlist2,shipZip);
            productXMLNode.addAll(productXMLNode1);
            productXMLNode.addAll(productXMLNode2);
        }
        
            ProdAvailCheckOrder(productXMLNode,mapProductCode);
        
        }
    }    
    
    
    public void ProdAvailCheckOrder(List<dom.XmlNode> productXMLNode, Map<String, Integer> mapProductCode){
              
        Map<Integer,OrderSelection> mapOrderSelectionUpdate = new Map<Integer,OrderSelection>();
        List<OrderSelection> lstOrderSelectionUpdate = new List<OrderSelection>();
        OrderSelection objOrderSelection = new OrderSelection();
        
        system.debug('productXMLNode.size()--> ' +productXMLNode.size());
        
        for(DOM.XmlNode productlist : productXMLNode) {
                    objOrderSelection = new OrderSelection();
        system.debug('productlist--> ' +productlist);
                dom.xmlNode itemidnode = productlist.getchildelement('itemId',null);
                
                if(itemidnode.getText()!='' && itemidnode.getText()!=null) {
                    
                    string itemid = itemidnode.gettext();
                    system.debug('Item Id' +itemid);
                    objOrderSelection.seq_no = mapProductCode.get(itemid);
                    objOrderSelection.PA_API_Message = '';
                    objOrderSelection.Earliest_Available_Date = null;
                    objOrderSelection.Available = false;
                    objOrderSelection.Available_Quantity = 0;
                }
            
                dom.xmlNode errornode = productlist.getchildelement('error',null);
                if(errornode!=null){
                    if(errornode.getText()!='' && errornode.getText()!=null) {
                        
                        string error = errornode.gettext();
                        system.debug('error' +error);
                    	objOrderSelection.PA_API_Message = error;
                    }
                    
                }else{
                    objOrderSelection.PA_API_Message = 'Success';
                    dom.xmlNode availdate = productlist.getchildelement('earliestDeliveryDate',null);
                    if(availdate!=null) {
                        if(availdate.getText()!='' && availdate.getText()!=null) {
                            
                            string itemavaildate = availdate.gettext();
                            system.debug('Earliest Delivery Date' +itemavaildate);
                            try{
                            	String earliestavaildate = itemavaildate.substring(0, 2) + '/' + itemavaildate.substring(2, 4) + '/' + itemavaildate.substring(4);
                            		objOrderSelection.Earliest_Available_Date = Date.parse(earliestavaildate);
                            }catch(Exception e){
                                System.debug('ERROR at Earliest Delivery Date: ' + e);
                            }
                        }
                    }
                    
                    dom.xmlNode prodavail = productlist.getchildelement('availability',null);
                    dom.XmlNode [] xprod = prodavail.getchildelements() ;
                    
                    for(dom.XmlNode prodavail_final: xprod){
                            system.debug('prodavail_final--> ' +prodavail_final);
                        if (prodavail_final.getname() == 'available'){
                            
                            if(prodavail_final.getText()!='' && prodavail_final.getText()!=null) {
                                
                                string availText = prodavail_final.gettext();
                                system.debug('Availability Text' +availText);
                    			objOrderSelection.Available = availText=='true'?true:false;
                            }
                        }
                        
                        if (prodavail_final.getname() == 'quantity'){
                            
                            if(prodavail_final.getText()!='' && prodavail_final.getText()!=null) {
                                
                                double Quantity;
                                string availQuanText = prodavail_final.gettext();
                                Quantity = double.valueof(availQuanText);
                                system.debug('Available Quantity' +Quantity);
                    			objOrderSelection.Available_Quantity = Integer.valueOf(Quantity);
                                
                            }
                        }
                    }
                    
                    
                    
                }
            system.debug('objOrderSelection--> ' +objOrderSelection);
            system.debug('objOrderSelection.Available_Quantity--> ' +objOrderSelection.Available_Quantity);
            system.debug('mapProductQuantity.get(objOrderSelection.seq_no)--> ' +mapProductQuantity.get(objOrderSelection.seq_no));
            
            
            lstOrderSelectionUpdate.add(objOrderSelection);
            mapOrderSelectionUpdate.put(objOrderSelection.seq_no, objOrderSelection);
                
        }
   
                renSubstitute = false;
        
        for(OrderSelection los : lstOrderSelection) {
            if(mapOrderSelectionUpdate.keyset().contains(los.seq_no)){
                los.PA_API_Message = mapOrderSelectionUpdate.get(los.seq_no).PA_API_Message;
                los.Earliest_Available_Date = mapOrderSelectionUpdate.get(los.seq_no).Earliest_Available_Date;
                los.Available = mapOrderSelectionUpdate.get(los.seq_no).Available;
                los.Available_Quantity = mapOrderSelectionUpdate.get(los.seq_no).Available_Quantity;
            if(los.Quantity>los.Available_Quantity){
                renSubstitute = true;
            }
                
            }else{
                renSubstitute = true;
            }
        }
        
        
                                system.debug('lstOrderSelection--> ' +lstOrderSelection);
        for(OrderSelection los : lstOrderSelection) {
                                system.debug('los--> ' +los);
        }        
        
         //       update lstOrderSelectionUpdate;
        
        
    }    
    */
    public PageReference calculateDeliveryDates(){
        
        setDate = new Set<String>();
        
        for(Integer sq:mapSelectedConfiguration.keySet()){
            if(mapSelectedConfiguration.get(sq)==null){
                mapSelectedConfiguration.put(sq, '');
            }
        }
        
        Integer temp_int = 0;
        Set<String> setTempId = new Set<String>();
        for(OrderSelection los:lstOrderSelection){
                mapParentUnique.put(los.seq_no, los.ProductParentUnique);
            if(mapSelectedConfiguration.get(los.seq_no)!='' && mapSelectedConfiguration.get(los.seq_no)!=null ){
                temp_int++;
                setTempId.add(los.product+mapSelectedConfiguration.get(los.seq_no));
            }
        }
        Boolean isError = false;
        if((payType == '' || payType == null) && (paymentType=='' || paymentType==null) ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select payment type')); 
            isError = true;
        }
//        if(delDate=='' || delDate==null ){
//            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select delivery date'));   
//            isError = true;
//        }
        if(setTempId.size()<temp_int){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'A Product cannot have same configuration in a single order'));   
            isError = true;
        }
        
        
        if(!isError){
        renDelivery = true;
        renLoading = true;
            payType = paymentType!=null?paymentType:payType;
            
        List<SerializeCalenderAPI> lstSerializeCalender = new List<SerializeCalenderAPI>();

        List<Contract> lstContract = new List<Contract>();
        lstContract = [SELECT Id, Name, ContractNumber, AccountId, Purchase_Number__c, SBQQ__Quote__r.SBQQ__Primary__c, SBQQ__Quote__c, Delivery_Charge__c,  
                       		SBQQ__Quote__r.SBQQ__ShippingStreet__c, SBQQ__Quote__r.SBQQ__ShippingPostalCode__c, SBQQ__Quote__r.SBQQ__ShippingCity__c, SBQQ__Quote__r.SBQQ__ShippingState__c , SBQQ__Quote__r.County_Name__c, 
                    		Account.Pricing_Tier__c, Account.Price_List_Type__c, Account.SCO_Account_ID__c, Account.Territory_ID__c, Account.NewTerritory__c, SBQQ__Quote__r.County_Code__c , SBQQ__Quote__r.GeoCode__c, 
                    		SBQQ__Quote__r.SBQQ__PrimaryContact__r.FirstName, SBQQ__Quote__r.SBQQ__PrimaryContact__r.LastName, //SBQQ__Quote__r.SBQQ__PrimaryContact__r.Email, SBQQ__Quote__r.SBQQ__PrimaryContact__r.Phone,
                    		SBQQ__Quote__r.Delivery_Contact__r.FirstName, SBQQ__Quote__r.Delivery_Contact__r.LastName, SBQQ__Quote__r.Delivery_Contact__r.Email, SBQQ__Quote__r.Delivery_Contact__r.Phone
                       FROM Contract 
                       WHERE Id=:contractId 
                       LIMIT 1
                      ];
        
                  
        system.debug('lstContract[0].Purchase_Number__c--> ' + lstContract[0].Purchase_Number__c );
        system.debug('lstContract[0].SBQQ__Quote__r.SBQQ__ShippingStreet__c--> ' + lstContract[0].SBQQ__Quote__r.SBQQ__ShippingStreet__c );
        system.debug('lstContract[0].SBQQ__Quote__r.SBQQ__ShippingPostalCode__c--> ' + lstContract[0].SBQQ__Quote__r.SBQQ__ShippingPostalCode__c );
        system.debug('lstContract[0].SBQQ__Quote__r.SBQQ__ShippingCity__c--> ' + lstContract[0].SBQQ__Quote__r.SBQQ__ShippingCity__c );
        system.debug('lstContract[0].SBQQ__Quote__r.SBQQ__ShippingState__c--> ' + lstContract[0].SBQQ__Quote__r.SBQQ__ShippingState__c );
        system.debug('lstContract[0].SBQQ__Quote__r.County_Name__c--> ' + lstContract[0].SBQQ__Quote__r.County_Name__c );
        system.debug('lstContract[0].SBQQ__Quote__r.County_Code__c--> ' + lstContract[0].SBQQ__Quote__r.County_Code__c );
        system.debug('lstContract[0].SBQQ__Quote__r.GeoCode__c--> ' + lstContract[0].SBQQ__Quote__r.GeoCode__c );
        system.debug('lstContract[0].Account.SCO_Account_ID__c--> ' + lstContract[0].Account.SCO_Account_ID__c );
        system.debug('lstContract[0].Account.NewTerritory__c--> ' + lstContract[0].Account.NewTerritory__c );
        system.debug('lstContract[0].SBQQ__Quote__r.SBQQ__PrimaryContact__r.FirstName--> ' + lstContract[0].SBQQ__Quote__r.SBQQ__PrimaryContact__r.FirstName );
        system.debug('lstContract[0].SBQQ__Quote__r.SBQQ__PrimaryContact__r.LastName--> ' + lstContract[0].SBQQ__Quote__r.SBQQ__PrimaryContact__r.LastName );
   //     system.debug('lstContract[0].SBQQ__Quote__r.SBQQ__PrimaryContact__r.Email--> ' + lstContract[0].SBQQ__Quote__r.SBQQ__PrimaryContact__r.Email );
  //      system.debug('lstContract[0].SBQQ__Quote__r.SBQQ__PrimaryContact__r.Phone--> ' + lstContract[0].SBQQ__Quote__r.SBQQ__PrimaryContact__r.Phone );
        system.debug('lstContract[0].SBQQ__Quote__r.Delivery_Contact__r.FirstName--> ' + lstContract[0].SBQQ__Quote__r.Delivery_Contact__r.FirstName );
        system.debug('lstContract[0].SBQQ__Quote__r.Delivery_Contact__r.LastName--> ' + lstContract[0].SBQQ__Quote__r.Delivery_Contact__r.LastName );
        system.debug('lstContract[0].SBQQ__Quote__r.Delivery_Contact__r.Email--> ' + lstContract[0].SBQQ__Quote__r.Delivery_Contact__r.Email );
        system.debug('lstContract[0].SBQQ__Quote__r.Delivery_Contact__r.Phone--> ' + lstContract[0].SBQQ__Quote__r.Delivery_Contact__r.Phone );
        system.debug('lstContract[0].ContractNumber--> ' + lstContract[0].ContractNumber );
        
        
        if(lstContract.size()>0){
            if(lstContract[0].Purchase_Number__c!=null 
               && lstContract[0].SBQQ__Quote__r.SBQQ__ShippingStreet__c!= null 
               && lstContract[0].SBQQ__Quote__r.SBQQ__ShippingPostalCode__c!= null 
               && lstContract[0].SBQQ__Quote__r.SBQQ__ShippingCity__c!= null 
               && lstContract[0].SBQQ__Quote__r.SBQQ__ShippingState__c!= null 
               && lstContract[0].SBQQ__Quote__r.County_Name__c!= null 
               && lstContract[0].SBQQ__Quote__r.County_Code__c!= null 
               && lstContract[0].SBQQ__Quote__r.GeoCode__c!= null 
               && lstContract[0].Account.SCO_Account_ID__c!= null 
      //         && lstContract[0].Account.Territory_ID__c!= null 
               && lstContract[0].Account.NewTerritory__c!= null 
               && lstContract[0].SBQQ__Quote__r.SBQQ__PrimaryContact__r.FirstName!= null 
               && lstContract[0].SBQQ__Quote__r.SBQQ__PrimaryContact__r.LastName!= null 
     //          && lstContract[0].SBQQ__Quote__r.SBQQ__PrimaryContact__r.Email!= null 
    //           && lstContract[0].SBQQ__Quote__r.SBQQ__PrimaryContact__r.Phone!= null 
               && lstContract[0].SBQQ__Quote__r.Delivery_Contact__r.FirstName!= null 
               && lstContract[0].SBQQ__Quote__r.Delivery_Contact__r.LastName!= null 
               && lstContract[0].SBQQ__Quote__r.Delivery_Contact__r.Email!= null 
               && lstContract[0].SBQQ__Quote__r.Delivery_Contact__r.Phone!= null 
               && lstContract[0].ContractNumber!=null
              ){
                
                  SerializeCalenderAPI objSerializeCalender = new SerializeCalenderAPI();
                  
                  //        String ran = String.valueOf(Math.mod(Math.round(Math.random()*1000000+1),1000000));
                  
                  DateTime dt = system.now();
                  
                  String str_dt = string.valueOf(dt.year()) 
                      + string.valueof(dt.month()<10?'0':'') + string.valueOf(dt.month())
                      + string.valueof(dt.day()<10?'0':'') + string.valueOf(dt.day())
                      + string.valueof(dt.hour()<10?'0':'') + string.valueOf(dt.hour())
                      + string.valueof(dt.minute()<10?'0':'') + string.valueOf(dt.minute())
                      + string.valueof(dt.second()<10?'0':'') + string.valueOf(dt.second());
                  
                  
                  system.debug('str_dt--> ' + str_dt );
                  
                  
                  objSerializeCalender.order_reference_number = 'SF_' + ordertype + '_' + lstContract[0].ContractNumber.replaceFirst( '^0+', '') + '_SF_'  + str_dt ;
                  orderreferencenumber = objSerializeCalender.order_reference_number;
                  objSerializeCalender.purchase_order_number = lstContract[0].Purchase_Number__c ;
                  objSerializeCalender.account_number = lstContract[0].Account.SCO_Account_ID__c ;
                  objSerializeCalender.delivery_charge = decimal.valueof(deliverycharge*percent_net_total).setscale(2);//Double.valueof(lstQuote[0].Delivery_Charge__c>0?lstQuote[0].Delivery_Charge__c:0 - lstQuote[0].Delivery_Discount__c>0?lstQuote[0].Delivery_Discount__c:0 ) ;
                  objSerializeCalender.delivery_tax = 0;
                  objSerializeCalender.district_id = district_id;
                  objSerializeCalender.territory_id = territory_id;
                  
                  SerializeCalenderAPI.Shipping_address objShippingInfo = new SerializeCalenderAPI.Shipping_address();
                  objShippingInfo.address_line_1=lstContract[0].SBQQ__Quote__r.SBQQ__ShippingStreet__c;
                  objShippingInfo.address_line_2='';
                  objShippingInfo.zip=lstContract[0].SBQQ__Quote__r.SBQQ__ShippingPostalCode__c;
                  objShippingInfo.city=lstContract[0].SBQQ__Quote__r.SBQQ__ShippingCity__c;
                  objShippingInfo.state=lstContract[0].SBQQ__Quote__r.SBQQ__ShippingState__c;
                  objShippingInfo.county=lstContract[0].SBQQ__Quote__r.County_Name__c;
                  objShippingInfo.county_code=lstContract[0].SBQQ__Quote__r.County_Code__c;
                  objShippingInfo.geo_code=lstContract[0].SBQQ__Quote__r.GeoCode__c;
         //         objShippingInfo.first_name=lstContract[0].SBQQ__Quote__r.SBQQ__PrimaryContact__r.FirstName;
        //          objShippingInfo.last_name=lstContract[0].SBQQ__Quote__r.SBQQ__PrimaryContact__r.LastName;
        //          objShippingInfo.email=lstContract[0].SBQQ__Quote__r.SBQQ__PrimaryContact__r.Email;
        //          objShippingInfo.phone=lstContract[0].SBQQ__Quote__r.SBQQ__PrimaryContact__r.Phone;
                  objShippingInfo.first_name=lstContract[0].SBQQ__Quote__r.Delivery_Contact__r.FirstName;
                  objShippingInfo.last_name=lstContract[0].SBQQ__Quote__r.Delivery_Contact__r.LastName;
                  objShippingInfo.email=lstContract[0].SBQQ__Quote__r.Delivery_Contact__r.Email;
                  objShippingInfo.phone=lstContract[0].SBQQ__Quote__r.Delivery_Contact__r.Phone.replaceAll('\\D','');
                  objSerializeCalender.shipping_address = objShippingInfo;

                  SerializeCalenderAPI.Payment_method objPaymentMethod = new SerializeCalenderAPI.Payment_method();
                  if(paymentType=='Credit Card' || payType=='Credit Card' ){
                      objPaymentMethod.type='CC';
                      objSerializeCalender.payment_method = objPaymentMethod;
                  }else if(paymentType=='Credit Account' || payType=='Credit Account'){
                      objPaymentMethod.type='AR';
                      objPaymentMethod.authorized_purchaser= lstContract[0].SBQQ__Quote__r.SBQQ__PrimaryContact__r.FirstName + ' ' + lstContract[0].SBQQ__Quote__r.SBQQ__PrimaryContact__r.LastName;
              //        objPaymentMethod.authorized_purchaser= lstContract[0].SBQQ__Quote__r.Delivery_Contact__r.FirstName + ' ' + lstContract[0].SBQQ__Quote__r.Delivery_Contact__r.LastName;
                      objSerializeCalender.payment_method = objPaymentMethod;
                  }else if(paymentType=='Check' || payType=='Check'){
                      objPaymentMethod.type='AR';
               //       objPaymentMethod.authorized_purchaser= lstContract[0].SBQQ__Quote__r.SBQQ__PrimaryContact__r.FirstName + ' ' + lstContract[0].SBQQ__Quote__r.SBQQ__PrimaryContact__r.LastName;
              //        objPaymentMethod.authorized_purchaser= lstContract[0].SBQQ__Quote__r.Delivery_Contact__r.FirstName + ' ' + lstContract[0].SBQQ__Quote__r.Delivery_Contact__r.LastName;
                      objPaymentMethod.authorized_purchaser= 'Check';
                      objSerializeCalender.payment_method = objPaymentMethod;
                  }
                  
                  List<SerializeCalenderAPI.Line_items> lstLineItems = new List<SerializeCalenderAPI.Line_items>();
                
                  system.debug('lstOrderSelection--> ' + lstOrderSelection );
        
                  for(OrderSelection los:lstOrderSelection){
                      system.debug('los--> ' + los );
                  }
                  
                  Map<String, List<OrderSelection>> mapFeatureOrderSelection = new Map<String, List<OrderSelection>>();
                  List<OrderSelection> lstTempOS = new List<OrderSelection>();
                  List<OrderSelection> lstParentOS = new List<OrderSelection>();
                  for(OrderSelection o:lstOrderSelection){
                    
                      if(o.feature!=null){
                          lstTempOS = new List<OrderSelection>();
                          if(mapFeatureOrderSelection.keySet().contains(o.ProductParentUnique + o.feature )){
                              lstTempOS.addAll(mapFeatureOrderSelection.get(o.ProductParentUnique + o.feature));
                          }else{
                              mapFeatureOrderSelection.put(o.ProductParentUnique + o.feature, lstTempOS);
                          }
                          lstTempOS.add(o);
                          
                          mapFeatureOrderSelection.put(o.ProductParentUnique + o.feature, lstTempOS);
                      }else{
                          lstParentOS.add(o);
                      }
                      
                  }     
                  
                  system.debug('mapFeatureOrderSelection--> ' + mapFeatureOrderSelection );
                  
                  for(OrderSelection po:lstParentOS){
                      system.debug('po--> ' + po );
                      SerializeCalenderAPI.Line_items objLineItems = new SerializeCalenderAPI.Line_items();
                      objLineItems.item_id = po.product_code;
                      objLineItems.price = double.valueof(po.list_price);
                      objLineItems.quantity = integer.valueof(po.Quantity);
                      if(po.tax_rate!=null){
                          objLineItems.tax = double.valueof((po.tax_rate*po.list_price)/po.Quantity);
                      }else{
                          objLineItems.tax = 0;
                      }
                      if(po.delivery_eligible)
                      	objLineItems.delivery_eligible = true;
                      
                      if(mapSelectedConfiguration.get(po.seq_no)!=null && mapSelectedConfiguration.get(po.seq_no)!='' ){
                          SerializeCalenderAPI.Product_configuration objConfig = new SerializeCalenderAPI.Product_configuration();
                          objConfig.item_id  = mapSelectedConfiguration.get(po.seq_no);
                          objLineItems.product_configuration = objConfig;
                      }
                      
                      for(String uft:mapFeatureOrderSelection.keyset()){
                          if(uft.contains(po.ProductParentUnique)){
                              if(uft==po.ProductParentUnique+'Parts'){
                                  List<SerializeCalenderAPI.Required_parts> lstRequiredParts = new List<SerializeCalenderAPI.Required_parts>();
                                  SerializeCalenderAPI.Required_parts objRequiredParts = new SerializeCalenderAPI.Required_parts();
                                  for(OrderSelection qlf:mapFeatureOrderSelection.get(uft)){
                                      objRequiredParts = new SerializeCalenderAPI.Required_parts();
                                      objRequiredParts.item_id = qlf.product_code;
                                      objRequiredParts.price = double.valueof(qlf.list_price);
                                      objRequiredParts.tax = double.valueof((qlf.tax_rate*qlf.list_price)/po.Quantity);
                                      lstRequiredParts.add(objRequiredParts);
                                  }
                                  objLineItems.required_parts = lstRequiredParts;
                              }else if(uft==po.ProductParentUnique+'Services'){
                                  SerializeCalenderAPI.Delivery_service objDeliveryService = new SerializeCalenderAPI.Delivery_service();
                                  SerializeCalenderAPI.Haulaway objHaulAway = new SerializeCalenderAPI.Haulaway();
                                  for(OrderSelection qlf:mapFeatureOrderSelection.get(uft)){
                                      if(qlf.product_code=='haulawayRequested'){
                                          objHaulAway = new SerializeCalenderAPI.Haulaway();
                                          objHaulAway.price = double.valueof(qlf.list_price);
                                          objHaulAway.tax = double.valueof((qlf.tax_rate*qlf.list_price)/po.Quantity);
                                          objLineItems.haulaway = objHaulAway;
                                      }else{
                                          objDeliveryService = new SerializeCalenderAPI.Delivery_service();
                                          objDeliveryService.price = double.valueof(qlf.list_price);
                                          objDeliveryService.tax = double.valueof((qlf.tax_rate*qlf.list_price)/po.Quantity);
                                          if(qlf.product_code.startsWith('01') || qlf.product_code.startsWith('4') ){
                                              objDeliveryService.item_id = 'install_J';
                                              objDeliveryService.install_service_pid = qlf.product_code;
                                          }else{
                                              objDeliveryService.item_id = qlf.product_code;
                                              objDeliveryService.install_service_pid = '';
                                          }
                                          objLineItems.delivery_service = objDeliveryService;
                                      }
                                  }
                              }
                          }
                              system.debug('objLineItems--> ' + objLineItems );
                      }
                      
                      
                      lstLineItems.add(objLineItems);
                  }
                  objSerializeCalender.line_items = lstLineItems; 
                  lstSerializeCalender.add(objSerializeCalender);
                  system.debug('lstSerializeCalender--> ' + lstSerializeCalender );
                  
              //    String JSONString_calender = JSON.serialize(lstSerializeCalender);
                  String JSONString_calender = JSON.serialize(objSerializeCalender);
                  System.debug('Serialized  JSON format: ' + JSONString_calender);
                  
                  Map<String, Common_Variables__c> mapCV = Common_Variables__c.getAll();
             //     String EndpointUrl = mapCV.get('B2BProd_Calender').Content__c;
             //     String EndpointUrl = 'https://scoapp301p.dev.ch3.s.com:2143/api/rest/delivery-dates';
             //     String EndpointUrl = 'https://KenmoreDirTRIAL331001.jitterbit.net/JitterbitDev/showCalendarApi';
                  String EndpointUrl = mapCV.get('B2BProd_Delivery_Dates_URL').Content__c;
                  String CS_CLIENT_ID = mapCV.get('B2BProd_KD_ClientId').Content__c;
                  String CS_CLIENT_SECRET = mapCV.get('B2BProd_KD_ClientSecret').Content__c;
                  String CS_CONTENT_TYPE = 'application/json';        
                  HttpRequest request = new HttpRequest();
                  HttpResponse response = new HttpResponse();
                  Http http = new Http();
                  
                  request.setHeader('Accept', CS_CONTENT_TYPE);
                  request.setHeader('Content-Type', CS_CONTENT_TYPE);
                  request.setHeader('CLIENT_ID', CS_CLIENT_ID);
                  request.setHeader('CLIENT_SECRET', CS_CLIENT_SECRET);
                  
                  request.setMethod('POST');
                  request.setendPoint(EndpointUrl);
                  system.debug('EndpointUrl >>'+EndpointUrl);
                  
                  request.setBody(JSONString_calender);
                  request.setTimeout(60000); // timeout in milliseconds
                  
                  system.debug('request >>'+request);
                  
                  CalloutB2BAPI.ResponseWrapper RW = CalloutB2BAPI.execute(request);
                  system.debug('RW>>' +RW);
                  system.debug('RW.message>>' +RW.message);
                  system.debug('RW.Response>>' +RW.Response);
                  
        List<SBQQ__Quote__c>lstQuoteBEMSuccess222 = new List<SBQQ__Quote__c>();
        lstQuoteBEMSuccess222 = [SELECT Id, Name, B2B_Order_Error_Message__c, Order_API_Request__c FROM SBQQ__Quote__c WHERE Id =: quoteId LIMIT 1];
            
            for(SBQQ__Quote__c qb:lstQuoteBEMSuccess222){
                qb.B2B_Order_Error_Message__c = (RW.message!=null?string.valueof(RW.message):'') + (RW.Response!=null?string.valueof(RW.Response):'');
                qb.Order_API_Request__c = JSONString_calender ;
            }
            system.debug('lstQuoteBEMSuccess222-->' + lstQuoteBEMSuccess222 );
            update lstQuoteBEMSuccess222;
            system.debug('lstQuoteBEMSuccess222-->' + lstQuoteBEMSuccess222 );
                  
                  
                  
            //      if(1==1){
            
             //     if(RW.message == '' && RW.Response != null){
                  if((RW.message == '' && RW.Response != null) || Test.isRunningTest() ){
                      system.debug('API response success');
                      
                      string resdoc = '';
                      
                      if(!Test.isRunningTest()){
                          system.debug('RW.Response--> ' + RW.Response );
                      //    response = http.send(request);
                      //    resdoc = response.getBody();
                          resdoc = RW.Response.getBody();
                      }else{
                          resdoc = '{ "order_reference_number": "SF_Order_Reference_Number", "delivery_dates": [ { "date": "7-01-2019" }, { "date": "7-02-2019" }, { "date": "7-03-2019" }, { "date": "7-04-2019" }, { "date": "7-05-2019" }, { "date": "7-06-2019" }, { "date": "7-07-2019" }, { "date": "7-08-2019" }, { "date": "7-09-2019" }, { "date": "7-10-2019" }, { "date": "7-11-2019" }, { "date": "7-12-2019" }, { "date": "7-13-2019" }, { "date": "7-14-2019" }, { "date": "7-15-2019" }, { "date": "7-16-2019" }, { "date": "7-17-2019" }, { "date": "7-18-2019" }, { "date": "7-19-2019" }, { "date": "7-20-2019" }, { "date": "7-21-2019" } ] }';
                      }
            
                  
                  
                  
              //       resdoc = '{ "order_reference_number": "SF_Order_Reference_Number", "delivery_dates": [ { "date": "7-01-2019" }, { "date": "7-02-2019" }, { "date": "7-03-2019" }, { "date": "7-04-2019" }, { "date": "7-05-2019" }, { "date": "7-06-2019" }, { "date": "7-07-2019" }, { "date": "7-08-2019" }, { "date": "7-09-2019" }, { "date": "7-10-2019" }, { "date": "7-11-2019" }, { "date": "7-12-2019" }, { "date": "7-13-2019" }, { "date": "7-14-2019" }, { "date": "7-15-2019" }, { "date": "7-16-2019" }, { "date": "7-17-2019" }, { "date": "7-18-2019" }, { "date": "7-19-2019" }, { "date": "7-20-2019" }, { "date": "7-21-2019" } ] }';
              //        resdoc = resdoc.replace('SF_Order_Reference_Number', orderreferencenumber);
                      system.debug('resdoc:' +resdoc);
                      
                      string resdoc1 = resdoc.replace('"date"', '"date1"');
            
                      DeserializeCalenderAPI obj = DeserializeCalenderAPI.parse(resdoc1);
                      system.debug('obj:' +obj);
                      
            
                      List<DeserializeCalenderAPI.Delivery_dates> lstDeliveryDates = new List<DeserializeCalenderAPI.Delivery_dates>();
                      lstDeliveryDates = obj.delivery_dates;
                      system.debug('lstDeliveryDates:' +lstDeliveryDates);
                      
                      string str_date = '';
                      
                      for(DeserializeCalenderAPI.Delivery_dates dd:lstDeliveryDates){
                          setDate.add(dd.date1);
                          str_date+=((str_date!=''?',':'') + dd.date1);
                      }
                      
                      List<Order_Staging__c> lstOrderStagingInsert = new List<Order_Staging__c>();
        
                      Order_Staging__c objOrderStagingInsert = new Order_Staging__c();
                      objOrderStagingInsert.Active__c = true;
                      objOrderStagingInsert.Delete_Date__c = system.now().addMinutes(15);
                      objOrderStagingInsert.Delivery_Dates__c = str_date;
                      objOrderStagingInsert.Quote__c = quoteId;
                      objOrderStagingInsert.Order_Reference_Number__c = orderreferencenumber;
                      objOrderStagingInsert.Contract__c = ordertype=='Contract'?contractId:null;
                      objOrderStagingInsert.Payment_Type__c = (payType==null || payType=='')?paymentType:payType;
                      lstOrderStagingInsert.add(objOrderStagingInsert);
                      system.debug('lstOrderStagingInsert--> ' + lstOrderStagingInsert );
                      if(isQuotePrimary){
                          insert lstOrderStagingInsert;
                      }
                     
                  }else{
               //   CalloutB2BAPI.ResponseWrapper RW;
                      if(RW.Response!=null){
                          system.debug('RW.Response>>' +RW.Response);
                          ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,RW.Response.getStatusCode() + '--> ' + RW.Response.getStatus() ));
                      }
                      if(RW.message!=null){
                      system.debug('RW.message--> ' + RW.message );
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,RW.message));
                      }
                  }
                  
                  
                  
              }else{
                  
                  
                  renDelivery = false;
                          system.debug('Missing value');
                  if(lstContract[0].Purchase_Number__c== null){
                      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Missing Purchase Number' ));
                  }
                  if(lstContract[0].SBQQ__Quote__r.SBQQ__ShippingStreet__c== null){
                      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Missing Shipping Street Address' ));
                  }
                  if(lstContract[0].SBQQ__Quote__r.SBQQ__ShippingPostalCode__c== null){
                      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Missing Shipping Zip Code' ));
                  }
                  if(lstContract[0].SBQQ__Quote__r.SBQQ__ShippingCity__c== null){
                      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Missing Shipping City' ));
                  }
                  if(lstContract[0].SBQQ__Quote__r.SBQQ__ShippingState__c== null){
                      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Missing Shipping State' ));
                  }
                  if(lstContract[0].SBQQ__Quote__r.County_Name__c== null){
                      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Missing Shipping County Name' ));
                  }
                  if(lstContract[0].SBQQ__Quote__r.County_Code__c== null){
                      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Missing Shipping County Code' ));
                  }
                  if(lstContract[0].SBQQ__Quote__r.GeoCode__c== null){
                      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Missing Shipping Geo Code' ));
                  }
                  if(lstContract[0].Account.SCO_Account_ID__c== null){
                      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Missing SCO Account Id' ));
                  }
            //      if(lstContract[0].Account.Territory_ID__c== null){
            //          ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Missing Account Territory Id' ));
            //      }
                  if(lstContract[0].Account.NewTerritory__c== null){
                      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Missing Account Territory Id' ));
                  }
                  if(lstContract[0].SBQQ__Quote__r.SBQQ__PrimaryContact__r.FirstName== null){
                      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Missing Primary Contact First Name' ));
                  }
                  if(lstContract[0].SBQQ__Quote__r.SBQQ__PrimaryContact__r.LastName== null){
                      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Missing Primary Contact Last Name' ));
                  }
                  if(lstContract[0].SBQQ__Quote__r.Delivery_Contact__r.FirstName== null){
                      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Missing Delivery Contact First Name' ));
                  }
                  if(lstContract[0].SBQQ__Quote__r.Delivery_Contact__r.LastName== null){
                      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Missing Delivery Contact Last Name' ));
                  }
                  if(lstContract[0].SBQQ__Quote__r.Delivery_Contact__r.Email== null){
                      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Missing Delivery Contact Email' ));
                  }
                  if(lstContract[0].SBQQ__Quote__r.Delivery_Contact__r.Phone== null){
                      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Missing Delivery Contact Phone' ));
                  }
                  
              }
        }        
        }else{
        renDelivery = false;
        }
       
        return null;
    }
    
    
    public PageReference actionCancel(){
        PageReference retURL = new PageReference('/' + contractId );
        retURL.setRedirect(true);
        return retURL;
    }    
    
    public void actionCreateOrder(){
        system.debug('mapSel1--> ' + mapSel1 );
        system.debug('mapSelectedConfiguration--> ' + mapSelectedConfiguration );
        for(Integer sq:mapSelectedConfiguration.keySet()){
            if(mapSelectedConfiguration.get(sq)==null){
                mapSelectedConfiguration.put(sq, '');
            }
        }
        displayPopup = true; 
    }
    
    public PageReference actionSend() {
        system.debug('mapSel1--> ' + mapSel1 );
        system.debug('mapSelectedConfiguration--> ' + mapSelectedConfiguration );
        for(Integer sq:mapSelectedConfiguration.keySet()){
            if(mapSelectedConfiguration.get(sq)==null){
                mapSelectedConfiguration.put(sq, '');
            }
        }
        system.debug('mapSelectedConfiguration--> ' + mapSelectedConfiguration );
        Integer temp_int = 0;
        Set<String> setTempId = new Set<String>();
        for(OrderSelection los:lstOrderSelection){
            if(mapSelectedConfiguration.get(los.seq_no)!='' && mapSelectedConfiguration.get(los.seq_no)!=null ){
                temp_int++;
                setTempId.add(los.product+mapSelectedConfiguration.get(los.seq_no));
            }
        }
        Boolean isError = false;
//        if(paymentType=='' || paymentType==null ){
//            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select payment type')); 
 //           isError = true;
 //       }
 //       
        if(delNote==null ){
            delNote = '';
        }
          
        if(selectedordertype==null ){
            selectedordertype = '';
        }
               
        if(delDate=='' || delDate==null ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select delivery date'));   
            isError = true;
        }
        
        if(selectedordertype=='' || selectedordertype==null ){
    //        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select Order Type'));   
    //        isError = true;
        }
        if(setTempId.size()<temp_int){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'A Product cannot have same configuration in a single order'));   
            isError = true;
        }
        system.debug('isError--> ' + isError );
   //     system.debug('selectedordertype--> ' + selectedordertype );
        
        if(!isError){
            actionSendOrderAPI();
            if(!renOrderCreateError){
        String orderId = '';
        List<Order> lstOrderInsert = new List<Order>();
        Order objOrderInsert = new Order();
        system.debug('lstOrderSelection--> ' + lstOrderSelection );
        
         //   objOrderInsert.SBQQ__Contracted__c = true;
            objOrderInsert.ContractId = contractId;
        //    objOrderInsert.SBQQ__Contracted__c = true;
            objOrderInsert.SBQQ__Quote__c = quoteId;
            objOrderInsert.AccountId = accountId;
            objOrderInsert.Status = 'Submitted';
        //    objOrderInsert.EffectiveDate = date.valueOf(delDate);
        //    objOrderInsert.Delivery_Date__c = date.valueOf(delDate);
            objOrderInsert.EffectiveDate = date.parse(delDate.replace('-', '/'));
            objOrderInsert.Delivery_Date__c = date.parse(delDate.replace('-', '/'));
            objOrderInsert.Delivery_Instruction__c = delNote;
         //   objOrderInsert.Payment_Type__c = paymentType;
            objOrderInsert.Payment_Type__c = (payType==null || payType=='')?paymentType:payType;
            objOrderInsert.Pricebook2Id='01s300000006uBlAAI';
            objOrderInsert.Delivery_Charge__c=double.valueof(decimal.valueof(deliverycharge*percent_net_total).setscale(2));
            objOrderInsert.Purchase_Number__c=purchasenumber;
            objOrderInsert.District_Id__c=district_id;
            objOrderInsert.Territory_Id__c=territory_id;
            objOrderInsert.Order_Reference_Number__c=orderreferencenumber;
            objOrderInsert.Order_Source__c='Salesforce';
            objOrderInsert.Type='Order';
            objOrderInsert.B2B_Order_Id__c = b2borderid;
            lstOrderInsert.add(objOrderInsert);
        if(isQuotePrimary){
            try{
            insert lstOrderInsert;
        		system.debug('lstOrderInsert--> ' + lstOrderInsert );
            List<Order> lstOrderQry = new List<Order>();
            lstOrderQry = [SELECT Id, Name,Type FROM Order WHERE Order_Reference_Number__c=:orderreferencenumber ORDER BY ID DESC LIMIT 1];
            if(lstOrderQry.size()>0){
                orderId = lstOrderQry[0].Id;
                insertorderid = lstOrderQry[0].Id;
        		system.debug('orderId--> ' + orderId );
        		system.debug('lstOrderQry[0].Type--> ' + lstOrderQry[0].Type );
            }
            
        List<OrderItem> lstOrderItemInsert = new List<OrderItem>();
        OrderItem objOrderItemInsert = new OrderItem();
        if(orderId!=''){
        List<PricebookEntry> lstPricebookEntry = new List<PricebookEntry>();
        Set<String> setProductId = new Set<String>();
        	for (OrderSelection os1:lstOrderSelection){
                setProductId.add(os1.product);
            }        
            
        if(setProductId.size()>0){
            lstPricebookEntry = [SELECT Id, Name, Product2Id  
                                 FROM PricebookEntry 
                                 WHERE  Product2Id IN: setProductId AND Pricebook2Id='01s300000006uBlAAI'
                                ];
            for(PricebookEntry pb:lstPricebookEntry){
    			mapProductPriceBook.put(pb.Product2Id, pb.Id);
            }
        }
            
        	for (OrderSelection os:lstOrderSelection){
        		system.debug('os--> ' + os );
                objOrderItemInsert = new OrderItem();
                objOrderItemInsert.OrderId = orderId;
                objOrderItemInsert.Product2Id = os.product;
                objOrderItemInsert.Quantity = os.Quantity;
                objOrderItemInsert.PriceBookEntryId = mapProductPriceBook.get(os.product);//'01uW000000PO0bDIAT';
                objOrderItemInsert.Configuration__c = mapSelectedConfiguration.get(os.seq_no);    
                objOrderItemInsert.Configuration_Description__c = mapConfiguration.get(mapSelectedConfiguration.get(os.seq_no)); 
                objOrderItemInsert.Order_Reference_Number__c=orderreferencenumber;
                objOrderItemInsert.Delivery_Date__c = date.parse(delDate.replace('-', '/'));
                objOrderItemInsert.Number__c = string.valueof(os.seq_no*10);
            //    objOrderItemInsert.Unique_Value__c=orderreferencenumber + string.valueof(os.seq_no*10) ;
                objOrderItemInsert.Unique_Value__c=orderreferencenumber + os.product_code ;
                if(!os.isProductParent){
               //     objOrderItemInsert.Parent_Part_Number__c=mapParentNumber.get(os.ProductParentUnique);
                    objOrderItemInsert.Parent_Part_Number__c=mapParentNumber.get(mapParentUnique.get(os.seq_no));
                    objOrderItemInsert.Unique_Value__c+=mapParentCode.get(mapParentUnique.get(os.seq_no))  ;
                }
                objOrderItemInsert.Feature__c = os.feature;
                objOrderItemInsert.isProductParent__c = os.isProductParent;
                objOrderItemInsert.ProductParentUnique__c = os.ProductParentUnique;
                objOrderItemInsert.List_Unit_Price__c = os.list_unit_price!=null?double.valueof(os.list_unit_price):0;
                objOrderItemInsert.Net_Unit_Price__c = os.net_unit_price!=null?double.valueof(os.net_unit_price):0;
                objOrderItemInsert.UnitPrice = os.net_unit_price!=null?double.valueof(os.net_unit_price):0;
                objOrderItemInsert.Disposable_Fee__c = os.disposable_fee!=null?double.valueof(os.disposable_fee):0;
                objOrderItemInsert.Tax_Rate__c = os.tax_rate!=null?double.valueof(os.tax_rate*100):0;
        //        objOrderItemInsert.SBQQ__TaxAmount__c = (((os.net_unit_price!=null?double.valueof(os.net_unit_price):0)*(os.tax_rate!=null?double.valueof(os.tax_rate):0))+(os.disposable_fee!=null?double.valueof(os.disposable_fee):0))*(os.Quantity!=null?double.valueof(os.Quantity):0) ;
        //        objOrderItemInsert.Item_Tax__c = (((os.net_unit_price!=null?double.valueof(os.net_unit_price):0)*(os.tax_rate!=null?double.valueof(os.tax_rate):0))+(os.disposable_fee!=null?double.valueof(os.disposable_fee):0))*(os.Quantity!=null?double.valueof(os.Quantity):0) ;
                objOrderItemInsert.SBQQ__TaxAmount__c = (((os.net_unit_price!=null?double.valueof(os.net_unit_price):0)*(os.tax_rate!=null?double.valueof(os.tax_rate):0))+(os.disposable_fee!=null?double.valueof(os.disposable_fee):0));
                objOrderItemInsert.Item_Tax__c = (((os.net_unit_price!=null?double.valueof(os.net_unit_price):0)*(os.tax_rate!=null?double.valueof(os.tax_rate):0))+(os.disposable_fee!=null?double.valueof(os.disposable_fee):0));
                
            	lstOrderItemInsert.add(objOrderItemInsert);
        	} 
            
                      
            if(!Test.isRunningTest()){
            	insert lstOrderItemInsert;
            }
        displayPopup = false;
        PageReference retURL = new PageReference('/' + orderId );
        retURL.setRedirect(true);
        return retURL;
            }else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Order not created'));
        displayPopup = false;
      		return null;  
        }
            
            }catch(exception e){
                system.debug('err-->' + e.getMessage() );
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
        return null;
            }
            
        }else{
                    displayPopup = false;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Selected Contract\'s Quote is not Primary. Please meake it primary to create an order.'));
        	return null;
        }
        }else{
                system.debug('Error creating Order coz some error while creating in b2b' );
            system.debug('b2bOrderErrorMessage-->' + b2bOrderErrorMessage );
        List<SBQQ__Quote__c>lstQuoteBEM = new List<SBQQ__Quote__c>();
        lstQuoteBEM = [SELECT Id, Name, B2B_Order_Error_Message__c, Order_API_Request__c FROM SBQQ__Quote__c WHERE Id =: quoteId LIMIT 1];
            
            for(SBQQ__Quote__c qb:lstQuoteBEM){
                qb.B2B_Order_Error_Message__c = b2bOrderErrorMessage;
                qb.Order_API_Request__c = orderapirequest;
            }
            system.debug('lstQuoteBEM-->' + lstQuoteBEM );
            update lstQuoteBEM;
            system.debug('lstQuoteBEM-->' + lstQuoteBEM );
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, b2bOrderErrorMessage));
       //     ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Error creating Order coz some error while creating in b2b '));
        	return null;
        }
        }else{
        	return null;
        }
    }     
    
    public void closePopup() { 
        displayPopup = false; 
    }   
    
    public PageReference actionSubstitute(){
        PageReference retURL = new PageReference('/' + contractId );
        retURL.setRedirect(true);
        return retURL;
    }
    
    public PageReference actionBackOrder(){
        PageReference retURL = new PageReference('/' + contractId );
        retURL.setRedirect(true);
        return null;
    }
    
    /*
    public PageReference actionMerge(){
        PageReference retURL = new PageReference('/apex/PdfMerge?id=' + contractId );
        retURL.setRedirect(true);
        return retURL;
    }
    */
    
    
    
    public list<selectoption> getPaymentMethod()
    {
        list<selectoption> lstSel= new list<selectoption>();
        lstSel.add(new SelectOption('', '--None--'));            
        lstSel.add(new SelectOption('Credit Card', 'Credit Card'));            
        lstSel.add(new SelectOption('Check', 'Check'));            
        lstSel.add(new SelectOption('Credit Account', 'Credit Account'));            
        return lstSel;
    }
    /*
    public list<selectoption> getDeliveryDate()
    {
        list<selectoption> lstSel= new list<selectoption>();
        for(integer i=0; i<21; i++){
        	lstSel.add(new SelectOption(string.valueof(system.today().addDays(i)), string.valueof(system.today().addDays(i))));
     //   	lstSel.add(new SelectOption(system.today().addDays(i), system.today().addDays(i)));
//            
        }
//        lstSel.add(new SelectOption('Credit Card', 'Credit Card'));            
//        lstSel.add(new SelectOption('Credit Account', 'Credit Account'));            
        return lstSel;
    }
    */
    public list<selectoption> getDeliveryDate()
    {
        list<selectoption> lstSel= new list<selectoption>();
        lstSel.add(new SelectOption('', '--None--'));   
                      
        for(String sd:setDate){
        	lstSel.add(new SelectOption(sd, sd));            
        }
        
        
        system.debug('lstSel:' +lstSel);
        
        return lstSel;
    }
    
    public void actionSendOrderAPI(){
        
        System.debug('payType ' + payType);
        System.debug('paymentType ' + paymentType);
     //   payType = paymentType!=null ?paymentType:payType;
        payType = (paymentType!=null && paymentType!='') ?paymentType:payType;
        System.debug('payType ' + payType);
        System.debug('paymentType ' + paymentType);
        
        List<SerializeCalenderAPI> lstSerializeCalender = new List<SerializeCalenderAPI>();
        
        List<Contract> lstContract = new List<Contract>();
        lstContract = [SELECT Id, Name, ContractNumber, AccountId, Purchase_Number__c, SBQQ__Quote__r.SBQQ__Primary__c, SBQQ__Quote__c, Delivery_Charge__c,  
                       SBQQ__Quote__r.SBQQ__ShippingStreet__c, SBQQ__Quote__r.SBQQ__ShippingPostalCode__c, SBQQ__Quote__r.SBQQ__ShippingCity__c, SBQQ__Quote__r.SBQQ__ShippingState__c , SBQQ__Quote__r.County_Name__c, 
                       Account.Pricing_Tier__c, Account.Price_List_Type__c, Account.SCO_Account_ID__c, Account.Territory_ID__c, Account.NewTerritory__c, SBQQ__Quote__r.County_Code__c, SBQQ__Quote__r.GeoCode__c, 
                       SBQQ__Quote__r.SBQQ__PrimaryContact__r.FirstName, SBQQ__Quote__r.SBQQ__PrimaryContact__r.LastName, //SBQQ__Quote__r.SBQQ__PrimaryContact__r.Email, SBQQ__Quote__r.SBQQ__PrimaryContact__r.Phone,
                       SBQQ__Quote__r.Delivery_Contact__r.FirstName, SBQQ__Quote__r.Delivery_Contact__r.LastName, SBQQ__Quote__r.Delivery_Contact__r.Email, SBQQ__Quote__r.Delivery_Contact__r.Phone
                       FROM Contract 
                       WHERE Id=:contractId 
                       LIMIT 1
                      ];
        
        if(lstContract.size()>0){
            if(lstContract[0].Purchase_Number__c!=null 
               && lstContract[0].SBQQ__Quote__r.SBQQ__ShippingStreet__c!= null 
               && lstContract[0].SBQQ__Quote__r.SBQQ__ShippingPostalCode__c!= null 
               && lstContract[0].SBQQ__Quote__r.SBQQ__ShippingCity__c!= null 
               && lstContract[0].SBQQ__Quote__r.SBQQ__ShippingState__c!= null 
               && lstContract[0].SBQQ__Quote__r.County_Name__c!= null 
               && lstContract[0].SBQQ__Quote__r.County_Code__c!= null 
               && lstContract[0].SBQQ__Quote__r.GeoCode__c!= null 
               && lstContract[0].Account.SCO_Account_ID__c!= null 
       //        && lstContract[0].Account.Territory_ID__c!= null 
               && lstContract[0].Account.NewTerritory__c!= null 
               && lstContract[0].SBQQ__Quote__r.SBQQ__PrimaryContact__r.FirstName!= null 
               && lstContract[0].SBQQ__Quote__r.SBQQ__PrimaryContact__r.LastName!= null 
        //       && lstContract[0].SBQQ__Quote__r.SBQQ__PrimaryContact__r.Email!= null 
       //        && lstContract[0].SBQQ__Quote__r.SBQQ__PrimaryContact__r.Phone!= null 
               && lstContract[0].SBQQ__Quote__r.Delivery_Contact__r.FirstName!= null 
               && lstContract[0].SBQQ__Quote__r.Delivery_Contact__r.LastName!= null 
               && lstContract[0].SBQQ__Quote__r.Delivery_Contact__r.Email!= null 
               && lstContract[0].SBQQ__Quote__r.Delivery_Contact__r.Phone!= null 
               && lstContract[0].ContractNumber!=null
              ){
                
                  SerializeOrderAPI objSerializeOrder = new SerializeOrderAPI();
                  
                  objSerializeOrder.order_reference_number = orderreferencenumber ;
                  objSerializeOrder.purchase_order_number = lstContract[0].Purchase_Number__c ;
                  objSerializeOrder.account_number = lstContract[0].Account.SCO_Account_ID__c ;
                  objSerializeOrder.delivery_charge = decimal.valueof(deliverycharge*percent_net_total).setscale(2);//Double.valueof(lstQuote[0].Delivery_Charge__c>0?lstQuote[0].Delivery_Charge__c:0 - lstQuote[0].Delivery_Discount__c>0?lstQuote[0].Delivery_Discount__c:0 ) ;
                  objSerializeOrder.delivery_tax = 0;
                  objSerializeOrder.district_id = district_id;
                  objSerializeOrder.territory_id = territory_id;
                  
                  
                  SerializeOrderAPI.Shipping_address objShippingInfo = new SerializeOrderAPI.Shipping_address();
                  objShippingInfo.address_line_1=lstContract[0].SBQQ__Quote__r.SBQQ__ShippingStreet__c;
                  objShippingInfo.address_line_2='';
                  objShippingInfo.zip=lstContract[0].SBQQ__Quote__r.SBQQ__ShippingPostalCode__c;
                  objShippingInfo.city=lstContract[0].SBQQ__Quote__r.SBQQ__ShippingCity__c;
                  objShippingInfo.state=lstContract[0].SBQQ__Quote__r.SBQQ__ShippingState__c;
                  objShippingInfo.county=lstContract[0].SBQQ__Quote__r.County_Name__c;
                  objShippingInfo.county_code=lstContract[0].SBQQ__Quote__r.County_Code__c;
                  objShippingInfo.geo_code=lstContract[0].SBQQ__Quote__r.GeoCode__c;
        //          objShippingInfo.first_name=lstContract[0].SBQQ__Quote__r.SBQQ__PrimaryContact__r.FirstName;
        //          objShippingInfo.last_name=lstContract[0].SBQQ__Quote__r.SBQQ__PrimaryContact__r.LastName;
       //           objShippingInfo.email=lstContract[0].SBQQ__Quote__r.SBQQ__PrimaryContact__r.Email;
       //           objShippingInfo.phone=lstContract[0].SBQQ__Quote__r.SBQQ__PrimaryContact__r.Phone;
                  objShippingInfo.first_name=lstContract[0].SBQQ__Quote__r.Delivery_Contact__r.FirstName;
                  objShippingInfo.last_name=lstContract[0].SBQQ__Quote__r.Delivery_Contact__r.LastName;
                  objShippingInfo.email=lstContract[0].SBQQ__Quote__r.Delivery_Contact__r.Email;
                  objShippingInfo.phone=lstContract[0].SBQQ__Quote__r.Delivery_Contact__r.Phone.replaceAll('\\D','');
                  objSerializeOrder.shipping_address = objShippingInfo;

                  SerializeOrderAPI.Payment_method objPaymentMethod = new SerializeOrderAPI.Payment_method();
                  if(paymentType=='Credit Card' || payType=='Credit Card' ){
                      objPaymentMethod.type='CC';
                      objSerializeOrder.payment_method = objPaymentMethod;
                  }else if(paymentType=='Credit Account' || payType=='Credit Account'){
                      objPaymentMethod.type='AR';
                      objPaymentMethod.authorized_purchaser= lstContract[0].SBQQ__Quote__r.SBQQ__PrimaryContact__r.FirstName + ' ' + lstContract[0].SBQQ__Quote__r.SBQQ__PrimaryContact__r.LastName;
           //           objPaymentMethod.authorized_purchaser= lstContract[0].SBQQ__Quote__r.Delivery_Contact__r.FirstName + ' ' + lstContract[0].SBQQ__Quote__r.Delivery_Contact__r.LastName;
                      objSerializeOrder.payment_method = objPaymentMethod;
                  }else if(paymentType=='Check' || payType=='Check'){
                      objPaymentMethod.type='AR';
           //           objPaymentMethod.authorized_purchaser= lstContract[0].SBQQ__Quote__r.SBQQ__PrimaryContact__r.FirstName + ' ' + lstContract[0].SBQQ__Quote__r.SBQQ__PrimaryContact__r.LastName;
           //           objPaymentMethod.authorized_purchaser= lstContract[0].SBQQ__Quote__r.Delivery_Contact__r.FirstName + ' ' + lstContract[0].SBQQ__Quote__r.Delivery_Contact__r.LastName;
                      objPaymentMethod.authorized_purchaser= 'Check';
                      objSerializeOrder.payment_method = objPaymentMethod;
                  }
                  
                  
                  SerializeOrderAPI.Delivery_date objDeliveryDate = new SerializeOrderAPI.Delivery_date();
                  objDeliveryDate.date1=delDate;
                  objSerializeOrder.delivery_date = objDeliveryDate;
            //      objSerializeOrder.delivery_note = '';
                  objSerializeOrder.delivery_note = delNote;
                  
                  List<SerializeOrderAPI.Line_items> lstLineItems = new List<SerializeOrderAPI.Line_items>();
                
                  system.debug('lstOrderSelection--> ' + lstOrderSelection );
        
                  for(OrderSelection los:lstOrderSelection){
                      system.debug('los--> ' + los );
                  }
                  
                  Map<String, List<OrderSelection>> mapFeatureOrderSelection = new Map<String, List<OrderSelection>>();
                  List<OrderSelection> lstTempOS = new List<OrderSelection>();
                  List<OrderSelection> lstParentOS = new List<OrderSelection>();
                  for(OrderSelection o:lstOrderSelection){
                    
                      if(o.feature!=null){
                          lstTempOS = new List<OrderSelection>();
                          if(mapFeatureOrderSelection.keySet().contains(o.ProductParentUnique + o.feature )){
                              lstTempOS.addAll(mapFeatureOrderSelection.get(o.ProductParentUnique + o.feature));
                          }else{
                              mapFeatureOrderSelection.put(o.ProductParentUnique + o.feature, lstTempOS);
                          }
                          lstTempOS.add(o);
                          
                          mapFeatureOrderSelection.put(o.ProductParentUnique + o.feature, lstTempOS);
                      }else{
                          lstParentOS.add(o);
                      }
                      
                  }     
                  
                  system.debug('mapFeatureOrderSelection--> ' + mapFeatureOrderSelection );
                  
                  for(OrderSelection po:lstParentOS){
                      system.debug('po--> ' + po );
                      SerializeOrderAPI.Line_items objLineItems = new SerializeOrderAPI.Line_items();
                      objLineItems.item_id = po.product_code;
                      objLineItems.price = double.valueof(po.list_price);
                      objLineItems.quantity = integer.valueof(po.Quantity);
                      if(po.tax_rate!=null){
                      objLineItems.tax = double.valueof((po.tax_rate*po.list_price)/po.Quantity);
                      }else{
                      objLineItems.tax = 0;
                      }
                      
                      if(mapSelectedConfiguration.get(po.seq_no)!=null && mapSelectedConfiguration.get(po.seq_no)!='' ){
                          SerializeOrderAPI.Product_configuration objConfig = new SerializeOrderAPI.Product_configuration();
                          objConfig.item_id  = mapSelectedConfiguration.get(po.seq_no);
                          objLineItems.product_configuration = objConfig;
                      }
                      
                      for(String uft:mapFeatureOrderSelection.keyset()){
                          if(uft.contains(po.ProductParentUnique)){
                              if(uft==po.ProductParentUnique+'Parts'){
                                  List<SerializeOrderAPI.Required_parts> lstRequiredParts = new List<SerializeOrderAPI.Required_parts>();
                                  SerializeOrderAPI.Required_parts objRequiredParts = new SerializeOrderAPI.Required_parts();
                                  for(OrderSelection qlf:mapFeatureOrderSelection.get(uft)){
                                      objRequiredParts = new SerializeOrderAPI.Required_parts();
                                      objRequiredParts.item_id = qlf.product_code;
                                      objRequiredParts.price = double.valueof(qlf.list_price);
                                      objRequiredParts.tax = double.valueof((qlf.tax_rate*qlf.list_price)/po.Quantity);
                                      lstRequiredParts.add(objRequiredParts);
                                  }
                                  objLineItems.required_parts = lstRequiredParts;
                              }else if(uft==po.ProductParentUnique+'Services'){
                                  SerializeOrderAPI.Delivery_service objDeliveryService = new SerializeOrderAPI.Delivery_service();
                                  SerializeOrderAPI.Haulaway objHaulAway = new SerializeOrderAPI.Haulaway();
                                  for(OrderSelection qlf:mapFeatureOrderSelection.get(uft)){
                                      if(qlf.product_code=='haulawayRequested'){
                                          objHaulAway = new SerializeOrderAPI.Haulaway();
                                          objHaulAway.price = double.valueof(qlf.list_price);
                                          objHaulAway.tax = double.valueof((qlf.tax_rate*qlf.list_price)/po.Quantity);
                                          objLineItems.haulaway = objHaulAway;
                                      }else{
                                          objDeliveryService = new SerializeOrderAPI.Delivery_service();
                                          objDeliveryService.price = double.valueof(qlf.list_price);
                                          objDeliveryService.tax = double.valueof((qlf.tax_rate*qlf.list_price)/po.Quantity);
                                          if(qlf.product_code.startsWith('01') || qlf.product_code.startsWith('4') ){
                                              objDeliveryService.item_id = 'install_J';
                                              objDeliveryService.install_service_pid = qlf.product_code;
                                          }else{
                                              objDeliveryService.item_id = qlf.product_code;
                                              objDeliveryService.install_service_pid = '';
                                          }
                                          objLineItems.delivery_service = objDeliveryService;
                                      }
                                  }
                              }
                          }
                              system.debug('1--> ' + objLineItems );
                      }
                      
                      
                      lstLineItems.add(objLineItems);
                  }
                  objSerializeOrder.line_items = lstLineItems; 
                  system.debug('objSerializeOrder--> ' + objSerializeOrder );
                  
                  
              //    String JSONString_calender = JSON.serialize(lstSerializeCalender);
              //    String JSONString_order = JSON.serialize(objSerializeOrder);
                  String JSONString_order1 = JSON.serialize(objSerializeOrder);
                  String JSONString_order = JSONString_order1.replace('"date1"', '"date"');
                  System.debug('Serialized  JSON format: ' + JSONString_order);
                  
                  orderapirequest = '';
                  orderapirequest = JSONString_order;
                  
                  Map<String, Common_Variables__c> mapCV = Common_Variables__c.getAll();
             //     String EndpointUrl = mapCV.get('B2BProd_Calender').Content__c;
             //     String EndpointUrl = 'https://scoapp301p.dev.ch3.s.com:2143/api/rest/delivery-dates';
             //     String EndpointUrl = 'https://KenmoreDirTRIAL331001.jitterbit.net/JitterbitDev/showCalendarApi';
            //      String EndpointUrl = mapCV.get('B2BProd_Delivery_Dates_URL').Content__c;
                  String EndpointUrl = mapCV.get('B2BProd_Create Order_URL').Content__c;
                  String CS_CLIENT_ID = mapCV.get('B2BProd_KD_ClientId').Content__c;
                  String CS_CLIENT_SECRET = mapCV.get('B2BProd_KD_ClientSecret').Content__c;
                  String CS_CONTENT_TYPE = 'application/json';        
                  HttpRequest request = new HttpRequest();
                  HttpResponse response = new HttpResponse();
                  Http http = new Http();
                  
                  request.setHeader('Accept', CS_CONTENT_TYPE);
                  request.setHeader('Content-Type', CS_CONTENT_TYPE);
                  request.setHeader('CLIENT_ID', CS_CLIENT_ID);
                  request.setHeader('CLIENT_SECRET', CS_CLIENT_SECRET);
                  
                  request.setMethod('POST');
                  request.setendPoint(EndpointUrl);
                  system.debug('EndpointUrl >>'+EndpointUrl);
                  
                  request.setBody(JSONString_order);
                  request.setTimeout(60000); // timeout in milliseconds
                  
                  system.debug('request >>'+request);
                  
                  CalloutB2BAPI.ResponseWrapper RW = CalloutB2BAPI.execute(request);
                  system.debug('RW>>' +RW);
                  system.debug('RW.message>>' +RW.message);
                  system.debug('RW.Response>>' +RW.Response);
                  
            //      if(1==1){
            renOrderCreateError = false;
       b2bOrderErrorMessage = '';
             //     if(RW.message == '' && RW.Response != null){
                  if((RW.message == '' && RW.Response != null) || Test.isRunningTest() ){
                      system.debug('API response success');
                      
                      string resdoc = '';
                      
                      if(!Test.isRunningTest()){
                          system.debug('RW.Response--> ' + RW.Response );
                      //    response = http.send(request);
                      //    resdoc = response.getBody();
                          resdoc = RW.Response.getBody();
                      }else{
                          resdoc = '{ "order_reference_number": "SF_OrderReferenceNumber", "order_id": 4321 }';
                      }
            
                  
                  

             //           resdoc = '{ "order_reference_number": "SF_OrderReferenceNumber", "order_id": 4321 }';
            //        resdoc = resdoc.replace('SF_OrderReferenceNumber', orderreferencenumber);
                //      
       
                      b2bOrderErrorMessage = resdoc;
                //      
                      system.debug('resdoc:' +resdoc);
                      
                      DeserializeOrderAPI obj = DeserializeOrderAPI.parse(resdoc);
                      system.debug('obj:' +obj);
                      b2borderid = string.valueof(obj.order_id);
                      /*
                     List<Order> lstOrderInsertQry = new List<Order>();
                      lstOrderInsertQry = [SELECT Id, Name, B2B_Order_Id__c FROM Order WHERE Id =: insertorderid LIMIT 1];
                      if(lstOrderInsertQry.size()>0){
                          for(Order ord:lstOrderInsertQry){
                              ord.B2B_Order_Id__c = b2borderid;
                          }
                      update lstOrderInsertQry;
                      }
                      */
                      
        List<SBQQ__Quote__c>lstQuoteBEMSuccess = new List<SBQQ__Quote__c>();
        lstQuoteBEMSuccess = [SELECT Id, Name, B2B_Order_Error_Message__c, Order_API_Request__c FROM SBQQ__Quote__c WHERE Id =: quoteId LIMIT 1];
            
            for(SBQQ__Quote__c qb:lstQuoteBEMSuccess){
                qb.B2B_Order_Error_Message__c = b2bOrderErrorMessage;
                qb.Order_API_Request__c = orderapirequest;
            }
            system.debug('lstQuoteBEMSuccess-->' + lstQuoteBEMSuccess );
            update lstQuoteBEMSuccess;
            system.debug('lstQuoteBEMSuccess-->' + lstQuoteBEMSuccess );
                      
                  }else{
                      renOrderCreateError= true;
           //       CalloutB2BAPI.ResponseWrapper RW;
                      if(RW.Response!=null){
                          system.debug('RW.Response>>' +RW.Response);
                          b2bOrderErrorMessage+=RW.Response.getStatus();
                          ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,RW.Response.getStatusCode() + '--> ' + RW.Response.getStatus() ));
                      }
                      if(RW.message!=null){
                      system.debug('RW.message--> ' + RW.message );
                          b2bOrderErrorMessage+=RW.message;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,RW.message));
                      }
                  }
                  
                  

                  
                  
              }  
        }
        
    }    
    
    public list<selectoption> getOrderType()
    {
        list<selectoption> lstSel= new list<selectoption>();
        lstSel.add(new SelectOption('', '--None--'));   
        lstSel.add(new SelectOption('1', '1'));   
              /*        
        for(String ot:lstOrderType){
        	lstSel.add(new SelectOption(ot, ot));            
        }*/
        
        
        system.debug('lstSel:' +lstSel);
        
        return lstSel;
    }
    
    public list<selectoption> getOrderType2()
    {
        list<selectoption> lstSel= new list<selectoption>();
        lstSel.add(new SelectOption('', '--None--'));   
                      
        for(String ot:lstOrderType){
        	lstSel.add(new SelectOption(ot, ot));            
        }
        
        
        system.debug('lstSel:' +lstSel);
        
        return lstSel;
    }
    
    
    
    
    public class OrderSelection{
        public Integer seq_no {get;set;}
//        public Boolean selected {get;set;}
        public String product {get;set;}
        public String product_code {get;set;}
        public String product_name {get;set;}
        public String feature {get;set;}
        public Double price {get;set;}
        public Double list_price {get;set;}
        public Boolean delivery_eligible {get;set;}
        public Integer Quantity {get;set;}
        public Boolean Available {get;set;}
        public Integer Available_Quantity {get;set;}
        public Date Earliest_Available_Date {get;set;}
        public String PA_API_Message {get;set;}
        public Boolean isProductParent {get;set;}
        public String ProductParentUnique {get;set;}
        public Double tax_rate {get;set;}
        public Double list_unit_price {get;set;}
        public Double net_unit_price {get;set;}
        public Double disposable_fee {get;set;}
    }
    
    
}