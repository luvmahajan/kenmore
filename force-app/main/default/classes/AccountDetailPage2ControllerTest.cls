@isTest
public class AccountDetailPage2ControllerTest{
    
    public static testMethod void function(){
        Test.startTest();
        Profile profile_obj = [SELECT Id, Name FROM Profile WHERE Name = 'System Administrator'];
        
        //Role is Sears Administrator in User Object
        UserRole role_obj = [select id, Name from UserRole where Name = 'Sears Administrator' limit 1];
        
        //Set the Test user
        List<User> users = TestDataFactory.createUsers(2);
        users[0].UserRoleId=role_obj.Id;
        users[0].profileid=profile_obj.ID; 
        insert users;        

        List<Zip_Code__c> lstTestZipCode = new List<Zip_Code__c>();
        
        Zip_Code__c test_zipcode_1 = new Zip_Code__c();
        test_zipcode_1.Name = '56040';
        test_zipcode_1.OwnerId = system.UserInfo.getUserId();
        test_zipcode_1.State__c = 'AL';
        
        lstTestZipCode.add(test_zipcode_1);
        
        insert lstTestZipCode;
                   
        
        Account account_obj_2 = new Account();        
        Account account_obj_1 = new Account();
        
        System.runAs(users[0]){
            //Creating records for Account Object
            account_obj_1.Nickname__c = 'Test';
            account_obj_1.SAP_NAICS_Code__c = '23';
            account_obj_1.Type = 'Prospect';
            account_obj_1.Fax = '53543';
            account_obj_1.Website = 'http://fgjddghj.com';
            account_obj_1.Business__c = 'Commercial';
            account_obj_1.Potential_Annual_Sales_Volume__c = 'A';
            account_obj_1.Terms_of_Payment__c = '0001';
            account_obj_1.Customer_Pricing_Procedure__c = '5';
            account_obj_1.Potential_Annual_Sales_Volume__c = 'A';
            account_obj_1.Phone = '(899) 725-8325';
            account_obj_1.Name = 'User_Account_1';
            account_obj_1.BillingStreet = 'ST';
            account_obj_1.BillingState = 'AL';
            account_obj_1.BillingCity = 'TestCity';
            account_obj_1.BillingPostalCode = '56040';
            account_obj_1.BillingCountry = 'PR';
            account_obj_1.SAP_Account_ID__c= '525434';
            account_obj_1.OwnerId = users[0].Id;
            insert account_obj_1;
            
            //Update a record for Account Object
            account_obj_2.Id = account_obj_1.Id;
            account_obj_1.Nickname__c = 'Test2';
            account_obj_1.SAP_NAICS_Code__c = '233';
            account_obj_1.Type = 'Prospect';
            account_obj_1.Fax = '5354334';
            account_obj_1.Website = 'http://fgjddghj.com';
            account_obj_1.Business__c = 'Commercial';
            account_obj_1.Potential_Annual_Sales_Volume__c = 'A';
            account_obj_1.Terms_of_Payment__c = '0002';
            account_obj_1.Customer_Pricing_Procedure__c = '5';
            account_obj_1.Potential_Annual_Sales_Volume__c = 'A';
            account_obj_1.Phone = '(899) 725-8325';
            account_obj_1.Name = 'User_Account_1';
            account_obj_1.BillingStreet = 'ST';
            account_obj_1.BillingState = 'AL';
            account_obj_1.BillingCity = 'TestCity';
            account_obj_1.BillingPostalCode = '56040';
            account_obj_1.BillingCountry = 'PR';
            account_obj_1.SAP_Account_ID__c= '525434';
            update account_obj_2;
            
            //ApexPages.currentPage().getParameters().put('Id',account_obj_1.id);
            ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(account_obj_2);
            ApexPages.currentPage().getParameters().put('Id',account_obj_2.id);
            
            AccountDetailPage2Controller account_detail_object = new AccountDetailPage2Controller(sc);
            account_detail_object.Save1();
             account_detail_object.Cancel1();

           System.runAs(users[1]){
                ApexPages.Standardcontroller sc2 = new ApexPages.Standardcontroller(account_obj_1);
                ApexPages.currentPage().getParameters().put('Id',account_obj_1.id);
            
                account_detail_object = new AccountDetailPage2Controller(sc2);
                account_detail_object.Save1();
           }
        }
       Test.stopTest();
    }    
}