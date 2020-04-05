public class CalloutProdInventoryCheckAPI7 {

    public static void ProdAvailCheckWrapper(SBQQ__Quote__c qheader) {
        List<Quote_Line_Staging__c> lstQuoteLineStaging = new List<Quote_Line_Staging__c>();
        lstQuoteLineStaging = [SELECT Id, Product__c, Product__r.ProductCode, Product__r.Fulfillment_Channel__c, Feature__c , Quantity__c
                               FROM Quote_Line_Staging__c 
                               WHERE Quote__c = :qheader.Id AND Product__r.ProductCode!=null AND Product__r.ProductCode!='' 
                         //      	AND (Feature__c=null OR Feature__c='Parts' )
                              ];
        system.debug('lstQuoteLineStaging--> ' + lstQuoteLineStaging );
        Map<String, String> mapProductQuote = new Map<String, String>();
        Map<String, String> mapProductQuote2 = new Map<String, String>();
        
        for(Quote_Line_Staging__c qst :lstQuoteLineStaging) {
            mapProductQuote.put(qst.Product__r.ProductCode, qst.Id);
        }        
        
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
        
        request.setHeader('Content-Type', CS_CONTENT_TYPE);
        request.setHeader('CLIENT_ID', CS_CLIENT_ID);
        request.setHeader('CLIENT_SECRET', CS_CLIENT_SECRET);
        
        dom.XmlNode xmlrequest = doc.createRootElement('request', null, null);
        dom.xmlNode zipCode = xmlrequest.addChildElement('zipCode', null, null);
        zipCode.addTextnode(qheader.SBQQ__ShippingPostalCode__c);
        dom.xmlNode items = xmlrequest.addChildElement('items',null,null);
        
        Map<String, List<Quote_Line_Staging__c>> mapQLStaging = new Map<String, List<Quote_Line_Staging__c>>();
        List<Quote_Line_Staging__c> lstTempStg = new List<Quote_Line_Staging__c>();
        
  //      for(Quote_Line_Staging__c qst : lt_qst ) {
        for(Quote_Line_Staging__c qst :lstQuoteLineStaging) {
            if(qst.Feature__c==null || qst.Feature__c=='' || qst.Feature__c=='Parts'){
            mapProductQuote2.put(qst.Product__r.ProductCode, qst.Id);
            lstTempStg = new List<Quote_Line_Staging__c>();
            String key_stg = qst.Product__r.ProductCode;//+string.valueof(Integer.valueof(qst.Quantity__c))+string.valueof(qst.Net_Unit_Price__c);
            if(mapQLStaging.keySet().contains(key_stg)){
                lstTempStg.addAll(mapQLStaging.get(key_stg));
            }else{
                mapQLStaging.put(key_stg, lstTempStg);
            }
            lstTempStg.add(qst);
            
            mapQLStaging.put(key_stg, lstTempStg);
            
            
            
            System.debug('Callout--> Quote Line Items:'+qst.Product__r.ProductCode);   
            //string tempprod = string.valueof(qst.SBQQ__Product__r.ProductCode);
            if(string.ValueOf(qst.Product__r.ProductCode).startsWith('0')) {
            system.debug('product code' +qst.Product__r.ProductCode);
            dom.XmlNode item = items.addChildElement('item', null, null);

            dom.XmlNode itemId = item.addChildElement('itemId', null, null);
            itemId.addTextNode(qst.Product__r.ProductCode);

            dom.XmlNode quantity = item.addChildElement('quantity', null, null);
            quantity.addTextNode('1');
         //   quantity.addTextNode(String.valueof(Integer.valueof(qst.Quantity__c)));
            
            dom.XmlNode dualStockItem = item.addChildElement('dualStockItem', null, null);
            dualStockItem.addTextNode('false');
            
                if(qst.Product__r.Fulfillment_Channel__c=='TW'){
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
        
        Map<String, Date> mapAvailDate = new Map<String, Date>();
        
        mapAvailDate = ProdAvailCheckAPI(request);

        List<Quote_Line_Staging__c> lstQLStagingUpdate = new List<Quote_Line_Staging__c>();
        Quote_Line_Staging__c objQLStaging = new Quote_Line_Staging__c();
        
                        system.debug('mapAvailDate --> ' + mapAvailDate );
                        system.debug('mapProductQuote --> ' + mapProductQuote );
        //Item unavailable
        //
        for(Quote_Line_Staging__c qst1 :lstQuoteLineStaging) {
                objQLStaging = new Quote_Line_Staging__c();
                objQLStaging.Id = qst1.Id;
                objQLStaging.PA_API_Message__c = '';
                objQLStaging.Earliest_Available_Date__c = null;
                objQLStaging.Available__c = false;
                objQLStaging.Available_Quantity__c = 0;
                if(mapAvailDate.get(qst1.Product__r.ProductCode)!=null && mapProductQuote2.get(qst1.Product__r.ProductCode)!=null ){
                    objQLStaging.PA_API_Message__c = 'Success';
                    objQLStaging.Available__c = true;
                    objQLStaging.Earliest_Available_Date__c = mapAvailDate.get(qst1.Product__r.ProductCode);
                } else if(mapAvailDate.get(qst1.Product__r.ProductCode)==null && mapProductQuote2.get(qst1.Product__r.ProductCode)!=null ){
                    objQLStaging.PA_API_Message__c = 'Item Unavailable';
                }else{
                    objQLStaging.Available__c = true;
                }
            lstQLStagingUpdate.add(objQLStaging);
                        system.debug('objQLStaging --> ' + objQLStaging );
        }
        //
        //
        /*
  //      for(String pid : mapAvailDate.keyset()){
        for(String pid : mapProductQuote.keyset()){
            objQLStaging = new Quote_Line_Staging__c();
            objQLStaging.Id = mapProductQuote.get(pid);
            objQLStaging.PA_API_Message__c = '';
            objQLStaging.Earliest_Available_Date__c = null;
            objQLStaging.Available__c = false;
            objQLStaging.Available_Quantity__c = 0;
            if(mapAvailDate.get(pid)!=null && mapProductQuote2.get(pid)!=null ){
                objQLStaging.PA_API_Message__c = 'Success';
            	objQLStaging.Available__c = true;
            	objQLStaging.Earliest_Available_Date__c = mapAvailDate.get(pid);
            } else if(mapAvailDate.get(pid)==null && mapProductQuote2.get(pid)!=null ){
                objQLStaging.PA_API_Message__c = 'Item Unavailable';
            }else{
            	objQLStaging.Available__c = true;
            }
            lstQLStagingUpdate.add(objQLStaging);
                        system.debug('objQLStaging --> ' + objQLStaging );
        }
        */
                        system.debug('lstQLStagingUpdate --> ' + lstQLStagingUpdate );
        update lstQLStagingUpdate;
        
    }  
    
    public static void ProdAvailCheckWrapper2(SBQQ__Quote__c qheader) {
        
        List<SBQQ__QuoteLine__c> lstQuoteLine = [select Id, SBQQ__Product__c, SBQQ__Product__r.ProductCode, SBQQ__Product__r.Fulfillment_Channel__c, 
                                                 SBQQ__ProductOption__r.SBQQ__Feature__r.Name, Feature__c, SBQQ__Quantity__c 
                                                 from SBQQ__QuoteLine__c 
                                                 where SBQQ__Quote__c = :qheader.Id AND SBQQ__Product__r.ProductCode!=null AND SBQQ__Product__r.ProductCode!=''
                               					//	AND (SBQQ__ProductOption__r.SBQQ__Feature__r.Name=null OR SBQQ__ProductOption__r.SBQQ__Feature__r.Name='Parts' )
                               						AND (Feature__c=null OR Feature__c='' OR Feature__c='Parts' )
                                                ] ;
        
        system.debug('lstQuoteLine--> ' + lstQuoteLine );
        Map<String, String> mapProductQuote = new Map<String, String>();
        Map<String, String> mapProductQuote2 = new Map<String, String>();
        Map<String, String> mapProductQuantity = new Map<String, String>();
        
        DOM.Document doc = new DOM.Document();
        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        Http http = new Http();
        
        Map<String, Common_Variables__c> mapCV = Common_Variables__c.getAll();
    //    String CS_Endpoint = mapCV.get('B2BProd_Tax_API_URL').Content__c;
    //    String CS_Endpoint = 'https://api.b2b.sears.com/v/2/delivery/earliest-dates';
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
        zipCode.addTextnode(qheader.SBQQ__ShippingPostalCode__c);
        dom.xmlNode items = xmlrequest.addChildElement('items',null,null);
        
        Map<String, List<SBQQ__QuoteLine__c>> mapQuoteLine = new Map<String, List<SBQQ__QuoteLine__c>>();
        List<SBQQ__QuoteLine__c> lstTempQL = new List<SBQQ__QuoteLine__c>();
        
        for(SBQQ__QuoteLine__c ql :lstQuoteLine) {
            mapProductQuote2.put(ql.SBQQ__Product__r.ProductCode, ql.Id);
            mapProductQuantity.put(ql.SBQQ__Product__r.ProductCode, String.valueof(Integer.valueof(ql.SBQQ__Quantity__c)));
            lstTempQL = new List<SBQQ__QuoteLine__c>();
            String key_ql = ql.SBQQ__Product__r.ProductCode;//+string.valueof(Integer.valueof(ql.Quantity__c))+string.valueof(ql.Net_Unit_Price__c);
            if(mapQuoteLine.keySet().contains(key_ql)){
                lstTempQL.addAll(mapQuoteLine.get(key_ql));
            }else{
                mapQuoteLine.put(key_ql, lstTempQL);
            }
            lstTempQL.add(ql);
            
            mapQuoteLine.put(key_ql, lstTempQL);
            
            
            
            System.debug('Callout--> Quote Line Items:'+ql.SBQQ__Product__r.ProductCode);   
            //string tempprod = string.valueof(ql.SBQQ__Product__r.ProductCode);
            if(string.ValueOf(ql.SBQQ__Product__r.ProductCode).startsWith('0')) {
            system.debug('product code' +ql.SBQQ__Product__r.ProductCode);
            dom.XmlNode item = items.addChildElement('item', null, null);

            dom.XmlNode itemId = item.addChildElement('itemId', null, null);
            itemId.addTextNode(ql.SBQQ__Product__r.ProductCode);

            dom.XmlNode quantity = item.addChildElement('quantity', null, null);
         //   quantity.addTextNode('1');
            quantity.addTextNode(String.valueof(Integer.valueof(ql.SBQQ__Quantity__c)));
            
            dom.XmlNode dualStockItem = item.addChildElement('dualStockItem', null, null);
            dualStockItem.addTextNode('false');
            
                if(ql.SBQQ__Product__r.Fulfillment_Channel__c=='TW'){
                    dom.XmlNode fulfillmentChannel = item.addChildElement('fulfillmentChannel', null, null);
                    fulfillmentChannel.addTextNode('TW');
                    dom.XmlNode forceFulfillment = item.addChildElement('forceFulfillment', null, null);
                    forceFulfillment.addTextNode('DDC');
                }
                
             }
        }  
        
        string req = doc.toXmlString();
        system.debug('req --> ' + req );
        request.setBody(req);
        
        Map<String, Date> mapAvailDate = new Map<String, Date>();
        
        mapAvailDate = ProdAvailCheckAPI(request);

        List<SBQQ__QuoteLine__c> lstQuoteLineUpdate = new List<SBQQ__QuoteLine__c>();
        SBQQ__QuoteLine__c objQuoteLine = new SBQQ__QuoteLine__c();
        
        system.debug('mapAvailDate --> ' + mapAvailDate );
        system.debug('mapProductQuote --> ' + mapProductQuote );
        system.debug('mapProductQuote2 --> ' + mapProductQuote2 );
        
        for(SBQQ__QuoteLine__c ql1 :lstQuoteLine) {
            objQuoteLine = new SBQQ__QuoteLine__c();
            objQuoteLine.Id = ql1.Id;//mapProductQuote2.get(pid);
            objQuoteLine.PA_API_Message__c = '';
            objQuoteLine.Earliest_Available_Date__c = null;
            objQuoteLine.Available__c = false;
            objQuoteLine.Available_Quantity__c = 0;
            if(mapAvailDate.get(ql1.SBQQ__Product__r.ProductCode)!=null && mapProductQuote2.get(ql1.SBQQ__Product__r.ProductCode)!=null ){
                objQuoteLine.PA_API_Message__c = 'Success';
            	objQuoteLine.Available__c = true;
            	objQuoteLine.Earliest_Available_Date__c = mapAvailDate.get(ql1.SBQQ__Product__r.ProductCode);
            } else if(mapAvailDate.get(ql1.SBQQ__Product__r.ProductCode)==null && mapProductQuote2.get(ql1.SBQQ__Product__r.ProductCode)!=null ){
                objQuoteLine.PA_API_Message__c = 'Item Unavailable';
            }else{
            	objQuoteLine.Available__c = true;
            }
            lstQuoteLineUpdate.add(objQuoteLine);
                        system.debug('objQuoteLine --> ' + objQuoteLine );
        }        
        /*
        for(String pid : mapProductQuote2.keyset()){
            objQuoteLine = new SBQQ__QuoteLine__c();
            objQuoteLine.Id = mapProductQuote2.get(pid);
            objQuoteLine.PA_API_Message__c = '';
            objQuoteLine.Earliest_Available_Date__c = null;
            objQuoteLine.Available__c = false;
            objQuoteLine.Available_Quantity__c = 0;
            if(mapAvailDate.get(pid)!=null && mapProductQuote2.get(pid)!=null ){
                objQuoteLine.PA_API_Message__c = 'Success';
            	objQuoteLine.Available__c = true;
            	objQuoteLine.Earliest_Available_Date__c = mapAvailDate.get(pid);
            } else if(mapAvailDate.get(pid)==null && mapProductQuote2.get(pid)!=null ){
                objQuoteLine.PA_API_Message__c = 'Item Unavailable';
            }else{
            	objQuoteLine.Available__c = true;
            }
            lstQuoteLineUpdate.add(objQuoteLine);
                        system.debug('objQuoteLine --> ' + objQuoteLine );
        }
*/
                        system.debug('lstQuoteLineUpdate --> ' + lstQuoteLineUpdate );
        update lstQuoteLineUpdate;
        
    }  
    
    public static Map<String, Date> ProdAvailCheckAPI(HttpRequest request) {
        
        CalloutB2BAPI.ResponseWrapper RW = CalloutB2BAPI.execute(request);
        Map<String, Date> mapAvailableDate = new Map<String, Date>();
        
        system.debug('callout success>>' +RW);
        if(!Test.isRunningTest() && ((RW.message == '' && RW.Response != null) || (RW.Response.getStatusCode()!=null && RW.Response.getStatusCode()==422)) ){
            system.debug('API response success');
            
            string resdoc = RW.Response.getBody();
            system.debug('Response output message:' +RW.Response.getBody());
            
            DOM.Document docResp= new DOM.Document();
            docResp.load(resdoc);
            
            DOM.XmlNode root = docResp.getRootElement();
            system.debug('root:' + root );
            
            DOM.XmlNode itemsXMLNode = root.getChildElement('requestedItems', null);
            system.debug('itemsXMLNode:' + itemsXMLNode );
            if(itemsXMLNode!=null){
            dom.XmlNode [] itemXMLNode = itemsXMLNode.getchildelements();
            
            
            for(DOM.XmlNode itemslist : itemXMLNode) 
            {
                system.debug('itemslist --> '+ itemslist);
                String key_pid = '';
                dom.XmlNode [] xitems = itemslist.getchildelements() ;                
                for(dom.XmlNode items_final: xitems) {
                    
                    if (items_final.getname() == 'partNumber'){
                        key_pid = items_final.gettext();
                        DOM.XmlNode datesXMLNode = itemslist.getChildElement('deliveryDates', null);
                        Dom.XmlNode [] dateXMLNode = datesXMLNode.getchildelements();
                        for(dom.XmlNode date_final: dateXMLNode) {
                            system.debug('date_final.getname() --> '+ date_final.getname());
                                system.debug('date_final.gettext() --> '+ date_final.gettext());
                            if (date_final.getname() == 'date' && date_final.gettext()!=null && date_final.gettext()!='' ){
                                system.debug('date_final.gettext() --> '+ date_final.gettext());
                                mapAvailableDate.put(key_pid, date.parse(date_final.gettext().replace('-', '/')));
                            }
                        }
                    }
                 }
            }
            
                        system.debug('mapAvailableDate --> ' + mapAvailableDate );
        }else{
            system.debug('API response error --> ' + RW.message );
            system.debug('Response output message:' +RW.Response.getBody());
        }
            
        }else{
            system.debug('API response error --> ' + RW.message );
        }
        return mapAvailableDate;
    }    
    
    
}