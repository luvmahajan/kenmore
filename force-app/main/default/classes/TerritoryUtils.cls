//-------------------------------------------------------------------------------
//Add common Territory methods/variables here, update test class to keep 100% code coverage
//-------------------------------------------------------------------------------
public with sharing class TerritoryUtils {
	//Commonly used variables	
	public static Map<Id, List<ObjectTerritory2AssignmentRuleItem>> childTerritoryRules = new Map<Id, List<ObjectTerritory2AssignmentRuleItem>>();	
	public static Id activeTerritoryModel = [SELECT Id FROM Territory2Model WHERE State = 'Active'].Id;	
	public static Id districtTypeId = [SELECT Id FROM Territory2Type WHERE DeveloperName = 'District'].Id;
	public static Id territoryTypeId = [SELECT Id FROM Territory2Type WHERE DeveloperName = 'Territory'].Id;
	public static Map<String, List<User>> territoryUserMap = new Map<String, List<User>>();
	public static Map<String, List<Territory2>> childTerritories = new Map<String, List<Territory2>>();
	private static Map<String, ObjectTerritory2AssignmentRule> allRules = new Map<String, ObjectTerritory2AssignmentRule>();


	//Territory assignment utils---------------------------------------------------------------------------------
	public static Map<String, String> getDistrictMapping(List<String> postalCodes){
		Map<String, String> result = new Map<String, String>();
		Boolean sendEmail = false;
		String body = 'The following postal code(s) for Territory assignment where not found, please verify and add to Salesforce if needed:<br>';
		if(postalCodes.size() > 0){
            for(District_Mapping__c newZip :[SELECT Zip_Code__r.Name, District__c FROM District_Mapping__c WHERE Zip_Code__r.Name IN :postalCodes]){
            	if(!result.containsKey(newZip.Zip_Code__r.Name)){
                    result.put(newZip.Zip_Code__r.Name, newZip.District__c);
                }
            }
        }

        //check for unknown zip codes and email support
        for(String postalCode : postalCodes){
        	if(String.isNotBlank(postalCode) && postalCode.length() == 5 && !result.containsKey(postalCode)){
        		body = body + postalCode + '<br>';
        		sendEmail = true;
        	}
        }

        //if(sendEmail){
        //	body = body + '<br><br>';
        //	sendEmailMessage(new String[]{Common_Variables__c.getInstance('Group Email').Content__c}, null, 'Territory Assignment Postal Code Mising', body, true);
        //}

		return result;
	}

	//Get all users that are active for Round Robin and are in the supplied territories
	public static void getTerritoryUsers(){
		if(territoryUserMap.size() > 0){
			System.debug('***** called more than once...');
		}
		else{
			Set<Id> userIds = new Set<Id>();
			List<UserTerritory2Association> utas = [SELECT Territory2.Name, UserId, User.LastName FROM UserTerritory2Association WHERE Territory2.Territory2ModelId = :activeTerritoryModel AND Territory2.Territory2TypeId IN (:districtTypeId, :territoryTypeId)];

			for(UserTerritory2Association uta : utas){
	        	    if(!userIds.contains(uta.UserId)){
	        	    	userIds.add(uta.UserId);
	        	    }
	        }

	        List<User> activeUsers = [SELECT FirstName, LastName, Id, UserRole.Name, Is_Current_Round_Robin_Selection__c, Is_Round_Robin_Active__c FROM User WHERE IsActive = true AND Id IN :userids];      
	    	for(UserTerritory2Association uta : utas){
	    		for(User user : activeUsers){
		    		if(user.Id == uta.UserId){
		    			if(!territoryUserMap.containsKey(uta.Territory2.Name)){
		    				territoryUserMap.put(uta.Territory2.Name, new List<User>());
		    			}

		    			territoryUserMap.get(uta.Territory2.Name).add(user);
		    			break;
		    		}
	    		}
	    	}
    	}
	}

	public static void getChildrenTerritories(Boolean reset){
		if(!(childTerritories.size() > 0) || reset){
			List<Id> territoryIds = new List<Id>();
				
			List<Territory2> districts = [SELECT Id, Name FROM Territory2 WHERE Territory2ModelId = :activeTerritoryModel AND Territory2TypeId = :districtTypeId];
			
			List<Id> districtIds = new List<Id>();
			for(Territory2 dist : districts){
				districtIds.add(dist.Id);
			}
			List<Territory2> territories = [SELECT Id, Name, ParentTerritory2Id FROM Territory2 WHERE Territory2ModelId = :activeTerritoryModel AND Territory2TypeId = :territoryTypeId AND ParentTerritory2Id IN :districtIds];

			if(territories.size() > 0){
				for(Territory2 territory : territories){
					for(Territory2 dist : districts){
						if(dist.Id == Territory.ParentTerritory2Id){
							if(!childTerritories.containsKey(dist.Name)){
								childTerritories.put(dist.Name, new List<Territory2>());
							}

							childTerritories.get(dist.Name).add(territory);
							territoryIds.add(territory.Id);
						}
					}
				}
			}		

			//if we have child territories, get rules from territory management
			System.debug('***** child count: ' + territoryIds.size());
			if(territoryIds.size() > 0){
				//Lead assignment rules should be inactive so they don't
				List<ObjectTerritory2AssignmentRule> allInactiveRules = [SELECT Id, BooleanFilter FROM ObjectTerritory2AssignmentRule WHERE IsActive = false];
				for(ObjectTerritory2AssignmentRule rule : allInactiveRules){
					if(!allRules.containsKey(rule.Id)){
						allRules.put(rule.Id, rule);
					}
				}
				List<ObjectTerritory2AssignmentRuleItem> allInactiveRulesItems = [SELECT Id, Field, Operation, Value, RuleId, SortOrder from ObjectTerritory2AssignmentRuleItem WHERE RuleId IN :allInactiveRules];
				

				if(allInactiveRulesItems != null){
					System.debug('***** Rule count: ' + allInactiveRulesItems.size());
					for(RuleTerritory2Association ruleAssocation : [SELECT RuleId, Territory2Id FROM RuleTerritory2Association WHERE Territory2Id IN :territoryIds]){
						for(ObjectTerritory2AssignmentRuleItem ruleItem : allInactiveRulesItems){
							if(ruleItem.RuleId == ruleAssocation.RuleId){						
								System.debug('***** RuleIds matched');
								if(!childTerritoryRules.containsKey(ruleAssocation.Territory2Id)){
									childTerritoryRules.put(ruleAssocation.Territory2Id, new List<ObjectTerritory2AssignmentRuleItem>());
								}
								System.debug('***** rule association found: ' + ruleAssocation.Territory2Id + ' : ' + ruleItem.Id);
								childTerritoryRules.get(ruleAssocation.Territory2Id).add(ruleItem);
							}
						}				
					}
				}
			}
		}
	}

	public static void removeTerritoryAssociation(List<UserTerritory2Association> utas){
		try{
			delete utas;
		}
		catch(DmlException e){
			System.debug('*****Error while deleting User Territory Association: ' + e.getMessage());
		}
	}

	public static String checkForChildTerritory(sObject obj, Schema.SObjectType objType, List<Territory2> territoryMap){
		String objectType = objType.getDescribe().getName();		
		String result = null;
		Boolean passed = false;

		if(objectType == 'Lead' && obj != null){			
			Map<String, Schema.SObjectField> M = Schema.SObjectType.Lead.fields.getMap();
			Lead leadObj = (Lead)obj;
			result = leadObj.Territory__c;

			if(String.isNotBlank(leadObj.GPO__c) || leadObj.LeadSource == Common_Variables__c.getInstance('FLS Lead Source Exception').Content__c ||
				(leadObj.Estimated_Opportunity_Amount__c != null && leadObj.Estimated_Opportunity_Amount__c < Decimal.valueOf(Common_Variables__c.getInstance('IST Lead Dollar Amount').Content__c))){
				return 'Inside Sales District';
			}

			if(territoryMap != null && territoryMap.size() > 0){
				Map<Integer,Boolean> ruleResultMap = new Map<Integer,Boolean>();
				System.debug('***** childTerr Count' + territoryMap.size());
				for(Territory2 territory : territoryMap){
					String ruleId = null;

					if(childTerritoryRules != null && childTerritoryRules.get(territory.Id) != null){
						for(ObjectTerritory2AssignmentRuleItem childTerritoryRule : childTerritoryRules.get(territory.Id)){	
							ruleId = childTerritoryRule.RuleId;
							ruleResultMap.put(Integer.valueOf(childTerritoryRule.SortOrder), checkRule(childTerritoryRule, M, leadObj));
						}
					}

					if(String.isNotBlank(ruleId)){
						ObjectTerritory2AssignmentRule territoryRule = allRules.get(ruleId);

						String filterLogic = territoryRule.BooleanFilter;
						if(String.isNotBlank(filterLogic)){
							filterLogic = filterLogic.replace('AND', '&').replace('OR','|').replace(' ','');
							System.debug('***** logic: ' + filterLogic);

							passed = compareFilterLogic(filterLogic, ruleResultMap);
						}
						else{
							if(ruleResultMap.containsKey(1)){
								passed = ruleResultMap.get(1);
							}
						}
					}
					
					//if we passed all rules
					if(passed){
						result = territory.Name;
					}
				}
			}

		}

		return result;
	}

	private static String checkForAddressConversion(String fieldName){
		String result = fieldName;
		System.debug('***** ' + fieldName);
		if(fieldName == 'BillingState' || fieldName == 'BillingStreet' || fieldName == 'BillingCity' || fieldName == 'BillingPostalCode'){
			result = fieldName.remove('Billing');
			System.debug('*****' + fieldName + ' : ' + result);
		}

		return result;
	}

	public static String getDistrictManager(String district, List<User> userList){
		String result = '';
        if(userList!=null){
		for(User user :userList){
			if(user.UserRole.Name.containsIgnoreCase('District Manager')){
				result = user.Id;
			}
		}
        }
		return result;
	}

	private static Boolean checkRule(ObjectTerritory2AssignmentRuleItem childTerritoryRule, Map<String, Schema.SObjectField> M, Lead leadObj){
		String fieldName = checkForAddressConversion(childTerritoryRule.Field.substringAfter('.'));						
		System.debug('***** field: ' + childTerritoryRule.Field);
		Schema.SObjectField field = M.get(fieldName);
		String leadObjFieldType = null;
		
		if(field != null){
			leadObjFieldType = CommonUtils.getFieldType(field);
		}

		if(leadObjFieldType != null){
			
			if(childTerritoryRule.Operation == 'equals'){
				System.debug('***** '+ leadObj.get(fieldName) + ' : ' + childTerritoryRule.Value);
				if(leadObj.get(fieldName) == childTerritoryRule.Value){
					return true;
				}
			}
			else if (childTerritoryRule.Operation == 'notEqual'){
				if(leadObj.get(fieldName) != childTerritoryRule.Value){
					return true;
				}
			}
			else if (childTerritoryRule.Operation == 'startsWith'){
				if(((String)leadObj.get(fieldName)).startsWithIgnoreCase(childTerritoryRule.Value)){
					return true;
				}							
			}
			else if (childTerritoryRule.Operation == 'contains'){
				if(((String)leadObj.get(fieldName)).contains(childTerritoryRule.Value)){
					return true;
				}
			}
			else if (childTerritoryRule.Operation == 'notContain'){
				if(!((String)leadObj.get(fieldName)).contains(childTerritoryRule.Value)){
					return true;
				}
			}
			else if (childTerritoryRule.Operation == 'lessThan'){
				if(leadObjFieldType == 'Date'){
					if(Date.valueOf(leadObj.get(fieldName)) < Date.valueOf(childTerritoryRule.Value)){
						return true;
					}
				}
				else if(leadObjFieldType == 'DateTime'){
					if(DateTime.valueOf(leadObj.get(fieldName)) < DateTime.valueOf(childTerritoryRule.Value)){
						return true;
					}
				}
				else if(leadObjFieldType == 'Integer'){
					if(Integer.valueOf(leadObj.get(fieldName)) < Integer.valueOf(childTerritoryRule.Value)){
						return true;
					}
				}
				else if(leadObjFieldType == 'Double'){
					if(Double.valueOf(leadObj.get(fieldName)) < Double.valueOf(childTerritoryRule.Value)){
						return true;
					}
				}
				else{
					if(String.valueOf(leadObj.get(fieldName)) < childTerritoryRule.Value){
						return true;
					}
				}							
			}
			else if (childTerritoryRule.Operation == 'lessOrEqual'){
				if(leadObjFieldType == 'Date'){
					if(Date.valueOf(leadObj.get(fieldName)) <= Date.valueOf(childTerritoryRule.Value)){
						return true;
					}
				}
				else if(leadObjFieldType == 'DateTime'){
					if(DateTime.valueOf(leadObj.get(fieldName)) <= DateTime.valueOf(childTerritoryRule.Value)){
						return true;
					}
				}
				else if(leadObjFieldType == 'Integer'){
					if(Integer.valueOf(leadObj.get(fieldName)) <= Integer.valueOf(childTerritoryRule.Value)){
						return true;
					}
				}
				else if(leadObjFieldType == 'Double'){
					if(Double.valueOf(leadObj.get(fieldName)) <= Double.valueOf(childTerritoryRule.Value)){
						return true;
					}
				}
				else{
					if(String.valueOf(leadObj.get(fieldName)) <= childTerritoryRule.Value){
						return true;
					}
				}	
			}
			else if (childTerritoryRule.Operation == 'greaterThan'){
				if(leadObjFieldType == 'Date'){
					if(Date.valueOf(leadObj.get(fieldName)) > Date.valueOf(childTerritoryRule.Value)){
						return true;
					}
				}
				else if(leadObjFieldType == 'DateTime'){
					if(DateTime.valueOf(leadObj.get(fieldName)) > DateTime.valueOf(childTerritoryRule.Value)){
						return true;
					}
				}
				else if(leadObjFieldType == 'Integer'){
					if(Integer.valueOf(leadObj.get(fieldName)) > Integer.valueOf(childTerritoryRule.Value)){
						return true;
					}
				}
				else if(leadObjFieldType == 'Double'){
					if(Double.valueOf(leadObj.get(fieldName)) > Double.valueOf(childTerritoryRule.Value)){
						return true;
					}
				}
				else{
					if(String.valueOf(leadObj.get(fieldName)) > childTerritoryRule.Value){
						return true;
					}
				}
			}
			else if (childTerritoryRule.Operation == 'greaterOrEqual'){
				if(leadObjFieldType == 'Date'){
					if(Date.valueOf(leadObj.get(fieldName)) >= Date.valueOf(childTerritoryRule.Value)){
						return true;
					}
				}
				else if(leadObjFieldType == 'DateTime'){
					if(DateTime.valueOf(leadObj.get(fieldName)) >= DateTime.valueOf(childTerritoryRule.Value)){
						return true;
					}
				}
				else if(leadObjFieldType == 'Integer'){
					if(Integer.valueOf(leadObj.get(fieldName)) >= Integer.valueOf(childTerritoryRule.Value)){
						return true;
					}
				}
				else if(leadObjFieldType == 'Double'){
					if(Double.valueOf(leadObj.get(fieldName)) >= Double.valueOf(childTerritoryRule.Value)){
						return true;
					}
				}
				else{
					if(String.valueOf(leadObj.get(fieldName)) >= childTerritoryRule.Value){
						return true;
					}
				}	
			}
		}	
		return false;						
	}

	private static Boolean compareFilterLogic(String filterLogic, Map<Integer,Boolean> ruleResultMap){
		Boolean result = false;

		Boolean tmpResult = false;

		Integer i = 0;
		do{
			if(i<filterLogic.length()){
				String character = filterLogic.substring(i,i+1);
				
				if(character.isNumeric()){
					result = ruleResultMap.get(Integer.valueOf(character));
				}
				else if (character == '|'){
					i = i+1;
					character = filterLogic.substring(i,i+1);
					tmpResult = ruleResultMap.get(Integer.valueOf(character));

					if(tmpResult || result){
						result = true;
					}
				}
				else if (character == '&'){
					i = i+1;
					character = filterLogic.substring(i,i+1);
					tmpResult = ruleResultMap.get(Integer.valueOf(character));

					if(tmpResult && result){
						result = true;
					}
					else{
						result = false;
					}
				}
			}
			i++;
		}while(i < filterLogic.length());

		return result;
	}
}