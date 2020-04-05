public with sharing class AddressValidationController {
    
    private final SBQQ__Quote__c quote;  
    public String quoteId {get; set;}
    public List<address> l_addressList = new List<address>();
    public List<String> errorList {get; set;}
    public SBQQ__Quote__c quotedetails;
    public boolean renTable {get; set;}
    public boolean renSuccess {get; set;}
    public SBQQ__Quote__c quotezip;
    public CommonCarrierOverrideZipcode__c CCdetails;
    public String selFulType {get; set;}
    public String selLocNum {get; set;}
    
    public AddressValidationController(ApexPages.StandardController Controller){
        
        renTable = false;
        renSuccess = false;
        quoteId = ApexPages.CurrentPage().getparameters().get('id');
        
        selFulType = '';
        selLocNum = '';
        
        //    List<string> newlist = new List<string> ();
        errorList = new List<String>();
        
        quotezip = new SBQQ__Quote__c();
        quotezip = [select Id, SBQQ__ShippingPostalCode__c, Fulfillment_Type__c, Location_Number__c from SBQQ__Quote__c where Id = :quoteId LIMIT 1];
        
        string post_code = '';
        post_code = quotezip.SBQQ__ShippingPostalCode__c;
        
        CCdetails = new CommonCarrierOverrideZipcode__c();
        try{
            CCdetails = [SELECT Id, Name, Zipcode__c, PLANT__c, USLOC__c FROM CommonCarrierOverrideZipcode__c where Zipcode__c = :post_code AND PLANT__c IN ('ZMDO', 'ZSDO') LIMIT 1];
        }catch(exception e){
            system.debug('No Common Carrier Override Zipcode');
        }
        if(ccdetails.PLANT__c != null){
        //    List<SBQQ__Quote__c> lstQuote_loc = new  List<SBQQ__Quote__c>();
      //      quotezip.Fulfillment_Type__c = ccdetails.PLANT__c;
      //      quotezip.Location_Number__c = ccdetails.USLOC__c;
            selFulType = ccdetails.PLANT__c;
            selLocNum = ccdetails.USLOC__c;
     //       lstQuote_loc.add(quotezip);
    //        system.debug('final update list :' +lstquote_loc );
            
       //     update lstQuote_loc;
           
        }
        
    }
    
    
    public PageReference checkAddress(){
        
        Map<String, Common_Variables__c> mapCV = Common_Variables__c.getAll();            
        //     String CS_Endpoint = mapCV.get('B2BProd_EndPoint').Content__c;
        String CS_Endpoint = mapCV.get('B2BProd_Address_Val_API_URL').Content__c;
        String CS_CLIENT_ID = mapCV.get('B2BProd_ClientId').Content__c;
        String CS_CLIENT_SECRET = mapCV.get('B2BProd_ClientSecret').Content__c;
        String CS_CONTENT_TYPE = mapCV.get('B2BProd_ContentType_XML').Content__c;
        
        // system.debug('CS_Endpoint >> ' + CS_Endpoint);
        // system.debug('CS_CLIENT_ID >> ' + CS_CLIENT_ID);
        // system.debug('CS_CLIENT_SECRET >> ' + CS_CLIENT_SECRET);
        
        
        renTable = false;
        renSuccess = false;
        quoteId = ApexPages.CurrentPage().getparameters().get('id');
        String EndpointUrl = CS_Endpoint;
        
        List<string> newlist = new List<string> ();
        errorList = new List<String>();
        
        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        Http http = new Http();
        system.debug('Hi');
        quotedetails = [select Id, SBQQ__ShippingCity__c, SBQQ__ShippingPostalCode__c, SBQQ__ShippingState__c, SBQQ__ShippingStreet__c, SBQQ__ShippingName__c, isValidAddress__c from SBQQ__Quote__c where Id = :quoteId];
        system.debug('quotedetails.SBQQ__ShippingCity__c--> ' + quotedetails.SBQQ__ShippingCity__c );
        system.debug('quotedetails.SBQQ__ShippingPostalCode__c--> ' + quotedetails.SBQQ__ShippingPostalCode__c );
        system.debug('quotedetails.SBQQ__ShippingState__c--> ' + quotedetails.SBQQ__ShippingState__c );
        system.debug('quotedetails.SBQQ__ShippingStreet__c--> ' + quotedetails.SBQQ__ShippingStreet__c );
        system.debug('quotedetails.SBQQ__ShippingName__c--> ' + quotedetails.SBQQ__ShippingName__c );
        system.debug('quotedetails.isValidAddress__c--> ' + quotedetails.isValidAddress__c );
        if(quotedetails.SBQQ__ShippingCity__c != null && quotedetails.SBQQ__ShippingPostalCode__c != null && quotedetails.SBQQ__ShippingState__c != null && quotedetails.SBQQ__ShippingStreet__c != null && quotedetails.SBQQ__ShippingName__c != null && quotedetails.isValidAddress__c == false ){
    //    if(quotedetails.SBQQ__ShippingCity__c != null && quotedetails.SBQQ__ShippingPostalCode__c != null && quotedetails.SBQQ__ShippingState__c != null && quotedetails.SBQQ__ShippingStreet__c != null && quotedetails.SBQQ__ShippingName__c != null  ){
            // Payload Prepare
            DOM.Document doc = new DOM.Document();
            dom.XmlNode xmlrequest = doc.createRootElement('shippingAddress', null, null);
            
            dom.xmlNode firstName = xmlrequest.addChildElement('firstName',null,null);
            firstName.addTextNode(quotedetails.SBQQ__ShippingName__c);
            
            dom.xmlNode lastName = xmlrequest.addChildElement('lastName',null,null);
            
            dom.xmlNode addressLine1 = xmlrequest.addChildElement('addressLine1',null,null);
            addressLine1.addTextNode(quotedetails.SBQQ__ShippingStreet__c);
            
            dom.xmlNode addressLine2 = xmlrequest.addChildElement('addressLine2',null,null);
            
            dom.xmlNode addressLine3 = xmlrequest.addChildElement('addressLine3',null,null);
            
            dom.xmlNode zipCode = xmlrequest.addChildElement('zipCode',null,null);
            zipCode.addTextNode(quotedetails.SBQQ__ShippingPostalCode__c);
            
            dom.xmlNode email = xmlrequest.addChildElement('email',null,null);
            
            dom.xmlNode city = xmlrequest.addChildElement('city',null,null);
            city.addTextNode(quotedetails.SBQQ__ShippingCity__c);
            
            dom.xmlNode state = xmlrequest.addChildElement('state',null,null);
            state.addTextNode(quotedetails.SBQQ__ShippingState__c);
            
            dom.xmlNode day_phone = xmlrequest.addChildElement('day_phone',null,null);
            day_phone.addTextNode('2342343333');
            
            string req = doc.toXmlString();
            system.debug('request  message' +req);
            
            // string ns = '<shippingAddress><firstName> First Name</firstName><lastName> Last Name </lastName><addressLine1> 1 North State Street</addressLine1><addressLine2>floor 12 </addressLine2><addressLine3> </addressLine3><zipCode>60601</zipCode><email>test@test.com</email><city>chicago</city><state>IL</state><day_phone>1112223333</day_phone></shippingAddress>';
            
            //Payload prepare
            request.setMethod('POST');
                  request.setTimeout(60000); // timeout in milliseconds
            request.setendPoint(EndpointUrl);
            system.debug('EndpointUrl >>'+EndpointUrl);
            
            //   request.setHeader('Content-Type', 'application/xml');
            //   request.setHeader('CLIENT_ID', 'c70a6500b5b70134f47d005056af5d0d');
            //   request.setHeader('CLIENT_SECRET', 'ES3u4E7GW70R/my5ygzS98OJ6ejwUSJlqH8I2EEblRNRH0qL');
            request.setHeader('Content-Type', CS_CONTENT_TYPE);
            request.setHeader('CLIENT_ID', CS_CLIENT_ID);
            request.setHeader('CLIENT_SECRET', CS_CLIENT_SECRET);
            request.setBody(req);
            
            
            
            CalloutB2BAPI.ResponseWrapper RW = CalloutB2BAPI.execute(request);
            
            system.debug('RW>>' +RW);
            system.debug('RW.Response>>' +RW.Response);
            system.debug('RW.message>>' +RW.message);
            
            //      response = http.send(request);
            system.debug('RW>> ' +RW);
            //    string docOutput = response.getBody();
            
            if (RW.message == '' && RW.Response != null){
                system.debug('API response success');
                
                string docOutput = RW.Response.getBody();
                system.debug('Response output' +docOutput);
                Dom.Document docResp = new Dom.Document();
                docResp.load(docOutput);
                system.debug('docResp--> ' + docResp);
                DOM.XmlNode root = docResp.getRootElement();
                system.debug('root--> ' + root);
                
                
                // DOM.xmlNode responseXMLNode = root.getChildElement('response', null);
                DOM.XmlNode addressXMLNode = root.getChildElement('address',null);
                system.debug('addressXMLNode--> ' + addressXMLNode);
                dom.XmlNode countiesXMLNode = addressXMLNode.getchildelement('counties',null);
                system.debug('countiesXMLNode--> ' + countiesXMLNode);
                dom.XmlNode [] scountyXMLNode = countiesXMLNode.getchildelements();
                system.debug('scountyXMLNode--> ' + scountyXMLNode);
                Integer counter = 0;
                
                for(DOM.XmlNode county : scountyXMLNode) {
                    counter++;
                    
                    dom.XmlNode [] xcounty = county.getchildelements() ;
                    system.debug('xcounty--> ' + xcounty);
                    for(dom.XmlNode county_final: xcounty) {
                        
                        if (county_final.getname() == 'geoCode'){
                            system.debug('geocode'+county_final.gettext());
                            newlist.add(county_final.gettext());
                            
                        }
                        
                        if (county_final.getname() == 'countyCode'){
                            system.debug('countycode'+county_final.gettext());
                            newlist.add(county_final.gettext());
                            
                        }
                        
                        if (county_final.getname() == 'countyName'){
                            system.debug('countyName'+county_final.gettext());
                            newlist.add(county_final.gettext());
                            
                        }
                        
                    }
                    
                    address addr = new address(String.valueOf(counter), newlist[0],newlist[1],newlist[2]);
                    system.debug('addr'+addr);
                    l_addressList.add(addr);
                    renTable = true;
                    newlist.clear();
                }
                
                system.debug('finallist'+newlist);
                system.debug('l_addressList'+l_addressList);
                
                
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
                /*
dom.XmlNode countiesXMLNode = addressXMLNode.getchildelement('counties',null);
system.debug('countiesXMLNode--> ' + countiesXMLNode);
dom.XmlNode [] scountyXMLNode = countiesXMLNode.getchildelements();
system.debug('scountyXMLNode--> ' + scountyXMLNode);
Integer counter = 0;
for(DOM.XmlNode county : scountyXMLNode) {
counter++;

dom.XmlNode [] xcounty = county.getchildelements() ;
system.debug('xcounty--> ' + xcounty);
for(dom.XmlNode county_final: xcounty) {

if (county_final.getname() == 'geoCode'){
system.debug('geocode'+county_final.gettext());
newlist.add(county_final.gettext());

}

if (county_final.getname() == 'countyCode'){
system.debug('countycode'+county_final.gettext());
newlist.add(county_final.gettext());

}

if (county_final.getname() == 'countyName'){
system.debug('countyName'+county_final.gettext());
newlist.add(county_final.gettext());

}

}


*/
            }else if(RW.message != null && RW.Response == null){
                errorList = new List<String>();
                errorList.add(RW.message);
            }
            
        }else if(quotedetails.isValidAddress__c == true){
            renSuccess = true;
            //    PageReference pageRef2 = new PageReference('/apex/QuoteLineEditor?id=' + quoteId );
            //     PageReference pageRef2 = new PageReference('/apex/ProductIntegration2?id=' + quoteId );
            PageReference pageRef2 = new PageReference('/apex/ProductIntegration?id=' + quoteId );
            return pageRef2;
        }
        
        
        return null;
    }
    
    
    
    
    
    public List<address> getaddressList(){
        return l_addressList;
    }
    
    public PageReference selectaddr(){
        String seqno = System.currentPageReference().getParameters().get('seqno');
        system.debug('Selected seqno  ->>'+seqno);
        List<SBQQ__Quote__c> lstQuote = new  List<SBQQ__Quote__c>();
        for(address addr: l_addressList){
            if(addr.seqno == seqno)   {
                quotedetails.GeoCode__c = addr.geoCode;
                quotedetails.County_Code__c = addr.countyCode;
                quotedetails.County_Name__c = addr.countyName;
                quotedetails.isValidAddress__c = true;
                quotedetails.Fulfillment_Type__c = selFulType;
                quotedetails.Location_Number__c = selLocNum;
                //    update quotedetails;
                lstQuote.add(quotedetails);
                
            }         
        }
        update lstQuote;
        
        
        //   PageReference pageRef2 = new PageReference('/apex/QuoteLineEditor?id=' + quoteId );
        //   PageReference pageRef2 = new PageReference('/apex/ProductIntegration2?id=' + quoteId );
        //   PageReference pageRef2 = new PageReference('/apex/DemarShipperAddress?id=' + quoteId );
        PageReference pageRef2 = new PageReference('/apex/ProductIntegration?id=' + quoteId );
        return pageRef2;
    }
    
    public PageReference gotoQuote()
    {
        PageReference retURL = new PageReference('/' + quoteId );
        retURL.setRedirect(true);
        return retURL;
    }
    
    
    
    public class address{
        public String seqno {get;set;}
        public string geoCode {get;set;}
        public string countyCode {get;set;}
        public string countyName {get;set;}
        public address(String seqno, string geoCode, string countyCode,string countyName ){
            this.seqno = seqno;
            this.geoCode = geoCode;
            this.countyCode = countyCode;
            this.countyName = countyName;
        }
    }
    
}