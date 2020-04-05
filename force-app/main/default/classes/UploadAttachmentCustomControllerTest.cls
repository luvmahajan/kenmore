@isTest
private class UploadAttachmentCustomControllerTest {
    
    static testmethod void attachmentUploadTestMethod() {
        List<Account> accounts = TestDataFactory.createAccounts(1);
        insert accounts;    

        ApexPages.StandardController stdController = new ApexPages.StandardController(accounts[0]);
        UploadAttachmentCustomController controller = new UploadAttachmentCustomController(stdController);

        Test.setCurrentPageReference(new PageReference('Page.myPage'));
        System.currentPageReference().getParameters().put('contractId', null);

        controller.fileName = 'Test Name';
        controller.selectedType = 'Supplier agreement';
        controller.selectedDocumentType = 'Addendums';
        controller.contract.Start_Date__c = System.today();
        controller.contract.End_Date__c = System.today() + 7;

        Test.startTest();       

        PageReference page = controller.processUpload();
        System.assertEquals(null, page);

        controller.fileBody = Blob.valueOf('Test Body');

        PageReference page2 = controller.processUpload();
        System.assertNotEquals(null, page2);
        
        List<Commercial_Contract__c> contracts = TestDataFactory.createCommercialContracts(1);
        contracts[0].Account__c = accounts[0].Id;
        contracts[0].Name = controller.contractName;        
        contracts[0].Contract_Type__c = 'Supplier agreement';
        contracts[0].Document_Type__c = 'Addendums';
        insert contracts;

        System.currentPageReference().getParameters().put('contractId', contracts[0].Id);
        UploadAttachmentCustomController controller2 = new UploadAttachmentCustomController(stdController);
        
        controller2.fileName = 'Test Name 2';
        controller2.fileBody = Blob.valueOf('Test Body 2');
        controller2.processUpload();

        UploadAttachmentCustomController controller3 = new UploadAttachmentCustomController(stdController);

        List<Commercial_Contract__c> contract = TestDataFactory.createCommercialContracts(1);
        contract[0].Account__c = accounts[0].Id;
        contract[0].Name = controller3.contractName;        
        contract[0].Contract_Type__c = 'Subcontractor agreement';
        contract[0].Document_Type__c = 'Addendums';

        controller3.contract = contract[0];
        controller3.fileName = 'Test Name 2';
        controller3.fileBody = Blob.valueOf('Test Body 2');
        controller3.selectedType = 'Subcontractor agreement';
        controller3.selectedDocumentType = 'Addendums';
        controller3.processUpload();

        ApexPages.Message[] pageMessages = ApexPages.getMessages();
        System.assertNotEquals(0, pageMessages.size());

        // Check that the error message you are expecting is in pageMessages
        Boolean messageFound = false;

        for(ApexPages.Message message : pageMessages) {
            if(message.getSummary() == 'Total Ammount is required for this document.'
                && message.getSeverity() == ApexPages.Severity.ERROR) {
                messageFound = true;        
            }
        }

        System.assert(messageFound);

        Test.stopTest();
    }
    
}