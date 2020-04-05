public class SalesCycleLogActionHandler implements ITrigger {
    private Map<Id, Sales_Cycle_Log__c> sclMap = new Map<Id, Sales_Cycle_Log__c>();
    private Map<Id, List<Sales_Cycle_Log_Action__c>> sclaMap = new Map<Id, List<Sales_Cycle_Log_Action__c>>();

    public SalesCycleLogActionHandler(){
        
    }

    public void bulkBefore(){
        if(Trigger.isInsert){
            List<Id> scls = new List<Id>();
            
            for(Sales_Cycle_Log_Action__c scla : (List<Sales_Cycle_Log_Action__c>)Trigger.new){
                scls.add(scla.Sales_Cycle_Log__c);
            }

            for(Sales_Cycle_Log__c scl : [SELECT Id, CreatedDate FROM Sales_Cycle_Log__c WHERE Id IN :scls]){
                if(!sclMap.containsKey(scl.Id)){
                    sclMap.put(scl.Id, scl);
                }
            }

            for(Sales_Cycle_Log_Action__c scla : [SELECT Sales_Cycle_Log__c, CreatedDate FROM Sales_Cycle_Log_Action__c WHERE Sales_Cycle_Log__c IN :scls ORDER BY CreatedDate DESC]){
                if(!sclaMap.containsKey(scla.Sales_Cycle_Log__c)){
                    sclaMap.put(scla.Sales_Cycle_Log__c, new List<Sales_Cycle_Log_Action__c>());
                }

                sclaMap.get(scla.Sales_Cycle_Log__c).add(scla);
            }
        }
    }

    public void bulkAfter(){   

    }

    public void beforeInsert(Sobject obj){
        Sales_Cycle_Log_Action__c newSCLA = (Sales_Cycle_Log_Action__c)obj;

        if(sclMap.containsKey(newSCLA.Sales_Cycle_Log__c)){
            Datetime oldCreatedDate = null;
            DateTime newCreateDate = newSCLA.CreatedDate == null ? System.now() : newSCLA.CreatedDate;

            if(sclaMap.containsKey(newSCLA.Sales_Cycle_Log__c) && sclaMap.get(newSCLA.Sales_Cycle_Log__c).size() > 0){
                for(Sales_Cycle_Log_Action__c scla : sclaMap.get(newSCLA.Sales_Cycle_Log__c)){
                    oldCreatedDate = oldCreatedDate == null ? scla.CreatedDate : oldCreatedDate < scla.CreatedDate ? scla.CreatedDate : oldCreatedDate;
                }
            }
            else{
                oldCreatedDate = sclMap.get(newSCLA.Sales_Cycle_Log__c).CreatedDate;
            }

            System.debug('***** Times: ' + oldCreatedDate + ' ' + newCreateDate);
            newSCLA.Time_Between_Lead_Status__c = (Decimal.valueOf(newCreateDate.getTime() - oldCreatedDate.getTime())/1000/60/60/24).setScale(2);
        }
    }

    public void beforeUpdate(Sobject oldObj, Sobject newObj){

    }

    public  void beforeDelete(Sobject obj){

    }

    public void afterInsert(Sobject obj){
        
    }

    public void afterUpdate(Sobject oldObj, Sobject newObj){
        
    }

    public void afterDelete(Sobject obj){

    }

    public void andFinally(){
        
    }

    //***************************Helper Methods******************************
}