@isTest
public class updateAccountTest{
     static testmethod void testAccUpdate(){
            
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
        //acc.Id= 'accountid';  
        acc.Territory__c= '0012';  
        acc.Territory_ID__c='111';
        //acc.Owner_ID_Old__c= 'owneridoldtest';  
        //acc.Owner_Id__c = 'owneridtest';
        acc.SAP_Account_ID__c='001245'; 
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
        insert acc;
        
        Territory__c terr = new Territory__c();
        terr.Territory_ID__c ='111';
        terr.FIRST_NAME__c ='testFname';
        terr.LAST_NAME__c='testLname';
        terr.Enterprise_ID__c='testsearchid';
        terr.District_Manager_Name_Short__c='District Manager';
        //terr.EID_length__c ='true';
        
        insert terr;
        
        User user = new User();
        user.FirstName='District ';
        user.LastName='Manager';
        user.Sears_Enterprise_id__c  ='testsearchid';
        user.Username='johnacmeff@fgf.com';
        user.Email='testemail@cg.com';
        user.Alias='aa';
        user.isActive=true;
        user.CommunityNickname='testccname';
        user.TimeZoneSidKey='America/Denver';
        user.LocaleSidKey='en_US';
        user.EmailEncodingKey='UTF-8';
        user.ProfileId='00e30000001FeAR';
        user.LanguageLocaleKey='en_US';
        
        
        insert user;
        
      
        Test.startTest();
        updateAccount updateAccountTest = new updateAccount();
        Database.executeBatch(updateAccountTest) ;
        Test.stopTest();

        
     }
 
}