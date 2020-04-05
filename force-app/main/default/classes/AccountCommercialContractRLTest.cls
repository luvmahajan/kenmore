@isTest
private class AccountCommercialContractRLTest {
	
	static testmethod void commercialContractRelatedListTestMethod() {
		List<Account> accounts = TestDataFactory.createAccounts(1);
		insert accounts;		

		List<Commercial_Contract__c> contracts = TestDataFactory.createCommercialContracts(1);
		contracts[0].Account__c = accounts[0].Id;
		insert contracts;

		ApexPages.StandardController stdController = new ApexPages.StandardController(contracts[0]);
		AccountCommercialContractRLController controller = new AccountCommercialContractRLController(stdController);
		List<Attachment> result = controller.getAttachmentList();

		List<Attachment> attachments =  TestDataFactory.createAttachemts(2);
		attachments[0].ParentId = contracts[0].Id;
		attachments[1].ParentId = contracts[0].Id;
		insert attachments;


		contracts[0].Attachment__c = attachments[1].Id;
		update contracts;

		Test.startTest();	

		result = controller.getAttachmentList();
		System.assert(result.size() == 2);
		
		Test.setCurrentPageReference(new PageReference('Page.myPage'));
		System.currentPageReference().getParameters().put('recordid', attachments[1].Id);
		controller.deleteContract();

		ApexPages.Message[] pageMessages = ApexPages.getMessages();
		System.assertNotEquals(0, pageMessages.size());


		System.currentPageReference().getParameters().put('recordid', attachments[0].Id);
		controller.deleteContract();

		result = controller.getAttachmentList();
		System.assert(result.size() == 1);

		Test.stopTest();
	}
	
}