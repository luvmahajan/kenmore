@isTest
public class QLMATest {

    static testMethod void test_QLMA(){
        
        String ran = DataInsertFactory.insertQuote();
            
        List<SBQQ__Quote__c> lstTestQuote = new List<SBQQ__Quote__c>();
        lstTestQuote = [SELECT Id, SBQQ__Status__c FROM SBQQ__Quote__c ORDER BY Id];
        
        system.debug('lstTestQuote --> ' + lstTestQuote.size() );
        
        for(SBQQ__Quote__c tq:lstTestQuote){
            tq.SBQQ__Status__c = 'Add/Edit Products';
        }
        update lstTestQuote;
        
        for(SBQQ__Quote__c tq:lstTestQuote){
            tq.SBQQ__Status__c = 'Approval';
        }
        update lstTestQuote;
        /*
        List<String> list_qid = new List<String>();
        for(SBQQ__Quote__c tq:lstTestQuote){
            list_qid.add(tq.Id);
        }
        
        system.debug('list_qid --> ' + list_qid );
        
        QuoteLineMarginApproval.calculateLineMargin(list_qid);
        */
    }    
    
}