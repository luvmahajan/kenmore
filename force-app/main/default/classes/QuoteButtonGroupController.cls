public class QuoteButtonGroupController {
    public String quoteId {get; set;}
//    public String recordtype {get; set;}
    public String status {get; set;}
    public Boolean renLock {get; set;}
    public Boolean isAccountTaxExempted {get; set;}
    public String salesRep {get; set;}
    
    public Boolean renOrder {get; set;}
//    public Boolean renSignMessage {get; set;}
    public Boolean renPOMessage {get; set;}
    public Boolean renPrimaryMessage {get; set;}
    public Boolean renAddressValidation {get; set;}
    
 //   public QuoteButtonGroupController(ApexPages.StandardController Controller){
            public QuoteButtonGroupController(){
        //    
        status = '';
//        recordtype = '';
//        recordtype = 'Commercial - Flow Business';
        renLock = true;
        isAccountTaxExempted = false;
        salesRep = '';
        renOrder = false;
//        renSignMessage = false;
        renPOMessage = false;
        renPrimaryMessage = false;
        renAddressValidation = false;
        //    
        quoteId = ApexPages.CurrentPage().getparameters().get('id');
        
        List<SBQQ__Quote__c> lstQuote = new List<SBQQ__Quote__c>();
        
        lstQuote = [SELECT Id, Name, SBQQ__Status__c, RecordType.Name, Approval_Status__c,SBQQ__SalesRep__c, SBQQ__Opportunity2__c, SBQQ__Primary__c, 
                    	Sales_Rep_Manager__c, Sales_Rep_Manager_2__c, Sales_Rep_Manager_3__c, isAccountTaxExempted__c, Purchase_Number__c, isValidAddress__c
                    FROM SBQQ__Quote__c
                    WHERE ID =: quoteId
                    LIMIT 1
                   ];
        
                string profile_sysadmin = '';
        List<Profile> lstProfile = new List<Profile>();
        lstProfile = [SELECT Id, Name FROM Profile WHERE Name='System Administrator' LIMIT 1];
        if(lstProfile.size()>0){
            profile_sysadmin = lstProfile[0].Id;
        }
                
                
                
        if(lstQuote.size()>0){
            status = lstQuote[0].SBQQ__Status__c;
 //           recordtype = lstQuote[0].RecordType.Name;
            isAccountTaxExempted = lstQuote[0].isAccountTaxExempted__c;
            salesRep = lstQuote[0].SBQQ__SalesRep__c;
            /*
        system.debug('lstQuote[0].Approval_Status__c --> ' + lstQuote[0].Approval_Status__c );
        system.debug('lstQuote[0].Sales_Rep_Manager__c --> ' + lstQuote[0].SBQQ__SalesRep__c );
        system.debug('lstQuote[0].Sales_Rep_Manager__c --> ' + lstQuote[0].Sales_Rep_Manager__c );
        system.debug('lstQuote[0].Sales_Rep_Manager_2__c --> ' + lstQuote[0].Sales_Rep_Manager_2__c );
        system.debug('lstQuote[0].Sales_Rep_Manager_3__c --> ' + lstQuote[0].Sales_Rep_Manager_3__c );
        system.debug('UserInfo.getUserId() --> ' + UserInfo.getUserId() );
        system.debug('UserInfo.getProfileId() --> ' + UserInfo.getProfileId() );
        system.debug('profile_sysadmin --> ' + profile_sysadmin );
*/
   //         if(lstQuote[0].Approval_Status__c=='Pending' && lstQuote[0].Sales_Rep_Manager__c != UserInfo.getUserId() 
            if(lstQuote[0].SBQQ__Status__c=='Approval' && lstQuote[0].Sales_Rep_Manager__c != UserInfo.getUserId() 
               && lstQuote[0].Sales_Rep_Manager_2__c != UserInfo.getUserId() && lstQuote[0].Sales_Rep_Manager_3__c != UserInfo.getUserId() 
               && userinfo.getProfileId()!= profile_sysadmin 
              ){
        		renLock = false;
            }
            
         /*                       
        List<User> lstUser = new List<User>();
        lstUser = [SELECT Id, Name, Manager.Name 
                   FROM User 
                   WHERE isActive = true AND (Manager.Name = 'Ken Crowne' OR Name = 'Ken Crowne' ) AND Id =: system.UserInfo.getUserId() 
                   LIMIT 1
                  ];
                
            
            List<Attachment> lstAttachmentQuote = new List<Attachment>();
            lstAttachmentQuote = [SELECT Id, ParentId, Name, ContentType, Body 
                             FROM Attachment 
                       //      WHERE ParentId='a2bW0000000kNKTIA2'
                             WHERE Name LIKE '%(signed).pdf' AND ParentId=:lstQuote[0].Id
                             ORDER BY CreatedDate DESC
                             LIMIT 1
                            ];
            
            List<Attachment> lstAttachmentOpportunity = new List<Attachment>();
            lstAttachmentOpportunity = [SELECT Id, ParentId, Name, ContentType, Body 
                             FROM Attachment 
                       //      WHERE ParentId='a2bW0000000kNKTIA2'
                             WHERE Name LIKE '%(signed).pdf' AND ParentId=:lstQuote[0].SBQQ__Opportunity2__c
                             ORDER BY CreatedDate DESC
                             LIMIT 1
                            ];
            
        system.debug('lstUser--> ' + lstUser );
        system.debug('lstAttachmentQuote--> ' + lstAttachmentQuote );
        system.debug('lstAttachmentOpportunity--> ' + lstAttachmentOpportunity );
            */
            
             //    if((lstUser.size()==0 && (lstAttachmentQuote.size()>0 || lstAttachmentOpportunity.size()>0 )) || lstQuote[0].Purchase_Number__c==null || lstQuote[0].Purchase_Number__c=='' ){
             //    if((lstUser.size()>0 || lstAttachmentQuote.size()>0 || lstAttachmentOpportunity.size()>0 ) && lstQuote[0].Purchase_Number__c!=null && lstQuote[0].Purchase_Number__c!='' ){
             //    if((userinfo.getProfileId()== profile_sysadmin || recordtype == 'Commercial - Flow Business' || lstUser.size()>0 || lstAttachmentQuote.size()>0 || lstAttachmentOpportunity.size()>0 ) && lstQuote[0].Purchase_Number__c!=null && lstQuote[0].Purchase_Number__c!='' && lstQuote[0].SBQQ__Primary__c==true ){
                 if( lstQuote[0].Purchase_Number__c!=null && lstQuote[0].Purchase_Number__c!='' && lstQuote[0].SBQQ__Primary__c==true && lstQuote[0].isValidAddress__c==true  ){
                    renOrder = true;
                 }else{
                     if(lstQuote[0].SBQQ__Primary__c==false){
                         renPrimaryMessage = true;
                     }
                     if(lstQuote[0].Purchase_Number__c==null || lstQuote[0].Purchase_Number__c==''){
                         renPOMessage = true;
                     }
                     if(lstQuote[0].isValidAddress__c==false){
                         renAddressValidation = true;
                     }
              //       if(userinfo.getProfileId()== profile_sysadmin || recordtype == 'Commercial - Flow Business' || lstUser.size()==0  && lstAttachmentQuote.size()==0 && lstAttachmentOpportunity.size()==0 ){
              //       if(userinfo.getProfileId()!= profile_sysadmin && recordtype != 'Commercial - Flow Business' && lstUser.size()==0 && lstAttachmentQuote.size()==0  ){
              //           renSignMessage = true;
              //       }
                 }
        system.debug('renOrder--> ' + renOrder );
        system.debug('renPOMessage--> ' + renPOMessage );
        system.debug('renPrimaryMessage--> ' + renPrimaryMessage );
        system.debug('renAddressValidation--> ' + renAddressValidation );
 //       system.debug('renSignMessage--> ' + renSignMessage );
            
        }
        		
        system.debug('status--> ' + status );
                
        system.debug('renLock--> ' + renLock );
    //          renLock = false;                  
    //    system.debug('renLock--> ' + renLock );
    }
    
    public PageReference gotoQuoteLineEditor(){
   //     PageReference retURL = new PageReference('/apex/QuoteLineEditor?id=' + quoteId );
        PageReference retURL = new PageReference('/apex/AddressValidation?id=' + quoteId );
        retURL.setRedirect(true);
        return retURL;
        //   return null;
    }
    
    public PageReference gotoGeocode(){
        
        List<SBQQ__Quote__c> lstQuoteAddr = new List<SBQQ__Quote__c>();
        
        lstQuoteAddr = [SELECT Id, Name, isValidAddress__c
                    FROM SBQQ__Quote__c
                    WHERE ID =: quoteId
                    LIMIT 1
                   ];
        
        if(lstQuoteAddr.size()>0){
            for(SBQQ__Quote__c qa:lstQuoteAddr){
                if(qa.isValidAddress__c==true){
                    qa.isValidAddress__c = false;
                }
            }
        }
        
        update lstQuoteAddr;
        
   //     PageReference retURL = new PageReference('/apex/QuoteLineEditor?id=' + quoteId );
        PageReference retURL = new PageReference('/apex/AddressValidation?id=' + quoteId );
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
   //     PageReference retURL = new PageReference('/apex/OrderQuote?id=' + quoteId );
        PageReference retURL = new PageReference('/apex/QuoteCredit?id=' + quoteId );
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
    
    public PageReference gotoQuoteAttachment(){
        PageReference retURL = new PageReference('/ui/content/ViewAllNotesPage?id=' + quoteId );
        retURL.setRedirect(true);
        return retURL;
    }
    
    public PageReference gotoApprovalProcess(){
        
        Approval.ProcessSubmitRequest req1 = 
            new Approval.ProcessSubmitRequest();
        req1.setComments('Submitting request for approval.');
        req1.setObjectId(quoteId);
        
        // Submit on behalf of a specific submitter
        req1.setSubmitterId(salesRep); 
        
        // Submit the record to specific process and skip the criteria evaluation
        req1.setProcessDefinitionNameOrId('Tax_Exempt_Approval');
        req1.setSkipEntryCriteria(true);
        
        // Submit the approval request for the account
        if(!Test.isRunningTest()){
        	Approval.ProcessResult result = Approval.process(req1);
        	System.debug(result);
        }
        
  //      PageReference retURL = new PageReference('/ui/content/ViewAllNotesPage?id=' + quoteId );
  //      retURL.setRedirect(true);
  //      return retURL;
        return null;
    }
    
    
    
}