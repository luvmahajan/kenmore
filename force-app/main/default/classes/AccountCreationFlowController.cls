public class AccountCreationFlowController {
    public Flow.Interview.Account_Creation accountFlow {get; set;}

    public PageReference prFinishLocation {
        get {
            PageReference prRef = new PageReference('/' + recordId);
            prRef.setRedirect(true);
            return prRef;
        }
        set { prFinishLocation = value; }
    }

    public String recordId {
        get {
            String newRecordId = '';
            Boolean createContact = false;
            if (accountFlow != null) {
                newRecordId = string.valueOf(accountFlow.getVariableValue('CreatedAccountId'));
                system.debug('*****NEW ACCOUNT**** = ' + newRecordId);
            }
            return newRecordId;
        }
        set { recordId = value; }
    }
}