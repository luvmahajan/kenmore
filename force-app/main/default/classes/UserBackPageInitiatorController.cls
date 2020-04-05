public class UserBackPageInitiatorController {
    
    public List<User> lstUser {get; set;}
    
    public UserBackPageInitiatorController() {
        lstUser = new List<User>();
        
        lstUser = [SELECT Id, Name, Title, Email, Phone
                   FROM User
                   WHERE isActive=true
                  ];
        
    }
    
    public PageReference gotoBackpage(){
        PageReference retURL = new PageReference('/apex/UserBackPage?id=' + lstUser[0].Id );
        retURL.setRedirect(true);
        return retURL;
    }
    
    public void createDocument(){
   //     if(!Test.isRunningTest()){
            
            List<Document> lstDoc = new List<Document>();
            
        for(User usr:lstUser){
        
        PageReference pdf = Page.UserBackPage;
        pdf.getParameters().put('id',usr.Id);
            
            Document doc = new Document();
            Blob body;  
        if(!Test.isRunningTest()){
            body = pdf.getContentAsPDF(); 
        }
            doc.Body = body;
            doc.Name = usr.Name.toUpperCase();
            string  sysnow = String.valueOf(system.now()).remove(' ').remove('-').remove(':');
            string ran = String.valueOf(Math.mod(Math.round(Math.random()*100+1),100));
            system.debug('USER_' + sysnow + '_' + ran + '_' + usr.Name.toUpperCase().replace(' ','_').replace('-','_').remove('.').remove('(').remove(')').remove('\''));
            doc.DeveloperName = 'USER_' + sysnow + '_' + ran + '_' + usr.Name.toUpperCase().replace(' ','_').replace('-','_').remove('.').remove('(').remove(')').remove('\'');
            doc.FolderId = '00l3A000003YY7iQAG';
            doc.ContentType = 'application/pdf';
            doc.Type = 'pdf';
            lstDoc.add(doc);
            system.debug('doc--> ' + doc );
        }
            
            insert lstDoc;
            
            List<String> lstDocId = new List<String>();
            Map<String, String> mapDoc = new Map<String, String>();
            Map<String, String> mapDocName = new Map<String, String>();
            
            for(Document dc:lstDoc){
                lstDocId.add(dc.Id);
                mapDoc.put(dc.Name,dc.Id );
                mapDocName.put(dc.Id,dc.Name );
            }
            
                List<Document> qDoc = new List<Document>();
                qDoc = [SELECT Id, Name 
                        FROM Document 
                        WHERE Name IN: mapDoc.keyset() AND Id NOT IN:lstDocId
                       // LIMIT 1
                       ];
                System.debug('qDoc--> ' + qDoc);
            
                    
                if(qDoc.size()>0){
            List<String> lstQDocId = new List<String>();
            Map<String, String> mapQDoc = new Map<String, String>();
            Map<String, String> mapQDocName = new Map<String, String>();
            for(Document qd:qDoc){
                mapQDoc.put(qd.Id, mapDoc.get(qd.Name));
                mapQDocName.put(qd.Id, qd.Name);
            }
                
                System.debug('mapDoc--> ' + mapDoc);
                System.debug('mapDocName--> ' + mapDocName);
                System.debug('mapQDoc--> ' + mapQDoc);
                System.debug('mapQDocName--> ' + mapQDocName);

            List<SBQQ__RelatedContent__c> lstContent = new List<SBQQ__RelatedContent__c>();
            lstContent = [SELECT Id, Name, SBQQ__ExternalId__c FROM SBQQ__RelatedContent__c WHERE SBQQ__ExternalId__c IN: mapQDoc.keySet()];
                    String ext_id = '';
                    for(SBQQ__RelatedContent__c cn:lstContent){
                        ext_id = cn.SBQQ__ExternalId__c;
                        cn.SBQQ__ExternalId__c = mapQDoc.get(ext_id);
                        cn.Name = mapDocName.get(cn.SBQQ__ExternalId__c);
                    }
                System.debug('lstContent--> ' + lstContent);
                    update lstContent;
                    delete qDoc;
                    
                }
            
     //   }
    }
    
}