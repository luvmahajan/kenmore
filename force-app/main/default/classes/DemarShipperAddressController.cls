public class DemarShipperAddressController {
    
    public String quoteId {get; set;}
    public String quoteZip {get; set;}
    public String storeNumber {get; set;}
    
    public DemarShipperAddressController() {
        quoteZip='';
        storeNumber='';
        quoteId = ApexPages.CurrentPage().getparameters().get('id');
        List<SBQQ__Quote__c> qheader = new List<SBQQ__Quote__c>();
        qheader = [select Id, SBQQ__ShippingPostalCode__c from SBQQ__Quote__c where Id = :quoteId LIMIT 1];
        if(qheader.size()>0){
            if(qheader[0].SBQQ__ShippingPostalCode__c!=null){
                quoteZip = qheader[0].SBQQ__ShippingPostalCode__c;
            }
        }
        
        
    }
    
    public PageReference redirectQLE(){
 //       quoteZip = '62806';
        if(quoteZip!=''){
            DOM.Document doc = new DOM.Document();
            HttpRequest request = new HttpRequest();
            HttpResponse response = new HttpResponse();
            Http http = new Http();
            
            Map<String, Common_Variables__c> mapCV = Common_Variables__c.getAll();
            String CS_Endpoint = mapCV.get('B2BProd_StoreZip').Content__c;
            String CS_CLIENT_ID = mapCV.get('B2BProd_ClientId').Content__c;
            String CS_CLIENT_SECRET = mapCV.get('B2BProd_ClientSecret').Content__c;
            String CS_CONTENT_TYPE = mapCV.get('B2BProd_ContentType_XML').Content__c;
            
            String EndpointUrl = CS_Endpoint+quoteZip;
            
            request.setMethod('GET');
            request.setendPoint(EndpointUrl);
            //    system.debug('EndpointUrl >>'+EndpointUrl);
            
            request.setHeader('Content-Type', CS_CONTENT_TYPE);
            request.setHeader('CLIENT_ID', CS_CLIENT_ID);
            request.setHeader('CLIENT_SECRET', CS_CLIENT_SECRET);
            
            
            CalloutB2BAPI.ResponseWrapper RW = CalloutB2BAPI.execute(request);
            //          system.debug('callout success>>' +RW);
            if(RW.message == '' && RW.Response != null){
                
                system.debug('API response success');
                response = http.send(request);
                system.debug( 'rescode= ' +response.getStatusCode());
                system.debug('resp message =' +response.getStatus());
                
                string resdoc = response.getBody();
                system.debug('Response output message:' +response.getBody());
                
                DOM.Document docResp= new DOM.Document();
                docResp.load(resdoc);
                
                DOM.XmlNode root = docResp.getRootElement();
                system.debug('root--> '+root);
                
                DOM.XmlNode storeXMLNode = root.getChildElement('storeNumber', null);
                system.debug('storeXMLNode--> '+storeXMLNode);
                if (storeXMLNode.getname() == 'storeNumber'){
                    storeNumber = storeXMLNode.gettext();
                    system.debug('storeXMLNode.gettext()--> '+storeXMLNode.gettext());
                }
            }  

            system.debug('storeNumber--> ' + storeNumber );
            
       //     if(storeNumber!=''){
                List<SBQQ__Quote__c> lstQuoteUpdate = new List<SBQQ__Quote__c>();
                lstQuoteUpdate = [SELECT Id, Store_Number__c from SBQQ__Quote__c where Id = :quoteId LIMIT 1];
                if(lstQuoteUpdate.size()>0){
                    for(SBQQ__Quote__c qt:lstQuoteUpdate){
                        qt.Store_Number__c = storeNumber;
                    }
                    update lstQuoteUpdate;
                }
      //      }
        }
    //    PageReference pageRef2 = new PageReference('/apex/ProductIntegration2?id=' + quoteId );
        PageReference pageRef2 = new PageReference('/apex/ProductIntegration?id=' + quoteId );
        return pageRef2;
        
    }    
    
    
}