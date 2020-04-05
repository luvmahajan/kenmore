public with sharing class UpdateAccountDetailsController{
    
    public Account account_Object {get; set;}
    public String account_Id {get;set;}
    public boolean refPg{get;set;}
    public boolean render{get; set;}
    
    public UpdateAccountDetailsController(){
        account_Id = ApexPages.currentPage().getParameters().get('Id');        
        account_Object = [SELECT AccountSource,Account_Full_Legal_Name__c,BillingAddress,BillingCity,BillingCountry,BillingPostalCode,BillingState,BillingStreet,Billing_Block_Reason__c,Business_Sector__c,
                                    Business__c,Case_Sensitive_18_Digit_Account_ID__c,Check_Customer_Accts_for_SAP_Integration__c,City__c,Credit_Needed__c,Customer_Group_1__c,Customer_Group_2__c,Customer_Group_3__c,
                                    Customer_Group_4__c,Customer_Group__c,Customer_Pricing_Procedure__c,Customer_Status__c,Description,Email_Address__c,Entity_Type__c,Fax,Id,Industry,Industry_Segment__c, Industry_Segmentation__c,
                                    Is_Project__c,Language__c,Lead_Source__c,NAICS_Code__c,Name,Name_2__c,Name_3__c,Name_4__c,Nickname__c,Non_Tax__c,Notes__c,OwnerId,ParentId,Payment_Term__c,Phone,
                                    PhotoUrl,Potential_Annual_Sales_Volume__c,Project__c,RecordTypeId,Reseller__c,Role__c,SAP_Account_ID__c,SAP_Account_Request_DateTime_C__c,SAP_Account_Request__c,
                                    SAP_Flagged_Accounts__c,SAP_Id__c,SAP_Loads__c,SAP_NAICS_Code__c,SAP_Notes__c,Sector__c,SFDC_ID__c,Site,Sync_with_SAP__c,Tax_Exempt__c,Terms_of_Payment__c,
                                    Territory_ID__c,Type,Website 
                            FROM Account WHERE Id = :account_Id];        
        refPg = true;
    }
    
    public pageReference Save(){
        updateObject();
        if(!render){
            ApexPages.getMessages().clear();
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Error, 'An error occured or you do not have the required permission for this account, please try again or contact support for assistance.'));
            return null;
        }
        PageReference save_page_reference = new PageReference('/'+account_Id);
        save_page_reference.setRedirect(true);
        return save_page_reference ;
    }
    
    public pageReference Cancel(){
        PageReference cancel_page_reference = new PageReference('/'+account_Id);
        cancel_page_reference.setRedirect(true);
        return cancel_page_reference;
    }

    public PageReference init(){
        System.debug('****** Start Field Check');
        render = true;
        if(companyFieldsMissing()){
            PageReference editPage = new PageReference('/apex/AccountDetailPage2?Id='+account_Id);
            editPage.setRedirect(true);
            editPage.getParameters().Put('message', 'Please make sure all required fields are populated and try again.');
            System.debug('******' + editPage.getParameters().get('message'));
            return editPage;
        }
        else if (!CommonUtils.checkRegex(CommonUtils.postalCodeRegex, account_Object.BillingPostalCode)){
            PageReference editPage = new PageReference('/apex/AccountDetailPage2?Id='+account_Id);
            editPage.setRedirect(true);
            editPage.getParameters().Put('message', 'Please correct the postal code.');
            return editPage;
        }

        account_Object.Customer_Group__c = String.isBlank(account_Object.Customer_Group__c) ? '01' : account_Object.Customer_Group__c;
        account_Object.Customer_Group_1__c = String.isBlank(account_Object.Customer_Group_1__c) ? '01' : account_Object.Customer_Group_1__c;
        account_Object.Customer_Group_2__c = String.isBlank(account_Object.Customer_Group_2__c) ? '01' : account_Object.Customer_Group_2__c;  
        account_Object.Customer_Group_3__c = String.isBlank(account_Object.Customer_Group_3__c) ? 'ST' : account_Object.Customer_Group_3__c;  
        account_Object.Customer_Group_4__c = String.isBlank(account_Object.Customer_Group_4__c) ? 'BP' : account_Object.Customer_Group_4__c;
        account_Object.Customer_Pricing_Procedure__c = String.isBlank(account_Object.Customer_Pricing_Procedure__c) ? '1' : account_Object.Customer_Pricing_Procedure__c;
        account_Object.Language__c = String.isBlank(account_Object.Language__c) ? 'E' : account_Object.Language__c;
        account_Object.Terms_of_Payment__c = String.isBlank(account_Object.Terms_of_Payment__c) ? '0001' : account_Object.Terms_of_Payment__c;
        account_Object.Role__c = String.isBlank(account_Object.Role__c) ? 'Sold-To Party' : account_Object.Role__c;
        account_Object.SFDC_ID__c = String.isBlank(account_Object.SFDC_ID__c) ? account_Object.Id : account_Object.SFDC_ID__c;
        account_Object.BillingCountry = String.isBlank(account_Object.BillingCountry) ? 'US' : account_Object.BillingCountry;
        account_Object.Potential_Annual_Sales_Volume__c = account_Object.Pricing_Tier__c == 'Silver' ? 'C' : account_Object.Pricing_Tier__c == 'Gold' ? 'B' : account_Object.Pricing_Tier__c == 'Platinum' ? 'A' : 'D';

        account_Object.SAP_Account_Id__c = 'Processing';
        account_Object.SAP_Account_Request__c = true;

        if(render){
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Hit Save to send your request to SAP for account creation, if you do not receive your SAP Account ID in Salesforce.com within one hour you will receive an email with instructions.'));
        }

        return null;
    }

    private Boolean companyFieldsMissing(){
        System.debug('****** Start Field Check Method');
        if(String.isBlank(account_Object.Name) || String.isBlank(account_Object.Phone) || String.isBlank(account_Object.BillingStreet) || String.isBlank(account_Object.BillingCity) || 
            String.isBlank(account_Object.BillingPostalCode) || String.isBlank(account_Object.BillingState) || 
            String.isBlank(account_Object.Industry_Segmentation__c)){
            return true;
            System.debug('****** Field is missing');
        }

        return false;
    }

    private void updateObject(){
        try{
            update account_Object;
        }
        catch(DmlException e){
            System.debug(e);            
            render = false;
        }
    }
}