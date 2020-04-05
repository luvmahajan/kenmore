public class SBQQQuoteHandler implements ITrigger {
    
        public void bulkBefore() {}
    
    public void bulkAfter() {}
    
    public void beforeInsert(Sobject obj) {
        
    }
    
    public void beforeUpdate(Sobject oldObj, Sobject newObj) {}
    
    public void beforeDelete(Sobject obj) {}
    
    public void afterInsert(Sobject obj) {
        
        SBQQ__Quote__c qheader = (SBQQ__Quote__c) obj;
        System.debug('qheader--> ' + qheader);
        System.debug('qheader.SBQQ__SalesRep__c--> ' + qheader.SBQQ__SalesRep__c);
        System.debug('qheader.SBQQ__SalesRep__r.Name--> ' + qheader.SBQQ__SalesRep__r.Name);
        
        if(qheader.SBQQ__SalesRep__c!=null){
            List<User> qUser = new List<User>();
            qUser = [SELECT Id, Name 
                     FROM User 
                     WHERE Id =: qheader.SBQQ__SalesRep__c
                     LIMIT 1
                    ];
            System.debug('qUser--> ' + qUser);
            
            if(qUser[0].Name!=null){
                List<Document> qDoc = new List<Document>();
                qDoc = [SELECT Id, Name 
                        FROM Document 
                        WHERE Name =: qUser[0].Name
                        LIMIT 1
                       ];
                System.debug('qDoc--> ' + qDoc);
                
                if(qDoc.size()>0){
                    SBQQ__RelatedContent__c qContent = new SBQQ__RelatedContent__c();
                    qContent.SBQQ__ExternalId__c = qDoc[0].Id;
                    qContent.SBQQ__Quote__c = qheader.Id;
                    qContent.SBQQ__Required__c = false;
                    qContent.Name = qDoc[0].Name;
                    
                    System.debug('qContent--> ' + qContent);
                    
                    insert qContent;
                    
                }
            }
        }
        
        /*
                    system.debug('1');
        SBQQ__Quote__c qheader = (SBQQ__Quote__c) obj;
        if(Trigger.isAfter){
            
            if(!(System.isFuture() || System.isBatch())){
                //for(SBQQ__Quote__c qheader : Trigger.new){
                    system.debug('In quote header '+qheader);
              //      Quotehandler.ProdTaxCheckCallout(qheader.Id);
              //      Quotehandler.ProdAvailCheckCallout(qheader.Id);
                    
                //}
            }
        }
*/
    }
    
    public void afterUpdate(Sobject oldObj, Sobject newObj) {
        /*
                    system.debug(oldObj);
                    system.debug(newObj);
        boolean isChange = false;
        SBQQ__Quote__c QuoteObject = new SBQQ__Quote__c(); // This takes all available fields from the required object. 
        Schema.SObjectType objType = QuoteObject.getSObjectType(); 
        Map<String, Schema.SObjectField> M = Schema.SObjectType.SBQQ__Quote__c.fields.getMap(); 
        for (String str : M.keyset()) {
            try { 
                if(str=='isapprovalready__c' && newObj.get(str)!=oldObj.get(str) ){ 
                System.debug('Field name: '+str +'. New value: ' + newObj.get(str) +'. Old value: '+oldObj.get(str)); 
                    system.debug('******The value has changed!!!! '); 
                    isChange = true;
                    break;
                } 
            } catch (Exception e) { 
                System.debug('Error: ' + e); 
            } 
        }
                System.debug('isChange: ' + isChange); 
        */
        /*
                    system.debug('2');
                    system.debug(oldObj);
                    system.debug(newObj);
        boolean isChange = false;
        SBQQ__Quote__c QuoteObject = new SBQQ__Quote__c(); // This takes all available fields from the required object. 
        Schema.SObjectType objType = QuoteObject.getSObjectType(); 
        Map<String, Schema.SObjectField> M = Schema.SObjectType.SBQQ__Quote__c.fields.getMap(); 
        for (String str : M.keyset()) {
            try { 
                System.debug('Field name: '+str +'. New value: ' + newObj.get(str) +'. Old value: '+oldObj.get(str)); 
                if(str!='lastmodifieddate' && str!='systemmodstamp' && newObj.get(str) != oldObj.get(str)){ 
                    system.debug('******The value has changed!!!! '); 
                    isChange = true;
                    break;
                } 
            } catch (Exception e) { 
                System.debug('Error: ' + e); 
            } 
        }
                System.debug('isChange: ' + isChange); 
        
        
        
        
        SBQQ__Quote__c qheader = (SBQQ__Quote__c) newobj;
        if(!(System.isFuture() || System.isBatch())){
            //for(SBQQ__Quote__c qheader : Trigger.new){
            system.debug('In quote header '+qheader);
        //    if(Trigger.oldMap.get(opp.Id)){
            if(isChange){
      //     Quotehandler.ProdTaxCheckCallout(qheader.Id);
      //     Quotehandler.ProdAvailCheckCallout(qheader.Id);
            }
     //      Quotehandler.redirectNewQuote(qheader.Id);
            
            //}
        }
        */
    }
    
    public void afterDelete(Sobject obj) {}
    
    public void andFinally() {}

}