public class ContractHandler implements ITrigger {
    
    public void bulkBefore() {}
    
    public void bulkAfter() {}
    
    public void beforeInsert(Sobject obj) {
        Contract objcontract = (Contract) obj;
        
                string legal_user = '';
        List<User> lstUser = new List<User>();
        lstUser = [SELECT Id, Name FROM User WHERE Name='Donna Carollo' LIMIT 1];
        if(lstUser.size()>0){
            legal_user = lstUser[0].Id;
        }
        
        
        objcontract.Legal_Approver__c = legal_user;
        
    }
    
    public void beforeUpdate(Sobject oldObj, Sobject newObj) {}
    
    public void beforeDelete(Sobject obj) {}
    
    public void afterInsert(Sobject obj) {
        Contract objcontract = (Contract) obj;
        System.debug('objcontract--> ' + objcontract);
        System.debug('objcontract.SBQQ__Quote__c--> ' + objcontract.SBQQ__Quote__c);
        
        Contract_Line_Item__c objContractLineItem = new Contract_Line_Item__c();
        List<Contract_Line_Item__c> lstContractLineItem = new List<Contract_Line_Item__c>();
        
        if(objcontract.SBQQ__Quote__c!=null){
            
            List<SBQQ__QuoteLine__c> lstQuoteLine = new List<SBQQ__QuoteLine__c>();
            
            lstQuoteLine = [SELECT Id, Name, SBQQ__Product__c, SBQQ__Quantity__c, SBQQ__Quote__c, 
                            	List_Price__c, Net_Unit_Price__c, Net_Total_Price__c, Disposable_Fee__c, 
                            	isProductParent__c, SBQQ__Number__c, Feature__c,ProductParentUnique__c, Tax_Rate__c,
                            	Configuration_Code__c, Configuration_Option__c
                            FROM SBQQ__QuoteLine__c 
                            WHERE SBQQ__Quote__c=:objcontract.SBQQ__Quote__c
                           ];
            
            if(lstQuoteLine.size()>0){
                
                for(SBQQ__QuoteLine__c ql:lstQuoteLine){
                    objContractLineItem = new Contract_Line_Item__c();
                    objContractLineItem.Contract__c = objcontract.Id;
                    objContractLineItem.Product__c = ql.SBQQ__Product__c;
                    objContractLineItem.Total_Quantity__c = ql.SBQQ__Quantity__c;
                    objContractLineItem.Total_Amount__c = ql.Net_Total_Price__c;
                    objContractLineItem.Tax_Rate__c = ql.Tax_Rate__c!=null?ql.Tax_Rate__c:0;
                    objContractLineItem.Status__c = 'Open';
                //    objContractLineItem.Feature__c = ql.SBQQ__ProductOption__r.SBQQ__Feature__r.Name;
                    objContractLineItem.Feature__c = ql.Feature__c;
                    objContractLineItem.Configuration_Code__c = ql.Configuration_Code__c;
                    objContractLineItem.Configuration_Option__c = ql.Configuration_Option__c;
                    objContractLineItem.Items_Processed__c = 0;
                    objContractLineItem.Amount_Processed__c = 0;
                    objContractLineItem.isProductParent__c = ql.isProductParent__c;
                    objContractLineItem.ProductParentUnique__c = ql.ProductParentUnique__c;
                    objContractLineItem.Number__c = ql.SBQQ__Number__c;
                    objContractLineItem.List_Unit_Price__c = ql.List_Price__c;
                    objContractLineItem.Net_Unit_Price__c = ql.Net_Unit_Price__c;
                    objContractLineItem.Disposable_Fee__c = ql.Disposable_Fee__c;
                    lstContractLineItem.add(objContractLineItem);
        			System.debug('objContractLineItem--> ' + objContractLineItem);
                }
                
                insert lstContractLineItem;
        		System.debug('lstContractLineItem--> ' + lstContractLineItem);
            }
            
            List<Attachment> lstAttachment = new List<Attachment>();
            lstAttachment = [SELECT Id, ParentId, Name, ContentType, Body 
                             FROM Attachment 
                       //      WHERE ParentId='a2bW0000000kNKTIA2'
                             WHERE ParentId=:objcontract.SBQQ__Quote__c AND Name LIKE '%(signed).pdf'
                             ORDER BY CreatedDate DESC
                             LIMIT 1
                            ];
            
            if(!Test.isRunningTest()){
                if(lstAttachment.size()>0){
            Attachment attach = new Attachment();
            attach.Body = lstAttachment[0].Body;
            attach.Name = lstAttachment[0].Name;
            attach.ContentType = 'application/pdf';
            attach.ParentId = objcontract.Id;
            attach.IsPrivate = false;   
            insert attach;
                }
            }
           /* 
        if(!Test.isRunningTest()){
            Attachment attach = new Attachment();
            Blob body;      
            body = pdf.getContentAsPDF(); 
            system.debug('Body ' + body);
            attach.Body = body;
        //    attach.Name = 'Rider_' + contractId +'.pdf';
            attach.Name = 'Rider_' + string.valueof(system.now()) +'.pdf';
            attach.IsPrivate = false;       
            attach.ParentId = contractId;
            attach.ContentType = 'application/pdf';
            insert attach;
        }
        */
            
            
        }
        
        
    }
    
    public void afterUpdate(Sobject oldObj, Sobject newObj) {}
    
    public void afterDelete(Sobject obj) {}
    
    public void andFinally() {}
    
}