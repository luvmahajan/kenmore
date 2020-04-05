public class OrderQuoteController {
    public String quoteId {get; set;}
    public String ordertype {get; set;}
    
    public List<SerializeCalenderAPI> lstSerializeCalender {get; set;}
    public SerializeCalenderAPI objSerializeOrder {get; set;}
    
    public List<SBQQ__QuoteLine__c> lstQuoteLine {get; set;}
    public List<SBQQ__QuoteLine__c> lstQuoteLineAll {get; set;}
    public List<SBQQ__QuoteLine__c> lstQuoteLineProd {get; set;}
    
    public String payType {get; set;}
    public String paymentType {get; set;}
    public Boolean isQuotePrimary {get; set;}
    public String delDate {get; set;}
    public String delNote {get; set;}
    public Set<String> setDate {get; set;}
    public Boolean renSubstitute {get; set;}
    public Boolean renDuplicate {get; set;}
    public Map<String, Map<String, String>> mapDeliveryProduct {get; set;}
    public Map<String, String> mapConfiguration {get; set;}
    public Map<String,String> mapSelectedConfiguration {get; set;}
    public Map<String, list<selectoption>> mapSel {get; set;}
    public Map<String,String> mapProductPriceBook {get; set;}
    public Map<String,String> mapParentNumber {get; set;}
    public Map<String,String> mapParentCode {get; set;}
    public Map<String,String> mapParentUnique {get; set;}
    
    public Boolean renDelivery {get; set;}
    public Boolean renLoading {get; set;}
    public String accountId {get; set;}
    public Double deliverycharge {get; set;}
    public String purchasenumber {get; set;}
    public String territory_id {get; set;}
    public String district_id {get; set;}
    public String orderreferencenumber {get; set;}
    public String contractId {get; set;}
    public String b2borderid {get; set;}
    public String insertorderid {get; set;}
    public Boolean renOrderCreateError {get; set;}
    public String b2bOrderErrorMessage {get; set;}
    public String orderapirequest {get; set;}
    
    public Date selectedStartDate {get; set;}
    public String quoteLocNo {get; set;}
    public String CCA_Location {get; set;}
    public List<String> lstCCALocations {get; set;}
    public Map<String, String> mapCCALocations {get; set;}
    public String selectedCCALocation {get; set;}
    public String selectedAddressType {get; set;}
    public String selectedPickupStore {get; set;}
    public Boolean isATShipping {get; set;}
    public Boolean isATPickup {get; set;}

    public List<String> lstAddEmails {get; set;}
    public String selectedAddEmail {get; set;}
    
    public String quoteAccountSCOId {get; set;}
    public String selectedCreditCard {get; set;}
    public List<String> lstCreditCards {get; set;}
    public Map<String, String> mapUID {get; set;}
    
    public Boolean renCCMsg {get; set;}
    public String pu_firstname {get; set;}
    public String pu_lastname {get; set;}
    public String pu_email {get; set;}
    public String pu_phone {get; set;}
    
    
    
    public OrderQuoteController() {
     //   quoteId = 'a2bW0000000ko3EIAQ';
        quoteId = ApexPages.CurrentPage().getparameters().get('id');
        //   productId = '01tW0000003QCUeIAO';
        payType = ApexPages.CurrentPage().getparameters().get('pay');
        paymentType = '';
        delDate = '';
        delNote = '';
        
        ordertype = 'Quote';
        
        lstSerializeCalender = new List<SerializeCalenderAPI>();
        objSerializeOrder = new SerializeCalenderAPI();
        lstQuoteLine = new List<SBQQ__QuoteLine__c>();        
        lstQuoteLineAll = new List<SBQQ__QuoteLine__c>();        
        lstQuoteLineProd = new List<SBQQ__QuoteLine__c>();        
        setDate = new Set<String>();
        
        isQuotePrimary = false;
        renSubstitute = false;
        renDuplicate = false;
        renDelivery = false;
        renLoading = false;
        accountId = '';
        deliverycharge = 0;
        purchasenumber = '';
        territory_id ='';
        district_id ='';
        orderreferencenumber ='';
        contractId = '';
        b2borderid = '';
        insertorderid= '';
        b2bOrderErrorMessage= '';
        orderapirequest= '';
        renOrderCreateError = false;
        
        selectedStartDate = system.today();
        quoteLocNo = '';
        CCA_Location= '';
        lstCCALocations = new List<String>();
        mapCCALocations = new Map<String, String>();
        selectedCCALocation = '';
        selectedAddressType = '';
        selectedPickupStore = '';
        isATShipping = false;
        isATPickup = false;
        
        mapDeliveryProduct = new Map<String, Map<String, String>>();
        mapConfiguration = new Map<String, String>();
        mapSel = new Map<String, list<selectoption>>();
        mapSelectedConfiguration = new Map<String, String>();
        mapProductPriceBook = new Map<String, String>();
        mapParentNumber = new Map<String, String>();
        mapParentCode = new Map<String, String>();
        mapParentUnique = new Map<String, String>();
            
        lstAddEmails = new List<String>();
        selectedAddEmail = '';
        
        quoteAccountSCOId = '';
        selectedCreditCard = '';
        lstCreditCards = new List<String>();
        mapUID = new Map<String, String>();
        
        renCCMsg = false;
        
        pu_firstname = '';
        pu_lastname = '';
        pu_email = '';
        pu_phone = '';
        
        List<Order_Staging__c> lstOrderStagingQry = new List<Order_Staging__c>();
        lstOrderStagingQry = [SELECT Id, Active__c, Delete_Date__c, Delivery_Dates__c, Quote__c, Contract__c, Payment_Type__c, Order_Reference_Number__c, Quote__r.LastModifiedDate, CreatedDate
                              FROM Order_Staging__c
                              WHERE Quote__c=:quoteId AND Contract__c=null AND Delete_Date__c >: system.now()
                              LIMIT 1
                             ];
        system.debug('lstOrderStagingQry--> ' + lstOrderStagingQry );
        
        if(lstOrderStagingQry.size()>0){
            
            for(Order_Staging__c os:lstOrderStagingQry){
                system.debug('os.CreatedDate--> ' + os.CreatedDate );
                system.debug('os.Quote__r.LastModifiedDate--> ' + os.Quote__r.LastModifiedDate );
                if(os.Quote__r.LastModifiedDate>os.CreatedDate){
                    system.debug('1');
                }else{
                    system.debug('2');
                    
                    if(os.Order_Reference_Number__c!=null){
                        orderreferencenumber = os.Order_Reference_Number__c;
                    }
                    if(os.Payment_Type__c!=null){
                        payType = os.Payment_Type__c;
                    }
                    if(os.Delivery_Dates__c!=null){
                        String str_deliverydate = '';
                        str_deliverydate = os.Delivery_Dates__c;
                        renDelivery = true;
                        setDate = new Set<String>();
                        setDate.addAll(str_deliverydate.split(','));
                        //    List<String> lstAlpha = alpha.split(',');
                    }
                    
                    
                    
                    
                }
            }
            
            
            /*
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
*/
            
        }
        /*
                      Order_Staging__c objOrderStagingInsert = new Order_Staging__c();
                      objOrderStagingInsert.Active__c = true;
                      objOrderStagingInsert.Delete_Date__c = system.now().addMinutes(15);
                      objOrderStagingInsert.Delivery_Dates__c = str_date;
                      objOrderStagingInsert.Quote__c = quoteId;
                      objOrderStagingInsert.Contract__c = ordertype=='Contract'?contractId:null;
                      objOrderStagingInsert.Delivery_Dates__c = str_date;
              //        objOrderStagingInsert.SBQQ__Quote__c = quoteId;
             //         objOrderStagingInsert.AccountId = accountId;
             //         objOrderStagingInsert.District_Id__c=district_id;
                      lstOrderStagingInsert.add(objOrderStagingInsert);
        */
        
    }
    
    public PageReference redirectQLE()
    {
        selectedAddressType = 'Shipping Address';
        isATShipping = true;
        isATPickup = false;
        renSubstitute = false;
        renDuplicate = false;
        SBQQ__Quote__c qheader = new SBQQ__Quote__c();
        qheader = [select SBQQ__NetAmount__c , SBQQ__ShippingCity__c, SBQQ__ShippingPostalCode__c, 
                   SBQQ__ShippingState__c, SBQQ__ShippingStreet__c, GeoCode__c, County_Code__c,
                   Location_Number__c, Fulfillment_Type__c, Additional_Delivery_Email_1__c, 
                   Additional_Delivery_Email_2__c, SBQQ__Account__r.SCO_Account_ID__c
                   from SBQQ__Quote__c where Id = :quoteId LIMIT 1];
        if(qheader!=null && qheader.SBQQ__ShippingPostalCode__c!=null ){
    //    CalloutProdInventoryCheckAPI5.ProdAvailCheckWrapper(qheader);
   //       CalloutProdInventoryCheckAPI7.ProdAvailCheckWrapper2(qheader);
        }
        
        if(qheader.SBQQ__Account__r.SCO_Account_ID__c!=null ){
            quoteAccountSCOId = qheader.SBQQ__Account__r.SCO_Account_ID__c;
        }
        
        system.debug('quoteAccountSCOId--> ' + quoteAccountSCOId );
        
        
        if(qheader.Location_Number__c!=null && qheader.Location_Number__c!='' && qheader.Fulfillment_Type__c!=null && qheader.Fulfillment_Type__c=='ZSDO' ){
            quoteLocNo = qheader.Location_Number__c;
        }
        
        system.debug('quoteLocNo--> ' + quoteLocNo );
        
        if(qheader.Additional_Delivery_Email_1__c!=null && qheader.Additional_Delivery_Email_1__c!='' ){
            lstAddEmails.add(qheader.Additional_Delivery_Email_1__c);
        }
        if(qheader.Additional_Delivery_Email_2__c!=null && qheader.Additional_Delivery_Email_2__c!='' ){
            lstAddEmails.add(qheader.Additional_Delivery_Email_2__c);
        }
        
        system.debug('lstAddEmails--> ' + lstAddEmails );
        
            List<Common_Carrier_Address__mdt> lstCCA = new List<Common_Carrier_Address__mdt>();
            lstCCA = [SELECT Id, DeveloperName, Label, City__c, State__c, Store__c, Street__c, Zip__c 
                      FROM Common_Carrier_Address__mdt
                     ];
            lstCCALocations = new List<String>();
            mapCCALocations = new Map<String, String>();
        
            for(Common_Carrier_Address__mdt cc:lstCCA){
                lstCCALocations.add(cc.Label);
                mapCCALocations.put(cc.Label, cc.Store__c);
                if(cc.Store__c==quoteLocNo){
                    CCA_Location = cc.Label;
                    selectedCCALocation = cc.Label;
                }
            }
        
        List<String> lstProductId = new List<String>();
        Set<String> setProductId = new Set<String>();
        lstQuoteLineProd = new List<SBQQ__QuoteLine__c>();
        
        lstQuoteLineProd = [SELECT Id, Name, SBQQ__Product__c, SBQQ__Product__r.Name, SBQQ__Product__r.ProductCode, SBQQ__Quantity__c, 
                                Available__c, Available_Quantity__c, Earliest_Available_Date__c, PA_API_Message__c, 
                                List_Price__c, Net_Unit_Price__c, Net_Total_Price__c, Tax_Rate__c, Tax__c, Total_Tax_Amount__c, 
                                SBQQ__Number__c, isProductParent__c, ProductParentUnique__c, Feature__c, Configuration_Code__c 
                            FROM SBQQ__QuoteLine__c 
                            WHERE SBQQ__Quote__c=:quoteId
                            ORDER BY SBQQ__Number__c
                           ];
        
        Set<String> setTempProduct = new Set<String>();
        
        for(SBQQ__QuoteLine__c ql:lstQuoteLineProd){
        //    if(ql.SBQQ__ProductOption__r.SBQQ__Feature__r.Name!=null && ql.SBQQ__ProductOption__r.SBQQ__Feature__r.Name!='Parts' ){
        //        ql.Available__c = true;
        //    }
            if(!ql.Available__c){
                renSubstitute = true;
            }
         //   if(ql.SBQQ__ProductOption__r.SBQQ__Feature__r.Name==null){
            if(ql.Feature__c==null){
                lstProductId.add(ql.SBQQ__Product__c);
                mapParentNumber.put(ql.ProductParentUnique__c, string.valueof(ql.SBQQ__Number__c*10));
                mapParentCode.put(ql.ProductParentUnique__c, ql.SBQQ__Product__r.ProductCode);
            
                if(setTempProduct.contains(ql.SBQQ__Product__c )){
                    renDuplicate = true;
                }
                setTempProduct.add(ql.SBQQ__Product__c);
                
            }
            setProductId.add(ql.SBQQ__Product__c);
            mapParentUnique.put(ql.Id, ql.ProductParentUnique__c);
        }
        
    //    renSubstitute = false;
        
        List<PricebookEntry> lstPricebookEntry = new List<PricebookEntry>();
        
        if(lstProductId.size()>0){
            lstPricebookEntry = [SELECT Id, Name, Product2Id  
                                 FROM PricebookEntry 
                                 WHERE  Product2Id IN: setProductId AND Pricebook2Id='01s300000006uBlAAI'
                                ];
            for(PricebookEntry pb:lstPricebookEntry){
                mapProductPriceBook.put(pb.Product2Id, pb.Id);
            }
        }
        
        if(qheader!=null && qheader.SBQQ__ShippingPostalCode__c!=null ){
       //     mapDeliveryProduct = new Map<String, List<String>>();
            mapDeliveryProduct = new Map<String, Map<String, String>>();
            mapDeliveryProduct = DeliveryServiceConfiguration.DeliveryServiceWrapper(quoteId, lstProductId);
            system.debug('mapDeliveryProduct--> ' + mapDeliveryProduct );
            
    //    for(String pc:mapDeliveryProduct.keySet()){
        for(SBQQ__QuoteLine__c ql:lstQuoteLineProd){
            list<selectoption> lstSel= new list<selectoption>();
            lstSel.add(new SelectOption('', '--None--'));
      //    lstSel.add(new SelectOption('18', 'Door should open to the left'));
      //    lstSel.add(new SelectOption('19', 'I have purchased a separate ice-maker, it should be installed prior to delivery.'));
     //     lstSel.add(new SelectOption('20', 'The refrigerator door should open to the left (instead of the right) and I have purchased a separate ice-maker, it should be installed prior to delivery.'));
           
            if(mapDeliveryProduct.keySet().contains(ql.SBQQ__Product__r.ProductCode)){
             //   for (String conf:mapDeliveryProduct.get(ql.SBQQ__Product__r.ProductCode)){
             //       lstSel.add(new SelectOption(conf, mapConfiguration.get(conf))); 
            //    }
                for (String conf:mapDeliveryProduct.get(ql.SBQQ__Product__r.ProductCode).keyset()){
                    lstSel.add(new SelectOption(conf, mapDeliveryProduct.get(ql.SBQQ__Product__r.ProductCode).get(conf))); 
                    mapConfiguration.put(conf, mapDeliveryProduct.get(ql.SBQQ__Product__r.ProductCode).get(conf));
                }
            }
            
            mapSel.put(ql.SBQQ__Product__r.ProductCode, lstSel);
        //  mapSelectedConfiguration.put(ql.Id, '');
            mapSelectedConfiguration.put(ql.Id, ql.Configuration_Code__c);
            if(mapSelectedConfiguration.get(ql.Id)==null){
                mapSelectedConfiguration.put(ql.Id, '');
            }
            
        }
            system.debug('mapSel--> ' + mapSel );
            system.debug('mapSelectedConfiguration--> ' + mapSelectedConfiguration );
            
            
        }
        
        return null;
        
    }
        
    public list<selectoption> getCommonCarrierDropdown()
    {
        list<selectoption> lstSel= new list<selectoption>();
        lstSel.add(new SelectOption('', '--None--'));   
                      
        for(String sd:lstCCALocations){
            lstSel.add(new SelectOption(sd, sd));            
        }
        
        
        system.debug('lstSel:' +lstSel);
        
        return lstSel;
    }
    
    public list<selectoption> getStorePickup()
    {
        List<CommonCarrierOverrideZipcode__c> lstCCSP = new List<CommonCarrierOverrideZipcode__c>();
        lstCCSP = [SELECT Id, Name, Zipcode__c, Facility_Number__c, Store_MDO_Name__c, Store_Type__c FROM CommonCarrierOverrideZipcode__c where Facility_Number__c != null];
        
        list<selectoption> lstSel= new list<selectoption>();
        lstSel.add(new SelectOption('', '--None--'));   
                      
        for(CommonCarrierOverrideZipcode__c sp:lstCCSP){
            lstSel.add(new SelectOption(sp.Facility_Number__c, sp.Facility_Number__c + '-' + sp.Store_MDO_Name__c));            
        }
        
        
        system.debug('lstSel:' +lstSel);
        
        return lstSel;
    }
    
    public list<selectoption> getAddressTypeDropDown()
    {
        list<selectoption> lstSel= new list<selectoption>();
   //     lstSel.add(new SelectOption('', '--None--'));   
        lstSel.add(new SelectOption('Shipping Address', 'Shipping Address'));   
        lstSel.add(new SelectOption('Store Pickup', 'Store Pickup'));   
                      
        
        system.debug('lstSel:' +lstSel);
        
        return lstSel;
    }
    
    public void saveAddressType(){
        
            system.debug('mapSelectedConfiguration--> ' + mapSelectedConfiguration );
        
        
        for(String sq:mapSelectedConfiguration.keySet()){
            if(mapSelectedConfiguration.get(sq)==null){
                mapSelectedConfiguration.put(sq, '');
            }
        }
        
            system.debug('mapSelectedConfiguration--> ' + mapSelectedConfiguration );
        
        String selAT = System.currentPageReference().getParameters().get('selAT');
        system.debug('selAT -->' + selAT );
        isATShipping = false;
        isATPickup = false;
        
        if(selAT=='Shipping Address'){
        isATShipping = true;
        isATPickup = false;
        }else if(selAT=='Store Pickup'){
        isATShipping = false;
        isATPickup = true;
        }
        
  //      return null;
    }    
   /* 
    public PageReference addAdditionalEmail(){
            system.debug('selectedAddEmail--> ' + selectedAddEmail );
            system.debug('lstAddEmails--> ' + lstAddEmails );
        
        lstAddEmails.add(selectedAddEmail);
        selectedAddEmail = '';

            system.debug('selectedAddEmail--> ' + selectedAddEmail );
            system.debug('lstAddEmails--> ' + lstAddEmails );
        
            system.debug('mapSelectedConfiguration--> ' + mapSelectedConfiguration );
        
        
        for(String sq:mapSelectedConfiguration.keySet()){
            if(mapSelectedConfiguration.get(sq)==null){
                mapSelectedConfiguration.put(sq, '');
            }
        }
        
            system.debug('mapSelectedConfiguration--> ' + mapSelectedConfiguration );
        
        
        return null;
    }    
    */
    public PageReference saveLocation(){
            system.debug('selectedAddressType --> ' + selectedAddressType );
            system.debug('selectedCCALocation --> ' + selectedCCALocation );
            system.debug('selectedPickupStore --> ' + selectedPickupStore );
        
        
            system.debug('mapSelectedConfiguration--> ' + mapSelectedConfiguration );
        
        
        for(String sq:mapSelectedConfiguration.keySet()){
            if(mapSelectedConfiguration.get(sq)==null){
                mapSelectedConfiguration.put(sq, '');
            }
        }
        
            system.debug('mapSelectedConfiguration--> ' + mapSelectedConfiguration );
                    CCA_Location = selectedCCALocation;
                //    selectedCCALocation = cc.Label;
        return null;
    }    
    
    public PageReference savePickup(){
        
            system.debug('mapSelectedConfiguration--> ' + mapSelectedConfiguration );
        
        
        for(String sq:mapSelectedConfiguration.keySet()){
            if(mapSelectedConfiguration.get(sq)==null){
                mapSelectedConfiguration.put(sq, '');
            }
        }
        
            system.debug('mapSelectedConfiguration--> ' + mapSelectedConfiguration );
        
            system.debug('selectedAddressType --> ' + selectedAddressType );
            system.debug('selectedCCALocation --> ' + selectedCCALocation );
            system.debug('selectedPickupStore --> ' + selectedPickupStore );
            system.debug('pu_firstname --> ' + pu_firstname );
            system.debug('pu_lastname --> ' + pu_lastname );
            system.debug('pu_email --> ' + pu_email );
            system.debug('pu_phone --> ' + pu_phone );
        pu_phone = pu_phone.replaceAll('\\D','');
            system.debug('pu_phone --> ' + pu_phone );
        
        
        if(selectedPickupStore == null || selectedPickupStore=='' ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select Pick Up Store')); 
        }
        if(pu_firstname == null || pu_firstname=='' ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select Pick Up First Name')); 
        }
        if(pu_lastname == null || pu_lastname=='' ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select Pick Up Last Name')); 
        }
        if(pu_email == null || pu_email=='' ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select Pick Up Email')); 
        }
        if(pu_phone == null || pu_phone=='' ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select Pick Up Phone')); 
        }else if(pu_phone.length()!=10){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select correct format for Pick Up Phone')); 
        }
        
        
        
        
        
        
        
        return null;
    }    
    
        public void verifyDate(){
        String sel_date = System.currentPageReference().getParameters().get('sel_date');
     //   Date sel_date = Date.valueof(System.currentPageReference().getParameters().get('sel_date'));
                    system.debug('sel_date--> ' + sel_date );
        }
    
    public PageReference calculateDeliveryDates(){        
        
            system.debug('mapSelectedConfiguration--> ' + mapSelectedConfiguration );
        
        
        for(String sq:mapSelectedConfiguration.keySet()){
            if(mapSelectedConfiguration.get(sq)==null){
                mapSelectedConfiguration.put(sq, '');
            }
        }
        
            system.debug('mapSelectedConfiguration--> ' + mapSelectedConfiguration );
        
                Integer temp_int = 0;
        Set<String> setTempId = new Set<String>();
        for(SBQQ__QuoteLine__c qli:lstQuoteLine){
            if(mapSelectedConfiguration.get(qli.Id)!=''){
                temp_int++;
                setTempId.add(qli.SBQQ__Product__c+mapSelectedConfiguration.get(qli.Id));
            }
        }
        Boolean isError = false;
        if((payType == '' || payType == null) && (paymentType=='' || paymentType==null) ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select payment type')); 
            isError = true;
        }
        
    //    if((selectedCreditCard == null || selectedCreditCard == '') && (payType == 'Credit Card' || paymentType=='Credit Card' ) ){
        if((selectedCreditCard == null || selectedCreditCard == '') && (payType == 'Credit Card' || paymentType=='Credit Card' ) && !renCCMsg ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select Credit Card')); 
            isError = true;
        }
        
    //    if(delDate=='' || delDate==null ){
   //         ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select delivery date'));   
   //         isError = true;
  //      }
        if(setTempId.size()<temp_int){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'A Product cannot have same configuration in a single order'));   
            isError = true;
        }
                  system.debug('isError--> ' + isError );
        
        if(!isError){
//renSubstitute = false;
        renDelivery = true;
        renLoading = true;
            payType = paymentType!=null?paymentType:payType;
        
        lstSerializeCalender = new List<SerializeCalenderAPI>();
        objSerializeOrder = new SerializeCalenderAPI();
            
        lstQuoteLine = new List<SBQQ__QuoteLine__c>();        
        lstQuoteLineAll = new List<SBQQ__QuoteLine__c>();        
        lstQuoteLineProd = new List<SBQQ__QuoteLine__c>();        
        setDate = new Set<String>();

        List<SBQQ__Quote__c>lstQuote = new List<SBQQ__Quote__c>();
        lstQuote = [SELECT Id, Name, SBQQ__Account__c, Delivery_Charge__c, Delivery_Discount__c, Purchase_Number__c, SBQQ__Primary__c, 
                        SBQQ__ShippingStreet__c, SBQQ__ShippingPostalCode__c, SBQQ__ShippingCity__c, SBQQ__ShippingState__c , 
                        County_Name__c, County_Code__c, GeoCode__c, SBQQ__Account__r.NewTerritory__c, 
                        SBQQ__Account__r.Pricing_Tier__c, SBQQ__Account__r.Price_List_Type__c, SBQQ__Account__r.SCO_Account_ID__c, SBQQ__Account__r.Territory_ID__c,
                        SBQQ__PrimaryContact__r.FirstName, SBQQ__PrimaryContact__r.LastName, //SBQQ__PrimaryContact__r.Email, SBQQ__PrimaryContact__r.Phone, 
                        Delivery_Contact__r.FirstName, Delivery_Contact__r.LastName, Delivery_Contact__r.Email, Delivery_Contact__r.Phone
                    FROM SBQQ__Quote__c 
                    WHERE Id =: quoteId LIMIT 1
                   ];
        
        system.debug('lstQuote[0].Purchase_Number__c--> ' + lstQuote[0].Purchase_Number__c );
        system.debug('lstQuote[0].SBQQ__ShippingStreet__c--> ' + lstQuote[0].SBQQ__ShippingStreet__c );
        system.debug('lstQuote[0].SBQQ__ShippingPostalCode__c--> ' + lstQuote[0].SBQQ__ShippingPostalCode__c );
        system.debug('lstQuote[0].SBQQ__ShippingCity__c--> ' + lstQuote[0].SBQQ__ShippingCity__c );
        system.debug('lstQuote[0].SBQQ__ShippingState__c--> ' + lstQuote[0].SBQQ__ShippingState__c );
        system.debug('lstQuote[0].County_Name__c--> ' + lstQuote[0].County_Name__c );
        system.debug('lstQuote[0].County_Code__c--> ' + lstQuote[0].County_Code__c );
        system.debug('lstQuote[0].GeoCode__c--> ' + lstQuote[0].GeoCode__c );
        system.debug('lstQuote[0].SBQQ__Account__r.SCO_Account_ID__c--> ' + lstQuote[0].SBQQ__Account__r.SCO_Account_ID__c );
        system.debug('lstQuote[0].SBQQ__Account__r.Territory_ID__c--> ' + lstQuote[0].SBQQ__Account__r.Territory_ID__c );
        system.debug('lstQuote[0].SBQQ__Account__r.NewTerritory__c--> ' + lstQuote[0].SBQQ__Account__r.NewTerritory__c );
        system.debug('lstQuote[0].SBQQ__PrimaryContact__r.FirstName--> ' + lstQuote[0].SBQQ__PrimaryContact__r.FirstName );
        system.debug('lstQuote[0].SBQQ__PrimaryContact__r.LastName--> ' + lstQuote[0].SBQQ__PrimaryContact__r.LastName );
    //    system.debug('lstQuote[0].SBQQ__PrimaryContact__r.Email--> ' + lstQuote[0].SBQQ__PrimaryContact__r.Email );
    //    system.debug('lstQuote[0].SBQQ__PrimaryContact__r.Phone--> ' + lstQuote[0].SBQQ__PrimaryContact__r.Phone );
        system.debug('lstQuote[0].Delivery_Contact__r.FirstName--> ' + lstQuote[0].Delivery_Contact__r.FirstName );
        system.debug('lstQuote[0].Delivery_Contact__r.LastName--> ' + lstQuote[0].Delivery_Contact__r.LastName );
        system.debug('lstQuote[0].Delivery_Contact__r.Email--> ' + lstQuote[0].Delivery_Contact__r.Email );
        system.debug('lstQuote[0].Delivery_Contact__r.Phone--> ' + lstQuote[0].Delivery_Contact__r.Phone );
        system.debug('lstQuote[[0].Name--> ' + lstQuote[0].Name );
            
            
        if(lstQuote.size()>0){
            isQuotePrimary = lstQuote[0].SBQQ__Primary__c;
            if(lstQuote[0].Purchase_Number__c!=null 
               && lstQuote[0].SBQQ__ShippingStreet__c!= null 
               && lstQuote[0].SBQQ__ShippingPostalCode__c!= null 
               && lstQuote[0].SBQQ__ShippingCity__c!= null 
               && lstQuote[0].SBQQ__ShippingState__c!= null 
               && lstQuote[0].County_Name__c!= null 
               && lstQuote[0].County_Code__c!= null 
               && lstQuote[0].GeoCode__c!= null 
               && lstQuote[0].SBQQ__Account__r.SCO_Account_ID__c!= null 
       //        && lstQuote[0].SBQQ__Account__r.Territory_ID__c!= null 
               && lstQuote[0].SBQQ__Account__r.NewTerritory__c!= null 
               && lstQuote[0].SBQQ__PrimaryContact__r.FirstName!= null 
               && lstQuote[0].SBQQ__PrimaryContact__r.LastName!= null 
       //        && lstQuote[0].SBQQ__PrimaryContact__r.Email!= null 
       //        && lstQuote[0].SBQQ__PrimaryContact__r.Phone!= null 
               && lstQuote[0].Delivery_Contact__r.FirstName!= null 
               && lstQuote[0].Delivery_Contact__r.LastName!= null 
               && lstQuote[0].Delivery_Contact__r.Email!= null 
               && lstQuote[0].Delivery_Contact__r.Phone!= null 
               && lstQuote[0].Name!=null 
              ){
                
                  accountId = lstQuote[0].SBQQ__Account__c;
              //    deliverycharge = Double.valueof(lstQuote[0].Delivery_Charge__c>0?lstQuote[0].Delivery_Charge__c:0 - lstQuote[0].Delivery_Discount__c>0?lstQuote[0].Delivery_Discount__c:0 ) ;
                  deliverycharge = Double.valueof(lstQuote[0].Delivery_Charge__c!=null?lstQuote[0].Delivery_Charge__c:0 - lstQuote[0].Delivery_Discount__c!=null?lstQuote[0].Delivery_Discount__c:0 ) ;
                  purchasenumber = lstQuote[0].Purchase_Number__c;
            //      territory_id = lstQuote[0].SBQQ__Account__r.Territory_ID__c;
                  
                  
        List<Territory__c> lstTerritory = new List<Territory__c>();
        lstTerritory = [SELECT Id, Name, Territory_ID__c, District_Territory_ID__c 
                        FROM Territory__c 
                //        WHERE Territory_ID__c =: lstQuote[0].SBQQ__Account__r.Territory_ID__c 
                        WHERE Id =: lstQuote[0].SBQQ__Account__r.NewTerritory__c 
                        ORDER BY Id DESC
                        LIMIT 1
                       ];
            if(lstTerritory.size()>0){
                territory_id = lstTerritory[0].Territory_ID__c;
                district_id = lstTerritory[0].District_Territory_ID__c;
            }
            
                                    
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
                  
                  objSerializeCalender.order_reference_number = 'SF_' + ordertype + '_' + lstQuote[0].Name.replaceFirst( '^0+', '') + '_SF_'  + str_dt ;
                  orderreferencenumber = objSerializeCalender.order_reference_number;
                  objSerializeCalender.purchase_order_number = lstQuote[0].Purchase_Number__c ;
                  objSerializeCalender.account_number = lstQuote[0].SBQQ__Account__r.SCO_Account_ID__c ;
                  Double dlv_charge = 0;
                  Double dlv_discount = 0;
                  if(lstQuote[0].Delivery_Charge__c!=null && Double.valueof(lstQuote[0].Delivery_Charge__c)!=0 ){
                      dlv_charge = Double.valueof(lstQuote[0].Delivery_Charge__c);
                  }
                  if(lstQuote[0].Delivery_Discount__c!=null && Double.valueof(lstQuote[0].Delivery_Discount__c)!=0 ){
                      dlv_discount = Double.valueof(lstQuote[0].Delivery_Discount__c);
                  }
                  objSerializeCalender.delivery_charge = dlv_charge - dlv_discount ;
                  objSerializeCalender.delivery_tax = 0;
                  objSerializeCalender.district_id = district_id;
                  objSerializeCalender.territory_id = territory_id;
                  
            system.debug('selectedAddressType--> ' + selectedAddressType );
            system.debug('mapCCALocations.get(CCA_Location)--> ' + mapCCALocations.get(CCA_Location) );
            system.debug('selectedPickupStore--> ' + selectedPickupStore );
            system.debug('pu_firstname--> ' + pu_firstname );
            system.debug('pu_lastname--> ' + pu_lastname );
            system.debug('pu_email--> ' + pu_email );
            system.debug('pu_phone--> ' + pu_phone );
                  
                  
                  
                  if(mapCCALocations.get(CCA_Location)!=null && selectedAddressType!='Store Pickup' ){
                      objSerializeCalender.location_number = mapCCALocations.get(CCA_Location);
                  }
                  system.debug('objSerializeCalender.location_number--> ' + objSerializeCalender.location_number );
                  if(selectedAddressType!='Store Pickup'){
                  SerializeCalenderAPI.Shipping_address objShippingInfo = new SerializeCalenderAPI.Shipping_address();
                  objShippingInfo.address_line_1=lstQuote[0].SBQQ__ShippingStreet__c;
                  objShippingInfo.address_line_2='';
                  objShippingInfo.zip=lstQuote[0].SBQQ__ShippingPostalCode__c;
                  objShippingInfo.city=lstQuote[0].SBQQ__ShippingCity__c;
                  objShippingInfo.state=lstQuote[0].SBQQ__ShippingState__c;
                  objShippingInfo.county=lstQuote[0].County_Name__c;
                  objShippingInfo.county_code=lstQuote[0].County_Code__c;
                  objShippingInfo.geo_code=lstQuote[0].GeoCode__c;
       //           objShippingInfo.first_name=lstQuote[0].SBQQ__PrimaryContact__r.FirstName;
      //            objShippingInfo.last_name=lstQuote[0].SBQQ__PrimaryContact__r.LastName;
       //           objShippingInfo.email=lstQuote[0].SBQQ__PrimaryContact__r.Email;
       //           objShippingInfo.phone=lstQuote[0].SBQQ__PrimaryContact__r.Phone;
                  objShippingInfo.first_name=lstQuote[0].Delivery_Contact__r.FirstName;
                  objShippingInfo.last_name=lstQuote[0].Delivery_Contact__r.LastName;
                  objShippingInfo.email=lstQuote[0].Delivery_Contact__r.Email;
                  objShippingInfo.phone=lstQuote[0].Delivery_Contact__r.Phone.replaceAll('\\D','');
                      objSerializeCalender.shipping_address = objShippingInfo;
                  }else{
                      SerializeCalenderAPI.Pickup_detail objPickupInfo = new SerializeCalenderAPI.Pickup_detail();
                      objPickupInfo.facility_number = selectedPickupStore;
                      SerializeCalenderAPI.Pickup_customer objCustomer = new SerializeCalenderAPI.Pickup_customer();
                      objCustomer.first_name  = pu_firstname;
                      objCustomer.last_name  = pu_lastname;
                      objCustomer.email  = pu_email;
                      objCustomer.day_phone  = pu_phone;
                      objPickupInfo.pickup_customer = objCustomer;
                      objSerializeCalender.pickup_detail = objPickupInfo;
                  }

                  SerializeCalenderAPI.Payment_method objPaymentMethod = new SerializeCalenderAPI.Payment_method();
                  if(paymentType=='Credit Card' || payType=='Credit Card' ){
                      objPaymentMethod.type='CC';
                      if(selectedCreditCard!=null){
                          objPaymentMethod.uid=selectedCreditCard;
                      }
                      objSerializeCalender.payment_method = objPaymentMethod;
                  }else if(paymentType=='Credit Account' || payType=='Credit Account'){
                      objPaymentMethod.type='AR';
                      objPaymentMethod.authorized_purchaser= lstQuote[0].SBQQ__PrimaryContact__r.FirstName + ' ' + lstQuote[0].SBQQ__PrimaryContact__r.LastName;
             //         objPaymentMethod.authorized_purchaser= lstQuote[0].Delivery_Contact__r.FirstName + ' ' + lstQuote[0].Delivery_Contact__r.LastName;
                      objSerializeCalender.payment_method = objPaymentMethod;
                  }else if(paymentType=='Check' || payType=='Check'){
                      objPaymentMethod.type='AR';
             //         objPaymentMethod.authorized_purchaser= lstQuote[0].SBQQ__PrimaryContact__r.FirstName + ' ' + lstQuote[0].SBQQ__PrimaryContact__r.LastName;
             //         objPaymentMethod.authorized_purchaser= lstQuote[0].Delivery_Contact__r.FirstName + ' ' + lstQuote[0].Delivery_Contact__r.LastName;
                      objPaymentMethod.authorized_purchaser= 'Check';
                      objSerializeCalender.payment_method = objPaymentMethod;
                  }
                  System.debug('objSerializeCalender.payment_method ' + objSerializeCalender.payment_method);
                  List<SerializeCalenderAPI.Line_items> lstLineItems = new List<SerializeCalenderAPI.Line_items>();
                
                  lstQuoteLineAll = new List<SBQQ__QuoteLine__c>();
                  
                  lstQuoteLineAll = [SELECT Id, Name, SBQQ__Product__c, SBQQ__Product__r.Name, SBQQ__Product__r.ProductCode, SBQQ__Quantity__c, 
                                        Available__c, Available_Quantity__c, Earliest_Available_Date__c, PA_API_Message__c, 
                                        List_Price__c, Net_Unit_Price__c, Net_Total_Price__c, Tax_Rate__c, Tax__c, Total_Tax_Amount__c, Disposable_Fee__c, 
                                        SBQQ__Number__c, isProductParent__c, ProductParentUnique__c, Feature__c 
                                     FROM SBQQ__QuoteLine__c 
                                     WHERE SBQQ__Quote__c=:quoteId //AND isProductParent__c=true
                                     ORDER BY SBQQ__Number__c
                                    ];
                  
                  
                  
                  
                  
                  Map<String, List<SBQQ__QuoteLine__c>> mapFeatureQuoteLine = new Map<String, List<SBQQ__QuoteLine__c>>();
                  List<SBQQ__QuoteLine__c> lstTempQL = new List<SBQQ__QuoteLine__c>();
                  for(SBQQ__QuoteLine__c q:lstQuoteLineAll){
                    
                      if(q.Feature__c!=null){
                          lstTempQL = new List<SBQQ__QuoteLine__c>();
                          if(mapFeatureQuoteLine.keySet().contains(q.ProductParentUnique__c + q.Feature__c )){
                              lstTempQL.addAll(mapFeatureQuoteLine.get(q.ProductParentUnique__c + q.Feature__c));
                          }else{
                              mapFeatureQuoteLine.put(q.ProductParentUnique__c + q.Feature__c, lstTempQL);
                          }
                          lstTempQL.add(q);
                          
                          mapFeatureQuoteLine.put(q.ProductParentUnique__c + q.Feature__c, lstTempQL);
                      }
                      
                  }     
                  
                  system.debug('mapFeatureQuoteLine--> ' + mapFeatureQuoteLine );
                  
                  lstQuoteLine = new List<SBQQ__QuoteLine__c>();
                  
                  lstQuoteLine = [SELECT Id, Name, SBQQ__Product__c, SBQQ__Product__r.Name, SBQQ__Product__r.ProductCode, SBQQ__Quantity__c, 
                                  Available__c, Available_Quantity__c, Earliest_Available_Date__c, PA_API_Message__c, 
                                  List_Price__c, Net_Unit_Price__c, Net_Total_Price__c, Tax_Rate__c, Tax__c, Total_Tax_Amount__c, 
                                  SBQQ__Number__c, isProductParent__c, ProductParentUnique__c, Feature__c, SBQQ__Product__r.Fulfillment_Channel__c 
                                  FROM SBQQ__QuoteLine__c 
                                  WHERE SBQQ__Quote__c=:quoteId AND isProductParent__c=true
                                  ORDER BY SBQQ__Number__c
                                 ];
                  
                  
                  for(SBQQ__QuoteLine__c ql:lstQuoteLine){
                      
            
                      SerializeCalenderAPI.Line_items objLineItems = new SerializeCalenderAPI.Line_items();
                      objLineItems.item_id = ql.SBQQ__Product__r.ProductCode;
                      objLineItems.price = double.valueof(ql.Net_Unit_Price__c);
                      objLineItems.quantity = integer.valueof(ql.SBQQ__Quantity__c);
                      objLineItems.tax = double.valueof(ql.Tax__c);
                      if(ql.SBQQ__Product__r.Fulfillment_Channel__c=='TW')
                        objLineItems.delivery_eligible = true;
                      
                      
                      if(mapSelectedConfiguration.get(ql.Id)!=null && mapSelectedConfiguration.get(ql.Id)!='' ){
                          SerializeCalenderAPI.Product_configuration objConfig = new SerializeCalenderAPI.Product_configuration();
                          objConfig.item_id  = mapSelectedConfiguration.get(ql.Id);
                          objLineItems.product_configuration = objConfig;
                      }
                      
                      
                      
                      for(String uft:mapFeatureQuoteLine.keyset()){
                          if(uft.contains(ql.ProductParentUnique__c)){
                              if(uft==ql.ProductParentUnique__c+'Parts'){
                                  List<SerializeCalenderAPI.Required_parts> lstRequiredParts = new List<SerializeCalenderAPI.Required_parts>();
                                  SerializeCalenderAPI.Required_parts objRequiredParts = new SerializeCalenderAPI.Required_parts();
                                  for(SBQQ__QuoteLine__c qlf:mapFeatureQuoteLine.get(uft)){
                                      objRequiredParts = new SerializeCalenderAPI.Required_parts();
                                      objRequiredParts.item_id = qlf.SBQQ__Product__r.ProductCode;
                                      objRequiredParts.price = double.valueof(qlf.Net_Unit_Price__c);
                                      objRequiredParts.tax = double.valueof(qlf.Tax__c);
                                      lstRequiredParts.add(objRequiredParts);
                                  }
                                  objLineItems.required_parts = lstRequiredParts;
                              }else if(uft==ql.ProductParentUnique__c+'Services'){
                                  SerializeCalenderAPI.Delivery_service objDeliveryService = new SerializeCalenderAPI.Delivery_service();
                                  SerializeCalenderAPI.Haulaway objHaulAway = new SerializeCalenderAPI.Haulaway();
                                  for(SBQQ__QuoteLine__c qlf:mapFeatureQuoteLine.get(uft)){
                                      if(qlf.SBQQ__Product__r.ProductCode=='haulawayRequested'){
                                          objHaulAway = new SerializeCalenderAPI.Haulaway();
                                          objHaulAway.price = double.valueof(qlf.Net_Unit_Price__c);
                                          objHaulAway.tax = double.valueof(qlf.Tax__c);
                                          objLineItems.haulaway = objHaulAway;
                                      }else{
                                          objDeliveryService = new SerializeCalenderAPI.Delivery_service();
                                          objDeliveryService.price = double.valueof(qlf.Net_Unit_Price__c);
                                          objDeliveryService.tax = double.valueof(qlf.Tax__c);
                                          if(qlf.SBQQ__Product__r.ProductCode.startsWith('01') || qlf.SBQQ__Product__r.ProductCode.startsWith('4') ){
                                              objDeliveryService.item_id = 'install_J';
                                              objDeliveryService.install_service_pid = qlf.SBQQ__Product__r.ProductCode;
                                          }else{
                                              objDeliveryService.item_id = qlf.SBQQ__Product__r.ProductCode;
                                              objDeliveryService.install_service_pid = '';
                                          }
                                          objLineItems.delivery_service = objDeliveryService;
                                      }
                                  
                                          
                                  }
                              }
                          }
                      }
/*
                                  List<SerializeCalenderAPI.Required_parts> lstRequiredParts = new List<SerializeCalenderAPI.Required_parts>();
                                  SerializeCalenderAPI.Required_parts objRequiredParts = new SerializeCalenderAPI.Required_parts();
                                      objRequiredParts.item_id = '02213000000';
                                      objRequiredParts.price = 19.99;
                                      objRequiredParts.tax = 2;
                                      lstRequiredParts.add(objRequiredParts);
                                  objLineItems.required_parts = lstRequiredParts;
                      
                                  SerializeCalenderAPI.Haulaway objHaulAway = new SerializeCalenderAPI.Haulaway();
                                          objHaulAway.price = 15;
                                          objHaulAway.tax = 1.5;
                                          objLineItems.haulaway = objHaulAway;
                      
                                  SerializeCalenderAPI.Delivery_service objDeliveryService = new SerializeCalenderAPI.Delivery_service();
                                          objDeliveryService.price = 0.0;//69.99;
                                          objDeliveryService.tax = 0.0;//7;
                                              objDeliveryService.item_id = 'install_J';
                                              objDeliveryService.install_service_pid = '01022100000';
                                        //      objDeliveryService.item_id = 'brownbox_10';
                                        //      objDeliveryService.install_service_pid = '';
                                          objLineItems.delivery_service = objDeliveryService;

                      */
                      lstLineItems.add(objLineItems);
                  }
                  
                  objSerializeCalender.line_items = lstLineItems; 
                  lstSerializeCalender.add(objSerializeCalender);
                  system.debug('lstSerializeCalender--> ' + lstSerializeCalender );
                  
              //    String JSONString_calender = JSON.serialize(lstSerializeCalender);
                  String JSONString_calender = JSON.serialize(objSerializeCalender);
                  System.debug('Serialized  JSON format: ' + JSONString_calender);
                  
              //    JSONString_calender='{ "order_reference_number": "SF_CONTRACT_12350", "purchase_order_number": "1235", "account_number": "1100000007", "shipping_address": { "address_line_1": "1 N Dearborn St", "address_line_2": "Suite 400", "zip": "60602", "city": "Chicago", "state": "IL", "county": "cook", "first_name": "Silpa", "last_name": "yerra", "email": "asss@sample.com", "phone": "1234567890" } , "delivery_charge": 79.00, "delivery_tax": 3.89, "payment_method": { "type": "CC" } , "line_items": [ { "item_id": "04601332000", "price": 949.99, "quantity": 2, "tax": 75.99, "delivery_service": { "item_id": "brownbox_10", "install_service_pid":"", "price": 10, "tax": 1.60 } , "required_parts": [ { "item_id": "04649599000", "price": 18.99, "tax": 1.54 } ], "product_configuration": { "item_id": "20" } , "protection_agreement": { "item_id": "PA_123", "price": 149.99, "tax": 15.96 } , "haulaway": { "price": 25.00, "tax": 2.00 } } ] }';
                  
    
                  String preferred_del_dt = selectedStartDate.month() + '-' + selectedStartDate.day() + '-' + selectedStartDate.year();
                  system.debug('preferred_del_dt--> ' + preferred_del_dt );
                  
                  Map<String, Common_Variables__c> mapCV = Common_Variables__c.getAll();
             //     String EndpointUrl = mapCV.get('B2BProd_Calender').Content__c;
             //     String EndpointUrl = 'https://scoapp301p.dev.ch3.s.com:2143/api/rest/delivery-dates';
             //     String EndpointUrl = 'https://KenmoreDirTRIAL331001.jitterbit.net/JitterbitDev/showCalendarApi';
             //     String EndpointUrl = mapCV.get('B2BProd_Delivery_Dates_URL').Content__c + '?preferred_delivery_date=' + string.valueof(selectedStartDate);
                  String EndpointUrl = mapCV.get('B2BProd_Delivery_Dates_URL').Content__c + '?preferred_delivery_date=' + preferred_del_dt;
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
        lstQuoteBEMSuccess222 = [SELECT Id, Name, B2B_Order_Error_Message__c, Order_API_Request__c, B2B_Order_Error_Message_Appended__c, Order_Reference_Number__c FROM SBQQ__Quote__c WHERE Id =: quoteId LIMIT 1];
            
            for(SBQQ__Quote__c qb:lstQuoteBEMSuccess222){
                qb.B2B_Order_Error_Message__c = (RW.message!=null?string.valueof(RW.message):'') + (RW.Response!=null?string.valueof(RW.Response):'');
                qb.Order_API_Request__c = JSONString_calender ;
                
                if(qb.Order_API_Request__c!=null && qb.Order_API_Request__c!='' ){
                    qb.Order_Reference_Number__c = qb.Order_API_Request__c.substringBetween(',"order_reference_number":"', '",')!=null?qb.Order_API_Request__c.substringBetween(',"order_reference_number":"', '",'):'';
                }else{
                    qb.Order_Reference_Number__c = '';
                }
                
                if(qb.B2B_Order_Error_Message__c!=null && qb.B2B_Order_Error_Message__c!='' ){
                    if(qb.B2B_Order_Error_Message__c.length()>254){
                        qb.B2B_Order_Error_Message_Appended__c = qb.B2B_Order_Error_Message__c.substring(0, 254);
                    }else{
                        qb.B2B_Order_Error_Message_Appended__c = qb.B2B_Order_Error_Message__c;
                    }
                }else{
                    qb.B2B_Order_Error_Message_Appended__c = '';
                }
                
            }
            system.debug('lstQuoteBEMSuccess222-->' + lstQuoteBEMSuccess222 );
            update lstQuoteBEMSuccess222;
            system.debug('lstQuoteBEMSuccess222-->' + lstQuoteBEMSuccess222 );
                  
            //      if(1==1){
                  
                  if((RW.message == '' && RW.Response != null) || Test.isRunningTest() ){
                      system.debug('API response success');
                      
                      string resdoc = '';
                      
                      if(!Test.isRunningTest()){
                          system.debug('RW.Response--> ' + RW.Response );
                      //    response = http.send(request);
                      //    resdoc = response.getBody();
                          resdoc = RW.Response.getBody();
                      }else{
                   //       resdoc = '{ "order_reference_number": "SF_CONTRACT_12302", "delivery_dates": [ { "date": "12-01-2019" }, { "date": "12-02-2019" }, { "date": "12-03-2019" }, { "date": "12-04-2019" }, { "date": "12-05-2019" }, { "date": "12-06-2019" }, { "date": "12-07-2019" }, { "date": "12-08-2019" }, { "date": "12-09-2019" }, { "date": "12-10-2019" }, { "date": "12-11-2019" }, { "date": "12-12-2019" }, { "date": "12-13-2019" }, { "date": "12-14-2019" }, { "date": "12-15-2019" }, { "date": "12-16-2019" }, { "date": "12-17-2019" }, { "date": "12-18-2019" }, { "date": "12-19-2019" }, { "date": "12-20-2019" }, { "date": "12-21-2019" } ] }';
                          resdoc = '{ "order_reference_number": "SF_CONTRACT_12302", "delivery_dates": [ { "date": "12-01-2020" }, { "date": "12-02-2020" }, { "date": "12-03-2020" }, { "date": "12-04-2020" }, { "date": "12-05-2020" }, { "date": "12-06-2020" }, { "date": "12-07-2020" }, { "date": "12-08-2020" }, { "date": "12-09-2020" }, { "date": "12-10-2020" }, { "date": "12-11-2020" }, { "date": "12-12-2020" }, { "date": "12-13-2020" }, { "date": "12-14-2020" }, { "date": "12-15-2020" }, { "date": "12-16-2020" }, { "date": "12-17-2020" }, { "date": "12-18-2020" }, { "date": "12-19-2020" }, { "date": "12-20-2020" }, { "date": "12-21-2020" } ] }';
                      }
            
               //         resdoc = '{ "order_reference_number": "SF_Order_Reference_Number", "delivery_dates": [ { "date": "12-01-2019" }, { "date": "12-02-2019" }, { "date": "12-03-2019" }, { "date": "12-04-2019" }, { "date": "12-05-2019" }, { "date": "12-06-2019" }, { "date": "12-07-2019" }, { "date": "12-08-2019" }, { "date": "12-09-2019" }, { "date": "12-10-2019" }, { "date": "12-11-2019" }, { "date": "12-12-2019" }, { "date": "12-13-2019" }, { "date": "12-14-2019" }, { "date": "12-15-2019" }, { "date": "12-16-2019" }, { "date": "12-17-2019" }, { "date": "12-18-2019" }, { "date": "12-19-2019" }, { "date": "12-20-2019" }, { "date": "12-21-2019" } ] }';
                      
                      system.debug('resdoc:' +resdoc);
                      
                      
               //       resdoc = resdoc.replace('SF_Order_Reference_Number', orderreferencenumber);
                      
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
                      system.debug('str_date:' +str_date);
                      
        
                      
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
                  if(lstQuote[0].SBQQ__ShippingStreet__c== null){
                      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Missing Quote Shipping Street Address' ));
                  }
                  if(lstQuote[0].SBQQ__ShippingPostalCode__c== null){
                      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Missing Quote Shipping Zip Code' ));
                  }
                  if(lstQuote[0].SBQQ__ShippingCity__c== null){
                      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Missing Quote Shipping City' ));
                  }
                  if(lstQuote[0].SBQQ__ShippingState__c== null){
                      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Missing Quote Shipping State' ));
                  }
                  if(lstQuote[0].County_Name__c== null){
                      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Missing Quote Shipping County Name' ));
                  }
                  if(lstQuote[0].County_Code__c== null){
                      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Missing Quote Shipping County Code' ));
                  }
                  if(lstQuote[0].SBQQ__Account__r.SCO_Account_ID__c== null){
                      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Missing SCO Account Id' ));
                  }
          //        if(lstQuote[0].SBQQ__Account__r.Territory_ID__c== null){
          //            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Missing Account Territory' ));
          //        }
                  if(lstQuote[0].SBQQ__Account__r.NewTerritory__c== null){
                      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Missing Account Territory' ));
                  }
                  if(lstQuote[0].SBQQ__PrimaryContact__r.FirstName== null){
                      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Missing Primary Contact First Name' ));
                  }
                  if(lstQuote[0].SBQQ__PrimaryContact__r.LastName== null){
                      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Missing Primary Contact Last Name' ));
                  }
                  if(lstQuote[0].Delivery_Contact__r.FirstName== null){
                      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Missing Delivery Contact First Name' ));
                  }
                  if(lstQuote[0].Delivery_Contact__r.LastName== null){
                      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Missing Delivery Contact Last Name' ));
                  }
                  if(lstQuote[0].Delivery_Contact__r.Email== null){
                      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Missing Delivery Contact Email' ));
                  }
                  if(lstQuote[0].Delivery_Contact__r.Phone== null){
                      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Missing Delivery Contact Phone' ));
                  }
                  
              }
            
            
        }
                  
        return null;
        }else{
        renDelivery = false;
        renLoading = false;
            return null;  
        }
        
    }
    
    
    
    
    public list<selectoption> getPaymentMethod()
    {
        list<selectoption> lstSel= new list<selectoption>();
        lstSel.add(new SelectOption('', '--None--'));            
        lstSel.add(new SelectOption('Credit Card', 'Credit Card'));   
        lstSel.add(new SelectOption('Check', 'Check'));   
        lstSel.add(new SelectOption('Credit Account', 'Credit Account'));            
        return lstSel;
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
        
        renCCMsg = false;
        
            system.debug('mapSelectedConfiguration--> ' + mapSelectedConfiguration );
        
        
        for(String sq:mapSelectedConfiguration.keySet()){
            if(mapSelectedConfiguration.get(sq)==null){
                mapSelectedConfiguration.put(sq, '');
            }
        }
        
            system.debug('mapSelectedConfiguration--> ' + mapSelectedConfiguration );
        
        system.debug('paymentType--> ' + paymentType );
        system.debug('selectedCreditCard--> ' + selectedCreditCard );
        
        if(paymentType==null){
            paymentType = '';
        }
        if(selectedCreditCard==null || paymentType!='Credit Card' ){
            selectedCreditCard = '';
        }
        
        system.debug('paymentType--> ' + paymentType );
        system.debug('selectedCreditCard--> ' + selectedCreditCard );
        
        lstCreditCards = new List<String>();
        mapUID = new Map<String, String>();
        if(paymentType=='Credit Card'){
            
      //      https://api.b2b.sears.com/api/kd/rest/payment_options/{account_number}
      //      https://scoapp301p.dev.ch3.s.com:2253/admin
      //      https://scoapp301p.dev.ch3.s.com:2243/api/rest/payment_options/1100000007
                //     String CS_CLIENT_ID = mapCV.get('B2BProd_KD_ClientId').Content__c;
                //     
        Map<String, Common_Variables__c> mapCV = Common_Variables__c.getAll();
    //        String CS_Authorization = mapCV.get('Adjustment_Payment_Auth').Content__c;
    //        String CS_LDAP_USER = mapCV.get('Adjustment_Payment_LDAP_User').Content__c;
                //     
        String EndpointUrl_CC = mapCV.get('Adjustment_Payment_API').Content__c;
    //        EndpointUrl_CC = 'https://KenmoreDirTRIAL331001.jitterbit.net/kd/rest/payment_options/';

    //        String CS_CLIENT_ID = mapCV.get('Order_Detail_Client_Id').Content__c;
    //        String CS_CLIENT_SECRET = mapCV.get('Order_Detail_Client_Secret').Content__c;
            String CS_CLIENT_ID = mapCV.get('B2BProd_KD_ClientId').Content__c;
            String CS_CLIENT_SECRET = mapCV.get('B2BProd_KD_ClientSecret').Content__c;
            
            String CS_CONTENT_TYPE = 'application/json';  
    //        EndpointUrl_CC = 'https://api.b2b.sears.com/api/kd/rest/payment_options/';
        EndpointUrl_CC += quoteAccountSCOId ;                
        
      //      EndpointUrl_CC = 'https://api.b2b.sears.com/api/kd/rest/payment_options/1100141933';
      //      EndpointUrl_CC = 'https://api.b2b.sears.com/api/kd/rest/payment_options/0010038976';
            
        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        Http http = new Http();
        
        
        request.setMethod('GET');
            
    //    request.setHeader('Authorization', 'eyJhbGciOiJSUzI1NiJ9.eyJuYW1lIjoiU0NPX0NvbXBhbnkiLCJzYW5kYm94IjpmYWxzZX0.GFuPwz1OwoB8y7cb12h0iSsTsl5la2ltMofdSZyHjjSBWi5SPv2mByCmtZroN1hax1GHs7AOlQqzlKGOVg_r_2728sY7XpEkwpb9omo3t4H4Q0LxZkvusEM9tz9XMMEBfhl_IAvAwgCYlyYpB-Z5Ewt1wVkVvI-dwJIS6HvghV4nyySMGCC632dB9zsIgwpKjfozWVFxIamq0mOhviJwbdqi55BiHpNvukESbzNx8Yqqu1M7q3ePl0TRwfOaoG1E-jZZZ_naZV6hCZgPyB1U8J8GisWHz7kqTQAjreQjMKFA6YShgdI4LOXsEADtXN2mU9iliasGDpRn-ZtSXuYl5w');
    //    request.setHeader('LDAP_USER_ID', 'akuma35');
    //    request.setHeader('Authorization', CS_Authorization);
    //    request.setHeader('LDAP_USER_ID', CS_LDAP_USER);
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
            renCCMsg = false;
            
        if((RW.message == '' && RW.Response != null) || Test.isRunningTest() ){
   //     if(1==1 ){
            system.debug('API response success');
            
            
            if(!Test.isRunningTest()){
       //     if(!Test.isRunningTest() || (RW.message == '' && RW.Response != null) ){
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
            
                    
            renCCMsg = true;
            for(DeserializePaymentOptionsAPI.CreditCards occ:lstCreditCardsAll){
                renCCMsg = false;
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
        system.debug('renCCMsg--> ' + renCCMsg );
        
        return null;
    }
    
    public PageReference actionCreditCardPayment(){
        
            system.debug('mapSelectedConfiguration--> ' + mapSelectedConfiguration );
        
        
        for(String sq:mapSelectedConfiguration.keySet()){
            if(mapSelectedConfiguration.get(sq)==null){
                mapSelectedConfiguration.put(sq, '');
            }
        }
        
            system.debug('mapSelectedConfiguration--> ' + mapSelectedConfiguration );
        
        system.debug('paymentType--> ' + paymentType );
        system.debug('selectedCreditCard--> ' + selectedCreditCard );
        
        if(paymentType==null){
            paymentType = '';
        }
        if(selectedCreditCard==null || paymentType!='Credit Card' ){
            selectedCreditCard = '';
        }
        
        system.debug('paymentType--> ' + paymentType );
        system.debug('selectedCreditCard--> ' + selectedCreditCard );
        
        
        return null;
    }
    
    
    public PageReference actionSend(){
        system.debug('paymentType--> ' + paymentType );
        system.debug('delDate--> ' + delDate );
        Boolean isError = false;
        
        if(delNote==null ){
            delNote = '';
        }
        if(delDate=='' || delDate==null ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select delivery date'));   
            isError = true;
        }
        if(!isError){
            actionSendOrderAPI();  
       //     if(b2bOrderErrorMessage==''){
            if(!renOrderCreateError){
        String orderId = '';
        List<Order> lstOrderInsert = new List<Order>();
        Order objOrderInsert = new Order();
     //   system.debug('lstOrderSelection--> ' + lstOrderSelection );
        
         //   objOrderInsert.SBQQ__Contracted__c = true;
         //   objOrderInsert.ContractId = contractId;
            objOrderInsert.SBQQ__Quote__c = quoteId;
        //    objOrderInsert.SBQQ__Contracted__c = false;
            objOrderInsert.AccountId = accountId;
            objOrderInsert.Status = 'Submitted';
            objOrderInsert.EffectiveDate = date.parse(delDate.replace('-', '/'));
            objOrderInsert.Delivery_Date__c = date.parse(delDate.replace('-', '/'));
            objOrderInsert.Delivery_Instruction__c = delNote;
            objOrderInsert.Pricebook2Id='01s300000006uBlAAI';
            objOrderInsert.Payment_Type__c = (payType==null || payType=='')?paymentType:payType;
            objOrderInsert.Delivery_Charge__c=deliverycharge;
            objOrderInsert.Purchase_Number__c=purchasenumber;
            objOrderInsert.Order_Reference_Number__c=orderreferencenumber;
            objOrderInsert.District_Id__c=district_id;
            objOrderInsert.Territory_Id__c=territory_id;
            objOrderInsert.Order_Source__c='Salesforce';
            objOrderInsert.Type='Order';
            objOrderInsert.B2B_Order_Id__c=b2borderid;
            lstOrderInsert.add(objOrderInsert);
        if(isQuotePrimary){
            try{
            insert lstOrderInsert;
                system.debug('lstOrderInsert--> ' + lstOrderInsert );
            List<Order> lstOrderQry = new List<Order>();
            lstOrderQry = [SELECT Id, Name FROM Order WHERE Order_Reference_Number__c=:orderreferencenumber ORDER BY ID DESC LIMIT 1];
            if(lstOrderQry.size()>0){
                orderId = lstOrderQry[0].Id;
                insertorderid = lstOrderQry[0].Id;
                system.debug('orderId--> ' + orderId );
            }
            
        List<OrderItem> lstOrderItemInsert = new List<OrderItem>();
        OrderItem objOrderItemInsert = new OrderItem();
        if(orderId!=''){
            for (SBQQ__QuoteLine__c os:lstQuoteLineAll){
                /*
                                        List_Price__c, Net_Unit_Price__c, Net_Total_Price__c, Tax_Rate__c, Tax__c, Total_Tax_Amount__c, 
                                        SBQQ__Number__c, isProductParent__c, ProductParentUnique__c, Feature__c 
*/
                system.debug('os--> ' + os );
                objOrderItemInsert = new OrderItem();
                objOrderItemInsert.OrderId = orderId;
                objOrderItemInsert.Product2Id = os.SBQQ__Product__c;
                objOrderItemInsert.Quantity = os.SBQQ__Quantity__c;
                objOrderItemInsert.PriceBookEntryId = mapProductPriceBook.get(os.SBQQ__Product__c);
                objOrderItemInsert.Configuration__c = mapSelectedConfiguration.get(os.Id); 
                objOrderItemInsert.Configuration_Description__c = mapConfiguration.get(mapSelectedConfiguration.get(os.Id)); 
                objOrderItemInsert.Delivery_Date__c = date.parse(delDate.replace('-', '/'));
                objOrderItemInsert.Number__c = string.valueof(os.SBQQ__Number__c*10);
                objOrderItemInsert.Feature__c = os.Feature__c;
                objOrderItemInsert.isProductParent__c = os.isProductParent__c;
                objOrderItemInsert.ProductParentUnique__c = os.ProductParentUnique__c;
                objOrderItemInsert.List_Unit_Price__c = double.valueof(os.List_Price__c);
                objOrderItemInsert.Net_Unit_Price__c = double.valueof(os.Net_Unit_Price__c);
                objOrderItemInsert.UnitPrice = double.valueof(os.Net_Unit_Price__c);
                objOrderItemInsert.Disposable_Fee__c = double.valueof(os.Disposable_Fee__c);
                objOrderItemInsert.Order_Reference_Number__c=orderreferencenumber;
           //     objOrderItemInsert.Unique_Value__c=orderreferencenumber + string.valueof(os.SBQQ__Number__c*10) ;
                objOrderItemInsert.Unique_Value__c=orderreferencenumber + os.SBQQ__Product__r.ProductCode ;
                if(!os.isProductParent__c){
                    objOrderItemInsert.Parent_Part_Number__c=mapParentNumber.get(mapParentUnique.get(os.Id));
                    objOrderItemInsert.Unique_Value__c+=mapParentCode.get(mapParentUnique.get(os.Id))  ;
                }
                objOrderItemInsert.Tax_Rate__c = os.Tax_Rate__c!=null?double.valueof(os.Tax_Rate__c*100):0;
                objOrderItemInsert.SBQQ__TaxAmount__c = (((os.Net_Unit_Price__c!=null?double.valueof(os.Net_Unit_Price__c):0)*(os.Tax_Rate__c!=null?double.valueof(os.Tax_Rate__c):0))+(os.Disposable_Fee__c!=null?double.valueof(os.Disposable_Fee__c):0))*(os.SBQQ__Quantity__c!=null?double.valueof(os.SBQQ__Quantity__c):0) ;
                objOrderItemInsert.Item_Tax__c = (((os.Net_Unit_Price__c!=null?double.valueof(os.Net_Unit_Price__c):0)*(os.Tax_Rate__c!=null?double.valueof(os.Tax_Rate__c):0))+(os.Disposable_Fee__c!=null?double.valueof(os.Disposable_Fee__c):0))*(os.SBQQ__Quantity__c!=null?double.valueof(os.SBQQ__Quantity__c):0) ;
      //          objOrderItemInsert.SBQQ__TaxAmount__c = (((os.Net_Unit_Price__c!=null?double.valueof(os.Net_Unit_Price__c):0)*(os.Tax_Rate__c!=null?double.valueof(os.Tax_Rate__c):0))+(os.Disposable_Fee__c!=null?double.valueof(os.Disposable_Fee__c):0)) ;
      //          objOrderItemInsert.Item_Tax__c = (((os.Net_Unit_Price__c!=null?double.valueof(os.Net_Unit_Price__c):0)*(os.Tax_Rate__c!=null?double.valueof(os.Tax_Rate__c):0))+(os.Disposable_Fee__c!=null?double.valueof(os.Disposable_Fee__c):0)) ;
                lstOrderItemInsert.add(objOrderItemInsert);
            }  
            
                      if(!Test.isRunningTest()){
                          insert lstOrderItemInsert;
                      }
            
        
        PageReference retURL = new PageReference('/' + orderId );
        retURL.setRedirect(true);
        return retURL;
            }else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Order not created'));
            return null;  
            }
            }catch(exception e){
                system.debug('err-->' + e.getMessage() );
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
        return null;
            }
        }else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Selected Quote is not Primary. Please meake it primary to create an order.'));
            return null;  
        }
        }else{
            system.debug('b2bOrderErrorMessage-->' + b2bOrderErrorMessage );
        List<SBQQ__Quote__c>lstQuoteBEM = new List<SBQQ__Quote__c>();
        lstQuoteBEM = [SELECT Id, Name, B2B_Order_Error_Message__c, Order_API_Request__c, B2B_Order_Error_Message_Appended__c, Order_Reference_Number__c FROM SBQQ__Quote__c WHERE Id =: quoteId LIMIT 1];
            
            for(SBQQ__Quote__c qb:lstQuoteBEM){
                qb.B2B_Order_Error_Message__c = b2bOrderErrorMessage;
                qb.Order_API_Request__c = orderapirequest;
                
                if(qb.Order_API_Request__c!=null && qb.Order_API_Request__c!='' ){
                    qb.Order_Reference_Number__c = qb.Order_API_Request__c.substringBetween(',"order_reference_number":"', '",')!=null?qb.Order_API_Request__c.substringBetween(',"order_reference_number":"', '",'):'';
                }else{
                    qb.Order_Reference_Number__c = '';
                }
                
                if(qb.B2B_Order_Error_Message__c!=null && qb.B2B_Order_Error_Message__c!='' ){
                    if(qb.B2B_Order_Error_Message__c.length()>254){
                        qb.B2B_Order_Error_Message_Appended__c = qb.B2B_Order_Error_Message__c.substring(0, 254);
                    }else{
                        qb.B2B_Order_Error_Message_Appended__c = qb.B2B_Order_Error_Message__c;
                    }
                }else{
                    qb.B2B_Order_Error_Message_Appended__c = '';
                }
                
            }
            system.debug('lstQuoteBEM-->' + lstQuoteBEM );
            update lstQuoteBEM;
            system.debug('lstQuoteBEM-->' + lstQuoteBEM );
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, b2bOrderErrorMessage));
            return null;  
        } 
            
            
            
            
        }else{
            return null;              
        }
    }
        /*
    public PageReference actionSend(){
        system.debug('paymentType--> ' + paymentType );
        system.debug('delDate--> ' + delDate );
            system.debug('mapSel--> ' + mapSel );
            system.debug('mapSelectedConfiguration--> ' + mapSelectedConfiguration );
        
        Integer temp_int = 0;
        Set<String> setTempId = new Set<String>();
        for(SBQQ__QuoteLine__c qli:lstQuoteLine){
            if(mapSelectedConfiguration.get(qli.Id)!=''){
                temp_int++;
                setTempId.add(qli.SBQQ__Product__c+mapSelectedConfiguration.get(qli.Id));
            }
        }
        Boolean isError = false;
        if((payType == '' || payType == null) && (paymentType=='' || paymentType==null) ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select payment type')); 
            isError = true;
        }
        if(delDate=='' || delDate==null ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select delivery date'));   
            isError = true;
        }
        if(setTempId.size()<temp_int){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'A Product cannot have same configuration in a single order'));   
            isError = true;
        }
        
        
        if(!isError){
   //     PageReference retURL = new PageReference('/' + quoteId );
   //     retURL.setRedirect(true);
    //    return retURL;
   //     return null;
   //     
        String orderId = '';
        List<Order> lstOrderInsert = new List<Order>();
        Order objOrderInsert = new Order();
     //   system.debug('lstOrderSelection--> ' + lstOrderSelection );
        
         //   objOrderInsert.SBQQ__Contracted__c = true;
         //   objOrderInsert.ContractId = contractId;
            objOrderInsert.SBQQ__Quote__c = quoteId;
            objOrderInsert.AccountId = accountId;
            objOrderInsert.Status = 'Submitted';
            objOrderInsert.EffectiveDate = date.valueOf(delDate);
            objOrderInsert.Delivery_Date__c = date.valueOf(delDate);
            objOrderInsert.Pricebook2Id='01s300000006uBlAAI';
            objOrderInsert.Payment_Type__c = (payType==null || payType=='')?paymentType:payType;
            lstOrderInsert.add(objOrderInsert);
        if(isQuotePrimary){
            insert lstOrderInsert;
            List<Order> lstOrderQry = new List<Order>();
            lstOrderQry = [SELECT Id, Name FROM Order ORDER BY ID DESC LIMIT 1];
            if(lstOrderQry.size()>0){
                orderId = lstOrderQry[0].Id;
                system.debug('orderId--> ' + orderId );
            }
            
        List<OrderItem> lstOrderItemInsert = new List<OrderItem>();
        OrderItem objOrderItemInsert = new OrderItem();
        if(orderId!=''){
            for (SBQQ__QuoteLine__c os:lstQuoteLine){
                system.debug('os--> ' + os );
                objOrderItemInsert = new OrderItem();
                objOrderItemInsert.OrderId = orderId;
                objOrderItemInsert.Product2Id = os.SBQQ__Product__c;
                objOrderItemInsert.Quantity = os.SBQQ__Quantity__c;
                objOrderItemInsert.PriceBookEntryId = mapProductPriceBook.get(os.SBQQ__Product__c);
                objOrderItemInsert.Configuration__c = mapSelectedConfiguration.get(os.Id); 
                objOrderItemInsert.Configuration_Description__c = mapConfiguration.get(mapSelectedConfiguration.get(os.Id)); 
            //    objOrderItemInsert.ListPrice = 500;
                objOrderItemInsert.UnitPrice = os.SBQQ__NetTotal__c;
         //       objOrderItemInsert.SBQQ__BookingsIndicator__c = 'Do Not Include';
                lstOrderItemInsert.add(objOrderItemInsert);
            } 
            insert lstOrderItemInsert;
        }
        
        PageReference retURL = new PageReference('/' + orderId );
        retURL.setRedirect(true);
        return retURL;
            
        }else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Selected Quote is not Primary. Please meake it primary to create an order.'));
            return null;  
        }
        
        }else{
            return null;  
        }
   //     
   //     
   //     
    }
    */
    
    
    public void actionSendOrderAPI(){
        
                  
        System.debug('payType ' + payType);
        System.debug('paymentType ' + paymentType);
     //   payType = paymentType!=null ?paymentType:payType;
        payType = (paymentType!=null && paymentType!='') ?paymentType:payType;
        System.debug('payType ' + payType);
        System.debug('paymentType ' + paymentType);
        
        SerializeOrderAPI objSerializeOrder = new SerializeOrderAPI();
            
        lstQuoteLine = new List<SBQQ__QuoteLine__c>();        
        lstQuoteLineAll = new List<SBQQ__QuoteLine__c>();        
        lstQuoteLineProd = new List<SBQQ__QuoteLine__c>();        
        
        
        List<SBQQ__Quote__c>lstQuote = new List<SBQQ__Quote__c>();
        lstQuote = [SELECT Id, Name, SBQQ__Account__c, Delivery_Charge__c, Delivery_Discount__c, Purchase_Number__c, SBQQ__Primary__c, 
                        SBQQ__ShippingStreet__c, SBQQ__ShippingPostalCode__c, SBQQ__ShippingCity__c, SBQQ__ShippingState__c , 
                        County_Name__c, County_Code__c, GeoCode__c, SBQQ__Account__r.NewTerritory__c,
                        SBQQ__Account__r.Pricing_Tier__c, SBQQ__Account__r.Price_List_Type__c, SBQQ__Account__r.SCO_Account_ID__c, SBQQ__Account__r.Territory_ID__c,
                        SBQQ__PrimaryContact__r.FirstName, SBQQ__PrimaryContact__r.LastName, //SBQQ__PrimaryContact__r.Email, SBQQ__PrimaryContact__r.Phone,
                        Delivery_Contact__r.FirstName, Delivery_Contact__r.LastName, Delivery_Contact__r.Email, Delivery_Contact__r.Phone
                    FROM SBQQ__Quote__c 
                    WHERE Id =: quoteId LIMIT 1
                   ];
        
        
        if(lstQuote.size()>0){
            isQuotePrimary = lstQuote[0].SBQQ__Primary__c;
            if(lstQuote[0].SBQQ__Account__c!=null){
                accountId = lstQuote[0].SBQQ__Account__c;
            }
            if(lstQuote[0].Purchase_Number__c!=null 
               && lstQuote[0].SBQQ__ShippingStreet__c!= null 
               && lstQuote[0].SBQQ__ShippingPostalCode__c!= null 
               && lstQuote[0].SBQQ__ShippingCity__c!= null 
               && lstQuote[0].SBQQ__ShippingState__c!= null 
               && lstQuote[0].County_Name__c!= null 
               && lstQuote[0].County_Code__c!= null 
               && lstQuote[0].GeoCode__c!= null 
               && lstQuote[0].SBQQ__Account__r.SCO_Account_ID__c!= null 
          //     && lstQuote[0].SBQQ__Account__r.Territory_ID__c!= null 
               && lstQuote[0].SBQQ__Account__r.NewTerritory__c!= null 
               && lstQuote[0].SBQQ__PrimaryContact__r.FirstName!= null 
               && lstQuote[0].SBQQ__PrimaryContact__r.LastName!= null 
        //       && lstQuote[0].SBQQ__PrimaryContact__r.Email!= null 
        //       && lstQuote[0].SBQQ__PrimaryContact__r.Phone!= null 
               && lstQuote[0].Delivery_Contact__r.FirstName!= null 
               && lstQuote[0].Delivery_Contact__r.LastName!= null 
               && lstQuote[0].Delivery_Contact__r.Email!= null 
               && lstQuote[0].Delivery_Contact__r.Phone!= null 
               && lstQuote[0].Name!=null 
              ){
                
             //     SerializeCalenderAPI objSerializeCalender = new SerializeCalenderAPI();
            objSerializeOrder = new SerializeOrderAPI();
                  //        String ran = String.valueOf(Math.mod(Math.round(Math.random()*1000000+1),1000000));
                  
                  
                  accountId = lstQuote[0].SBQQ__Account__c;
             //     deliverycharge = Double.valueof(lstQuote[0].Delivery_Charge__c>0?lstQuote[0].Delivery_Charge__c:0 - lstQuote[0].Delivery_Discount__c>0?lstQuote[0].Delivery_Discount__c:0 ) ;
                  deliverycharge = Double.valueof(lstQuote[0].Delivery_Charge__c!=null?lstQuote[0].Delivery_Charge__c:0 - lstQuote[0].Delivery_Discount__c!=null?lstQuote[0].Delivery_Discount__c:0 ) ;
                  purchasenumber = lstQuote[0].Purchase_Number__c;
            //      territory_id = lstQuote[0].SBQQ__Account__r.Territory_ID__c;
                  
                  
        List<Territory__c> lstTerritory = new List<Territory__c>();
        lstTerritory = [SELECT Id, Name, Territory_ID__c, District_Territory_ID__c 
                        FROM Territory__c 
                   //     WHERE Territory_ID__c =: lstQuote[0].SBQQ__Account__r.Territory_ID__c 
                        WHERE Id =: lstQuote[0].SBQQ__Account__r.NewTerritory__c 
                        ORDER BY Id DESC
                        LIMIT 1
                       ];
            if(lstTerritory.size()>0){
                territory_id = lstTerritory[0].Territory_ID__c;
                district_id = lstTerritory[0].District_Territory_ID__c;
            }
            
                  
                  
                  
             
                  objSerializeOrder.order_reference_number = orderreferencenumber ;
            //      orderreferencenumber = objSerializeCalender.order_reference_number;
                  objSerializeOrder.purchase_order_number = lstQuote[0].Purchase_Number__c ;
                  objSerializeOrder.account_number = lstQuote[0].SBQQ__Account__r.SCO_Account_ID__c ;
           //       objSerializeOrder.delivery_charge = Double.valueof(lstQuote[0].Delivery_Charge__c>0?lstQuote[0].Delivery_Charge__c:0 - lstQuote[0].Delivery_Discount__c>0?lstQuote[0].Delivery_Discount__c:0 ) ;
                  Double dlv_charge = 0;
                  Double dlv_discount = 0;
                  if(lstQuote[0].Delivery_Charge__c!=null && Double.valueof(lstQuote[0].Delivery_Charge__c)!=0 ){
                      dlv_charge = Double.valueof(lstQuote[0].Delivery_Charge__c);
                  }
                  if(lstQuote[0].Delivery_Discount__c!=null && Double.valueof(lstQuote[0].Delivery_Discount__c)!=0 ){
                      dlv_discount = Double.valueof(lstQuote[0].Delivery_Discount__c);
                  }
                  objSerializeOrder.delivery_charge = dlv_charge - dlv_discount ;
                  objSerializeOrder.delivery_tax = 0;
                  objSerializeOrder.district_id = district_id;
                  objSerializeOrder.territory_id = territory_id;
                  if(lstAddEmails.size()>0){
                      objSerializeOrder.additional_emails = lstAddEmails;
                  }
                  
        System.debug('selectedAddressType --> ' + selectedAddressType);
                  
                  if(selectedAddressType!='Store Pickup'){
                  SerializeOrderAPI.Shipping_address objShippingInfo = new SerializeOrderAPI.Shipping_address();
                  objShippingInfo.address_line_1=lstQuote[0].SBQQ__ShippingStreet__c;
                  objShippingInfo.address_line_2='';
                  objShippingInfo.zip=lstQuote[0].SBQQ__ShippingPostalCode__c;
                  objShippingInfo.city=lstQuote[0].SBQQ__ShippingCity__c;
                  objShippingInfo.state=lstQuote[0].SBQQ__ShippingState__c;
                  objShippingInfo.county=lstQuote[0].County_Name__c;
                  objShippingInfo.county_code=lstQuote[0].County_Code__c;
                  objShippingInfo.geo_code=lstQuote[0].GeoCode__c;
         //         objShippingInfo.first_name=lstQuote[0].SBQQ__PrimaryContact__r.FirstName;
         //         objShippingInfo.last_name=lstQuote[0].SBQQ__PrimaryContact__r.LastName;
        //          objShippingInfo.email=lstQuote[0].SBQQ__PrimaryContact__r.Email;
        //          objShippingInfo.phone=lstQuote[0].SBQQ__PrimaryContact__r.Phone;
                  objShippingInfo.first_name=lstQuote[0].Delivery_Contact__r.FirstName;
                  objShippingInfo.last_name=lstQuote[0].Delivery_Contact__r.LastName;
                  objShippingInfo.email=lstQuote[0].Delivery_Contact__r.Email;
                  objShippingInfo.phone=lstQuote[0].Delivery_Contact__r.Phone.replaceAll('\\D','');
                  objSerializeOrder.shipping_address = objShippingInfo;
                  }
                  
                  SerializeOrderAPI.Payment_method objPaymentMethod = new SerializeOrderAPI.Payment_method();
                  if(paymentType=='Credit Card' || payType=='Credit Card' ){
                      objPaymentMethod.type='CC';
                      if(selectedCreditCard!=null){
                          objPaymentMethod.uid=selectedCreditCard;
                      }
                      objSerializeOrder.payment_method = objPaymentMethod;
                  }else if(paymentType=='Credit Account' || payType=='Credit Account'){
                      objPaymentMethod.type='AR';
                      objPaymentMethod.authorized_purchaser= lstQuote[0].SBQQ__PrimaryContact__r.FirstName + ' ' + lstQuote[0].SBQQ__PrimaryContact__r.LastName;
              //        objPaymentMethod.authorized_purchaser= lstQuote[0].Delivery_Contact__r.FirstName + ' ' + lstQuote[0].Delivery_Contact__r.LastName;
                      objSerializeOrder.payment_method = objPaymentMethod;
                  }else if(paymentType=='Check' || payType=='Check'){
                      objPaymentMethod.type='AR';
              //        objPaymentMethod.authorized_purchaser= lstQuote[0].SBQQ__PrimaryContact__r.FirstName + ' ' + lstQuote[0].SBQQ__PrimaryContact__r.LastName;
              //        objPaymentMethod.authorized_purchaser= lstQuote[0].Delivery_Contact__r.FirstName + ' ' + lstQuote[0].Delivery_Contact__r.LastName;
                      objPaymentMethod.authorized_purchaser= 'Check';
                      objSerializeOrder.payment_method = objPaymentMethod;
                  }
                  System.debug('objSerializeOrder.payment_method ' + objSerializeOrder.payment_method);
                  SerializeOrderAPI.Delivery_date objDeliveryDate = new SerializeOrderAPI.Delivery_date();
                  objDeliveryDate.date1=delDate;
                  objSerializeOrder.delivery_date = objDeliveryDate;
            //      objSerializeOrder.delivery_note = '';
                  objSerializeOrder.delivery_note = delNote;
                  
                  
                  List<SerializeOrderAPI.Line_items> lstLineItems = new List<SerializeOrderAPI.Line_items>();
                
                  lstQuoteLineAll = new List<SBQQ__QuoteLine__c>();
                  
                  lstQuoteLineAll = [SELECT Id, Name, SBQQ__Product__c, SBQQ__Product__r.Name, SBQQ__Product__r.ProductCode, SBQQ__Quantity__c, 
                                        Available__c, Available_Quantity__c, Earliest_Available_Date__c, PA_API_Message__c, 
                                        List_Price__c, Net_Unit_Price__c, Net_Total_Price__c, Tax_Rate__c, Tax__c, Total_Tax_Amount__c, Disposable_Fee__c, 
                                        SBQQ__Number__c, isProductParent__c, ProductParentUnique__c, Feature__c 
                                     FROM SBQQ__QuoteLine__c 
                                     WHERE SBQQ__Quote__c=:quoteId //AND isProductParent__c=true
                                     ORDER BY SBQQ__Number__c
                                    ];
                  
                  
                  
                  
                  
                  Map<String, List<SBQQ__QuoteLine__c>> mapFeatureQuoteLine = new Map<String, List<SBQQ__QuoteLine__c>>();
                  List<SBQQ__QuoteLine__c> lstTempQL = new List<SBQQ__QuoteLine__c>();
                  for(SBQQ__QuoteLine__c q:lstQuoteLineAll){
                    
                      if(q.Feature__c!=null){
                          lstTempQL = new List<SBQQ__QuoteLine__c>();
                          if(mapFeatureQuoteLine.keySet().contains(q.ProductParentUnique__c + q.Feature__c )){
                              lstTempQL.addAll(mapFeatureQuoteLine.get(q.ProductParentUnique__c + q.Feature__c));
                          }else{
                              mapFeatureQuoteLine.put(q.ProductParentUnique__c + q.Feature__c, lstTempQL);
                          }
                          lstTempQL.add(q);
                          
                          mapFeatureQuoteLine.put(q.ProductParentUnique__c + q.Feature__c, lstTempQL);
                      }
                      
                  }     
                  
                  system.debug('mapFeatureQuoteLine--> ' + mapFeatureQuoteLine );
                  
                  lstQuoteLine = new List<SBQQ__QuoteLine__c>();
                  
                  lstQuoteLine = [SELECT Id, Name, SBQQ__Product__c, SBQQ__Product__r.Name, SBQQ__Product__r.ProductCode, SBQQ__Quantity__c, 
                                  Available__c, Available_Quantity__c, Earliest_Available_Date__c, PA_API_Message__c, 
                                  List_Price__c, Net_Unit_Price__c, Net_Total_Price__c, Tax_Rate__c, Tax__c, Total_Tax_Amount__c, 
                                  SBQQ__Number__c, isProductParent__c, ProductParentUnique__c, Feature__c 
                                  FROM SBQQ__QuoteLine__c 
                                  WHERE SBQQ__Quote__c=:quoteId AND isProductParent__c=true
                                  ORDER BY SBQQ__Number__c
                                 ];
                  
                  
                  for(SBQQ__QuoteLine__c ql:lstQuoteLine){
                      
            
                      SerializeOrderAPI.Line_items objLineItems = new SerializeOrderAPI.Line_items();
                      objLineItems.item_id = ql.SBQQ__Product__r.ProductCode;
                      objLineItems.price = double.valueof(ql.Net_Unit_Price__c);
                      objLineItems.quantity = integer.valueof(ql.SBQQ__Quantity__c);
                      objLineItems.tax = double.valueof(ql.Tax__c);
                      
                      
                      if(mapSelectedConfiguration.get(ql.Id)!=null && mapSelectedConfiguration.get(ql.Id)!='' ){
                          SerializeOrderAPI.Product_configuration objConfig = new SerializeOrderAPI.Product_configuration();
                          objConfig.item_id  = mapSelectedConfiguration.get(ql.Id);
                          objLineItems.product_configuration = objConfig;
                      }
                      
                      
                      
                      for(String uft:mapFeatureQuoteLine.keyset()){
                          if(uft.contains(ql.ProductParentUnique__c)){
                              if(uft==ql.ProductParentUnique__c+'Parts'){
                                  List<SerializeOrderAPI.Required_parts> lstRequiredParts = new List<SerializeOrderAPI.Required_parts>();
                                  SerializeOrderAPI.Required_parts objRequiredParts = new SerializeOrderAPI.Required_parts();
                                  for(SBQQ__QuoteLine__c qlf:mapFeatureQuoteLine.get(uft)){
                                      objRequiredParts = new SerializeOrderAPI.Required_parts();
                                      objRequiredParts.item_id = qlf.SBQQ__Product__r.ProductCode;
                                      objRequiredParts.price = double.valueof(qlf.Net_Unit_Price__c);
                                      objRequiredParts.tax = double.valueof(qlf.Tax__c);
                                      lstRequiredParts.add(objRequiredParts);
                                  }
                                  objLineItems.required_parts = lstRequiredParts;
                              }else if(uft==ql.ProductParentUnique__c+'Services'){
                                  SerializeOrderAPI.Delivery_service objDeliveryService = new SerializeOrderAPI.Delivery_service();
                                  SerializeOrderAPI.Haulaway objHaulAway = new SerializeOrderAPI.Haulaway();
                                  for(SBQQ__QuoteLine__c qlf:mapFeatureQuoteLine.get(uft)){
                                      if(qlf.SBQQ__Product__r.ProductCode=='haulawayRequested'){
                                          objHaulAway = new SerializeOrderAPI.Haulaway();
                                          objHaulAway.price = double.valueof(qlf.Net_Unit_Price__c);
                                          objHaulAway.tax = double.valueof(qlf.Tax__c);
                                          objLineItems.haulaway = objHaulAway;
                                      }else{
                                          objDeliveryService = new SerializeOrderAPI.Delivery_service();
                                          objDeliveryService.price = double.valueof(qlf.Net_Unit_Price__c);
                                          objDeliveryService.tax = double.valueof(qlf.Tax__c);
                                          if(qlf.SBQQ__Product__r.ProductCode.startsWith('01') || qlf.SBQQ__Product__r.ProductCode.startsWith('4') ){
                                              objDeliveryService.item_id = 'install_J';
                                              objDeliveryService.install_service_pid = qlf.SBQQ__Product__r.ProductCode;
                                          }else{
                                              objDeliveryService.item_id = qlf.SBQQ__Product__r.ProductCode;
                                              objDeliveryService.install_service_pid = '';
                                          }
                                          objLineItems.delivery_service = objDeliveryService;
                                      }
                                  
                                          
                                  }
                              }
                          }
                      }
                      lstLineItems.add(objLineItems);
                  }
                  
                  objSerializeOrder.line_items = lstLineItems; 
               //   lstSerializeCalender.add(objSerializeCalender);
             //     system.debug('lstSerializeCalender--> ' + lstSerializeCalender );
                  
              //    String JSONString_calender = JSON.serialize(lstSerializeCalender);
                  String JSONString_order1 = JSON.serialize(objSerializeOrder);
                  String JSONString_order = JSONString_order1.replace('"date1"', '"date"');
                  System.debug('Serialized  JSON format: ' + JSONString_order);
                  
                  orderapirequest = '';
                  orderapirequest = JSONString_order;
                  
                  Map<String, Common_Variables__c> mapCV = Common_Variables__c.getAll();
             //     String EndpointUrl = mapCV.get('B2BProd_Calender').Content__c;
             //     String EndpointUrl = 'https://scoapp301p.dev.ch3.s.com:2143/api/rest/delivery-dates';
             //     String EndpointUrl = 'https://KenmoreDirTRIAL331001.jitterbit.net/JitterbitDev/showCalendarApi';
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
            
            renOrderCreateError = false;
       b2bOrderErrorMessage = '';
                  
            //      if(1==1){
                  
                  if((RW.message == '' && RW.Response != null) || Test.isRunningTest() ){
                      system.debug('API response success');
                      
                      string resdoc = '';
                      
                      if(!Test.isRunningTest()){
                          system.debug('RW.Response--> ' + RW.Response );
                      //    response = http.send(request);
                      //    resdoc = response.getBody();
                          resdoc = RW.Response.getBody();
                      }else{
                          resdoc = '{ "order_reference_number": "SF_OrderReferenceNumber", "order_id": 1234 }';
                      }
            
            
                      
                      

           //               resdoc = '{ "order_reference_number": "SF_OrderReferenceNumber", "order_id": 1234 }';
           //          resdoc = resdoc.replace('SF_OrderReferenceNumber', orderreferencenumber);
           //          
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
                      system.debug('lstOrderInsertQry.size()--> ' +lstOrderInsertQry.size());
                      if(lstOrderInsertQry.size()>0){
                          for(Order ord:lstOrderInsertQry){
                              ord.B2B_Order_Id__c = b2borderid;
                          }
                      update lstOrderInsertQry;
                      }
*/
                      
        List<SBQQ__Quote__c>lstQuoteBEMSuccess = new List<SBQQ__Quote__c>();
        lstQuoteBEMSuccess = [SELECT Id, Name, B2B_Order_Error_Message__c, Order_API_Request__c, B2B_Order_Error_Message_Appended__c, Order_Reference_Number__c FROM SBQQ__Quote__c WHERE Id =: quoteId LIMIT 1];
            
            for(SBQQ__Quote__c qb:lstQuoteBEMSuccess){
                qb.B2B_Order_Error_Message__c = b2bOrderErrorMessage;
                qb.Order_API_Request__c = orderapirequest;
                
                if(qb.Order_API_Request__c!=null && qb.Order_API_Request__c!='' ){
                    qb.Order_Reference_Number__c = qb.Order_API_Request__c.substringBetween(',"order_reference_number":"', '",')!=null?qb.Order_API_Request__c.substringBetween(',"order_reference_number":"', '",'):'';
                }else{
                    qb.Order_Reference_Number__c = '';
                }
                
                if(qb.B2B_Order_Error_Message__c!=null && qb.B2B_Order_Error_Message__c!='' ){
                    if(qb.B2B_Order_Error_Message__c.length()>254){
                        qb.B2B_Order_Error_Message_Appended__c = qb.B2B_Order_Error_Message__c.substring(0, 254);
                    }else{
                        qb.B2B_Order_Error_Message_Appended__c = qb.B2B_Order_Error_Message__c;
                    }
                }else{
                    qb.B2B_Order_Error_Message_Appended__c = '';
                }
                
            }
            system.debug('lstQuoteBEMSuccess-->' + lstQuoteBEMSuccess );
            update lstQuoteBEMSuccess;
            system.debug('lstQuoteBEMSuccess-->' + lstQuoteBEMSuccess );
                      
                      
            
                  }else{
                      renOrderCreateError= true;
           //       CalloutB2BAPI.ResponseWrapper RW;
                      if(RW.Response!=null){
                          system.debug('RW.Response>>' +RW.Response);
                          ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,RW.Response.getStatusCode() + '--> ' + RW.Response.getStatus() ));
                          b2bOrderErrorMessage+=RW.Response.getStatus();
                      }
                      if(RW.message!=null){
                      system.debug('RW.message--> ' + RW.message );
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,RW.message));
                          b2bOrderErrorMessage+=RW.message;
                      }
                  }
                  
                
            }
            
            
        }
                  
        
        
        
        
    }
    
    
    
    
    public PageReference actionSubstitute(){
        PageReference retURL = new PageReference('/' + quoteId );
        retURL.setRedirect(true);
        return retURL;
    }
    
    
    public PageReference actionCancel(){
        PageReference retURL = new PageReference('/' + quoteId );
        retURL.setRedirect(true);
        return retURL;
    }
    
    
   
    
}