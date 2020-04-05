public with sharing class AccountCommercialContractRLController {

    private final Commercial_Contract__c mysObject;
    public String destURL {get; set;}
    public Boolean renderButtons {get; set;}
   
    public AccountCommercialContractRLController(ApexPages.StandardController stdController) {
        renderButtons = false;
        if(!Test.isRunningTest()){
            stdController.addFields(new List<String>{'Account__c'});
            stdController.addFields(new List<String>{'Attachment__c'});
        }
        this.mysObject = (Commercial_Contract__c)stdController.getRecord();
        this.destURL = String.format('/apex/CommercialContractUpload?id={0}&contractId={1}', new String[]{mysObject.Account__c, mysObject.Id});

        List<PermissionSetAssignment> currentUserPermSet = [SELECT Id, PermissionSet.Name,AssigneeId FROM PermissionSetAssignment WHERE AssigneeId = :UserInfo.getUserId()];
        Account contractAccount = [SELECT Id, OwnerId FROM Account WHERE Id = :mysObject.Account__c];
        Profile admin = [SELECT Id, Name FROM Profile WHERE Name = 'System Administrator'];

        if(UserInfo.getUserId() == contractAccount.OwnerId || UserInfo.getProfileId() == admin.Id){
            renderButtons = true;
        }

        for (PermissionSetAssignment record : currentUserPermSet) {
            if ( record.PermissionSet.Name.equals('Contracting_Admin_Account_editability') ) {
                renderButtons = true;
            }
        }
    }    

    public List<Attachment> getAttachmentList(){
        List<Attachment> attachmentList = new List<Attachment>();
        
        for(Attachment record: [SELECT ContentType,Description,Id,Name,OwnerId,ParentId,CreatedById, CreatedDate FROM Attachment WHERE ParentId = :mysObject.Id ORDER BY CreatedDate DESC]){
            attachmentList.add(record);
        }

        if(attachmentList.size() > 0)
            return attachmentList;
        else
            return null;
    }

    public PageReference deleteContract(){
        String recordId = ApexPages.currentPage().getParameters().get('recordid');


        if(this.mysObject.Attachment__c != recordId){
            Attachment recordToDelete = [SELECT Id from Attachment WHERE Id = :recordId LIMIT 1];
            if(recordToDelete != null){
                delete recordToDelete;
            }
        }else{
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Can not delete the most current record for this Commercial Contract'));
        }

        return null;
    }
}