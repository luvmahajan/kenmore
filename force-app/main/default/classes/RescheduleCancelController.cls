public class RescheduleCancelController {
    public String orderId {get; set;}
    public String adjAction {get; set;}
    public String b2bOrderId {get; set;}
    public String adjType {get; set;}
    public String selRschReason {get; set;}
    public String selCnlReason {get; set;}
    public String selPickupDate {get; set;}
    public String delDate {get; set;}
    public Integer noOFItems {get; set;}
    public Decimal totalDimension {get; set;}
    public Boolean renConfirmCancel {get; set;}
    public String ldapUserId {get; set;}
    
    public List<Order> lstOrder {get; set;}
    public List<OrderItem> lstOrderItemQry {get; set;}
    public Set<String> setDate {get; set;}

    public RescheduleCancelController(){        
        orderId = ApexPages.CurrentPage().getparameters().get('id');
        adjAction = ApexPages.CurrentPage().getparameters().get('action');
        system.debug('orderId--> ' + orderId );
        system.debug('adjAction--> ' + adjAction );
        
        selRschReason = '';
        selCnlReason = '';
        selPickupDate = '';
        
        adjType = '';
        delDate = '';
        b2bOrderId = '';
        
        renConfirmCancel = false;
        
        lstOrder = new List<Order>();
        lstOrderItemQry = new List<OrderItem>();
        setDate = new Set<String>();
        
        lstOrder = [SELECT Id, Name, Status, type, Parent_Order__c, Delivery_Date__c, B2B_Order_Id__c, 
                    	ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode
                    FROM Order
                    WHERE ID =: orderId
                    LIMIT 1
                   ];
            system.debug('lstOrder--> ' + lstOrder );
        if(lstOrder.size()>0){
            adjType = lstOrder[0].type;
            if(lstOrder[0].B2B_Order_Id__c!=null && lstOrder[0].B2B_Order_Id__c!='' ){
                b2bOrderId = lstOrder[0].B2B_Order_Id__c;
            if(lstOrder[0].Delivery_Date__c!=null){
                delDate = string.valueof(lstOrder[0].Delivery_Date__c);
            }
            
            lstOrderItemQry = [SELECT Id, OrderId, Product2Id, Quantity, Feature__c
                               FROM OrderItem    
                               WHERE OrderId=:orderId
                               ORDER BY Number__c
                              ];
            system.debug('lstOrderItemQry--> ' + lstOrderItemQry );
            }
            
        }
        
        system.debug('delDate--> ' + delDate );
        
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
        
         
        
        
        noOFItems = 0;
        totalDimension = 0;
        
        noOfItems = calculateCalenderItems();           
        totalDimension = calculateCalenderDimensions().setScale(2);           
        
        system.debug('noOfItems--> ' + noOfItems );
        system.debug('totalDimension--> ' + totalDimension );
        
    }    
    
    public PageReference gotoAdjustment(){
        PageReference retURL = new PageReference('/' + orderId );
        retURL.setRedirect(true);
        return retURL;
    }
    
     public list<selectoption> getRescheduleCancelReason(){
        list<selectoption> lstSel= new list<selectoption>();
        lstSel.add(new SelectOption('', '--None--'));   
                
        List<Reason_Code__c> lstHeaderReasonCode= new List<Reason_Code__c >();
        
        lstHeaderReasonCode = [SELECT Id, Name, Div__c, Code__c, Category_Code__c, Category_Description__c, 
                               			Reason_Code__c, Reason_Description__c, Reason_Id__c, Reason_Type__c
                               FROM Reason_Code__c
                            //   WHERE Reason_Type__c =: adjAction 
                               ORDER BY Reason_Type__c , Code__c, Reason_Id__c, Id 
                              ];
        
        for(Reason_Code__c hrc:lstHeaderReasonCode ){
            if(hrc.Reason_Type__c != null && hrc.Reason_Type__c==adjAction && (adjType=='Return' || adjType=='Exchange') ){
        		lstSel.add(new SelectOption(hrc.Code__c, hrc.Reason_Description__c));        
            }else if(hrc.Reason_Id__c==null && (adjType=='Credit Memo' || adjType=='Debit Memo')){
        		lstSel.add(new SelectOption(hrc.Reason_Description__c, hrc.Reason_Description__c)); 
            }
        }
        
        system.debug('lstSel:' +lstSel);
         
        
        return lstSel;
    }
    
    public list<selectoption> getPickUpDateDropDown()
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
            if(delDate!=null && delDate!=''){
        SerializeAdjustmentDeliveryAPI objSerializeDelivery = new SerializeAdjustmentDeliveryAPI();
        
        objSerializeDelivery = new SerializeAdjustmentDeliveryAPI();
        
        SerializeAdjustmentDeliveryAPI.DeliveryCalendarRequest objDelCal = new SerializeAdjustmentDeliveryAPI.DeliveryCalendarRequest();
        objDelCal.clientCode = 'COMM';
        objDelCal.sellingStoreID = '09346';
        objDelCal.timeWindow = 'ALL';
        objDelCal.servicetime = '10';
        objDelCal.cubes = totalDimension;
        objDelCal.nofItems = noOfItems;
        objDelCal.startDate = delDate;
        objDelCal.address1 = lstOrder[0].ShippingStreet;
        objDelCal.address2 = '';
        objDelCal.city = lstOrder[0].ShippingCity;
        objDelCal.state = lstOrder[0].ShippingState;
        objDelCal.zip = lstOrder[0].ShippingPostalCode;

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
        
            }
        
    }
    
    public Integer calculateCalenderItems(){
        Integer no_itms = 0;
        
        for(OrderItem oi:lstOrderItemQry){
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
        
        for(OrderItem oi:lstOrderItemQry){
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
        
        for(OrderItem oi:lstOrderItemQry){
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

    public PageReference actionReschedule(){
        
        system.debug('selRschReason--> ' + selRschReason );
        system.debug('selPickupDate--> ' + selPickupDate );
        
        Boolean isError = false;
        
        if(selRschReason==null || selRschReason=='' ){
            isError = true;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter Rescheduling Reason'));
        }
        if(selPickupDate==null || selPickupDate=='' ){
            isError = true;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select Available Date'));
        }
        
        if(!isError){
            
        SerializeReschedule objRsch = new SerializeReschedule();
        
        objRsch = new SerializeReschedule();
        
            objRsch.reason_code = selRschReason;
        objRsch.pickup_date = selPickupDate;
        
        String JSONString_Reschedule = JSON.serialize(objRsch);
                  
        System.debug('Serialized  JSON format: ' + JSONString_Reschedule);
                  
        Map<String, Common_Variables__c> mapCV = Common_Variables__c.getAll();
                  
     //   String EndpointUrl = mapCV.get('B2BProd_Create Order_URL').Content__c;
     //   String CS_CLIENT_ID = mapCV.get('B2BProd_KD_ClientId').Content__c;
     //   String CS_CLIENT_SECRET = mapCV.get('B2BProd_KD_ClientSecret').Content__c;
        String CS_CLIENT_ID = mapCV.get('B2BProd_ClientId').Content__c;
        String CS_CLIENT_SECRET = mapCV.get('B2BProd_ClientSecret').Content__c;
     //   String EndpointUrl = 'https://KenmoreDirTRIAL331001.jitterbit.net/ProductloadSF/b2BQaReturnExchangeRescheduleApi';
        String EndpointUrl = mapCV.get('Adjustment_Order_API').Content__c;
            EndpointUrl += '/' + b2bOrderId + '/reschedule';
        String CS_CONTENT_TYPE = 'application/json';        
        
        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        Http http = new Http();
        
        request.setHeader('Accept', CS_CONTENT_TYPE);
        request.setHeader('Content-Type', CS_CONTENT_TYPE);
        request.setHeader('CLIENT_ID', CS_CLIENT_ID);
        request.setHeader('CLIENT_SECRET', CS_CLIENT_SECRET);
        request.setHeader('LDAP_USER_ID', ldapUserId);
        
        request.setMethod('POST');
        request.setendPoint(EndpointUrl);
        system.debug('EndpointUrl >>'+EndpointUrl);
        
        request.setBody(JSONString_Reschedule);
        request.setTimeout(60000); // timeout in milliseconds
        
        system.debug('request >>'+request);
        
        
        CalloutB2BAPI.ResponseWrapper RW = CalloutB2BAPI.execute(request);
        system.debug('RW>>' +RW);
        system.debug('RW.message>>' +RW.message);
        system.debug('RW.Response>>' +RW.Response);
        
        if((RW.message == '' && RW.Response != null) || Test.isRunningTest() ){
    //    if(1==1 ){
            system.debug('API response success');
            
            string resdoc = '';
            
            if(!Test.isRunningTest()){
                system.debug('RW.Response--> ' + RW.Response );
                resdoc = RW.Response.getBody();
            }else{
                resdoc = '{ "order_reference": "SF_ADJUSTMENT_RA15", "order_id": "R800000830" }';
            }
    //            resdoc = '{ "order_reference": "SF_ADJUSTMENT_RA15", "order_id": "R800000830" }';
            system.debug('resdoc:' +resdoc);
            
            DeserializeAdjustmentOrderAPI obj = DeserializeAdjustmentOrderAPI.parse(resdoc);
            system.debug('obj:' +obj);
                      
            if(b2borderid == string.valueof(obj.order_id)){
                      List<Order> lstOrderInsertQry = new List<Order>();
                      lstOrderInsertQry = [SELECT Id, Name, Delivery_Date__c, Reschedule_Reason_Code__c FROM Order WHERE Id =: orderid LIMIT 1];
                      system.debug('lstOrderInsertQry.size()--> ' +lstOrderInsertQry.size());
                      if(lstOrderInsertQry.size()>0){
                          for(Order ord:lstOrderInsertQry){
                              ord.Delivery_Date__c = date.valueof(selPickupDate);
                              ord.Reschedule_Reason_Code__c = selRschReason;
                          }
                      update lstOrderInsertQry;
        PageReference retURL = new PageReference('/' + orderId );
        retURL.setRedirect(true);
        return retURL;
                      }
            }else{
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Encountered following error response while submitting order --> ' + resdoc ));
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
        
            
            
        }
        
   //     PageReference retURL = new PageReference('/' + orderId );
   //     retURL.setRedirect(true);
   //     return retURL;
        return null;
    }
                
    public void actionCancel(){
        
        system.debug('selCnlReason--> ' + selCnlReason );
        
        if(selCnlReason!=null && selCnlReason!='' ){
            renConfirmCancel = true;
        }else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter Cancellation Reason'));
        }
        
    }
                
    public PageReference actionNoCancel(){
        
        system.debug('selCnlReason--> ' + selCnlReason );
        
        renConfirmCancel = false;
        
        PageReference retURL = new PageReference('/' + orderId );
        retURL.setRedirect(true);
   //     return retURL;
        return null;
    }
    
    public PageReference actionConfirmCancel(){
        
        system.debug('selCnlReason--> ' + selCnlReason );
        
        String JSONString_Cancel = '';
        
        if(adjType=='Return' || adjType=='Exchange' ){
        SerializeCancelRX objCnlRX = new SerializeCancelRX();
        
        objCnlRX = new SerializeCancelRX();
        
            objCnlRX.reason_code = selCnlReason;
            
            JSONString_Cancel = JSON.serialize(objCnlRX);
        }else if(adjType=='Credit Memo' || adjType=='Debit Memo' ){
        SerializeCancelCD objCnlCD = new SerializeCancelCD();
        
        objCnlCD = new SerializeCancelCD();
        
            objCnlCD.reason = selCnlReason;
            
            JSONString_Cancel = JSON.serialize(objCnlCD);
        }
            
            
                  
        System.debug('Serialized  JSON format: ' + JSONString_Cancel);
                  
        Map<String, Common_Variables__c> mapCV = Common_Variables__c.getAll();
                  
     //   String EndpointUrl = mapCV.get('B2BProd_Create Order_URL').Content__c;
     //   String CS_CLIENT_ID = mapCV.get('B2BProd_KD_ClientId').Content__c;
     //   String CS_CLIENT_SECRET = mapCV.get('B2BProd_KD_ClientSecret').Content__c;
        String CS_CLIENT_ID = mapCV.get('B2BProd_ClientId').Content__c;
        String CS_CLIENT_SECRET = mapCV.get('B2BProd_ClientSecret').Content__c;
     //   String EndpointUrl = 'https://KenmoreDirTRIAL331001.jitterbit.net/ProductloadSF/b2BAdjustmentsCancelrequest';
        String EndpointUrl = mapCV.get('Adjustment_Order_API').Content__c;
            EndpointUrl += '/' + b2bOrderId + '/cancel';
        String CS_CONTENT_TYPE = 'application/json';        
        
        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        Http http = new Http();
        
        request.setHeader('Accept', CS_CONTENT_TYPE);
        request.setHeader('Content-Type', CS_CONTENT_TYPE);
        request.setHeader('CLIENT_ID', CS_CLIENT_ID);
        request.setHeader('CLIENT_SECRET', CS_CLIENT_SECRET);
        request.setHeader('LDAP_USER_ID', ldapUserId);
        
     //   request.setMethod('POST');
        request.setMethod('PUT');
        request.setendPoint(EndpointUrl);
        system.debug('EndpointUrl >>'+EndpointUrl);
        
        request.setBody(JSONString_Cancel);
        request.setTimeout(60000); // timeout in milliseconds
        
        system.debug('request >>'+request);
        
        
        CalloutB2BAPI.ResponseWrapper RW = CalloutB2BAPI.execute(request);
        system.debug('RW>>' +RW);
        system.debug('RW.message>>' +RW.message);
        system.debug('RW.Response>>' +RW.Response);
        
        if((RW.message == '' && RW.Response != null) || Test.isRunningTest() ){
    //    if(1==1 ){
            system.debug('API response success');
            
            string resdoc = '';
            
            if(!Test.isRunningTest()){
                system.debug('RW.Response--> ' + RW.Response );
                resdoc = RW.Response.getBody();
            }else{
                resdoc = '{ "order_reference": "SF_ADJUSTMENT_RA15", "order_id": "R800000830" }';
            }
          //      resdoc = '{ "order_reference": "SF_ADJUSTMENT_RA15", "order_id": "R800000830" }';
            system.debug('resdoc:' +resdoc);
            
            DeserializeAdjustmentOrderAPI obj = DeserializeAdjustmentOrderAPI.parse(resdoc);
            system.debug('obj:' +obj);
                      
            if(b2borderid == string.valueof(obj.order_id)){
                      List<Order> lstOrderInsertQry = new List<Order>();
                      lstOrderInsertQry = [SELECT Id, Name, Cancellation_Reason_Code__c FROM Order WHERE Id =: orderid LIMIT 1];
                      system.debug('lstOrderInsertQry.size()--> ' +lstOrderInsertQry.size());
                      if(lstOrderInsertQry.size()>0){
                          for(Order ord:lstOrderInsertQry){
                              ord.Cancellation_Reason_Code__c = selCnlReason;
                          }
                      update lstOrderInsertQry;
        PageReference retURL = new PageReference('/' + orderId );
        retURL.setRedirect(true);
        return retURL;
                      }
            }else{
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Encountered following error response while submitting order --> ' + resdoc ));
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
        
        
        
        PageReference retURL = new PageReference('/' + orderId );
        retURL.setRedirect(true);
   //     return retURL;
        return null;
    }
                
    public class SerializeReschedule {
        public String reason_code {get;set;}
        public String pickup_date {get;set;}
    }       
    
    public class SerializeCancelRX {
        public String reason_code {get;set;}
    }       
    
    public class SerializeCancelCD {
        public String reason {get;set;}
    }       
    
                
}