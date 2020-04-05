public class RouteDeliveryController {
    public String quoteId {get; set;}

    public RouteDeliveryController(){
        quoteId = ApexPages.CurrentPage().getparameters().get('id');        
    }
    
    public PageReference redirectQLE()
    {
        PageReference retURL = new PageReference('/apex/DemarCharges?id=' + quoteId );
        retURL.setRedirect(true);
        return retURL;
  //     return null;
    }
    
}