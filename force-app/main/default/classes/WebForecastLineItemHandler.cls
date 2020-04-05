public class WebForecastLineItemHandler implements ITrigger {
    
    
    public void bulkBefore(){
        
    }
    
    public void bulkAfter(){
        
    }
    
    public void beforeInsert(Sobject obj){
        
        Web_Forecast_Line_Item__c fli = (Web_Forecast_Line_Item__c) obj;
        system.debug ('in handler class');
        ForecastItemValidations.ForecastItemBeforeValidations(fli);
        
    }
    
    public void beforeUpdate(Sobject oldObj, Sobject newObj){
        Web_Forecast_Line_Item__c fli = (Web_Forecast_Line_Item__c) newObj;
        system.debug ('in handler class');
        ForecastItemValidations.ForecastItemBeforeValidations(fli);
    }
     
    public  void beforeDelete(Sobject obj){
        
    }
    
    public void afterInsert(Sobject obj){
        
    }
    
    public void afterUpdate(Sobject oldObj, Sobject newObj){
        
    }
    
    public void afterDelete(Sobject obj){
        
    }
    
    public void andFinally() {}
}