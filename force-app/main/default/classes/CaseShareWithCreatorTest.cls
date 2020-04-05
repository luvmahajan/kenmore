@isTest
public class CaseShareWithCreatorTest {
    static testmethod void testCaseShare(){
        
		List<Account> accounts = TestDataFactory.createAccounts(1);
		insert accounts;
        
		List<Contact> contacts = TestDataFactory.createContacts(1);
		contacts[0].AccountId = accounts[0].Id;
		contacts[0].Email = 'testcase@email.com';
		insert contacts;
        
    List<RecordType> listRecordType = new List<Recordtype>();
    listRecordType = [SELECT Id, Name FROM RecordType WHERE Name = 'Inside Sales' AND SobjectType='Case' LIMIT 1];
        
        
 //       Case record = new Case(Type = 'Other', Subject = 'Test Case', Description = 'Sample Description');        
        List<Case> cases = new List<Case>();
        Case record = new Case(Type = 'Other', Subject = 'Test Case', Description = 'Sample Description', RecordTypeId=listRecordType[0].Id, SuppliedEmail='testcase@email.com' );        
        cases.add(record);
        Case record2 = new Case(Type = 'Other', Subject = 'Test Case', Description = 'Sample Description', RecordTypeId=listRecordType[0].Id, SuppliedEmail='testfail@email.com' );        
        cases.add(record2);
        
        
        
        Test.startTest();
     //   insert(record);
        insert(cases);
        Test.stopTest();  
    }
}