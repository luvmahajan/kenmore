@isTest
private class AccountRedirectControllerTest {/*
    @isTest
    static void NewAccountNonCommercial () {
      Profile p = [SELECT Id FROM Profile WHERE Name='Home Services Administrator'];
      User u = new User(Alias = 'test', Email='standardTest@testorg.com',
          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
          LocaleSidKey='en_US', ProfileId = p.Id,
          TimeZoneSidKey='America/Los_Angeles', UserName='standardTest@testorg.com');

      System.runAs(u) {
         System.debug('Current User: ' + UserInfo.getUserName());
         System.debug('Current Profile: ' + UserInfo.getProfileId());

         AccountRedirectController controller = new AccountRedirectController(new ApexPages.StandardController(new account()));
         PageReference pr = controller.redirect();
      }

    }*/
    @isTest
    static void NewAccountCommercial () {
      Profile p2 = [SELECT Id FROM Profile WHERE Name='Standard User'];
      User u2 = new User(Alias = 'test2', Email='standardTest2@testorg.com',
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
      LocaleSidKey='en_US', ProfileId = p2.Id,
      TimeZoneSidKey='America/Los_Angeles', UserName='standardTest2@testorg.com');

      System.runAs(u2) {
         System.debug('Current User: ' + UserInfo.getUserName());
         System.debug('Current Profile: ' + UserInfo.getProfileId());

             AccountRedirectController controller = new AccountRedirectController(new ApexPages.StandardController(new account()));
             PageReference pr = controller.redirect();
        }


    }
}