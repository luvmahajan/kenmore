public class UpdateContractAmendment {
    
    @InvocableMethod
    public static void quoteBusiensshour_method(List<Id> qId) {
        
        System.debug('qId--> ' + qId);
        
        if(qId!=null){
            
            SBQQ__Quote__c objQuote = new SBQQ__Quote__c();
            
            objQuote = [SELECT Id, Name, SBQQ__MasterContract__c
                        FROM SBQQ__Quote__c 
                        WHERE Id IN: qId
                       ];
            
            if(objQuote.Id!=null && objQuote.SBQQ__MasterContract__c!=null ){
                
                List<SBQQ__QuoteLine__c> lstQuoteLine = new List<SBQQ__QuoteLine__c>();
                lstQuoteLine = [SELECT Id, Name, SBQQ__Product__c, SBQQ__Quantity__c, SBQQ__Quote__c, 
                                List_Price__c, Net_Unit_Price__c, Net_Total_Price__c, Disposable_Fee__c, 
                                isProductParent__c, SBQQ__Number__c, Feature__c,ProductParentUnique__c, Tax_Rate__c,
                                Configuration_Code__c, Configuration_Option__c
                                FROM SBQQ__QuoteLine__c 
                                WHERE SBQQ__Quote__c=:objQuote.Id
                                ORDER BY SBQQ__Number__c
                               ];
                
                List<Contract_Line_Item__c> lstContractLineItem = new List<Contract_Line_Item__c>();
                lstContractLineItem = [SELECT Id, Name, Contract__c, Amount_Processed__c, Amount_Remaining__c, Disposable_Fee__c, 
                                       Feature__c, Items_Processed__c, Items_Remaining__c, List_Unit_Price__c, Net_Unit_Price__c, 
                                       Number__c, ProductParentUnique__c, Product__c, Requested_Delivery_Date__c, Status__c, 
                                       Tax_Rate__c, Total_Amount__c, Total_Quantity__c, isProductParent__c, Configuration_Code__c, 
                                       Configuration_Option__c, Product_Code__c, Tax_Amount__c, Total_Tax_Amount__c, 
                                       Billed_Quantity__c, Billed_Value__c, Shipped_Quantity__c 
                                       FROM Contract_Line_Item__c 
                                       WHERE Contract__c=:objQuote.SBQQ__MasterContract__c
                                      ];
                
                Contract_Line_Item__c objContractLineItem = new Contract_Line_Item__c();
                List<Contract_Line_Item__c> lstContractLineItemUpsert = new List<Contract_Line_Item__c>();
                List<String> lstCLINonDelete = new List<String>();
                
                
                Map<String, Contract_Line_Item__c> mapContractLineItem = new Map<String, Contract_Line_Item__c>();
                Map<String, Boolean> mapIsProcessed = new Map<String, Boolean>();
                Set<String> setIsProcessed = new Set<String>();
                
                String clKey = '';
                String temp_clKey = '';
                
                for(Contract_Line_Item__c cl:lstContractLineItem){
                    System.debug('cl.Product__c--> ' + cl.Product__c + '  ||  cl.ProductParentUnique__c--> ' + cl.ProductParentUnique__c);
                    temp_clKey = cl.Product__c + cl.ProductParentUnique__c;
                    clKey = temp_clKey.substring(0,temp_clKey.length()-6);
              //      mapContractLineItem.put(cl.Product__c + cl.ProductParentUnique__c , cl);
                    mapContractLineItem.put(clKey , cl);
                    if(cl.Items_Processed__c>0 || cl.Amount_Processed__c>0 || cl.Billed_Quantity__c>0 || cl.Billed_Value__c>0 || cl.Shipped_Quantity__c>0 ){
                        setIsProcessed.add(cl.ProductParentUnique__c);
                    }
                }
                
                String qlKey = '';
                String temp_qlKey = '';
                
                for(SBQQ__QuoteLine__c ql:lstQuoteLine){
                    System.debug('ql.SBQQ__Product__c--> ' + ql.SBQQ__Product__c + '  ||  ql.ProductParentUnique__c--> ' + ql.ProductParentUnique__c);
                    objContractLineItem = new Contract_Line_Item__c();
                //    qlKey = ql.SBQQ__Product__c + ql.ProductParentUnique__c;
                    temp_qlKey = ql.SBQQ__Product__c + ql.ProductParentUnique__c;
                    qlKey = temp_qlKey.substring(0,temp_qlKey.length()-6);
                    
                    if(mapContractLineItem.keySet().contains(qlKey)){
                        objContractLineItem.Total_Quantity__c = ql.SBQQ__Quantity__c;
                        objContractLineItem.Total_Amount__c = ql.Net_Total_Price__c;
                        objContractLineItem.Tax_Rate__c = ql.Tax_Rate__c!=null?ql.Tax_Rate__c:0;
                        objContractLineItem.Feature__c = ql.Feature__c;
                        objContractLineItem.Configuration_Code__c = ql.Configuration_Code__c;
                        objContractLineItem.Configuration_Option__c = ql.Configuration_Option__c;
                        objContractLineItem.isProductParent__c = ql.isProductParent__c;
                        objContractLineItem.Number__c = ql.SBQQ__Number__c;
                        objContractLineItem.List_Unit_Price__c = ql.List_Price__c;
                        objContractLineItem.Net_Unit_Price__c = ql.Net_Unit_Price__c;
                        objContractLineItem.Disposable_Fee__c = ql.Disposable_Fee__c;
                        
                        objContractLineItem.Id = mapContractLineItem.get(qlKey).Id;
                        objContractLineItem.Amount_Processed__c = mapContractLineItem.get(qlKey).Amount_Processed__c;
                        //       objContractLineItem.Amount_Remaining__c = mapContractLineItem.get(qlKey).Amount_Remaining__c;
                        objContractLineItem.Items_Processed__c = mapContractLineItem.get(qlKey).Items_Processed__c;
                        //       objContractLineItem.Items_Remaining__c = mapContractLineItem.get(qlKey).Items_Remaining__c;
                        objContractLineItem.Requested_Delivery_Date__c = mapContractLineItem.get(qlKey).Requested_Delivery_Date__c;
                        objContractLineItem.Status__c = mapContractLineItem.get(qlKey).Status__c;
                        objContractLineItem.Billed_Quantity__c = mapContractLineItem.get(qlKey).Billed_Quantity__c;
                        objContractLineItem.Billed_Value__c = mapContractLineItem.get(qlKey).Billed_Value__c;
                        objContractLineItem.Shipped_Quantity__c = mapContractLineItem.get(qlKey).Shipped_Quantity__c;
                        objContractLineItem.Tax_Amount__c = mapContractLineItem.get(qlKey).Tax_Amount__c;
                        objContractLineItem.Total_Tax_Amount__c = mapContractLineItem.get(qlKey).Total_Tax_Amount__c;
                        lstCLINonDelete.add(qlKey);
                        System.debug('objContractLineItem--> ' + objContractLineItem);
                    }else{
                        objContractLineItem.Contract__c = objQuote.SBQQ__MasterContract__c;
                        objContractLineItem.Product__c = ql.SBQQ__Product__c;
                        objContractLineItem.Total_Quantity__c = ql.SBQQ__Quantity__c;
                        objContractLineItem.Total_Amount__c = ql.Net_Total_Price__c;
                        objContractLineItem.Tax_Rate__c = ql.Tax_Rate__c!=null?ql.Tax_Rate__c:0;
                        objContractLineItem.Status__c = 'Open';
                        objContractLineItem.Feature__c = ql.Feature__c;
                        objContractLineItem.Configuration_Code__c = ql.Configuration_Code__c;
                        objContractLineItem.Configuration_Option__c = ql.Configuration_Option__c;
                        objContractLineItem.Items_Processed__c = 0;
                        objContractLineItem.Amount_Processed__c = 0;
                        objContractLineItem.Billed_Quantity__c = 0;
                        objContractLineItem.Billed_Value__c = 0;
                        objContractLineItem.isProductParent__c = ql.isProductParent__c;
                        objContractLineItem.ProductParentUnique__c = ql.ProductParentUnique__c;
                        objContractLineItem.Number__c = ql.SBQQ__Number__c;
                        objContractLineItem.List_Unit_Price__c = ql.List_Price__c;
                        objContractLineItem.Net_Unit_Price__c = ql.Net_Unit_Price__c;
                        objContractLineItem.Disposable_Fee__c = ql.Disposable_Fee__c;
                        System.debug('objContractLineItem--> ' + objContractLineItem);
                    }
                    
                    lstContractLineItemUpsert.add(objContractLineItem);
                    
                    
                    
                }
            
                
                Integer iu_cli = lstContractLineItemUpsert.size();
                List<Contract_Line_Item__c> lstContractLineItemDelete = new List<Contract_Line_Item__c>();
                
                for(String mcli:mapContractLineItem.keySet()){
                    System.debug('mcli--> ' + mcli );
                    if(!lstCLINonDelete.contains(mcli) && setIsProcessed.contains(mapContractLineItem.get(mcli).ProductParentUnique__c) ){
                            iu_cli++;
                            objContractLineItem = new Contract_Line_Item__c();
                            objContractLineItem  = mapContractLineItem.get(mcli);
                            objContractLineItem.Number__c = iu_cli;
                        lstContractLineItemUpsert.add(objContractLineItem);
                        System.debug('mapContractLineItem.get(mcli)--> ' + mapContractLineItem.get(mcli));
                    }else if(!lstCLINonDelete.contains(mcli) && !setIsProcessed.contains(mapContractLineItem.get(mcli).ProductParentUnique__c) ){
                        lstContractLineItemDelete.add(mapContractLineItem.get(mcli));
                        System.debug('mapContractLineItem.get(mcli)--> ' + mapContractLineItem.get(mcli));
                    }
                }
                
                
                upsert lstContractLineItemUpsert;
                System.debug('lstContractLineItemUpsert.size()--> ' + lstContractLineItemUpsert.size());            
                
                
                delete lstContractLineItemDelete;
                System.debug('lstContractLineItemDelete.size()--> ' + lstContractLineItemDelete.size());            
                
            }
            
            
        }
        
        
        
        
    }
    
}