public class ContractButtonGroupController {
    public String contractId {get; set;}
    public String status {get; set;}
    public Boolean approval_status {get; set;}
    public Boolean renLock {get; set;}
    public Boolean renOnboarded {get; set;}
    public Boolean renPermission {get; set;}
    
            public ContractButtonGroupController(){
        status = '';
        approval_status = false;
        renLock = true;
        renOnboarded = false;
        renPermission = true;
                
                
        contractId = ApexPages.CurrentPage().getparameters().get('id');
        
        List<Contract> lstContract = new List<Contract>();
        
        lstContract = [SELECT Id, Name, Status, Submitted_for_Approval__c, Approval_Status__c, Legal_Approver__c, Onboarded__c
                       FROM Contract
                       WHERE ID =: contractId
                       LIMIT 1
                      ];
        
                string profile_sysadmin = '';
        List<Profile> lstProfile = new List<Profile>();
        lstProfile = [SELECT Id, Name FROM Profile WHERE Name='System Administrator' LIMIT 1];
        if(lstProfile.size()>0){
            profile_sysadmin = lstProfile[0].Id;
        }
         
                boolean isPS_CPQAll = false;
        List<PermissionSetAssignment> lstPSA = new List<PermissionSetAssignment >();
        lstPSA = [SELECT Id, PermissionSetId, PermissionSet.Name, AssigneeId FROM PermissionSetAssignment WHERE AssigneeId=:userinfo.getUserId() AND PermissionSet.Name='Lightning_CPQ'  LIMIT 1 ];
        if(lstPSA.size()>0){
            isPS_CPQAll = true;
        }
                
                
                
        if(lstContract.size()>0){
        //    renOnboarded = true;
            renOnboarded = lstContract[0].Onboarded__c;
            status = lstContract[0].Status;
        	approval_status = lstContract[0].Submitted_for_Approval__c; 
            if(lstContract[0].Approval_Status__c=='Pending' && lstContract[0].Legal_Approver__c != UserInfo.getUserId() 
               && userinfo.getProfileId()!= profile_sysadmin
              ){
        		renLock = false;
            }
            if(userinfo.getProfileId()!= profile_sysadmin && !isPS_CPQAll
              ){
        		renPermission = false;
            }
        }
        
        system.debug('renOnboarded--> ' + renOnboarded );
        system.debug('renLock--> ' + renLock );
        system.debug('status--> ' + status );
        system.debug('approval_status--> ' + approval_status );
             
                
                
                
                
    }
    
    public PageReference gotoContractAttachment(){
        PageReference retURL = new PageReference('/ui/content/ViewAllNotesPage?id=' + contractId );
        retURL.setRedirect(true);
        return retURL;
    }
    
    public PageReference gotoContractRider(){
        PageReference retURL = new PageReference('/apex/ContractRiderBuilder?id=' + contractId );
        retURL.setRedirect(true);
        return retURL;
    }
    
    public PageReference gotoForecast(){
        PageReference retURL = new PageReference('/lightning/r/' + contractId + '/related/Web_Forecasts__r/view' );
        retURL.setRedirect(true);
        return retURL;
    }
    
    public PageReference gotoCreateOrder(){
        PageReference retURL = new PageReference('/apex/OrderSelection?id=' + contractId );
        retURL.setRedirect(true);
        return retURL;
    }
    
    public PageReference gotoCustomerSign(){
   //     PageReference retURL = new PageReference('/apex/cuda_signnow__signnow_templates?id={!contractId}&type=Contract&view=attachments');
   //     PageReference retURL = new PageReference('/apex/cuda_signnow__signnow_templates?id=' + contractId + '&type=Contract&view=attachments');
  //      PageReference retURL = new PageReference('/apex/cuda_signnow__signnow_templates?id=' + contractId + '&type=Contract&view=attachment-group&redirect=true');
        //     PageReference retURL = new PageReference('/apex/cuda_signnow__signnow_templates?id=' + contractId + '&type=Contract&view=attachment-group&redirect=true');
       
        PageReference retURL = new PageReference('/apex/cuda_signnow__signnow_templates?id=' + contractId + '&type=Contract&view=merge-attachments&redirect=true');
        retURL.setRedirect(true);
        return retURL;
    }
    
    public PageReference gotoCustomerSign2(){
   //     PageReference retURL = new PageReference('/apex/cuda_signnow__signnow_templates?id={!contractId}&type=Contract&view=attachments');
   //     PageReference retURL = new PageReference('/apex/cuda_signnow__signnow_templates?id=' + contractId + '&type=Contract&view=attachments');
        PageReference retURL = new PageReference('/apex/cuda_signnow__signnow_templates?id=' + contractId + '&type=Contract&redirect=true&template_id=d72a7e6db74b35eb5cc7c590d11ee6eade57363c');
        retURL.setRedirect(true);
     //   return retURL;
        return null;
    }
    
    public PageReference gotoApproval(){
        
        List<Contract> lstContractUpdate = new List<Contract>();
        
        lstContractUpdate = [SELECT Id, Name, Status, Submitted_for_Approval__c
                       FROM Contract
                       WHERE ID =: contractId
                       LIMIT 1
                      ];
        
        if(lstContractUpdate.size()>0){        
        for(Contract cu:lstContractUpdate){
            if(!cu.Submitted_for_Approval__c){
                cu.Submitted_for_Approval__c = true;
            }
        }
            update lstContractUpdate;
        }
        
   //     PageReference retURL = new PageReference('/apex/cuda_signnow__signnow_templates?id={!contractId}&type=Contract&view=attachments');
        PageReference retURL = new PageReference('/' + contractId);
        retURL.setRedirect(true);
     //   return retURL;
        return null;
    }
    
    
    /*
    public PageReference gotoQuoteLineEditor(){
        PageReference retURL = new PageReference('/apex/QuoteLineEditor?id=' + quoteId );
        retURL.setRedirect(true);
        return retURL;
        //   return null;
    }
    
    public PageReference gotoGenerateDocument(){
        PageReference retURL = new PageReference('/apex/SBQQ__GenerateDocument?id=' + quoteId );
//        PageReference retURL = new PageReference('/apex/SBQQ__GenerateDocument?scontrolCaching=1&id='+ quoteId);
//        PageReference retURL = new PageReference('/apex/GenerateDocument' );
        retURL.setRedirect(true);
        return retURL;
        //   return null;
    }
    
    public PageReference gotoQuoteOrder(){
        PageReference retURL = new PageReference('/apex/OrderQuote?id=' + quoteId );
        retURL.setRedirect(true);
        return retURL;
        //   return null;
    }
    
    public PageReference gotoQuoteContract(){
        PageReference retURL = new PageReference('/apex/OrderQuote?id=' + quoteId );
        retURL.setRedirect(true);
        return retURL;
        //   return null;
    }
    */
    
}