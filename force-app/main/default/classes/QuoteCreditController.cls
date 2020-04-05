public class QuoteCreditController {
    
    public String quoteId {get; set;}
    public String selectedPayment {get; set;}
    public Boolean isOnboarded {get; set;}
    public Map<String,String> mapPaymentType {get; set;}
    public List<String> lstPaymentType {get; set;}
    
    
    public QuoteCreditController(ApexPages.StandardController Controller){
        quoteId = ApexPages.CurrentPage().getparameters().get('id');
        selectedPayment = '';
        isOnboarded = false;
        
        lstPaymentType = new List<String>();
        lstPaymentType.add('Information');
        lstPaymentType.add('Credit Card');
        lstPaymentType.add('Check');
        lstPaymentType.add('Credit Account');
        
        
        /*
        //    String actCard = 'Inform the customer that they will need to enter their credit card information at this link: http://www.thisthing.com ';
        String actCard = '<div>Inform the customer that they will need to enter their&nbsp;</div>' 
            			+ '<div>credit card information at this link:&nbsp;</div>'
            			+ '<div><a href="https://www.kenmoredirect.com/">https://www.kenmoredirect.com/</a></div>';
        String actCheck = '<div>Offer the customer the option to call this number to use</div>' 
            			+ '<div>our &quot;Check by Phone&quot; service or give them this</div>' 
            			+ '<div>address to mail their Check into us.</div>' 
            			+ '<div>1235 Maple Ave. Augusta GA 72054</div>';
        String actAccount = '<div>Inform customer we will be sending them a credit</div>' 
            				+ '<div>application. They can eSign the application or mail</div>'
            				+ '<div>into this address</div>'
            				+'<div>1235 Maple Ave. Augusta GA 30805</div>';
*/        
        
        String actInfo = '<div>You have reached the screen because the customer has not been verified for&nbsp;</div>' 
            			+ '<div>CPQ. Make sure the customer account has an SCO Account number and then&nbsp;</div>'
            			+ '<div>check the onboard box on the account. If a default payment method exists on&nbsp;</div>'
            			+ '<div>the B2B system it will be used for all orders from CPQ. If not, the order will be&nbsp;</div>'
            			+ '<div>parked in B2B until a payment method is added.</div>';
        String actCard = '<div>A default Credit Card can be set by the customer through&nbsp;</div>' 
            			+ '<div><a href="https://www.kenmoredirect.com/">https://www.kenmoredirect.com/</a> or via the credit team if Commercial One or&nbsp;</div>'
            			+ '<div>Commercial Pro accounts.</div>';
        String actCheck = '<div>Customers paying by check:&nbsp;</div>' 
            			+ '<div style="color:#194E7C"><b>Check Mailing Address:&nbsp;</b></div>'
            			+ '<div style="color:#194E7C">TransformCo / Kenmore Direct&nbsp;</div>'
            			+ '<div style="color:#194E7C">C/O Financial Operations&nbsp;</div>'
            			+ '<div style="color:#194E7C">2417 Regency Blvd, Ste 6&nbsp;</div>'
            			+ '<div style="color:#194E7C">Augusta GA 30904&nbsp;</div>'
            			+ '<div style="color:#194E7C">(Contact <a href="mailto:cscrdt@searshc.com">cscrdt@searshc.com</a> for wire information)</div>';
        String actAccount = '<div>Provide customer with Commercial Pro application and send to&nbsp;</div>' 
            			+ '<div><a href="mailto:cscrdt@searshc.com">cscrdt@searshc.com</a></div>';
        
        mapPaymentType = new Map<String,String>();
        mapPaymentType.put('Information', actInfo);
        mapPaymentType.put('Credit Card', actCard);
        mapPaymentType.put('Check', actCheck);
        mapPaymentType.put('Credit Account', actAccount);
        
        List<SBQQ__Quote__c> lstQuote = new List<SBQQ__Quote__c>();
        lstQuote = [SELECT Id, Onboarded__c FROM SBQQ__Quote__c WHERE Id=:quoteId LIMIT 1];
        if(lstQuote.size()>0){
            isOnboarded = lstQuote[0].Onboarded__c;
        }

        
    }
    
    public PageReference redirectQLE(){
        if(isOnboarded){
  //      PageReference retURL = new PageReference('/apex/OrderQuote?id=' + quoteId );
        PageReference retURL = new PageReference('/apex/OrderAvailability?id=' + quoteId );
        retURL.setRedirect(true);
            return retURL;
        }
        return null;
    }
    
    public PageReference actionSend(){
        system.debug('selectedPayment--> ' + selectedPayment );
        if(selectedPayment=='Check' || selectedPayment=='Credit Card' ){
       //     PageReference retURL = new PageReference('/apex/OrderQuote?id=' + quoteId + '&pay=' + selectedPayment );
            PageReference retURL = new PageReference('/apex/OrderAvailability?id=' + quoteId + '&pay=' + selectedPayment );
            retURL.setRedirect(true);
            return retURL;
        }else{
        PageReference retURL = new PageReference('https://www.kenmoredirect.com/' );
            retURL.setRedirect(true);
            return retURL;
        }
    }    
    
    public PageReference actionCancel(){
        PageReference retURL = new PageReference('/' + quoteId );
        retURL.setRedirect(true);
        return retURL;
    }
    
    public PageReference actionSelected() {
        selectedPayment = '';
        selectedPayment = System.currentPageReference().getParameters().get('pay');
        system.debug('selectedPayment --> ' + selectedPayment );
        return null;
    }
    
    
}