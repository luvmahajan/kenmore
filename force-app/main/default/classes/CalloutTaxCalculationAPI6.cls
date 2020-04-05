public class CalloutTaxCalculationAPI6 {
            
    public static void TaxCalcWrapper(SBQQ__Quote__c qheader) {
        
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
        mapServices.put('haulawayRequested', '000HA999000');
        mapServices.put('uncrate_K', '000UC999000');
        Map<String, String> mapServicesCode = new Map<String, String>();
        mapServicesCode.put('000BX999000', 'brownbox_10');
        mapServicesCode.put('000HK999000', 'hookup_3');
        mapServicesCode.put('000GH999000', 'gashookup_3');
        mapServicesCode.put('000HA999000', 'haulawayRequested');
        mapServicesCode.put('000UC999000', 'uncrate_K');
        
        List<SBQQ__TaxExemptionCertificate__c> lstTaxExempt = new List<SBQQ__TaxExemptionCertificate__c>();
        lstTaxExempt = [SELECT Id, Name, SBQQ__CERTIFICATENUMBER__C, SBQQ__ACCOUNT__C, 
                        SBQQ__ACTIVE__C, SBQQ__STATE__C, SBQQ__DATEISSUED__C, SBQQ__EXPIRATIONDATE__C
                        FROM SBQQ__TaxExemptionCertificate__c
                        WHERE SBQQ__ACCOUNT__C =: qheader.SBQQ__Account__c AND SBQQ__STATE__C=:qheader.SBQQ__ShippingState__c
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
        
        Map<String, List<Quote_Line_Staging__c>> mapQLStaging = new Map<String, List<Quote_Line_Staging__c>>();
        List<Quote_Line_Staging__c> lstTempStg = new List<Quote_Line_Staging__c>();
        
        List<Quote_Line_Staging__c> lt_qst = [select Id, Product__c, Product__r.ProductCode, Quantity__c, List_Unit_Price__c, Feature__c, 
                                              	Net_Unit_Price__c, Disposable_Fee__c, Tax_Rate__c, Total_Tax_Amount__c, Tax_Amount__c, Tax__c
                                              from  Quote_Line_Staging__c 
                                              where Quote__c = :qheader.Id  
                                             ] ;
        
        system.debug('quote line items' +lt_qst);
        system.debug('net total amount' +qheader.SBQQ__NetAmount__c);
        /*
        Map<String, String> mapSelectedProduct = new Map<String, String>();
        
        for(Quote_Line_Staging__c oi:lt_qst){
            if(oi.Feature__c==null || oi.Feature__c=='' ){
                mapSelectedProduct.put(oi.Product__c, oi.Product__r.ProductCode);
            }
        }		
        
        List<Product_Specification__c> lstProdSpec = new List<Product_Specification__c>();
        lstProdSpec = [SELECT Id, Name, Product__c, Product__r.ProductCode, Specification__c, Specification_Name__c 
                       FROM Product_Specification__c 
                       WHERE Product__c IN:mapSelectedProduct.keyset() AND Specification_Name__c IN ('Length', 'Width', 'Height', 'Weight')
                      ];
        system.debug('lstProdSpec--> ' + lstProdSpec );
        
        Map<String, String> mapProdSpec = new Map<String, String>();
        for(Product_Specification__c ps:lstProdSpec){
            mapProdSpec.put(ps.Product__c+ps.Specification_Name__c, ps.Specification__c);
        //    mapProdSpec.put(ps.Product__r.ProductCode + ps.Specification_Name__c, ps.Specification__c);
        }
        system.debug('mapProdSpec--> ' + mapProdSpec );

        Map<String, Double> mapProdMajor = new Map<String, Double>();
        Set<String> setProdMajor = new Set<String>();
        Double total_dim = 0;
        Double total_wt = 0;

        for(String oi:mapSelectedProduct.keyset()){
        	total_dim = 0;
        	total_wt = 0;
            if(mapProdSpec.get(oi+'Length')!= null 
               && mapProdSpec.get(oi+'Width') != null
               && mapProdSpec.get(oi+'Height') != null
              ){
                total_dim = Double.valueOf(mapProdSpec.get(oi+'Length')) * Double.valueOf(mapProdSpec.get(oi+'Width')) * Double.valueOf(mapProdSpec.get(oi+'Height'));
            }
            if(mapProdSpec.get(oi+'Weight')!= null){
                total_wt = Double.valueOf(mapProdSpec.get(oi+'Weight'));
            }
        	system.debug('Product --> ' + oi + 'Product Code --> ' + mapSelectedProduct.get(oi) + ' || total_dim --> ' + total_dim + ' || total_wt --> ' + total_wt );
            if(total_dim > 17820 || total_wt > 70 ){
                setProdMajor.add(mapSelectedProduct.get(oi));
            }
        }

        system.debug('setProdMajor--> ' + setProdMajor );



        
        
        Decimal del_first = 79;
        Decimal del_subsequent = 25;
        Decimal delivery_charge_kap = 0;
        integer cnt_qty = 0;
            
        List<Account> lstAccount = new List<Account>();
		lstAccount = [SELECT Id, Name, Delivery_Charge_First__c, Delivery_Charge_Subsequent__c, 
                      		ParentId, Parent.Name, Parent.Delivery_Charge_First__c, Parent.Delivery_Charge_Subsequent__c, 
                      		Parent.ParentId, Parent.Parent.Name, Parent.Parent.Delivery_Charge_First__c, Parent.Parent.Delivery_Charge_Subsequent__c 
                      FROM Account
                      WHERE Id =: qheader.SBQQ__Account__c
                      LIMIT 1
                     ];
        
        system.debug('lstAccount --> ' + lstAccount );
        
        if(lstAccount.size()>0){
            for(Account acc:lstAccount){
                if(acc.Parent.ParentId != null){
                    if(acc.Parent.Parent.Delivery_Charge_First__c!=null){
                        del_first = acc.Parent.Parent.Delivery_Charge_First__c;
                    }
                    if(acc.Parent.Parent.Delivery_Charge_Subsequent__c!=null){
                        del_subsequent = acc.Parent.Parent.Delivery_Charge_Subsequent__c;
                    }
                }else if(acc.ParentId != null){
                    if(acc.Parent.Delivery_Charge_First__c!=null){
                        del_first = acc.Parent.Delivery_Charge_First__c;
                    }
                    if(acc.Parent.Delivery_Charge_Subsequent__c!=null){
                        del_subsequent = acc.Parent.Delivery_Charge_Subsequent__c;
                    }
                }else{
                    if(acc.Delivery_Charge_First__c!=null){
                        del_first = acc.Delivery_Charge_First__c;
                    }
                    if(acc.Delivery_Charge_Subsequent__c!=null){
                        del_subsequent = acc.Delivery_Charge_Subsequent__c;
                    }
                }
            }
        }
        
        system.debug('del_first --> ' + del_first );
        system.debug('del_subsequent --> ' + del_subsequent );
        */
        // Payload Prepare
        dom.XmlNode xmlrequest = doc.createRootElement('request', null, null);
        dom.xmlNode items = xmlrequest.addChildElement('items',null,null);
        
        for(Quote_Line_Staging__c qst : lt_qst ) {
            
            lstTempStg = new List<Quote_Line_Staging__c>();
            String key_stg = qst.Product__r.ProductCode;//+string.valueof(Integer.valueof(qst.Quantity__c))+string.valueof(qst.Net_Unit_Price__c);
            if(mapQLStaging.keySet().contains(key_stg) ){
                lstTempStg.addAll(mapQLStaging.get(key_stg));
            }else{
                mapQLStaging.put(key_stg, lstTempStg);
            }
            lstTempStg.add(qst);
            
            mapQLStaging.put(key_stg, lstTempStg);
            
            
            
            System.debug('Callout--> Quote Line Items:'+qst.Product__r.ProductCode);   
            System.debug('qst.Feature__c:'+qst.Feature__c);   
            //string tempprod = string.valueof(qst.SBQQ__Product__r.ProductCode);
       //     if(string.ValueOf(qst.Product__r.ProductCode).startsWith('0')) {
      //      if(qst.Feature__c==null || qst.Feature__c=='' || qst.Feature__c=='Parts' ) {
      //      if(1==1) {
            system.debug('product code' +qst.Product__r.ProductCode);
            dom.XmlNode item = items.addChildElement('item', null, null);

            dom.XmlNode partNumber = item.addChildElement('partNumber', null, null);
            if(qst.Feature__c==null || qst.Feature__c=='' || qst.Feature__c=='Parts' || mapServices.get(qst.Product__r.ProductCode)==null ) {
                partNumber.addTextNode(qst.Product__r.ProductCode);
       /*     }else if(qst.Feature__c=='Services' ){
                if(mapServices.get(qst.Product__r.ProductCode)!=null){
                    partNumber.addTextNode(mapServices.get(qst.Product__r.ProductCode));
                }else{
                    partNumber.addTextNode(qst.Product__r.ProductCode);
                }
            }*/
            }else{
                partNumber.addTextNode(mapServices.get(qst.Product__r.ProductCode));
            }
                
            double quanint = qst.Quantity__c;
            
            string sint = string.valueof(Integer.valueof(quanint));
            
            dom.XmlNode quan = item.addChildElement('quantity', null, null);
         //   quan.addTextNode(sint);
            quan.addTextNode('1');
            
         //   double price = qst.List_Unit_Price__c;
            double price = qst.Net_Unit_Price__c;
            
         //   string sitemprice = string.valueof(price);
            string sitemprice = string.valueof(qst.Net_Unit_Price__c);
            
            dom.XmlNode itemPrice = item.addChildElement('itemPrice', null, null);
            itemPrice.addTextNode(sitemprice);
                system.debug('itemprice');
            dom.XmlNode itemType = item.addChildElement('itemType', null, null);
            dom.XmlNode parentItem = item.addChildElement('parentItem', null, null);
            if(qst.Feature__c==null || qst.Feature__c=='' ) {
//                itemType.addTextNode('PRODUCT');
                parentItem.addTextNode('true');
            }else if(qst.Feature__c=='Parts' ) {
//                itemType.addTextNode('PRODUCT');
                parentItem.addTextNode('false');
            }else{
//                itemType.addTextNode('SERVICES');
                parentItem.addTextNode('false');
                }
            
     //        }
     //        
           /*     if((qst.Feature__c==null || qst.Feature__c=='') && setProdMajor.contains(qst.Product__r.ProductCode) ){
                    system.debug('qst.Product__r.ProductCode--> ' + qst.Product__r.ProductCode + ' || qst.Feature__c--> ' + qst.Feature__c + ' || qst.Quantity__c--> ' + qst.Quantity__c );
                    cnt_qty += integer.valueOf(qst.Quantity__c);
                }*/
     //        
        }  
        /*
            if(cnt_qty > 0){
                delivery_charge_kap = cnt_qty * del_subsequent;
                delivery_charge_kap += (del_first - del_subsequent);
            }
                system.debug('cnt_qty--> ' + cnt_qty );
                system.debug('delivery_charge_kap--> ' + delivery_charge_kap );
        */
        
        if(qheader.Delivery_Total__c>0  ){
    //    if(delivery_charge_kap>0  ){
            dom.XmlNode item = items.addChildElement('item', null, null);
            dom.XmlNode partNumber = item.addChildElement('partNumber', null, null);
            partNumber.addTextNode('000HD999000');
            dom.XmlNode quan = item.addChildElement('quantity', null, null);
            quan.addTextNode('1');
            string sitemprice = string.valueof(qheader.Delivery_Total__c);
        //    string sitemprice = string.valueof(delivery_charge_kap);
            dom.XmlNode itemPrice = item.addChildElement('itemPrice', null, null);
            itemPrice.addTextNode(sitemprice);
            dom.XmlNode parentItem = item.addChildElement('parentItem', null, null);
            parentItem.addTextNode('true');
        }
        
        
        dom.xmlNode shipAddress = xmlrequest.addChildElement('shippingAddress', null, null);
        
        dom.xmlNode addressLine1 = shipAddress.addChildElement('addressLine1', null, null);
        addressLine1.addTextnode(qheader.SBQQ__ShippingStreet__c);
        
        dom.xmlNode city = shipaddress.addChildElement('city', null, null);
        city.addTextnode(qheader.SBQQ__ShippingCity__c);
        
        dom.xmlNode state = shipaddress.addChildElement('state', null, null);
        state.addTextnode(qheader.SBQQ__ShippingState__c);
        
        dom.xmlNode zipCode = shipaddress.addChildElement('zipCode', null, null);
        zipCode.addTextNode(qheader.SBQQ__ShippingPostalCode__c);
        /*
        dom.xmlNode geocode = xmlrequest.addChildElement('geocode', null, null);
        geocode.addTextNode(qheader.GeoCode__c);
        
        dom.xmlNode company = xmlrequest.addChildElement('company', null, null);
        company.addTextNode('sco');
        
        dom.XmlNode countryCode = xmlrequest.addChildElement('countyCode', null, null);
        countrycode.addTextNode(qheader.County_Code__c);
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
       //     response = http.send(request);
            
            
            
      //      system.debug( 'rescode= ' +response.getStatusCode());
      //      system.debug('resp message =' +response.getStatus());
        //    string resdoc = response.getBody();
       //     system.debug('Response output message:' +response.getBody());
            string resdoc = RW.Response.getBody();
            system.debug('Response output message:' +RW.Response.getBody());
        	system.debug('mapQLStaging--> ' +mapQLStaging);
            
            DOM.Document docResp= new DOM.Document();
            docResp.load(resdoc);
            
            DOM.XmlNode root = docResp.getRootElement();
      //      string totaltax = root.getChildElement('totalTax',null).getText();
            
      //      system.debug('totaltax  >>>> '+root.getChildElement('totalTax',null).getText()); 
            
            DOM.XmlNode itemsXMLNode = root.getChildElement('items', null);
            dom.XmlNode [] itemXMLNode = itemsXMLNode.getchildelements();
            
        
            List<Quote_Line_Staging__c> lstQLSUpdate = new List<Quote_Line_Staging__c>();
            Quote_Line_Staging__c objQLSUpdate = new Quote_Line_Staging__c();
        	Map<String, Double> mapQLStaging_tr = new Map<String, Double>();
        	Map<String, Double> mapQLStaging_tx = new Map<String, Double>();
        	Map<String, Double> mapQLStaging_st = new Map<String, Double>();
        	Map<String, Double> mapQLStaging_trx = new Map<String, Double>();
            
                        qheader.Delivery_Tax__c = 0;
            
            for(DOM.XmlNode itemslist : itemXMLNode) 
            {
                dom.XmlNode [] xitems = itemslist.getchildelements() ;
                String key_rt = '';
                
                for(dom.XmlNode items_final: xitems) {
                    
                //    if (items_final.getname() == 'partNumber' || items_final.getname() == 'quantity' || items_final.getname() == 'itemPrice' ){
                    if (items_final.getname() == 'partNumber'){// || items_final.getname() == 'quantity' || items_final.getname() == 'itemPrice' ){
                        system.debug('items_final--> '+items_final.gettext());
                     //   key_rt += items_final.gettext();
                        if(!mapServicesCode.keyset().contains(items_final.gettext())){
                            key_rt = items_final.gettext();
                        }else if(items_final.gettext()=='000HD999000'){
                            key_rt = '000HD999000';
                        }else{
                            key_rt = mapServicesCode.get(items_final.gettext());
                        }
                        system.debug('key_rt--> '+key_rt);
                    }
                    
                    if(key_rt!='000HD999000'){
                    
                    if (items_final.getname() == 'taxRate'){
                        system.debug('taxrate'+items_final.gettext());
                        string taxtext = items_final.gettext();
                        double staxrate = isTaxExempt?0:double.valueof(taxtext);
                        tottaxrate = staxrate*100 ;
                        system.debug('tax rate percentage' + tottaxrate);
                        newitems.add(staxrate);
                        mapQLStaging_tr.put(key_rt, staxrate);
                    }
                    
                    if (items_final.getname() == 'tax'){
                        system.debug('tax'+items_final.gettext());
                        string tax2text = items_final.gettext();
                        double stax = isTaxExempt?0:double.valueof(tax2text);
                        tottax = stax*100 ;
                        system.debug('tax percentage' + tottax);
                        newitems.add(stax);
                        mapQLStaging_tx.put(key_rt, stax);
                        if(stax==0){
                            mapQLStaging_trx.put(key_rt, stax);
                        }
                    }
                    /*
                    //Shipping charge only for shippable items (OMS/TW items)
                    if (items_final.getname() == 'shippingCharge'){
                        
                        if(items_final.getText()!='' && items_final.getText()!=null) {
                            system.debug('shippingCharge'+items_final.gettext());
                            string shipcharge = items_final.gettext();
                            //newitems.add(items_final.gettext());
                            double scharge = double.valueOf(shipcharge);
                            newitems.add(scharge);
                            system.debug('shipping item charge' +scharge);
                            totalshipsum = scharge+totalshipsum;
                            system.debug('total shipping charge' +totalshipsum);
                            
                        }
                    }
					*/
                    if (items_final.getname() == 'specialTax'){
                        system.debug('special Tax'+items_final.gettext());
                        string spltaxtext = items_final.gettext();
                        double spltaxrate = isTaxExempt?0:double.valueof(spltaxtext);
                       // tottaxrate = staxrate*100 ;
                        system.debug('Solid waste/disposable fee' + spltaxrate);
                        newitems.add(spltaxrate);
                        totalspltax = spltaxrate+totalspltax;
                        system.debug('Total Solid waste/disposable fee' + totalspltax);
                        mapQLStaging_st.put(key_rt, spltaxrate);
                    }
                    }else{
                        if(items_final.getname() == 'tax'){
                        system.debug('tax'+items_final.gettext());
                        string tax2text = items_final.gettext();
                        qheader.Delivery_Tax__c = isTaxExempt?0:double.valueof(tax2text);
                        system.debug('qheader.Delivery_Tax__c' + qheader.Delivery_Tax__c);
                        }
                        
                    }

                    
                }
                
            }
            
            
           // string deliveryCharge = root.getChildElement('deliveryCharge',null).getText();
            //double delcharge = double.valueOf(deliveryCharge);
            //system.debug('deliverycharge' + delcharge);
            //qheader.Delivery_charge__c = delcharge;
            /*
            double taxfinal = double.valueof(totaltax);
            system.debug('finaltax amount>>'+taxfinal);
            qheader.Disposable_Fee__c = totalspltax;
         //   qheader.Shipping_Charge__c = totalshipsum;
            qheader.Total_Tax_Amount__c = taxfinal;
            qheader.Tax_Rate__c = tottaxrate;
            */
            //DB Update
         //   qheader.Delivery_Charge__c = delivery_charge_kap;
            qheader.Tax_API_Request__c = taxRequest;
            qheader.Tax_API_Response__c = taxResponse;
            qheader.isTaxError__c = false;
            update qheader;
            system.debug('qheader--> ' + qheader );
            
            system.debug('mapQLStaging >> '+mapQLStaging);
            system.debug('mapQLStaging_st >> '+mapQLStaging_st);
            system.debug('mapQLStaging_tr >> '+mapQLStaging_tr);
            system.debug('mapQLStaging_tx >> '+mapQLStaging_tx);
            system.debug('mapQLStaging_trx >> '+mapQLStaging_trx);
                
          //  for(Quote_Line_Staging__c qs: mapQLStaging) {
            for(String qs: mapQLStaging.keyset()) {
                for(Quote_Line_Staging__c os: mapQLStaging.get(qs)) {
                	objQLSUpdate = new Quote_Line_Staging__c();
                    objQLSUpdate = os;
                objQLSUpdate.Disposable_Fee__c = mapQLStaging_st.get(qs) ;
                objQLSUpdate.Tax_Rate__c = mapQLStaging_trx.get(qs)!=null?mapQLStaging_trx.get(qs):mapQLStaging_tr.get(qs) ;
          //      objQLSUpdate.Total_Tax_Amount__c = mapQLStaging_tx.get(qs) ;
                objQLSUpdate.Tax_Amount__c = mapQLStaging_tx.get(qs) ;
                lstQLSUpdate.add(objQLSUpdate);
            system.debug('objQLSUpdate--> ' + objQLSUpdate );
                }
            }
            system.debug('lstQLSUpdate--> ' + lstQLSUpdate );
update  lstQLSUpdate;           
            
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
                        system.debug('message'+mess.gettext());
                    }
                }
            /*

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
}



*/
            
            
            
            
        //    qheader.Delivery_Charge__c = delivery_charge_kap;
            qheader.Tax_API_Request__c = taxRequest;
            qheader.Tax_API_Response__c = taxResponse;
            qheader.isTaxError__c = true;
            update qheader;
            system.debug('qheader--> ' + qheader );
            
            system.debug('API Response failure');
        }
    }
}