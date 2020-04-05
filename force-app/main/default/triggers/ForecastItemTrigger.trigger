trigger ForecastItemTrigger on Web_Forecast_Line_Item__c (before insert, before update, before delete, after insert, after update, after delete) {
    
    TriggerFactory.createHandler(Web_Forecast_Line_Item__c.sObjectType);

}