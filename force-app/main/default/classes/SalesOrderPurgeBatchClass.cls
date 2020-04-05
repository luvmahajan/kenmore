public class SalesOrderPurgeBatchClass implements Database.Batchable<sObject> {
	
	private String query = 'SELECT Id FROM Sales_Order_Header__c WHERE Order_Status__c = \'' + 'Completed' + '\'' + ' AND Create_Date_Time__c < ' + datetime.now().addDays(-30).format('YYYY-MM-dd');

	public SalesOrderPurgeBatchClass() {
		
	}
	
	public Database.QueryLocator start(Database.BatchableContext BC) {
		System.debug('***** ' + query);
		return Database.getQueryLocator(query);
	}

   	public void execute(Database.BatchableContext BC, List<sObject> scope) {
		System.debug('***** ' + scope.size());

		if(scope != null && scope.size() > 0){
			delete scope;
		}
	}
	
	public void finish(Database.BatchableContext BC) {
		
	}
	
}