public class OrderAdjustmentSubmissionController {
    
    public String orderId {get; set;}
    public String selectedAdjustment {get; set;}
    
    public List<Order> lstOrderOverviewQry {get; set;}
    public List<OrderItem> lstOrderOverviewItemQry {get; set;}
    
    public Map<String,String> mapItemReason {get; set;}
    public String selectedReasonCode {get; set;}
    
    public Boolean isApproved {get; set;}
    public Boolean isMemo {get; set;}
    
    public Boolean renDelivery {get; set;}
    public Set<String> setDate {get; set;}
    public String delDate {get; set;}
    public String delNote {get; set;}
    public Integer noOFItems {get; set;}
    public Decimal totalDimension {get; set;}
    
    public String payType {get; set;}
    public String selectedCreditCard {get; set;}
    public List<String> lstCreditCards {get; set;}
    public Map<String, String> mapUID {get; set;}
    public String selectedAuthPurchaser {get; set;}
    
    public Boolean isStandalone {get; set;}
 //   public String standaloneSCOId {get; set;}
    public Boolean ren504Error {get; set;}
    public String ldapUserId {get; set;}
    
    public String shipZipCode {get; set;}
    public String shippingDate {get; set;}
    
    public Boolean parentCommonCarrier {get; set;}
    public String parentPayUID {get; set;}
    public String parentPayAuth {get; set;}
    public String parentPayType {get; set;}
        
    public OrderAdjustmentSubmissionController() {
        
        orderId = ApexPages.CurrentPage().getparameters().get('id');
        selectedAdjustment = ApexPages.CurrentPage().getparameters().get('adj');
        
        //    selectedAdjustment = 'Credit Memo';
        
        system.debug('orderId--> ' + orderId ); 
        system.debug('selectedAdjustment--> ' + selectedAdjustment ); 
        
        isMemo = false;
        
        if(selectedAdjustment=='Credit Memo' || selectedAdjustment=='Debit Memo' ){
            isMemo = true;
        }
        
        system.debug('isMemo--> ' + isMemo );        
        
        
        lstOrderOverviewQry = new List<Order>();
        lstOrderOverviewQry = [SELECT Id, OrderNumber, ContractId, SBQQ__Quote__c, AccountId, Status, EffectiveDate, Delivery_Date__c, 
                               		Delivery_Instruction__c, Payment_Type__c, Pricebook2Id, Delivery_Charge__c,  Parent_Order__c, 
                             		Purchase_Number__c, District_Id__c, Territory_Id__c, Order_Reference_Number__c, Order_Approver__c, 
                             		SBQQ__TaxAmount__c, B2B_Order_Id__c, Gross_Amount__c, TotalAmount,// Order_Source__c, OwnerId, 
                             		Type, Reason_Code__c, ShippingAddress, BillingAddress, ShippingStreet, ShippingCity, 
                             		ShippingState, ShippingPostalCode, BillingStreet, BillingCity, BillingState, BillingPostalCode,
                           //    		SBQQ__Quote__r.Delivery_Contact__r.FirstName, SBQQ__Quote__r.Delivery_Contact__r.LastName, 
                           //    		SBQQ__Quote__r.Delivery_Contact__r.Email, SBQQ__Quote__r.Delivery_Contact__r.Phone,
                               		Parent_Order__r.Order_Reference_Number__c, Parent_Order__r.B2B_Order_Id__c, Parent_Order__r.Delivery_Date__c, 
                               		Parent_Order__r.isCommonCarrier__c, SBQQ__Quote__r.GeoCode__c, SBQQ__Quote__r.County_Code__c, SBQQ__Quote__r.County_Name__c,
                               		SBQQ__Quote__r.SBQQ__Account__r.SCO_Account_ID__c, Haulaway_Charge__c, Premium_Delivery_Charge__c, 
                               		Geo_Code__c, County_Code__c, County_Name__c, Account.SCO_Account_ID__c, DOS_Order_Number__c, 
                               		RMA_Order_Number__c, Origin_Order_Date__c, Post_Sales_Manager_Lead__c, isCommonCarrier__c, 
                               		Shipping_Contact_First_Name__c, Shipping_Contact_Last_Name__c, Shipping_Contact_Phone__c, 
                               		Shipping_Contact_Email__c, PreHour_Trigger_Time__c, B2B_504_Error__c, Other_Taxes__c
                               FROM Order                             
                               WHERE Id=:orderId
                               LIMIT 1
                             ];
        
        system.debug('lstOrderOverviewQry--> ' + lstOrderOverviewQry );
        
        isStandalone = false;
  //      standaloneSCOId = '';
        
        if(lstOrderOverviewQry[0].Parent_Order__c==null  ){
            isStandalone = true;
 //           standaloneSCOId = lstOrderOverviewQry[0].Account.SCO_Account_ID__c;
        }
        system.debug('isStandalone--> ' + isStandalone );
  //      system.debug('standaloneSCOId--> ' + standaloneSCOId );
  //      system.debug('lstOrderOverviewQry[0].Account.SCO_Account_ID__c--> ' + lstOrderOverviewQry[0].Account.SCO_Account_ID__c );
        
        shipZipCode = '';
        shippingDate = '';
        
        if(lstOrderOverviewQry[0].ShippingPostalCode!=null && lstOrderOverviewQry[0].ShippingPostalCode!='' ){
            shipZipCode = lstOrderOverviewQry[0].ShippingPostalCode;
 //           standaloneSCOId = lstOrderOverviewQry[0].Account.SCO_Account_ID__c;
        }
        system.debug('shipZipCode--> ' + shipZipCode );
        
        selectedReasonCode = '';
        
        if(lstOrderOverviewQry[0].Reason_Code__c!=null && lstOrderOverviewQry[0].Reason_Code__c!='' ){
            List<Reason_Code__c> lstHeaderReasonCode= new List<Reason_Code__c >();
            
            lstHeaderReasonCode = [SELECT Id, Name, Div__c, Code__c, Category_Code__c, Category_Description__c, 
                                   Reason_Code__c, Reason_Description__c, Reason_Id__c, Reason_Type__c
                                   FROM Reason_Code__c
                                   WHERE Reason_Type__c != null AND Code__c =: lstOrderOverviewQry[0].Reason_Code__c
                                   LIMIT 1
                                  ];
            if(lstHeaderReasonCode[0].Reason_Description__c!=null && lstHeaderReasonCode[0].Reason_Description__c!='' ){
                selectedReasonCode = lstHeaderReasonCode[0].Reason_Description__c;
            }
            
            
        }
                
        system.debug('selectedReasonCode--> ' + selectedReasonCode );

        lstOrderOverviewItemQry = new List<OrderItem>();
        lstOrderOverviewItemQry = [SELECT Id, OrderId, Product2Id, Product2.Name, Product2.ProductCode, Product2.Fulfillment_Channel__c, Quantity, Configuration__c, 
                                 		Configuration_Description__c, Number__c, Feature__c, isProductParent__c, ProductParentUnique__c, 
                                 		Parent_Part_Number__c, Order_Reference_Number__c, Unique_Value__c, List_Unit_Price__c, Reason_Code__c, Reason_Category_Code__c, 
                                 		Net_Unit_Price__c, Net_Total_Price__c, SBQQ__TaxAmount__c, Item_Tax__c, Tax__c, Tax_Rate__c, Total_Tax_Amount__c,  
                                 		PriceBookEntryId, Disposable_Fee__c, OMS_Order_Id__c, Billable_Quantity__c, Cancelled_Quantity__c, Order_Type__c, Product_Type__c 
                                 	FROM OrderItem    
                                 	WHERE OrderId=:orderId
                                 	ORDER BY Number__c
                                 	];
        system.debug('lstOrderOverviewItemQry--> ' + lstOrderOverviewItemQry );
                
        Map<String,String> mapRCDiv = new Map<String,String>();
        
        list<Reason_Code__c > lstRCDiv= new list<Reason_Code__c >();
        lstRCDiv = [SELECT Id, Name, Div__c, Code__c, Category_Code__c, Category_Description__c, 
                    Reason_Code__c, Reason_Description__c, Reason_Id__c, Reason_Type__c  
                    FROM Reason_Code__c
                    WHERE Div__c != null AND Category_Code__c != null AND Reason_Code__c != null AND Category_Description__c != null AND Reason_Description__c != null 
                    ORDER BY Name
                   ];
        
        for(Reason_Code__c rc:lstRCDiv){
            mapRCDiv.put(rc.Div__c + rc.Category_Code__c + rc.Reason_Code__c, rc.Category_Description__c + ' - ' + rc.Reason_Description__c);
        }
        
        
        
        mapItemReason = new Map<String,String>();
        
        String selectedReasonCodeItem = '';
        
        
        for(OrderItem oi:lstOrderOverviewItemQry){
            if(oi.Reason_Code__c!=null && oi.Reason_Code__c!='' && oi.Reason_Category_Code__c!=null && oi.Reason_Category_Code__c!='' ){
                selectedReasonCodeItem = '6' + oi.Product2.ProductCode.substring(1,3) + oi.Reason_Category_Code__c + String.valueOf(Integer.valueOf(oi.Reason_Code__c));
                if(mapRCDiv.get(selectedReasonCodeItem)!=null){
                    mapItemReason.put(oi.Number__c, mapRCDiv.get(selectedReasonCodeItem));
                }else{
                	mapItemReason.put(oi.Number__c, '');
                }
            }else{
                mapItemReason.put(oi.Number__c, '');
            }
                system.debug('selectedReasonCodeItem--> ' + selectedReasonCodeItem );
        }
        
        isApproved = false;
        
        ProcessInstance objProcessInstance = new ProcessInstance();
        try{
            
            objProcessInstance = [SELECT Id, ProcessDefinitionId, ProcessDefinition.name, TargetObjectId, Status 
                                  FROM ProcessInstance 
                                  WHERE ProcessDefinition.Name = 'Order Adjustment Approval' AND TargetObjectId =: orderId 
                                  ORDER BY CreatedDate DESC 
                                  LIMIT 1
                                 ];
            system.debug('objProcessInstance--> ' + objProcessInstance );        
            if(objProcessInstance!=null){
                if(objProcessInstance.Status == 'Approved'){
                    isApproved = true;
                }
            }
            
        }catch(exception c){
            system.debug('No Approval Present' );        
        }
   //     isApproved = false;
            system.debug('isApproved--> ' + isApproved );        
        
        renDelivery = false;
        setDate = new Set<String>();
        delDate = '';
        delNote = '';
        
        noOFItems = 0;
        totalDimension = 0;
        
        noOfItems = calculateCalenderItems();           
        totalDimension = calculateCalenderDimensions().setScale(2);           
        
        system.debug('noOfItems--> ' + noOfItems );
        system.debug('totalDimension--> ' + totalDimension );
        
        payType = '';
        selectedCreditCard = '';
        lstCreditCards = new List<String>();
        mapUID = new Map<String, String>();
        selectedAuthPurchaser = '';
        ren504Error = false;
        
        ldapUserId = '';
        
        User objUser = new User();
        objUser = [SELECT Id, Name, Alias FROM User WHERE Id =: userinfo.getUserId() LIMIT 1];
        system.debug('objUser--> ' + objUser );
        
        if(objUser!=null){
            if(objUser.Alias!=null && objUser.Alias!='' ){
                ldapUserId = objUser.Alias;
            }
        }

        system.debug('ldapUserId--> ' + ldapUserId );
        
        parentCommonCarrier = false;
        parentPayUID = '';
        parentPayAuth = '';
        parentPayType = '';
                      
    }  
    
