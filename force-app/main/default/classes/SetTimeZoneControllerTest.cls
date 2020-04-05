@isTest
private class SetTimeZoneControllerTest {
	
	static testmethod void test_method_one() {
		SetTimeZoneController.getPreference('America/Cayman');
		SetTimeZoneController.setTimeZone('America/Cayman');

	}	
}