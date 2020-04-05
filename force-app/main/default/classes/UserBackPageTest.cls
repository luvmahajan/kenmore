@isTest
public class UserBackPageTest {
    static testMethod void Initiator_test(){
        UserBackPageInitiatorController ctredt = new UserBackPageInitiatorController();
        ctredt.gotoBackpage();
        
        User usr = new User();
        
        usr = [SELECT Id, Name, Title, Email, Phone
               FROM User
               WHERE isActive=true
               LIMIT 1
              ];
        
            Document doc = new Document();
            Blob body;  
            doc.Body = body;
            doc.Name = usr.Name.toUpperCase();
                  string  sysnow = String.valueOf(system.now()).remove(' ').remove('-').remove(':');
            string ran = String.valueOf(Math.mod(Math.round(Math.random()*100+1),100));
            system.debug('USER_' + sysnow + '_' + ran + '_' + usr.Name.toUpperCase().replace(' ','_').replace('-','_').remove('(').remove('(').remove(')').remove('\''));
            doc.DeveloperName = 'USER_' + sysnow + '_' + ran + '_' + usr.Name.toUpperCase().remove('(').replace(' ','_').replace('-','_').remove('(').remove(')').remove('\'');
            doc.FolderId = '00l3A000003YY7iQAG';
            doc.ContentType = 'application/pdf';
            doc.Type = 'pdf';
            insert doc;
            system.debug('doc--> ' + doc );
        
        
        ctredt.createDocument();
    }


    static testMethod void BackPage_test(){
        PageReference pageRef = Page.UserBackPage; 
        pageRef.getParameters().put('id', userinfo.getUserId());
        Test.setCurrentPage(pageRef);

        UserBackPageController ctredt = new UserBackPageController();
        pageRef.getParameters().put('id', userinfo.getUserId());
    }

}