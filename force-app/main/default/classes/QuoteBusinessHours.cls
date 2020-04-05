public class QuoteBusinessHours {
    
    @InvocableMethod
    public static void quoteBusiensshour_method(List<ID> qId) {
        DateTime timestart = system.now();
        List<BusinessHours> lstBusinessHours = new List<BusinessHours>();
        lstBusinessHours = [SELECT Id, Name, IsActive, IsDefault FROM BusinessHours WHERE Name = 'IST Business Hours' LIMIT 1];
        if(lstBusinessHours.size()>0){
            Long interval = 16 * 60 * 60 * 1000;
            DateTime time2businessdays = BusinessHours.add(lstBusinessHours[0].id, timestart, interval);
            system.debug('timestart--> ' + timestart );
            system.debug('time2businessdays--> ' + time2businessdays );
            List<SBQQ__Quote__c> lstQuote = new List<SBQQ__Quote__c>();
            lstQuote = [SELECT Id, Name, Approval_Deadline__c FROM SBQQ__Quote__c WHERE Id =: qId LIMIT 1];
            if(lstQuote.size()>0){
                for(SBQQ__Quote__c qt:lstQuote){
                    qt.Approval_Deadline__c = time2businessdays;
                }
                update lstQuote;
            }
        }
        
    }
    
}