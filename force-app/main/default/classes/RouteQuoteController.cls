public class RouteQuoteController {
    
    public String quoteId {get; set;}
    
    public RouteQuoteController() {
        quoteId = ApexPages.CurrentPage().getparameters().get('id');
        
    }  
    
    public PageReference redirectQLE()
    {
        

Long startTime = DateTime.now().getTime();
Long finishTime = DateTime.now().getTime();
while ((finishTime - startTime) < 2000) {
    finishTime = DateTime.now().getTime();
}
System.assertEquals(Integer.valueOf((finishTime - startTime) / 1000), 2);
System.debug('>>> Done from ' + startTime + ' to ' + finishTime);

       
        PageReference retURL = new PageReference('/' + quoteId );
        retURL.setRedirect(true);
        return retURL;
    }
    
    

}