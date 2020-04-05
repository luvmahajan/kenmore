public class LeadHandler implements ITrigger {

    Map<String, String> postalCodeMap = new Map<String, String>();    
    List<Lead> leadsToUpdate = new List<Lead>();
    List<Task> tasksToUpdate = new List<Task>();
    List<Sales_Cycle_Log__c> sclToUpdate = new List<Sales_Cycle_Log__c>();
    //List<User> usersToUpdate = new List<User>();
    Map<String, List<Territory2>> territoryChildrenMap = new Map<String, List<Territory2>>();
    Map<Id, Boolean> usersToUpdate = new Map<Id, Boolean>();
    Map<String, List<Campaign>> leadCampaigns = new Map<String, List<Campaign>>();
    Map<String, List<Task>> leadTasks = new Map<String, List<Task>>();
     Map<Id, Sales_Cycle_Log__c> sclEntries = new Map<Id, Sales_Cycle_Log__c>();        
            
    public LeadHandler(){        
    }

    public void bulkBefore(){
        if(!Trigger.isDelete){
            List<String> postalCodes = new List<String>();
            List<Id> leadId = new List<Id>();

            For( Lead newLead :(List<Lead>)Trigger.new){
                if(String.isNotBlank(newLead.PostalCode)){
                    postalCodes.add(newLead.PostalCode.Left(5));
                }
                if(Trigger.isUpdate){
                    leadId.add(newLead.Id);
                }
            }

            postalCodeMap = TerritoryUtils.getDistrictMapping(postalCodes);       
            
            if(Trigger.isUpdate){     
                TerritoryUtils.getTerritoryUsers();
                TerritoryUtils.getChildrenTerritories(False);
                leadCampaigns = CommonUtils.getLeadCampaigns(leadId);                  
            }
        }
    }

    public void bulkAfter(){   
        if(!Trigger.isDelete){
            if(Trigger.isUpdate){
                List<Id> leadId = new List<Id>();
                List<Id> convertedLeadIds = new List<Id>();
                Map<Id, Id> mapLeadOwners = new Map<Id, Id>();

                For( Lead newLead :(List<Lead>)Trigger.new){
                    leadId.add(newLead.Id);                    
                    mapLeadOwners.put(newLead.Id, newLead.OwnerId);

                    if(newLead.isConverted){
                        convertedLeadIds.add(newLead.Id);
                    }
                }

                for(Sales_Cycle_Log__c scl : [select Contact__c, Opportunity__c, Account__c, Lead__c from Sales_Cycle_Log__c where lead__c in :convertedLeadIds ORDER BY LastModifiedDate DESC]){
                    if(!sclEntries.containsKey(scl.Lead__c)){
                        sclEntries.put(scl.Lead__c,scl);
                    }
                }


                tasksToUpdate = CommonUtils.updateTaskOwner(leadId, Lead.sObjecttype, mapLeadOwners);
            }
        }
    }

    public void beforeInsert(Sobject obj){
        Lead newObject = (Lead)obj;
        String newPostalCode = String.isNotBlank(newObject.PostalCode) ? newObject.PostalCode.Left(5) : '';

        //Territory Assignment
        if(postalCodeMap.containsKey(newPostalCode)){
            newObject.Territory__c = postalCodeMap.get(newPostalCode);
        }
    }

    public void beforeUpdate(Sobject oldObj, Sobject newObj){        
        Lead oldLead = (Lead)oldObj;
        Lead newLead = (Lead)newObj;
        String oldPostalCode = String.isNotBlank(oldLead.PostalCode) ? oldLead.PostalCode.Left(5) : '';
        String newPostalCode = String.isNotBlank(newLead.PostalCode) ? newLead.PostalCode.Left(5) : '';

        if((newPostalCode != oldPostalCode || String.isBlank(oldLead.Territory__c)) && postalCodeMap.containsKey(newPostalCode)){ 
            newLead.Territory__c = postalCodeMap.get(newPostalCode);
        }   

        //If we are not a field user, auto assign user on status change
        if(oldLead.Status != newLead.Status && newLead.Status == Common_Variables__c.getInstance('Auto Assignment Status Change').Content__c && String.isNotBlank(newLead.Territory__c)){
            String dm = null;
            Boolean dmRoute = false;
            Boolean childTerritoryFound = false;

            List<Campaign_Territory_Management_Exception__c> exceptionList = Campaign_Territory_Management_Exception__c.getall().values();

            //check custom settings for Campaign Ids that should bypass TM and go to DM
            //System.debug('***** member : campaigns - ' + leadCampaigns.size() + ' : ' +exceptionList.size());
            if(exceptionList != null && exceptionList.size() > 0 && leadCampaigns != null && leadCampaigns.containsKey(newLead.Id)){
                for(Campaign_Territory_Management_Exception__c exc : exceptionList){
                    for(Campaign cmp : leadCampaigns.get(newLead.Id)){
                        if(exc.CampaignId__c == cmp.Id){
                            dmRoute = true;
                            System.debug('***** camp exception found');
                        }
                    }
                }
            }

            String correctTerritory = TerritoryUtils.checkForChildTerritory(newLead,Lead.sObjectType,TerritoryUtils.childTerritories.get(newLead.Territory__c));

            //if we have a child territory don't send to DM
            if(correctTerritory != newLead.Territory__c && !dmRoute){
                childTerritoryFound = true;
            }

            if(dmRoute || (!Round_Robin_Toggle__c.getInstance(newLead.Territory__c).Round_Robin_Active__c && newLead.Estimated_Opportunity_Amount__c >= Decimal.valueOf(Common_Variables__c.getInstance('IST Lead Dollar Amount').Content__c))){
                dm = TerritoryUtils.getDistrictManager(newLead.Territory__c, TerritoryUtils.territoryUserMap.get(newLead.Territory__c));
                System.debug('***** DM - ' + dm);
            }

            if(String.isNotBlank(dm) && !childTerritoryFound){
                newLead.OwnerId = dm;
            }
            else{
                
                sObject result = CommonUtils.autoAssignOwner(newLead, Lead.sObjectType, TerritoryUtils.territoryUserMap.get(correctTerritory));

                if(result != null){
                    Lead leadResult = (Lead)result;
                    System.debug('***** ' + leadResult.OwnerId + ' - ' + newLead.OwnerId);
                    System.debug('***** ' + CommonUtils.userAssigned);

                    //If an actual user was assigned, update flags on user accounts
                    if(CommonUtils.userAssigned){
                        System.debug('***** user assigned');
                        for(User user : TerritoryUtils.territoryUserMap.get(correctTerritory)){
                            System.debug('***** ' + user.LastName);
                            if(user.Is_Current_Round_Robin_Selection__c){
                                usersToUpdate.put(user.Id, false);
                                continue;
                            }

                            if(user.Id == leadResult.OwnerId){
                                usersToUpdate.put(user.Id, true);
                                continue;
                            }
                        }
                    }
                }
            }
        }     
    }

    public  void beforeDelete(Sobject obj){

    }

    public void afterInsert(Sobject obj){
        
    }

    public void afterUpdate(Sobject oldObj, Sobject newObj){      
        Lead oldLead = (Lead)oldObj;
        Lead newLead = (Lead)newObj;

        if(newLead.isConverted && oldLead.isConverted != newLead.isConverted && sclEntries.containsKey(newLead.Id)){
            Sales_Cycle_Log__c scl = sclEntries.get(newLead.Id);
            scl.contact__c = newLead.ConvertedContactId;
            scl.opportunity__c = newLead.ConvertedOpportunityId;
            scl.account__c = newLead.ConvertedAccountId;

            sclToUpdate.add(scl);
        }
    }

    public void afterDelete(Sobject obj){

    }

    public void andFinally(){
        if(usersToUpdate.size() > 0){
            updateUsers(usersToUpdate);
        }
        if(tasksToUpdate.size() > 0){
            update tasksToUpdate;
        }
        if(sclToUpdate.size() > 0){
            update sclToUpdate;
        }
    }

    //***************************Helper Methods******************************
    @future
    private static void updateUsers(Map<Id, Boolean> userMap){
        List<User> users = [SELECT Id, Is_Current_Round_Robin_Selection__c FROM User WHERE Id IN :userMap.keySet()];

        if(users != null){
            for(User user : users){
                user.Is_Current_Round_Robin_Selection__c = userMap.get(user.Id);
            }
            update users;
        }
    }
}