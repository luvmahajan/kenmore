public class CreateSCOAccountRequestController {
    public String accountId {get; set;}
    public List<Account> lstAccount {get; set;}
    
    public CreateSCOAccountRequestController(ApexPages.StandardController controller){
        accountId= '1';
        accountId = ApexPages.CurrentPage().getparameters().get('Id');
        system.debug('accountId--> ' + accountId ); 
            
    }
    
    public PageReference redirectButton(){
        system.debug('accountId--> ' + accountId ); 
        
        lstAccount = new List<Account>();
        lstAccount = [SELECT Id, Name, Create_SCO_Account__c, SCO_Account_ID__c FROM Account WHERE Id=: accountId LIMIT 1];
        
        system.debug('lstAccount--> ' + lstAccount ); 
        
        if(lstAccount[0].SCO_Account_ID__c==null ||  lstAccount[0].SCO_Account_ID__c=='' || lstAccount[0].SCO_Account_ID__c=='Processing' ){
            for(Account ac:lstAccount){
                ac.Create_SCO_Account__c = true;
                ac.SCO_Account_ID__c = 'Processing';
         //       ac.B2B_Account_ID__c = 'Processing';
         //       ac.B2B_Account_Request__c = true;
            }
            update lstAccount;
        }
        
        system.debug('lstAccount--> ' + lstAccount ); 
        
        PageReference retURL = new PageReference('/' + accountId );
        retURL.setRedirect(true);
        return retURL;    
   //     return null; 
    }
}