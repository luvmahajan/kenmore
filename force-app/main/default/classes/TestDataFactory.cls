/*
 * Class    : 	TestDataFactory
 *
 * Objective: 	Factory class to generate common objects for use in test classes
 *
 * Created  : 	12/20/2015
*/
@isTest
Global class TestDataFactory {
        
	public static List<Account> createAccounts(Integer numberOfAccounts){
        
        /****************** Insert Zip Code ****************/   
        
        List<Zip_Code__c> lstTestZipCode = new List<Zip_Code__c>();
        
        Zip_Code__c test_zipcode_1 = new Zip_Code__c();
        test_zipcode_1.Name = '84040';
        test_zipcode_1.OwnerId = system.UserInfo.getUserId();
        test_zipcode_1.State__c = 'UT';
        
        lstTestZipCode.add(test_zipcode_1);
        
        insert lstTestZipCode;
        
        /****************** Insert Territory ****************/   
        
        List<Territory__c> lstTestTerritory = new List<Territory__c>();
        
        Territory__c test_territory_1 = new Territory__c();
        test_territory_1.Name = '12321';
        test_territory_1.Territory_ID__c = '12321';
        test_territory_1.District_Territory_ID__c = '12321';
        
        lstTestTerritory.add(test_territory_1);
        
        insert lstTestTerritory;
        
        /****************** Insert Account ****************/           
        
		List<Account> result = new List<Account>();

		for(Integer i = 1; i <= numberOfAccounts; i++)
		{
			Account newAccount = new Account();
			newAccount.Name = String.format('Test Account {0}', new String[]{String.valueOf(i)});
			newAccount.BillingStreet = 'Test Street';
			newAccount.BillingCity = 'Layton';
			newAccount.BillingPostalCode = '84040';
			newAccount.BillingState = 'UT';
			newAccount.BillingCountry = 'US';
			newAccount.ShippingStreet = 'Test Street';
			newAccount.ShippingCity = 'Layton';
			newAccount.ShippingPostalCode = '84040';
			newAccount.ShippingState = 'UT';
			newAccount.ShippingCountry = 'US';
			newAccount.Pricing_Tier__c = 'Bronze';
			newAccount.SCO_Account_ID__c = 'sco_123';
			newAccount.Territory_ID__c = '12321';
			newAccount.NewTerritory__c = lstTestTerritory[0].Id;
            
			result.add(newAccount);
		}

		return result;
	}

	public static List<User> createUsers(Integer numberOfUsers){
		List<User> result = new List<User>();
		Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];

		for(Integer i = 1; i <= numberOfUsers; i++)
		{
			User newUser = new User();
			newUser.FirstName = 'Test';
			newUser.LastName = String.format('User {0}', new String[]{String.valueOf(i)});
			newUser.Username = String.format('devtestuser{0}@factory.com', new String[]{String.valueOf(i)});			
			newUser.Email = String.format('testuser{0}@testfactory.com', new String[]{String.valueOf(i)});
			newUser.Alias = String.format('tuser{0}', new String[]{String.valueOf(i)});
			newUser.EmailEncodingKey = 'UTF-8';
			newUser.LanguageLocaleKey = 'en_US';
			newUser.LocaleSidKey = 'en_US';
			newUser.TimeZoneSidKey = 'America/Los_Angeles';
			newUser.ProfileId = p.Id;

			result.add(newUser);
		}
		
		return result;
	}

	public static List<Contact> createContacts(Integer numberOfContacts){
		List<Contact> result = new List<Contact>();

		for(Integer i = 1; i <= numberOfContacts; i++)
		{
			Contact newContact = new Contact();
			newContact.FirstName = 'Test';
			newContact.LastName = String.format('Contact {0}', new String[]{String.valueOf(i)});

			result.add(newContact);
		}
		
		return result;
	}

	public static List<Opportunity> createOpportunities(Integer numberOfOpportunities){
		List<Opportunity> result = new List<Opportunity>();

		for(Integer i = 1; i <= numberOfOpportunities; i++)
		{
			Opportunity newOpportunity = new Opportunity();			
			newOpportunity.CloseDate = System.today()+7;
			newOpportunity.Name = String.format('Test Opportunity {0}', new String[]{String.valueOf(i)});
			newOpportunity.StageName = 'Identification';
			newOpportunity.Shipping_Start_Date__c = System.today();
			newOpportunity.Shipping_End_Date__c = System.today()+30;


			result.add(newOpportunity);
		}
		
		return result;
	}

	public static List<Commercial_Contract__c> createCommercialContracts(Integer numberOfContracts){
		List<Commercial_Contract__c> result = new List<Commercial_Contract__c>();

		for(Integer i = 1; i <= numberOfContracts; i++)
		{
			Commercial_Contract__c newContract = new Commercial_Contract__c();
			newContract.Start_Date__c = System.today();
			newContract.End_Date__c = System.today()+7;

			result.add(newContract);
		}

		return result;
	}

	public static List<Attachment> createAttachemts(Integer numberOfAttachments){
		List<Attachment> result = new List<Attachment>();

		try
		{
			for(Integer i = 1; i <= numberOfAttachments; i++)
			{
				Attachment newAttachment = new Attachment();				
				newAttachment.Name = String.format('Test Attachment {0}', new String[]{String.valueOf(i)});
				newAttachment.Body = Blob.valueOf('abc');
				result.add(newAttachment);
			}
		}
		catch(Exception e)
		{
			System.debug('Create Attachment failed, ' + e.getMessage());
		}	

		return result;	
	}

	public static List<Sales_Order_Header__c> createSalesOrderHeaders(Integer numberOfHeaders){
		List<Sales_Order_Header__c> result = new List<Sales_Order_Header__c>();

		for(Integer i = 1; i <= numberOfHeaders; i++)
		{
			Sales_Order_Header__c newHeader = new Sales_Order_Header__c();
			result.add(newHeader);
		}

		return result;
	}

	public static List<Sales_Order_Header__c> createSalesOrderHeaders(Integer numberOfHeaders, String accountId){
		List<Sales_Order_Header__c> result = new List<Sales_Order_Header__c>();

		for(Sales_Order_Header__c record :createSalesOrderHeaders(numberOfHeaders)){
			record.Account__c = accountId;
			result.add(record);
		}

		return result;
	}

	public static List<Sales_Order_Line_Item__c> createSalesOrderLineItems(Integer numberOfLineItems){
		List<Sales_Order_Line_Item__c> result = new List<Sales_Order_Line_Item__c>();

		for(Integer i = 1; i <= numberOfLineItems; i++)
		{
			Sales_Order_Line_Item__c newLineItem = new Sales_Order_Line_Item__c();
			result.add(newLineItem);
		}

		return result;
	}

	public static List<Sales_Order_Line_Item__c> createSalesOrderLineItems(Integer numberOfLineItems, String headerId){
		List<Sales_Order_Line_Item__c> result = new List<Sales_Order_Line_Item__c>();

		for(Sales_Order_Line_Item__c record :createSalesOrderLineItems(numberOfLineItems)){
			record.Sales_Order_Header__c = headerId;
			result.add(record);
		}

		return result;
	}

	public static List<Change_Request__c> createChangeRequests(Integer numberofRequests){
		List<Change_Request__c> result = new List<Change_Request__c>();

		for(Integer i = 1; i <= numberofRequests; i++){
			Change_Request__c newRequest = new Change_Request__c();
			result.add(newRequest);
		}

		return result;
	}

	public static List<Change_Request__c> createChangeRequests(Integer numberofRequests, String accountId){
		List<Change_Request__c> result = new List<Change_Request__c>();

		for(Change_Request__c record :createChangeRequests(numberofRequests)){
			record.Account_Name__c = accountId;
			result.add(record);
		}

		return result;
	}

	public static List<Territory__c> createTerritories(Integer numberOfTerritories){
		List<Territory__c> result = new List<Territory__c>();

		for(Integer i = 1; i <= numberOfTerritories; i++){
			Territory__c newTerritory = new Territory__c();
			newTerritory.District_Name__c = String.format('Test District {0}000', new String[]{String.valueOf(i)});
			result.add(newTerritory);
		}

		return result;
	}

	public static List<Task> createTasks(Integer numberOfTasks){
		List<Task> result = new List<Task>();

		for(Integer i = 1; i <= numberOfTasks; i++){
			Task newTask = new Task();
			newTask.Subject = String.format('Test Subject {0}', new String[]{String.valueOf(i)});
			newTask.Status = 'In Progress';
			newTask.Type = 'Other';
			result.add(newTask);
		}

		return result;
	}

	public static List<Lead> createLeads(Integer numberOfLeads){
		List<Lead> result = new List<Lead>();

		for(Integer i = 1; i <= numberOfLeads; i++){
			Lead newLead = new Lead();
			newLead.Company = String.format('Test Company {0}', new String[]{String.valueOf(i)});
			newLead.LastName = String.format('Test LastName {0}', new String[]{String.valueOf(i)});
			newLead.LeadSource = 'Other';
			newLead.Status = 'Marketing Qualified Lead';
			newLead.Email = String.format('testemail{0}@test.com', new String[]{String.valueOf(i)});
			newLead.Opportunity_Type__c = 'Commercial - Flow Business';
			newLead.Street = '132 Test Street';
			newLead.City = 'Layton';
			newLead.PostalCode = '84040';
			newLead.State = 'UT';
			newLead.Country = 'US';
			result.add(newLead);
		}

		return result;
	}

	public static List<Campaign> createCampaigns(Integer numberOfCampaigns){
		List<Campaign> result = new List<Campaign>();

		for(Integer i = 1; i <= numberOfCampaigns; i++){
			Campaign newCampaign = new Campaign();
			newCampaign.Name = String.format('Test Campaign {0}', new String[]{String.valueOf(i)});
			newCampaign.IsActive = true;
			result.add(newCampaign);
		}

		return result;
	}

	public static List<CampaignMember> createCampaignMembers(Integer numberOfCampaignMembers){
		List<CampaignMember> result = new List<CampaignMember>();

		for(Integer i = 1; i <= numberOfCampaignMembers; i++){
			CampaignMember newCampaignMember = new CampaignMember();
			result.add(newCampaignMember);
		}

		return result;
	}
	
    public static List<invoice__c> createInvoice(Integer numberOfInvoices){
        List<Invoice__c> result = new List<Invoice__c>();
        
        for(integer i=0; i<numberOfInvoices; i++) {
        	Invoice__c invoicelist = new Invoice__c();
           	invoicelist.Invoice_number__c = 'Test123';
            invoicelist.order_number__c = '12345678';
            invoicelist.Invoice_Date__c = system.today();
           // invoicelist.Parent_Account__c = accountId;
            invoicelist.Customer_PO__c = 'Test Invoice';  
            invoicelist.Ship_to_Name__c = 'Test Ship to Name';
            invoicelist.ADDR1__c = 'Test ship address';
           // invoicelist.State__c = 'IL';
            //invoicelist.City__c = 'Testcity';
            //

            
                        
			result.add(invoicelist);
		}

		return result;
        
    }

       public static Invoice_Line_Item__c createInvoiceLineItems(String InvoiceId){
            Invoice_Line_Item__c lineitem = new Invoice_Line_Item__c();
	        lineitem.Invoice__c =  InvoiceId;
           lineitem.Sequence__c =  '10';
           lineitem.Quantity__c =  10;
           lineitem.Unit_Price__c =  10;
           return lineitem;

       }
    

	//----------CUSTOM SETTINGS-------------------------------------------------------------

	public static Map<String, Common_Variables__c> createCommonVariables(){
		Map<String, Common_Variables__c> result = new Map<String, Common_Variables__c>();

		result.put('Auto Assignment Status Change', new Common_Variables__c(Name='Auto Assignment Status Change',Content__c='Sales Qualified'));		
		result.put('Group Email', new Common_Variables__c(Name='Group Email',Content__c='sfdcsupport@searshc.com'));
		result.put('IST Lead Dollar Amount', new Common_Variables__c(Name='IST Lead Dollar Amount',Content__c='50000'));
		result.put('IST Queue Id', new Common_Variables__c(Name='IST Queue Id',Content__c='00G300000030EzsEAE'));
	//	result.put('Account Manager Profile Id', new Common_Variables__c(Name='Account Manager Profile Id', Content__c='00e30000001tSgAAAU'));
		result.put('Account Manager Profile Id', new Common_Variables__c(Name='Account Manager Profile Id', Content__c='00e30000001FeAUAA0'));
		result.put('IST Profile Id', new Common_Variables__c(Name='IST Profile Id', Content__c='00e30000001tT7lAAE'));
		result.put('Integration User', new Common_Variables__c(Name='Integration User', Content__c = '0053000000BQVTrAAP'));

		return result;
	}

	public static Map<String, Round_Robin_Toggle__c> createRoundRobinToggle(){
		Map<String, Round_Robin_Toggle__c> result = new Map<String, Round_Robin_Toggle__c>();

		result.put('Capitol District', new Round_Robin_Toggle__c(Name='Capitol District', Round_Robin_Active__c=false));
		result.put('Northern California District', new Round_Robin_Toggle__c(Name='Northern California District', Round_Robin_Active__c=true));
		result.put('Child_Territory', new Round_Robin_Toggle__c(Name='Child_Territory', Round_Robin_Active__c=true));
		return result;
	}

	public static void setupRoundRobinToggle(){
		Map<String, Round_Robin_Toggle__c> result = createRoundRobinToggle();
		insert result.values();
	}

	public static void setupCommonVariables(){
		Map<String, Common_Variables__c> result = createCommonVariables();
		insert result.values();
	}
}