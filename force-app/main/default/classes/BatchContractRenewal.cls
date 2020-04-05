/*
 * Class    : 	BatchContractRenewal
 *
 * Objective: 	This batch class is executed everyday. It looks for Contracts that expire in 90 days
 *				and creates a new Opportunity using the data from the Contract.
 *
 * Name/Org : 	Marc Lain/Bluewolf
 * Created  : 	7/18/2013
*/

global class BatchContractRenewal implements Database.Batchable<sObject>
{
   	public String query { get; set; }
   	private Date futureDate = Date.today().addDays(90);
   	   	
   	global BatchContractRenewal()
	{
		query = 'SELECT Id, Name, Contract_End_Date__c, AccountId, Account.Name, Account.OwnerId FROM Contract WHERE Contract_End_Date__c =: futureDate';
		
		//Query for unit test
		if(Test.isRunningTest())
		{
			query = 'SELECT Id, Name, Contract_End_Date__c, AccountId, Account.Name, Account.OwnerId FROM Contract';
		}
		
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC)
	{
		return Database.getQueryLocator(query);
	}
	
	global void execute(Database.BatchableContext BC, list<sObject> scope)
	{
		List<Contract> contracts = (List<Contract>) scope;
		
		processContracts(contracts);
	}
	
	global void finish(Database.BatchableContext BC)
	{
		
	}
	
	public void processContracts(List<Contract> contracts)
	{
		List<Opportunity> oppsToInsert = new List<Opportunity>();
		
		String stage = ContractRenewalOpportunityFields__c.getInstance('Defaults').Opportunity_Stage__c;
		String recTypeId = ContractRenewalOpportunityFields__c.getInstance('Defaults').Opportunity_Record_Type__c;
		String business = ContractRenewalOpportunityFields__c.getInstance('Defaults').Opportunity_Business__c;
		 
		for(Contract c : contracts)
		{
			Opportunity opp = new Opportunity();
			opp.Name = c.Account.Name + ' ' + c.Contract_End_Date__c.year() + ' - Renewal';
			opp.AccountId = c.AccountId;
			opp.CloseDate = Date.today().addDays(30);
			opp.OwnerId = c.Account.OwnerId;
			opp.Amount = 0;
			opp.StageName = stage;
			opp.RecordTypeId = recTypeId;
			opp.Business__c = business;
			opp.Is_Created_From_Contract_Renewal__c = true;
			oppsToInsert.add(opp);
		}
		insert oppsToInsert;
	}
	
}