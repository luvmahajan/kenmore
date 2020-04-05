public class ProductAccesorriesController {

    public String quoteId {get; set;}
    public String parentUnique {get; set;}
    public String editProduct {get; set;}
    public String productId {get; set;}
    public List<String> lstProductCode {get; set;}
    public Map<String,String> mapProductCodeName {get; set;}
    public Map<String,List<OptionProduct>> mapOptionProduct {get; set;}
    public Map<String,List<OptionProduct>> mapOptionProduct1 {get; set;}
    public Map<String,Set<String>> mapFeatureSelect {get; set;}
    public Map<String,Boolean> mapFeatureRender {get; set;}
    public Map<String,Boolean> renFeatureSelect {get; set;}
    public Map<String,String> mapInstallation {get; set;}
    public Map<String,String> mapselInstallation {get; set;}
    public Map<String,Boolean> maprenInstallation {get; set;}
    public Map<String,String> mapInstallationPrice {get; set;}
    public Map<String,Boolean> maprenInstallprice {get; set;}
    public String selInstallation {get; set;}
    public Boolean renInstallation {get; set;}
    public Boolean renRedirect {get; set;}
    public Boolean renError {get; set;}
    public String strError {get; set;}
    public Boolean renFulfillment {get; set;}
    
    public Map<String,List<String>> mapProductKey {get; set;}
    public Map<String,String> mapProductCode {get; set;}
    public Map<String,Double> mapKAP {get; set;}
    public Map<String,Double> mapCost {get; set;}
//    public Map<String,Double> mapServicePrice {get; set;}
//    public Map<String,String> mapServiceName {get; set;}
//    public Map<String,Double> mapKAPService {get; set;}
    public Map<String,String> mapPriceSource {get; set;}
    public Map<String,Double> mapKAPService2 {get; set;}
    
    public Integer RW_Code {get; set;}
    public String RW_Message {get; set;}
    
    public String configurationcode {get; set;}
    public String configurationoption {get; set;}
    
    public Boolean renHaulAway {get; set;}
    
    public Set<Quote_Line_Staging__c> setQLSSubstitute {get; set;}
    public Set<Quote_Line_Staging__c> setQLSEdit {get; set;}
    
    public ProductAccesorriesController() {
        quoteId = ApexPages.CurrentPage().getparameters().get('id');
        productId = ApexPages.CurrentPage().getparameters().get('prodid');
        parentUnique = ApexPages.CurrentPage().getparameters().get('pu');
        system.debug('parentUnique--> ' + parentUnique );
        editProduct = ApexPages.CurrentPage().getparameters().get('pe');
        system.debug('editProduct--> ' + editProduct );
    //    quoteId = 'a2bW0000000ko3EIAQ';
   //     productId = '01tW0000003QCJxIAO';
        selInstallation = '';
        renInstallation = false;
        renRedirect = false;        
        renError = false;
        strError = '';
        renFulfillment = false;
        renHaulAway = false;
        mapselInstallation = new Map<String, String>();
        maprenInstallation = new Map<String, Boolean>();
        mapInstallationPrice = new Map<String, String>();
        maprenInstallprice = new Map<String, Boolean>();
        mapProductKey = new Map<String,List<String>>();
        mapOptionProduct = new Map<String,List<OptionProduct>>();
 //       mapServicePrice = new Map<String, Double>();
 //       mapServiceName = new Map<String, String>();
 //       mapKAPService = new Map<String, Double>();
        mapKAPService2 = new Map<String, Double>();
        mapPriceSource = new Map<String, String>();
        
        String quoteShippingZip = '';
        String accountId = '';
        String account_tier = '';
        String account_price_type = '';
        String account_SCO_Id = '';
        
        configurationcode = '';
        configurationoption = '';
        
            mapOptionProduct = new Map<String,List<OptionProduct>>();
            mapOptionProduct1 = new Map<String,List<OptionProduct>>();
            mapFeatureSelect = new Map<String,Set<String>>();
            mapFeatureRender = new Map<String,Boolean>();
            renFeatureSelect = new Map<String,Boolean>();
        
        
        
        setQLSSubstitute = new Set<Quote_Line_Staging__c>();
        setQLSEdit = new Set<Quote_Line_Staging__c>();
        
    //    mapKAPService
    //    
    //    
    //    
        List<Key_Account_Pricing__c> lstKAPService = new List<Key_Account_Pricing__c>();
        lstKAPService = [SELECT Id, Customer_KAP_price__c, Valid_from__c, Valid_to__c, Customer__c, Price_List_Type__c, Material_Number__c//, Product__c
                         FROM Key_Account_Pricing__c
                         WHERE Material_Number__c LIKE '4%'
                         AND 
                         (
                             (Customer__c!=null AND Price_List_Type__c=null AND Customer__c=: accountId) 
                             OR 
                             (Customer__c=null AND Price_List_Type__c!=null AND Price_List_Type__c=:account_price_type)
                         ) 
                         AND Valid_from__c<=:system.today() AND Valid_to__c>=:system.today()
                        ];
        
        
        for(Key_Account_Pricing__c lks:lstKAPService){
  //          mapKAPService.put(lks.Material_Number__c, lks.Customer_KAP_price__c);
            mapKAPService2.put(lks.Material_Number__c, lks.Customer_KAP_price__c);
        }
        //account_tier
        List<Product_Pricing__c> lstProductPricingService = new List<Product_Pricing__c>();
        lstProductPricingService = [SELECT Id, Price__c, Cost__c, Material_Number__c//, Product__c
                                    FROM Product_Pricing__c
                                    WHERE Material_Number__c LIKE '4%'
                                   ];
        
        for(Product_Pricing__c lps:lstProductPricingService){
            /*
            if(mapKAPService.get(lps.Material_Number__c)==null){
                mapKAPService.put(lps.Material_Number__c, lps.Price__c);
                mapKAPService2.put(lps.Material_Number__c, lps.Price__c);
            }
*/
            
            if(mapKAPService2.get(lps.Material_Number__c)==null){
                mapKAPService2.put(lps.Material_Number__c, lps.Price__c);
            }
            
        }
       
    //    
    //    
    //    
    //    
        /*
            List<Service__mdt> lstServicePrice = new List<Service__mdt>();
            lstServicePrice = [SELECT Id, MasterLabel, Price__c FROM Service__mdt]; 
        for(Service__mdt sp:lstServicePrice){
            mapServicePrice.put(sp.MasterLabel, sp.Price__c);
      //      if(sp.B2B_Code__c!=null){
            mapKAPService.put(sp.MasterLabel, sp.Price__c);
            if(mapKAPService.keyset().contains(sp.B2B_Code__c)){
                mapServiceName.put(sp.MasterLabel, sp.B2B_Code__c);
            }
        }
        System.debug('mapServicePrice--> ' + mapServicePrice);
        System.debug('mapServiceName--> ' + mapServiceName);
        System.debug('mapKAPService--> ' + mapKAPService);
        */
        
        List<SBQQ__Quote__c>lstQuote = new List<SBQQ__Quote__c>();
        lstQuote = [SELECT Id, Name, SBQQ__ShippingPostalCode__c, SBQQ__Account__c, SBQQ__Account__r.SCO_Account_Id__c, 
                    SBQQ__Account__r.Pricing_Tier__c, SBQQ__Account__r.Price_List_Type__c
                    FROM SBQQ__Quote__c 
                    WHERE Id =: quoteId LIMIT 1
                   ];
        
        if(lstQuote.size()>0){
            quoteShippingZip = lstQuote[0].SBQQ__ShippingPostalCode__c;
            accountId = lstQuote[0].SBQQ__Account__c;
            account_tier = lstQuote[0].SBQQ__Account__r.Pricing_Tier__c;
            account_price_type = lstQuote[0].SBQQ__Account__r.Price_List_Type__c;
            if(lstQuote[0].SBQQ__Account__r.SCO_Account_Id__c!=null)
            account_SCO_Id = lstQuote[0].SBQQ__Account__r.SCO_Account_Id__c;
        }
        
        List<Quote_Line_Staging__c>lstQuoteLineStagingQry = new List<Quote_Line_Staging__c>();
        lstQuoteLineStagingQry = [SELECT Id, Name, Quote__c, Product__r.ProductCode 
                                  FROM Quote_Line_Staging__c 
                                  WHERE Quote__c =: quoteId AND Product__r.ProductCode='haulawayRequested' 
                                  LIMIT 1];
        
        if(lstQuoteLineStagingQry.size()>0){
            renHaulAway = true;
        }
        
        if(editProduct!=null){
            List<Quote_Line_Staging__c>lstQLSEdit = new List<Quote_Line_Staging__c>();
            lstQLSEdit = [SELECT Id, Name, CreatedDate, Quote__c, Product__c, Product__r.ProductCode, Quantity__c, 
                                List_Unit_Price__c, List_Unit_Cost__c, Additional_Disc__c, Net_Unit_Price__c, Set_Unit_Price__c,  
                                Price_Source__c, ProductParent__c, ProductParentUnique__c, isProductParent__c, 
                                Substituted_Product__c, Substituted_Product_Code__c, Substituted_Product_Cost__c, 
                                Substituted_Product_Created_Date__c, Substituted_Product_Price__c, Substituted_Product_Quantity__c,
                                Substituted_Product_Source__c, Substitution_Reason__c
                          FROM Quote_Line_Staging__c 
                          WHERE Quote__c =: quoteId AND isProductParent__c = true AND ProductParentUnique__c =: editProduct  
                          LIMIT 1
                         ];
            
            if(lstQLSEdit.size()>0){
                for(Quote_Line_Staging__c lqe:lstQLSEdit){
                    setQLSEdit.add(lqe);
                }
            }
        
        }
        
        if(parentUnique!=null){
            List<Quote_Line_Staging__c>lstQLSSubstitute = new List<Quote_Line_Staging__c>();
            lstQLSSubstitute = [SELECT Id, Name, CreatedDate, Quote__c, Product__c, Product__r.ProductCode, Quantity__c, 
                                    List_Unit_Price__c, List_Unit_Cost__c, Additional_Disc__c, Net_Unit_Price__c, Set_Unit_Price__c,  
                                    Price_Source__c, ProductParent__c, ProductParentUnique__c, isProductParent__c,   
                                    Substituted_Product__c, Substituted_Product_Code__c, Substituted_Product_Cost__c, 
                                    Substituted_Product_Created_Date__c, Substituted_Product_Price__c, Substituted_Product_Quantity__c,
                                    Substituted_Product_Source__c, Substitution_Reason__c
                                FROM Quote_Line_Staging__c 
                                WHERE Quote__c =: quoteId AND isProductParent__c = true AND ProductParentUnique__c =: parentUnique  
                                LIMIT 1
                               ];
            
            if(lstQLSSubstitute.size()>0){
                for(Quote_Line_Staging__c lqs:lstQLSSubstitute){
                    setQLSSubstitute.add(lqs);
                }
            }
        
        }
                
        
        
        if(quoteShippingZip!=null && accountId!= null ){
        
        
        List<String>lstProductId = new List<String>();
        lstProductId = productId.split(',', 0);
        
        lstProductCode = new List<String>();
        mapProductCodeName = new Map<String, String>();
        mapProductCode = new Map<String, String>();
        for(Product2 pr:[SELECT Id, Name, Description, ProductCode,Fulfillment_Channel__c  FROM Product2]){
            if(lstProductId.contains(pr.Id)){
                lstProductCode.add(pr.ProductCode);
                mapProductCodeName.put(pr.ProductCode, pr.Name);
                mapselInstallation.put(pr.ProductCode, 'None');
                maprenInstallation.put(pr.ProductCode, false);
                maprenInstallprice.put(pr.ProductCode, false);
                if(pr.Fulfillment_Channel__c!='DDC' && pr.Fulfillment_Channel__c!='TW' ){
                    renFulfillment = true;
                }
            }
            mapProductCode.put(pr.ProductCode, pr.Id);
        }
        
//system.debug('lstProductCode--> ' + lstProductCode );
//system.debug('lstProductCode.size()--> ' + lstProductCode.size() ); 
//system.debug('mapProductCode--> ' + mapProductCode );
  
   //     ProductAccessoriesHelperTry2.prod_acc_send(quoteId, lstProductCode);
 
        List<productaccessoriessend> lstPAS = new List<productaccessoriessend>();
        productaccessoriessend objPAS = new productaccessoriessend();
        for(String pc:lstProductCode){
            objPAS = new productaccessoriessend();/*
            objPAS.part_number = pc;
            objPAS.quantity = '1';
        //    objPAS.zipcode = '60602';
            objPAS.zipcode = quoteShippingZip;*/
            objPAS.zipcode = quoteShippingZip;
            objPAS.quantity = '1';
            objPAS.part_number = pc;
       //     objPAS.account = account_SCO_Id;
            objPAS.account_number = account_SCO_Id;
            lstPAS.add(objPAS);
            mapFeatureRender.put(pc+'Parts', false);
            mapFeatureRender.put(pc+'Services', false);
            mapFeatureRender.put(pc+'Config', false);
            renFeatureSelect.put(pc+'PartsSelect_All', false);
            renFeatureSelect.put(pc+'PartsSelect_One', false);
            renFeatureSelect.put(pc+'ServicesSelect_All', false);
            renFeatureSelect.put(pc+'ServicesSelect_One', false);
            renFeatureSelect.put(pc+'ServicesInstall', false);
            renFeatureSelect.put(pc+'ServicesOptional', false);
            renFeatureSelect.put(pc+'ConfigSelect_One', false);
            
        }
        
    //    String JSONString_PAS = JSON.serialize(lstPAS);
        String JSONString_PAS = JSON.serialize(objPAS);
        System.debug('Serialized  JSON format: ' + JSONString_PAS);
        
    //    String EndpointUrl = 'https://scoapp301p.dev.ch3.s.com:3143/api/delivery/services';
    //    String EndpointUrl = 'https://scoapp301p.dev.ch3.s.com:2143/api/rest/delivery/services';
   //     String EndpointUrl = 'https://KenmoreDirTRIAL331001.jitterbit.net/JitterbitDev/b2BQaDeliveryService';
   //     String CS_CONTENT_TYPE = 'application/json';        
        
            
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
   //     system.debug('EndpointUrl >>'+EndpointUrl);
   //     system.debug('B2BProd_Service_Install_URL >>'+mapCV.get('B2BProd_Service_Install_URL').Content__c);
  //      system.debug('B2BProd_KD_ClientId >>'+mapCV.get('B2BProd_KD_ClientId').Content__c);
  //      system.debug('B2BProd_KD_ClientSecret >>'+mapCV.get('B2BProd_KD_ClientSecret').Content__c);
        
        request.setHeader('Content-Type', CS_CONTENT_TYPE);
            request.setHeader('CLIENT_ID', CS_CLIENT_ID);
            request.setHeader('CLIENT_SECRET', CS_CLIENT_SECRET);
            request.setHeader('Accept', CS_CONTENT_TYPE);
            request.setTimeout(60000); // timeout in milliseconds
 
        request.setBody(JSONString_PAS);
        system.debug('request>>' +request);
        system.debug('request.getEndpoint()>>' +request.getEndpoint());
        system.debug('request.getBody()>>' +request.getBody());
        system.debug('request.getHeader(\'Accept\')>>' +request.getHeader('Accept'));
        system.debug('request.getHeader(\'Content-Type\')>>' +request.getHeader('Content-Type'));
        system.debug('request.getHeader(\'CLIENT_ID\')>>' +request.getHeader('CLIENT_ID'));
        system.debug('request.getHeader(\'CLIENT_SECRET\')>>' +request.getHeader('CLIENT_SECRET'));
            CalloutB2BAPI.ResponseWrapper RW = CalloutB2BAPI.execute(request);
        system.debug('RW>>' +RW);
            RW_Message = '';
            RW_Message = RW.message;
            RW_Code = 0;
            RW_Code = (RW.Response!=null && RW.Response.getStatusCode()!=null)?RW.Response.getStatusCode():0;
     //   system.debug('RW.Response.getStatusCode()>>' +RW.Response.getStatusCode());
       
        mapKAP = new Map<String, Double>();
        mapCost = new Map<String, Double>();
            
        List<Key_Account_Pricing__c> lstKAP = new List<Key_Account_Pricing__c>();
        lstKAP = [SELECT Id, Customer_KAP_price__c, Valid_from__c, Valid_to__c, Customer__c, Price_List_Type__c, Material_Number__c//, Product__c
                  FROM Key_Account_Pricing__c
        //          WHERE (Product__c IN: lstProductId OR Product__c=:productId) AND Customer__c=: accountId 
       //           WHERE (Material_Number__c IN: lstProductCode OR Material_Number__c IN: mapProductCode.keyset()) AND (Customer__c=: accountId OR Price_List_Type__c=:account_price_type) 
                  WHERE (Material_Number__c IN: lstProductCode OR Material_Number__c IN: mapProductCode.keyset()) 
                    AND 
                  (
                      (Customer__c!=null AND Price_List_Type__c=null AND Customer__c=: accountId) 
                      OR 
                      (Customer__c=null AND Price_List_Type__c!=null AND Price_List_Type__c=:account_price_type)
                  ) 
                    AND Valid_from__c<=:system.today() AND Valid_to__c>=:system.today()
                 ];
        
        
        for(Key_Account_Pricing__c lk:lstKAP){
      //      mapKAP.put(lk.Product__c, lk.Customer_KAP_price__c);
            mapKAP.put(lk.Material_Number__c, lk.Customer_KAP_price__c);
            mapPriceSource.put(lk.Material_Number__c, 'KAP');
        }
        //account_tier
        List<Product_Pricing__c> lstProductPricing = new List<Product_Pricing__c>();
        lstProductPricing = [SELECT Id, Price__c, Cost__c, Material_Number__c//, Product__c
                             FROM Product_Pricing__c
                       //      WHERE (Product__c IN: lstProductId OR Product__c=:productId) 
                             WHERE Material_Number__c IN: lstProductCode OR Material_Number__c IN: mapProductCode.keyset()
                            ];
        
        for(Product_Pricing__c lp:lstProductPricing){
        //    mapCost.put(lp.Product__c, lp.Cost__c);
            mapCost.put(lp.Material_Number__c, lp.Cost__c);
            
       //     if(mapKAP.get(lp.Product__c)==null){
            if(mapKAP.get(lp.Material_Number__c)==null){
                /*
                Double product_price = 0;
                if(account_tier=='Platinum'){
                    product_price = lp.Price__c*0.87;
                }else if(account_tier=='Gold'){
                    product_price = lp.Price__c*0.90;
                }else if(account_tier=='Silver'){
                    product_price = lp.Price__c*0.94;
                }else if(account_tier=='Bronze'){
                    product_price = lp.Price__c*0.97;
                }else{
                    product_price = lp.Price__c;
                }
                */
           //     mapKAP.put(lp.Product__c, product_price);
           //     mapKAP.put(lp.Material_Number__c, product_price);
                mapKAP.put(lp.Material_Number__c, lp.Price__c);
                mapPriceSource.put(lp.Material_Number__c, 'List');
            }
        }
       
            
            
  //      if(1==1){
            if(!renFulfillment){

             //     if(RW.message == '' && RW.Response != null){
                  if((RW.message == '' && RW.Response != null) || Test.isRunningTest() ){
                      system.debug('API response success');
                      renRedirect = false;
                      string resdoc = '';
                      
                      if(!Test.isRunningTest()){
                          system.debug('RW.Response--> ' + RW.Response );
                          response = http.send(request);
                          resdoc = response.getBody();
                      }else{
                   //       resdoc = '{ "product": { "services": { "required_parts": { "select_all": [ { "part_number": "02213000000", "product_name": "Kenmore 99903 8-Ft Dishwasher Connector Kit", "price": { "sellPrice": "19.99", "fixedPrice": null, "regularPrice": "19.99" }, "description": "<p>Stainless steel dishwasher connector kit includes everything needed for installation. &nbsp;Includes 2 brass elbows and a water supply adapter to work for any type of installation.</p>", "image_url": "//c.shld.net/rpx/i/s/i/spin/10154867/prod_2032887312" } ] }, "delivery_options": { "select_one": [ { "option_code": "brownbox_10", "description": "Leave-in-Box Delivery", "price": "69.99", "hookup_tasks": null }, { "option_code": "uncrate_K", "description": "Deliver and Uncrate", "price": "69.99", "hookup_tasks": null }, { "option_code": "install_J", "description": "Contact me to schedule professional installation. I understand an additional charge will apply.", "price": "0.0", "hookup_tasks": null } ], "optional": [ { "option_code": "haulawayRequested", "description": "I would like my old item hauled away", "base_price": "15.0", "addon_price": 15 } ] }, "installation_services": [ { "part_number": "01022100000", "division": "22", "line": "41", "sub_line": "15", "short_desc": "MAIN INSTALLATION DISHWASHER", "description": null, "price": "0.0" }, { "part_number": "01022102000", "division": "22", "line": "41", "sub_line": "15", "short_desc": "AI DW APT", "description": null, "price": "0.0" }, { "part_number": "01022103000", "division": "22", "line": "41", "sub_line": "15", "short_desc": "AI DW AIRGAP", "description": null, "price": "0.0" }, { "part_number": "01022104000", "division": "22", "line": "41", "sub_line": "15", "short_desc": "AI DW WTRLN", "description": null, "price": "0.0" }, { "part_number": "01022109000", "division": "22", "line": "41", "sub_line": "15", "short_desc": "HAUL AWAY, DISHWASHE", "description": null, "price": "0.0" }, { "part_number": "01022111000", "division": "22", "line": "41", "sub_line": "15", "short_desc": "OUT OF AREA", "description": null, "price": "0.0" }, { "part_number": "01022112000", "division": "22", "line": "41", "sub_line": "15", "short_desc": "AI DW ELE", "description": null, "price": "0.0" }, { "part_number": "01022113000", "division": "22", "line": "41", "sub_line": "15", "short_desc": "ELE CONNEC,T D/W", "description": null, "price": "0.0" }, { "part_number": "01022198000", "division": "22", "line": "41", "sub_line": "15", "short_desc": "WAR D/W, INSTALLATIO", "description": null, "price": "0.0" }, { "part_number": "01022199000", "division": "22", "line": "41", "sub_line": "15", "short_desc": "PA DISHWSHR", "description": null, "price": "0.0" }, { "part_number": "01022773000", "division": "22", "line": "41", "sub_line": "15", "short_desc": "EST DISHWSHR", "description": null, "price": "0.0" }, { "part_number": "01099888000", "division": "22", "line": "41", "sub_line": "15", "short_desc": "BLDG PERMITS", "description": null, "price": "0.0" }, { "part_number": "40010500000", "division": null, "line": null, "sub_line": null, "short_desc": "Deluxe Set Up", "description": null, "price": "0.0" }, { "part_number": "40010500221", "division": "22", "line": "41", "sub_line": "15", "short_desc": "Deluxe Set Up Dishwasher", "description": null, "price": "0.0" } ] } } }';
                      resdoc = '{ "product": { "services": { "required_parts": { "select_all": [ { "part_number": "02213000000", "product_name": "Kenmore 99903 8-Ft Dishwasher Connector Kit", "price": { "sellPrice": "19.99", "fixedPrice": "", "regularPrice": "19.99" }, "description": "<p>Stainless steel dishwasher connector kit includes everything needed for installation. &nbsp;Includes 2 brass elbows and a water supply adapter to work for any type of installation.</p>", "image_url": "//c.shld.net/rpx/i/s/i/spin/10154867/prod_2032887312" } ] }, "delivery_options": { "select_one": [ { "option_code": "brownbox_10", "description": "Leave-in-Box Delivery", "price": "69.99", "hookup_tasks": null }, { "option_code": "uncrate_K", "description": "Deliver and Uncrate", "price": "69.99", "hookup_tasks": null }, { "option_code": "install_J", "description": "Contact me to schedule professional installation. I understand an additional charge will apply.", "price": "0.0", "hookup_tasks": null } ], "optional": [ { "option_code": "haulawayRequested", "description": "I would like my old item hauled away", "base_price": "15.0", "addon_price": 15 } ] }, "installation_services": [ { "part_number": "01022100000", "division": "22", "line": "41", "sub_line": "15", "short_desc": "MAIN INSTALLATION DISHWASHER", "description": "", "price": "0.0" }, { "part_number": "01022102000", "division": "22", "line": "41", "sub_line": "15", "short_desc": "AI DW APT", "description": "", "price": "0.0" }, { "part_number": "01022103000", "division": "22", "line": "41", "sub_line": "15", "short_desc": "AI DW AIRGAP", "description": "", "price": "0.0" }, { "part_number": "01022104000", "division": "22", "line": "41", "sub_line": "15", "short_desc": "AI DW WTRLN", "description": "", "price": "0.0" }, { "part_number": "01022109000", "division": "22", "line": "41", "sub_line": "15", "short_desc": "HAUL AWAY, DISHWASHE", "description": "", "price": "0.0" }, { "part_number": "01022111000", "division": "22", "line": "41", "sub_line": "15", "short_desc": "OUT OF AREA", "description": "", "price": "0.0" }, { "part_number": "01022112000", "division": "22", "line": "41", "sub_line": "15", "short_desc": "AI DW ELE", "description": "", "price": "0.0" }, { "part_number": "01022113000", "division": "22", "line": "41", "sub_line": "15", "short_desc": "ELE CONNEC,T D/W", "description": "", "price": "0.0" }, { "part_number": "01022198000", "division": "22", "line": "41", "sub_line": "15", "short_desc": "WAR D/W, INSTALLATIO", "description": "", "price": "0.0" }, { "part_number": "01022199000", "division": "22", "line": "41", "sub_line": "15", "short_desc": "PA DISHWSHR", "description": "", "price": "0.0" }, { "part_number": "01022773000", "division": "22", "line": "41", "sub_line": "15", "short_desc": "EST DISHWSHR", "description": "", "price": "0.0" }, { "part_number": "01099888000", "division": "22", "line": "41", "sub_line": "15", "short_desc": "BLDG PERMITS", "description": "", "price": "0.0" }, { "part_number": "40010500000", "division": "", "line": "", "sub_line": "", "short_desc": "Deluxe Set Up", "description": "", "price": "0.0" }, { "part_number": "40010500221", "division": "22", "line": "41", "sub_line": "15", "short_desc": "Deluxe Set Up Dishwasher", "description": "", "price": "0.0" } ] } } }';                      
                      }
            
            
                      system.debug('resdoc:' +resdoc);
            
 //           resdoc = '{ "product": { "services": { "required_parts": { "select_one": [ { "part_number": "04633000000", "product_name": "Frigidaire 33000 Smart Choice Stainless Steel Refrigerator Waterline Kit", "price": { "sellPrice": "17.99", "fixedPrice": "17.99", "regularPrice": "17.99" }, "description": "<span>Smart Choice Stainless Steel Refrigerator Waterline Kit is used for tapping into a cold water line and plumb water to the back to the refrigerator. Kit comes with 6-foot stainless steel braided icemaker waterline, 1/4x1/4C Union, Teflon tape and instruction sheet.</span>", "image_url": "//c.shld.net/rpx/i/s/i/spin/10038420/prod_17652819012" }, { "part_number": "04649599000", "product_name": "Sears 49599 Water Hose for Ice Makers and Water Dispensers", "price": { "sellPrice": "10.98", "fixedPrice": "10.98", "regularPrice": "11.98" }, "description": "<p><strong>Make ice with the Water Hose for Ice Makers and Water Dispensers</strong></p>. <p>This 5-foot braided hose is designed for use with any ice maker or water dispense and can be installed without any special tools. The hookup kit includes 1/4c lead-free fittings, ensuring your water and ice are chemical-free meeting all FDA requirements. Installation is a breeze with the screw-on fittings, making it easy to replace a busted hose in any fridge or freezer.</p> <p>If your water dispenser or ice maker are not operating as they should, the hose may have sprung a leak. This replacement <strong>Water Hose for Ice Makers and Water Dispensers</strong> will get you back up and running in no time.</p>", "image_url": "//c.shld.net/rpx/i/s/i/spin/10005490/prod_12139425512" } ] }, "delivery_options": { "select_one": [ { "option_code": "hookup_3", "description": "Delivery and Basic Hook-up", "price": "69.99", "hookup_tasks": "TOP MOUNT REFRIGERATORS;Remove item from carton;Remove and re-attach handles and doors to complete delivery, if needed;Place product in location and provide customer literature;Reverse merchandise doors, if requested;Check water flow. Reconnect to existing water line, provided that water line meets manufacturer and local building requirements and check for leaks. Note: Icemaker and water dispenser connections may require connectors and additional tubing.;Remove tape, protective film covering and packaging material ;Place racks, crispers, ice trays, and door handles in recommended positions;Plug unit in and set to mid-range cold setting;Level the unit;Remove all packing material from the premises" }, { "option_code": "brownbox_10", "description": "Leave-in-Box Delivery", "price": "69.99", "hookup_tasks": null }, { "option_code": "uncrate_K", "description": "Deliver and Uncrate", "price": "69.99", "hookup_tasks": null }, { "option_code": "install_J", "description": "Contact me to schedule professional installation. I understand an additional charge will apply.", "price": "0.0", "hookup_tasks": null } ], "optional": [ { "option_code": "haulawayRequested", "description": "I would like my old item hauled away", "base_price": "15.0", "addon_price": 15 } ] }, "installation_services": [ { "part_number": "01046200000", "division": "46", "line": "1", "sub_line": "23", "short_desc": "MI ICEMKR LN", "description": "", "price": "159.99" }, { "part_number": "01046206000", "division": "46", "line": "1", "sub_line": "23", "short_desc": "AI IM APT", "description": "", "price": "34.99" }, { "part_number": "01046208000", "division": "46", "line": "1", "sub_line": "23", "short_desc": "AI IM HAUL", "description": "", "price": "25.0" }, { "part_number": "01046212000", "division": "46", "line": "1", "sub_line": "23", "short_desc": "AI IM CRAWL", "description": "", "price": "0.0" }, { "part_number": "01046249000", "division": "46", "line": "1", "sub_line": "23", "short_desc": "EST ICEMKRLN", "description": "", "price": "69.99" }, { "part_number": "01046298000", "division": "46", "line": "1", "sub_line": "23", "short_desc": "WAR ICEMKRLN", "description": "", "price": "0.0" }, { "part_number": "01046299000", "division": "46", "line": "1", "sub_line": "23", "short_desc": "PA ICEMKR LN", "description": "", "price": "0.0" }, { "part_number": "01046796000", "division": "46", "line": "1", "sub_line": "23", "short_desc": "EA ICEMKLN", "description": "", "price": "0.01" }, { "part_number": "40010500000", "division": "", "line": "", "sub_line": "", "short_desc": "Deluxe Set Up", "description": "", "price": "0.0" }, { "part_number": "40010500461", "division": "46", "line": "1", "sub_line": "23", "short_desc": "Deluxe Set Up Refrigeration", "description": "", "price": "0.0" } ] } } }';
  //                    system.debug('resdoc:' +resdoc);
// resdoc = '{ "product": { "services": { "required_parts": { "select_one": [ { "part_number": "04633000000", "product_name": "Frigidaire 33000 Smart Choice 6\' Stainless Steel Refrigerator Waterline Kit", "price": { "sellPrice": "17.99", "fixedPrice": "17.99", "regularPrice": "17.99" }, "description": "<span>Smart Choice 6\' Stainless Steel Refrigerator Waterline Kit is used for tapping into a cold water line and plumb water to the back to the refrigerator. Kit comes with 6-foot stainless steel braided icemaker waterline, 1/4x1/4C Union, Teflon tape and instruction sheet.</span>", "image_url": "c.shld.net/rpx/i/s/i/spin/10038420/prod_17652819012" }, { "part_number": "04649599000", "product_name": "Sears 49599 5\' Water Hose for Ice Makers and Water Dispensers", "price": { "sellPrice": "10.98", "fixedPrice": "10.98", "regularPrice": "11.98" }, "description": "<p><strong>Make ice with the 5\' Water Hose for Ice Makers and Water Dispensers</strong></p>. <p>This 5-foot braided hose is designed for use with any ice maker or water dispense and can be installed without any special tools. The hookup kit includes 1/4c lead-free fittings, ensuring your water and ice are chemical-free meeting all FDA requirements. Installation is a breeze with the screw-on fittings, making it easy to replace a busted hose in any fridge or freezer.</p> <p>If your water dispenser or ice maker are not operating as they should, the hose may have sprung a leak. This replacement <strong>Water Hose for Ice Makers and Water Dispensers</strong> will get you back up and running in no time.</p>", "image_url": "//c.shld.net/rpx/i/s/i/spin/10005490/prod_12139425512" } ] }, "delivery_options": { "select_one": [ { "option_code": "hookup_3", "description": "Delivery and Basic Hook-up", "price": "69.99", "hookup_tasks": "TOP MOUNT REFRIGERATORS;Remove item from carton;Remove and re-attach handles and doors to complete delivery, if needed;Place product in location and provide customer literature;Reverse merchandise doors, if requested;Check water flow. Reconnect to existing water line, provided that water line meets manufacturer and local building requirements and check for leaks. Note: Icemaker and water dispenser connections may require connectors and additional tubing.;Remove tape, protective film covering and packaging material ;Place racks, crispers, ice trays, and door handles in recommended positions;Plug unit in and set to mid-range cold setting;Level the unit;Remove all packing material from the premises" }, { "option_code": "brownbox_10", "description": "Leave-in-Box Delivery", "price": "69.99", "hookup_tasks": null }, { "option_code": "uncrate_K", "description": "Deliver and Uncrate", "price": "69.99", "hookup_tasks": null }, { "option_code": "install_J", "description": "Contact me to schedule professional installation. I understand an additional charge will apply.", "price": "0.0", "hookup_tasks": null } ], "optional": [ { "option_code": "haulawayRequested", "description": "I would like my old item hauled away", "base_price": "15.0", "addon_price": 15 } ] }, "installation_services": [ { "part_number": "01046200000", "division": "46", "line": "1", "sub_line": "23", "short_desc": "MI ICEMKR LN", "description": "", "price": "159.99" }, { "part_number": "01046206000", "division": "46", "line": "1", "sub_line": "23", "short_desc": "AI IM APT", "description": "", "price": "34.99" }, { "part_number": "01046208000", "division": "46", "line": "1", "sub_line": "23", "short_desc": "AI IM HAUL", "description": "", "price": "25.0" }, { "part_number": "01046212000", "division": "46", "line": "1", "sub_line": "23", "short_desc": "AI IM CRAWL", "description": "", "price": "0.0" }, { "part_number": "01046249000", "division": "46", "line": "1", "sub_line": "23", "short_desc": "EST ICEMKRLN", "description": "", "price": "69.99" }, { "part_number": "01046298000", "division": "46", "line": "1", "sub_line": "23", "short_desc": "WAR ICEMKRLN", "description": "", "price": "0.0" }, { "part_number": "01046299000", "division": "46", "line": "1", "sub_line": "23", "short_desc": "PA ICEMKR LN", "description": "", "price": "0.0" }, { "part_number": "01046796000", "division": "46", "line": "1", "sub_line": "23", "short_desc": "EA ICEMKLN", "description": "", "price": "0.01" }, { "part_number": "40010500000", "division": "", "line": "", "sub_line": "", "short_desc": "Deluxe Set Up", "description": "", "price": "0.0" }, { "part_number": "40010500461", "division": "46", "line": "1", "sub_line": "23", "short_desc": "Deluxe Set Up Refrigeration", "description": "", "price": "0.0" } ] } } }';
//            system.debug('resdoc:' +resdoc);
//                      string resdoc1 = resdoc.substring(4, 8);
//            system.debug('resdoc1:' +resdoc1);
            
    //    system.debug('mapKAP--> ' + mapKAP );
    //    system.debug('mapCost--> ' + mapCost );
            
            /*
        system.debug('mapDeliveryProduct--> ' + mapDeliveryProduct );
        system.debug('mapDeliveryProduct.get(deliveryOptions)--> ' + mapDeliveryProduct.get('deliveryOptions') );
        
        for(String del:mapDeliveryProduct.get('deliveryOptions').keyset()){
      //      mapKAP.put(del, mapDeliveryProduct.get('deliveryOptions').get(del));
            if(mapDeliveryProduct.get('deliveryOptions').get(del)!=null && mapDeliveryProduct.get('deliveryOptions').get(del)!='' ){
                mapKAP.put(del, double.valueof(mapDeliveryProduct.get('deliveryOptions').get(del)));
                mapCost.put(del, double.valueof(mapDeliveryProduct.get('deliveryOptions').get(del)));
            }
        }
        */
             
            
            
            
            
        
            OptionProduct objOptionProduct = new OptionProduct();
        
            List<OptionProduct> lstTempOption = new List<OptionProduct>();
            Set<String> setTempString = new Set<String>();
            mapOptionProduct = new Map<String,List<OptionProduct>>();
            mapOptionProduct1 = new Map<String,List<OptionProduct>>();
            mapFeatureSelect = new Map<String,Set<String>>();
                      
            mapProductKey = new Map<String,List<String>>();
            
            mapInstallation = new Map<String, String>();
            
            DeserializeProductAccessories obj = DeserializeProductAccessories.parse(resdoc);
      //      system.debug('obj:' +obj);
      //      system.debug('obj.product.services:' +obj.product.services);
     //       system.debug('obj.product.services.Delivery_options:' +obj.product.services.Delivery_options);
            
                      
            List<DeserializeProductAccessories.Select_Parts> lstPartsSelectAll = new List<DeserializeProductAccessories.Select_Parts>();
            Map<String, List<DeserializeProductAccessories.Select_Parts>> mapPartsSelectAll = new Map<String, List<DeserializeProductAccessories.Select_Parts>>();
            
            List<DeserializeProductAccessories.Select_Parts> lstPartsSelectOne = new List<DeserializeProductAccessories.Select_Parts>();
            Map<String, List<DeserializeProductAccessories.Select_Parts>> mapPartsSelectOne = new Map<String, List<DeserializeProductAccessories.Select_Parts>>();
            
            List<DeserializeProductAccessories.Select_Delivery> lstServicesSelectAll = new List<DeserializeProductAccessories.Select_Delivery>();
            Map<String, List<DeserializeProductAccessories.Select_Delivery>> mapServicesSelectAll = new Map<String, List<DeserializeProductAccessories.Select_Delivery>>();
            
            List<DeserializeProductAccessories.Select_Delivery> lstServicesSelectOne = new List<DeserializeProductAccessories.Select_Delivery>();
            Map<String, List<DeserializeProductAccessories.Select_Delivery>> mapServicesSelectOne = new Map<String, List<DeserializeProductAccessories.Select_Delivery>>();
            
            List<DeserializeProductAccessories.Optional> lstServicesOptional = new List<DeserializeProductAccessories.Optional>();
            Map<String, List<DeserializeProductAccessories.Optional>> mapServicesOptional = new Map<String, List<DeserializeProductAccessories.Optional>>();
            
            List<DeserializeProductAccessories.Installation_services> lstInstallationSelect = new List<DeserializeProductAccessories.Installation_services>();
            Map<String, List<DeserializeProductAccessories.Installation_services>> mapInstallationSelect = new Map<String, List<DeserializeProductAccessories.Installation_services>>();
                      
            List<DeserializeProductAccessories.Select_Configuration> lstConfigurationOptionSelect = new List<DeserializeProductAccessories.Select_Configuration>();
            Map<String, List<DeserializeProductAccessories.Select_Configuration>> mapConfigurationOptionSelect = new Map<String, List<DeserializeProductAccessories.Select_Configuration>>();
                      
                      if(!Test.isRunningTest()){
                          if(obj.product.services.Required_parts!=null && obj.product.services.Required_parts.select_all!=null ) {
            lstPartsSelectAll = obj.product.services.Required_parts.select_all;
      //      system.debug('lstPartsSelectAll:' +lstPartsSelectAll);
            mapPartsSelectAll.put(lstProductCode[0], lstPartsSelectAll);                              
                          }         
            
                         if(obj.product.services.Required_parts!=null && obj.product.services.Required_parts.select_one!=null ) {                  
            lstPartsSelectOne = obj.product.services.Required_parts.select_one;
     //       system.debug('lstPartsSelectOne:' +lstPartsSelectOne);
            mapPartsSelectOne.put(lstProductCode[0], lstPartsSelectOne);
                         }
            
                if(obj.product.services.Delivery_options!=null && obj.product.services.Delivery_options.select_all!=null ) {                                   
            lstServicesSelectAll = obj.product.services.Delivery_options.select_all;
      //      system.debug('lstServicesSelectAll:' +lstServicesSelectAll);
            mapServicesSelectAll.put(lstProductCode[0], lstServicesSelectAll);
                }
                          
                if(obj.product.services.Delivery_options!=null && obj.product.services.Delivery_options.select_one!=null ) {            
            lstServicesSelectOne = obj.product.services.Delivery_options.select_one;
      //      system.debug('lstServicesSelectOne:' +lstServicesSelectOne);
            mapServicesSelectOne.put(lstProductCode[0], lstServicesSelectOne);
                }
            
                if(obj.product.services.Delivery_options!=null && obj.product.services.Delivery_options.optional!=null ) {                          
            lstServicesOptional = obj.product.services.Delivery_options.optional;
      //      system.debug('lstServicesOptional:' +lstServicesOptional);
            mapServicesOptional.put(lstProductCode[0], lstServicesOptional);
                }
            
                if(obj.product.services.installation_services!=null ) {                          
            lstInstallationSelect = obj.product.services.installation_services;
     //       system.debug('lstInstallationSelect:' +lstInstallationSelect);
            mapInstallationSelect.put(lstProductCode[0], lstInstallationSelect);
                }
                          
                if(obj.product.services.configuration_options!=null && obj.product.services.configuration_options.select_one!=null ) {                          
            lstConfigurationOptionSelect = obj.product.services.configuration_options.select_one;
            system.debug('lstConfigurationOptionSelect:' +lstConfigurationOptionSelect);
            mapConfigurationOptionSelect.put(lstProductCode[0], lstConfigurationOptionSelect);
            system.debug('mapConfigurationOptionSelect:' +mapConfigurationOptionSelect);
                }
                      }
                     
            for(String mpsa:mapPartsSelectAll.keyset()){
                
         //   if(lstPartsSelectAll!=null){
         //       for(DeserializeProductAccessories.Select_Parts psa:lstPartsSelectAll){
            if(mapPartsSelectAll.get(mpsa)!=null){
                for(DeserializeProductAccessories.Select_Parts psa:mapPartsSelectAll.get(mpsa)){
                    system.debug('psa--> ' +psa);
                    if(mapProductCode.get(psa.part_number)!=null){
                        objOptionProduct = new OptionProduct();
                        objOptionProduct.product_code = psa.part_number;
                        objOptionProduct.sel_check = false;
                        objOptionProduct.sel_button = false;
                        objOptionProduct.renButton = false;
                        objOptionProduct.is_selected = false;
                        objOptionProduct.sel_type = 'Select All';
                        //     objOptionProduct.option_id = op.Id;
                        objOptionProduct.product_id = mapProductCode.get(psa.part_number);
                        objOptionProduct.product_name = psa.product_name;
                      //  objOptionProduct.product_description = mapProductCode.get(psa.part_number).Description;
                        //   objOptionProduct.list_price = string.valueOf(mapKAP.get(op.SBQQ__OptionalSKU__c));//'100';
                        //    objOptionProduct.list_price = string.valueOf(mapKAP.get(op.SBQQ__OptionalSKU__r.ProductCode));//'100';
                            objOptionProduct.list_price = string.valueOf(mapKAP.get(psa.part_number));
                        lstTempOption = new List<OptionProduct>();
                        
                        if(mapOptionProduct.keySet().contains(mpsa+'PartsSelect_All')){
                            lstTempOption.addAll(mapOptionProduct.get(mpsa+'PartsSelect_All'));
                        }else{
                            mapOptionProduct.put(mpsa+'PartsSelect_All', lstTempOption);
                        }
                        lstTempOption.add(objOptionProduct);
                        
                        mapOptionProduct.put(mpsa+'PartsSelect_All', lstTempOption);
                        
                        setTempString = new Set<String>();
                        if(mapFeatureSelect.keySet().contains(mpsa+'Parts')){
                            setTempString.addAll(mapFeatureSelect.get(mpsa+'Parts'));
                        }else{
                            mapFeatureSelect.put(mpsa+'Parts', setTempString);
                        }
                        setTempString.add('Select_All');
                        
                        mapFeatureSelect.put(mpsa+'Parts', setTempString);
                        renFeatureSelect.put(mpsa+'PartsSelect_All', true);
                        if(setTempString.size()>0){
                            mapFeatureRender.put(mpsa+'Parts',true);
                        }
                        
                    }
                }
            }else{
                renFeatureSelect.put(mpsa+'PartsSelect_All', false);
            }
            }
            
            for(String mpso:mapPartsSelectOne.keyset()){
         //   if(lstPartsSelectAll!=null){
         //       for(DeserializeProductAccessories.Select_Parts psa:lstPartsSelectAll){
         //   if(lstPartsSelectOne!=null){
         //       for(DeserializeProductAccessories.Select_Parts pso:lstPartsSelectOne){
            if(mapPartsSelectOne.get(mpso)!=null){
                for(DeserializeProductAccessories.Select_Parts pso:mapPartsSelectOne.get(mpso)){
                    system.debug('pso--> ' +pso);
                    if(mapProductCode.get(pso.part_number)!=null){
                        objOptionProduct = new OptionProduct();
                        objOptionProduct.product_code = pso.part_number;
                        objOptionProduct.sel_check = false;
                        objOptionProduct.sel_button = true;
                        objOptionProduct.renButton = true;
                        objOptionProduct.is_selected = false;
                        objOptionProduct.sel_type = 'Select One';
                        //     objOptionProduct.option_id = op.Id;
                        objOptionProduct.product_id = mapProductCode.get(pso.part_number);
                        objOptionProduct.product_name = pso.product_name;
                    //    objOptionProduct.product_description = mapProductCode.get(pso.part_number).Description;
                        //   objOptionProduct.list_price = string.valueOf(mapKAP.get(op.SBQQ__OptionalSKU__c));//'100';
                        //    objOptionProduct.list_price = string.valueOf(mapKAP.get(op.SBQQ__OptionalSKU__r.ProductCode));//'100';
                        objOptionProduct.list_price = string.valueOf(mapKAP.get(pso.part_number));//'100';
                        lstTempOption = new List<OptionProduct>();
                        
                        if(mapOptionProduct.keySet().contains(mpso+'PartsSelect_One')){
                            lstTempOption.addAll(mapOptionProduct.get(mpso+'PartsSelect_One'));
                        }else{
                            mapOptionProduct.put(mpso+'PartsSelect_One', lstTempOption);
                        }
                        lstTempOption.add(objOptionProduct);
                        
                        mapOptionProduct.put(mpso+'PartsSelect_One', lstTempOption);
                        
                        setTempString = new Set<String>();
                        if(mapFeatureSelect.keySet().contains(mpso+'Parts')){
                            setTempString.addAll(mapFeatureSelect.get(mpso+'Parts'));
                        }else{
                            mapFeatureSelect.put(mpso+'Parts', setTempString);
                        }
                        setTempString.add('Select_One');
                        
                        mapFeatureSelect.put(mpso+'Parts', setTempString);
                        renFeatureSelect.put(mpso+'PartsSelect_One', true);
                        if(setTempString.size()>0){
                            mapFeatureRender.put(mpso+'Parts',true);
                        }
                        
                    }
                }
            }else{
                renFeatureSelect.put(mpso+'PartsSelect_One', false);
            }
            }
            
            
            
            for(String mdsa:mapServicesSelectAll.keyset()){
          //  if(lstServicesSelectAll!=null){
          //      for(DeserializeProductAccessories.Select_Delivery dsa:lstServicesSelectAll){
            if(mapServicesSelectAll.get(mdsa)!=null){
                for(DeserializeProductAccessories.Select_Delivery dsa:mapServicesSelectAll.get(mdsa)){
                    system.debug('dsa--> ' +dsa);
                    if(mapProductCode.get(dsa.option_code)!=null){
                        objOptionProduct = new OptionProduct();
                        objOptionProduct.product_code = dsa.option_code;
                        objOptionProduct.sel_check = false;
                        objOptionProduct.sel_button = false;
                        objOptionProduct.renButton = false;
                        objOptionProduct.is_selected = false;
                        objOptionProduct.sel_type = 'Select All';
                        //     objOptionProduct.option_id = op.Id;
                        objOptionProduct.product_id = mapProductCode.get(dsa.option_code);
                        objOptionProduct.product_name = dsa.option_code=='install_j'?'Professional Installation':dsa.description;
                     //   objOptionProduct.product_description = mapProductCode.get(dsa.option_code).Description;
                        //   objOptionProduct.list_price = string.valueOf(mapKAP.get(op.SBQQ__OptionalSKU__c));//'100';
                        //    objOptionProduct.list_price = string.valueOf(mapKAP.get(op.SBQQ__OptionalSKU__r.ProductCode));//'100';
                    //    objOptionProduct.list_price = string.valueOf(dsa.price);
                        /*
                        objOptionProduct.list_price = string.valueOf(mapServicePrice.get(dsa.option_code));
                        if(mapKAPService.keySet().contains(dsa.option_code)){
                            if(mapServiceName.keySet().contains(dsa.option_code)){
                                objOptionProduct.list_price = string.valueOf(mapKAPService.get(mapServiceName.get(dsa.option_code)));
                            }else{
                                objOptionProduct.list_price = string.valueOf(mapKAPService.get(dsa.option_code));
                            }
                        }
*/
                        objOptionProduct.list_price = string.valueOf(mapKAPService2.get(dsa.part_number)!=null?mapKAPService2.get(dsa.part_number):0);
                        
                        lstTempOption = new List<OptionProduct>();
                        
                        if(mapOptionProduct.keySet().contains(mdsa+'ServicesSelect_All')){
                            lstTempOption.addAll(mapOptionProduct.get(mdsa+'ServicesSelect_All'));
                        }else{
                            mapOptionProduct.put(mdsa+'ServicesSelect_All', lstTempOption);
                        }
                        lstTempOption.add(objOptionProduct);
                        
                        mapOptionProduct.put(mdsa+'ServicesSelect_All', lstTempOption);
                        
                        setTempString = new Set<String>();
                        if(mapFeatureSelect.keySet().contains(mdsa+'Services')){
                            setTempString.addAll(mapFeatureSelect.get(mdsa+'Services'));
                        }else{
                            mapFeatureSelect.put(mdsa+'Services', setTempString);
                        }
                        setTempString.add('Select_All');
                        
                        mapFeatureSelect.put(mdsa+'Services', setTempString);
                        renFeatureSelect.put(mdsa+'ServicesSelect_All', true);
                        if(setTempString.size()>0){
                            mapFeatureRender.put(mdsa+'Services',true);
                        }
                        
                    }
                }
            }else{
                renFeatureSelect.put(mdsa+'ServicesSelect_All', false);
            }
            }
            
                    system.debug('mapServicesSelectOne--> ' +mapServicesSelectOne);
            for(String mdso:mapServicesSelectOne.keyset()){
         //   if(lstServicesSelectOne!=null){
         //       for(DeserializeProductAccessories.Select_Delivery dso:lstServicesSelectOne){
            if(mapServicesSelectOne.get(mdso)!=null){
                for(DeserializeProductAccessories.Select_Delivery dso:mapServicesSelectOne.get(mdso)){
                    system.debug('dso--> ' +dso);
                    if(mapProductCode.get(dso.option_code)!=null){
                        objOptionProduct = new OptionProduct();
                        objOptionProduct.product_code = dso.option_code;
                        objOptionProduct.sel_check = false;
                        objOptionProduct.sel_button = true;
                        objOptionProduct.renButton = true;
                        objOptionProduct.is_selected = false;
                        objOptionProduct.sel_type = 'Select One';
                        //     objOptionProduct.option_id = op.Id;
                        objOptionProduct.product_id = mapProductCode.get(dso.option_code);
                        objOptionProduct.product_name = dso.option_code=='install_j'?'Professional Installation':dso.description;
                     //   objOptionProduct.product_description = mapProductCode.get(dso.option_code).Description;
                        //   objOptionProduct.list_price = string.valueOf(mapKAP.get(op.SBQQ__OptionalSKU__c));//'100';
                        //    objOptionProduct.list_price = string.valueOf(mapKAP.get(op.SBQQ__OptionalSKU__r.ProductCode));//'100';
                   //     objOptionProduct.list_price = string.valueOf(dso.price);
                        /*
                        objOptionProduct.list_price = string.valueOf(mapServicePrice.get(dso.option_code));
                        if(mapKAPService.keySet().contains(dso.option_code)){
                            if(mapServiceName.keySet().contains(dso.option_code)){
                                objOptionProduct.list_price = string.valueOf(mapKAPService.get(mapServiceName.get(dso.option_code)));
                            }else{
                                objOptionProduct.list_price = string.valueOf(mapKAPService.get(dso.option_code));
                            }
                        }
*/
                        objOptionProduct.list_price = string.valueOf(mapKAPService2.get(dso.part_number)!=null?mapKAPService2.get(dso.part_number):0);
                        
                        lstTempOption = new List<OptionProduct>();
                        
                        if(mapOptionProduct.keySet().contains(mdso+'ServicesSelect_One')){
                            lstTempOption.addAll(mapOptionProduct.get(mdso+'ServicesSelect_One'));
                        }else{
                            mapOptionProduct.put(mdso+'ServicesSelect_One', lstTempOption);
                        }
                        lstTempOption.add(objOptionProduct);
                        
                        mapOptionProduct.put(mdso+'ServicesSelect_One', lstTempOption);
                        
                        setTempString = new Set<String>();
                        if(mapFeatureSelect.keySet().contains(mdso+'Services')){
                            setTempString.addAll(mapFeatureSelect.get(mdso+'Services'));
                        }else{
                            mapFeatureSelect.put(mdso+'Services', setTempString);
                        }
                        setTempString.add('Select_One');
                        
                        mapFeatureSelect.put(mdso+'Services', setTempString);
                        renFeatureSelect.put(mdso+'ServicesSelect_One', true);
                        if(setTempString.size()>0){
                            mapFeatureRender.put(mdso+'Services',true);
                        }
                        
                    }
                }
            }else{
                renFeatureSelect.put(mdso+'ServicesSelect_One', false);
            }
            }
                
            for(String mis:mapInstallationSelect.keyset()){
       //     if(lstInstallationSelect!=null){
       //         for(DeserializeProductAccessories.Installation_services is:lstInstallationSelect){
            if(mapInstallationSelect.get(mis)!=null){
                for(DeserializeProductAccessories.Installation_services is:mapInstallationSelect.get(mis)){
                    system.debug('is--> ' +is);
                    if(mapProductCode.get(is.part_number)!=null){
                        objOptionProduct = new OptionProduct();
                        objOptionProduct.product_code = is.part_number;
                        objOptionProduct.sel_check = false;
                        objOptionProduct.sel_button = true;
                        objOptionProduct.renButton = true;
                        objOptionProduct.is_selected = false;
                        objOptionProduct.sel_type = 'Install';
                        //     objOptionProduct.option_id = op.Id;
                        objOptionProduct.product_id = mapProductCode.get(is.part_number);
                        objOptionProduct.product_name = is.short_desc;
                        mapInstallation.put(is.part_number, is.short_desc);
                     //   objOptionProduct.product_description = mapProductCode.get(is.part_number).Description;
                        //   objOptionProduct.list_price = string.valueOf(mapKAP.get(op.SBQQ__OptionalSKU__c));//'100';
                        //    objOptionProduct.list_price = string.valueOf(mapKAP.get(op.SBQQ__OptionalSKU__r.ProductCode));//'100';
                        objOptionProduct.list_price = string.valueOf(is.price);
                        /*
                        if(mapKAPService.keySet().contains(is.part_number)){
                            if(mapServiceName.keySet().contains(is.part_number)){
                                objOptionProduct.list_price = string.valueOf(mapKAPService.get(mapServiceName.get(is.part_number)));
                            }else{
                                objOptionProduct.list_price = string.valueOf(mapKAPService.get(is.part_number));
                            }
                        }
*/
              //          objOptionProduct.list_price = string.valueOf(mapKAPService2.get(is.part_number));
                        
                    //    mapInstallationPrice.put(mis+is.part_number, string.valueOf(is.price));
                        mapInstallationPrice.put(mis+is.part_number, objOptionProduct.list_price);
                        mapInstallationPrice.put(mis+'None', '0');
                        lstTempOption = new List<OptionProduct>();
                        
                        if(mapOptionProduct.keySet().contains(mis+'ServicesInstall')){
                            lstTempOption.addAll(mapOptionProduct.get(mis+'ServicesInstall'));
                        }else{
                            mapOptionProduct.put(mis+'ServicesInstall', lstTempOption);
                        }
                        lstTempOption.add(objOptionProduct);
                        
                        mapOptionProduct.put(mis+'ServicesInstall', lstTempOption);
                        mapOptionProduct1.put(mis+'ServicesInstall', lstTempOption);
                                                
                        setTempString = new Set<String>();
                        if(mapFeatureSelect.keySet().contains(mis+'Services')){
                            setTempString.addAll(mapFeatureSelect.get(mis+'Services'));
                        }else{
                            mapFeatureSelect.put(mis+'Services', setTempString);
                        }
                        setTempString.add('Install');
                        
                        mapFeatureSelect.put(mis+'Services', setTempString);
                        renFeatureSelect.put(mis+'ServicesInstall', true);
                        if(setTempString.size()>0){
                            mapFeatureRender.put(mis+'Services',true);
                        }
                        
                    }
                    
                    
                }
            }else{
                renFeatureSelect.put(mis+'ServicesInstall', false);
            }
            }
                        
            for(String mso:mapServicesOptional.keyset()){
        //    if(lstServicesOptional!=null){
        //        for(DeserializeProductAccessories.Optional so:lstServicesOptional){
            if(mapServicesOptional.get(mso)!=null){
                for(DeserializeProductAccessories.Optional so:mapServicesOptional.get(mso)){
                    system.debug('so--> ' +so);
                    if(mapProductCode.get(so.option_code)!=null){
                        objOptionProduct = new OptionProduct();
                        objOptionProduct.product_code = so.option_code;
                        objOptionProduct.sel_check = false;
                        objOptionProduct.sel_button = false;
                        objOptionProduct.renButton = false;
                        objOptionProduct.is_selected = false;
                        objOptionProduct.sel_type = 'Optional';
                        //     objOptionProduct.option_id = op.Id;
                        objOptionProduct.product_id = mapProductCode.get(so.option_code);
                        objOptionProduct.product_name = so.option_code=='install_j'?'Professional Installation':so.description;
                     //   objOptionProduct.product_description = mapProductCode.get(dso.option_code).Description;
                        //   objOptionProduct.list_price = string.valueOf(mapKAP.get(op.SBQQ__OptionalSKU__c));//'100';
                        //    objOptionProduct.list_price = string.valueOf(mapKAP.get(op.SBQQ__OptionalSKU__r.ProductCode));//'100';
                     //   objOptionProduct.list_price = string.valueOf(so.base_price);
                        /*
                        objOptionProduct.list_price = string.valueOf(mapServicePrice.get(so.option_code));
                        if(mapKAPService.keySet().contains(so.option_code)){
                            if(mapServiceName.keySet().contains(so.option_code)){
                                objOptionProduct.list_price = string.valueOf(mapKAPService.get(mapServiceName.get(so.option_code)));
                            }else{
                                objOptionProduct.list_price = string.valueOf(mapKAPService.get(so.option_code));
                            }
                        }
                        objOptionProduct.list_price = string.valueOf(mapKAPService2.get(so.part_number));
                        */
                        objOptionProduct.list_price = string.valueOf(mapKAPService2.get(so.part_number)!=null?mapKAPService2.get(so.part_number):0);
                        lstTempOption = new List<OptionProduct>();
                        
                        if(mapOptionProduct.keySet().contains(mso+'ServicesOptional')){
                            lstTempOption.addAll(mapOptionProduct.get(mso+'ServicesOptional'));
                        }else{
                            mapOptionProduct.put(mso+'ServicesOptional', lstTempOption);
                        }
                        lstTempOption.add(objOptionProduct);
                        
                        mapOptionProduct.put(mso+'ServicesOptional', lstTempOption);
                        
                        setTempString = new Set<String>();
                        if(mapFeatureSelect.keySet().contains(mso+'Services')){
                            setTempString.addAll(mapFeatureSelect.get(mso+'Services'));
                        }else{
                            mapFeatureSelect.put(mso+'Services', setTempString);
                        }
                        setTempString.add('Optional');
                        
                        mapFeatureSelect.put(mso+'Services', setTempString);
                        renFeatureSelect.put(mso+'ServicesOptional', true);
                        if(setTempString.size()>0){
                            mapFeatureRender.put(mso+'Services',true);
                        }
                        
                    }
                }
            }else{
                renFeatureSelect.put(mso+'ServicesOptional', false);
            }
            }
                   
  //          List<DeserializeProductAccessories.Select_Configuration> lstConfigurationOptionSelect = new List<DeserializeProductAccessories.Select_Configuration>();
  //          Map<String, List<DeserializeProductAccessories.Select_Configuration>> mapConfigurationOptionSelect = new Map<String, List<DeserializeProductAccessories.Select_Configuration>>();
                      
        for(String mcos:mapConfigurationOptionSelect.keyset()){
                          
            if(mapConfigurationOptionSelect.get(mcos)!=null){
                for(DeserializeProductAccessories.Select_Configuration cos:mapConfigurationOptionSelect.get(mcos)){
                    system.debug('cos--> ' +cos);
                        objOptionProduct = new OptionProduct();
                        objOptionProduct.product_code = cos.option_code;
                        objOptionProduct.sel_check = false;
                        objOptionProduct.sel_button = true;
                        objOptionProduct.renButton = true;
                        objOptionProduct.is_selected = false;
                        objOptionProduct.sel_type = 'Select One';
                        //     objOptionProduct.option_id = op.Id;
                        objOptionProduct.product_id = cos.option_code;
                        objOptionProduct.product_name = cos.description;
                    //    objOptionProduct.product_description = cos.description;
                        //   objOptionProduct.list_price = '0';
                        //    objOptionProduct.list_price = '0';
                        objOptionProduct.list_price = '0';
                        lstTempOption = new List<OptionProduct>();
                        
                        if(mapOptionProduct.keySet().contains(mcos+'ConfigSelect_One')){
                            lstTempOption.addAll(mapOptionProduct.get(mcos+'ConfigSelect_One'));
                        }else{
                            mapOptionProduct.put(mcos+'ConfigSelect_One', lstTempOption);
                        }
                        lstTempOption.add(objOptionProduct);
                        
                        mapOptionProduct.put(mcos+'ConfigSelect_One', lstTempOption);
                        
                        setTempString = new Set<String>();
                        if(mapFeatureSelect.keySet().contains(mcos+'Config')){
                            setTempString.addAll(mapFeatureSelect.get(mcos+'Config'));
                        }else{
                            mapFeatureSelect.put(mcos+'Config', setTempString);
                        }
                        setTempString.add('Select_One');
                        
                        mapFeatureSelect.put(mcos+'Config', setTempString);
                        renFeatureSelect.put(mcos+'ConfigSelect_One', true);
                        if(setTempString.size()>0){
                            mapFeatureRender.put(mcos+'Config',true);
                        }
                        
                    /*

                        objOptionProduct = new OptionProduct();
                        objOptionProduct.product_code = pso.part_number;
                        objOptionProduct.sel_check = false;
                        objOptionProduct.sel_button = true;
                        objOptionProduct.renButton = true;
                        objOptionProduct.is_selected = false;
                        objOptionProduct.sel_type = 'Select One';
                        //     objOptionProduct.option_id = op.Id;
                        objOptionProduct.product_id = mapProductCode.get(pso.part_number);
                        objOptionProduct.product_name = pso.product_name;
                    //    objOptionProduct.product_description = mapProductCode.get(pso.part_number).Description;
                        //   objOptionProduct.list_price = string.valueOf(mapKAP.get(op.SBQQ__OptionalSKU__c));//'100';
                        //    objOptionProduct.list_price = string.valueOf(mapKAP.get(op.SBQQ__OptionalSKU__r.ProductCode));//'100';
                        objOptionProduct.list_price = string.valueOf(mapKAP.get(pso.part_number));//'100';
                        lstTempOption = new List<OptionProduct>();
                        
                        if(mapOptionProduct.keySet().contains(mpso+'PartsSelect_One')){
                            lstTempOption.addAll(mapOptionProduct.get(mpso+'PartsSelect_One'));
                        }else{
                            mapOptionProduct.put(mpso+'PartsSelect_One', lstTempOption);
                        }
                        lstTempOption.add(objOptionProduct);
                        
                        mapOptionProduct.put(mpso+'PartsSelect_One', lstTempOption);
                        
                        setTempString = new Set<String>();
                        if(mapFeatureSelect.keySet().contains(mpso+'Parts')){
                            setTempString.addAll(mapFeatureSelect.get(mpso+'Parts'));
                        }else{
                            mapFeatureSelect.put(mpso+'Parts', setTempString);
                        }
                        setTempString.add('Select_One');
                        
                        mapFeatureSelect.put(mpso+'Parts', setTempString);
                        renFeatureSelect.put(mpso+'PartsSelect_One', true);
                        if(setTempString.size()>0){
                            mapFeatureRender.put(mpso+'Parts',true);
                        }
                        

*/
                }
            }else{
                renFeatureSelect.put(mcos+'ConfigSelect_All', false);
            }
        }
                      
                      
            
            system.debug('resdoc:' +resdoc);
                      
            list<String> lstTempProductKey= new list<String>();
            for(String pc:lstProductCode){
                lstTempProductKey= new list<String>();
                for(String rf:renFeatureSelect.keyset()){
                    if(renFeatureSelect.get(rf) && rf.contains(pc) ){
                        lstTempProductKey.add(rf);
                    }
                }
                
                mapProductKey.put(pc, lstTempProductKey);
            }
            
            system.debug('renFeatureSelect:' +renFeatureSelect);
            system.debug('mapFeatureSelect:' +mapFeatureSelect);
            system.debug('mapProductKey:' +mapProductKey);
       //     system.debug('mapOptionProduct:' +mapOptionProduct);
            for(String mop:mapOptionProduct.keySet()){
                system.debug('mop:' +mop);
                system.debug('mapOptionProduct.get(mop):' +mapOptionProduct.get(mop));
            }
            
        }else{
            system.debug('RW.Response.getStatusCode()>>' +RW.Response.getStatusCode()); 
            if(RW.Response.getStatusCode()==500){
                renRedirect = true;
            }else{
                renError = true;
                strError = RW.Response.getStatusCode()!=null?string.valueof(RW.Response.getStatusCode()):'' + RW.message;
            }
        }
        }else{
                system.debug('Non-DDC Fulfillment');
                renRedirect = true;
        } 
        }
                system.debug('renFeatureSelect:' +renFeatureSelect);
        
    }

    public PageReference redirectQLE(){
        
                system.debug('mapKAP:' +mapKAP);
                system.debug('mapCost:' +mapCost);  
                system.debug('mapPriceSource:' +mapPriceSource);  
                system.debug('renRedirect:' +renRedirect);  
                system.debug('renError:' +renError);  
                system.debug('strError:' +strError);  
        
        if(renRedirect || Test.isRunningTest() ){
            List<Quote_Line_Staging__c> lstQLStaging = new List<Quote_Line_Staging__c>();
            Quote_Line_Staging__c objQLStaging = new Quote_Line_Staging__c();
            String ran = '';
            for(String pc:lstProductCode){
                if(mapKAP.get(pc)!=null && mapCost.get(pc)!=null ){
                    ran = String.valueOf(Math.mod(Math.round(Math.random()*1000000+1),1000000));
                    //      system.debug('prod:' +prod);
                    objQLStaging = new Quote_Line_Staging__c();
                    objQLStaging.Product__c = mapProductCode.get(pc);
                    objQLStaging.Quote__c = quoteId;
                    objQLStaging.Quantity__c = 1;
                    objQLStaging.Additional_Disc__c = 0;
                    objQLStaging.List_Unit_Price__c = mapKAP.get(pc);
                    objQLStaging.List_Unit_Cost__c = mapCost.get(pc);
                    objQLStaging.Price_Source__c = mapPriceSource.get(pc);
                    objQLStaging.ProductParent__c = mapProductCode.get(pc);                
                    objQLStaging.ProductParentUnique__c = mapProductCode.get(pc)+ran;                
                    objQLStaging.isProductParent__c = true;                
                    objQLStaging.Feature__c = '';         
                    objQLStaging.Configuration_Code__c = configurationcode;                
                    objQLStaging.Configuration_Option__c = configurationoption;
                    if(setQLSSubstitute.size()>0){
                        for(Quote_Line_Staging__c sqs:setQLSSubstitute){
                            if(sqs.Substituted_Product__c==null){
                                objQLStaging.Substituted_Product__c = sqs.Product__c;
                            }else{
                                objQLStaging.Substituted_Product__c = sqs.Substituted_Product__c;
                            }
                            if(sqs.Substituted_Product_Code__c==null){
                                objQLStaging.Substituted_Product_Code__c = sqs.Product__r.ProductCode;
                            }else{
                                objQLStaging.Substituted_Product_Code__c = sqs.Substituted_Product_Code__c;
                            }
                            if(sqs.Substituted_Product_Cost__c==null){
                                objQLStaging.Substituted_Product_Cost__c = sqs.List_Unit_Cost__c;
                            }else{
                                objQLStaging.Substituted_Product_Cost__c = sqs.Substituted_Product_Cost__c;
                            }
                            if(sqs.Substituted_Product_Price__c==null){
                                objQLStaging.Substituted_Product_Price__c = sqs.Net_Unit_Price__c;
                            }else{
                                objQLStaging.Substituted_Product_Price__c = sqs.Substituted_Product_Price__c;
                            }
                            if(sqs.Substituted_Product_Quantity__c==null){
                                objQLStaging.Substituted_Product_Quantity__c = sqs.Quantity__c;
                            }else{
                                objQLStaging.Substituted_Product_Quantity__c = sqs.Substituted_Product_Quantity__c;
                            }
                            if(sqs.Substituted_Product_Source__c==null){
                                objQLStaging.Substituted_Product_Source__c = sqs.Price_Source__c;
                            }else{
                                objQLStaging.Substituted_Product_Source__c = sqs.Substituted_Product_Source__c;
                            }
                            if(sqs.Substitution_Reason__c==null){
                                objQLStaging.Substitution_Reason__c = '';
                            }else{
                                objQLStaging.Substitution_Reason__c = sqs.Substitution_Reason__c;
                            }
                            if(sqs.Substituted_Product_Created_Date__c==null){
                                objQLStaging.Substituted_Product_Created_Date__c = sqs.CreatedDate;
                            }else{
                                objQLStaging.Substituted_Product_Created_Date__c = sqs.Substituted_Product_Created_Date__c;
                            }
                        }
                    }
                    if(setQLSEdit.size()>0){
                        for(Quote_Line_Staging__c sqe:setQLSEdit){
                            if(sqe.Substituted_Product__c!=null){
                                objQLStaging.Substituted_Product__c = sqe.Substituted_Product__c;
                            }
                            if(sqe.Substituted_Product_Code__c!=null){
                                objQLStaging.Substituted_Product_Code__c = sqe.Substituted_Product_Code__c;
                            }
                            if(sqe.Substituted_Product_Cost__c!=null){
                                objQLStaging.Substituted_Product_Cost__c = sqe.Substituted_Product_Cost__c;
                            }
                            if(sqe.Substituted_Product_Price__c!=null){
                                objQLStaging.Substituted_Product_Price__c = sqe.Substituted_Product_Price__c;
                            }
                            if(sqe.Substituted_Product_Quantity__c!=null){
                                objQLStaging.Substituted_Product_Quantity__c = sqe.Substituted_Product_Quantity__c;
                            }
                            if(sqe.Substituted_Product_Source__c!=null){
                                objQLStaging.Substituted_Product_Source__c = sqe.Substituted_Product_Source__c;
                            }
                            if(sqe.Substitution_Reason__c!=null){
                                objQLStaging.Substitution_Reason__c = sqe.Substitution_Reason__c;
                            }
                            if(sqe.Substituted_Product_Created_Date__c==null){
                                objQLStaging.Substituted_Product_Created_Date__c = sqe.CreatedDate;
                            }else{
                                objQLStaging.Substituted_Product_Created_Date__c = sqe.Substituted_Product_Created_Date__c;
                            }
                        }
                    }
                    lstQLStaging.add(objQLStaging);
                }
            }
            
            insert lstQLStaging;
            
        List<SBQQ__Quote__c> lstQuoteDiscountUpdate = new List<SBQQ__Quote__c>();
        lstQuoteDiscountUpdate = [SELECT Id, Name, Delivery_Charge__c, Delivery_Discount__c FROM SBQQ__Quote__c WHERE Id=:quoteId];
        if(lstQuoteDiscountUpdate.size()>0){
            for(SBQQ__Quote__c ld:lstQuoteDiscountUpdate){
                ld.Delivery_Charge__c = 0;
                ld.Delivery_Discount__c = 0;
            }
            update lstQuoteDiscountUpdate;
        }
        
        system.debug('quoteId--> ' + quoteId );
        system.debug('productId--> ' + productId );
    //    PageReference retURL = new PageReference('/apex/QuoteLineEditor?id=' + quoteId );
        PageReference retURL = new PageReference('/apex/ProductIntegration?id=' + quoteId );
        retURL.setRedirect(true);
        return retURL;

        }else if(renError){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,strError));
        }
        
        return null;
    }
    
    public PageReference actionSelected(){
        String prod = System.currentPageReference().getParameters().get('prod');
        String prcd = System.currentPageReference().getParameters().get('prcd');
        String key = System.currentPageReference().getParameters().get('key');
        system.debug('prod--> ' + prod );
        system.debug('prcd--> ' + prcd );
        system.debug('key--> ' + key );
        if(prcd=='install_j'){
            maprenInstallation.put(prod,true);
        }else{
            maprenInstallation.put(prod,false);
        }
                            
   //     objQLStaging.Configuration_Code__c = configurationcode;                
   //     objQLStaging.Configuration_Option__c = configurationoption;                

        list<OptionProduct> lstTempOption= new list<OptionProduct>();
        list<OptionProduct> lstTempOption2= new list<OptionProduct>();
                    if(!Test.isRunningTest()){
                for(OptionProduct op:mapOptionProduct.get(key)){
                    system.debug('op:' +op);
                    if(op.product_code==prcd && op.product_code!='install_j' ){
                        op.is_selected = true;
                    }else{
                        op.is_selected = false;
                    }
                    lstTempOption.add(op);
                }
        mapOptionProduct.put(key, lstTempOption);
        
        
                for(OptionProduct si:mapOptionProduct.get(prod+'ServicesInstall')){
                    system.debug('si:' +si);
                  //      si.is_selected = false;
                    lstTempOption2.add(si);
                }
                    }
        mapOptionProduct.put(prod+'ServicesInstall', lstTempOption2);
        mapselInstallation.put(prod, 'None');

        return null;
    }
    
    public PageReference actionInstallation(){
        String prod = System.currentPageReference().getParameters().get('prod');
        String key = System.currentPageReference().getParameters().get('key');
        String prcd = '';
        prcd = mapselInstallation.get(prod);
        system.debug('prod--> ' + prod );
        system.debug('prcd--> ' + prcd );
        system.debug('key--> ' + key );
                          if(!Test.isRunningTest() ){

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
                          }
        
        maprenInstallprice.put(prod, true);
        
        return null;
    }
    
    public list<selectoption> getInstallationService(){
        list<selectoption> lstSel= new list<selectoption>();
        lstSel.add(new SelectOption('None', '--None--'));
        if(mapInstallation.size()>0){
            for(String mi:mapInstallation.keyset()){
                lstSel.add(new SelectOption(mi, mi + ' - '  + mapInstallation.get(mi)));            
            }
        }
        return lstSel;
    }
    
    public PageReference gotoProducts()
    {
 //       PageReference retURL = new PageReference('/apex/QuoteLineProducts?id=' + quoteId );
 //       retURL.setRedirect(true);
 //       return retURL;
        
        system.debug('parentUnique--> ' + parentUnique );
        system.debug('editProduct--> ' + editProduct );
        
        if(parentUnique==null && editProduct==null  ){
            PageReference retURL = new PageReference('/apex/QuoteLineProducts?id=' + quoteId );
            retURL.setRedirect(true);
            return retURL;
        }else if(parentUnique!=null && editProduct==null  ){
            PageReference retURL = new PageReference('/apex/QuoteLineProducts?id=' + quoteId + '&pu=' + parentUnique );
            retURL.setRedirect(true);
            return retURL;
        }else if(parentUnique==null && editProduct!=null  ){
            PageReference retURL = new PageReference('/apex/QuoteLineEditor?id=' + quoteId );
            retURL.setRedirect(true);
            return retURL;
        }
        return null;
    }
    
    
    public PageReference actionSave(){
        
        List<String> lstErrorMessage = new List<String>();
        Map<String, Integer> mapKeyCount = new Map<String, Integer>();
        Map<String, Integer> mapKeySize = new Map<String, Integer>();
        Map<String, Boolean> mapisServiceInstallJ = new Map<String, Boolean>();
        Map<String, Boolean> mapisInstallation = new Map<String, Boolean>();
        Map<String, Boolean> mapisServiceException = new Map<String, Boolean>();
        
        for(String prod:mapProductKey.keySet()){
            system.debug('prod:' +prod);                                   
            mapisServiceInstallJ.put(prod, false);
            mapisInstallation.put(prod, false);
            mapisServiceException.put(prod, false);
            for(String key:mapOptionProduct.keySet()){
                mapKeyCount.put(key, 0);
                mapKeySize.put(key, mapOptionProduct.get(key).size());
            
                system.debug('mapOptionProduct.get(key):' +mapOptionProduct.get(key));                                   
                
                for(OptionProduct op:mapOptionProduct.get(key)){
                    if(op.product_code=='install_J'){
                        mapisServiceInstallJ.put(prod, true);
                    }
                    system.debug('op:' +op);
                    if(op.is_selected){
                        mapKeyCount.put(key, mapKeyCount.get(key)+1);
                        if(key==prod+'ServicesInstall'){
                            mapisInstallation.put(prod, true);
                        }
                    //    if(op.product_code=='brownbox_10' || op.product_code=='uncrate_K' ){
                        if(op.product_code=='brownbox_10' || op.product_code=='uncrate_K' || op.product_code.startsWith('01') || op.product_code.startsWith('4') ){
                            mapisServiceException.put(prod, true);
                        }
                        if(key==prod+'ConfigSelect_One'){
                            configurationcode = op.product_code;
                            configurationoption = op.product_name;
   //     objQLStaging.Configuration_Code__c = configurationcode;                
   //     objQLStaging.Configuration_Option__c = configurationoption;                
                        }
                    }
                }
            }
        }
        
            system.debug('mapKeyCount:' +mapKeyCount);                                   
            system.debug('mapKeySize:' +mapKeySize); 
            system.debug('mapisServiceInstallJ:' +mapisServiceInstallJ); 
            system.debug('mapisInstallation:' +mapisInstallation); 
            system.debug('mapisServiceException:' +mapisServiceException); 
            system.debug('configurationcode:' +configurationcode); 
            system.debug('configurationoption:' +configurationoption); 
        
        
        for(String prod:mapProductKey.keySet()){
            lstErrorMessage = new List<String>();
            for(String ks:mapKeySize.keyset()){
                
                if( (ks == prod + 'PartsSelect_All') && (mapKeyCount.get(ks) < mapKeySize.get(ks)) && !mapisServiceException.get(prod) ){
                        lstErrorMessage.add('Please Select All Parts for ' + prod );
                }else if( (ks == prod + 'PartsSelect_One') && (mapKeyCount.get(ks) < 1)  && !mapisServiceException.get(prod) ){
                        lstErrorMessage.add('Please Select one Part for ' + prod );
                }else if( (ks == prod + 'ServicesSelect_All') && (mapKeyCount.get(ks) < mapKeySize.get(ks)) ){
                        lstErrorMessage.add('Please Select All Services for ' + prod );
                }else if( (ks == prod + 'ServicesSelect_One') && (mapKeyCount.get(ks) < 1)  && !mapisInstallation.get(prod)  ){
                       lstErrorMessage.add('Please Select a Service/Installation for ' + prod );
                }else if( (ks == prod + 'ServicesInstall') && (mapKeyCount.get(ks) < 1) && !mapisServiceInstallJ.get(prod) ){
                        lstErrorMessage.add('Please Select a Service/Installation for ' + prod );
                }
                
            }
        }
        
        
        for(String er:lstErrorMessage){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,er));
        }
        
        if(lstErrorMessage.size()==0){
        List<Quote_Line_Staging__c> lstQLStaging = new List<Quote_Line_Staging__c>();
        Quote_Line_Staging__c objQLStaging = new Quote_Line_Staging__c();
        String ran = '';
        
        for(String prod:mapProductKey.keySet()){
            ran = String.valueOf(Math.mod(Math.round(Math.random()*1000000+1),1000000));
      //      system.debug('prod:' +prod);
            objQLStaging = new Quote_Line_Staging__c();
            objQLStaging.Product__c = mapProductCode.get(prod);
            objQLStaging.Quote__c = quoteId;
            objQLStaging.Quantity__c = 1;
            objQLStaging.Additional_Disc__c = 0;
            objQLStaging.List_Unit_Price__c = mapKAP.get(prod);
            objQLStaging.List_Unit_Cost__c = mapCost.get(prod);
            objQLStaging.Price_Source__c = mapPriceSource.get(prod);
            objQLStaging.ProductParent__c = mapProductCode.get(prod);                
            objQLStaging.ProductParentUnique__c = mapProductCode.get(prod)+ran;                
            objQLStaging.isProductParent__c = true;
            objQLStaging.Discount_Operator__c = 'Amount';
            objQLStaging.Feature__c = ''; 
            objQLStaging.Configuration_Code__c = configurationcode;                
            objQLStaging.Configuration_Option__c = configurationoption;   
            if(setQLSSubstitute.size()>0){
                for(Quote_Line_Staging__c sqs:setQLSSubstitute){
                    if(sqs.Substituted_Product__c==null){
                        objQLStaging.Substituted_Product__c = sqs.Product__c;
                    }else{
                        objQLStaging.Substituted_Product__c = sqs.Substituted_Product__c;
                    }
                    if(sqs.Substituted_Product_Code__c==null){
                        objQLStaging.Substituted_Product_Code__c = sqs.Product__r.ProductCode;
                    }else{
                        objQLStaging.Substituted_Product_Code__c = sqs.Substituted_Product_Code__c;
                    }
                    if(sqs.Substituted_Product_Cost__c==null){
                        objQLStaging.Substituted_Product_Cost__c = sqs.List_Unit_Cost__c;
                    }else{
                        objQLStaging.Substituted_Product_Cost__c = sqs.Substituted_Product_Cost__c;
                    }
                    if(sqs.Substituted_Product_Price__c==null){
                        objQLStaging.Substituted_Product_Price__c = sqs.Net_Unit_Price__c;
                    }else{
                        objQLStaging.Substituted_Product_Price__c = sqs.Substituted_Product_Price__c;
                    }
                    if(sqs.Substituted_Product_Quantity__c==null){
                        objQLStaging.Substituted_Product_Quantity__c = sqs.Quantity__c;
                    }else{
                        objQLStaging.Substituted_Product_Quantity__c = sqs.Substituted_Product_Quantity__c;
                    }
                    if(sqs.Substituted_Product_Source__c==null){
                        objQLStaging.Substituted_Product_Source__c = sqs.Price_Source__c;
                    }else{
                        objQLStaging.Substituted_Product_Source__c = sqs.Substituted_Product_Source__c;
                    }
                    if(sqs.Substitution_Reason__c==null){
                        objQLStaging.Substitution_Reason__c = '';
                    }else{
                        objQLStaging.Substitution_Reason__c = sqs.Substitution_Reason__c;
                    }
                    if(sqs.Substituted_Product_Created_Date__c==null){
                        objQLStaging.Substituted_Product_Created_Date__c = sqs.CreatedDate;
                    }else{
                        objQLStaging.Substituted_Product_Created_Date__c = sqs.Substituted_Product_Created_Date__c;
                    }
                }
            }
            if(setQLSEdit.size()>0){
                for(Quote_Line_Staging__c sqe:setQLSEdit){
                    if(sqe.Substituted_Product__c!=null){
                        objQLStaging.Substituted_Product__c = sqe.Substituted_Product__c;
                    }
                    if(sqe.Substituted_Product_Code__c!=null){
                        objQLStaging.Substituted_Product_Code__c = sqe.Substituted_Product_Code__c;
                    }
                    if(sqe.Substituted_Product_Cost__c!=null){
                        objQLStaging.Substituted_Product_Cost__c = sqe.Substituted_Product_Cost__c;
                    }
                    if(sqe.Substituted_Product_Price__c!=null){
                        objQLStaging.Substituted_Product_Price__c = sqe.Substituted_Product_Price__c;
                    }
                    if(sqe.Substituted_Product_Quantity__c!=null){
                        objQLStaging.Substituted_Product_Quantity__c = sqe.Substituted_Product_Quantity__c;
                    }
                    if(sqe.Substituted_Product_Source__c!=null){
                        objQLStaging.Substituted_Product_Source__c = sqe.Substituted_Product_Source__c;
                    }
                    if(sqe.Substitution_Reason__c!=null){
                        objQLStaging.Substitution_Reason__c = sqe.Substitution_Reason__c;
                    }
                    if(sqe.Substituted_Product_Created_Date__c==null){
                        objQLStaging.Substituted_Product_Created_Date__c = sqe.CreatedDate;
                    }else{
                        objQLStaging.Substituted_Product_Created_Date__c = sqe.Substituted_Product_Created_Date__c;
                    }
                }
            }
            lstQLStaging.add(objQLStaging);
            
            for(String key:mapOptionProduct.keySet()){
       //         system.debug('key:' +key);
      //          system.debug('mapOptionProduct.get(key):' +mapOptionProduct.get(key));
                for(OptionProduct op:mapOptionProduct.get(key)){
     //               system.debug('op:' +op);
     //               if(op.is_selected){
                    if(op.is_selected && mapProductCode.Keyset().contains(op.product_code) && (!renHaulAway || op.product_code!='haulawayRequested' ) ){
                        objQLStaging = new Quote_Line_Staging__c();
                        objQLStaging.Product__c = op.product_id;
                        objQLStaging.Quote__c = quoteId;
                        objQLStaging.Quantity__c = 1;
                        objQLStaging.Additional_Disc__c = 0;
                        objQLStaging.List_Unit_Price__c = key.contains('Parts')?mapKAP.get(op.product_code):Double.valueOf(op.list_price);
                        objQLStaging.List_Unit_Cost__c = key.contains('Parts')?mapCost.get(op.product_code):Double.valueOf(op.list_price);
                        objQLStaging.Price_Source__c = key.contains('Parts')?mapPriceSource.get(op.product_code):'';
                        objQLStaging.ProductParent__c = mapProductCode.get(prod);                
                        objQLStaging.ProductParentUnique__c = mapProductCode.get(prod)+ran;                
                        objQLStaging.isProductParent__c = false;              
                        objQLStaging.Discount_Operator__c = 'Amount';
                        objQLStaging.Feature__c = key.contains('Parts')?'Parts':(key.contains('Services')?'Services':''); 
                            objQLStaging.Configuration_Code__c = '';                
                            objQLStaging.Configuration_Option__c = '';                
                        lstQLStaging.add(objQLStaging);
                    }
                }
            }
        }
        
        system.debug('lstQLStaging:' +lstQLStaging);
        for(Quote_Line_Staging__c qls:lstQLStaging){
            system.debug('qls:' +qls);
        }
        
            insert lstQLStaging;
            
            List<Quote_Line_Staging__c> lstQLStagingDelete = new List<Quote_Line_Staging__c>();
        if(editProduct!=null){
            List<Quote_Line_Staging__c> lstQLStagingDelete1 = new List<Quote_Line_Staging__c>();
            lstQLStagingDelete1 = [SELECT Id FROM Quote_Line_Staging__c 
                                   WHERE Quote__c=:quoteId AND ProductParentUnique__c=:editProduct 
                                 ];
           // delete lstQLStagingDelete1;
            lstQLStagingDelete.addAll(lstQLStagingDelete1);
        }
        
        if(parentUnique!=null){
            List<Quote_Line_Staging__c> lstQLStagingDelete2 = new List<Quote_Line_Staging__c>();
            lstQLStagingDelete2 = [SELECT Id FROM Quote_Line_Staging__c 
                                   WHERE Quote__c=:quoteId AND ProductParentUnique__c=:parentUnique 
                                  ];
           // delete lstQLStagingDelete2;
            lstQLStagingDelete.addAll(lstQLStagingDelete2);
        }
            
            if(lstQLStagingDelete.size()>0){
                delete lstQLStagingDelete;
            }   
            
        List<SBQQ__Quote__c> lstQuoteDiscountUpdate = new List<SBQQ__Quote__c>();
        lstQuoteDiscountUpdate = [SELECT Id, Name, Delivery_Charge__c, Delivery_Discount__c FROM SBQQ__Quote__c WHERE Id=:quoteId];
        if(lstQuoteDiscountUpdate.size()>0){
            for(SBQQ__Quote__c ld:lstQuoteDiscountUpdate){
                ld.Delivery_Charge__c = 0;
                ld.Delivery_Discount__c = 0;
            }
                    update lstQuoteDiscountUpdate;
        }
        
        PageReference retURL = new PageReference('/apex/ProductIntegration?id=' + quoteId );
        retURL.setRedirect(true);
        return retURL;
        }else{
        return null;
            }
            
    }
    

    
    
    public class productaccessoriessend {
        public String part_number {get;set;}
        public String quantity {get;set;}
        public String zipcode {get;set;}
    //    public String account {get;set;}
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
    
    
    
}