public class DemarChargesController {
    public String quoteId {get; set;}
    /*
    public Map<String, String> mapAccesorialCodes {get; set;}
    public List<Accessorials> lstAccessorials {get; set;}
    public List<Accessorials> lstAccessorialsPass {get; set;}
    public Integer quantity {get; set;}
    */
    public DemarChargesController(){
        quoteId = ApexPages.CurrentPage().getparameters().get('id');
        /*
        quantity = 0;
        
        mapAccesorialCodes = new Map<String, String>();
        lstAccessorials = new List<Accessorials>();
        lstAccessorialsPass = new List<Accessorials>();
        
        mapAccesorialCodes.put('2MAND', 'TWO MAN DELIVERY');
        mapAccesorialCodes.put('ADDMANPOWER', 'ADDITIONAL MANPOWER');
        mapAccesorialCodes.put('AFTERHRS', 'AFTER HOURS/WEEKEND');
        mapAccesorialCodes.put('ATTEMPT PU', 'ATTEMPTED PICK UP');
        mapAccesorialCodes.put('ATTEMPTED DELIVERY', 'ATTEMPTED DELIVERY');
        mapAccesorialCodes.put('COI', 'CERTIFICATE OF INSURANCE');
        mapAccesorialCodes.put('EXMILEAGE', 'EXCESS MILEAGE');
        mapAccesorialCodes.put('OUTAREA', 'OUT OF AREA SPECIAL CHARGE');
        mapAccesorialCodes.put('PACKAGING', 'PACKAGING');
        mapAccesorialCodes.put('PALLET', 'PALLETIZE FOR SHIPPING');
        mapAccesorialCodes.put('SDC', 'SPECIAL DELIVERY CHARGE');
        mapAccesorialCodes.put('STORAGE', 'STORAGE CHARGE');
        mapAccesorialCodes.put('SWAPOUT', 'SWAP OUT');
        mapAccesorialCodes.put('TIMESPECIFIC', 'TIME SPECIFIC CHARGE');
        mapAccesorialCodes.put('UNDELVD', 'UNDELIVERED ORDER HANDLING FEE');
        mapAccesorialCodes.put('WGTDET', 'WEIGHT DETERMINATION');
        
        Accessorials objAC = new Accessorials();
        
        for(String cd:mapAccesorialCodes.keySet()){
        	objAC = new Accessorials();
        	objAC.AccessorialCode = cd;
            objAC.Quantity = 0;
            lstAccessorials.add(objAC);
        }
        */
        
        
  //      redirectQLE();
    }
    
    
    public PageReference redirectQLE(){
        calculatePallet();
        PageReference retURL = new PageReference('/apex/ProductIntegration?id=' + quoteId );
        retURL.setRedirect(true);
        return retURL;
    }
    
    
    
