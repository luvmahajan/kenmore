public with sharing class AccountDetailPage2Controller{
  
    public Account account_object {get; set;}
    public Id account_Id {get; set;}
    public Boolean render {get; set;}
   
    
    //Constructor
    public AccountDetailPage2Controller(ApexPages.StandardController controller){
        render = true;
        account_object = new Account();
        account_Id = ApexPages.currentPage().getParameters().get('Id');
        String message = '' + ApexPages.currentPage().getParameters().get('message');
        System.debug('*****' + message);
        if(String.isNotBlank(message) || message != 'null'){
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Error, message));
        }
        account_object.Id = account_Id;
        //'001V000000Irogu';
        /*===================================================ACCOUNT DETAILS========================================================*/
        account_object = [SELECT Id, Name, Nickname__c, Parent.Name, Owner.Name, SAP_Account_ID__c, Territory_ID__c,
                                 Potential_Annual_Sales_Volume__c, Business_Sector__c, Industry_Segment__c, Industry_Segmentation__c,
                                 SAP_NAICS_Code__c, Type, Business__c, Phone, Fax, Website, Description,
                                 Site, AccountSource, BillingStreet, BillingCity,  BillingState, BillingPostalCode, 
                                 BillingCountry, Is_Project__c, Credit_Needed__c, Reseller__c, Tax_Exempt__c, Operational_Group__c, 
                                 Customer_Group__c, Customer_Group_1__c, Customer_Group_2__c, Customer_Group_3__c, Customer_Group_4__c, 
                                 Price_List_Type__c, Credit_Type__c, Language__c, Terms_of_Payment__c, 
                                 SAP_Account_Request_DateTime_C__c, Customer_Pricing_Procedure__c, Name_3__c, Incoterms_1__c, 
                                 Name_4__c, Incoterms_2__c, SAP_Notes__c, Role__c, Reporting_Group__c, Account_Assignment_Group__c, 
                                 WCEM_Customer_Categorization__c, Relevant_for_Rebate__c, Billing_Block_Reason__c, 
                                 External_BP_Number__c, Delivery_Block_Reason__c, Central_Block__c, Archived__c,
                                 Transaction_Block_Reason__c, SFDC_ID__c, Commercial_Credit_Status__c, GPO__c, DEA_Number__c, 
                                 HIN__c, Corporate_Group__c, IDN_Group__c, Affiliate_Group__c, GLN__c, 
                                 Check_if_RepONE_is_the_reporting_Group__c, Account_Full_Legal_Name__c, Line_of_Credit_Requested__c, 
                                 Territory_Manager_OLD__c, Target_Customer__c, Sales_Representative_OLD__c, Inside_Sales_OLD__c, 
                                 NumberOfEmployees, Territory__c, AnnualRevenue, Territory_Manager__c, Notes__c, 
                                 Sales_Representative__c, Has_Parent__c, Inside_Sales__c, Planned_units_in_the_next_12_months__c, 
                                 Where_do_you_buy_the_products__c, What_is_your_average_spend_per_unit__c, Current_Provider__c, 
                                 What_brand_of_appliances_are_you_using__c, Customer_Status__c, Brand_Of_Competitor_Working_With__c, 
                                 Reasons_For_Not_Working_With_SC__c, Brand_Of_Distributor_Working_With__c, 
                                 Reasons_For_Switching_To_The_Competition__c, Segment_Description__c, SCOPES_ID__c, 
                                 Pricing_Assignment__c, Special_Notes_or_Delivery_Information__c, Final_Credit_Response__c, 
                                 Credit_Comments__c, Final_Line_of_Credit__c, Initial_Requests_Completed__c, YTD_Sales__c, 
                                 F2013_Sales__c, F2012_Sales__c, F2011_Sales__c, Sync_with_SAP__c, SAP_Account_Request__c
                          FROM Account
                          WHERE Id = :account_Id];
    }
    
    //Save function
    public pageReference Save1(){
        try{
            update account_object;
        }
        catch(DmlException e){
            System.debug(e);
            ApexPages.getMessages().clear();
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Error, 'An error occured or you do not have the required permission for this account, please try again or contact support for assistance.'));
            render = false;
            return null;
        }
        
        PageReference page_reference_obj_after_save = new PageReference('/apex/UpdateAccountDetails?Id=' +account_Id);
        page_reference_obj_after_save .setRedirect(true);
        
        return page_reference_obj_after_save ;
    }
    
    //Cancel function
    public pageReference Cancel1(){
        PageReference page_reference_obj_after_cancel = new PageReference('/' +account_Id);
        page_reference_obj_after_cancel.setRedirect(true);
        
        return page_reference_obj_after_cancel;
    }
}