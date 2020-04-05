@isTest
private class LineOfBillingAddAccountRefTriggerTest
{
	//Create Account
	//Create LOB 

	//Insert Account
	//INsert LOB - Log Results

	
	//Scenario 1 - Bill_to does not exist

	//Scenario 2 - All fields exist but SAP Id not attached to Account

	//Scenario 3 - Everything exists and insert successful

	@isTest
	static void InsertLOB()
	{
            
        List<Zip_Code__c> lstTestZipCode = new List<Zip_Code__c>();
        
        Zip_Code__c test_zipcode_1 = new Zip_Code__c();
        test_zipcode_1.Name = '01012';
        test_zipcode_1.OwnerId = system.UserInfo.getUserId();
        test_zipcode_1.State__c = 'AL';
        
        lstTestZipCode.add(test_zipcode_1);
        
        insert lstTestZipCode;
                   
		Business_Sector__c buSec = new Business_Sector__c();
        buSec.Name='usinessname';
        insert buSec;
        
        Industry_Segment__c inSec = new Industry_Segment__c();
        inSec.Business_Sector__c = buSec.id;
        inSec.Name = 'industryname';
        //inSec.NAICS_Code__c=020120;
        insert inSec;

		Account acc = new Account(); 
        acc.Territory__c= '0012';  
        acc.Territory_ID__c='111';
        acc.BillingStreet='teststreet';
        acc.BillingCity='testcity';
        acc.BillingState='AL';
        acc.BillingPostalCode='01012';
        acc.BillingCountry='US';
        acc.Industry='testindustry';
        acc.Name='testname';
        acc.Phone='(999)999-9999';
        acc.Business_Sector__c = buSec.id;
        acc.Industry_Segment__c = inSec.id;
        acc.SAP_Account_ID__c = '10042178';
        insert acc;

		

		Line_Of_Billing__c lob = new Line_Of_Billing__c ();
        lob .Bill_To__c= '10042178'; 
        insert lob ;

	}
}