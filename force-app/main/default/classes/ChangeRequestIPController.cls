public class ChangeRequestIPController{

    public Change_Request__c change_request_obj {get;set;}

    public ChangeRequestIPController()
    {
    }
    
    public ChangeRequestIPController(ApexPages.StandardController controller) {
         this.change_request_obj = (Change_Request__c)controller.getRecord();         
         
    }

    public PageReference goNext(){
        if(this.change_request_obj.Account_Name__c != null){
             return this.Next();
         }
       return null;
    }
 
   
    public PageReference Next(){
               
        Id myId = this.change_request_obj.Account_Name__c;   
        
        PageReference nextPage= new PageReference('/apex/ChangeRequestPage2?myId='+myId+'&tier=false');
        nextPage.setRedirect(true);
        return nextPage;
    }
        
    public PageReference Cancel(){

        PageReference page_reference_obj_after_cancel = new PageReference('/a1M/o');
        page_reference_obj_after_cancel.setRedirect(true);

        return page_reference_obj_after_cancel;
    }   
}