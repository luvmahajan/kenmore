@isTest
public class ChangeRequestPage2ControllerTest{
public static testMethod void changePage(){
        Test.startTest();
        Profile profile_obj = [SELECT Id, Name FROM Profile WHERE Name = 'System Administrator'];
         UserRole role_obj = [select id, Name from UserRole where Name = 'Sears Administrator' limit 1];
         User user_obj = new User(alias = 'TU1', 
            email='test1@gmail.com',
            emailencodingkey='UTF-8', 
            lastname='Testing1', 
            languagelocalekey='en_US',
            localesidkey='en_US', 
            Territory_ID__c ='35678',
            UserRoleId=role_obj.Id, 
            profileid=profile_obj.Id,
            country='United States',
            timezonesidkey='America/Los_Angeles', 
            username='Testuser1@sears.com',
            isActive = true);
            insert user_obj;
            
        List<Zip_Code__c> lstTestZipCode = new List<Zip_Code__c>();
        
        Zip_Code__c test_zipcode_1 = new Zip_Code__c();
        test_zipcode_1.Name = '56040';
        test_zipcode_1.OwnerId = system.UserInfo.getUserId();
        test_zipcode_1.State__c = 'AL';
        
        lstTestZipCode.add(test_zipcode_1);
        
        insert lstTestZipCode;
                   
        
        system.runas(user_obj){
            Business_Sector__c buSec = new Business_Sector__c();
            buSec.Name='usinessname';
            insert buSec;

            Industry_Segment__c inSec = new Industry_Segment__c();
            inSec.Business_Sector__c = buSec.id;
            inSec.Name = 'industryname';
            //inSec.NAICS_Code__c=020120;
            insert inSec;
            
            Account account_obj_1 = new Account();
            account_obj_1.Business__c = 'Commercial';
            account_obj_1.Potential_Annual_Sales_Volume__c = 'A';
            account_obj_1.Terms_of_Payment__c = '0001';
            account_obj_1.Customer_Pricing_Procedure__c = '05';
            account_obj_1.Potential_Annual_Sales_Volume__c = 'A';
            account_obj_1.Territory_ID__c = '09836';
            account_obj_1.Territory__c = 'Test territory';
            account_obj_1.Phone = '(999) 999-9999';
            account_obj_1.Name = 'User_Account_1';
            account_obj_1.BillingStreet = 'ST';
            account_obj_1.BillingState = 'AL';
            account_obj_1.BillingCity = 'TestCity';
       //     account_obj_1.BillingPostalCode = '560040';
            account_obj_1.BillingPostalCode = '56040';
            account_obj_1.BillingCountry = 'PR';
            account_obj_1.SAP_Account_ID__c= '51111';
            account_obj_1.Business_Sector__c =buSec.id;
            account_obj_1.Industry_Segment__c=inSec.id;
            insert account_obj_1;
            
            
            
            PageReference pageRef = Page.ChangeRequestPage2;
            Test.setCurrentPage(pageRef);

            TestDataFactory.setupCommonVariables();
            //ChangeRequestPage2Controller controller = new ChangeRequestPage2Controller();
            ApexPages.currentPage().getParameters().put('myId', account_obj_1.id);
            ChangeRequestPage2Controller controller = new ChangeRequestPage2Controller();
            controller.Save();
            controller.Cancel();
            controller.Approval_Process_Call();
            controller.submit_for_approval();
            controller.change_request_obj.New_Industry_Segment__c  = inSec.id;
            controller.newNaicCode();
            controller.change_request_obj.New_Account_Owner__c  = user_obj.id;
            controller.newTerriID();  
        }
        Test.stopTest(); 
    }
}