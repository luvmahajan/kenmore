/*
 * Class    : 	ScheduledBatchContractRenewal
 *
 * Objective: 	This class is an implementation of the Schedulable interface. 
 *				It executes the batch class BatchContractRenewal
 *
 * Name/Org : 	Marc Lain/Bluewolf
 * Created  : 	7/18/2013
*/

global class ScheduledBatchContractRenewal implements Schedulable
{
   
   	global void execute(SchedulableContext sc) 
   	{
      	BatchContractRenewal bcr = new BatchContractRenewal(); 
      	database.executebatch(bcr);
   	}
}