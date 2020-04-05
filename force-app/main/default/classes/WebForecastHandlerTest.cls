/**
 * Created by jirala on 2/8/2018.
 */
@isTest
public class WebForecastHandlerTest {

    public static Web_Forecast__c header;
    public static Web_Forecast_Line_Item__c forecastline;

    static void setupData(boolean withitem){
        Zipcode_DDC_RRC__c shiptozip = new Zipcode_DDC_RRC__c(External_ID__c = '1', Name = '60089',
                DOS_Unit__c = '8808', DDC__c = '8721', RRC__c = '449');
        Insert shiptozip;

        FCST_Item_Info__c itemdet_DDC = new FCST_Item_Info__c(
                External_ID_Num__c = '1',
                Division__c = '026',
                Item_Num__c = '026-48232-000',
                MDM_Item__c = '02648232000',
                Item_8721_Stock__c = 'Y',
                Dist_Type__c = 'DD'
                );
        Insert itemdet_DDC;

        FCST_Item_Info__c itemdet_RRC = new FCST_Item_Info__c(
                External_ID_Num__c = '2',
                Division__c = '046',
                Item_Num__c = '046-70339-000',
                MDM_Item__c = '04670339000',
                Item_8721_Stock__c = 'Y',
                Dist_Type__c = 'TW'
        );
        Insert itemdet_RRC;

        Transitions_Item__c transitem = new Transitions_Item__c(
                Ext_Num__c = '1',
                Old_Item__c = '026-51022-000',
                New_Item__c = '026-51122-000'
        );
        Insert transitem;

        //setup test data: Quote header & Line items.
        header = new Web_Forecast__c(
                Week_Start_Date__c = Date.today(),
                Ship_to_Zipcode__c = shiptozip.Id,
                Name = 'Testclass Forecast',
                Sales_Rep_Email__c = 'testclass@test.com',
            	Sales_Rep_Name__c = 'Test Account Manager',
            	Sales_Rep_Number__c = '1234',
            	District_Manager__c = 'Test DM'
        );
        insert header;

        if(withitem){
            forecastline = new Web_Forecast_Line_Item__c(
                    Web_Forecast_Header__c = header.Id,
                    Division__c = '026',
                    Item__c = '48232',
                    Price__c = 50,
                    Qty_Week1__c = 1,
                    Qty_Week2__c = 1,
                    Qty_Week3__c = 1,
                    Qty_Week4__c = 1,
                    Qty_Week5__c = 1,
                    Qty_Week6__c = 1,
                    Qty_Week7__c = 1,
                    Qty_Week8__c = 1,
                    Qty_Week9__c = 1,
                    Qty_Week10__c = 1,
                    Qty_Week11__c = 1,
                    Qty_Week12__c = 1,
                    Qty_Week13__c = 1,
                	Qty_Week14__c = 1,
                	Qty_Week15__c = 1,
                	Qty_Week16__c = 1,
                	Qty_Week17__c = 1,
                	Qty_Week18__c = 1,
                	Qty_Week19__c = 1,
                	Qty_Week20__c = 1,
                	Qty_Week21__c = 1,
                	Qty_Week22__c = 1,
                	Qty_Week23__c = 1,
                	Qty_Week24__c = 1,
                	Qty_Week25__c = 1,
                	Qty_Week26__c = 1
            ); insert forecastline;

            Web_Forecast_Line_Item__c forecastline_RRC = new Web_Forecast_Line_Item__c(
                    Web_Forecast_Header__c = header.Id,
                    Division__c = '046',
                    Item__c = '70339',
                    Price__c = 50,
                    Qty_Week1__c = 1,
                    Qty_Week2__c = 1,
                    Qty_Week3__c = 1,
                    Qty_Week4__c = 1,
                    Qty_Week5__c = 1,
                    Qty_Week6__c = 1,
                    Qty_Week7__c = 1,
                    Qty_Week8__c = 1,
                    Qty_Week9__c = 1,
                    Qty_Week10__c = 1,
                    Qty_Week11__c = 1,
                    Qty_Week12__c = 1,
                    Qty_Week13__c = 1,
                    Qty_Week14__c = 1,
                	Qty_Week15__c = 1,
                	Qty_Week16__c = 1,
                	Qty_Week17__c = 1,
                	Qty_Week18__c = 1,
                	Qty_Week19__c = 1,
                	Qty_Week20__c = 1,
                	Qty_Week21__c = 1,
                	Qty_Week22__c = 1,
                	Qty_Week23__c = 1,
                	Qty_Week24__c = 1,
                	Qty_Week25__c = 1,
                	Qty_Week26__c = 1
            ); insert forecastline_RRC;
        }
    }

