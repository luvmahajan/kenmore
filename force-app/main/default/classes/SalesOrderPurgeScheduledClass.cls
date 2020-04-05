global class SalesOrderPurgeScheduledClass implements Schedulable {
	global void execute(SchedulableContext sc) {
		SalesOrderPurgeBatchClass SOPurge = new SalesOrderPurgeBatchClass();
		Database.executeBatch(SOPurge, 1000);
	}
}