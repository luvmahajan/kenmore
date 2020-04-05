public class ChangeRequestPage2Controller{

    public Change_Request__c change_request_obj{get;set;}
    public id accid {get; set;}
    //public boolean response {get; set;}
    //public id cRId {get; set;}
    
    public List<Account> account_obj_list {get;set;}
    public List<Account> user_obj_list {get;set;}
    //public List<Industry_Segment__c> industry_segment_list;
   // public List<Business_Sector__c> business_sector_list;
    
    //public String parentAccName{get;set;}
    //public String accName{get;set;}
    public String sTree{get;set;}
    public String cIty{get;set;}
    public String reGion{get;set;}
    public String postalCode{get;set;}
    public String couNtry{get;set;}
    public String telePhone{get;set;}
    public String eMail{get;set;}
    public String customPriceProcedue{get;set;}
    public String customerGroup{get;set;}
    public String industry{get;set;}
    public String paymentTerm{get;set;}
    public String priceGroup{get;set;}
    public String priceListType{get;set;}
    public String territoryId{get;set;}
    public String name1 {get; set;}
    public String request_status{get; set;}
    //public String buSiness{get; set;}
    //public String buSinessId;
    public String sapId{get; set;}
    public String sfdcId{get; set;}
    //public String industrySegment{get; set;}
    //public String industrySegmentId;
    public String NAICS_Code{get; set;}
    //public String PotentialAnnualSalesVolume{get; set;}
    
    public String owner_first_name{get;set;}
    public String owner_last_name{get;set;}
    public String owner_email{get; set;}
    //public String appNmae{get; set;}
    //public String fileNETNmae{get; set;}
    
    public String pricingTier{get;set;}
    public String account_manager {get;set;}
    public String newnaic_code {get;set;}
    public string newTerriID{get;set;}
    public Decimal pricingQTDSales{get;set;}
    public Decimal pricingYTDSales{get;set;}
    public Boolean requireField {get;set;}
    public Boolean tierVisible {get;set;}
    public Boolean accountVisible {get;set;}

    public ChangeRequestPage2Controller(){
        change_request_obj = new Change_Request__c();
        accid = ApexPages.currentPage().getParameters().get('myId');
        tierVisible = ApexPages.currentPage().getParameters().get('tier') == 'true' ? True : False;
        accountVisible = !tierVisible;

        requireField = false;

        if(String.isNotBlank(accid)){
            account_obj_list = [SELECT Id, Name, Name_2__c, BillingStreet, BillingCity, Business_Sector__c, SAP_Account_ID__c, BillingState, 
                                       BillingPostalCode, BillingCountry, Phone, Email_Address__c, Customer_Pricing_Procedure__c,  
                                       Customer_Group__c, Industry, Payment_Term__c, Industry_Segment__c, Parent.Name,
                                       Price_List_Type__c, Territory_ID__c, NAICS_Code__c, Pricing_Tier__c,Pricing_Tier_Assignment_Date__c,Pricing_Tier_Expiration_Date__c,
                                       Pricing_Tier_YTD_Sales__c, Pricing_Tier_QTD_Sales__c, Estimated_Opportunity_Amount__c
                                FROM Account 
                                WHERE Id = :accid];

            for(Opportunity opp :[SELECT Amount FROM Opportunity WHERE AccountId = :accid AND IsClosed = false]){
                if(opp.Amount != null && opp.Amount > 0){
                    change_request_obj.Open_Opportunity_Amount__c = change_request_obj.Open_Opportunity_Amount__c == null ? 0.00 : change_request_obj.Open_Opportunity_Amount__c;                    
                    change_request_obj.Open_Opportunity_Amount__c += opp.Amount;
                }
            }
                                                    
            change_request_obj.Account_Name__c =  accid;
            //change_request_obj.New_Potential_Annual_Sales_Volume__c = String.ValueOf(account_obj_list[0].Potential_Annual_Sales_Volume__c);      
            
            name1 =  String.ValueOf(account_obj_list[0].Name) ;
            System.debug('name1 -----------------' +name1 );
            System.debug('change_request_obj.Account_Name__r.Name-----------------' +change_request_obj.Account_Name__r.Name);
            System.debug('change_request_obj.Account_Name__r.Name-----------------' +change_request_obj.Account_Name__c);
       
            //accName=String.ValueOf(account_obj_list[0].Parent.Name) ;
            sTree=String.ValueOf(account_obj_list[0].BillingStreet) ;
            cIty=String.ValueOf(account_obj_list[0].BillingCity) ; 
            reGion=String.ValueOf(account_obj_list[0].BillingState) ; 
            postalCode=String.ValueOf(account_obj_list[0].BillingPostalCode) ; 
            couNtry=String.ValueOf(account_obj_list[0].BillingCountry) ; 
            telePhone=String.ValueOf(account_obj_list[0].Phone) ; 
            eMail=String.ValueOf(account_obj_list[0].Email_Address__c) ;
            customPriceProcedue=String.ValueOf(account_obj_list[0].Customer_Pricing_Procedure__c) ; 
            customerGroup=String.ValueOf(account_obj_list[0].Customer_Group__c) ; 
            industry=String.ValueOf(account_obj_list[0].Industry) ; 
            paymentTerm=String.ValueOf(account_obj_list[0].Payment_Term__c) ; 
            //priceGroup=String.ValueOf(account_obj_list[0].Potential_Annual_Sales_Volume__c) ; 
            priceListType=String.ValueOf(account_obj_list[0].Price_List_Type__c) ; 
            territoryId=String.ValueOf(account_obj_list[0].Territory_ID__c  ) ; 
            //buSinessId=String.ValueOf(account_obj_list[0].Business_Sector__c) ;
            sapId=String.ValueOf(account_obj_list[0].SAP_Account_ID__c) ;
            sfdcId=String.ValueOf(account_obj_list[0].Id) ; 
            NAICS_Code = String.ValueOf(account_obj_list[0].NAICS_Code__c);
            //PotentialAnnualSalesVolume = String.ValueOf(account_obj_list[0].Potential_Annual_Sales_Volume__c);
            pricingTier=String.ValueOf(account_obj_list[0].Pricing_Tier__c);
            pricingQTDSales= account_obj_list[0].Pricing_Tier_QTD_Sales__c == null ? 0.00 : account_obj_list[0].Pricing_Tier_QTD_Sales__c;
            pricingYTDSales= account_obj_list[0].Pricing_Tier_YTD_Sales__c == null ? 0.00 : account_obj_list[0].Pricing_Tier_YTD_Sales__c;
            
            industry = String.ValueOf(account_obj_list[0].Industry);
            if(industry == '' || industry == null) {
                requireField = true;
            }
           
            
            request_status = 'None';

            user_obj_list = [SELECT id, Owner.FirstName, Owner.LastName, Owner.Email, Owner.Username FROM Account WHERE Account.Id = :accid];
            
            owner_first_name = String.ValueOf(user_obj_list[0].Owner.FirstName) ;
            owner_last_name = String.ValueOf(user_obj_list[0].Owner.LastName) ;
            owner_email = String.ValueOf(user_obj_list[0].Owner.Email) ; 
            account_manager = owner_first_name + ' ' + owner_last_name ;
        }
    }

    public void newNaicCode()
    {  
    }

    public void newTerriID()
    {
        newTerriID=[select Territory_ID__c from User where id=:change_request_obj.New_Account_Owner__c Limit 1].Territory_ID__c;
    }
    
    //On click of Save button in the VF page, the Resquest Status field will be updated to Saved.
    public void Save(){
        request_status = 'Saved';
        change_request_obj.Request_Status__c = request_status;
        insert change_request_obj;
    }     
  
    //On click of Cancel button in the VF page, the page will be redirected to List View page.
    public PageReference Cancel(){  
        PageReference page_reference_obj_after_cancel = new PageReference('/'+accid);
        page_reference_obj_after_cancel.setRedirect(true);
        
        return page_reference_obj_after_cancel;
    }
    
    /*1. On accepting of sending for Approval Process, the Request Status will be updated to Submitted 
      2. Page will be redirected to account List View page*/
    public PageReference Approval_Process_Call(){  
        change_request_obj.Request_Status__c = 'Submitted';
        Database.Update(change_request_obj);
        System.debug('MYMethod fnction----------------------------------');
        PageReference my_function = new PageReference('/'+accid);
        my_function.setRedirect(true);
        
        return my_function;
    }
    
    public PageReference submit_for_approval() {
        //Change_Request__c change_request_obj;
        Approval.ProcessSubmitRequest req1=new Approval.ProcessSubmitRequest();
        //req1.setComments('Submitting request for approval');
        req1.setObjectId(change_request_obj.id);
        try{
            Approval.ProcessResult result = Approval.process(req1);
            if(result.isSuccess())
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Your Change Request has been submitted to your District Manager for approval. Once approved it will be sent to the file administration team for approval and update in SAP. Updates will automatically populate to the account within 24 hours.'));
            }
            else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'SubmissionFailed as the contract not in Submitted Status'));
            }
        }
        catch(Exception e){
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.info,e));
        }
        return null;

    }
}