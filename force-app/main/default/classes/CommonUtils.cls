//-------------------------------------------------------------------------------
//Add common methods/variables here, update test class to keep 100% code coverage
//-------------------------------------------------------------------------------
public with sharing class CommonUtils {
	//Commonly used Regex's 
	public static String postalCodeRegex = '^\\d{5}(-\\d{4})?$';

	//Commonly used variables
	public static Long automationControl = 0;
	public static Boolean userAssigned = false;
	public static Map<String,Boolean> isFirstRunMap = new Map<String, Boolean>();

	//Generic Regex checker, can use the regex's declared above or pass in custom one
	public static Boolean checkRegex(String regex, String stringToBeChecked){
		System.debug('***** ' + regex);
		System.debug('***** ' + stringToBeChecked);
		Pattern regexPattern = Pattern.compile(regex);
		Matcher patternMatcher = regexPattern.matcher(stringToBeChecked);
		return patternMatcher.matches();
	}

	//recursion prevention
	public static Boolean isFirstRun(String objectName){
		if(!isFirstRunMap.containsKey(objectName)){
			isFirstRunMap.put(objectName, false);
			return true;
		}
		else{
			return isFirstRunMap.get(objectName);
		}
	}

	public static Long getAutomationControl(){
		if(!(automationControl > 0)){
			automationControl = System.currentTimeMillis();
		}

		return automationControl;
	}

	public static String getAutomationControlTypes(Boolean validation, Boolean workflow, Boolean process){
		String result = '';

		if(validation){
			result = result + 'Validation, ';
		}
		if(workflow){
			result = result + 'Workflow, ';
		}
		if(process){
			result = result + 'Process, ';
		}

		return result;
	}

	//Email-------------------------------------------------------------------------------------------------------
	//public static void sendEmailMessage(String[] toAddresses, String[] ccAddresses, String subject, String body, Boolean html){
		// First, reserve email capacity for the current Apex transaction to ensure
		// that we won't exceed our daily email limits when sending email after
		// the current transaction is committed.
		//Messaging.reserveSingleEmailCapacity(toAddresses.size() + ccAddresses.size());

		// Processes and actions involved in the Apex transaction occur next,
		// which conclude with sending a single email.
		// Now create a new single email message object
		// that will send out a single email to the addresses in the To, CC & BCC list.
		//Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();		  

		// Assign the addresses for the To and CC lists to the mail object.
		//mail.setToAddresses(toAddresses);
		//if(ccAddresses != null){
			//mail.setCcAddresses(ccAddresses);
		//}

		// Specify the address used when the recipients reply to the email. 
		//mail.setReplyTo(Common_Variables__c.getInstance('Group Email').Content__c);

		// Specify the name used as the display name.
		//mail.setSenderDisplayName('Salesforce Support');

		// Specify the subject line for your email address.
		//mail.setSubject(subject);

		// Set to True if you want to BCC yourself on the email.
		//mail.setBccSender(false);

		// Optionally append the salesforce.com email signature to the email.
		// The email address of the user executing the Apex Code will be used.
		//mail.setUseSignature(false);

		// Specify the text content of the email.
		//mail.setSubject(subject);
		//if(html){
			//mail.setHtmlBody(body);
		//}
		//else{
			//mail.setPlainTextBody(body);			
		//}

		// Send the email you have created.
		//Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
	//}

	//Automate Owner assignment----------------------------------------------------------------------------------------
	public static sObject autoAssignOwner(sObject obj, Schema.SObjectType objType, List<User> usersList){
		String objectType = objType.getDescribe().getName();
		sObject result = null;
		userAssigned = false;

		if(objectType == 'Lead'){
			Lead leadObj = (Lead)obj;
			
			Id roundRobinUserId = null;

			if(usersList != null){
				roundRobinUserId = getRoundRobinOwner(usersList);
			}

			if(roundRobinUserId == null){
				String dm = '';

				if(TerritoryUtils.territoryUserMap.containsKey(leadObj.Territory__c)){
					dm = TerritoryUtils.getDistrictManager(leadObj.Territory__c, TerritoryUtils.territoryUserMap.get(leadObj.Territory__c));
				}

				if(String.isNotBlank(dm)){
					leadObj.OwnerId = dm;
				}
				else{
					leadObj.OwnerId = Common_Variables__c.getInstance('IST Queue Id').Content__c;
				}				
			}else{
				leadObj.OwnerId = roundRobinUserId;
				userAssigned = true;
			}

			result = leadObj;
		}
		//else if(objectType == 'Account'){
			//Account accObj = (Account)obj;

			//result = accObj;
		//}

		return result;
	}

	public static Id getRoundRobinOwner(List<User> usersList){
		Map<String, User> userMap = new Map<String, User>();
		List<String> sortThis = new List<String>();
		Boolean selectNextUser = false;
		Id result = null;

		for(User user : usersList)
		{
			if(user.Is_Round_Robin_Active__c && !user.UserRole.Name.containsIgnoreCase('District Manager')){
		   		userMap.put(user.LastName, user);
		   		sortThis.add(user.LastName);
			}
		}

		sortThis.sort(); // Sort by Name in this case    
		List<User> nameSortedUsers = new List<User>();

		for(String lastName : sortThis)
		{
			User user = userMap.get(lastName);
			if(selectNextUser || sortThis.size() == 1){
				result = user.Id;
				break;
			}
			if(user.Is_Current_Round_Robin_Selection__c){
				selectNextUser = true;
			}
		}

		//if we have users in the list but no one was assigned, default to first person in the list
		if(sortThis.size() > 0 && result == null){
			result = userMap.get(sortThis[0]).Id;
		}
		System.debug('result: ' + result);
		return result;
	}

	//get the type of the supplied field
	public static String getFieldType(Schema.SObjectField field){
		String result = '';
		Schema.DisplayType FldType = field.getDescribe().getType();
		if(FldType == null) return '';              // we can't say much about null with our current techniques
    	if(FldType == Schema.DisplayType.String)             return 'String';
    	if(FldType == Schema.DisplayType.Date)               return 'Date';
    	if(FldType == Schema.DisplayType.Datetime)           return 'Datetime';
    	if(FldType == Schema.DisplayType.Integer)            return 'Integer';
    	if(FldType == Schema.DisplayType.Double)             return 'Double';   // we can't distinguish between decimal and double
    	if(FldType == Schema.DisplayType.Currency)			 return 'Double';

		return result;
	}

	public static Map<String,List<Campaign>> getLeadCampaigns(List<Id> leadId){
		Map<String, List<Campaign>> result = new Map<String, List<Campaign>>();
		if(leadId != null && leadId.size() > 0){
			List<CampaignMember> memberResult = [SELECT LeadId, CampaignId FROM CampaignMember WHERE LeadId IN :leadId];
			Set<Id> campaigns = new Set<Id>();
			
			for(CampaignMember member : memberResult){
				if(!campaigns.contains(member.CampaignId)){		
					campaigns.add(member.CampaignId);
				}
			}

			if(memberResult != null && memberResult.size() > 0){
				List<Campaign> campaignResult = [SELECT Id FROM Campaign WHERE Id IN :campaigns];
				
				for(CampaignMember member : memberResult){
					for(Campaign cmp : campaignResult){
						if(member.CampaignId == cmp.Id){
							if(!result.containsKey(member.LeadId)){
								result.put(member.LeadId, new List<Campaign>());
							}
							result.get(member.LeadId).add(cmp);
						}
					}
				}
			}
		}

		return result;
	}

	public static Case createCase(String status, String subject, String description, String recordTypeId, String caseType, Id createdById){
		Case result = new Case();

		try{
			result.Status = status == null ? '' : status;
			result.Subject = subject == null ? '' : subject;
			result.Description = description == null ? '' : description;
			result.Type = caseType == null ? '' : caseType;
			if(String.isNotBlank(recordTypeId)){
				result.RecordTypeId = recordTypeId;
			}
			if(createdById != null){
				result.CreatedById = createdById;
				result.LastModifiedById = createdById;
			}
		}
		catch(Exception e){
			System.debug('***** exception' + e.getMessage() + ' : ' + e.getStackTraceString());
			result = null;
		}

		return result;
	}


	//Jeevana Start
	public static List<Task> updateTaskOwner(List<Id> ParentobjIds, Schema.SObjectType objType, map<Id,Id> mapOwners ){

		String SObjectType = objType.getDescribe().getName();

		List<task> tasks = new List<task>();
		List<task> tasksToUpdate = new List<task>();

		if (SObjectType == 'Account' || SObjectType == 'Opportunity'){
			for(Task openTask: [SELECT Id, OwnerId, WhatId FROM Task WHERE IsClosed = false AND WhatId IN :ParentobjIds] ){

				if(mapOwners.containsKey(openTask.WhatId) && openTask.OwnerId != mapOwners.get(openTask.WhatId)){
					openTask.OwnerId = mapOwners.get(openTask.WhatId);
					tasksToUpdate.add(openTask);
					system.debug('Tasks Ownership Util - Object Type is :' +SObjectType);
					system.debug('Tasks Ownership Util -  tasksadd loop = '+openTask);

				}
			}
		} else if (SObjectType == 'Contact' || SObjectType == 'Lead') {
			for(Task openTask: [SELECT Id, OwnerId, WhoId FROM Task WHERE IsClosed = false AND WhoId IN :ParentobjIds] ){

				if(mapOwners.containsKey(openTask.WhoId) && string.valueOf(mapOwners.get(openTask.WhoId)).startsWith('005') &&  openTask.OwnerId != mapOwners.get(openTask.WhoId)){
					openTask.OwnerId = mapOwners.get(openTask.WhoId);
					tasksToUpdate.add(openTask);
					system.debug('Tasks Ownership Util - Object Type is :' +SObjectType);
					system.debug('Tasks Ownership Util -  tasksadd loop = '+openTask);

				}
			}
		}

		system.debug('IN CommonUtil updateTaskOwner-  -  Return tasksToUpdate = '+tasksToUpdate);
		return tasksToUpdate;

	}
	//Jeevana End

	public static String getNAICSCode(String industry){
		String result = '23';
		if(String.isNotBlank(industry)){
			if(industry == 'Manufacturing'){
				result = '337110';
			}
			else if(industry.equalsIgnoreCase('Military')){
				result = '928810';
			}
			else if(industry.equalsIgnoreCase('Retail Trade')){
				result = '44-45';
			}
			else if(industry.equalsIgnoreCase('Transportation and Warehousing')){
				result = '48-49';
			}
			else if(industry.equalsIgnoreCase('Administrative and Support and Waste Management and Remediation Services')){
 				result = '56';
 			}
 			else if(industry.equalsIgnoreCase('Agriculture, Forestry, Fishing & Hunting')){
 				result = '11';
 			}
			else if(industry.equalsIgnoreCase('Arts, Entertainment, and Recreation')){
				result = '71';
			}
			else if(industry.equalsIgnoreCase('Education')){
				result = '61';
			}
			else if(industry.equalsIgnoreCase('Healthcare & Social Assistance')){
				result = '62';
			}
			else if(industry.equalsIgnoreCase('Information')){
				result = '51';
			}
			else if(industry.equalsIgnoreCase('Insurance Companies')){
				result = '52';
			}
			else if(industry.equalsIgnoreCase('Lodging')){
				result = '72';
			}
			else if(industry.equalsIgnoreCase('Management of Companies and Enterprises')){
				result = '55';
			}
			else if(industry.equalsIgnoreCase('Mining, Quarrying, and Oil and Gas')){
				result = '21';
			}
			else if(industry.startsWithIgnoreCase('Other Services')){
				result = '81';
			}
			else if(industry.equalsIgnoreCase('Professional, Scientific, and Technical Services')){
				result = '54';
			}
			else if(industry.equalsIgnoreCase('Property Management')){
				result = '53';
			}
			else if(industry.equalsIgnoreCase('Utilities')){
				result = '22';
			}
			else if(industry.equalsIgnoreCase('Wholesale Trade')){
				result = '42';
			}
			else if(industry.equalsIgnoreCase('Government')){
				result = '92';
			}
		}

		return result;
	}

	public static String getIndustry(String naicsCode){
		String result = 'Builders';
		if(String.isNotBlank(naicsCode)){
			if(naicsCode == '337110'){
				result = 'Manufacturing';
			}
			else if(naicsCode == '928810'){
				result = 'Military';
			}
			else if(naicsCode == '44-45'){
				result = 'Retail Trade';
			}
			else if(naicsCode == '48-49'){
				result = 'Transportation and Warehousing';
			}
			else if(naicsCode.startsWithIgnoreCase('56')){
 				result = 'Administrative and Support and Waste Management and Remediation Services';
 			}
 			else if(naicsCode.startsWithIgnoreCase('11')){
 				result = 'Agriculture, Forestry, Fishing & Hunting';
 			}
			else if(naicsCode.startsWithIgnoreCase('71')){
				result = 'Arts, Entertainment, and Recreation';
			}
			else if(naicsCode.startsWithIgnoreCase('61')){
				result = 'Education';
			}
			else if(naicsCode.startsWithIgnoreCase('62')){
				result = 'Healthcare & Social Assistance';
			}
			else if(naicsCode.startsWithIgnoreCase('51')){
				result = 'Information';
			}
			else if(naicsCode.startsWithIgnoreCase('52')){
				result = 'Insurance Companies';
			}
			else if(naicsCode.startsWithIgnoreCase('72')){
				result = 'Lodging';
			}
			else if(naicsCode.startsWithIgnoreCase('55')){
				result = 'Management of Companies and Enterprises';
			}
			else if(naicsCode.startsWithIgnoreCase('')){
				result = 'Mining, Quarrying, and Oil and Gas';
			}
			else if(naicsCode.startsWithIgnoreCase('81')){
				result = 'Other Services (except Public Administration)';
			}
			else if(naicsCode.startsWithIgnoreCase('54')){
				result = 'Professional, Scientific, and Technical Services';
			}
			else if(naicsCode.startsWithIgnoreCase('53')){
				result = 'Property Management';
			}
			else if(naicsCode.startsWithIgnoreCase('22')){
				result = 'Utilities';
			}
			else if(naicsCode.startsWithIgnoreCase('42')){
				result = 'Wholesale Trade';
			}
			else if(naicsCode.startsWithIgnoreCase('92')){
				result = 'Government';
			}
		}

		return result;
	}
}