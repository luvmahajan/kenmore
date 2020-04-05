@isTest
public class ClonePlusControllerTest
{
    /*
        Test the initialise objects for cloning method.
        
        Initialise an instance of the clone plus controller, and add some test parameters to the test URL.
        
        In this test, we will add an account Id as the the object to be cloned.
    */
    private static testmethod void testInitialiseObjectsForCloning()
    {
        
        List<Zip_Code__c> lstTestZipCode = new List<Zip_Code__c>();
        
        Zip_Code__c test_zipcode_1 = new Zip_Code__c();
        test_zipcode_1.Name = '84040';
        test_zipcode_1.OwnerId = system.UserInfo.getUserId();
        test_zipcode_1.State__c = 'UT';
        
        lstTestZipCode.add(test_zipcode_1);
        
        insert lstTestZipCode;
        
        // First lets create our sample Account object and some related Contacts.
        Account acc = new Account (Name = 'Test Account', BillingStreet = '123 test st', BillingCity = 'Layton', BillingState = 'UT', BillingPostalCode = '84040', BillingCountry = 'US',
            Phone = '01482 123456789', Automation_Control__c = 3458730, Automation_Control_Type__c = 'Workflow, Process, Validation'); 
        insert acc;
        
        List<Contact> cons = new List<Contact>{};
        cons.add(new Contact(AccountId = acc.Id, FirstName = 'Sam', 
                             LastName = 'Ple' , email='test1@salesforce.com',
                             Automation_Control__c = 3458730, Automation_Control_Type__c = 'Workflow, Process, Validation'));
        cons.add(new Contact(AccountId = acc.Id, FirstName = 'Ted', 
                             LastName = 'Test', email='test2@salesforce.com', 
                             Automation_Control__c = 3458730, Automation_Control_Type__c = 'Workflow, Process, Validation'));
        insert cons;
        
        List<Opportunity> opps = new List<Opportunity>{};
        opps.add(new Opportunity(AccountId = acc.Id, Name = 'Test Opportunity 1',
                                 StageName='Closed Won' , CloseDate=Date.TODAY(),
                                 Automation_Control__c = 3458730, Automation_Control_Type__c = 'Workflow, Process, Validation'));
        opps.add(new Opportunity(AccountId = acc.Id, Name = 'Test Opportunity 2',  Reason_Lost_Description__c = 'Test', Reason_Lost__c = 'Contract terms did not meet customer needs',
                                 StageName='Closed Lost', CloseDate=Date.TODAY(),
                                 Automation_Control__c = 3458730, Automation_Control_Type__c = 'Workflow, Process, Validation'));
        insert opps;
        
        // Put the newly created account Id as the Id parameter on the page.
        ApexPages.currentPage().getParameters().put('Id', acc.id);
        
        // Also, add the contact object as a child object to clone.
        ApexPages.currentPage().getParameters().put('childobjecttypes','Contact,Opportunity');
        
        // Initialise a test instance of a clone plus controller.
        ClonePlusController cpc = new ClonePlusController();
        
        // Now call the initialise method.
        cpc.initialiseObjectsForCloning();
        
        // Now verify that all the class variables have been correctly set.
        system.assertEquals(2              , cpc.objectChildren.size());
        system.assertEquals('Contacts'     , cpc.objectChildren[0].pluralLabel);
        system.assertEquals('AccountId'    , cpc.objectChildren[0].relatedFieldName);
        system.assertEquals('Opportunities', cpc.objectChildren[1].pluralLabel);
        system.assertEquals('AccountId'    , cpc.objectChildren[1].relatedFieldName);
        
        // The related contacts should all be loaded into the controller.
        system.assertEquals(2              , cpc.objectChildren[0].objectRows.size());
  //      system.assertEquals(cons[0].Id     , cpc.objectChildren[0].objectRows[0].getId());
  //      system.assertEquals(cons[1].Id     , cpc.objectChildren[0].objectRows[1].getId());
        
        // The related opportunites should all be loaded into the controller.
        system.assertEquals(2              , cpc.objectChildren[1].objectRows.size());
        system.assertEquals(opps[0].Id     , cpc.objectChildren[1].objectRows[0].getId());
        system.assertEquals(opps[1].Id     , cpc.objectChildren[1].objectRows[1].getId());
        
        // All related objects should be selected for clonign by default.
        system.assert(cpc.objectChildren[0].objectRows[0].selected);
        system.assert(cpc.objectChildren[0].objectRows[1].selected);
        system.assert(cpc.objectChildren[1].objectRows[0].selected);
        system.assert(cpc.objectChildren[1].objectRows[1].selected);        

  // These variables all store information about the head object (Account)
        system.assertEquals('Account'   , cpc.objectTypeName);
        system.assertEquals(acc.Name    , cpc.objectName);
        system.assertEquals(acc.Id      , cpc.headSObject.Id);
        system.assertEquals(null        , cpc.headClone);
    }
    
