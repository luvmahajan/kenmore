@isTest
public class UpdateAccountDetailsControllerTest{
public static testMethod void changePage(){
            Profile profile_obj = [SELECT Id, Name FROM Profile WHERE Name = 'System Administrator'];
            UserRole role_obj = [select id, Name from UserRole where Name = 'Sears Administrator' limit 1];

            List<User> users = TestDataFactory.createUsers(2); 
            users[0].Territory_ID__c ='35678';
            users[0].UserRoleId=role_obj.Id;
            users[0].profileid=profile_obj.Id;
            insert users;

            system.runas(users[0]){
            
        List<Zip_Code__c> lstTestZipCode = new List<Zip_Code__c>();
        
        Zip_Code__c test_zipcode_1 = new Zip_Code__c();
        test_zipcode_1.Name = '56004';
        test_zipcode_1.OwnerId = system.UserInfo.getUserId();
        test_zipcode_1.State__c = 'AL';
        
        lstTestZipCode.add(test_zipcode_1);
        
        insert lstTestZipCode;
                   
                Business_Sector__c buSec = new Business_Sector__c();
                buSec.Name='businessname';
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
                account_obj_1.BillingStreet = '123 Test St';
                account_obj_1.BillingState = 'AL';
                account_obj_1.BillingCity = 'TestCity';
                account_obj_1.BillingPostalCode = '56004';
                account_obj_1.BillingCountry = 'US';
                account_obj_1.SAP_Account_ID__c= '51111';
                account_obj_1.Business_Sector__c =buSec.id;
                account_obj_1.Industry_Segment__c=inSec.id;
                insert account_obj_1;

                System.runAs(users[1]){
                    PageReference pageRef = Page.UpdateAccountDetails;
                    Test.setCurrentPage(pageRef);
                    ApexPages.currentPage().getParameters().put('Id', account_obj_1.id);
                    UpdateAccountDetailsController controller = new UpdateAccountDetailsController();
           //         controller.Save();
                }

                PageReference pageRef = Page.UpdateAccountDetails;
                Test.setCurrentPage(pageRef);
                ApexPages.currentPage().getParameters().put('Id', account_obj_1.id);
                UpdateAccountDetailsController controller = new UpdateAccountDetailsController();                
                String pageTest = controller.init().getUrl();
                pageTest = pageTest.substring(0,pageTest.indexOf('&'));
                System.assertNotEquals(null,pageTest);
                System.debug(pageTest);
                System.assertEquals('/apex/AccountDetailPage2?Id=' + account_obj_1.Id,pageTest);

                account_obj_1.BillingStreet = 'Test Street';
                account_obj_1.BillingPostalCode = '56004';
                update account_obj_1;
                Test.setCurrentPage(pageRef);
                ApexPages.currentPage().getParameters().put('Id', account_obj_1.id);
                controller = new UpdateAccountDetailsController();     
                pageTest = controller.init().getUrl();
                pageTest = pageTest.substring(0,pageTest.indexOf('&'));
                System.assertNotEquals(null,pageTest);
                System.debug(pageTest);
                System.assertEquals('/apex/AccountDetailPage2?Id=' + account_obj_1.Id,pageTest);

                account_obj_1.BillingPostalCode = '56004';
                update account_obj_1;
                Test.setCurrentPage(pageRef);
                ApexPages.currentPage().getParameters().put('Id', account_obj_1.id);
                controller = new UpdateAccountDetailsController();                
                pageRef = controller.init();
                //System.assertEquals(null,pageRef);

                

                controller.Save();
                controller.Cancel();
                
       }         
                
       
  }
 }