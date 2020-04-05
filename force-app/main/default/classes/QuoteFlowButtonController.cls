public class QuoteFlowButtonController {
    
    public QuoteFlowButtonController(ApexPages.StandardSetController controller) {
    }
    public PageReference redirectNewQuote() {
        
        String oppId = ApexPages.currentPage().getParameters().get('Id');         
        	List<RecordType> listRecordType = new List<RecordType>();
        listRecordType = [SELECT Id, Name FROM RecordType WHERE SobjectType='SBQQ__Quote__c' AND DeveloperName = 'Commercial_Flow_Business' LIMIT 1 ];
        String projectRecordId = listRecordType[0].Id;
     //   system.debug('projectRecordId--> ' + projectRecordId );
        
        
            PageReference pageRef = new PageReference('/apex/SBQQ__NewQuote?RecordType=' + projectRecordId );
        return (pageRef);
    }
  
}