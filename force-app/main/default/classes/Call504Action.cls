public class Call504Action {
    
    @InvocableMethod
    public static void call504action_method(List<ID> oId) {
        doCalloutFromFuture(oId);
        
    }
    
    
  @future (callout=true)
  public static void doCalloutFromFuture(List<ID> oId) {
   //Add code to perform callout
   //
   //
        system.debug('oId--> ' + oId );
        
        Order objOrder = new Order();
        objOrder = [SELECT Id, Name, Order_Reference_Number__c, B2B_Order_Id__c, 
                    	ContractId, Parent_Order__c, Parent_Order__r.ContractId,
                    	B2B_504_Error__c
                    FROM Order 
                    WHERE Id IN: oId 
                    LIMIT 1
                   ];
        if(objOrder!=null){
            system.debug('objOrder--> ' + objOrder );
            
        Map<String, Common_Variables__c> mapCV = Common_Variables__c.getAll();
      //          String EndpointUrl = 'https://KenmoreDirTRIAL331001.jitterbit.net/kd/rest/adjustments/get_order_details/' + objOrder.Order_Reference_Number__c;
            String EndpointUrl = mapCV.get('Order_Detail_API').Content__c;
            EndpointUrl += objOrder.Order_Reference_Number__c;
      //      String CS_CLIENT_ID = '35c5aeb0dae801366e6f001a4aebb081';  
      //      String CS_CLIENT_SECRET = 'rZFrd3Tlo7f+7hYtrFAb2D06cEodbJlTA+UnBEJcMfRqZFLJ'; 
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
                
                request.setTimeout(60000); // timeout in milliseconds
                
                system.debug('request >>'+request);
            
                CalloutB2BAPI.ResponseWrapper RW = CalloutB2BAPI.execute(request);
                system.debug('RW>>' +RW);
                system.debug('RW.message>>' +RW.message);
                system.debug('RW.Response>>' +RW.Response);
                                        
            
          //     if((RW.message == '' && RW.Response != null) || Test.isRunningTest() ){
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
                    
                    string b2borderid = '';

                      DeserializeOrderDetailAPI obj = DeserializeOrderDetailAPI.parse(resdoc);
                      system.debug('obj:' +obj);
                      b2borderid = string.valueof(obj.order_no);
                    system.debug('b2borderid --> ' + b2borderid );
						objOrder.B2B_Order_Id__c = b2borderid;
						objOrder.Status = string.valueof(obj.status);
						objOrder.PreHour_Trigger_Time__c = null;
                    if(objOrder.Parent_Order__c != null){
                        objOrder.ContractId = objOrder.Parent_Order__r.ContractId;
                    }
                    if(resdoc.length()>255){
                        objOrder.B2B_504_Error__c = resdoc.substring(0,255);
                    }else{
                        objOrder.B2B_504_Error__c = resdoc;
                    }
                      update objOrder;
                      
                    
                    
                    
                }else{
                    string b2bErrorMessage = '';
                      if(RW.Response!=null){
                          system.debug('RW.Response>>' +RW.Response);
                   //       ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,RW.Response.getStatusCode() + '--> ' + RW.Response.getStatus() ));
                 //         b2bErrorMessage+=RW.Response.getStatus();
                      }
                      if(RW.message!=null){
                      system.debug('RW.message--> ' + RW.message );
      //      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,RW.message));
                          b2bErrorMessage+=RW.message;
                      }
                    if(b2bErrorMessage.length()>255){
                        objOrder.B2B_504_Error__c = b2bErrorMessage.substring(0,255);
                    }else{
                        objOrder.B2B_504_Error__c = b2bErrorMessage;
                    }
                    update objOrder;
                    
       
                //    string toMail = 'luvmahajan.0512@gmail.com';
                //    string ccMail = 'luv.512@gmail.com';
               //     string repMail = 'luv.mahajan@kenmoredirect.com';
       
                    string toMail = 'SearsB2B_Dev@searshc.com';
                    string ccMail = 'sfdcsupport@searshc.com';
                    string repMail = 'sfdcsupport@searshc.com';
       
                    string subjectEmail = 'B2B Adjustment Order Number Issue for ' + objOrder.Order_Reference_Number__c ;
       
                    string bodyEmail = 'Hi Team, <br/><br/>The B2B Order Number was not returned for ' + objOrder.Order_Reference_Number__c + ' when we queried after 5 mins. <br/><br/>Regards<br/> SFDC Team';
                    
                    
                    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                    string[] to = new string[] {toMail};
                        string[] cc = new string[] {ccMail};
                            
                            email.setToAddresses(to);
                    if(ccMail!=null && ccMail != '')
                        email.setCcAddresses(cc);
                    if(repmail!=null && repmail!= '')
                        email.setInReplyTo(repMail);
                    
                    email.setSubject(subjectEmail);
                    email.setHtmlBody(bodyEmail);
                    
                    try{
               //         Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
                    }catch(exception e){
                        System.debug('The email failed to send: ' + e.getMessage());
                    }
                    
                    
                }            
            
        }
   //
   //
   //
   //
   //
   //
}        
        
    
}