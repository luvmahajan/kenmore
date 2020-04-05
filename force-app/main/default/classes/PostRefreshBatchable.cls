global class PostRefreshBatchable implements Database.Batchable<sObject> {
	Id adminProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
	//System.debug('***** adminId' + adminProfileId);
	String query = 'SELECT Id, Email, UserName FROM User WHERE IsActive = true AND ProfileId = ' + '\'' + adminProfileId + '\'';
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		System.debug('***** query' + query);
		return Database.getQueryLocator(query);
	}

   	global void execute(Database.BatchableContext BC, List<sObject> scope) {
   		List<User> usersToUpdate = new List<User>();

		for(User u : (List<User>)scope){
			if(u.Email.contains('=') && !(u.Username.contains('sfdcadmin')) && !(u.Username.contains('user'))){
                u.Email = u.Email.replace('@example.com','').replace('=','@');
                usersToUpdate.add(u);
            }
		}

		if(usersToUpdate.size() > 0){
            update usersToUpdate;
        }  
	}
	
	global void finish(Database.BatchableContext BC) {
		
	}
	
}