global class OpportunityTaskAutoCreate implements Schedulable {
	global void execute(SchedulableContext sc) {
		List<Task> tasksToInsert = GenerateTasks();

		if(tasksToInsert.size() > 0){
           //       if(Test.isRunningTest() ){
			insert(tasksToInsert);
         //         }
		}
	}

	public List<Task> GenerateTasks(){
		LIST<Profile> profiles = [SELECT Id FROM Profile WHERE Name IN ('Standard Inside Sales User','Standard Commercial AM User','Standard Commercial Management User') ];
        if(Test.isRunningTest() ){
            profiles = [SELECT Id FROM Profile WHERE Name IN ('Standard Inside Sales User','Standard Commercial AM User','Standard Commercial Management User', 'Standard User') ];
        }
        List<Opportunity> opportunities = [SELECT Id, OwnerId FROM Opportunity WHERE Owner.ProfileId IN :profiles AND IsClosed = false AND Owner.IsActive = true];
		//tasks list that holds the opportunity ID's of those that have open tasks
		Map<Id, AggregateResult> tasks = new Map<Id, AggregateResult>([SELECT WhatId Id FROM Task WHERE IsClosed = false AND WhatId IN :opportunities GROUP BY WhatId]);


		List<Opportunity> taskNeeded = new List<Opportunity>();
		for(Opportunity record :opportunities){
			if(!tasks.containsKey(record.Id))
			{
				taskNeeded.add(record);
			}
		}

		List<Task> result = new List<Task>();
		for(Opportunity record :taskNeeded){
			Task newTask = new Task();
			newTask.Description = 'This task was created automatically to ensure that we have a clear next step with the customer with any open opportunity.  Please update this task with an appropriate due date, subject heading, and add comments if applicable.';
			newTask.ActivityDate = System.today().addDays(1);
			newTask.OwnerId = record.OwnerId;
			newTask.Priority = 'Normal';
			newTask.Status = 'Not Started';
			newTask.Subject = 'Open Opportunity: Schedule Next Step';
			newTask.WhatId = record.Id;
			newTask.IsReminderSet = true;
            newTask.ReminderDateTime = System.now()+1;

			result.add(newTask);
		}

		return result;
	}
}