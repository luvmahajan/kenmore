global class ScheduledQuoteApproval Implements Schedulable
{
    
    
    //   ScheduledQuoteApproval rt = new ScheduledQuoteApproval();
    //   String srt = '0 13 * * * ?';
    //   String jobID = system.schedule('ScheduledQuoteApproval', srt, rt);
    
    global void execute(SchedulableContext sc){
        DateTime systemNow = system.now();
        List<SBQQ__Quote__c> lstQuote = new List<SBQQ__Quote__c>();
        lstQuote = [SELECT Id, ScheduledRejectComment__c  FROM SBQQ__Quote__c 
                    WHERE Approval_Stage__c IN (1,2,3) AND Approval_Status__c='Pending'
                    AND Approval_Deadline__c>:systemNow.addDays(1) AND Approval_Deadline__c<:systemNow.addDays(2)
                   ];
        
        
        
        Set<Id> setQuote = (new Map<Id, SBQQ__Quote__c>([SELECT Id FROM SBQQ__Quote__c 
                                                         WHERE Approval_Stage__c IN (1,2,3) AND Approval_Status__c='Pending'
                                                         AND Approval_Deadline__c>:systemNow.addDays(1) AND Approval_Deadline__c<:systemNow.addDays(2)
                                                        ])).keySet();
        //    system.debug('setQuote--> ' + setQuote );
        Set<Id> setProcessInstance = (new Map<Id, ProcessInstance>([SELECT Id,Status,TargetObjectId FROM ProcessInstance where Status='Pending' and TargetObjectId in :setQuote AND ProcessDefinition.DeveloperName='CPQ_Margin_Approval_Process'])).keySet();
        //    system.debug('setProcessInstance--> ' + setProcessInstance );
        Set<Id> setInstanceWorkitems = (new Map<Id, ProcessInstanceWorkitem>([SELECT Id,ProcessInstanceId FROM ProcessInstanceWorkitem WHERE ProcessInstanceId in :setProcessInstance])).keySet();
        //     system.debug('setInstanceWorkitems--> ' + setInstanceWorkitems );
        
        List<Approval.ProcessWorkitemRequest> requests = new List<Approval.ProcessWorkitemRequest>();
        for (Id pInstanceWorkitemsId:setInstanceWorkitems){
            Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
            req.setComments('The Quote is rejected because it was not approved within 2 business days.');
            req.setAction('Reject');
            req.setWorkitemId(pInstanceWorkitemsId);
            requests.add(req);
            
        }
        Approval.ProcessResult[] processResults = Approval.process(requests);
        
        for (SBQQ__Quote__c qt:lstQuote){
            qt.ScheduledRejectComment__c = 'The Quote is rejected because it was not approved within 2 business days.';
        } 
        update lstQuote;
    }
}