public class QuoteLineProductsController {

    public String quoteId {get; set;}
    public String parentUnique {get; set;}
    public List<LineProduct> lstLineProduct {get; set;}
    
    public String selFamily {get; set;}
    public String selCode {get; set;}
    public String selName {get; set;}
    public String selDivision {get; set;}
    public String selBrand {get; set;}
    public String selColor {get; set;}
    public String selLength {get; set;}
    public String selLength_op {get; set;}
    public String selWidth {get; set;}
    public String selWidth_op {get; set;}
    public String selHeight {get; set;}
    public String selHeight_op {get; set;}
    public String selWeight {get; set;}
    public String selWeight_op {get; set;}
    public String selADACompliant {get; set;}
    public String selEnergyCompliant {get; set;}

    public Set<String> setQLS {get; set;}
    public Set<String> setQLSCode {get; set;}
    
    public QuoteLineProductsController() {
    
        selFamily = '';
        selCode = '';
        selName = '';
        selDivision = '';
        selBrand = '';
        selColor = '';
        selADACompliant = '';
        selEnergyCompliant = '';
    
        quoteId = ApexPages.CurrentPage().getparameters().get('id');
        parentUnique = ApexPages.CurrentPage().getparameters().get('pu');
        
        system.debug('parentUnique--> ' + parentUnique );
        
        setQLS = new Set<String>();
        setQLSCode = new Set<String>();
        List<Quote_Line_Staging__c> lstQLS = new List<Quote_Line_Staging__c>();
        lstQLS = [SELECT Id, Name, Quote__c, Feature__c, Product__c, Product__r.ProductCode 
                  FROM Quote_Line_Staging__c
                  WHERE Quote__c =: quoteId AND (Feature__c=null OR Feature__c='' ) 
                 ];
        for(Quote_Line_Staging__c st:lstQLS){
        //    setQLS.add(st.Product__r.ProductCode);
            setQLS.add(st.Product__c);
            setQLSCode.add(st.Product__r.ProductCode);
        }
        system.debug('setQLS--> ' + setQLS );
        system.debug('setQLSCode--> ' + setQLSCode );
        
        lstLineProduct = new List<LineProduct>();
        actionApplyFilter();
        
    }
    
    public list<selectoption> getProductFamily()
    {
        list<selectoption> lstSel= new list<selectoption>();
        lstSel.add(new SelectOption('', '--None--'));            
        lstSel.add(new SelectOption('Products', 'Products'));            
    //    lstSel.add(new SelectOption('Services', 'Services'));            
        
        return lstSel;
    }
    
    public list<selectoption> getProductOperator(){
        list<selectoption> lstSel= new list<selectoption>();
        lstSel.add(new SelectOption('', '--None--'));            
        lstSel.add(new SelectOption('equals', 'equals'));            
        lstSel.add(new SelectOption('does not equal', 'does not equal'));            
        lstSel.add(new SelectOption('greater than equals', 'greater than equals'));
        lstSel.add(new SelectOption('less than equals', 'less than equals'));            
        lstSel.add(new SelectOption('greater than', 'greater than'));            
        lstSel.add(new SelectOption('less than', 'less than'));            
        return lstSel;
    }
    
    public list<selectoption> getCertification(){
        list<selectoption> lstSel= new list<selectoption>();
        lstSel.add(new SelectOption('', '--None--'));            
        lstSel.add(new SelectOption('TRUE', 'Yes'));            
        lstSel.add(new SelectOption('FALSE', 'No'));            
        return lstSel;
    }
    
