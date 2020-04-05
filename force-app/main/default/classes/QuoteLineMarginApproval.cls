public class QuoteLineMarginApproval {
    
    @InvocableMethod
    public static void calculateLineMargin(List<Id> list_qId) {
        
        System.debug('list_qId--> ' + list_qId);
            String qId = '';
        if(list_qId!=null){
            qId = list_qId[0];
            
            SBQQ__Quote__c objQuote = new SBQQ__Quote__c();
            
            objQuote = [SELECT Id, Name, SBQQ__Status__c
                        FROM SBQQ__Quote__c 
                        WHERE Id =: qId
                       ];
            
            system.debug('objQuote--> ' + objQuote );
            
            List<SBQQ__QuoteLine__c> lstQuoteLine = new List<SBQQ__QuoteLine__c>();
            lstQuoteLine = [SELECT Id, Name, List_Price__c, Feature__c, Price_Source__c, SBQQ__AdditionalDiscountAmount__c, 
                            		List_Cost__c, Substituted_Product__c 
                            FROM SBQQ__QuoteLine__c 
                            WHERE SBQQ__Quote__c =: qId
                           ];
            
            Boolean sendForApproval = false;
            Double line_price = 0;
            Double line_cost = 0;
            Double line_margin = 0;
            
            
            for(SBQQ__QuoteLine__c ql:lstQuoteLine){
                line_price = 0;
                line_cost = 0;
                line_margin = 0;
                
                if((ql.Feature__c==null || ql.Feature__c=='Parts' ) && !sendForApproval && ql.Substituted_Product__c==null ){
                    if(ql.Price_Source__c==null || ql.Price_Source__c=='' || ql.Price_Source__c=='List' || ql.Price_Source__c=='KAP' ){
                        if(ql.Price_Source__c=='KAP' && ql.SBQQ__AdditionalDiscountAmount__c!=null && ql.SBQQ__AdditionalDiscountAmount__c>0){
                            sendForApproval = true;
                        }else if(ql.Price_Source__c==null || ql.Price_Source__c=='' || ql.Price_Source__c=='List'){
                            line_price = (ql.List_Price__c==null?0:ql.List_Price__c) - (ql.SBQQ__AdditionalDiscountAmount__c==null?0:ql.SBQQ__AdditionalDiscountAmount__c);
                            line_cost = ql.List_Cost__c==null?0:ql.List_Cost__c;
                            
                            system.debug('line_price--> ' + line_price );
                            system.debug('line_cost--> ' + line_cost );
                            
                      //      if(line_price > 0 && line_cost > 0 ){
                            if(line_price != 0 ){
                                line_margin = (line_price - line_cost)/line_price;
                                if(line_margin <= 0.23995 ){
                                    sendForApproval = true;
                                }
                            }else if(line_price == 0){
                                	line_margin = 0;
                                    sendForApproval = true;
                            }
                            
                                system.debug('line_margin--> ' + line_margin );
                                system.debug('sendForApproval--> ' + sendForApproval );
                            
                        }
                    } 
                }
                
            }
            
            system.debug('sendForApproval--> ' + sendForApproval );
            
            if(sendForApproval){
                
                Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
            //    req1.setComments('Quote Line Margin Approval.');
                req1.setObjectId(qId);
                
                req1.setSubmitterId(userinfo.getUserId()); 
                
                req1.setProcessDefinitionNameOrId('Quote_Approval_Process');
                req1.setSkipEntryCriteria(true);
                if(!Test.isRunningTest() ){
                    Approval.ProcessResult result = Approval.process(req1);
                    
                    List<Id> newWorkItemIds = result.getNewWorkitemIds();
                    system.debug('result.getInstanceStatus()--> ' + result.getInstanceStatus());
                    system.debug('result.isSuccess()--> ' + result.isSuccess());
                    system.debug('newWorkItemIds--> ' + newWorkItemIds);
                }
                
            }else{
                objQuote.SBQQ__Status__c = 'Document Preparation';
                update objQuote;
            }
            
        }
        
        
    }
    
}