public class UserBackPageController {
    
    public User objUser {get; set;}
    public String userId {get; set;}
    
    public UserBackPageController() {
        
        userId = ApexPages.CurrentPage().getparameters().get('id');        
            system.debug('userId--> ' + userId);
        
        objUser = [SELECT Id, Name, Title, Email, Phone
                   FROM User
                   WHERE Id =: userId
                   LIMIT 1
                  ];
        
    }
        
}