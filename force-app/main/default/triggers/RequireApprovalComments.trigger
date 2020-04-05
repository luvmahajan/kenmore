trigger RequireApprovalComments on Change_Request__c  (before update) 
{
    // Create a map that stores all the objects that require editing 
    Map<Id, Change_Request__c > approvalStatements = new Map<Id, Change_Request__c >{};
    Change_Request__c inv2 = new Change_Request__c ();
    string com;
    string status;
    Id recordId;
    String comments;
    map <id, string> pn = new map<id, string>();
    
    for(Change_Request__c  inv: trigger.new)
    {
         recordId = inv.Id;   
         System.debug('recordId------------------'+recordId );
        // Put all objects for update that require a comment check in a map,
        // so we only have to use 1 SOQL query to do all checks  
        System.debug('inv.Approval_Comment_Check__c-----------------'+inv.Approval_Comment_Check__c );      
        if (inv.Approval_Comment_Check__c == 'Requested' )
        { 
            approvalStatements.put(inv.Id, inv);
            // Reset the field value to null, 
            // so that the check is not repeated,
            // next time the object is updated
            inv.Approval_Comment_Check__c = null; 
        }
    }  
    
    if (!approvalStatements.isEmpty())  
    {
        // UPDATE 2/1/2014: Get the most recent process instance for the approval.
        // If there are some approvals to be reviewed for approval, then
        // get the most recent process instance for each object.
        List<Id> processInstanceIds = new List<Id>{};
        
        for (Change_Request__c  invs : [  SELECT (SELECT ID
                                          FROM ProcessInstances
                                          ORDER BY CreatedDate DESC
                                          LIMIT 1)
              FROM Change_Request__c 
              WHERE ID IN :approvalStatements.keySet()])
        {
            system.debug('######nvsProcessInstances.##'+invs.ProcessInstances.size());
                processInstanceIds.add(invs.ProcessInstances[0].Id);
        }
       
        ProcessDefinition[] process_definition_ids = [Select id From ProcessDefinition where Name = 'Change Request Approval Process'];
        if(process_definition_ids.size() > 0) {
            ProcessDefinition process_definition_id = process_definition_ids[0];
            List<ProcessNode> process_node = [SELECT id, Name FROM ProcessNode where ProcessDefinitionId = :process_definition_id.Id];
             for(ProcessNode pnod :   process_node)
                pn.put(pnod.id, pnod.Name);
            
            // Now that we have the most recent process instances, we can check
            // the most recent process steps for comments.  
            for (ProcessInstance pi : [SELECT TargetObjectId,
                                      (SELECT Id, StepNodeId,StepStatus, Comments 
                                      FROM Steps
                                      ORDER BY CreatedDate DESC
                                      LIMIT 1 )
                                      FROM ProcessInstance
                                      WHERE Id IN :processInstanceIds
                                      ORDER BY CreatedDate DESC])
            {
                // If no comment exists, then prevent the object from saving.    
                
                if ((pi.Steps[0].Comments == null || pi.Steps[0].Comments.trim().length() == 0))
                {
                    approvalStatements.get(pi.TargetObjectId).addError(
                    'Operation Cancelled: Please provide a reason ' + 
                    'for your approval / rejection!');
                }
                
                
                com = pi.Steps[0].Comments ;
                status = pi.Steps[0].StepStatus ;
                System.debug('COMMENTS-----------------------------'+com);
                System.debug('StepsStatus-----------------------------'+pi.Steps[0].StepStatus);
                System.debug('StepsStatus-----------------------------'+pi.Steps[0].Id);
                System.debug('process_node[0].Name----------------------------'+process_node[0].Name);
                System.debug('process_node[0].Name----------------------------'+pi.Steps[0].StepNodeId);
                System.debug('processtepsss----------------------------'+pi.Steps);
                
                
                for(Change_Request__c inv: trigger.new){
                string sname = pn.get(pi.Steps[0].StepNodeId);
                integer i = process_node.size() -1;
                    if(status == 'Rejected'){
                        inv.Rejection_Comments__c = com;
                            comments = com;
                        }
                        
                        system.debug('#####status#######'+status);
                        system.debug('#####sname#######'+sname);
                        
                       if(status == 'Approved' && sname == 'Approval by District Manager'  ){
                           comments = com;
                            inv.Approver_Comments__c = com; 
                        }
                        if(sname == 'Approval by File Administrator' && status=='Approved'){ 
                            comments = com;
                            inv.File_Admin_Comments__c = com; 
                        }
                }
                
                       
            }
        }
            
    }
           
}