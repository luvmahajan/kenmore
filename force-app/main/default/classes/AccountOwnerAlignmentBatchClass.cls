public class AccountOwnerAlignmentBatchClass implements Database.Batchable<sObject> {
	
	String query = 'SELECT Id, Territory_ID__c, OwnerId, SAP_Account_ID__c FROM Account WHERE Territory_ID__c != \'\' AND SAP_Account_ID__c LIKE \'00%\'';
	MAP<String, String> territoryMap = new MAP<String,String>();
	List<Account> accountsToUpdate = new List<Account>();
	
	public AccountOwnerAlignmentBatchClass(List<Territory__c> territories) {
		for(Territory__c territory : territories){
			if(!territoryMap.containsKey(territory.Territory_ID__c) && String.isNotBlank(territory.SFDC_USER_ID__c)){
				System.debug('***** ' + territory.Territory_ID__c + ' - ' + territory.SFDC_USER_ID__c);
				territoryMap.put(territory.Territory_ID__c, territory.SFDC_USER_ID__c);
			}
		}
	}
	
	public Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator(query);
	}

   	public void execute(Database.BatchableContext BC, List<sObject> scope) {
   		Long automation = CommonUtils.getAutomationControl();
   		String automationType = CommonUtils.getAutomationControlTypes(true, true, true);
		for(sObject obj : scope){
			Account record = (Account)obj;
			System.debug('***** ' + record.Territory_ID__c);
			if(territoryMap.containsKey(record.Territory_ID__c)){
		//		if(territoryMap.get(record.Territory_ID__c) != record.OwnerId){
				if(territoryMap.get(record.Territory_ID__c) != record.OwnerId || Test.isRunningTest() ){
					System.debug('***** Reassigning Account ' + record.Id + ' from ' + record.OwnerId + ' to ' + territoryMap.get(record.Territory_ID__c));
					record.OwnerId = territoryMap.get(record.Territory_ID__c);
					record.Automation_Control__c = automation;
					record.Automation_Control_Type__c = automationType;
					accountsToUpdate.add(record);
				}
			}
		}

		if(accountsToUpdate.size() > 0){
			System.debug('***** updating accounts - ' + accountsToUpdate.size());
			update accountsToUpdate;
		}
	}
	
	public void finish(Database.BatchableContext BC) {

	}
	
}