    public PageReference gotoEditor()
    {
        system.debug('quoteId--> ' + quoteId );
            PageReference retURL = new PageReference('/apex/QuoteLineEditor?id=' + quoteId );
            retURL.setRedirect(true);
            return retURL;
    }
    
    
    public pagereference actionApplyFilter() {   
        
        Set<String> setFamily= new Set<String>();
        if(selFamily==null || selFamily==''){
            setFamily.add('');
            setFamily.add('Products');
       //     setFamily.add('Services');
        }else{
            setFamily.add(selFamily);
        }
                
        selCode= selCode.replaceAll( '\\s+', '').replaceAll( '-', '');
        
        String esc_selCode = '%' + String.escapeSingleQuotes(selCode) + '%';
        String esc_selCode_cmp = String.escapeSingleQuotes(selCode);
        String esc_selName = '%' + String.escapeSingleQuotes(selName) + '%';
        String esc_selDivision = '%' + String.escapeSingleQuotes(selDivision) + '%';
        String esc_selBrand = '%' + String.escapeSingleQuotes(selBrand) + '%';
        String esc_selColor = '%' + String.escapeSingleQuotes(selColor) + '%';
        
        String emp_selCode = selCode==''?selCode:esc_selCode;
        String emp_selName = selName==''?selName:esc_selName;
        String emp_selDivision = selDivision==''?selDivision:esc_selDivision;
        String emp_selBrand = selBrand==''?selBrand:esc_selBrand;
        String emp_selColor = selColor==''?selColor:esc_selColor;
        
        Decimal cmp_selLength = 0;
        Decimal cmp_selWidth = 0;
        Decimal cmp_selHeight = 0;
        Decimal cmp_selWeight = 0;
        
        try{
            cmp_selLength = (selLength==null || selLength=='' )?0:Decimal.valueof(selLength);    
            system.debug('cmp_selLength--> ' + cmp_selLength );
        if(
            ((selLength==null || selLength=='') && selLength_op!= null && selLength_op!='' && selLength_op.contains('than') )
            || ((selLength_op==null || selLength_op=='') && selLength!='' && selLength!=null )
        ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please enter valid filter for the Product Length'));
        }
            
                }catch(exception e){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please enter valid format for the Product Length'));
                }
        
        try{
            cmp_selWidth = (selWidth==null || selWidth=='' )?0:Decimal.valueof(selWidth);
            
        if(
            ((selWidth==null || selWidth=='') && selWidth_op!= null && selWidth_op!='' && selWidth_op.contains('than') )
            || ((selWidth_op==null || selWidth_op=='') && selWidth!='' && selWidth!=null )
        ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please enter valid filter for the Product Width'));
        }
            
                }catch(exception e){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please enter valid format for the Product Width'));
                }
        
        try{
            cmp_selHeight = (selHeight==null || selHeight=='' )?0:Decimal.valueof(selHeight);
            
        if(
            ((selHeight==null || selHeight=='') && selHeight_op!= null && selHeight_op!='' && selHeight_op.contains('than') )
            || ((selHeight_op==null || selHeight_op=='') && selHeight!='' && selHeight!=null )
        ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please enter valid filter for the Product Height'));
        }
            
                }catch(exception e){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please enter valid format for the Product Height'));
                }
        
        try{
            cmp_selWeight = (selWeight==null || selWeight=='' )?0:Decimal.valueof(selWeight);
            
        if(
            ((selWeight==null || selWeight=='') && selWeight_op!= null && selWeight_op!='' && selWeight_op.contains('than') )
            || ((selWeight_op==null || selWeight_op=='') && selWeight!='' && selWeight!=null )
        ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please enter valid filter for the Product Weight'));
        }
            
                }catch(exception e){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please enter valid format for the Product Weight'));
                }
        
            system.debug('setQLSCode--> ' + setQLSCode );
            system.debug('esc_selCode_cmp--> ' + esc_selCode_cmp );
        
        if(setQLSCode.contains(esc_selCode_cmp)){
            system.debug('c' );
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'The product already exists on Quote. Duplicates are not allowed.'));
        }
        
        
        List<Product2> lstProduct = new List<Product2>();
        
        lstProduct = [SELECT Id, Name, ProductCode, Description, IsActive, Family, Brand__c, Division__c                      
                      FROM Product2 
                      WHERE IsActive=true AND SBQQ__Component__c =false AND CanUseQuantitySchedule=false
                      AND ProductCode!=null
                      AND Family IN: setFamily 
                      AND (ProductCode LIKE: esc_selCode OR ProductCode=: emp_selCode ) 
                      AND (Name LIKE: esc_selName OR Name=: emp_selName ) 
                      AND (Division__c LIKE: esc_selDivision OR Division__c=: emp_selDivision ) 
                      AND (Brand__c LIKE: esc_selBrand OR Brand__c=: emp_selBrand ) 
                      ORDER BY ProductCode //LIMIT 700
                     ];

        system.debug('setQLS--> ' + setQLS );
        system.debug('setQLSCode--> ' + setQLSCode );
        
        system.debug('lstProduct-->' + lstProduct );
        system.debug('lstProduct.size()-->' + lstProduct.size() );
        
        List<String> lstProductId = new List<String>();
       List<String> lstProductCode = new List<String>();
        for(Product2 pri:lstProduct){
            if(!setQLS.contains(pri.Id)){
            lstProductId.add(pri.Id);
            lstProductCode.add(pri.ProductCode);
            }
        }
        
        SBQQ__Quote__c objQuote = new SBQQ__Quote__c();
        objQuote = [SELECT Id, Name, SBQQ__Account__c, SBQQ__Account__r.Pricing_Tier__c, SBQQ__Account__r.Price_List_Type__c
                    FROM SBQQ__Quote__c 
                    WHERE Id =: quoteId LIMIT 1
                   ];
        String accountId = objQuote.SBQQ__Account__c;
        String account_tier = objQuote.SBQQ__Account__r.Pricing_Tier__c;
        String account_price_type = objQuote.SBQQ__Account__r.Price_List_Type__c;
        
        List<Key_Account_Pricing__c> lstKAP = new List<Key_Account_Pricing__c>();
        lstKAP = [SELECT Id, Customer_KAP_price__c, Valid_from__c, Valid_to__c, Customer__c, Price_List_Type__c, Material_Number__c//, Product__c
                  FROM Key_Account_Pricing__c
           //       WHERE Product__c IN: lstProductId AND (Customer__c=: accountId OR Price_List_Type__c=:account_price_type)
                  WHERE Material_Number__c IN: lstProductCode AND (Customer__c=: accountId OR Price_List_Type__c=:account_price_type)
                    AND Valid_from__c<=:system.today() AND Valid_to__c>=:system.today()
                 ];
        
        Map<String, Double> mapKAP = new Map<String, Double>();
        Map<String, Double> mapCost = new Map<String, Double>();
        for(Key_Account_Pricing__c lk:lstKAP){
    //        mapKAP.put(lk.Product__c, lk.Customer_KAP_price__c);            
            mapKAP.put(lk.Material_Number__c, lk.Customer_KAP_price__c);
        }
        
        List<Product_Pricing__c> lstProductPricing = new List<Product_Pricing__c>();
        lstProductPricing = [SELECT Id, Price__c, Cost__c, Material_Number__c//, Product__c
                             FROM Product_Pricing__c
                        //     WHERE Product__c IN: lstProductId  
                             WHERE Material_Number__c IN: lstProductCode  
                             ORDER BY  Material_Number__c  
                            ];
        
        for(Product_Pricing__c lp:lstProductPricing){
     //       mapCost.put(lp.Product__c, lp.Cost__c);
            mapCost.put(lp.Material_Number__c, lp.Cost__c);
    //        if(mapKAP.get(lp.Product__c)==null){
            
            if(mapKAP.get(lp.Material_Number__c)==null){
                /*
                Double product_price = 0;
                if(account_tier=='Bronze'){
                    product_price = lp.Price__c*0.97;
                }else if(account_tier=='Silver'){
                    product_price = lp.Price__c*0.94;
                }else if(account_tier=='Gold'){
                    product_price = lp.Price__c*0.90;
                }else if(account_tier=='Platinum'){
                    product_price = lp.Price__c*0.87;
                }else{
                    product_price = lp.Price__c;
                }
*/
            //    mapKAP.put(lp.Product__c, product_price);
            //    mapKAP.put(lp.Material_Number__c, product_price);
                mapKAP.put(lp.Material_Number__c, lp.Price__c);
            }
            
        }
        
        Map<String, Decimal> mapProductDimension2 = new Map<String, Decimal>();
    //    Map<String, Boolean> mapProductCertification2 = new Map<String, Boolean>();        
        Map<String, String> mapProductCertification = new Map<String, String>();        
        Map<String, String> mapProductColor2 = new Map<String, String>();
        Set<String> setDimensions1 = new Set<String>();
        setDimensions1.add('Depth');
        setDimensions1.add('Width');
        setDimensions1.add('Height');
        setDimensions1.add('Weight');
        setDimensions1.add('Length');
        setDimensions1.add('Color Family');
        setDimensions1.add('ADA Compliant');
        setDimensions1.add('Energy Star Compliant');
        setDimensions1.add('Length_Depth');
        
        List<Product_Specification__c> lstProdSpec1 = new List<Product_Specification__c>();
        lstProdSpec1 = [SELECT Id, Name, Product__c, Specification__c, Specification_Name__c 
                        FROM Product_Specification__c 
                        WHERE Product__c IN:lstProductId //AND Name='Dimensions'
                            AND Specification_Name__c IN: setDimensions1
                       ];

        for(Product_Specification__c ps1:lstProdSpec1){
            try{
                if(ps1.Name=='Dimensions'){
                    mapProductDimension2.put(ps1.Product__c+ps1.Specification_Name__c, decimal.valueOf(ps1.Specification__c));
                }else if(ps1.Name=='Certifications & Ratings' && ps1.Specification__c!=null && ps1.Specification__c!=''  ){
                    mapProductCertification.put(ps1.Product__c+ps1.Specification_Name__c, ps1.Specification__c);
           //         mapProductCertification2.put(ps1.Product__c+ps1.Specification_Name__c, boolean.valueOf(ps1.Specification__c));
                }else if(ps1.Name=='Color' && ps1.Specification__c!=null && ps1.Specification__c!='' ){
                    mapProductColor2.put(ps1.Product__c+ps1.Specification_Name__c, ps1.Specification__c);
                }
            }catch(exception e){
                system.debug('Error for Product--> ' + ps1.Product__c + ' and Specification--> ' + ps1.Specification_Name__c );
            }
        }

        
        lstLineProduct = new List<LineProduct>();
        List<LineProduct> lstLineProduct1 = new List<LineProduct>();
        LineProduct objLineProduct = new LineProduct();
        Map<String, String> mapDescription = new Map<String, String>();
        
        integer cnt = 0;
        for(Product2 pr:lstProduct){
        if(
        
                    (
                    selLength_op==null || selLength_op=='' 
                        || (selLength_op=='equals' && (((selLength==null || selLength=='') && mapProductDimension2.get(pr.Id+'Length')==null ) || (selLength!=null && selLength!='' &&  mapProductDimension2.get(pr.Id+'Length')!=null && mapProductDimension2.get(pr.Id+'Length')==cmp_selLength) )  )
                        || (selLength_op=='does not equal' && (((selLength==null || selLength=='') && mapProductDimension2.get(pr.Id+'Length')!=null ) || (selLength!=null && selLength!='' &&  mapProductDimension2.get(pr.Id+'Length')!=null && mapProductDimension2.get(pr.Id+'Length')!=cmp_selLength) )  )
                        || (selLength_op=='greater than equals' && mapProductDimension2.get(pr.Id+'Length')!=null && mapProductDimension2.get(pr.Id+'Length')>=cmp_selLength  )
                        || (selLength_op=='less than equals' && mapProductDimension2.get(pr.Id+'Length')!=null && mapProductDimension2.get(pr.Id+'Length')<=cmp_selLength  )
                        || (selLength_op=='greater than' && mapProductDimension2.get(pr.Id+'Length')!=null && mapProductDimension2.get(pr.Id+'Length')>cmp_selLength  )
                        || (selLength_op=='less than' && mapProductDimension2.get(pr.Id+'Length')!=null && mapProductDimension2.get(pr.Id+'Length')<cmp_selLength  )
                        )
                    
                    &&
                    
                    (
                    selWidth_op==null || selWidth_op=='' 
                        || (selWidth_op=='equals' && (((selWidth==null || selWidth=='') && mapProductDimension2.get(pr.Id+'Width')==null ) || (selWidth!=null && selWidth!='' &&  mapProductDimension2.get(pr.Id+'Width')!=null && mapProductDimension2.get(pr.Id+'Width')==cmp_selWidth) )  )
                        || (selWidth_op=='does not equal' && (((selWidth==null || selWidth=='') && mapProductDimension2.get(pr.Id+'Width')!=null ) || (selWidth!=null && selWidth!='' &&  mapProductDimension2.get(pr.Id+'Width')!=null && mapProductDimension2.get(pr.Id+'Width')!=cmp_selWidth) )  )
                        || (selWidth_op=='greater than equals' && mapProductDimension2.get(pr.Id+'Width')!=null && mapProductDimension2.get(pr.Id+'Width')>=cmp_selWidth  )
                        || (selWidth_op=='less than equals' && mapProductDimension2.get(pr.Id+'Width')!=null && mapProductDimension2.get(pr.Id+'Width')<=cmp_selWidth  )
                        || (selWidth_op=='greater than' && mapProductDimension2.get(pr.Id+'Width')!=null && mapProductDimension2.get(pr.Id+'Width')>cmp_selWidth  )
                        || (selWidth_op=='less than' && mapProductDimension2.get(pr.Id+'Width')!=null && mapProductDimension2.get(pr.Id+'Width')<cmp_selWidth  )
                        )
                    
                    &&
                    
                    (
                    selHeight_op==null || selHeight_op=='' 
                        || (selHeight_op=='equals' && (((selHeight==null || selHeight=='') && mapProductDimension2.get(pr.Id+'Height')==null ) || (selHeight!=null && selHeight!='' &&  mapProductDimension2.get(pr.Id+'Height')!=null && mapProductDimension2.get(pr.Id+'Height')==cmp_selHeight) )  )
                        || (selHeight_op=='does not equal' && (((selHeight==null || selHeight=='') && mapProductDimension2.get(pr.Id+'Height')!=null ) || (selHeight!=null && selHeight!='' &&  mapProductDimension2.get(pr.Id+'Height')!=null && mapProductDimension2.get(pr.Id+'Height')!=cmp_selHeight) )  )
                        || (selHeight_op=='greater than equals' && mapProductDimension2.get(pr.Id+'Height')!=null && mapProductDimension2.get(pr.Id+'Height')>=cmp_selHeight  )
                        || (selHeight_op=='less than equals' && mapProductDimension2.get(pr.Id+'Height')!=null && mapProductDimension2.get(pr.Id+'Height')<=cmp_selHeight  )
                        || (selHeight_op=='greater than' && mapProductDimension2.get(pr.Id+'Height')!=null && mapProductDimension2.get(pr.Id+'Height')>cmp_selHeight  )
                        || (selHeight_op=='less than' && mapProductDimension2.get(pr.Id+'Height')!=null && mapProductDimension2.get(pr.Id+'Height')<cmp_selHeight  )
                        )
                    
                    &&
                    
                    (
                    selWeight_op==null || selWeight_op=='' 
                        || (selWeight_op=='equals' && (((selWeight==null || selWeight=='') && mapProductDimension2.get(pr.Id+'Weight')==null ) || (selWeight!=null && selWeight!='' &&  mapProductDimension2.get(pr.Id+'Weight')!=null && mapProductDimension2.get(pr.Id+'Weight')==cmp_selWeight) )  )
                        || (selWeight_op=='does not equal' && (((selWeight==null || selWeight=='') && mapProductDimension2.get(pr.Id+'Weight')!=null ) || (selWeight!=null && selWeight!='' &&  mapProductDimension2.get(pr.Id+'Weight')!=null && mapProductDimension2.get(pr.Id+'Weight')!=cmp_selWeight) )  )
                        || (selWeight_op=='greater than equals' && mapProductDimension2.get(pr.Id+'Weight')!=null && mapProductDimension2.get(pr.Id+'Weight')>=cmp_selWeight  )
                        || (selWeight_op=='less than equals' && mapProductDimension2.get(pr.Id+'Weight')!=null && mapProductDimension2.get(pr.Id+'Weight')<=cmp_selWeight  )
                        || (selWeight_op=='greater than' && mapProductDimension2.get(pr.Id+'Weight')!=null && mapProductDimension2.get(pr.Id+'Weight')>cmp_selWeight  )
                        || (selWeight_op=='less than' && mapProductDimension2.get(pr.Id+'Weight')!=null && mapProductDimension2.get(pr.Id+'Weight')<cmp_selWeight  )
                        )
                   &&  ((selColor!=null && selColor!='' && mapProductColor2.get(pr.Id+'Color Family')!=null && (mapProductColor2.get(pr.Id+'Color Family').contains(selColor) || mapProductColor2.get(pr.Id+'Color Family') == selColor) ) || selColor==null || selColor=='' )
                  &&  ((mapProductCertification.get(pr.Id+'ADA Compliant')==selADACompliant && selADACompliant!=''  && selADACompliant!=null ) || selADACompliant=='' || selADACompliant==null ) 
                  &&  ((mapProductCertification.get(pr.Id+'Energy Star Compliant')==selEnergyCompliant && selEnergyCompliant!=''  && selEnergyCompliant!=null ) || selEnergyCompliant=='' || selEnergyCompliant==null  ) 
                    && mapKAP.get(pr.ProductCode)!=null && mapCost.get(pr.ProductCode)!=null 
        
        ){

                    objLineProduct = new LineProduct();
                    objLineProduct.seq_no = cnt+1;
                    
                    objLineProduct.product_id = pr.Id;
                    objLineProduct.product_code = pr.ProductCode;
                    objLineProduct.product_name = pr.Name;
          //          objLineProduct.product_family = pr.Family;
                    //      objLineProduct.list_price = mapKAP.get(pr.Id);//100;//ql.SBQQ__ListPrice__c;
                    objLineProduct.list_price = mapKAP.get(pr.ProductCode);//100;//ql.SBQQ__ListPrice__c;
               //     objLineProduct.description = pr.Description;
                    mapDescription.put(pr.ProductCode, pr.Description);
                    lstLineProduct1.add(objLineProduct);                    
                    cnt++;
        }  
        }

        integer cnt_lp = 100;
        for(LineProduct lp:lstLineProduct1){
        if(cnt_lp>0){
                    objLineProduct = new LineProduct();
                    objLineProduct.seq_no = lp.seq_no;
                    objLineProduct.product_id = lp.product_id ;
                    objLineProduct.product_code = lp.product_code ;
                    objLineProduct.product_name = lp.product_name ;
          //          objLineProduct.product_family = pr.Family;
                    //      objLineProduct.list_price = mapKAP.get(pr.Id);//100;//ql.SBQQ__ListPrice__c;
                    objLineProduct.list_price = lp.list_price;
                    objLineProduct.description = mapDescription.get(lp.product_code);
               //     mapDescription.put(pr.ProductCode, pr.Description);
                    lstLineProduct.add(objLineProduct);                    
                    cnt_lp--;
                    }
        }


        
    return null;
    } 
    
    public PageReference actionProduct(){
        String pid = System.currentPageReference().getParameters().get('pid');
        
        system.debug('parentUnique--> ' + parentUnique );
        if(parentUnique==null){
            PageReference retprod = new PageReference('/apex/ProductAccesorries?id=' + quoteId + '&prodid=' + pid );
            retprod.setRedirect(true);
            return retprod;
        }else{
            PageReference retprod = new PageReference('/apex/ProductAccesorries?id=' + quoteId + '&prodid=' + pid + '&pu=' + parentUnique );
            retprod.setRedirect(true);
            return retprod;
        }
        
//PageReference retprod = new PageReference('/apex/ProductAccesorries?id=' + quoteId + '&prodid=' + pid );
//PageReference retprod = new PageReference('/apex/DeliveryService?id=' + quoteId + '&prodid=' + pid );
//        return retprod;
    }
    
    
    
    public class LineProduct{
        public Integer seq_no {get;set;}
        public String product_id {get;set;}
        public String product_code {get;set;}
        public String product_name {get;set;}
      //  public String product_family {get;set;}
        public double list_price {get;set;}
        public String description {get;set;}
    }
    
}