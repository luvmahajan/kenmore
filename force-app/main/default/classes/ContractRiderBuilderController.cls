public class ContractRiderBuilderController {
    public String contractId {get; set;}
    public Boolean renTable {get; set;}
    public Boolean displayPopUp {get; set;}
    public Boolean displayPopUp2 {get; set;}
    public List<SelectRider> lstSelDefaultRider {get; set;}
    public List<Contract_Rider__c> lstContractRider {get; set;}
    public String addedTitle {get; set;}
    public String addedDescription {get; set;}
    public List<Contract_Rider__c> lstSelectedContractRider {get; set;}
    
    public ContractRiderBuilderController(ApexPages.StandardController stdController) {
        contractId = ApexPages.CurrentPage().getparameters().get('id');
        renTable = false;
        displayPopUp = false;
        displayPopUp2 = false;
        lstSelDefaultRider = new List<SelectRider>();
        lstContractRider = new List<Contract_Rider__c>();
        addedTitle = '';
        addedDescription = '';
        lstSelectedContractRider = new List<Contract_Rider__c>();
        
        List<Contract_Rider__c> lstDefaultRider = new List<Contract_Rider__c>();
        lstDefaultRider = [SELECT Id, Name, Title__c, Description__c, Contract__c, Sort_Order__c, isDefault__c 
                           FROM Contract_Rider__c 
                           WHERE isDefault__c = true
                           ORDER BY Sort_Order__c
                          ];
        if(lstDefaultRider.size()>0){
        SelectRider objSelDefaultRider = new SelectRider();
            for (Contract_Rider__c def:lstDefaultRider){
                objSelDefaultRider = new SelectRider();
                objSelDefaultRider.seq_no = Integer.valueOf(def.Sort_Order__c);
                objSelDefaultRider.sel_check = false;
                objSelDefaultRider.rider_title = def.Title__c;
                objSelDefaultRider.rider_desc = def.Description__c;
                lstSelDefaultRider.add(objSelDefaultRider);
            }
        }
        
        lstContractRider = [SELECT Id, Name, Title__c, Description__c, Contract__c, Sort_Order__c, isDefault__c 
                            FROM Contract_Rider__c 
                            WHERE isDefault__c = false AND Contract__c=:contractId
                            ORDER BY Sort_Order__c
                           ];
        if(lstContractRider.size()>0){
            renTable = true;
        lstSelectedContractRider.addAll(lstContractRider);
        }
              
    }   
    
    public PageReference addDefaults2(){
        PageReference retURL = new PageReference('/apex/DefaultRider?id=' + contractId);
        retURL.setRedirect(true);
        return retURL;
    }    
    
    public void addDefaults(){
        displayPopUp2 = true; 
    }    
    
    public void addCondition(){
        addedTitle = '';
        addedDescription = '';
        displayPopUp = true; 
    }    
    
    public void addSelectedCondition(){
        
        Contract_Rider__c objSelectedContractRider = new Contract_Rider__c();
        
        if(addedTitle != '' || addedDescription != '' ){
            objSelectedContractRider = new Contract_Rider__c();
            objSelectedContractRider.Title__c = addedTitle;
            objSelectedContractRider.Description__c = '<p>' + addedDescription + '</p>';
            objSelectedContractRider.Sort_Order__c = lstSelectedContractRider.size()+1;
            objSelectedContractRider.Contract__c = contractId;
            lstSelectedContractRider.add(objSelectedContractRider);
            
        }
        addedTitle = '';
        addedDescription = '';
        displayPopUp = false; 
        
        if(lstSelectedContractRider.size()>0){
            renTable = true;
        }
                
    }    
    
    public void CancelPopup() { 
        displayPopUp = false; 
    }     
    
    public void addSelectedCondition2(){
        
        Contract_Rider__c objSelectedContractRider = new Contract_Rider__c();
        
        for (SelectRider sr:lstSelDefaultRider){
            if(sr.sel_check == true){
            objSelectedContractRider = new Contract_Rider__c();    
            objSelectedContractRider.Title__c = sr.rider_title;
            objSelectedContractRider.Description__c = sr.rider_desc;
            objSelectedContractRider.Sort_Order__c = lstSelectedContractRider.size()+1;
            objSelectedContractRider.Contract__c = contractId;
            lstSelectedContractRider.add(objSelectedContractRider);
                
                
                sr.sel_check = false;
            }
        }
        
        displayPopUp2 = false; 
        
        if(lstSelectedContractRider.size()>0){
            renTable = true;
        }
        
    }    
    
    public void selectAllDefault(){
        
        Contract_Rider__c objSelectedContractRider = new Contract_Rider__c();
        
        for (SelectRider sr:lstSelDefaultRider){
            objSelectedContractRider = new Contract_Rider__c();
            objSelectedContractRider.Title__c = sr.rider_title;
            objSelectedContractRider.Description__c = sr.rider_desc;
            objSelectedContractRider.Sort_Order__c = lstSelectedContractRider.size()+1;
            objSelectedContractRider.Contract__c = contractId;
            lstSelectedContractRider.add(objSelectedContractRider);
            
            sr.sel_check = false;
        }
        
        displayPopUp2 = false; 
        
        if(lstSelectedContractRider.size()>0){
            renTable = true;
        }
        
    }    
    
    public void CancelPopup2() { 
        displayPopUp2 = false; 
    }     
    
    public PageReference actionQuickSave(){
        
        actionSaveHelper();        
        PageReference retURL = new PageReference('/apex/ContractRiderBuilder?id=' + contractId );
        retURL.setRedirect(true);
        return null;
    }    
    
    public PageReference actionSave(){
        
        actionSaveHelper();        
        PageReference retURL = new PageReference('/' + contractId );
        retURL.setRedirect(true);
        return retURL;
    }  
    
    public PageReference actionSaveGenerate(){
        
        actionSaveHelper();        
        createDocument();
        PageReference retURL = new PageReference('/' + contractId );
        retURL.setRedirect(true);
        return retURL;
    }  
    
    public void actionSaveHelper(){
        
        Set<String> setRiderDel = new Set<String>();
        
        for (Contract_Rider__c del:lstContractRider){
            setRiderDel.add(del.Id);
        }
        
        
        for (Contract_Rider__c ins:lstSelectedContractRider){
            if(ins.Id!=null){
        		setRiderDel.remove(ins.Id);
            }
        }
        
        if(setRiderDel.size()>0){
            List<Contract_Rider__c> lstContractRiderDel = new List<Contract_Rider__c>();
            lstContractRiderDel = [SELECT Id 
                                   FROM Contract_Rider__c 
                                   WHERE isDefault__c = false AND Contract__c=:contractId AND Id IN: setRiderDel
                                  ];
            if(lstContractRiderDel.size()>0){
                delete lstContractRiderDel;
            }
        }
        
        if(lstSelectedContractRider.size()>0){
            upsert lstSelectedContractRider;
        }
        
        
    }
    
    public PageReference actionCancel(){
        PageReference retURL = new PageReference('/' + contractId );
        retURL.setRedirect(true);
        return retURL;
    }  

    public PageReference GoToDocument(){
        PageReference retURL = new PageReference('/apex/ContractRiderDocument?id=' + contractId );
        retURL.setRedirect(true);
        return retURL;
    }    

    
    public void actionUp(){
        
        String ord = System.currentPageReference().getParameters().get('ord');
        	system.debug('ord--> ' + ord ); 
        
        Map<Decimal, Contract_Rider__c> mapSequence = new Map<Decimal, Contract_Rider__c>();
        
        for (Contract_Rider__c sc:lstSelectedContractRider){
            if(sc.Sort_Order__c==Decimal.valueof(ord) ){
                if(Decimal.valueof(ord)>1){
                sc.Sort_Order__c = sc.Sort_Order__c - 1;
                }
            }else if(sc.Sort_Order__c == (Decimal.valueof(ord)-1)){
                sc.Sort_Order__c = sc.Sort_Order__c+ 1;
            }
            mapSequence.put(sc.Sort_Order__c, sc);
        }
        
        lstSelectedContractRider.clear();
        for (integer i=1;i<=mapSequence.size();i++){
            lstSelectedContractRider.add(mapSequence.get(i));
        }
        
        
    }  
    
    public void actionDown(){
        
        String ord = System.currentPageReference().getParameters().get('ord');
        	system.debug('ord--> ' + ord ); 

        Map<Decimal, Contract_Rider__c> mapSequence = new Map<Decimal, Contract_Rider__c>();
        
        for (Contract_Rider__c sc:lstSelectedContractRider){
            if(sc.Sort_Order__c==Decimal.valueof(ord) ){
                if(Decimal.valueof(ord)<lstSelectedContractRider.size()){
                sc.Sort_Order__c = sc.Sort_Order__c + 1;
                }
            }else if(sc.Sort_Order__c == (Decimal.valueof(ord)+1)){
                sc.Sort_Order__c = sc.Sort_Order__c- 1;
            }
            mapSequence.put(sc.Sort_Order__c, sc);
        }
        
        lstSelectedContractRider.clear();
        for (integer i=1;i<=mapSequence.size();i++){
            lstSelectedContractRider.add(mapSequence.get(i));
        }
        
        
    }  
    
    public void actionDelete(){
        
        String ord = System.currentPageReference().getParameters().get('ord');
        	system.debug('ord--> ' + ord ); 
        
        Map<Decimal, Contract_Rider__c> mapSequence = new Map<Decimal, Contract_Rider__c>();
        
        for (Contract_Rider__c sc:lstSelectedContractRider){
            if(sc.Sort_Order__c>Decimal.valueof(ord) ){
                sc.Sort_Order__c = sc.Sort_Order__c - 1;
            	mapSequence.put(sc.Sort_Order__c, sc);
            }else if(sc.Sort_Order__c < Decimal.valueof(ord)){
            	mapSequence.put(sc.Sort_Order__c, sc);
            }
        }
        
        lstSelectedContractRider.clear();
        for (integer i=1;i<=mapSequence.size();i++){
            lstSelectedContractRider.add(mapSequence.get(i));
        }
        
    } 
    
    public void createDocument(){
        PageReference pdf = Page.ContractRiderDocument;
        pdf.getParameters().put('id',contractId);
        
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
        
    }
    
    
    public class SelectRider{
        public Integer seq_no {get;set;}
        public Boolean sel_check {get;set;}
        public String rider_title {get;set;}
        public String rider_desc {get;set;}
    }
    
    
}