@isTest
public with sharing class OpportunityTriggerTest {

    public static testmethod void OpportunityOpenTaskReassignment(){
        List<User> users = TestDataFactory.createUsers(2);
        insert users;

        List<Account> Accounts = TestDataFactory.createAccounts(1);
        Accounts[0].OwnerId = users[0].Id;
        insert Accounts;

        List<Opportunity> Opps = TestDataFactory.createOpportunities(2);
        Opps[0].OwnerId = users[0].Id;
        Opps[0].AccountId = Accounts[0].Id;
        Opps[1].OwnerId = users[0].Id;
        Opps[1].AccountId = Accounts[0].Id;
        insert Opps;

        List<Task> tasks = TestDataFactory.createTasks(2);
        tasks[0].OwnerId = users[0].Id;
        tasks[0].WhatId = Opps[0].Id;
        tasks[1].OwnerId = users[0].Id;
        tasks[1].WhatId = Opps[1].Id;
        insert tasks;


        List<Task> result = [SELECT Id FROM Task WHERE OwnerId = :users[0].Id];
        //System.assertEquals(2, result.size());

        Test.startTest();
        tasks[0].Status = 'Completed';
        update tasks[0];

        Accounts[0].OwnerId = users[1].Id;
        update Accounts;

        List<Opportunity> result1 = [SELECT Id FROM Opportunity WHERE OwnerId = :users[1].Id];
        //System.assertEquals(2, result1.size(),'Opportunity Ownership failure');


        List<Task> result2 = [SELECT Id, status FROM Task WHERE OwnerId = :users[0].Id];
        system.debug('Jeevana tasks' +result2);
        //System.assertEquals(1, result2.size(),'Task Ownership failure');

        List<Task> result3 = [SELECT Id FROM Task WHERE OwnerId = :users[1].Id];
        //system.assertEquals(1, result3.size(), 'Task Ownership failure');

        Test.stopTest();

    }

}