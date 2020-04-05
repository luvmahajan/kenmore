/**
 * Created by jirala on 2/6/2018.
 */

public with sharing class WebForecastLineItem_Controller {

    private ApexPages.StandardController con;
    public List<String> Weeklabels {get;set;}
    public Id HeaderId;
    public Id LineItemId;
    public String retURL;
    public String mode {get;set;}

    public WebForecastLineItem_Controller(ApexPages.StandardController controller) {
        con = controller;

        LineItemId = ApexPages.currentPage().getParameters().get('Id');
        map<string, string> pageParameters = ApexPages.currentPage().getParameters();

        if(LineItemId == null){
            // NEW (create mode)
            mode = 'edit';
            HeaderId = ApexPages.currentPage().getParameters().get(Label.WebforecastHeaderFieldId);
        } else if(pageParameters.get('retUrl') != null){
            // Update (Edit mode)
            mode = 'edit';
            Web_Forecast_Line_Item__c item = [SELECT Id,Web_Forecast_Header__c  FROM Web_Forecast_Line_Item__c where Id = :LineItemId];
            HeaderId = item.Web_Forecast_Header__c;
        } else {
            mode = 'view';
            Web_Forecast_Line_Item__c item = [SELECT Id,Web_Forecast_Header__c FROM Web_Forecast_Line_Item__c where Id = :LineItemId];
            HeaderId = item.Web_Forecast_Header__c;
        }
        System.debug('####mode--> '+mode);
        retURL = ApexPages.currentPage().getParameters().get('retURL');

        if(retURL == null)retURL = '/'+HeaderId;

        system.debug('ApexPages.currentPage().getParameters()-->'+ApexPages.currentPage().getParameters());
        system.debug('ApexPages.currentPage()-->'+ApexPages.currentPage());

        if(HeaderId != null){
            Web_Forecast__c header = [select Id, Week1__c from Web_Forecast__c where Id = :HeaderId];
            Weeklabels = new  List<String>();
            for (Integer i = 0; i <= 25; i++) {
                Weeklabels.add('Week '+(i+1)+' ('+header.Week1__c.addDays(7*i).format()+')');
            }
        }
    }
     public PageReference gotoHeader(){
        PageReference RetPage = new PageReference(retURL);
        RetPage.setRedirect(true);
        return RetPage;
    }
}