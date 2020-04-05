public class OpportunityButtonGroupController {
    public String opportunityId {get; set;}
    public String recordtype {get; set;}
    public String stage {get; set;}
            
    public OpportunityButtonGroupController(){
        stage = '';
        recordtype = '';
        recordtype = 'Commercial - Flow Business';
        
        opportunityId = ApexPages.CurrentPage().getparameters().get('id');
        
        List<Opportunity> lstOpportunity = new List<Opportunity>();
        
        lstOpportunity = [SELECT Id, Name, StageName, RecordType.Name, RecordTypeId 
                          FROM Opportunity
                          WHERE ID =: opportunityId
                          LIMIT 1
                         ];
        
        if(lstOpportunity.size()>0){
            stage = lstOpportunity[0].StageName;
            recordtype = lstOpportunity[0].RecordType.Name;
        }
        
    }
    
    public PageReference gotoMSASign(){
   //     PageReference retURL = new PageReference('/apex/cuda_signnow__signnow_templates?id={!contractId}&type=Contract&view=attachments');
   //     PageReference retURL = new PageReference('/apex/cuda_signnow__signnow_templates?id=' + contractId + '&type=Contract&view=attachments');
   //     PageReference retURL = new PageReference('/apex/cuda_signnow__signnow_templates?id=' + contractId + '&type=Contract&view=attachment-group&redirect=true');
   //     PageReference retURL = new PageReference('/apex/cuda_signnow__signnow_templates?id=' + contractId + '&type=Contract&view=merge-attachments&redirect=true');
        PageReference retURL = new PageReference('/apex/cuda_signnow__signnow_templates?id=' + opportunityId + '&type=Opportunity&view=attachments');
        retURL.setRedirect(true);
        return retURL;
    }
    
    
    
}