    /*
    public PageReference actionCancel(){
        PageReference retURL = new PageReference('/apex/QuoteLineEditor?id=' + quoteId );
        retURL.setRedirect(true);
        return retURL;
    }
        
    public PageReference actionSubmit()
    {
		lstAccessorialsPass = new List<Accessorials>();    
        for(Accessorials ac:lstAccessorials){
            if(ac.Quantity>0){
                lstAccessorialsPass.add(ac);
            }
        }
        calculatePallet();
        PageReference retURL = new PageReference('/apex/QuoteLineEditor?id=' + quoteId );
        retURL.setRedirect(true);
        return retURL;
   //     
    }
    */
    
    
    public void calculatePallet(){
        
        Decimal limit_length = 48;
        Decimal limit_width = 40;
        Decimal limit_height = 91;
        Decimal limit_volume = limit_length*limit_width*limit_height;
        
        
/*        
        List<Quote_Line_Staging__c> lstQuoteLineStaging = new List<Quote_Line_Staging__c>();
        lstQuoteLineStaging = [SELECT Id, Name, Product__c, Quantity__c, Product__r.ProductCode, Product__r.Name, 
                               		Product__r.Product_Height__c, Product__r.Product_Length__c, 
                               		Product__r.Product_Weight__c, Product__r.Product_Width__c 
                               FROM Quote_Line_Staging__c 
                               WHERE Quote__c = :quoteId
                        AND (Feature__c=null OR Feature__c='Parts')
                               AND Product__r.Product_Height__c!=null AND Product__r.Product_Length__c!=null 
                               AND Product__r.Product_Weight__c!=null AND  Product__r.Product_Width__c!=null
                              ];
        system.debug('lstQuoteLineStaging--> ' + lstQuoteLineStaging );
        
        Map<String, Quote_Line_Staging__c> mapProductDimension = new Map<String, Quote_Line_Staging__c>();

        Set<Decimal> setVolume = new Set<Decimal>();
        
        for(Quote_Line_Staging__c stg:lstQuoteLineStaging){
            mapProductDimension.put(stg.Product__r.ProductCode,stg);
            for(integer cnt=1;cnt<=stg.Quantity__c;cnt++){
            Decimal tempVol = 0;
                tempVol = Decimal.valueof(stg.Product__r.Product_Length__c) * Decimal.valueof(stg.Product__r.Product_Width__c) * Decimal.valueof(stg.Product__r.Product_Height__c);
                setVolume.add(tempVol);
            }
        }
        */
        
        
        List<Quote_Line_Staging__c> lstQuoteLineStaging1 = new List<Quote_Line_Staging__c>();
        lstQuoteLineStaging1 = [SELECT Id, Name, Product__c, Product__r.ProductCode, Quantity__c 
                                FROM Quote_Line_Staging__c 
                                WHERE Quote__c = :quoteId
                                	AND (Feature__c=null OR Feature__c='Parts')
                                	AND Product__c!=null AND Quantity__c>0
                              ];
        system.debug('lstQuoteLineStaging1--> ' + lstQuoteLineStaging1 );
        
        
        Map<String, String> mapProductCode = new Map<String, String>();
        Map<String, Decimal> mapProductDimension2 = new Map<String, Decimal>();

        Set<String> setProduct1 = new Set<String>();
        Set<String> setDimensions1 = new Set<String>();
        
        for(Quote_Line_Staging__c stg1:lstQuoteLineStaging1){
            mapProductCode.put(stg1.Product__r.ProductCode,stg1.Product__c);
            mapProductDimension2.put(stg1.Product__c+'Quantity',stg1.Quantity__c);
            setProduct1.add(stg1.Product__c);
        }   
        
        setDimensions1.add('Depth');
        setDimensions1.add('Width');
        setDimensions1.add('Height');
        setDimensions1.add('Weight');
        setDimensions1.add('Length');
        setDimensions1.add('Length_Depth');
        
        List<Product_Specification__c> lstProdSpec1 = new List<Product_Specification__c>();
        lstProdSpec1 = [SELECT Id, Name, Product__c, Specification__c, Specification_Name__c 
                        FROM Product_Specification__c 
                        WHERE Product__c IN:setProduct1 AND Name='Dimensions'
                        	AND Specification_Name__c IN: setDimensions1
                       ];
        system.debug('lstProdSpec1--> ' + lstProdSpec1 );
        
        for(Product_Specification__c ps1:lstProdSpec1){
            try{
                mapProductDimension2.put(ps1.Product__c+ps1.Specification_Name__c, decimal.valueOf(ps1.Specification__c));
            }catch(exception e){
                system.debug('Error for Product--> ' + ps1.Product__c + ' and Specification--> ' + ps1.Specification_Name__c );
            }
        }

        system.debug('mapProductDimension2--> ' + mapProductDimension2 );
        
        Set<Decimal> setVolume1 = new Set<Decimal>();
        Map<String, Decimal> mapProductDimension3 = new Map<String, Decimal>();
        
        for(String sp1:setProduct1){
            if(mapProductDimension2.get(sp1+'Quantity')>0 && mapProductDimension2.get(sp1+'Width')>0 
               && mapProductDimension2.get(sp1+'Height')>0 && mapProductDimension2.get(sp1+'Weight')>0 
              ){
                  if(mapProductDimension2.get(sp1+'Length')>0 && mapProductDimension2.get(sp1+'Depth')==null ){
                      mapProductDimension3.put(sp1+'Quantity',mapProductDimension2.get(sp1+'Quantity'));
                      mapProductDimension3.put(sp1+'Width',mapProductDimension2.get(sp1+'Width'));
                      mapProductDimension3.put(sp1+'Height',mapProductDimension2.get(sp1+'Height'));
                      mapProductDimension3.put(sp1+'Weight',mapProductDimension2.get(sp1+'Weight'));
                      mapProductDimension3.put(sp1+'Length_Depth',mapProductDimension2.get(sp1+'Length'));
                      Decimal tempVol1 = 0;
                      tempVol1 = mapProductDimension3.get(sp1+'Length_Depth') * mapProductDimension3.get(sp1+'Width') * mapProductDimension3.get(sp1+'Height');
                      setVolume1.add(tempVol1);
                  }else if(mapProductDimension2.get(sp1+'Depth')>0 && mapProductDimension2.get(sp1+'Length')==null){
                      mapProductDimension3.put(sp1+'Quantity',mapProductDimension2.get(sp1+'Quantity'));
                      mapProductDimension3.put(sp1+'Width',mapProductDimension2.get(sp1+'Width'));
                      mapProductDimension3.put(sp1+'Height',mapProductDimension2.get(sp1+'Height'));
                      mapProductDimension3.put(sp1+'Weight',mapProductDimension2.get(sp1+'Weight'));
                      mapProductDimension3.put(sp1+'Length_Depth',mapProductDimension2.get(sp1+'Depth'));
                      Decimal tempVol1 = 0;
                      tempVol1 = mapProductDimension3.get(sp1+'Length_Depth') * mapProductDimension3.get(sp1+'Width') * mapProductDimension3.get(sp1+'Height');
                      setVolume1.add(tempVol1);
                  }
              }
        }
        
        List<Decimal> lstVolumeAsc = new List<Decimal>();
   //     lstVolumeAsc.addAll(setVolume);
        lstVolumeAsc.addAll(setVolume1);
        
        lstVolumeAsc.sort();
        	system.debug('lstVolumeAsc--> ' + lstVolumeAsc );
        
        List<Decimal> lstVolumeDesc = new List<Decimal>();
        
        for(integer i=1;i<=lstVolumeAsc.size();i++){
            lstVolumeDesc.add(lstVolumeAsc[lstVolumeAsc.size()-i]);
        }
         
        system.debug('lstVolumeDesc--> ' + lstVolumeDesc );
        
        Map<Decimal,Set<String>> mapProductVolume = new Map<Decimal,Set<String>>(); 
        Set<String> setTempProducts = new Set<String>();
        for(Quote_Line_Staging__c st: lstQuoteLineStaging1){
            setTempProducts = new Set<String>();
            Decimal tempVol = 0;
            if(mapProductDimension3.get(st.Product__c+'Quantity')>0 && mapProductDimension3.get(st.Product__c+'Width')>0 
               && mapProductDimension3.get(st.Product__c+'Height')>0 && mapProductDimension3.get(st.Product__c+'Weight')>0 
               && mapProductDimension3.get(st.Product__c+'Length_Depth')>0 ){ 
        //    tempVol = Decimal.valueof(st.Product__r.Product_Length__c) * Decimal.valueof(st.Product__r.Product_Width__c) * Decimal.valueof(st.Product__r.Product_Height__c);
			tempVol = mapProductDimension3.get(st.Product__c+'Length_Depth') * mapProductDimension3.get(st.Product__c+'Width') * mapProductDimension3.get(st.Product__c+'Height');
            if(mapProductVolume.keySet().contains(tempVol)){
                setTempProducts.addAll(mapProductVolume.get(tempVol));
            }else{
                mapProductVolume.put(tempVol, setTempProducts);
            }
            setTempProducts.add(st.Product__r.ProductCode);
            
            mapProductVolume.put(tempVol, setTempProducts);
               }
        }
        system.debug('mapProductVolume --> ' + mapProductVolume );
        
        List<PalletProducts> lstPalletProducts = new List<PalletProducts>();
        PalletProducts objPalletProducts = new PalletProducts();
        Set<Integer> setTempPalletProducts = new Set<Integer>();
       	Integer seq_pp = 1;
        
        for(Decimal pv:lstVolumeDesc){
            for(String cd:mapProductVolume.get(pv)){
        //        for(integer cnt=1;cnt<=mapProductDimension.get(cd).Quantity__c;cnt++){
                for(integer cnt=1;cnt<=mapProductDimension3.get(mapProductCode.get(cd)+'Quantity');cnt++){
                    objPalletProducts = new PalletProducts();
                    objPalletProducts.seq_no = seq_pp;
                    objPalletProducts.ProductCode = cd;
                    objPalletProducts.volume = pv;
           //         objPalletProducts.weight = Decimal.valueof(mapProductDimension.get(cd).Product__r.Product_Weight__c);
                    objPalletProducts.weight = mapProductDimension3.get(mapProductCode.get(cd)+'Weight');
                    lstPalletProducts.add(objPalletProducts);
                    setTempPalletProducts.add(seq_pp);
                    seq_pp++;
                }
            }
        }

        	system.debug('lstPalletProducts--> ' + lstPalletProducts );
        	system.debug('setTempPalletProducts--> ' + setTempPalletProducts );
        
        List<PalletDimension> lstPalletDimension = new List<PalletDimension>();
        for(integer i=1;setTempPalletProducts.size()>0;i++){
        Decimal temp_limit_volume = limit_volume;
        Decimal temp_limit_weight = 0;
        Integer temp_count = 0;
        
        PalletDimension objPalletDimension = new PalletDimension();
        for(PalletProducts pl:lstPalletProducts){
        //    if(pl.volume<=temp_limit_volume && pl.weight<=temp_limit_weight && setTempPalletProducts.contains(pl.seq_no) ){
            if(pl.volume<=temp_limit_volume && setTempPalletProducts.contains(pl.seq_no) ){
            	temp_limit_volume -= pl.volume;
            //	temp_limit_weight -= pl.weight;
            	temp_limit_weight += (pl.weight>=(pl.volume/194)?pl.weight:(pl.volume/194));
            	temp_count++;
                setTempPalletProducts.remove(pl.seq_no);
        	system.debug('setTempPalletProducts--> ' + setTempPalletProducts );
            }
        }
        
        objPalletDimension = new PalletDimension();
        objPalletDimension.seq_no = i;
        objPalletDimension.pieces = temp_count;
    //    objPalletDimension.weight = limit_weight-temp_limit_weight;
        objPalletDimension.weight = temp_limit_weight;
        objPalletDimension.volume = limit_volume-temp_limit_volume;
        objPalletDimension.seq_key = string.valueOf(objPalletDimension.pieces) + string.valueOf(objPalletDimension.weight) + string.valueOf(objPalletDimension.volume);
            
        lstPalletDimension.add(objPalletDimension);
        }
        	system.debug('lstPalletDimension--> ' + lstPalletDimension );
        
        PalletLineItem objTempPalletLineItem = new PalletLineItem();
        Map<String,PalletLineItem> mapPalletDimension = new Map<String,PalletLineItem>();
        
        for(PalletDimension pd:lstPalletDimension){
            String tempPalletString = string.valueOf(pd.pieces) + string.valueOf(pd.weight) + string.valueOf(pd.volume);
            if(mapPalletDimension.keySet().contains(tempPalletString)){
                objTempPalletLineItem = new PalletLineItem();
                objTempPalletLineItem.pallet = mapPalletDimension.get(tempPalletString).pallet+1;
                objTempPalletLineItem.pieces = mapPalletDimension.get(tempPalletString).pieces+pd.pieces;
                objTempPalletLineItem.weight = mapPalletDimension.get(tempPalletString).weight+pd.weight;
                mapPalletDimension.put(tempPalletString,objTempPalletLineItem);
            }else{
                objTempPalletLineItem = new PalletLineItem();
                objTempPalletLineItem.pallet = 1;
                objTempPalletLineItem.pieces = pd.pieces;
                objTempPalletLineItem.weight = pd.weight;
                mapPalletDimension.put(tempPalletString,objTempPalletLineItem);
            }
        }      
    
        List<PalletLineItem> lstPalletLineItems = new List<PalletLineItem>();
        PalletLineItem objPalletLineItem = new PalletLineItem();
            for(String mpd:mapPalletDimension.keyset()){
                objPalletLineItem = new PalletLineItem();
                objPalletLineItem.pallet = mapPalletDimension.get(mpd).pallet;
                objPalletLineItem.pieces = mapPalletDimension.get(mpd).pieces;
                objPalletLineItem.weight = mapPalletDimension.get(mpd).weight.setScale(2);
                lstPalletLineItems.add(objPalletLineItem);
            }
        
        
        List<ShipmentLineItems> lstShipmentLineItems = new List<ShipmentLineItems>();
        ShipmentLineItems objShipmentLineItems = new ShipmentLineItems();
        
        	system.debug('mapPalletDimension--> ' + mapPalletDimension );
            for(String mpd:mapPalletDimension.keyset()){
                objShipmentLineItems = new ShipmentLineItems();
                objShipmentLineItems.Pallets = mapPalletDimension.get(mpd).pallet;
                objShipmentLineItems.Pieces = mapPalletDimension.get(mpd).pieces;
                objShipmentLineItems.Weight = mapPalletDimension.get(mpd).weight.setScale(2);
                lstShipmentLineItems.add(objShipmentLineItems);
            }
        
        	system.debug('lstShipmentLineItems--> ' + lstShipmentLineItems );
        
        if(lstShipmentLineItems.size()>0){
        	ShippingChargeSend(lstShipmentLineItems);
        }
    }
    public void ShippingChargeSend(List<ShipmentLineItems> lstShipmentLineItems) {
        
        List<testshippingsend> lsttestshippingsend = new List<testshippingsend>();
        testshippingsend objtestshippingsend = new testshippingsend();
        
        
        objtestshippingsend.ServiceLevel = 'Standard'; //Standard, Premium
        
        objtestshippingsend.ConsigneeAddress = new Address();
        
        SBQQ__Quote__c quotedetails = new SBQQ__Quote__c();
        quotedetails = [select Id, SBQQ__ShippingCity__c, SBQQ__ShippingPostalCode__c, SBQQ__ShippingState__c, SBQQ__ShippingStreet__c, SBQQ__ShippingName__c, isValidAddress__c, SBQQ__ShippingCountry__c, Store_Number__c from SBQQ__Quote__c  where Id = :quoteId];
        if(quotedetails.Store_Number__c != null && quotedetails.isValidAddress__c == true ){
            
            List<Common_Carrier_Address__mdt> lstCommonCarrier = new List<Common_Carrier_Address__mdt>();
            lstCommonCarrier = [SELECT Id, Street__c, City__c, State__c, Zip__c, Store__c FROM Common_Carrier_Address__mdt WHERE Store__c =:quotedetails.Store_Number__c LIMIT 1]; 
            if(lstCommonCarrier.size()>0){
            objtestshippingsend.ConsigneeAddress = new Address();
            objtestshippingsend.ConsigneeAddress.AddressLine1 = lstCommonCarrier[0].Street__c;
            objtestshippingsend.ConsigneeAddress.AddressLine2 = '';
            objtestshippingsend.ConsigneeAddress.AddressLine3 = '';
            objtestshippingsend.ConsigneeAddress.City = lstCommonCarrier[0].City__c;
            objtestshippingsend.ConsigneeAddress.State_Province = lstCommonCarrier[0].State__c;
            objtestshippingsend.ConsigneeAddress.Zip = lstCommonCarrier[0].Zip__c;
            objtestshippingsend.ConsigneeAddress.Country = 'US';//quotedetails.SBQQ__ShippingCountry__c;
            system.debug('objtestshippingsend.ConsigneeAddress--> ' + objtestshippingsend.ConsigneeAddress );
            } 
        }
        
        objtestshippingsend.ShipperAddress = new Address();
        
        if(quotedetails.SBQQ__ShippingCity__c != null && quotedetails.SBQQ__ShippingPostalCode__c != null && quotedetails.SBQQ__ShippingState__c != null && quotedetails.SBQQ__ShippingStreet__c != null && quotedetails.SBQQ__ShippingName__c != null && quotedetails.SBQQ__ShippingCountry__c != null && quotedetails.isValidAddress__c == true ){
            objtestshippingsend.ShipperAddress = new Address();
            objtestshippingsend.ShipperAddress.AddressLine1 = quotedetails.SBQQ__ShippingStreet__c;
            objtestshippingsend.ShipperAddress.AddressLine2 = '';
            objtestshippingsend.ShipperAddress.AddressLine3 = '';
            objtestshippingsend.ShipperAddress.City = quotedetails.SBQQ__ShippingCity__c;
            objtestshippingsend.ShipperAddress.State_Province = quotedetails.SBQQ__ShippingState__c;
            objtestshippingsend.ShipperAddress.Zip = quotedetails.SBQQ__ShippingPostalCode__c;
            objtestshippingsend.ShipperAddress.Country = 'US';//quotedetails.SBQQ__ShippingCountry__c;
            
            system.debug('objtestshippingsend.ShipperAddress--> ' + objtestshippingsend.ShipperAddress );
            
  //          objtestshippingsend.ConsigneeAddress = new Address();
  //          objtestshippingsend.ConsigneeAddress = objtestshippingsend.ShipperAddress;
        }
        
        objtestshippingsend.ShipmentLineItems = new List<ShipmentLineItems>();
        objtestshippingsend.ShipmentLineItems.addAll(lstShipmentLineItems);
        
        system.debug('objtestshippingsend.ShipmentLineItems--> ' + objtestshippingsend.ShipmentLineItems );
        
        objtestshippingsend.Accessorials = new List<Accessorials>();
//        objtestshippingsend.Accessorials.addAll(lstAccessorialsPass);
        
//        system.debug('objtestshippingsend.Accessorials--> ' + objtestshippingsend.Accessorials );
        
        String JSONString_shipping = JSON.serialize(objtestshippingsend);
        System.debug('Serialized  JSON format: ' + JSONString_shipping);
        
        Map<String, Common_Variables__c> mapCV = Common_Variables__c.getAll();
   //     String CS_CLIENT_ID = mapCV.get('B2BProd_ClientId').Content__c;
  //      String CS_CLIENT_SECRET = mapCV.get('B2BProd_ClientSecret').Content__c;
  //      String CS_CONTENT_TYPE = mapCV.get('B2BProd_ContentType_XML').Content__c;
        
        String CS_Authorization = mapCV.get('DEMAR_Authorization').Content__c;
        String CS_CONTENT_TYPE = mapCV.get('DEMAR_ContentType').Content__c;
        String EndpointUrl = mapCV.get('DEMAR_Rating_URL').Content__c;
        
        
        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        Http http = new Http();
            
            
     //   EndpointUrl += tmpprodlist+'?price=true&availability=true&shipping=true&zipcode='+qshipzip;
        
        request.setMethod('POST');
        request.setendPoint(EndpointUrl);
        system.debug('EndpointUrl >>'+EndpointUrl);
        
        request.setHeader('Content-Type', CS_CONTENT_TYPE);
        request.setHeader('Authorization', CS_Authorization);
 
        request.setBody(JSONString_shipping);
        
        	CalloutB2BAPI.ResponseWrapper RW = CalloutB2BAPI.execute(request);
        system.debug('RW>>' +RW);
            
        //Response
        Double demar_charge = 0;
        String demar_response = '';
        
        
        if(Test.isRunningTest() || (RW.message == '' && RW.Response != null)){
            system.debug('API response success');
            
            string resdoc = '';
            if(!Test.isRunningTest()){
            system.debug('RW.Response--> ' + RW.Response );
                resdoc = RW.Response.getBody();
            }else{
                resdoc = '{ "AccessorialCharges": [], "FuelSurcharge": 17.07, "ResponseCode": "Success", "ResponseMessage": null, "TransportationCharge": 72.65 }';
            }
            system.debug('resdoc:' +resdoc);
            
            DeserializeShippingChargeHelper obj = DeserializeShippingChargeHelper.parse(resdoc);
            system.debug('obj:' +obj);
            
            demar_charge = 0;
            
            if(obj.ResponseCode=='Success' && obj.ResponseMessage==null ){
                demar_charge+=obj.FuelSurcharge;
                demar_charge+=obj.TransportationCharge;
                for(integer i=0;i<obj.AccessorialCharges.size();i++){
                    demar_charge+=obj.AccessorialCharges[i].Charge;
                }
                demar_response = obj.ResponseCode;
            }else if(obj.ResponseCode=='Error' && obj.ResponseMessage!=null ){
                demar_response = obj.ResponseCode + ' - ' + obj.ResponseMessage;
            }
            
            
        }else{
                system.debug('API response failure');
            system.debug('RW.Response--> ' + RW.Response );
            system.debug('RW.message--> ' + RW.message );
            demar_response = RW.message;
        }            
            
            
            system.debug('demar_charge--> ' + demar_charge );
            system.debug('demar_response--> ' + demar_response );
        
        List<SBQQ__Quote__c> lstQuote = new List<SBQQ__Quote__c>();
        lstQuote = [SELECT Id, Name, SBQQ__DeliveryMethod__c, Delivery_Charge__c, Delivery_Discount__c, Delivery_Message__c FROM SBQQ__Quote__c WHERE Id =: quoteId LIMIT 1];
        
        if(lstQuote.size()>0){
            for (SBQQ__Quote__c qdel:lstQuote){
                qdel.SBQQ__DeliveryMethod__c = 'DEMAR';
                qdel.Delivery_Charge__c = demar_charge;
                qdel.Delivery_Message__c = demar_response;                
                qdel.Delivery_Discount__c = 0;                
            }
        }
        update lstQuote;
        
    
        
    }
   
