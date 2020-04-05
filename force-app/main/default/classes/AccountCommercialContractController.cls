public with sharing class AccountCommercialContractController {
	private final Account account {get; set;}
	public String destURL {get; set;}
	
	public AccountCommercialContractController(ApexPages.StandardController controller) {
		if(!test.isRunningTest()){
			controller.addFields(new List<String>{'ParentId'});
		}
		this.account = (Account)controller.getRecord();	
		this.destURL = String.format('/apex/CommercialContractUpload?id={0}&contractId=', new String[]{account.Id});
	}

	public List<DisplayContracts> getContractList(){
		List<DisplayContracts> contractList = new List<DisplayContracts>();

		for(Commercial_Contract__c record: [SELECT Account__c,Attachment__c,Document_Type__c,Contract_Type__c,End_Date__c,Id,Name,Total_Amount__c,Start_Date__c FROM Commercial_Contract__c WHERE Account__c = :account.ParentId AND IsDeleted = false ORDER BY Start_Date__c DESC]){
			contractList.add(new DisplayContracts(record,[SELECT ContentType,Description,Id,Name,OwnerId,ParentId FROM Attachment WHERE Id = :record.Attachment__c],true));
		}
		
		for(Commercial_Contract__c record: [SELECT Account__c,Attachment__c,Document_Type__c,Contract_Type__c,End_Date__c,Id,Name,Total_Amount__c,Start_Date__c FROM Commercial_Contract__c WHERE Account__c = :account.Id AND IsDeleted = false ORDER BY Start_Date__c DESC]){
			contractList.add(new DisplayContracts(record,[SELECT ContentType,Description,Id,Name,OwnerId,ParentId FROM Attachment WHERE Id = :record.Attachment__c],false));
		}		

		if(contractList.size() > 0)
			return contractList;
		else
			return null;
	}

	@TestVisible class DisplayContracts{
		 public Commercial_Contract__c contract { get;set; }
		 public Attachment attachment { get; set; }
		 public Boolean parent {get; set;}

		 public DisplayContracts(Commercial_Contract__c c, Attachment a, Boolean isParent){
		 	this.contract = c;
		 	this.attachment = a;
		 	this.parent = isParent;
		 }
	}
}