    /*
     Test the "doClone" method. This method clones the parent object held in the controller,
     and all the related objects that have also been selected for copying.

        Initialise an instance of the clone plus controller, and populate the class variables with
        some sample objects. Select some of the related objects for cloning and ignore some others
  
        After the method has run, query the database to make sure that only those objects selected
        for cloning have been replicated.
    */
    private static testmethod void testDoCloneSuccess()
    {
        
        List<Zip_Code__c> lstTestZipCode = new List<Zip_Code__c>();
        
        Zip_Code__c test_zipcode_1 = new Zip_Code__c();
        test_zipcode_1.Name = '84040';
        test_zipcode_1.OwnerId = system.UserInfo.getUserId();
        test_zipcode_1.State__c = 'UT';
        
        lstTestZipCode.add(test_zipcode_1);
        
        insert lstTestZipCode;
        
        // First lets create our sample account object and some related Accounts.
        Account acc = new Account (Name = 'Test Account', Phone = '01482 123456789', BillingStreet = '123 test st', BillingCity = 'Layton', BillingState = 'UT', BillingPostalCode = '84040', BillingCountry = 'US'); 
        insert acc;
        
        List<Contact> cons = new List<Contact>{};
        cons.add(new Contact(AccountId = acc.Id, FirstName = 'Sam', Automation_Control__c = 3458730, Automation_Control_Type__c = 'Workflow, Process, Validation',
                             LastName = 'Ple', email='test1@salesforce.com'));
        cons.add(new Contact(AccountId = acc.Id, FirstName = 'Ted', Automation_Control__c = 3458730, Automation_Control_Type__c = 'Workflow, Process, Validation',
                             LastName = 'Test', email='test2@salesforce.com'));
        insert cons;
        
        List<Opportunity> opps = new List<Opportunity>{};
        opps.add(new Opportunity(AccountId = acc.Id, Name = 'Test Opportunity 1', Automation_Control__c = 3458730, Automation_Control_Type__c = 'Workflow, Process, Validation',
                                 StageName='Closed Won' , CloseDate=Date.TODAY()));
        opps.add(new Opportunity(AccountId = acc.Id, Name = 'Test Opportunity 2', Reason_Lost_Description__c = 'Test', Reason_Lost__c = 'Contract terms did not meet customer needs',
                                 Automation_Control__c = 3458730, Automation_Control_Type__c = 'Workflow, Process, Validation',
                                 StageName='Closed Lost', CloseDate=Date.TODAY()));
        insert opps;        
        
        // Initialise a test instance of a clone plus controller.
        ClonePlusController cpc = new ClonePlusController();
        
        // Populate the controller variables as if the Account created above had been 
        // selected for cloning along with all its related contacts.
        cpc.headSobject    = acc;
        
        List<ClonePlusController.RelatedObjectRow> relatedContactRows 
                               = new List<ClonePlusController.RelatedObjectRow>{};
        relatedContactRows.add(new ClonePlusController.RelatedObjectRow(cons[0]));
        relatedContactRows.add(new ClonePlusController.RelatedObjectRow(cons[1])); 
        
        List<ClonePlusController.RelatedObjectRow> relatedOpportunityRows 
                               = new List<ClonePlusController.RelatedObjectRow>{};
        relatedOpportunityRows.add(new ClonePlusController.RelatedObjectRow(opps[0]));
        relatedOpportunityRows.add(new ClonePlusController.RelatedObjectRow(opps[1]));
        
        // Deselect one of the Opportunities, indicating that it should not be cloned.       
        relatedOpportunityRows[0].selected = false;
        
        cpc.objectChildren = new List<ClonePlusController.RelatedObjects>{};
        cpc.objectChildren.add(new ClonePlusController.RelatedObjects(relatedContactRows,    
                                                                      'Contacts', 'AccountId'));
        cpc.objectChildren.add(new ClonePlusController.RelatedObjects(relatedOpportunityRows,
                                                                      'Opportunity', 'AccountId'));
        
        // Call the do clone method. Record the page reference passed in response. 
        // We will use this later in the test to ensure that the user is correctly being 
        // directed to the new cloned object detail page.
        PageReference doCloneResult = cpc.doClone();
        
        // Check the database for the presence of the newly cloned records.
        List<Account> clonedAccs = [SELECT Name, Phone,
                                          (SELECT FirstName, LastName, Email
                                           FROM Contacts
                                           ORDER By FirstName),
                                           (SELECT Name, StageName, CloseDate
                                           FROM Opportunities
                                           ORDER By Name)
                                    FROM Account
                                    WHERE Id != :acc.Id];
        
  //      system.assertEquals(1                , clonedAccs.size());
  //      system.assertEquals(acc.Name         , clonedAccs[0].Name);
 //       system.assertEquals(acc.Phone        , clonedAccs[0].Phone);
        
        //Both of the selected contacts should have been cloned.
 //       system.assertEquals(2                , clonedAccs[0].Contacts.Size());
 //       system.assertEquals(cons[0].FirstName, clonedAccs[0].Contacts[0].FirstName);
//        system.assertEquals(cons[0].LastName , clonedAccs[0].Contacts[0].LastName);
 //       system.assertEquals(cons[0].email    , clonedAccs[0].Contacts[0].Email);
 //       system.assertEquals(cons[1].FirstName, clonedAccs[0].Contacts[1].FirstName);
 //       system.assertEquals(cons[1].LastName , clonedAccs[0].Contacts[1].LastName);
 //       system.assertEquals(cons[1].email    , clonedAccs[0].Contacts[1].Email);
        
        // Only 1 opportunity should have been cloned.
 //       system.assertEquals(1                , clonedAccs[0].Opportunities.Size());
 //       system.assertEquals(opps[1].Name     , clonedAccs[0].Opportunities[0].Name);
 //       system.assertEquals(opps[1].StageName, clonedAccs[0].Opportunities[0].StageName);
 //       system.assertEquals(opps[1].CloseDate, clonedAccs[0].Opportunities[0].CloseDate);
        
        // Finally, verify that the page reference returned by the clone method is the 
        // view page of the new account object.
 //       system.assertEquals('/' + clonedAccs[0].Id, doCloneResult.getURL());
    }

