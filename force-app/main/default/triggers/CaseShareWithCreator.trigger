trigger CaseShareWithCreator on Case (after update,after insert, before update, before insert) {
    //trigger CaseShareWithCreator on Case (after update, after insert) {
    
    List<Case> listCase = new List<Case>();
    List<String> listCaseEmail = new List<String>();
    Map<String,Contact> mapEmailContact = new Map<String,Contact>();
    Map<String,String> mapCaseEmail = new Map<String,String>();
    
    List<RecordType> listRecordType = new List<Recordtype>();
    listRecordType = [SELECT Id, Name FROM RecordType WHERE Name = 'Inside Sales' AND SobjectType='Case' LIMIT 1];
    
    List<CaseShare> CaseShareList = new List<CaseShare>();
    
    for(Case newCase: Trigger.new) {
        // if((Trigger.isUpdate && newCase.OwnerId<>trigger.oldMap.get(newCase.Id).OwnerId) || Trigger.IsInsert){
        if(Trigger.isAfter && ((Trigger.isUpdate && newCase.OwnerId<>trigger.oldMap.get(newCase.Id).OwnerId) || Trigger.IsInsert)){
            CaseShare caseShare = new CaseShare();
            caseShare.CaseId = newCase.Id;
            caseShare.UserOrGroupId = newCase.CreatedById;
            caseShare.CaseAccessLevel = 'Edit';
            CaseShareList.add(caseShare);
        }
        
        if(Trigger.IsBefore && listRecordType.size()>0 && (Trigger.IsInsert || (Trigger.isUpdate && newCase.SuppliedEmail<>trigger.oldMap.get(newCase.Id).SuppliedEmail))){
            if(newCase.RecordTypeId==listRecordType[0].Id){     
                listCaseEmail.add(newCase.SuppliedEmail);
                listCase.add(newCase);
                mapCaseEmail.put(newCase.Id, newCase.SuppliedEmail);
            }
        }
        
    }
    
 //   system.debug('listCase1--> ' + listCase );
 //   system.debug('listCaseEmail--> ' + listCaseEmail );
    
    
    List<Contact> listContactEmail = new List<Contact>();
    listContactEmail = [SELECT Id, name, AccountId, Email FROM Contact WHERE Email IN: listCaseEmail ];
    
    for(Contact con: listContactEmail) {
        mapEmailContact.put(con.Email,con);
    }
    
    for(Case ca: listCase) {
     //   ca.Type_of_Request__c = 'Place an order';
        if(mapEmailContact.get(ca.SuppliedEmail)!=null){
            ca.ContactId = mapEmailContact.get(ca.SuppliedEmail).Id;
            ca.AccountId = mapEmailContact.get(ca.SuppliedEmail).AccountId;
        }else{
            ca.ContactId = null;
            ca.AccountId = null;
        }
    }
    
 //   system.debug('listCase2--> ' + listCase );
    
    
    
    if(CaseShareList.size() > 0) {
        Database.SaveResult[] AssistRequestShareInsertResult = Database.insert(CaseShareList,False);
    }
    
}