@isTest
private class MarketingPortalIFrameControllerTest {
	
	@isTest static void urlTestMethod() {
		MarketingPortalIFrameController event = new MarketingPortalIFrameController();
		string url = event.getURL();

		System.assert(String.isNotEmpty(url));
		System.assertEquals(url, String.format('https://www.scmarketingtools.com/?user={0}&key={1}', new String[]{UserInfo.getUserEmail(), 'test1234'}));
	}
	
}