    /*
        Test the "doClone" method. This method clones the parent object held in the controller,
        and all the related objects that have also been selected for copying.

        Initialise an instance of the clone plus controller, and don't populate the class variables with
        some sample objects. This will cause an error when calling the do clone method, 
        as there is nothing to clone. 
  
        Instead of redirecting the user, a page message should be added to the current page, 
        informing the user of the error that has occured.
    */
    private static testmethod void testDoCloneFailure()
    {   
        // Initialise a test instance of a clone plus controller.
        ClonePlusController cpc = new ClonePlusController();
        
        // Call the do clone method. Record the page reference passed in response. 
        PageReference doCloneResult = cpc.doClone();
        
        // Verify that that a null page reference is returned by the method call, 
        // and that a page message has been generated to inform the user a fault has occured.
        system.assertEquals(1, ApexPages.getMessages().size());
    }
    
    /*
     When the related object rows have been populated, the getId method can be used to interrogate
     the generic sobject and retrieve the id field of the object.
      
     However, if no id field is visible to the user, then this should not cause an exception to occur.
     Instead, a blank value should be returned.
    */
    private static testmethod void testGetObjectIdException()
    {
     // Start the test by intialising some object rows in the controller. 
     // One object row will not contain an object, resulting in a (caught) exception 
     // when the id is requested.
     Contact testSavedContact = new Contact(FirstName = 'Sam', LastName = 'Ple', 
                                            email='test1@salesforce.com');
     insert testSavedContact;
     
     ClonePlusController.RelatedObjectRow testSavedContactRow 
                         = new ClonePlusController.RelatedObjectRow(testSavedContact);
     ClonePlusController.RelatedObjectRow testNullObjectRow   
                         = new ClonePlusController.RelatedObjectRow(null);
     
     System.assertEquals(testSavedContact.Id, testSavedContactRow.getId());
     System.assertEquals(''                 , testNullObjectRow.getId());
    }
}