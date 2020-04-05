public with sharing class UploadAttachmentCustomController {

    @TestVisible Account account {get;set;}
    public Commercial_Contract__c contract {get; set;}
	public transient String fileName {get;set;}
    public transient Blob fileBody {get;set;}
    public List<SelectOption> typeOptions {get; set;}
    public List<SelectOption> documentTypeOptions {get; set;}
    public String selectedType {get; set;}
    public String selectedDocumentType {get; set;}
    public String contractName {get; set;}
    private String addToContractId {get; set;}
    public Boolean readOnlyFlag {get; set;}
    private Attachment attachment {get; set;}
    private Boolean deleteContract {get; set;}    
    private Boolean deleteAttachment {get; set;}
    
    public UploadAttachmentCustomController(ApexPages.StandardController controller) {  
        readOnlyFlag = false;   
        deleteAttachment = false;
        deleteContract = false;
        if(!Test.isRunningTest()){               
            controller.addFields(new List<String>{'SAP_Account_ID__c'});
        }
        
        this.account = (Account)controller.getRecord(); 
        this.contract = new Commercial_Contract__c();
        addToContractId = system.CurrentPageReference().GetParameters().get('contractId');

        if(String.isNotBlank(addToContractId)){
            contract = [SELECT Account__c,Attachment__c,Contract_Type__c,CreatedById,CreatedDate,Document_Type__c,Document__c,End_Date__c,Id,Name,Total_Amount__c,Start_Date__c FROM Commercial_Contract__c WHERE Id = :addToContractId LIMIT 1];
            selectedType = contract.Contract_Type__c;
            selectedDocumentType = contract.Document_Type__c;
            readOnlyFlag = true;
        }

        Schema.DescribeFieldResult componentFieldDescription = Commercial_Contract__c.Document_Type__c.getDescribe();
        documentTypeOptions = new list<SelectOption>();
        for (Schema.Picklistentry picklistEntry : componentFieldDescription.getPicklistValues())
        {
            documentTypeOptions.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));
        }

        Schema.DescribeFieldResult typeFieldDescription = Commercial_Contract__c.Contract_Type__c.getDescribe();
        typeOptions = new List<SelectOption>();
        for(Schema.PickListEntry picklistEntry : typeFieldDescription.getPicklistValues()){
            typeOptions.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));
        }

        contractName = String.format('{0} - {1}', new String[]{account.SAP_Account_ID__c, account.Name});
    }   
    
    // creates a new Contact_Attachment__c record
    private Database.SaveResult saveCustomAttachment() {
        contract.Account__c = account.Id;
        contract.Contract_Type__c = selectedType;
        contract.Document_Type__c = selectedDocumentType;
        contract.Name = contractName;

        return Database.insert(contract);
    }
    
    // create an actual Attachment record with the Contact_Attachment__c as parent
    private Database.SaveResult saveStandardAttachment(Id parentId) {
        Database.SaveResult result;
        
        attachment = new Attachment();
        attachment.body = this.fileBody;
        attachment.name = this.fileName;
        attachment.parentId = parentId;
        // inser the attahcment
        result = Database.insert(attachment);
        // reset the file for the view state
        fileBody = Blob.valueOf(' ');
        return result;
    }
    
    public PageReference processUpload() {
        Database.SaveResult attachmentResult;
        Database.SaveResult customAttachmentResult;
        PageReference page = null;

        try { 
            if(fileBody != null){
                if(contract.Total_Amount__c == NULL && selectedType == 'Subcontractor agreement' && (selectedDocumentType == 'Addendums' || selectedDocumentType == 'Final/signed contract')){
                    ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                      'Total Ammount is required for this document.'));            
                    return null;
                }
                else{
                     if(String.isBlank(addToContractId)){
                        customAttachmentResult = saveCustomAttachment();
                    
                        if (customAttachmentResult == null || !customAttachmentResult.isSuccess()) {
                            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                              'Could not save attachment.'));
                            return null;
                        }

                        attachmentResult = saveStandardAttachment(customAttachmentResult.getId());
                    }
                    else{                
                        attachmentResult = saveStandardAttachment(contract.Id);
                    }
                
                    if (attachmentResult == null || !attachmentResult.isSuccess()) {
                        ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                          'Could not save attachment.'));            
                        return null;
                    } else {
                        // update the custom attachment record with some attachment info
                        contract.Attachment__c = attachmentResult.getId();
                        update contract;
                    }
                }
            }
            else{
                    ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                      'Please attach a file.'));            
                    return null;
            }
        
        } catch (Exception e) {
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                      'Failed to upload contract, please try again or contact support for assistance'));
            System.debug(e);            
        } 

        if(String.isNotBlank(addToContractId)){
            return new PageReference('/' + contract.Id);
        }
        
        return new PageReference('/'+account.Id);
    }
}