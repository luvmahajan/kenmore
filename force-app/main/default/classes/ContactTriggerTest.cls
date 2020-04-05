@isTest
public class ContactTriggerTest {

    public static testmethod void ContactOpenTaskReassignment(){
        List<User> users = TestDataFactory.createUsers(2);
        insert users;

        List<Account> Accounts = TestDataFactory.createAccounts(1);
        Accounts[0].OwnerId = users[0].Id;
        insert Accounts;

        List<Contact> Contacts = TestDataFactory.createContacts(2);
        Contacts[0].OwnerId = users[0].Id;
        Contacts[0].AccountId = Accounts[0].Id;
        Contacts[1].OwnerId = users[0].Id;
        Contacts[1].AccountId = Accounts[0].Id;
        insert Contacts;

        List<Task> tasks = TestDataFactory.createTasks(2);
        tasks[0].OwnerId = users[0].Id;
        tasks[0].WhoId = Contacts[0].Id;
        tasks[1].OwnerId = users[0].Id;
        tasks[1].WhoId = Contacts[1].Id;
        insert tasks;

        List<Task> result = [SELECT Id FROM Task WHERE OwnerId = :users[0].Id];
        System.assertEquals(2, result.size());

        Test.startTest();
        tasks[0].Status = 'Completed';
        update tasks[0];

        Accounts[0].OwnerId = users[1].Id;
        update Accounts;

        List<Contact> result3 = [SELECT Id FROM Contact WHERE OwnerId = :users[1].Id];
        //System.assertEquals(2, result3.size(),'Contact Ownership failure');


        List<Task> result1 = [SELECT Id FROM Task WHERE OwnerId = :users[0].Id];
        //System.assertEquals(1, result1.size(),'Task Ownership failure');

        List<Task> result2 = [SELECT Id FROM Task WHERE OwnerId = :users[1].Id];
        //System.assertEquals(1, result2.size(),'Task Ownership failure');

        Test.stopTest();
    }
}