// External Callout handler class 

public class CalloutB2BAPI {
    
    @testVisible final static String INVALID_RESPONSE = 'Invalid Response';
    @testVisible final static String CALLOUT_EXCEPTION = 'Callout Exception';
    @testVisible final static String NO_CONTENT = 'No Content';
    
    
    public class ResponseWrapper {
        public HttpResponse Response;
        public String message;
        public ResponseWrapper(HttpResponse Response, String message ){
            this.Response = Response;
            this.message = message;
        }
    }
    
    public static ResponseWrapper execute(HttpRequest request){
        
        
        HttpResponse Response;
        String message = INVALID_RESPONSE;
        Http http = new Http();
        
        try {
            Response = http.send(request);
            system.debug( 'Response= ' +Response);
         /*   
Long startTime = DateTime.now().getTime();
Long finishTime = DateTime.now().getTime();
while ((finishTime - startTime) < 1000) {
    finishTime = DateTime.now().getTime();
}
System.assertEquals(Integer.valueOf((finishTime - startTime) / 1000), 1);
System.debug('>>> Done from ' + startTime + ' to ' + finishTime);
*/
       
//        PageReference retURL = new PageReference('/' + quoteId );
//        retURL.setRedirect(true);
//        return retURL;
                message = Response.getBody();
            System.debug('message: '+ message);
            if((Response.getStatus() == 'OK' && Response.getStatusCode() == 200) || Response.getStatusCode() == 201  ){
                message = '';
            }else if(Response.getStatusCode() == 204) { // No Content 
                message = NO_CONTENT;
            }else{
                message = Response.getBody();
            }
            System.debug('message: '+ message);
            
        } catch(System.CalloutException e) {
            System.debug('Callout error: '+ e);
      //      System.debug(response.toString());
            message = CALLOUT_EXCEPTION + ':'+ e.getMessage();
        } catch(System.Exception general) {
            message = general.getMessage();
        } 
 
        ResponseWrapper RW = new ResponseWrapper(Response, message);
        return RW;
        
    }
}