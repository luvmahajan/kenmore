public with sharing class AccountRedirectController {
    String recordId;
    public AccountRedirectController(ApexPages.StandardController stdController) {
        recordId = stdController.getId();
    }

    public PageReference redirect() {
        Profile p = [select name from Profile where id = :UserInfo.getProfileId()];
        System.debug('Current User Profile - ' + p.name);
        PageReference pageReference;
        String recordTypeId = ApexPages.CurrentPage().GetParameters().Get('RecordType');

        if ((p.name != 'Home Services Administrator') && (p.name != 'Home Services BIT') && (p.name != 'Standard Home Services User')) {
            pageReference =  Page.AccountCreationFlow;
            pageReference.setRedirect(true);
            pageReference.getParameters().put('id', recordId);
            return pageReference;
        } else {
           String hostname = ApexPages.currentPage().getHeaders().get('Host');
            String standardAccountCreate = 'https://'+hostname+'/001/e?';
            String urlEnd = '';
            if(String.isNotBlank(recordTypeId)) {
                urlEnd = 'RecordType=' + recordTypeId + '&nooverride=1';
            }
            else{
                urlEnd = 'nooverride=1';
            }
            standardAccountCreate = standardAccountCreate + urlEnd;
           pageReference = new PageReference(standardAccountCreate);
           pageReference.setRedirect(true);
           return pageReference;
        }
    }
}