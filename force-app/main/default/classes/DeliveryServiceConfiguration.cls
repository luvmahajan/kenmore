public class DeliveryServiceConfiguration {

 //   public static Map<String, List<String>> DeliveryServiceWrapper(String quoteId, List<String> lstProductId) {
 //       Map<String, List<String>> mapProductsConfig = new Map<String, List<String>> ();
    public static Map<String, Map<String, String>> DeliveryServiceWrapper(String quoteId, List<String> lstProductId) {
        Map<String, Map<String, String>> mapProductsConfig = new Map<String, Map<String, String>> ();
        
        SBQQ__Quote__c qheader = new SBQQ__Quote__c();
        qheader = [select Id, SBQQ__ShippingPostalCode__c from SBQQ__Quote__c where Id = :quoteId LIMIT 1];
        List<Product2> lstpheader = new List<Product2>();
        lstpheader = [select Id, ProductCode from Product2 where Id IN :lstProductId];
        if(qheader!=null && qheader.SBQQ__ShippingPostalCode__c!=null && lstpheader.size()>0 ){
            DOM.Document doc = new DOM.Document();
            HttpRequest request = new HttpRequest();
            HttpResponse response = new HttpResponse();
            Http http = new Http();
            
            Map<String, Common_Variables__c> mapCV = Common_Variables__c.getAll();
            String CS_Endpoint = mapCV.get('B2BProd_Delivery_Service_URL').Content__c;
            String CS_CLIENT_ID = mapCV.get('B2BProd_ClientId').Content__c;
            String CS_CLIENT_SECRET = mapCV.get('B2BProd_ClientSecret').Content__c;
            String CS_CONTENT_TYPE = mapCV.get('B2BProd_ContentType_XML').Content__c;
            
            String EndpointUrl = CS_Endpoint;
            String itemspayload;
            
            request.setMethod('POST');
            request.setendPoint(EndpointUrl);
        //    system.debug('EndpointUrl >>'+EndpointUrl);
            
            request.setHeader('Content-Type', CS_CONTENT_TYPE);
            request.setHeader('CLIENT_ID', CS_CLIENT_ID);
            request.setHeader('CLIENT_SECRET', CS_CLIENT_SECRET);
            
            dom.XmlNode xmlrequest = doc.createRootElement('request', null, null);
            dom.xmlNode items = xmlrequest.addChildElement('items',null,null);
            
            for(Product2 pheader:lstpheader){
            if(string.ValueOf(pheader.ProductCode).startsWith('0')) {
                dom.XmlNode item = items.addChildElement('item', null, null);
                dom.XmlNode itemId = item.addChildElement('itemId', null, null);
                itemId.addTextNode(pheader.ProductCode);
                dom.XmlNode quantity = item.addChildElement('quantity', null, null);
                quantity.addTextNode('1');
            }
            }
            
            dom.xmlNode zipCode = xmlrequest.addChildElement('zipCode', null, null);
            zipCode.addTextNode(qheader.SBQQ__ShippingPostalCode__c);
            
            string req = doc.toXmlString();
            
            system.debug('Items payload'+req);
            //Payload request
            request.setBody(req);
            
            
            CalloutB2BAPI.ResponseWrapper RW = CalloutB2BAPI.execute(request);
  //          system.debug('callout success>>' +RW);
            if(RW.message == '' && RW.Response != null){
                
                
 //               system.debug('API response success');
                response = http.send(request);
 //               system.debug( 'rescode= ' +response.getStatusCode());
//                system.debug('resp message =' +response.getStatus());
                
                string resdoc = response.getBody();
 //               system.debug('Response output message:' +response.getBody());
                
                DOM.Document docResp= new DOM.Document();
                docResp.load(resdoc);
                
                DOM.XmlNode root = docResp.getRootElement();
       //         system.debug('root--> '+root);
                DOM.XmlNode itemsXMLNode = root.getChildElement('items', null);
   //             system.debug('itemsXMLNode--> '+itemsXMLNode);
                dom.XmlNode [] itemXMLNode = itemsXMLNode.getchildelements();
       //         system.debug('itemXMLNode--> '+itemXMLNode);
                
                
                for(DOM.XmlNode itemslist : itemXMLNode){
                    
                        DOM.XmlNode itemIdXMLNode = itemslist.getChildElement('itemId', null);
                	String key_pid = '';
                    
                  //      system.debug('itemslist.getname() --> '+ itemslist.getname());
                //        system.debug('itemIdXMLNode.getname() --> '+ itemIdXMLNode.getname());
                    if (itemIdXMLNode.getname() == 'itemId'){
                        key_pid = itemIdXMLNode.gettext();
              //          system.debug('itemIdXMLNode.gettext() --> '+ itemIdXMLNode.gettext());
                    }
                    DOM.XmlNode productConfigurationOptionsXMLNode = itemslist.getChildElement('productConfigurationOptions', null);
        //            system.debug('productConfigurationOptionsXMLNode--> '+productConfigurationOptionsXMLNode);
                    if(productConfigurationOptionsXMLNode!=null){
        
                        List<String> lstProductsConfig = new List<String>();
                        List<String> lstProductsConfig2 = new List<String>();
                        
                    DOM.XmlNode pickConfXMLNode = productConfigurationOptionsXMLNode.getChildElement('pick', null);
       //             system.debug('pickConfXMLNode--> '+pickConfXMLNode);
                    dom.XmlNode [] optionConfXMLNode = pickConfXMLNode.getchildelements();
      //              system.debug('optionConfXMLNode--> '+optionConfXMLNode);
                    
                    for(DOM.XmlNode optionsConflist : optionConfXMLNode){
                        dom.XmlNode [] ooptionsConf = optionsConflist.getchildelements() ;
                        
                        for(dom.XmlNode optionsConf_final: ooptionsConf) {
                    //            system.debug('optionsConf_final--> '+optionsConf_final);
                    //            system.debug('optionsConf_final.getname()--> '+optionsConf_final.getname());
                    //            system.debug('optionsConf_final.gettext()--> '+optionsConf_final.gettext());
                            if (optionsConf_final.getname() == 'optionCode'){
                      //          system.debug('optionsConf_final--> '+optionsConf_final.gettext());
                                lstProductsConfig.add(optionsConf_final.gettext());
                            }
                            if (optionsConf_final.getname() == 'description'){
                      //          system.debug('optionsConf_final--> '+optionsConf_final.gettext());
                                lstProductsConfig2.add(optionsConf_final.gettext());
                            }
                        }
                    }
                        Map<String, String> mapConfig = new Map<String, String> ();
                        if(lstProductsConfig.size()>0){
                            integer count_config = 0;
                            for(String prcf:lstProductsConfig){
                                if(prcf!=null && prcf!='' ){
                                    mapConfig.put(prcf,lstProductsConfig2[count_config]);
                                }
                                count_config++;
                            }
                            
                        }
                        
                    //            system.debug('lstProductsConfig--> '+lstProductsConfig);
                    //            system.debug('lstProductsConfig2--> '+lstProductsConfig2);
                    //            system.debug('mapConfig--> '+mapConfig);
                    //    mapProductsConfig.put(key_pid, lstProductsConfig);
                        mapProductsConfig.put(key_pid, mapConfig);
                    }
                    
                    
                    
                }
            }
        }
                                system.debug('mapProductsConfig--> '+mapProductsConfig);
        return mapProductsConfig;
    }  
    
    
}