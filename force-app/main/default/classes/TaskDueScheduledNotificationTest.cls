@isTest
public class TaskDueScheduledNotificationTest {
    static testmethod void testTaskDueNotification(){
        
        Test.startTest();

        List<Account> a = TestDataFactory.createAccounts(1);
		insert a;
        
        List<Task> tasks = new List<Task>();
		tasks.add(new Task(ActivityDate = Date.today(),Subject='Sample Task Due Today',WhatId = a[0].Id,OwnerId = UserInfo.getUserId(),Status='In Progress', Description = 'Sample Description'));
		tasks.add(new Task(ActivityDate = Date.today().addDays(-7),Subject='Sample Task 7 Days Over Due',WhatId = a[0].Id,OwnerId = UserInfo.getUserId(),Status='In Progress'));
        tasks.add(new Task(ActivityDate = Date.today().addDays(3),Subject='Sample Task Before Due Date',WhatId = a[0].Id,OwnerId = UserInfo.getUserId(),Status='In Progress'));
        tasks.add(new Task(ActivityDate = Date.today().addDays(14),Subject = 'Sample Null Check',WhatId = null,OwnerId = UserInfo.getUserId(),Status='In Progress', Description = null));
		insert tasks;
        
		TaskDueScheduledNotification event = new TaskDueScheduledNotification();
		event.execute(null);
		
		Messaging.SingleEmailMessage result = event.CreateTaskDueEmail(new Task(ActivityDate = Date.today(),Subject='Sample Task Due Today',WhatId = a[0].Id,OwnerId = UserInfo.getUserId(),Status='In Progress', Description = 'Sample Description'), false);
		System.assertEquals('Task Sample Task Due Today Is Due Today - Please Review', result.Subject);

		Messaging.SingleEmailMessage result2 = event.CreateTaskDueEmail(new Task(ActivityDate = Date.today().addDays(-7),Subject='Sample Task 7 Days Over Due',WhatId = a[0].Id,OwnerId = UserInfo.getUserId(),Status='In Progress'), true);
		System.assertEquals('Task Sample Task 7 Days Over Due Is Past Due - Please Review', result2.Subject);

        Test.stopTest();
    }
}