/**
 * Created by jirala on 4/13/2017.
 */

public without sharing class OpportunityHandler implements ITrigger{

    Map<String, List<Task>> contactTasks = new Map<String, List<Task>>();
    List<Task> tasksToUpdate = new List<Task>();


    public OpportunityHandler(){

    }

    public void bulkBefore(){

    }

    public void bulkAfter(){

        if(!Trigger.isDelete){

            if(Trigger.isUpdate) {

                List<Id> oppId = new List<Id>();
                Map<Id, Id> mapOppOwners = new Map<Id, Id>();

                for(Opportunity newOpp :(List<Opportunity>)Trigger.new){
                    oppId.add(newopp.Id);
                    mapOppOwners.put(newopp.Id, newopp.OwnerId);
                }


                //tasksToUpdate = CommonUtils.updateTaskOwner(oppId, Opportunity.sObjecttype, mapOppOwners);
                //System.debug('***** number of tasks to update: ' + tasksToUpdate.size());

            }
        }

    }

    public void beforeInsert(Sobject obj){

    }

    public void beforeUpdate(Sobject obj, Sobject newObj){

    }

    public  void beforeDelete(Sobject obj){

    }

    public void afterInsert(Sobject obj){

    }

    public void afterUpdate(Sobject obj, Sobject newObj){

    }

    public void afterDelete(Sobject obj){

    }

    public void andFinally(){

        // System.debug('***** size to update: ' + requestsToUpdate.size());
        if(tasksToUpdate.size() > 0){
            update tasksToUpdate;
        }

    }

}