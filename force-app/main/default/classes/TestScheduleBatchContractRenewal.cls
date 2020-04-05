@isTest
private class TestScheduleBatchContractRenewal 
{
 	private static testMethod void testScheduling()
 	{    		
 		CronTrigger	ct;
 		String	cronExp, jobID;
 		
 		//create the cron expression next year
        cronExp	= '0 0 0 3 9 ? ' + String.valueOf(Date.Today().year() + 1);
        
        Test.startTest();
                
        // Schedule the test job 
        jobID = System.schedule('UnitTestScheduleBatchContractRenewal', cronExp, new ScheduledBatchContractRenewal());
        
        System.assertNotEquals(null, jobID, 'The Job was not scheduled properly');
        
        // Get the information from the CronTrigger API object 
        ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];

        // Verify the expressions are the same 
        System.assertEquals(cronExp, ct.CronExpression);

        // Verify the job has not run 
	    System.assertEquals(0, ct.TimesTriggered);

        // Verify the next time the job will run     
        System.assertEquals(string.valueOf(Date.Today().year() + 1) + '-09-03 00:00:00', String.valueOf(ct.NextFireTime));
        
        Test.stopTest();
    }
}