    public PageReference redirectQLE(){
        
        shippingDate = '';
        parentCommonCarrier = false;
        parentPayUID = '';
        parentPayAuth = '';
        parentPayType = '';
        
        if(selectedAdjustment == 'Exchange'){
            DOM.Document doc = new DOM.Document();
            HttpRequest request = new HttpRequest();
            HttpResponse response = new HttpResponse();
            Http http = new Http();
            
            Map<String, Common_Variables__c> mapCV = Common_Variables__c.getAll();
            //    String CS_Endpoint = mapCV.get('B2BProd_Tax_API_URL').Content__c;
            String CS_Endpoint = mapCV.get('B2BProd_ProductAvailability').Content__c;
            String CS_CLIENT_ID = mapCV.get('B2BProd_ClientId').Content__c;
            String CS_CLIENT_SECRET = mapCV.get('B2BProd_ClientSecret').Content__c;
            String CS_CONTENT_TYPE = mapCV.get('B2BProd_ContentType_XML').Content__c;
            
            String EndpointUrl = CS_Endpoint;
            String itemspayload;
            
            request.setMethod('POST');
            request.setendPoint(EndpointUrl);
            system.debug('EndpointUrl >>'+EndpointUrl);
            system.debug('CS_CLIENT_ID >>'+CS_CLIENT_ID);
            system.debug('CS_CLIENT_SECRET >>'+CS_CLIENT_SECRET);
            
            request.setHeader('Content-Type', CS_CONTENT_TYPE);
            request.setHeader('CLIENT_ID', CS_CLIENT_ID);
            request.setHeader('CLIENT_SECRET', CS_CLIENT_SECRET);
            
            dom.XmlNode xmlrequest = doc.createRootElement('request', null, null);
            dom.xmlNode zipCode = xmlrequest.addChildElement('zipCode', null, null);
            zipCode.addTextnode(shipZipCode);
            dom.xmlNode items = xmlrequest.addChildElement('items',null,null);
            
            for(OrderItem oi :lstOrderOverviewItemQry) {
                if(oi.Feature__c==null || oi.Feature__c=='' || oi.Feature__c=='Parts'){
                    
                    System.debug('Callout--> Order Items: '+oi.Product2.ProductCode);   
                    if(string.ValueOf(oi.Product2.ProductCode).startsWith('0')) {
                        system.debug('product code: ' +oi.Product2.ProductCode);
                        
                        dom.XmlNode item = items.addChildElement('item', null, null);
                        
                        dom.XmlNode itemId = item.addChildElement('itemId', null, null);
                        itemId.addTextNode(oi.Product2.ProductCode);
                        //itemId.addTextNode('02212776000');
                        
                        dom.XmlNode quantity = item.addChildElement('quantity', null, null);
                        //   quantity.addTextNode('1');
                        quantity.addTextNode(String.valueof(Integer.valueof(oi.Quantity)));
                        
                        dom.XmlNode dualStockItem = item.addChildElement('dualStockItem', null, null);
                        dualStockItem.addTextNode('false');
                        
                        if(oi.Product2.Fulfillment_Channel__c=='TW'){
                            dom.XmlNode fulfillmentChannel = item.addChildElement('fulfillmentChannel', null, null);
                            fulfillmentChannel.addTextNode('TW');
                            dom.XmlNode forceFulfillment = item.addChildElement('forceFulfillment', null, null);
                            forceFulfillment.addTextNode('DDC');
                        }
                        
                        
                        
                    }
                    
                }
            }    
            
            string req = doc.toXmlString();
            system.debug('req --> ' + req );
            request.setBody(req);
            
            
            CalloutB2BAPI.ResponseWrapper RW = CalloutB2BAPI.execute(request);
            
            system.debug('callout success>>' +RW);
            if(!Test.isRunningTest() && ((RW.message == '' && RW.Response != null) || (RW.Response.getStatusCode()!=null && RW.Response.getStatusCode()==422)) ){
                system.debug('API response success');
                
                string resdoc = RW.Response.getBody();
                system.debug('Response output message:' +RW.Response.getBody());
                
                DOM.Document docResp= new DOM.Document();
                docResp.load(resdoc);
                
                DOM.XmlNode root = docResp.getRootElement();
                system.debug('root:' + root );
                system.debug('root.getname():' + root.getname() );
                
                if(root.getname()=='response'){
                    
                    DOM.XmlNode datesXMLNode = root.getChildElement('deliveryDates', null);
                    if(datesXMLNode!=null){
                        Dom.XmlNode [] dateXMLNode = datesXMLNode.getchildelements();
                        for(dom.XmlNode date_final: dateXMLNode) {
                            system.debug('date_final.getname() --> '+ date_final.getname());
                            system.debug('date_final.gettext() --> '+ date_final.gettext());
                            if (date_final.getname() == 'date' && date_final.gettext()!=null && date_final.gettext()!='' ){
                                system.debug('date_final.gettext() --> '+ date_final.gettext());
                                Date dd = date.parse(date_final.gettext().replace('-', '/'));
                                system.debug('dd--> ' + dd );
                                String ddm = '';
                                String ddd = '';
                                if(dd!=null){
                                    if(dd.month()<10){
                                        ddm = '0' + string.valueof(dd.month());
                                    }else{
                                        ddm = string.valueof(dd.month());
                                    }
                                    if(dd.day()<10){
                                        ddd = '0' + string.valueof(dd.day());
                                    }else{
                                        ddd = string.valueof(dd.day());
                                    }
                                    shippingDate = dd.year() + '-' + ddm + '-' + ddd;
                                }
                                system.debug('shippingDate--> ' + shippingDate );                                
                          //      shippingDate = date_final.gettext();
                            }
                        }
                    }
                }else if(root.getname()=='error'){
                    DOM.XmlNode msgXMLNode = root.getChildElement('message', null);
                    if(msgXMLNode.getText()!=null){
                        system.debug('msgXMLNode.gettext() --> '+ msgXMLNode.gettext());
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Encountered following problem while quering Shipping Date:'));
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,msgXMLNode.getText()));
                    }
                }else{
                    system.debug('msgXMLNode.gettext() 1 --> User Request invalid 1. Please contact CPQ Support ');
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Encountered following problem while quering Shipping Date:'));
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'User Request invalid 1. Please contact CPQ Support'));
                }
                
            }else{
                system.debug('msgXMLNode.gettext() 2 --> User Request invalid 2. Please contact CPQ Support ');
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Encountered following problem while quering Shipping Date:'));
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'User Request invalid 2. Please contact CPQ Support'));
            }
            
        }
        
        system.debug('shippingDate --> ' + shippingDate );
        
        system.debug('lstOrderOverviewQry[0].Parent_Order__c--> ' + lstOrderOverviewQry[0].Parent_Order__c );
        
        if(lstOrderOverviewQry[0].Parent_Order__c!=null){
            if(lstOrderOverviewQry[0].Parent_Order__r.Order_Reference_Number__c!=null ){
        Map<String, Common_Variables__c> mapCV = Common_Variables__c.getAll();
            String EndpointUrl = mapCV.get('Order_Detail_API').Content__c;
            EndpointUrl += lstOrderOverviewQry[0].Parent_Order__r.Order_Reference_Number__c;
      //      String CS_CLIENT_ID = mapCV.get('Order_Detail_Client_Id').Content__c;
      //      String CS_CLIENT_SECRET = mapCV.get('Order_Detail_Client_Secret').Content__c;
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
                
                request.setMethod('GET');
                request.setendPoint(EndpointUrl);
                system.debug('EndpointUrl >>'+EndpointUrl);
                system.debug('CS_CLIENT_ID >>'+CS_CLIENT_ID);
                system.debug('CS_CLIENT_SECRET >>'+CS_CLIENT_SECRET);
                
                request.setTimeout(60000); // timeout in milliseconds
                
                system.debug('request >>'+request);
            
                CalloutB2BAPI.ResponseWrapper RW = CalloutB2BAPI.execute(request);
                system.debug('RW>>' +RW);
                system.debug('RW.message>>' +RW.message);
                system.debug('RW.Response>>' +RW.Response);
                                       
                if((RW.message == '' && RW.Response != null) ){
          //      if(1==1 ){
                    system.debug('API response success');
                    
                    string resdoc = '';
                    
                    if(!Test.isRunningTest() ){
            //    if(RW.message == '' && RW.Response != null){
                        system.debug('RW.Response--> ' + RW.Response );
                        //    response = http.send(request);
                        //    resdoc = response.getBody();
                        resdoc = RW.Response.getBody();
                    }else{
                        resdoc = '{ "order_reference_number": "SF_ADJUSTMENT_CMR_20191210110149", "account_number": "1100000007", "order_no": "0800000999", "originating_doc_no": "", "type": "CMR", "source": "", "status": "Submitted", "territory_id": "01936", "district_id": "08473", "shippig_address": { "address_line_1": "beverly st\n1 n dearborn", "address_line_2": "TCD", "zip": "60179", "city": "hoffman estates", "state": "IL", "county": "" }, "payment_method": { "type": "CC" }, "items": [ { "oms_order_id": "", "item_number": "10", "item_id": "02213000000", "item_type": "item", "price": -100.0, "quantity": 1, "salescheck_number": "", "billable_quantity": 0, "cancelled_quantity": 1, "cancelled_tax": "0.0", "cancelled_special_tax": "0.0", "tax": 0.0, "status": "Completed", "parent_item_number": "0", "parent_part_number": "", "status_changes": [ { "status": "Completed", "billable_quantity": 0, "cancelled_quantity": 1, "cancelled_tax": "0.0", "cancelled_special_tax": "0.0", "updated_at": "12/10/2019 21:12:07" } ] }, { "oms_order_id": "", "item_number": "20", "item_id": "40010500223", "item_type": "item", "price": -50.0, "quantity": 2, "salescheck_number": "", "billable_quantity": 0, "cancelled_quantity": 2, "cancelled_tax": "0.0", "cancelled_special_tax": "0.0", "tax": 0.0, "status": "Completed", "parent_item_number": "0", "parent_part_number": "", "status_changes": [ { "status": "Completed", "billable_quantity": 0, "cancelled_quantity": 2, "cancelled_tax": "0.0", "cancelled_special_tax": "0.0", "updated_at": "12/10/2019 21:12:07" } ] }, { "oms_order_id": "", "item_number": "30", "item_id": "07022206000", "item_type": "item", "price": -25.0, "quantity": 4, "salescheck_number": "", "billable_quantity": 0, "cancelled_quantity": 4, "cancelled_tax": "0.0", "cancelled_special_tax": "0.0", "tax": 0.0, "status": "Completed", "parent_item_number": "0", "parent_part_number": "", "status_changes": [ { "status": "Completed", "billable_quantity": 0, "cancelled_quantity": 4, "cancelled_tax": "0.0", "cancelled_special_tax": "0.0", "updated_at": "12/10/2019 21:12:07" } ] } ] }';                 
                    }

                    resdoc = resdoc.replaceAll('\n','').replaceAll('\r','');
                    resdoc = resdoc.replaceAll('"type"', '"type1"');
                    system.debug('resdoc:' +resdoc);
                      
                    string b2borderid = '';
                      DeserializeOrderDetailAPI obj = DeserializeOrderDetailAPI.parse(resdoc);
                      system.debug('obj:' +obj);
                      b2borderid = string.valueof(obj.order_no);
                    system.debug('b2borderid --> ' + b2borderid );
                    system.debug('obj.payment_method.uid --> ' + obj.payment_method.uid );
                    system.debug('obj.payment_method.type1 --> ' + obj.payment_method.type1 );
                    system.debug('obj.payment_method.authorized_purchaser --> ' + obj.payment_method.authorized_purchaser );
                    system.debug('obj.common_carrier --> ' + obj.common_carrier );
				//		objOrder.B2B_Order_Id__c = b2borderid;
        
                    parentCommonCarrier = false;
                    
                    if(obj.common_carrier!=null ){
                        parentCommonCarrier = obj.common_carrier;
                    }
                    
                    if(obj.payment_method.uid!=null ){
                        parentPayUID = obj.payment_method.uid;
                    }
                    
                    if(obj.payment_method.authorized_purchaser!=null ){
                        parentPayAuth = obj.payment_method.authorized_purchaser;
                        selectedAuthPurchaser = obj.payment_method.authorized_purchaser;
                    }
                    
                    if(obj.payment_method.type1!=null ){
                        parentPayType = obj.payment_method.type1;
                    }
                    
           //         parentPayUID = '7e335110fa5c0136e0e8001a4a00005b';
           //         parentPayAuth = 'Auth Test';
           //         parentPayType = 'CC';
           //         parentCommonCarrier = true;
                } 
                
            }
        }

        system.debug('parentPayUID --> ' + parentPayUID );
        system.debug('parentPayAuth --> ' + parentPayAuth );
        system.debug('parentPayType --> ' + parentPayType );
        system.debug('parentCommonCarrier --> ' + parentCommonCarrier );
        system.debug('selectedAuthPurchaser--> ' + selectedAuthPurchaser );
        
        return null;
        
    }
    
    
    
    public PageReference actionGoToEdit(){
        
            if(isStandalone){
        PageReference retURL = new PageReference('/apex/StandaloneEdit?id=' + orderId + '&adj=' + selectedAdjustment );
        retURL.setRedirect(true);
        return retURL;
            }else{
        PageReference retURL = new PageReference('/apex/OrderAdjustmentEdit?id=' + orderId + '&adj=' + selectedAdjustment );
        retURL.setRedirect(true);
        return retURL;
            }
        
    }
    
    public PageReference actionGoToOrderHeader(){
        PageReference retURL = new PageReference('/' + orderId );
        retURL.setRedirect(true);
        return retURL;
    }
    
    public PageReference submitApprovalRequest(){
            
        Approval.ProcessSubmitRequest req1 = 
            new Approval.ProcessSubmitRequest();
        req1.setComments('Submitting request for approval.');
        req1.setObjectId(orderId);
        
        req1.setSubmitterId(userinfo.getUserId()); 
        
        req1.setProcessDefinitionNameOrId('Order_Adjustment_Approval');
        req1.setSkipEntryCriteria(true);
        if(!Test.isRunningTest() ){
        Approval.ProcessResult result = Approval.process(req1);
        
        List<Id> newWorkItemIds = result.getNewWorkitemIds();
        system.debug('result.getInstanceStatus()--> ' + result.getInstanceStatus());
        system.debug('result.isSuccess()--> ' + result.isSuccess());
        system.debug('newWorkItemIds--> ' + newWorkItemIds);
        }
        PageReference retURL = new PageReference('/' + orderId );
        retURL.setRedirect(true);
        return retURL;
        
    }
    
    public Integer calculateCalenderItems(){
        Integer no_itms = 0;
        
        for(OrderItem oi:lstOrderOverviewItemQry){
            if(oi.Feature__c==null || oi.Feature__c=='Parts' ){
                no_itms += Integer.valueOf(oi.Quantity);
            }
        }
        
        system.debug('no_itms--> ' + no_itms );
        
        return no_itms;
    }
    
    
    public Decimal calculateCalenderDimensions(){
        Decimal total_dim = 0;
        
        Set<String> setSelectedProducts = new Set<String>();
        
        for(OrderItem oi:lstOrderOverviewItemQry){
            if(oi.Feature__c==null || oi.Feature__c=='Parts' ){
                setSelectedProducts.add(oi.Product2Id);
            }
        }
        
        
        List<Product_Specification__c> lstProdSpec = new List<Product_Specification__c>();
        lstProdSpec = [SELECT Id, Name, Product__c, Product__r.ProductCode, Specification__c, Specification_Name__c 
                       FROM Product_Specification__c 
                       WHERE Product__c IN:setSelectedProducts AND Specification_Name__c IN ('Length', 'Width', 'Height')
                      ];
        system.debug('lstProdSpec--> ' + lstProdSpec );
        
        Map<String, String> mapProdSpec = new Map<String, String>();
        for(Product_Specification__c ps:lstProdSpec){
            mapProdSpec.put(ps.Product__c+ps.Specification_Name__c, ps.Specification__c);
        }
        system.debug('mapProdSpec--> ' + mapProdSpec );
        
        for(OrderItem oi:lstOrderOverviewItemQry){
            if( (oi.Feature__c==null || oi.Feature__c=='Parts') 
               && mapProdSpec.get(oi.Product2Id+'Length')!= null 
               && mapProdSpec.get(oi.Product2Id+'Width') != null
               && mapProdSpec.get(oi.Product2Id+'Height') != null
              ){
                total_dim += (Double.valueOf(mapProdSpec.get(oi.Product2Id+'Length')) * Double.valueOf(mapProdSpec.get(oi.Product2Id+'Width')) * Double.valueOf(mapProdSpec.get(oi.Product2Id+'Height')) * oi.Quantity )/1728;
            }
        }
         
        system.debug('total_dim--> ' + total_dim );
        
        return total_dim;
    }

    
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
    
    
    public void calculateDeliveryDates(){
        
        system.debug('shippingDate >>'+shippingDate);
        
        SerializeAdjustmentDeliveryAPI objSerializeDelivery = new SerializeAdjustmentDeliveryAPI();
        
        objSerializeDelivery = new SerializeAdjustmentDeliveryAPI();
        
        SerializeAdjustmentDeliveryAPI.DeliveryCalendarRequest objDelCal = new SerializeAdjustmentDeliveryAPI.DeliveryCalendarRequest();
        objDelCal.clientCode = 'COMM';
        objDelCal.sellingStoreID = '09346';
        objDelCal.timeWindow = 'ALL';
        objDelCal.servicetime = '10';
        objDelCal.cubes = totalDimension;
        objDelCal.nofItems = noOfItems;
        if(selectedAdjustment!='Exchange'){
            objDelCal.startDate = string.valueOf(system.today());
        }else{
            if(shippingDate!=null && shippingDate!='' ){
                objDelCal.startDate = string.valueOf(shippingDate);
            }
        }
     //   objDelCal.startDate = string.valueOf(system.today());
        objDelCal.address1 = lstOrderOverviewQry[0].ShippingStreet;
        objDelCal.address2 = '';
        objDelCal.city = lstOrderOverviewQry[0].ShippingCity;
        objDelCal.state = lstOrderOverviewQry[0].ShippingState;
        objDelCal.zip = lstOrderOverviewQry[0].ShippingPostalCode;

        objSerializeDelivery.deliveryCalendarRequest = objDelCal;
        
        String JSONString_delivery = JSON.serialize(objSerializeDelivery);
                  
        System.debug('Serialized  JSON format: ' + JSONString_delivery);
                  
        Map<String, Common_Variables__c> mapCV = Common_Variables__c.getAll();
                  
     //   String EndpointUrl = mapCV.get('B2BProd_Create Order_URL').Content__c;
     //   String CS_CLIENT_ID = mapCV.get('B2BProd_KD_ClientId').Content__c;
     //   String CS_CLIENT_SECRET = mapCV.get('B2BProd_KD_ClientSecret').Content__c;
        String CS_CLIENT_ID = mapCV.get('B2BProd_ClientId').Content__c;
        String CS_CLIENT_SECRET = mapCV.get('B2BProd_ClientSecret').Content__c;
     //   String EndpointUrl = 'https://KenmoreDirTRIAL331001.jitterbit.net/JitterbitDev/returnDeliveryCalendarApi';
        String EndpointUrl = mapCV.get('Adjustment_Calendar_API').Content__c;
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
        
        request.setBody(JSONString_delivery);
        request.setTimeout(60000); // timeout in milliseconds
        
        system.debug('request >>'+request);
        
        CalloutB2BAPI.ResponseWrapper RW = CalloutB2BAPI.execute(request);
        system.debug('RW>>' +RW);
        system.debug('RW.message>>' +RW.message);
        system.debug('RW.Response>>' +RW.Response);
        
        if((RW.message == '' && RW.Response != null) || Test.isRunningTest() ){
            system.debug('API response success');
            
            string resdoc = '';
            
            if(!Test.isRunningTest()){
                system.debug('RW.Response--> ' + RW.Response );
                resdoc = RW.Response.getBody();
            }else{
                resdoc = '{ "deliveryCalendarResponse": { "retCode": 0, "retReason": "SUCCESS", "zip": 60179, "timeSlotList": [ { "windowCode": "AM", "dates": [ "2019-09-06", "2019-09-13", "2019-09-20", "2019-09-27", "2019-10-04" ] }, { "windowCode": "TBS", "dates": [ "2019-09-03", "2019-09-04", "2019-09-06", "2019-09-07", "2019-09-09", "2019-09-10", "2019-09-11", "2019-09-13", "2019-09-14", "2019-09-16", "2019-09-17", "2019-09-18", "2019-09-20", "2019-09-21", "2019-09-23", "2019-09-24", "2019-09-25", "2019-09-27", "2019-09-28", "2019-09-30", "2019-10-01" ] }, { "windowCode": "E", "dates": [ "2019-09-03", "2019-09-04", "2019-09-05", "2019-09-06", "2019-09-07", "2019-09-09", "2019-09-10", "2019-09-11", "2019-09-12", "2019-09-13", "2019-09-14", "2019-09-16", "2019-09-17", "2019-09-18", "2019-09-19", "2019-09-20", "2019-09-21", "2019-09-23", "2019-09-24", "2019-09-25", "2019-09-26", "2019-09-27", "2019-09-28", "2019-09-30", "2019-10-01" ] }, { "windowCode": "U", "dates": [ "2019-09-03", "2019-09-04", "2019-09-05", "2019-09-06", "2019-09-07", "2019-09-09", "2019-09-10", "2019-09-11", "2019-09-12", "2019-09-13", "2019-09-14", "2019-09-16", "2019-09-17", "2019-09-18", "2019-09-19", "2019-09-20", "2019-09-21", "2019-09-23", "2019-09-24", "2019-09-25", "2019-09-26", "2019-09-27", "2019-09-28", "2019-09-30", "2019-10-01" ] }, { "windowCode": "H", "dates": [ "2019-09-03", "2019-09-04", "2019-09-05", "2019-09-06", "2019-09-07", "2019-09-09", "2019-09-10", "2019-09-11", "2019-09-12", "2019-09-13", "2019-09-14", "2019-09-16", "2019-09-17", "2019-09-18", "2019-09-19", "2019-09-20", "2019-09-21", "2019-09-23", "2019-09-24", "2019-09-25", "2019-09-26", "2019-09-27", "2019-09-28", "2019-09-30", "2019-10-01" ] } ] } }';
            }
            
      //      system.debug('resdoc:' +resdoc);
            
            DeserializeAdjustmentDeliveryAPI obj = DeserializeAdjustmentDeliveryAPI.parse(resdoc);
            system.debug('obj:' +obj);
            
            system.debug('obj.DeliveryCalendarResponse.retReason:' +obj.DeliveryCalendarResponse.retReason);
            
            if(obj.DeliveryCalendarResponse.retReason=='SUCCESS'){
            
                List<DeserializeAdjustmentDeliveryAPI.TimeSlotList> lstDeliveryDatesAll = new List<DeserializeAdjustmentDeliveryAPI.TimeSlotList>();
                if(obj.DeliveryCalendarResponse.TimeSlotList!=null ) {
                    lstDeliveryDatesAll = obj.DeliveryCalendarResponse.TimeSlotList;
                }
                
                setDate = new Set<String>();
        
                for(DeserializeAdjustmentDeliveryAPI.TimeSlotList dc:lstDeliveryDatesAll){
                 //   system.debug('dc--> ' + dc);
                    if(dc.windowCode == 'TBS'){
                        system.debug('dc.dates--> ' + dc.dates);
                        setDate.addAll(dc.dates);
                    }

                }
                
                
            }else{
                
            }
            
        }else{
                      if(RW.Response!=null){
                          system.debug('RW.Response>>' +RW.Response);
                              ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Encountered following error response while submitting order --> ' + RW.Response ));
                      }
                      if(RW.message!=null){
                      system.debug('RW.message--> ' + RW.message );
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Encountered following error message while submitting order --> ' + RW.message));
                      }
        }
        
        renDelivery = true;
       
        
    }
    
    
    
    public list<selectoption> getPaymentMethod()
    {
        list<selectoption> lstSel= new list<selectoption>();
        lstSel.add(new SelectOption('', '--None--'));          
        if(selectedAdjustment!='Exchange'){
            lstSel.add(new SelectOption('Credit Card', 'Credit Card'));   
        }
        lstSel.add(new SelectOption('Account Receivable', 'Account Receivable'));            
        return lstSel;
    }
    
    public list<selectoption> getCreditCardPaymentMethod()
    {
        list<selectoption> lstSel= new list<selectoption>();
        lstSel.add(new SelectOption('', '--None--'));            
        for(String cc:lstCreditCards){
        	lstSel.add(new SelectOption(cc, mapUID.get(cc)));            
        }
        system.debug('lstSel:' +lstSel);
        return lstSel;
    }
    
    public PageReference actionPayment(){
        system.debug('payType--> ' + payType );
        system.debug('selectedCreditCard--> ' + selectedCreditCard );
        
        if(payType==null){
            payType = '';
        }
        if(selectedCreditCard==null || payType!='Credit Card' ){
            selectedCreditCard = '';
        }
        
        system.debug('payType--> ' + payType );
        system.debug('selectedCreditCard--> ' + selectedCreditCard );
        
        lstCreditCards = new List<String>();
        mapUID = new Map<String, String>();
        if(payType=='Credit Card'){
            
      //      https://api.b2b.sears.com/api/kd/rest/payment_options/{account_number}
      //      https://scoapp301p.dev.ch3.s.com:2253/admin
      //      https://scoapp301p.dev.ch3.s.com:2243/api/rest/payment_options/1100000007
                //     String CS_CLIENT_ID = mapCV.get('B2BProd_KD_ClientId').Content__c;
                //     
        Map<String, Common_Variables__c> mapCV = Common_Variables__c.getAll();
            String CS_Authorization = mapCV.get('Adjustment_Payment_Auth').Content__c;
     //       String CS_LDAP_USER = mapCV.get('Adjustment_Payment_LDAP_User').Content__c;
                //     
        String EndpointUrl_CC = mapCV.get('Adjustment_Payment_API').Content__c;
    //        EndpointUrl_CC = 'https://KenmoreDirTRIAL331001.jitterbit.net/kd/rest/payment_options/';

    //        String CS_CLIENT_ID = mapCV.get('Order_Detail_Client_Id').Content__c;
    //        String CS_CLIENT_SECRET = mapCV.get('Order_Detail_Client_Secret').Content__c;
            String CS_CLIENT_ID = mapCV.get('B2BProd_KD_ClientId').Content__c;
            String CS_CLIENT_SECRET = mapCV.get('B2BProd_KD_ClientSecret').Content__c;
            
            String CS_CONTENT_TYPE = 'application/json';  
            /*
            if(isStandalone){
    //    EndpointUrl_CC = 'https://scoapp301p.dev.ch3.s.com:2243/api/rest/payment_options/' + standaloneSCOId ;
        EndpointUrl_CC += lstOrderOverviewQry[0].Account.SCO_Account_ID__c ;                
            }else{
        EndpointUrl_CC += lstOrderOverviewQry[0].SBQQ__Quote__r.SBQQ__Account__r.SCO_Account_ID__c ;
            }
        */
            
        EndpointUrl_CC += lstOrderOverviewQry[0].Account.SCO_Account_ID__c ;                
            
        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        Http http = new Http();
        
        
        request.setMethod('GET');
            
    //    request.setHeader('Authorization', 'eyJhbGciOiJSUzI1NiJ9.eyJuYW1lIjoiU0NPX0NvbXBhbnkiLCJzYW5kYm94IjpmYWxzZX0.GFuPwz1OwoB8y7cb12h0iSsTsl5la2ltMofdSZyHjjSBWi5SPv2mByCmtZroN1hax1GHs7AOlQqzlKGOVg_r_2728sY7XpEkwpb9omo3t4H4Q0LxZkvusEM9tz9XMMEBfhl_IAvAwgCYlyYpB-Z5Ewt1wVkVvI-dwJIS6HvghV4nyySMGCC632dB9zsIgwpKjfozWVFxIamq0mOhviJwbdqi55BiHpNvukESbzNx8Yqqu1M7q3ePl0TRwfOaoG1E-jZZZ_naZV6hCZgPyB1U8J8GisWHz7kqTQAjreQjMKFA6YShgdI4LOXsEADtXN2mU9iliasGDpRn-ZtSXuYl5w');
    //    request.setHeader('LDAP_USER_ID', 'akuma35');
   //     request.setHeader('Authorization', CS_Authorization);
  //      request.setHeader('LDAP_USER_ID', CS_LDAP_USER);
            request.setHeader('Content-Type', CS_CONTENT_TYPE);
            request.setHeader('Accept', CS_CONTENT_TYPE);
                   request.setHeader('CLIENT_ID', CS_CLIENT_ID);
                   request.setHeader('CLIENT_SECRET', CS_CLIENT_SECRET);
            
            
        request.setendPoint(EndpointUrl_CC);
        system.debug('EndpointUrl_CC >>'+EndpointUrl_CC);
        
        request.setTimeout(60000); // timeout in milliseconds
        
        system.debug('request >>'+request);
        system.debug('Accept >>'+CS_CONTENT_TYPE);
        system.debug('CLIENT_ID >>'+CS_CLIENT_ID);
        system.debug('CLIENT_SECRET >>'+CS_CLIENT_SECRET);
        
        CalloutB2BAPI.ResponseWrapper RW = CalloutB2BAPI.execute(request);
        system.debug('RW>>' +RW);
        system.debug('RW.message>>' +RW.message);
        system.debug('RW.Response>>' +RW.Response);
            
            string resdoc = '';
            
        if((RW.message == '' && RW.Response != null) || Test.isRunningTest() ){
            system.debug('API response success');
            
            
            if(!Test.isRunningTest()){
                system.debug('RW.Response--> ' + RW.Response );
                resdoc = RW.Response.getBody();
            }else{
            //    resdoc = '{ "credit_cards": [ { "display_name": "DI_2347", "uid": "258b6c40f1d50136c8c00c85908b7b37", "expiry": "1120", "default": false }, { "display_name": "VI_0026", "uid": "258e5d10f1d50136c8c00c85908b7b37", "expiry": "1220", "default": false }, { "display_name": "VI_0026", "uid": "258e78d0f1d50136c8c00c85908b7b37", "expiry": "1220", "default": false }, { "display_name": "VI_0026", "uid": "258ec700f1d50136c8c00c85908b7b37", "expiry": "1219", "default": false } ] }';
                resdoc = '{ "credit_cards": [ { "display_name": "DI_5134", "uid": "b3ab14d06e920137e2be001a4a00005b", "expiry": "1220", "default": false }, { "display_name": "VI_5072", "uid": "ea367430ff6e0136e106001a4a00005b", "expiry": "1220", "default": false }, { "display_name": "VI_0026", "uid": "d49398d06eaf0137e2c1001a4a00005b", "expiry": "1121", "default": false }, { "display_name": "SCO_1725", "uid": "73e006c078b10137e2f5001a4a00005b", "expiry": "1298", "default": false }, { "display_name": "MC_1732", "uid": "ea395e90ff6e0136e106001a4a00005b", "expiry": "0121", "default": false }, { "display_name": "MC_0016", "uid": "b2e303c0ffc80136e10a001a4a00005b", "expiry": "1229", "default": false }, { "display_name": "SCP_7429", "uid": "602564b02ea20137e1ef001a4a00005b", "expiry": "1122", "default": false }, { "display_name": "SCP_7429", "uid": "f7c962002ec40137e1ed001a4a00005b", "expiry": "1122", "default": false }, { "display_name": "SMC_4400", "uid": "5b5fefc078b10137e2f6001a4a00005b", "expiry": "1223", "default": false }, { "display_name": "YMC_9600", "uid": "5b3c8a5071130137e2dd001a4a00005b", "expiry": "1220", "default": false }, { "display_name": "YMC_9600", "uid": "8664447078aa0137e2f6001a4a00005b", "expiry": "1299", "default": true }, { "display_name": "YMC_9600", "uid": "02eecc0074070137e2e7001a4a00005b", "expiry": "1299", "default": false } ] }';
            }
            
                      system.debug('resdoc:' +resdoc);
                      
                      string resdoc1 = resdoc.replace('"default"', '"default1"');
                      system.debug('resdoc1:' +resdoc1);
            
            DeserializePaymentOptionsAPI obj = DeserializePaymentOptionsAPI.parse(resdoc1);
            system.debug('obj:' +obj);
            system.debug('obj.credit_cards:' +obj.credit_cards);
            
                List<DeserializePaymentOptionsAPI.CreditCards> lstCreditCardsAll = new List<DeserializePaymentOptionsAPI.CreditCards>();
                if(obj.credit_cards!=null ) {
                    lstCreditCardsAll = obj.credit_cards;
                }
            
            String expdt = '';
            String displayPay = '';
            
            system.debug('parentPayUID --> ' + parentPayUID );
            system.debug('parentPayAuth --> ' + parentPayAuth );
            system.debug('parentPayType --> ' + parentPayType );
            system.debug('parentCommonCarrier --> ' + parentCommonCarrier );
            system.debug('selectedCreditCard--> ' + selectedCreditCard );
            
            for(DeserializePaymentOptionsAPI.CreditCards occ:lstCreditCardsAll){
                system.debug('occ:' +occ);
                
                if(occ.expiry!=null){
                    if(occ.expiry.length()==4){
                        expdt = occ.expiry.substring(0,2) + '/01/20' + occ.expiry.substring(2);
                        if(date.parse(expdt)>system.today()){
                            system.debug('1');
                            displayPay = occ.display_name + 
                                		' - Exp_' + occ.expiry.substring(0,2) + '/' + occ.expiry.substring(2);
                            if(occ.default1==true){
                                displayPay += ' - (Default)';
                            }
                            lstCreditCards.add(occ.uid);
                            mapUID.put(occ.uid, displayPay );
                            if(parentPayUID.equals(occ.uid)){
                                selectedCreditCard = occ.uid;
                            }
                        }
                    }
                }                
                
            }
            
            system.debug('parentPayUID--> ' + parentPayUID );
            system.debug('selectedCreditCard--> ' + selectedCreditCard );
            
        }else{
            
                      if(RW.Response!=null){
                          system.debug('RW.Response>>' +RW.Response);
                              ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Encountered following error response while retrieving cards --> ' + RW.Response ));
                      }
                      if(RW.message!=null){
                      system.debug('RW.message--> ' + RW.message );
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Encountered following error message while retrieving cards --> ' + RW.message));
                      }
            /*
          //      resdoc = '{ "credit_cards": [ { "display_name": "DI_2347", "uid": "258b6c40f1d50136c8c00c85908b7b37", "expiry": "1120", "default": false }, { "display_name": "VI_0026", "uid": "258e5d10f1d50136c8c00c85908b7b37", "expiry": "1220", "default": false }, { "display_name": "VI_0026", "uid": "258e78d0f1d50136c8c00c85908b7b37", "expiry": "1220", "default": false }, { "display_name": "VI_0026", "uid": "258ec700f1d50136c8c00c85908b7b37", "expiry": "1219", "default": false } ] }';
                resdoc = '{ "credit_cards": [ { "display_name": "DI_5134", "uid": "b3ab14d06e920137e2be001a4a00005b", "expiry": "1220", "default": false }, { "display_name": "VI_5072", "uid": "ea367430ff6e0136e106001a4a00005b", "expiry": "1220", "default": false }, { "display_name": "VI_0026", "uid": "d49398d06eaf0137e2c1001a4a00005b", "expiry": "1121", "default": false }, { "display_name": "SCO_1725", "uid": "73e006c078b10137e2f5001a4a00005b", "expiry": "1298", "default": false }, { "display_name": "MC_1732", "uid": "ea395e90ff6e0136e106001a4a00005b", "expiry": "0121", "default": false }, { "display_name": "MC_0016", "uid": "b2e303c0ffc80136e10a001a4a00005b", "expiry": "1229", "default": false }, { "display_name": "SCP_7429", "uid": "602564b02ea20137e1ef001a4a00005b", "expiry": "1122", "default": false }, { "display_name": "SCP_7429", "uid": "f7c962002ec40137e1ed001a4a00005b", "expiry": "1122", "default": false }, { "display_name": "SMC_4400", "uid": "5b5fefc078b10137e2f6001a4a00005b", "expiry": "1223", "default": false }, { "display_name": "YMC_9600", "uid": "5b3c8a5071130137e2dd001a4a00005b", "expiry": "1220", "default": false }, { "display_name": "YMC_9600", "uid": "8664447078aa0137e2f6001a4a00005b", "expiry": "1299", "default": true }, { "display_name": "YMC_9600", "uid": "02eecc0074070137e2e7001a4a00005b", "expiry": "1299", "default": false } ] }';
        
                      system.debug('resdoc:' +resdoc);
                      
                      string resdoc1 = resdoc.replace('"default"', '"default1"');
                      system.debug('resdoc1:' +resdoc1);
            
            DeserializePaymentOptionsAPI obj = DeserializePaymentOptionsAPI.parse(resdoc1);
            system.debug('obj:' +obj);
            system.debug('obj.credit_cards:' +obj.credit_cards);
            
                List<DeserializePaymentOptionsAPI.CreditCards> lstCreditCardsAll = new List<DeserializePaymentOptionsAPI.CreditCards>();
                if(obj.credit_cards!=null ) {
                    lstCreditCardsAll = obj.credit_cards;
                }
            
            String expdt = '';
            String displayPay = '';
            
            for(DeserializePaymentOptionsAPI.CreditCards occ:lstCreditCardsAll){
                system.debug('occ:' +occ);
                
                if(occ.expiry!=null){
                    if(occ.expiry.length()==4){
                        expdt = occ.expiry.substring(0,2) + '/01/20' + occ.expiry.substring(2);
                        if(date.parse(expdt)>system.today()){
                            system.debug('1');
                            displayPay = occ.display_name + 
                                		' - Exp_' + occ.expiry.substring(0,2) + '/' + occ.expiry.substring(2);
                            if(occ.default1==true){
                                displayPay += ' - (Default)';
                            }
                            lstCreditCards.add(occ.uid);
                            mapUID.put(occ.uid, displayPay );
                        }
                    }
                }                
                
            }
        */
        
        }
            
            
        }
        
        system.debug('selectedCreditCard--> ' + selectedCreditCard );
        return null;
    }
    
    public PageReference actionCreditCardPayment(){
        system.debug('payType--> ' + payType );
        system.debug('selectedCreditCard--> ' + selectedCreditCard );
        
        if(payType==null){
            payType = '';
        }
        if(selectedCreditCard==null || payType!='Credit Card' ){
            selectedCreditCard = '';
        }
        
        system.debug('payType--> ' + payType );
        system.debug('selectedCreditCard--> ' + selectedCreditCard );
        
        
        return null;
    }
    
    public PageReference actionSendOrderAPI() {
        
        system.debug('isMemo--> ' + isMemo );
        system.debug('delDate--> ' + delDate );
        system.debug('delNote--> ' + delNote );
        system.debug('payType--> ' + payType );
        system.debug('selectedAuthPurchaser--> ' + selectedAuthPurchaser );
        system.debug('selectedCreditCard--> ' + selectedCreditCard );
        
        
        List<String> lstErrorMessage = new List<String>();
        
        if((delDate == null || delDate == '') && !isMemo ){
            lstErrorMessage.add('Please select Pick-up Date');
        }
        if((payType == null || payType == '') && selectedAdjustment != 'Exchange'){
    //    if((payType == null || payType == '') ){
            lstErrorMessage.add('Please select Payment Type');
        }
    //    if((selectedAuthPurchaser == null || selectedAuthPurchaser == '') && selectedAdjustment != 'Exchange'){
        if((selectedAuthPurchaser == null || selectedAuthPurchaser == '') ){
            lstErrorMessage.add('Please enter Authorized Purchaser');
        }
        if((selectedCreditCard == null || selectedCreditCard == '') && payType == 'Credit Card'  && selectedAdjustment != 'Exchange' ){
   //     if((selectedCreditCard == null || selectedCreditCard == '') && payType == 'Credit Card' ){
            lstErrorMessage.add('Please select Credit Card');
        }
        
        if(lstErrorMessage.size()>0){
            for(String em:lstErrorMessage){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, em));   
            }
        }else{
            
                String JSONString_order1 = '';
            
            if(selectedAdjustment=='Credit Memo' || selectedAdjustment=='Debit Memo' ){
                
                SerializeCDOrderAPI objSerializeCDOrder = new SerializeCDOrderAPI();
                
                objSerializeCDOrder.order_reference = lstOrderOverviewQry[0].Order_Reference_Number__c;
                objSerializeCDOrder.purchase_order_number = lstOrderOverviewQry[0].Purchase_Number__c;
                if(lstOrderOverviewQry[0].Parent_Order__c!=null){
                    if(lstOrderOverviewQry[0].Parent_Order__r.B2B_Order_Id__c!=null)
                    objSerializeCDOrder.order_id = lstOrderOverviewQry[0].Parent_Order__r.B2B_Order_Id__c.replaceFirst('^0+','');
                }else{
                    objSerializeCDOrder.order_id = '';
                }
                objSerializeCDOrder.reason_code = lstOrderOverviewQry[0].Reason_Code__c;
                if(selectedAdjustment=='Credit Memo'){
                    objSerializeCDOrder.category = 'cmr';
                }else if(selectedAdjustment=='Debit Memo'){
                    objSerializeCDOrder.category = 'dmr';
                }
                /*
            if(isStandalone){
     //           objSerializeCDOrder.account_number = standaloneSCOId;
                objSerializeCDOrder.account_number = lstOrderOverviewQry[0].Account.SCO_Account_ID__c;
            }else{
                objSerializeCDOrder.account_number = lstOrderOverviewQry[0].SBQQ__Quote__r.SBQQ__Account__r.SCO_Account_ID__c;
            }
                */
                objSerializeCDOrder.account_number = lstOrderOverviewQry[0].Account.SCO_Account_ID__c;
                System.debug('objSerializeCDOrder.account_number ' + objSerializeCDOrder.account_number);
                
                  SerializeCDOrderAPI.Shipping_address objShippingCDInfo = new SerializeCDOrderAPI.Shipping_address();
                  objShippingCDInfo.address_line_1 = lstOrderOverviewQry[0].ShippingStreet;
             //     objShippingCDInfo.address_line_2 = 'TCD';
                  objShippingCDInfo.address_line_2 = '';
                  objShippingCDInfo.zip = lstOrderOverviewQry[0].ShippingPostalCode;
                  objShippingCDInfo.city = lstOrderOverviewQry[0].ShippingCity;
                  objShippingCDInfo.state = lstOrderOverviewQry[0].ShippingState;
              //    objShippingCDInfo.county = lstOrderOverviewQry[0].ShippingStreet;
              //    objShippingCDInfo.geo_code = isStandalone?lstOrderOverviewQry[0].Geo_Code__c:lstOrderOverviewQry[0].SBQQ__Quote__r.GeoCode__c;
              //    objShippingCDInfo.county_code = isStandalone?lstOrderOverviewQry[0].County_Code__c:lstOrderOverviewQry[0].SBQQ__Quote__r.County_Code__c;
             //     objShippingCDInfo.county_name = isStandalone?lstOrderOverviewQry[0].County_Name__c:lstOrderOverviewQry[0].SBQQ__Quote__r.County_Name__c;
                  objShippingCDInfo.geo_code = lstOrderOverviewQry[0].Geo_Code__c;
                  objShippingCDInfo.county_code = lstOrderOverviewQry[0].County_Code__c;
                  objShippingCDInfo.county_name = lstOrderOverviewQry[0].County_Name__c;
                  objShippingCDInfo.first_name = lstOrderOverviewQry[0].Shipping_Contact_First_Name__c;
                  objShippingCDInfo.last_name = lstOrderOverviewQry[0].Shipping_Contact_Last_Name__c;
                  objShippingCDInfo.email = string.valueOf(lstOrderOverviewQry[0].Shipping_Contact_Email__c);
                  objShippingCDInfo.day_phone = string.valueOf(lstOrderOverviewQry[0].Shipping_Contact_Phone__c);
                  objSerializeCDOrder.shipping_address = objShippingCDInfo;
                
                  System.debug('objShippingCDInfo ' + objShippingCDInfo);
                
                  SerializeCDOrderAPI.Payment_method objPaymentMethodCD = new SerializeCDOrderAPI.Payment_method();
                  if(payType=='Credit Card' ){
                      objPaymentMethodCD.type='CC';
                      objPaymentMethodCD.authorized_purchaser= selectedAuthPurchaser;
                      if(selectedCreditCard!=null){
                          objPaymentMethodCD.uid=selectedCreditCard;
                      }
                  }else if(payType=='Account Receivable'){
                      objPaymentMethodCD.type='AR';
                      objPaymentMethodCD.authorized_purchaser= selectedAuthPurchaser;
                  }
                      objSerializeCDOrder.payment_method = objPaymentMethodCD;
                
                  System.debug('objPaymentMethodCD ' + objPaymentMethodCD);
                
                List<SerializeCDOrderAPI.items> lstItems = new List<SerializeCDOrderAPI.items>();
                SerializeCDOrderAPI.Items objItems = new SerializeCDOrderAPI.Items();
                
                for (OrderItem oos: lstOrderOverviewItemQry) {
                    system.debug('oos--> ' + oos );
                    system.debug('oos.Product_Type__c--> ' + oos.Product_Type__c );
                    //   if(oos.Feature==null || oos.Feature=='' || oos.Feature=='Parts' ){
                        objItems = new SerializeCDOrderAPI.Items();
                        objItems.part_number = oos.Product2.ProductCode;
                        objItems.selling_price = oos.Net_Unit_Price__c;
                        objItems.list_price = (oos.List_Unit_Price__c!=0 && oos.List_Unit_Price__c!=null )?oos.List_Unit_Price__c:oos.Net_Unit_Price__c;
                        objItems.quantity = Integer.valueOf(oos.Quantity);
                        objItems.type = (oos.Product_Type__c!=null && oos.Product_Type__c!='')?oos.Product_Type__c:'OrderItem';
                        system.debug('objItems--> ' + objItems );
                        lstItems.add(objItems);
                }
                objSerializeCDOrder.items = lstItems;
                
                System.debug('lstItems ' + lstItems);
                system.debug('objSerializeCDOrder--> ' + objSerializeCDOrder );
                
                JSONString_order1 = JSON.serialize(objSerializeCDOrder);
                
            }else if(selectedAdjustment=='Return' || selectedAdjustment=='Exchange' ){
                
                SerializeRXOrderAPI objSerializeRXOrder = new SerializeRXOrderAPI();
                
                objSerializeRXOrder.order_reference = lstOrderOverviewQry[0].Order_Reference_Number__c;
                objSerializeRXOrder.purchase_order_number = lstOrderOverviewQry[0].Purchase_Number__c;
          //      objSerializeRXOrder.common_carrier_location = lstOrderOverviewQry[0].Parent_Order__r.isCommonCarrier__c;
          //      objSerializeRXOrder.common_carrier_location = true;
          //      objSerializeRXOrder.common_carrier_location = lstOrderOverviewQry[0].isCommonCarrier__c;
                
                if(lstOrderOverviewQry[0].Parent_Order__c!=null){
                    if(lstOrderOverviewQry[0].Parent_Order__r.B2B_Order_Id__c!=null){
                    	objSerializeRXOrder.order_id = lstOrderOverviewQry[0].Parent_Order__r.B2B_Order_Id__c.replaceFirst('^0+','');
                        objSerializeRXOrder.common_carrier_location = parentCommonCarrier;
                    }
                }else{
                    objSerializeRXOrder.order_id = '';
                    objSerializeRXOrder.original_order_date = string.valueof(lstOrderOverviewQry[0].Origin_Order_Date__c);
                    objSerializeRXOrder.original_rma_number = lstOrderOverviewQry[0].RMA_Order_Number__c;
                    objSerializeRXOrder.order_reservation_number = lstOrderOverviewQry[0].DOS_Order_Number__c;
                    objSerializeRXOrder.common_carrier_location = lstOrderOverviewQry[0].isCommonCarrier__c;
                }
                System.debug('objSerializeRXOrder.order_id ' + objSerializeRXOrder.order_id);
                objSerializeRXOrder.reason_code = lstOrderOverviewQry[0].Reason_Code__c;
                objSerializeRXOrder.category = selectedAdjustment;
           //     objSerializeRXOrder.account_number = isStandalone?standaloneSCOId:lstOrderOverviewQry[0].SBQQ__Quote__r.SBQQ__Account__r.SCO_Account_ID__c;
           //     objSerializeRXOrder.account_number = isStandalone?lstOrderOverviewQry[0].Account.SCO_Account_ID__c:lstOrderOverviewQry[0].SBQQ__Quote__r.SBQQ__Account__r.SCO_Account_ID__c;
                objSerializeRXOrder.account_number = lstOrderOverviewQry[0].Account.SCO_Account_ID__c;
                System.debug('isStandalone ' + isStandalone);
                System.debug('objSerializeRXOrder.account_number ' + objSerializeRXOrder.account_number);
                objSerializeRXOrder.delivery_charge = lstOrderOverviewQry[0].Delivery_Charge__c;
                objSerializeRXOrder.premium_delivery_charge = lstOrderOverviewQry[0].Premium_Delivery_Charge__c;
                objSerializeRXOrder.haulaway_charge = lstOrderOverviewQry[0].Haulaway_Charge__c;
                
                objSerializeRXOrder.pickup_date = delDate;
             //   objSerializeRXOrder.delivery_instructions = delNote;
                objSerializeRXOrder.delivery_instructions = lstOrderOverviewQry[0].Delivery_Instruction__c;
                

                  SerializeRXOrderAPI.Shipping_address objShippingRXInfo = new SerializeRXOrderAPI.Shipping_address();
                  objShippingRXInfo.address_line_1 = lstOrderOverviewQry[0].ShippingStreet;
             //     objShippingRXInfo.address_line_2 = 'TRX';
                  objShippingRXInfo.address_line_2 = '';
                  objShippingRXInfo.zip = lstOrderOverviewQry[0].ShippingPostalCode;
                  objShippingRXInfo.city = lstOrderOverviewQry[0].ShippingCity;
                  objShippingRXInfo.state = lstOrderOverviewQry[0].ShippingState;
              //    objShippingRXInfo.county = lstOrderOverviewQry[0].ShippingStreet;
              //    objShippingRXInfo.geo_code = isStandalone?lstOrderOverviewQry[0].Geo_Code__c:lstOrderOverviewQry[0].SBQQ__Quote__r.GeoCode__c;
              //    objShippingRXInfo.county_code = isStandalone?lstOrderOverviewQry[0].County_Code__c:lstOrderOverviewQry[0].SBQQ__Quote__r.County_Code__c;
              //    objShippingRXInfo.county_name = isStandalone?lstOrderOverviewQry[0].County_Name__c:lstOrderOverviewQry[0].SBQQ__Quote__r.County_Name__c;
                  objShippingRXInfo.geo_code = lstOrderOverviewQry[0].Geo_Code__c;
                  objShippingRXInfo.county_code = lstOrderOverviewQry[0].County_Code__c;
                  objShippingRXInfo.county_name = lstOrderOverviewQry[0].County_Name__c;
                  objShippingRXInfo.first_name = lstOrderOverviewQry[0].Shipping_Contact_First_Name__c;
                  objShippingRXInfo.last_name = lstOrderOverviewQry[0].Shipping_Contact_Last_Name__c;
                  objShippingRXInfo.email = string.valueOf(lstOrderOverviewQry[0].Shipping_Contact_Email__c);
                  objShippingRXInfo.day_phone = string.valueOf(lstOrderOverviewQry[0].Shipping_Contact_Phone__c);
                  objSerializeRXOrder.shipping_address = objShippingRXInfo;
                
                  System.debug('objShippingRXInfo ' + objShippingRXInfo);
                SerializeRXOrderAPI.Payment_method objPaymentMethodRX = new SerializeRXOrderAPI.Payment_method();
                
                if(selectedAdjustment != 'Exchange'){
                    if(payType=='Credit Card' ){
                        objPaymentMethodRX.type='CC';
                        objPaymentMethodRX.authorized_purchaser= selectedAuthPurchaser;
                        objPaymentMethodRX.uid='';
                        if(selectedCreditCard!=null){
                            objPaymentMethodRX.uid=selectedCreditCard;
                        }
                    }else if(payType=='Account Receivable'){
                        objPaymentMethodRX.type='AR';
                        objPaymentMethodRX.authorized_purchaser= selectedAuthPurchaser;
                        //    objPaymentMethodRX.uid='';
                    }
                }else{
                    system.debug('parentPayUID --> ' + parentPayUID );
                    system.debug('parentPayAuth --> ' + parentPayAuth );
                    system.debug('parentPayType --> ' + parentPayType );
                    objPaymentMethodRX.type=parentPayType;
              //      objPaymentMethodRX.authorized_purchaser= parentPayAuth;
                    objPaymentMethodRX.authorized_purchaser= selectedAuthPurchaser;
                    if(parentPayUID!=null){
                        objPaymentMethodRX.uid=parentPayUID;
                    }
                }
                
                objSerializeRXOrder.payment_method = objPaymentMethodRX;
                System.debug('objPaymentMethodRX ' + objPaymentMethodRX);
                
                
                
                List<OrderItem> lstOrderOverviewItemQryParent = new List<OrderItem>();
                
                for (OrderItem oos: lstOrderOverviewItemQry) {
                    system.debug('oos--> ' + oos );
                    system.debug('oos.Product_Type__c--> ' + oos.Product_Type__c );
                    system.debug('oos.Number__c--> ' + oos.Number__c );
                    if(oos.Parent_Part_Number__c==null){
                        lstOrderOverviewItemQryParent.add(oos);
                    }
                }
                
                List<SerializeRXOrderAPI.items> lstItems = new List<SerializeRXOrderAPI.items>();
                SerializeRXOrderAPI.Items objItems = new SerializeRXOrderAPI.Items();
                     
                List<SerializeRXOrderAPI.Required_parts> lstRequiredParts = new List<SerializeRXOrderAPI.Required_parts>();
                SerializeRXOrderAPI.Required_parts objRequiredParts = new SerializeRXOrderAPI.Required_parts();
                
                List<SerializeRXOrderAPI.Delivery_option> lstDeliveryoption = new List<SerializeRXOrderAPI.Delivery_option>();
                SerializeRXOrderAPI.Delivery_option objDeliveryoption = new SerializeRXOrderAPI.Delivery_option();
                
                
                for (OrderItem oosp: lstOrderOverviewItemQryParent) {
                    
                    objItems = new SerializeRXOrderAPI.Items();
                    
                    objItems.part_number = oosp.Product2.ProductCode;
                    objItems.selling_price = oosp.Net_Unit_Price__c;
                //    objItems.list_price = oosp.List_Unit_Price__c;
                //    objItems.original_price = oosp.List_Unit_Price__c;
                    objItems.list_price = (oosp.List_Unit_Price__c!=0 && oosp.List_Unit_Price__c!=null )?oosp.List_Unit_Price__c:oosp.Net_Unit_Price__c;
                    objItems.original_price = (oosp.List_Unit_Price__c!=0 && oosp.List_Unit_Price__c!=null )?oosp.List_Unit_Price__c:oosp.Net_Unit_Price__c;
                    objItems.quantity = Integer.valueOf(oosp.Quantity);
                    objItems.type = oosp.Product_Type__c;
                    
                    objItems.return_reason_code = oosp.Reason_Code__c;
                    objItems.return_category_code = oosp.Reason_Category_Code__c;
                    /*
                if(oosp.ReasonCode!=null){
                    if(oosp.ReasonCode.length()>5  && !oosp.ReasonCode.contains('null') ){
                    //    objItems.return_reason_code = oosp.ReasonCode.substring(3,5);
                        objItems.return_category_code = oosp.ReasonCode.substring(3,5);
                        if(oosp.ReasonCode.substring(5).length()==1){
                   //         objItems.return_category_code = '0' + oosp.ReasonCode.substring(5);
                            objItems.return_reason_code = '0' + oosp.ReasonCode.substring(5);
                        }else if(oosp.ReasonCode.substring(5).length()==2){
                   //         objItems.return_category_code = oosp.ReasonCode.substring(5);
                            objItems.return_reason_code = oosp.ReasonCode.substring(5);
                        }
                    }
                }
                    */
                
                    lstRequiredParts = new List<SerializeRXOrderAPI.Required_parts>();
                    objRequiredParts = new SerializeRXOrderAPI.Required_parts();
                    for (OrderItem oos: lstOrderOverviewItemQry) {
                    system.debug('oos.Feature__c--> ' + oos.Feature__c );
                    system.debug('oos.Parent_Part_Number__c--> ' + oos.Parent_Part_Number__c );
                    system.debug('oosp.Number__c--> ' + oosp.Number__c );
                        if(oos.Feature__c == 'Parts' && (oos.Parent_Part_Number__c == oosp.Number__c) ){
                            objRequiredParts = new SerializeRXOrderAPI.Required_parts();
                            objRequiredParts.part_number = oos.Product2.ProductCode;
                            objRequiredParts.price = oos.Net_Unit_Price__c;
                            objRequiredParts.original_price = (oos.List_Unit_Price__c!=0 && oos.List_Unit_Price__c!=null )?oos.List_Unit_Price__c:oos.Net_Unit_Price__c;
                            objRequiredParts.return_reason_code = oos.Reason_Code__c;
                            objRequiredParts.return_category_code = oos.Reason_Category_Code__c;
                       /*     
                if(oos.ReasonCode!=null){
                    if(oos.ReasonCode.length()>5  && !oos.ReasonCode.contains('null') ){
                //        objRequiredParts.return_reason_code = oos.ReasonCode.substring(3,5);
                        objRequiredParts.return_category_code = oos.ReasonCode.substring(3,5);
                        if(oos.ReasonCode.substring(5).length()==1){
                //        objRequiredParts.return_reason_code = oos.ReasonCode.substring(3,5);
                        objRequiredParts.return_reason_code = '0' + oos.ReasonCode.substring(5);
                        }else if(oos.ReasonCode.substring(5).length()==2){
               //             objRequiredParts.return_category_code = oos.ReasonCode.substring(5);
                            objRequiredParts.return_reason_code = oos.ReasonCode.substring(5);
                        }
                    }
                }
                            */
                            
                            lstRequiredParts.add(objRequiredParts);
                            objItems.required_parts = lstRequiredParts;
                        }
                    }
                    
                objDeliveryoption = new SerializeRXOrderAPI.Delivery_option();
                    for (OrderItem oos: lstOrderOverviewItemQry) {
                    system.debug('oos.Feature__c--> ' + oos.Feature__c );
                    system.debug('oos.Parent_Part_Number__c--> ' + oos.Parent_Part_Number__c );
                    system.debug('oosp.Number__c--> ' + oosp.Number__c );
                   //     if(oos.Feature__c == 'Services' && oos.ProductParentUnique == oosp.ProductParentUnique ){
                        if(oos.Feature__c == 'Services' && (oos.Parent_Part_Number__c == oosp.Number__c) ){
                            objDeliveryoption = new SerializeRXOrderAPI.Delivery_option();
                            objDeliveryoption.description = oos.Product2.Name;
                            objDeliveryoption.addon_price = oos.Net_Unit_Price__c;
                            if(oos.Product2.ProductCode.startsWith('01') || oos.Product2.ProductCode.startsWith('4') ){
                                objDeliveryoption.option_code = 'install_J';
                                objDeliveryoption.part_number = oos.Product2.ProductCode;
                            }else{
                                objDeliveryoption.option_code = oos.Product2.ProductCode;
                            }
                            objItems.delivery_option = objDeliveryoption;
                        }
                    }
                    
                    lstItems.add(objItems);
                    
                }
                
                
                
                
                objSerializeRXOrder.items = lstItems;
                
                System.debug('lstItems ' + lstItems);
                system.debug('objSerializeRXOrder--> ' + objSerializeRXOrder );
                
                
                JSONString_order1 = JSON.serialize(objSerializeRXOrder);
                
                
            }
            
                System.debug('JSONString_order1 --> ' + JSONString_order1 );
            
                //    String JSONString_order = '{ "adjustment_reference": "SF_ADJUSTMENT_LUVTEST1", "purchase_order_number": "1235", "order_id": "3551", "reason_code": "A08", "category": "cmr", "account_number": "1100000007", "shipping_address": { "address_line_1": "1 N Dearborn St", "address_line_2": "Suite 400", "zip": "60179", "city": "Hoffman Estates", "state": "IL", "county": "cook", "first_name": "Silpa", "last_name": "yerra", "email": "anilkumar.peechara@searshc.com", "day_phone": "1234567890" }, "payment_method": { "type": "CC", "authorized_purchaser": "John Doe", "uid": "536ea120ff6f01362412001a4a000047" }, "items": [ { "part_number": "04601332000", "selling_price": 949.99, "quantity": 2, "type":"Catalog" }, { "part_number": "40095615000", "selling_price": 15, "list_price": 15, "quantity": 1, "type":"Adjustment" }, { "part_number": "02665093000", "selling_price": 423.05, "list_price": 420.00, "quantity": 1, "type":"OrderItem" }, { "part_number": "07002244000", "selling_price": 423.05, "list_price": 420.00, "quantity": 1, "type":"PAWarranty" }, { "part_number": "07091551000", "selling_price": 423.05, "list_price": 420.00, "quantity": 1, "type":"InstallationService" } ] }';
                String JSONString_order = '{ "order_reference": "SF_ADJUSTMENT_LUVTEST2", "purchase_order_number": "1235", "common_carrier_location": false, "order_id": "", "reason_code": "S01", "category": "EXCHANGE", "delivery_charge": 55, "premium_delivery_charge": 10, "haulaway_charge": 15, "account_number": "1100000007", "original_rma_number": "43501231234", "order_reservation_number": "872000682000", "original_order_date": "2018-12-31", "pickup_date": "2019-10-15", "delivery_instructions": "Do not deliver the product", "shipping_address": { "address_line_1": "1 N Dearborn St", "address_line_2": "Suite 400", "zip": "60179", "city": "Hoffman Estates", "state": "IL", "county": "cook", "first_name": "Silpa", "last_name": "yerra", "email": "anilkumar.peechara@searshc.com", "day_phone": "1234567890" }, "payment_method": { "type": "CC", "authorized_purchaser": "John Doe", "uid": "" }, "items": [ { "part_number": "02665093000", "selling_price": 1599.99, "list_price": 1599.99, "original_price": 1500, "quantity": 1, "type":"OrderItem", "return_reason_code": "02", "return_category_code": "30", "required_parts": [{ "part_number": "02657000000", "price": 17.99, "original_price": "17.00", "return_reason_code": "02", "return_category_code": "30" }], "delivery_option": { "description": "BrownBox", "option_code": "brownbox_10", "addon_price": 50 } } ] }';
                System.debug('Serialized  JSON format: ' + JSONString_order);
                
                //     String EndpointUrl = mapCV.get('B2BProd_Create Order_URL').Content__c;
                //     String CS_CLIENT_ID = mapCV.get('B2BProd_KD_ClientId').Content__c;
                //     String CS_CLIENT_SECRET = mapCV.get('B2BProd_KD_ClientSecret').Content__c;
                //     String CS_CONTENT_TYPE = 'application/json';  
        Map<String, Common_Variables__c> mapCV = Common_Variables__c.getAll();
                String EndpointUrl = mapCV.get('Adjustment_Order_API').Content__c;//https://KenmoreDirTRIAL331001.jitterbit.net/ProductloadSF/orderAdjustmentApi';
            /*
            if(isMemo){
       //         EndpointUrl += 'orderAdjustmentApi';
                EndpointUrl += 'orderAdjustmentApi';
            }else{
                EndpointUrl += 'adjustmentReturnExchangeCreate';
            }
            */
             //   EndpointUrl = 'https://KenmoreDirTRIAL331001.jitterbit.net/kd/rest/adjustments';


    //        String CS_CLIENT_ID = mapCV.get('Order_Detail_Client_Id').Content__c;
    //        String CS_CLIENT_SECRET = mapCV.get('Order_Detail_Client_Secret').Content__c;
            String CS_CLIENT_ID = mapCV.get('B2BProd_KD_ClientId').Content__c;
            String CS_CLIENT_SECRET = mapCV.get('B2BProd_KD_ClientSecret').Content__c;
            
     //       String CS_Authorization = mapCV.get('Adjustment_Payment_Auth').Content__c;
     //       String CS_LDAP_USER = mapCV.get('Adjustment_Payment_LDAP_User').Content__c;
            
            
            
                String CS_CONTENT_TYPE = 'application/json';  
                
                HttpRequest request = new HttpRequest();
                HttpResponse response = new HttpResponse();
                Http http = new Http();
                
                request.setHeader('Accept', CS_CONTENT_TYPE);
                request.setHeader('Content-Type', CS_CONTENT_TYPE);
                request.setHeader('CLIENT_ID', CS_CLIENT_ID);
                request.setHeader('CLIENT_SECRET', CS_CLIENT_SECRET);
       //     request.setHeader('Authorization', CS_Authorization);
            request.setHeader('LDAP_USER_ID', ldapUserId);
            
            
                request.setMethod('POST');
                request.setendPoint(EndpointUrl);
                system.debug('EndpointUrl >>'+EndpointUrl);
                
                request.setBody(JSONString_order1);
                request.setTimeout(60000); // timeout in milliseconds
                
                system.debug('request >>'+request);
            /*
            if(isMemo){
						lstOrderOverviewQry[0].B2B_Order_Id__c = '08000001234';
            }else{
						lstOrderOverviewQry[0].B2B_Order_Id__c = 'R8000001234';
            }
						lstOrderOverviewQry[0].Status = 'Submitted';
            
                      update lstOrderOverviewQry;
            
        PageReference retURL = new PageReference('/' + lstOrderOverviewQry[0].Id );
        retURL.setRedirect(true);
        return retURL;
            */
                
            ren504Error = false;
            
            
                CalloutB2BAPI.ResponseWrapper RW = CalloutB2BAPI.execute(request);
                system.debug('RW>>' +RW);
                system.debug('RW.message>>' +RW.message);
                system.debug('RW.Response>>' +RW.Response);
                

            
         //       if(1==1 ){
                if((RW.message == '' && RW.Response != null) || Test.isRunningTest() ){
                    system.debug('API response success');
                    
                    string resdoc = '';
                    
                //    if(!Test.isRunningTest() && RW.Response.getStatusCode()==201 ){
                    if(!Test.isRunningTest() ){
                        system.debug('RW.Response--> ' + RW.Response );
                        //    response = http.send(request);
                        //    resdoc = response.getBody();
                        resdoc = RW.Response.getBody();
                    }else{
/*
                      if(RW.Response!=null){
                          system.debug('RW.Response>>' +RW.Response);
                              ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Encountered following error response while submitting order --> ' + RW.Response ));
                      }
                      if(RW.message!=null){
                      system.debug('RW.message--> ' + RW.message );
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Encountered following error message while submitting order --> ' + RW.message));
                      }
  */                      
                        resdoc = '{ "order_reference_number": "SF_OrderReferenceNumber", "order_id": "12345" }';
                        
                 //   system.debug('RW.Response.getBody() --> ' + RW.Response.getBody() );
                 //   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Encountered following error while submitting order --> ' + RW.Response));   
                    }
                    
                  //      resdoc = '{ "order_reference_number": "SF_OrderReferenceNumber", "order_id": "12345" }';
                    system.debug('resdoc --> ' + resdoc );
                    
                    string b2borderid = '';

                      DeserializeAdjustmentOrderAPI obj = DeserializeAdjustmentOrderAPI.parse(resdoc);
                      system.debug('obj:' +obj);
                      b2borderid = string.valueof(obj.order_id);

                    system.debug('b2borderid --> ' + b2borderid );
                      
            
						lstOrderOverviewQry[0].B2B_Order_Id__c = b2borderid;
						lstOrderOverviewQry[0].Status = 'Submitted';
						lstOrderOverviewQry[0].PreHour_Trigger_Time__c = null;
						lstOrderOverviewQry[0].B2B_504_Error__c = null;
						lstOrderOverviewQry[0].Delivery_Date__c = date.valueOf(delDate);


                      update lstOrderOverviewQry;
                      
        PageReference retURL = new PageReference('/' + lstOrderOverviewQry[0].Id );
        retURL.setRedirect(true);
        return retURL;


                }else{
                    string b2bErrorMessage = '';
                    system.debug('API response failure');
                      if(RW.Response!=null){
                          system.debug('RW.Response>>' +RW.Response);
                          if(RW.Response.getStatusCode()==504){
                              ren504Error = true;
						lstOrderOverviewQry[0].Status = 'Adjustment Submitted but Waiting on B2B';
						lstOrderOverviewQry[0].PreHour_Trigger_Time__c = system.now() - 0.038;
						lstOrderOverviewQry[0].Delivery_Date__c = date.valueOf(delDate);
                 //       lstOrderOverviewQry[0].B2B_504_Error__c = RW.Response.substring(0,255);
                              
                          }else{
                              ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Encountered following error response while submitting order --> ' + RW.Response ));
                          }
                              b2bErrorMessage = RW.Response.getStatus();
                      }
                      if(RW.message!=null &&  !ren504Error){
                      system.debug('RW.message--> ' + RW.message );
                              b2bErrorMessage += RW.message;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Encountered error message while submitting order --> ' + RW.message));
                      }
                      system.debug('b2bErrorMessage--> ' + b2bErrorMessage );
                    if(b2bErrorMessage.length()>255){
                        lstOrderOverviewQry[0].B2B_504_Error__c = b2bErrorMessage.substring(0,255);
                    }else{
                        lstOrderOverviewQry[0].B2B_504_Error__c = b2bErrorMessage;
                    }
                      update lstOrderOverviewQry;
                                        
                    
                }
                
            
            
            
        }
        
        return null;
    }    
    
    
}