    public static testMethod void WebForecastItemTrigger(){
        setupData(false);

        Web_Forecast_Line_Item__c forecastline = new Web_Forecast_Line_Item__c(
                Web_Forecast_Header__c = header.Id,
                Division__c = '026',
                Item__c = '48232',
                Price__c = 50
        );

        Web_Forecast_Line_Item__c forecastline_dupl = new Web_Forecast_Line_Item__c(
                Web_Forecast_Header__c = header.Id,
                Division__c = '026',
                Item__c = '48232',
                Price__c = 50
        );

        Test.startTest();
        Database.SaveResult result = Database.insert(forecastline,false);
        Database.SaveResult result_dupl = Database.insert(forecastline_dupl,false);
        Test.stopTest();

        Web_Forecast_Line_Item__c forecastdet = [select Week1__c, Item_Formatted__c, Item_Dist_Type__c, DDC_Item__c, RRC_Item__c from Web_Forecast_Line_Item__c where Web_Forecast_Header__c = :header.Id];
        //System.assertEquals(forecastdet.Week1__c, '');
        System.assertEquals(forecastdet.Item_Formatted__c, '026-48232-000');
        System.assertEquals(forecastdet.Item_Dist_Type__c, 'DD');
        System.assertEquals(forecastdet.DDC_Item__c, '8721');
        System.assertEquals(forecastdet.RRC_Item__c, '449');

        system.assertEquals(result_dupl.isSuccess(),false,'Duplicate Item check fails');
    }

    //test method for 'View' Forecase item VF Page .
    public static testMethod void ViewWebForecaseItemOverride() {

        setupData(true);
        PageReference pageRef = Page.WebForecastLineItemVF;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('Id', forecastline.Id);
        ApexPages.StandardController stdController = new ApexPages.StandardController(forecastline);
        WebForecastLineItem_Controller custcontroller = new WebForecastLineItem_Controller(stdController);
        PageReference retURL = custcontroller.gotoHeader();
    }

    //test method for 'Edit' Forecase item VF Page .
    public static testMethod void EditWebForecaseItemOverride() {

        setupData(true);
        PageReference pageRef = Page.WebForecastLineItemVF;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('Id', forecastline.Id);
        ApexPages.currentPage().getParameters().put('retUrl', header.Id);
        ApexPages.StandardController stdController = new ApexPages.StandardController(forecastline);
        WebForecastLineItem_Controller custcontroller = new WebForecastLineItem_Controller(stdController);
        PageReference retURL = custcontroller.gotoHeader();
    }

    //test method for 'Create' Forecase item VF Page .
    public static testMethod void CreateWebForecaseItemOverride() {

        setupData(true);
        PageReference pageRef = Page.WebForecastLineItemVF;
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController stdController = new ApexPages.StandardController(forecastline);
        WebForecastLineItem_Controller custcontroller = new WebForecastLineItem_Controller(stdController);
        PageReference retURL = custcontroller.gotoHeader();
    }

    //test method for VF Page button to generate email on web forecasting.
    public static testMethod void GenerateFiles_Email_VF() {

        setupData(true);
        List<Contact> Contacts = TestDataFactory.createContacts(1);
        Contacts[0].Email = 'test@testmail.com';
        insert Contacts;

        PageReference pageRef = Page.WebForecastEmailFiles;
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController stdController = new ApexPages.StandardController(header);
        WebForecastEmailConfirmation custcontroller = new WebForecastEmailConfirmation(stdController);
        PageReference retURL = custcontroller.EmailandAttach();


    }

}