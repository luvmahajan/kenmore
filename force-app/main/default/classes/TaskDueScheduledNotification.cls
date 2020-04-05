/*
 * Class    : 	TaskDueScheduledNotification
 *
 * Objective: 	This class implements the Schedulable interface to send emails to task owners when 
 *				tasks are due and overdue by 7 days.
 *
 * Created  : 	11/30/2015
*/
global class TaskDueScheduledNotification implements Schedulable{
    global void execute(SchedulableContext sc){
        //Holds the tasks that need notifications sent out
        Map<Id,List<Task>> tasksDue = new Map<Id,List<Task>>();
        //Holds all messages to send
        List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>();
        List<User> users = new List<User>();

        for(Task record: [SELECT Id, Owner.Name, Subject, ActivityDate, What.Name, Description FROM Task WHERE IsClosed = FALSE AND Owner.IsActive = true AND 
                                (ActivityDate = :System.today() OR ActivityDate = :System.today().addDays(-7))]){
            if(!tasksDue.containsKey(record.OwnerId)){
                tasksDue.put(record.OwnerId, new List<Task>());
            }
            tasksDue.get(record.OwnerId).add(record);
        }
        
        Set<ID> homeServicesProfileIds =  new Set<ID>();
        for(Profile record: [SELECT Id FROM Profile WHERE Name IN ('Standard Home Services User', 'Home Services Administrator','Home Services BIT')]){
            homeServicesProfileIds.add(record.Id);
        }
        users = [SELECT Id, FirstName, ProfileId FROM User WHERE Id IN :tasksDue.keyset()];

        //for each user, create a email based off the due date if not home services profile.
        for(User userRecord: users){
            for(Task taskRecord: tasksDue.get(userRecord.Id)){  

                if(!homeServicesProfileIds.contains(userRecord.ProfileId)){
                    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                    
                    //pick the correct template
                    if(taskRecord.ActivityDate == System.today()){
                        email = CreateTaskDueEmail(taskRecord, false);
                    }
                    else{                
                        email = CreateTaskDueEmail(taskRecord, true);
                    }     

                    messages.add(email);
                }
            }   
        }

        //send messages if we have any
        if(messages.size() > 0)
        {
            Messaging.sendEmail(messages);
        }
        
    }//End execute method
    
    //Summary
    //This method creates the appropriate email given theTask and pastDue flag
    //Summary
    public Messaging.SingleEmailMessage CreateTaskDueEmail(Task taskRecord, Boolean pastDue){
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        string placeholder = '';
        string relatedTo = '';
        string description = '';
        
        //it we have NULL, leave empty string for email
        if(string.isNotBlank(taskRecord.What.Name)){
            relatedTo = taskRecord.What.Name;
        }
        if(string.isNotBlank(taskRecord.Description)){
            description = taskRecord.Description;
        }
        
        //create proper intro to email
        if(pastDue){
            email.setSubject(String.format('Task {0} Is Past Due - Please Review', new String[]{taskRecord.Subject}));
            placeholder = 'Hi {0},\n\n' +
            'This is a reminder that you have a task that was due {1}; this task is 7 days past due:\n\n';  
        }
        else{
            email.setSubject(String.format('Task {0} Is Due Today - Please Review', new String[]{taskRecord.Subject}));
            placeholder = 'Hi {0},\n\n' +
            	'This is a reminder that you have a task due today, {1}:\n\n';                     
        }
        
        //append the rest that is the same for both email formats
        placeholder += 'Subject: {2}\n\n' +
            'Related To: {3}\n\n' +            
            'Comments (if any): {4}\n\n' +            
            'Task Link: {5}\n\n' +            
            'Please login to Salesforce to further review the task details. If you have already performed the task, change the Status to "Completed." If not, perform the task or edit the due date to a later time.\n\n' +            
            'Thank you.';
        
        //set email properties
        email.setTargetObjectId(taskRecord.OwnerId);
        email.setSaveAsActivity(false);
        email.setPlainTextBody(string.format(placeholder, new String[]{taskRecord.Owner.Name, string.valueOf(taskRecord.ActivityDate),taskRecord.Subject, relatedTo, description, URL.getSalesforceBaseUrl().toExternalForm() + '/' + taskRecord.Id}));

        return email;
    }
}//End Class