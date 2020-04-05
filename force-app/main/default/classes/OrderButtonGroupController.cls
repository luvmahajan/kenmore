public class OrderButtonGroupController {
    public String orderId {get; set;}
    public String status {get; set;}
    public String ordertype {get; set;}
    public String parentorder {get; set;}
    public List<String> lstOrderType {get; set;}
    public String selectedordertype {get; set;}
    public boolean renAdj {get; set;}
    public boolean renCM {get; set;}
    public boolean renDM {get; set;}
    public boolean renRX {get; set;}
    
    public boolean isPending {get; set;}
            
    public OrderButtonGroupController(){
        
        lstOrderType = new List<String>();
        
   //     renRE = true;
   //     renCD = true;
        
        renCM = false;
        renDM = false;
        renRX = false;
        
        status = '';
        ordertype = '';
        parentorder = '';
        
        orderId = ApexPages.CurrentPage().getparameters().get('id');
        
        List<Order> lstOrder = new List<Order>();
        
        lstOrder = [SELECT Id, Name, Status, type, Parent_Order__c 
                    FROM Order
                    WHERE ID =: orderId
                    LIMIT 1
                   ];
        
        if(lstOrder.size()>0){
            status = lstOrder[0].Status;
            ordertype = lstOrder[0].type;
            parentorder = lstOrder[0].Parent_Order__c;
        }
        
        selectedordertype = '';
        
        List<OrderItem> lstOrderLineItem = new List<OrderItem>();
        
        lstOrderLineItem = [SELECT Id, SBQQ__Status__c 
                            FROM OrderItem
                            WHERE OrderId =: orderId
                           ];
        
        for (OrderItem oli : lstOrderLineItem){
            if(oli.SBQQ__Status__c!='Cancelled'){
                renDM = true;
            }
            if(oli.SBQQ__Status__c=='Completed' || oli.SBQQ__Status__c=='In Process' || oli.SBQQ__Status__c=='Done' || oli.SBQQ__Status__c=='Returned' ){
                renCM = true;
            }
            if(oli.SBQQ__Status__c=='Completed' || oli.SBQQ__Status__c=='In Process' || oli.SBQQ__Status__c=='Done' ){
                renRX = true;
            }
        }
        
        if(renRX){
            lstOrderType.add('Return');
            lstOrderType.add('Exchange');
        }
        if(renCM){
            lstOrderType.add('Credit Memo');
        }
        if(renDM){
            lstOrderType.add('Debit Memo');
        }
        
        system.debug('lstOrderType--> ' + lstOrderType );
        system.debug('ordertype--> ' + ordertype );
        
        
        
        renAdj = true;
        
        isPending = false;
 //       isPending = true;
        
        if(ordertype != null && ordertype != '' && ordertype != 'Order' ){
            
            ProcessInstance objProcessInstance = new ProcessInstance();
            try{
                
                objProcessInstance = [SELECT Id, ProcessDefinitionId, ProcessDefinition.name, TargetObjectId, Status 
                                      FROM ProcessInstance 
                                      WHERE ProcessDefinition.Name = 'Order Adjustment Approval' AND TargetObjectId =: orderId 
                                      ORDER BY CreatedDate DESC 
                                      LIMIT 1
                                     ];
                system.debug('objProcessInstance--> ' + objProcessInstance );        
                if(objProcessInstance!=null){
                    if(objProcessInstance.Status == 'Pending'){
                        isPending = true;
                    }
                }
                
            }catch(exception c){
                system.debug('No Approval Present' );        
            }
            
            system.debug('isPending--> ' + isPending );        
            
        }
        
        
    }
   
    public list<selectoption> getOrderTypeDrop()
    {
        list<selectoption> lstSel= new list<selectoption>();
        lstSel.add(new SelectOption('', '--None--'));   
                      
        for(String ot:lstOrderType){
        	lstSel.add(new SelectOption(ot, ot));            
        }
        
        
        system.debug('lstSel:' +lstSel);
        
        return lstSel;
    }
    
         
    
    public PageReference gotoMSASign22(){
        system.debug('renAdj:' +renAdj);
        if(selectedordertype==null ){
        renAdj = false;
        system.debug('renAdj:' +renAdj);
            selectedordertype = '';
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select Adjustment Type'));   
            return null;
        }else{
        renAdj = true;
        system.debug('renAdj:' +renAdj);
        PageReference retURL = new PageReference('/apex/OrderAdjustmentCreation?id=' + orderId + '&adj=' + selectedordertype );
        retURL.setRedirect(true);
        return retURL;
        }
               
        
    }
    
    public PageReference gotoAdjustmentPage22(){
        
  //      PageReference retURL = new PageReference('/apex/OrderAdjustment?id=' + orderId + '&adj=' + ordertype + '&save=edit' );
        PageReference retURL = new PageReference('/apex/OrderAdjustmentEdit?id=' + orderId + '&adj=' + ordertype  );
        retURL.setRedirect(true);
        return retURL;
    }
            
    public PageReference gotoAdjustmentPage33(){
        
        String errMsg = '';
        
        errMsg = AdjustmentTaxCalculator.TaxCalcWrapper(orderId);
        if(errMsg == ''){
            //      PageReference retURL = new PageReference('/apex/OrderAdjustment?id=' + orderId + '&adj=' + ordertype + '&save=edit' );
            PageReference retURL = new PageReference('/apex/OrderAdjustmentSubmission?id=' + orderId + '&adj=' + ordertype );
            retURL.setRedirect(true);
            return retURL;
        }else{
            system.debug('errMsg:' +errMsg);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, errMsg));   
            return null;
        }
    }
    
    public PageReference gotoAdjustmentPage44(){
        
  //      PageReference retURL = new PageReference('/apex/OrderAdjustment?id=' + orderId + '&adj=' + ordertype + '&save=edit' );
        PageReference retURL = new PageReference('/apex/StandaloneEdit?id=' + orderId + '&adj=' + ordertype  );
        retURL.setRedirect(true);
        return retURL;
    }
            
    public PageReference gotoAdjustmentReschedule(){
        PageReference retURL = new PageReference('/apex/RescheduleCancel?id=' + orderId + '&action=reschedule' );
        retURL.setRedirect(true);
        return retURL;
    }
            
    public PageReference gotoAdjustmentCancel(){
        PageReference retURL = new PageReference('/apex/RescheduleCancel?id=' + orderId + '&action=cancel' );
        retURL.setRedirect(true);
        return retURL;
    }
            
    
}