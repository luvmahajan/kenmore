@isTest
public class UpdateSFDCUserIDTest{
     static testmethod void testAccUpdate(){
     
     User user = new User();
        user.FirstName='District ';
        user.LastName='Manager';
        user.Sears_Enterprise_id__c  ='testsearchid';
        user.Username='johnacmeff@fgf.com';
        user.Email='testemail@cg.com';
        user.Alias='aa';
        user.isActive=true;
        user.CommunityNickname='testccname';
        user.TimeZoneSidKey='America/Denver';
        user.LocaleSidKey='en_US';
        user.EmailEncodingKey='UTF-8';
        user.ProfileId='00e30000001FeAR';
        user.LanguageLocaleKey='en_US';
        insert user;
     
     
     
     Territory__c terr = new Territory__c();
        terr.Territory_ID__c ='111';
        terr.FIRST_NAME__c ='testFname';
        terr.LAST_NAME__c='testLname';
        terr.Enterprise_ID__c='testsearchid';
        terr.District_Manager_Name_Short__c='District Manager';
        //terr.EID_length__c ='true';
        insert terr;
        
          Territory__c terr1 = new Territory__c();
        terr1.Territory_ID__c ='111';
        terr1.FIRST_NAME__c ='testFname';
        terr1.LAST_NAME__c='testLname';
        terr1.Enterprise_ID__c='testid';
        terr1.District_Manager_Name_Short__c='District Manager';
        //terr.EID_length__c ='true';
        insert terr1;
        
        
        

     
     }
 }