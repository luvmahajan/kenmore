Trigger UpdateNAICSIDs on Account (before update) {
    /***
List<string> sapcode = new List<string>();
Map<string, Industry_Segment__c>  industrysegmentmap= new Map<string, Industry_Segment__c>();

For( Account newAcc :Trigger.new){
    Sapcode.add( newAcc.SAP_NAICS_Code__C);
}

If(sapcode.Size()>0){
    For(Industry_Segment__c NewIds :[SELECT ID, Business_Sector__c,SAP_NAICS_Code__c FROM Industry_segment__c WHERE SAP_NAICS_Code__c IN: sapcode]){
        industrysegmentmap.put(NewIds.SAP_NAICS_Code__c,NewIds);
    } 
}
for (Account newAcc : Trigger.new) {
    If(!String.isBlank(newAcc.SAP_Account_ID__c)){      
        If(industrysegmentmap.containskey(newAcc.SAP_NAICS_Code__c)){
            newAcc.Industry_Segment__c = industrysegmentmap.get(newAcc.SAP_NAICS_Code__c).Id;
            newAcc.Business_Sector__c = industrysegmentmap.get(newAcc.SAP_NAICS_Code__c).Business_Sector__c;
        }
    }
 
 }
 ***/
}