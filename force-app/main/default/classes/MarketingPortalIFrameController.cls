public class MarketingPortalIFrameController {
    private String userEmail = UserInfo.getUserEmail();
    private String key = 'test1234';

    public String getURL() {
        return String.format('https://www.scmarketingtools.com/?user={0}&key={1}', new String[]{userEmail, key});
    }
}