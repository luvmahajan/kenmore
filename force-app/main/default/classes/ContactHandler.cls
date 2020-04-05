public class ContactHandler implements ITrigger {
    
    Map<String, List<Task>> contactTasks = new Map<String, List<Task>>();
    List<Task> tasksToUpdate = new List<Task>();
    
    public ContactHandler(){        
    }
    
    public void bulkBefore(){
        
    }
    
    public void bulkAfter(){
        
        if(!Trigger.isDelete){
            
            if(Trigger.isUpdate) {
                
                List<Id> contactId = new List<Id>();
                Map<Id, Id> mapContactOwners = new Map<Id, Id>();
                
                for(Contact newContact :(List<Contact>)Trigger.new){
                    contactId.add(newContact.Id);
                    mapContactOwners.put(newContact.Id, newContact.OwnerId);
                }
                
                //tasksToUpdate = CommonUtils.updateTaskOwner(contactId, contact.sObjecttype, mapContactOwners);
                
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