global class ScheduledProductDocuments Implements Schedulable
{
    
    
    //   ScheduledProductDocuments rt = new ScheduledProductDocuments();
    //   String srt = '0 13 * * * ?';
    //   String jobID = system.schedule('ScheduledProductDocuments', srt, rt);
    
    global void execute(SchedulableContext sc){
        
        List<Product2> lstProduct = new List<Product2>();
        lstProduct = [SELECT Id, Name, ProductCode FROM Product2 WHERE ProductCode != null];
        
        Map<String, String> mapProductId = new Map<String, String>();
        Map<String, String> mapProductCode = new Map<String, String>();
        
        for(Product2 pr:lstProduct){
            mapProductId.put(pr.Id, pr.ProductCode);
            mapProductCode.put(pr.ProductCode, pr.Id);
        }
        
        
        
        List<String> lstProductAdditional = new List<String>();
        List<SBQQ__RelatedContent__c> lstAdditionalDocument = new List<SBQQ__RelatedContent__c>();
        lstAdditionalDocument = [SELECT Id, Name, SBQQ__ExternalId__c, SBQQ__Product__c, SBQQ__Required__c 
                                 FROM SBQQ__RelatedContent__c 
                                 WHERE SBQQ__Product__c != null
                                ];
        
        for(SBQQ__RelatedContent__c ad:lstAdditionalDocument){
       //     lstProductAdditional.add(ad.SBQQ__Product__c);
            lstProductAdditional.add(mapProductId.get(ad.SBQQ__Product__c));
        }
        system.debug('lstProductAdditional.size()--> '+ lstProductAdditional.size() );
        
        for(String lpa:lstProductAdditional){
        	system.debug('lpa--> '+ lpa );
        }
        
        
        Map<String, String> mapDocumentExternal = new Map<String, String>();
        List<Document> lstDocument = new List<Document>();
        lstDocument = [SELECT Id, Name, DeveloperName, AuthorId, Author.Name, CreatedDate, LastModifiedDate, LastModifiedById 
                       FROM Document 
                       WHERE Folder.DeveloperName='SteelBrick_CPQ_Template_Resources' AND Name NOT IN: lstProductAdditional AND Name IN: mapProductCode.keyset()  
                      ];
        system.debug('lstDocument.size()--> '+ lstDocument.size() );
        
        for(Document dc:lstDocument){
            mapDocumentExternal.put(mapProductCode.get(dc.Name), dc.Id);
        }
        
        system.debug('mapDocumentExternal--> '+ mapDocumentExternal );
        
        List<SBQQ__RelatedContent__c> lstContent = new List<SBQQ__RelatedContent__c>();
        SBQQ__RelatedContent__c objContent = new SBQQ__RelatedContent__c();
        
        for(String de:mapDocumentExternal.keyset()){
            objContent = new SBQQ__RelatedContent__c();
            objContent.SBQQ__ExternalId__c = mapDocumentExternal.get(de);
            objContent.SBQQ__Product__c = de;
            objContent.SBQQ__Required__c = false;
            objContent.Name = mapProductId.get(de);
            System.debug('objContent--> ' + objContent);
            lstContent.add(objContent);
        }
        
        System.debug('lstContent--> ' + lstContent);
        System.debug('lstContent.size()--> ' + lstContent.size());
        insert lstContent;
       
    }
}