@isTest
private class SandboxPostRefreshTest {
	
	static testmethod void test_method_one() {
		Profile p = [ SELECT id FROM Profile WHERE name = 'System Administrator' ];

        User user1;

        // https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_testing_tools_runas.htm
        System.runAs( new User( id = UserInfo.getUserId() ) ) {

            user1 = newUser( p.id, 'Alpha', 'Test 1', 'test1=salesforce.com@example.com' );

            insert user1;

        }

        TestDataFactory.setupCommonVariables();

        Test.startTest();

        Test.testSandboxPostCopyScript(
            new SandboxPostRefreshClass(), // apex class to run
            UserInfo.getOrganizationId(), // org id
            UserInfo.getOrganizationId(), // sandbox id
            'Test' // sandbox name
        );

        Test.stopTest();

        user1 = [ SELECT id, email FROM User WHERE id = :user1.id ];

        System.assertEquals( 'test1@salesforce.com', user1.email );

    }

    private static User newUser( ID profileId, String firstName, String lastName, String email ) {
        Integer rand = Math.round( Math.random() * 1000 );
        return new User(
            isActive = true,
            profileId = profileId,
            alias = firstName.substring(0,1) + lastName.substring(1,5),
            firstName = firstName,
            lastName = lastName,
            email = email,
            username = rand + email,
            emailEncodingKey = 'UTF-8',
            languageLocaleKey = 'en_US',
            localeSidKey = 'en_US',
            timeZoneSidKey = 'America/Chicago'
        );
    }	
}