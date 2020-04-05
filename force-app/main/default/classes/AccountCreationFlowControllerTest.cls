@isTest
private class AccountCreationFlowControllerTest {
    @isTest
    static void AccountFlowTest () {
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User u = new User(Alias = 'test', Email = 'standardTest@testorg.com',
                          EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
                          LocaleSidKey = 'en_US', ProfileId = p.Id,
                          TimeZoneSidKey = 'America/Los_Angeles', UserName = 'standardTest@testorg.com');


        System.runAs(u) {
            System.debug('Current User: ' + UserInfo.getUserName());
            System.debug('Current Profile: ' + UserInfo.getProfileId());

            List<Account> account = TestDataFactory.createAccounts(1);
            insert account;

            PageReference pageReference = Page.AccountCreationFlow;
            Test.setCurrentPage(pageReference);
            ApexPages.currentPage().getParameters().put('CreatedAccountId', 'account.Id');

            AccountCreationFlowController controller = new AccountCreationFlowController();
            String getRecordId = controller.recordId;
            controller.recordId = account[0].Id;
            PageReference getprFinishLocation = controller.prFinishLocation;
            controller.prFinishLocation = pageReference;

        }

    }
}