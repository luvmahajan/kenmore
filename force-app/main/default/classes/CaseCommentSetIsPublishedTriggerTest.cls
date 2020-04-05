@isTest
public class CaseCommentSetIsPublishedTriggerTest {
    static testmethod void testIsPublishedTrigger() {
        
        Test.startTest();
        
        Case record = new Case(Type = 'Other', Subject = 'Test Case', Description = 'Sample Description');
        insert record;
        
        CaseComment comment = new CaseComment();
        comment.CommentBody = 'Test Comment';
        comment.ParentId = record.Id;
        comment.IsPublished = false;        
        
        insert(comment);        
        
        Test.stopTest();
        
        CaseComment insertedComment = [SELECT Id, IsPublished FROM CaseComment WHERE Id = :comment.Id];
        System.assert(insertedComment.IsPublished == true);
    }
}