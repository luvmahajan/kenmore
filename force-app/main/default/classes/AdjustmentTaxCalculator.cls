public class AdjustmentTaxCalculator {
    
    public static String TaxCalcWrapper(String orderId) {
        
        String errMsg = '';
        
        system.debug('orderId--> ' + orderId );
        
        Order objOrder = new Order();
        objOrder = [SELECT Id, AccountId, Status, ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode, 
                    Geo_Code__c, County_Code__c, Haulaway_Charge__c, Delivery_Charge__c, Premium_Delivery_Charge__c,
                    Other_Taxes__c
                    FROM Order                             
                    WHERE Id=:orderId
                    LIMIT 1
                   ];
        
        system.debug('objOrder--> ' + objOrder );
        
        if(objOrder.AccountId != null && objOrder.ShippingPostalCode != null ){
            
            
            DOM.Document doc = new DOM.Document();
            HttpRequest request = new HttpRequest();
            HttpResponse response = new HttpResponse();
            Http http = new Http();
            
            List<double> newitems = new List<double> ();
            double totalshipsum = 0;
            double tottaxrate;
            double tottax;
            double totalspltax = 0;
            
            String taxRequest = '';
            String taxResponse = '';
            
            Boolean isTaxExempt = false;
            
            Date dt_today = system.today();
            
            Map<String, String> mapServices = new Map<String, String>();
            mapServices.put('brownbox_10', '000BX999000');
            mapServices.put('hookup_3', '000HK999000');
            mapServices.put('gashookup_3', '000GH999000');
            //     mapServices.put('haulawayRequested', '000HA999000');
            mapServices.put('uncrate_K', '000UC999000');
            Map<String, String> mapServicesCode = new Map<String, String>();
            mapServicesCode.put('000BX999000', 'brownbox_10');
            mapServicesCode.put('000HK999000', 'hookup_3');
            mapServicesCode.put('000GH999000', 'gashookup_3');
            //     mapServicesCode.put('000HA999000', 'haulawayRequested');
            mapServicesCode.put('000UC999000', 'uncrate_K');
            
            List<SBQQ__TaxExemptionCertificate__c> lstTaxExempt = new List<SBQQ__TaxExemptionCertificate__c>();
            lstTaxExempt = [SELECT Id, Name, SBQQ__CERTIFICATENUMBER__C, SBQQ__ACCOUNT__C, 
                            SBQQ__ACTIVE__C, SBQQ__STATE__C, SBQQ__DATEISSUED__C, SBQQ__EXPIRATIONDATE__C
                            FROM SBQQ__TaxExemptionCertificate__c
                            WHERE SBQQ__ACCOUNT__C =: objOrder.AccountId AND SBQQ__STATE__C=:objOrder.ShippingPostalCode
                            AND SBQQ__DATEISSUED__C<=: dt_today AND SBQQ__EXPIRATIONDATE__C>: dt_today
                            AND SBQQ__ACTIVE__C = true
                            LIMIT 1
                           ];
            
            system.debug('lstTaxExempt--> ' + lstTaxExempt );
            
            if(lstTaxExempt.size()>0){
                isTaxExempt = true;
            }
            
            
            Map<String, Common_Variables__c> mapCV = Common_Variables__c.getAll();
            String CS_Endpoint = mapCV.get('B2BProd_Tax_API_URL').Content__c;
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
            system.debug('CS_CONTENT_TYPE >>'+CS_CONTENT_TYPE);
            system.debug('CS_CLIENT_ID >>'+CS_CLIENT_ID);
            system.debug('CS_CLIENT_SECRET >>'+CS_CLIENT_SECRET);
            
            
            List<OrderItem> lstOrderItem = new List<OrderItem>();
            lstOrderItem = [SELECT Id, OrderId, Product2Id, Product2.Name, Product2.ProductCode, Quantity, Number__c, Feature__c, isProductParent__c, 
                            Parent_Part_Number__c, Net_Unit_Price__c, SBQQ__TaxAmount__c, Item_Tax__c, Tax__c, Tax_Rate__c, Total_Tax_Amount__c 
                            FROM OrderItem    
                            WHERE OrderId=:orderId
                            ORDER BY Number__c
                           ];
            system.debug('lstOrderItem--> ' + lstOrderItem );
            
            
            // Payload Prepare
            dom.XmlNode xmlrequest = doc.createRootElement('request', null, null);
            dom.xmlNode items = xmlrequest.addChildElement('items',null,null);
            
            Map<String, List<OrderItem>> mapOrderItem= new Map<String, List<OrderItem>>();
            List<OrderItem> lstTempOrderItem = new List<OrderItem>();
            
            
            for(OrderItem oi : lstOrderItem ) {
                lstTempOrderItem = new List<OrderItem>();
                String key_oi = oi.Product2.ProductCode;
                if(mapOrderItem.keySet().contains(key_oi) ){
                    lstTempOrderItem.addAll(mapOrderItem.get(key_oi));
                }else{
                    mapOrderItem.put(key_oi, lstTempOrderItem);
                }
                lstTempOrderItem.add(oi);
                
                mapOrderItem.put(key_oi, lstTempOrderItem);
                
                System.debug('key_oi --> ' + key_oi);   
                System.debug('oi.Feature__c --> ' + oi.Feature__c);   
                
                dom.XmlNode item = items.addChildElement('item', null, null);
                
                dom.XmlNode partNumber = item.addChildElement('partNumber', null, null);
                if(oi.Feature__c==null || oi.Feature__c=='' || oi.Feature__c=='Parts' || mapServices.get(key_oi)==null ) {
                    partNumber.addTextNode(key_oi);
                }else{
                    partNumber.addTextNode(mapServices.get(key_oi));
                }
                
                string sint = string.valueof(Integer.valueof(oi.Quantity));
                dom.XmlNode quan = item.addChildElement('quantity', null, null);
                quan.addTextNode(sint);
                //    quan.addTextNode('1');
                
                string sitemprice = string.valueof(oi.Net_Unit_Price__c);
                dom.XmlNode itemPrice = item.addChildElement('itemPrice', null, null);
                itemPrice.addTextNode(sitemprice);
                
                dom.XmlNode itemType = item.addChildElement('itemType', null, null);
                dom.XmlNode parentItem = item.addChildElement('parentItem', null, null);
                if(oi.Parent_Part_Number__c==null || oi.Parent_Part_Number__c=='' || oi.Parent_Part_Number__c=='0' ) {
                    parentItem.addTextNode('true');
                }else{
                    parentItem.addTextNode('false');
                }
                
            }
            
            system.debug('mapOrderItem--> ' + mapOrderItem );
            
            if(objOrder.Delivery_Charge__c > 0 || objOrder.Premium_Delivery_Charge__c > 0 ){
                dom.XmlNode item = items.addChildElement('item', null, null);
                dom.XmlNode partNumber = item.addChildElement('partNumber', null, null);
                partNumber.addTextNode('000HD999000');
                dom.XmlNode quan = item.addChildElement('quantity', null, null);
                quan.addTextNode('1');
                Double totaldelivery = 0;
                if(objOrder.Delivery_Charge__c > 0){
                    totaldelivery += objOrder.Delivery_Charge__c;
                }
                if(objOrder.Premium_Delivery_Charge__c > 0){
                    totaldelivery += objOrder.Premium_Delivery_Charge__c;
                }
                string sitemprice = string.valueof(totaldelivery);
                dom.XmlNode itemPrice = item.addChildElement('itemPrice', null, null);
                itemPrice.addTextNode(sitemprice);
                dom.XmlNode parentItem = item.addChildElement('parentItem', null, null);
                parentItem.addTextNode('true');
            }
            
            if(objOrder.Haulaway_Charge__c > 0  ){
                dom.XmlNode item = items.addChildElement('item', null, null);
                dom.XmlNode partNumber = item.addChildElement('partNumber', null, null);
                partNumber.addTextNode('000HA999000');
                dom.XmlNode quan = item.addChildElement('quantity', null, null);
                quan.addTextNode('1');
                string sitemprice = string.valueof(objOrder.Haulaway_Charge__c);
                dom.XmlNode itemPrice = item.addChildElement('itemPrice', null, null);
                itemPrice.addTextNode(sitemprice);
                dom.XmlNode parentItem = item.addChildElement('parentItem', null, null);
                parentItem.addTextNode('true');
            }
            
            dom.xmlNode shipAddress = xmlrequest.addChildElement('shippingAddress', null, null);
            
            dom.xmlNode addressLine1 = shipAddress.addChildElement('addressLine1', null, null);
            addressLine1.addTextnode(objOrder.ShippingStreet);
            
            dom.xmlNode city = shipaddress.addChildElement('city', null, null);
            city.addTextnode(objOrder.ShippingCity);
            
            dom.xmlNode state = shipaddress.addChildElement('state', null, null);
            state.addTextnode(objOrder.ShippingState);
            
            dom.xmlNode zipCode = shipaddress.addChildElement('zipCode', null, null);
            zipCode.addTextNode(objOrder.ShippingPostalCode);
            /*
dom.xmlNode geocode = xmlrequest.addChildElement('geocode', null, null);
geocode.addTextNode(objOrder.Geo_Code__c);

dom.xmlNode company = xmlrequest.addChildElement('company', null, null);
company.addTextNode('sco');

dom.XmlNode countryCode = xmlrequest.addChildElement('countyCode', null, null);
countrycode.addTextNode(objOrder.County_Code__c);
*/
            string req = doc.toXmlString();
            
            system.debug('Items payload'+req);
            //Payload request
            request.setBody(req);
            
            CalloutB2BAPI.ResponseWrapper RW = CalloutB2BAPI.execute(request);
            taxRequest = req;
            taxResponse = string.valueof(RW);
            
            system.debug('callout success>>' +RW);
            
            if(RW.message == '' && RW.Response != null){
                
                system.debug('API response success');
                string resdoc = RW.Response.getBody();
                system.debug('Response output message:' +RW.Response.getBody());
                system.debug('mapOrderItem--> ' +mapOrderItem);
                
                DOM.Document docResp= new DOM.Document();
                docResp.load(resdoc);
                
                DOM.XmlNode root = docResp.getRootElement();
                //      string totaltax = root.getChildElement('totalTax',null).getText();
                
                //      system.debug('totaltax  >>>> '+root.getChildElement('totalTax',null).getText()); 
                
                DOM.XmlNode itemsXMLNode = root.getChildElement('items', null);
                dom.XmlNode [] itemXMLNode = itemsXMLNode.getchildelements();
                
                
                Map<String, Double> mapOLI_tr = new Map<String, Double>();
                Map<String, Double> mapOLI_tx = new Map<String, Double>();
                Map<String, Double> mapOLI_st = new Map<String, Double>();
                Map<String, Double> mapOLI_trx = new Map<String, Double>();
                
                objOrder.Other_Taxes__c = 0;
                Double otherTaxes = 0;
                
                for(DOM.XmlNode itemslist : itemXMLNode){
                    dom.XmlNode [] xitems = itemslist.getchildelements() ;
                    String key_rt = '';
                    
                    for(dom.XmlNode items_final: xitems) {
                        
                        if (items_final.getname() == 'partNumber'){
                            system.debug('items_final--> '+items_final.gettext());
                            //   key_rt += items_final.gettext();
                            if(!mapServicesCode.keyset().contains(items_final.gettext())){
                                key_rt = items_final.gettext();
                            }else if(items_final.gettext()=='000HD999000'){
                                key_rt = '000HD999000';
                            }else if(items_final.gettext()=='000HA999000'){
                                key_rt = '000HA999000';
                            }else{
                                key_rt = mapServicesCode.get(items_final.gettext());
                            }
                            system.debug('key_rt--> '+key_rt);
                        }
                        
                        if(key_rt!='000HD999000' && key_rt!='000HA999000' ){
                            
                            if (items_final.getname() == 'taxRate'){
                                system.debug('taxrate'+items_final.gettext());
                                string taxtext = items_final.gettext();
                                double staxrate = isTaxExempt?0:double.valueof(taxtext);
                                tottaxrate = staxrate*100 ;
                                system.debug('tax rate percentage' + tottaxrate);
                                newitems.add(staxrate);
                                mapOLI_tr.put(key_rt, staxrate);
                            }
                            
                            if (items_final.getname() == 'tax'){
                                system.debug('tax'+items_final.gettext());
                                string tax2text = items_final.gettext();
                                double stax = isTaxExempt?0:double.valueof(tax2text);
                                newitems.add(stax);
                                mapOLI_tx.put(key_rt, stax);
                                if(stax==0){
                                    mapOLI_trx.put(key_rt, stax);
                                }
                            }
                            
                            if (items_final.getname() == 'specialTax'){
                                system.debug('special Tax'+items_final.gettext());
                                string spltaxtext = items_final.gettext();
                                double spltaxrate = isTaxExempt?0:double.valueof(spltaxtext);
                                // tottaxrate = staxrate*100 ;
                                system.debug('Solid waste/disposable fee' + spltaxrate);
                                newitems.add(spltaxrate);
                                totalspltax = spltaxrate+totalspltax;
                                system.debug('Total Solid waste/disposable fee' + totalspltax);
                                mapOLI_st.put(key_rt, spltaxrate);
                            }
                        }else{
                            if(items_final.getname() == 'tax'){
                                system.debug('tax'+items_final.gettext());
                                string tax2text = items_final.gettext();
                                //      objOrder.Other_Taxes__c = isTaxExempt?0:double.valueof(tax2text);
                                otherTaxes += isTaxExempt?0:double.valueof(tax2text);
                                system.debug('otherTaxes' + otherTaxes);
                            }
                            
                        }
                        
                    }   
                }
                
                objOrder.Other_Taxes__c = otherTaxes;
                system.debug('objOrder--> ' + objOrder );
                update objOrder;
                
                system.debug('mapOrderItem >> '+mapOrderItem);
                system.debug('mapOLI_st >> '+mapOLI_st);
                system.debug('mapOLI_tr >> '+mapOLI_tr);
                system.debug('mapOLI_tx >> '+mapOLI_tx);
                system.debug('mapOLI_trx >> '+mapOLI_trx);
                
                List<OrderItem> lstOLIUpdate = new List<OrderItem>();
                OrderItem objOLIUpdate = new OrderItem();
                
                for(String moi: mapOrderItem.keyset()) {
                    for(OrderItem oi: mapOrderItem.get(moi)) {
                        objOLIUpdate = new OrderItem();
                        objOLIUpdate = oi;
                        objOLIUpdate.Tax_Rate__c = mapOLI_trx.get(moi)!=null?mapOLI_trx.get(moi):mapOLI_tr.get(moi) ;
                        objOLIUpdate.SBQQ__TaxAmount__c = mapOLI_tx.get(moi)!=null?mapOLI_tx.get(moi):0 + mapOLI_st.get(moi)!=null?mapOLI_st.get(moi):0 ;
                        objOLIUpdate.Item_Tax__c = mapOLI_tx.get(moi)!=null?mapOLI_tx.get(moi):0 + mapOLI_st.get(moi)!=null?mapOLI_st.get(moi):0 ;
                        lstOLIUpdate.add(objOLIUpdate);
                        system.debug('objOLIUpdate--> ' + objOLIUpdate );
                    }
                }
                system.debug('lstOLIUpdate--> ' + lstOLIUpdate );
                update  lstOLIUpdate;           
                
                
                
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
                if(messagesXMLNode!=null){
                    dom.XmlNode [] messageXMLNode = messagesXMLNode.getchildelements();
                    system.debug('messageXMLNode--> ' + messageXMLNode);
                    //  Integer count_error = 0;
                    for(dom.XmlNode mess: messageXMLNode) {
                        errMsg += mess.gettext();
                        system.debug('message'+mess.gettext());
                    }
                }
            }
            
        }else{
            if(objOrder.AccountId == null){
                errMsg += 'Missing Account';
            } 
            if(objOrder.ShippingPostalCode == null){
                errMsg += 'Missing Shipping Zip Code';
            } 
        }
        
        return errMsg;
        
    }
}