    public class PalletProducts{
        public Integer seq_no {get;set;}
        public String ProductCode {get;set;}
        public Decimal volume {get;set;}
        public Decimal weight {get;set;}
    }
    
    public class PalletDimension{
        public String seq_key {get;set;}
        public Integer seq_no {get;set;}
        public Integer pieces {get;set;}
        public Decimal weight {get;set;}
        public Decimal volume {get;set;}
    }

    public class PalletLineItem{
        public String seq_no {get;set;}
        public Integer pallet {get;set;}
        public Integer pieces {get;set;}
        public Decimal weight {get;set;}
    }
    
    public class ShipmentLineItems {
        public Integer Pallets {get;set;}
        public Integer Pieces {get;set;}
        public Decimal Weight {get;set;}
    }
    
    public class Address {
        public String AddressLine1 {get;set;}
        public String AddressLine2 {get;set;}
        public String AddressLine3 {get;set;}
        public String City {get;set;}
        public String State_Province {get;set;}
        public String Zip {get;set;}
        public String Country {get;set;}
    }
    
    public class Accessorials {
        public String AccessorialCode {get;set;}
        public Integer Quantity {get;set;}
    }
    
	public class AccessorialCharges {
		public String AccessorialCode {get;set;}
		public Double Charge {get;set;}
	}
    
    public class testshippingsend {
    	public String ServiceLevel {get;set;}
    	public Address ShipperAddress {get;set;}
    	public Address ConsigneeAddress {get;set;}
    	public List<ShipmentLineItems> ShipmentLineItems {get;set;}
    	public List<Accessorials> Accessorials {get;set;}
    }
    
    
    
}