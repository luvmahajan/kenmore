@isTest
public class StandaloneTest {

    static testMethod void edit_rx(){
        String orderid = '';
        String selectedAdjustment = 'Return';
        orderid = insertOrder(selectedAdjustment);
        
        system.debug('orderid--> ' + orderid );
        
        PageReference pageRef = Page.StandaloneEdit; 
        pageRef.getParameters().put('id', orderid);
        pageRef.getParameters().put('adj', selectedAdjustment);
        Test.setCurrentPage(pageRef);
        
        StandaloneEditController ctredt = new StandaloneEditController();

        ctredt.gotoOrder();
        ctredt.actionGoToSubmission();
        ctredt.getAdjustmentSelection();
        
        pageRef.getParameters().put('prcd', 'uncrate_k');
        pageRef.getParameters().put('key', 'ServicesSelect_One');
        Test.setCurrentPage(pageRef);
        
        ctredt.getAdjustmentSelection();
        ctredt.getAdjPart();
        ctredt.getPAWarrantyPart();
        ctredt.getInstallPart();
        
   //     ctredt.actionLoadProducts();
        ctredt.selectedAdjustment = 'Return';
        ctredt.selectedSCOAccount = '1100000007';
  //      ctredt.actionLoadProducts();
        ctredt.getHeaderReasonCode();
        
        
        ctredt.actionLoadAccessories();
        ctredt.selectedproductcode = '02608262000';
        ctredt.selectedzipcode = '60179';
        ctredt.actionLoadAccessories();
        
        
        ctredt.selInstallation = null;
        ctredt.selInstallPrice = null;
        ctredt.actionSelected();
        
        ctredt.getInstallationService();
        ctredt.selInstallation = null;
        ctredt.selInstallPrice = null;
        ctredt.actionInstallation();
        
        ctredt.actionAddToList();
        
        ctredt.checkAddress();
        ctredt.objOrderOverviewQry.Origin_Order_Date__c = system.today();
        ctredt.objOrderOverviewQry.Delivery_Charge__c = -1;
        ctredt.objOrderOverviewQry.Premium_Delivery_Charge__c = -1;
        ctredt.objOrderOverviewQry.Haulaway_Charge__c = -1;
        ctredt.checkAddress();

        ctredt.objOrderOverviewQry.Reason_Code__c = 'S12';
        ctredt.objOrderOverviewQry.Purchase_Number__c = '12';
        ctredt.objOrderOverviewQry.Shipping_Contact_First_Name__c = 'Fn';
        ctredt.objOrderOverviewQry.Shipping_Contact_Last_Name__c = 'Ln';
        ctredt.objOrderOverviewQry.Shipping_Contact_Phone__c = '1234567890';
        ctredt.objOrderOverviewQry.Shipping_Contact_Email__c = 'fn@ln.com';
        ctredt.objOrderOverviewQry.ShippingStreet = 'beverly st1 n dearborn';
        ctredt.objOrderOverviewQry.ShippingCity = 'beverly st1 n dearborn';
        ctredt.objOrderOverviewQry.ShippingState = 'IL';
        ctredt.objOrderOverviewQry.ShippingPostalCode = '60179';
        ctredt.objOrderOverviewQry.BillingStreet = 'beverly st1 n dearborn';
        ctredt.objOrderOverviewQry.BillingCity = 'beverly st1 n dearborn';
        ctredt.objOrderOverviewQry.BillingState = 'IL';
        ctredt.objOrderOverviewQry.BillingPostalCode = '60179';
        ctredt.objOrderOverviewQry.DOS_Order_Number__c = '23';
        ctredt.objOrderOverviewQry.RMA_Order_Number__c = '34';
        ctredt.objOrderOverviewQry.Origin_Order_Date__c = system.today().addDays(-1);
        ctredt.objOrderOverviewQry.Delivery_Charge__c = 1;
        ctredt.objOrderOverviewQry.Premium_Delivery_Charge__c = 1;
        ctredt.objOrderOverviewQry.Haulaway_Charge__c = 1;
        ctredt.checkAddress();
        ctredt.getAddressList();
        
        ctredt.selectedAddr = 'GEO CODE: 00 | COUNTY CODE: 031 | COUNTY NAME: COOK' ;
        ctredt.actionSaveAdjustment();
        
        ctredt.selectedSaveAdjustment = 'Exchange';
        ctredt.actionSaveAdjustment();
        
        ctredt.actionDelete();
        pageRef.getParameters().put('sid', '1');
        ctredt.actionDelete();
        
    }

    static testMethod void edit_cd(){
        String orderid = '';
        String selectedAdjustment = 'Credit Memo';
        orderid = insertOrder(selectedAdjustment);
        
        system.debug('orderid--> ' + orderid );
        
        PageReference pageRef = Page.StandaloneEdit; 
        pageRef.getParameters().put('id', orderid);
        pageRef.getParameters().put('adj', selectedAdjustment);
        Test.setCurrentPage(pageRef);
        
        StandaloneEditController ctredt = new StandaloneEditController();

        ctredt.gotoOrder();
        ctredt.actionGoToSubmission();
        ctredt.getAdjustmentSelection();
        
        pageRef.getParameters().put('prcd', 'uncrate_k');
        pageRef.getParameters().put('key', 'ServicesSelect_One');
        Test.setCurrentPage(pageRef);
        
        ctredt.getAdjustmentSelection();
        ctredt.getAdjPart();
        ctredt.getPAWarrantyPart();
        ctredt.getInstallPart();
        
  //      ctredt.actionLoadProducts();
        ctredt.selectedAdjustment = 'Credit Memo';
        ctredt.selectedSCOAccount = '1100000007';
  //      ctredt.actionLoadProducts();
        ctredt.getHeaderReasonCode();
        
        
        ctredt.actionLoadAccessories();
        ctredt.selectedproductcode = '02608262000';
        ctredt.selectedzipcode = '60179';
        ctredt.actionLoadAccessories();
        
        
        ctredt.selInstallation = null;
        ctredt.selInstallPrice = null;
        ctredt.actionSelected();
        
        ctredt.getInstallationService();
        ctredt.selInstallation = null;
        ctredt.selInstallPrice = null;
        ctredt.actionInstallation();
        
        ctredt.actionAddToList();
        
        ctredt.selectedmemoproductcode = '02608262000';
        pageRef.getParameters().put('type', 'prod');
        ctredt.FindProducts();
        ctredt.actionAddtoAdjustment();
        
        ctredt.selectedpart = '40010500000';
        pageRef.getParameters().put('type', 'part');
        ctredt.FindProducts();
        ctredt.actionAddtoAdjustment();
        
        ctredt.selectedprotection = '07062376000';
        pageRef.getParameters().put('type', 'prot');
        ctredt.FindProducts();
        ctredt.actionAddtoAdjustment();
        
        ctredt.selectedinstall = '01026200000';
        pageRef.getParameters().put('type', 'inst');
        ctredt.FindProducts();
        ctredt.actionAddtoAdjustment();
        
        
        

 //       ctredt.actionAddToList();

        
        ctredt.checkAddress();
        ctredt.objOrderOverviewQry.Origin_Order_Date__c = system.today();
        ctredt.objOrderOverviewQry.Delivery_Charge__c = -1;
        ctredt.objOrderOverviewQry.Premium_Delivery_Charge__c = -1;
        ctredt.objOrderOverviewQry.Haulaway_Charge__c = -1;
        ctredt.checkAddress();

        ctredt.objOrderOverviewQry.Reason_Code__c = 'S12';
        ctredt.objOrderOverviewQry.Purchase_Number__c = '12';
        ctredt.objOrderOverviewQry.Shipping_Contact_First_Name__c = 'Fn';
        ctredt.objOrderOverviewQry.Shipping_Contact_Last_Name__c = 'Ln';
        ctredt.objOrderOverviewQry.Shipping_Contact_Phone__c = '1234567890';
        ctredt.objOrderOverviewQry.Shipping_Contact_Email__c = 'fn@ln.com';
        ctredt.objOrderOverviewQry.ShippingStreet = 'beverly st1 n dearborn';
        ctredt.objOrderOverviewQry.ShippingCity = 'beverly st1 n dearborn';
        ctredt.objOrderOverviewQry.ShippingState = 'IL';
        ctredt.objOrderOverviewQry.ShippingPostalCode = '60179';
        ctredt.objOrderOverviewQry.BillingStreet = 'beverly st1 n dearborn';
        ctredt.objOrderOverviewQry.BillingCity = 'beverly st1 n dearborn';
        ctredt.objOrderOverviewQry.BillingState = 'IL';
        ctredt.objOrderOverviewQry.BillingPostalCode = '60179';
        ctredt.objOrderOverviewQry.DOS_Order_Number__c = '23';
        ctredt.objOrderOverviewQry.RMA_Order_Number__c = '34';
        ctredt.objOrderOverviewQry.Origin_Order_Date__c = system.today().addDays(-1);
        ctredt.objOrderOverviewQry.Delivery_Charge__c = 1;
        ctredt.objOrderOverviewQry.Premium_Delivery_Charge__c = 1;
        ctredt.objOrderOverviewQry.Haulaway_Charge__c = 1;
        ctredt.checkAddress();
        ctredt.getAddressList();
        
        ctredt.selectedAddr = 'GEO CODE: 00 | COUNTY CODE: 031 | COUNTY NAME: COOK' ;
        ctredt.actionSaveAdjustment();
        
        ctredt.selectedSaveAdjustment = 'Debit Memo';
        ctredt.actionSaveAdjustment();
        
        ctredt.actionDelete();
        pageRef.getParameters().put('sid', '1');
        ctredt.actionDelete();
        
    }

    public Static String insertOrder(String selectedAdjustment){
        AdjustmentFactory.insertBasics();
        
        List<Account> lstSCOAccount = new List<Account>();
        lstSCOAccount = [SELECT Id, Name, Price_List_Type__c, SCO_Account_Id__c, NewTerritory__c 
                         FROM Account 
                         LIMIT 1
                        ];
        
        String accountId = '';
        String account_new_territory = '';
        String territory_id = '';
        String district_id = '';
        
        if(lstSCOAccount.size()>0){
            accountId = lstSCOAccount[0].Id;
            account_new_territory = lstSCOAccount[0].NewTerritory__c;
            
            
            territory_id = '';
            district_id = '';
            
            List<Territory__c> lstTerritory = new List<Territory__c>();
            lstTerritory = [SELECT Id, Name, Territory_ID__c, District_Territory_ID__c 
                            FROM Territory__c 
                            WHERE Id =: account_new_territory 
                            ORDER BY Id DESC
                            LIMIT 1
                           ];
            if(lstTerritory.size()>0){
                territory_id = lstTerritory[0].Territory_ID__c;
                district_id = lstTerritory[0].District_Territory_ID__c;
            }
            
        }
        
        
        Order objOrderInsert = new Order();
        objOrderInsert.AccountId = accountId;
        //     objOrderInsert.Status = 'Submitted';
        objOrderInsert.Status = 'Adjustment Created';
        objOrderInsert.Order_Reference_Number__c = 'orn_st';
        objOrderInsert.Type = selectedAdjustment;
        objOrderInsert.Pricebook2Id='01s300000006uBlAAI';
        objOrderInsert.Order_Source__c='Salesforce';
        //     objOrderInsert.Parent_Order__c=orderId;
        objOrderInsert.District_Id__c=district_id;
        objOrderInsert.Territory_Id__c=territory_id;
        objOrderInsert.EffectiveDate = system.today();        
        objOrderInsert.Reason_Code__c = 'S12';
        objOrderInsert.Purchase_Number__c='12';
        objOrderInsert.DOS_Order_Number__c='23';
        objOrderInsert.RMA_Order_Number__c='34';
        objOrderInsert.Origin_Order_Date__c=system.today().addDays(-1);
        objOrderInsert.isCommonCarrier__c=false;
        objOrderInsert.Shipping_Contact_First_Name__c='Fn';
        objOrderInsert.Shipping_Contact_Last_Name__c='Ln';
        objOrderInsert.Shipping_Contact_Phone__c='1234567890';
        objOrderInsert.Shipping_Contact_Email__c='fn@ln.com';
        objOrderInsert.ShippingStreet='beverly st1 n dearborn';
        objOrderInsert.ShippingCity='hoffman estates';
        objOrderInsert.ShippingState='IL';
        objOrderInsert.ShippingPostalCode='60179';
        objOrderInsert.BillingStreet='beverly st1 n dearborn';
        objOrderInsert.BillingCity='hoffman estates';
        objOrderInsert.BillingState='IL';
        objOrderInsert.BillingPostalCode='60179';
        objOrderInsert.Delivery_Charge__c = 1;
        objOrderInsert.Premium_Delivery_Charge__c = 1;
        objOrderInsert.Haulaway_Charge__c = 1;
        objOrderInsert.Geo_Code__c = '00';
        objOrderInsert.County_Code__c = '031';
        objOrderInsert.County_Name__c = 'COOK';
        
        insert objOrderInsert;
        
        String saveOrderId = '';
        saveOrderId = objOrderInsert.Id;
        
        
        List<Product2> lstProduct = new List<Product2>();
        
        lstProduct = [SELECT Id, Name, ProductCode  
                      FROM Product2 
                      WHERE IsActive=true AND SBQQ__Component__c =false AND CanUseQuantitySchedule=false AND ProductCode!=null 
                     ];
        
        Map<String, String> mapPriceBookEntry = new Map<String, String>();
        List<PricebookEntry> lstPricebookEntry = new List<PricebookEntry>();
        lstPricebookEntry = [SELECT Id, Name, Product2Id  
                             FROM PricebookEntry
                             WHERE  Pricebook2Id='01s300000006uBlAAI'
                            ];
        
        for(PricebookEntry pb:lstPricebookEntry){
            mapPriceBookEntry.put(pb.Product2Id, pb.Id);
        }
        
        system.debug('mapPriceBookEntry--> ' + mapPriceBookEntry );        
        
        
        OrderItem objInsPartsOrderItem = new OrderItem();
        
        objInsPartsOrderItem.OrderId = saveOrderId;
        objInsPartsOrderItem.Number__c = '10';
        objInsPartsOrderItem.Product2Id = lstProduct[0].Id;
        objInsPartsOrderItem.Quantity = 1;
        objInsPartsOrderItem.PriceBookEntryId = mapPriceBookEntry.get(lstProduct[0].Id);
        objInsPartsOrderItem.Configuration__c = '';
        objInsPartsOrderItem.Configuration_Description__c = '';
        objInsPartsOrderItem.Feature__c = '';
        objInsPartsOrderItem.isProductParent__c = true;
        objInsPartsOrderItem.ProductParentUnique__c = lstProduct[0].Id;
        objInsPartsOrderItem.Parent_Part_Number__c = '';
        objInsPartsOrderItem.List_Unit_Price__c = 691.67;
        objInsPartsOrderItem.Net_Unit_Price__c = 649.99;
        objInsPartsOrderItem.UnitPrice = 649.99;
        
        objInsPartsOrderItem.Reason_Category_Code__c = '30';
        
        objInsPartsOrderItem.Reason_Code__c = '02';
        
        objInsPartsOrderItem.Product_Type__c = 'OrderItem';
        
        insert objInsPartsOrderItem;
        
        return saveOrderId;
        
    }
    
    static testMethod void creation_rx(){
        
        AdjustmentFactory.insertBasics();
        
        StandaloneCreationController ctredt = new StandaloneCreationController();
        
        PageReference pageRef = Page.StandaloneCreation; 
        pageRef.getParameters().put('prcd', 'uncrate_k');
        pageRef.getParameters().put('key', 'ServicesSelect_One');
        Test.setCurrentPage(pageRef);
        
        ctredt.getAdjustmentSelection();
        ctredt.getAdjPart();
        ctredt.getPAWarrantyPart();
        ctredt.getInstallPart();
        
        ctredt.actionLoadProducts();
        ctredt.selectedAdjustment = 'Return';
        ctredt.selectedSCOAccount = '1100000007';
        ctredt.actionLoadProducts();
        ctredt.getHeaderReasonCode();
        
        
        ctredt.actionLoadAccessories();
        ctredt.selectedproductcode = '02608262000';
        ctredt.selectedzipcode = '60179';
        ctredt.actionLoadAccessories();
        
        
        ctredt.selInstallation = null;
        ctredt.selInstallPrice = null;
        ctredt.actionSelected();
        
        ctredt.getInstallationService();
        ctredt.selInstallation = null;
        ctredt.selInstallPrice = null;
        ctredt.actionInstallation();
        
        ctredt.actionAddToList();
        
        ctredt.actionDelete();
        pageRef.getParameters().put('sid', '1');
        ctredt.actionDelete();
        
        ctredt.checkAddress();
        ctredt.objOrderOverviewQry.Origin_Order_Date__c = system.today();
        ctredt.objOrderOverviewQry.Delivery_Charge__c = -1;
        ctredt.objOrderOverviewQry.Premium_Delivery_Charge__c = -1;
        ctredt.objOrderOverviewQry.Haulaway_Charge__c = -1;
        ctredt.checkAddress();

        ctredt.objOrderOverviewQry.Reason_Code__c = 'S12';
        ctredt.objOrderOverviewQry.Purchase_Number__c = '12';
        ctredt.objOrderOverviewQry.Shipping_Contact_First_Name__c = 'Fn';
        ctredt.objOrderOverviewQry.Shipping_Contact_Last_Name__c = 'Ln';
        ctredt.objOrderOverviewQry.Shipping_Contact_Phone__c = '1234567890';
        ctredt.objOrderOverviewQry.Shipping_Contact_Email__c = 'fn@ln.com';
        ctredt.objOrderOverviewQry.ShippingStreet = 'beverly st1 n dearborn';
        ctredt.objOrderOverviewQry.ShippingCity = 'beverly st1 n dearborn';
        ctredt.objOrderOverviewQry.ShippingState = 'IL';
        ctredt.objOrderOverviewQry.ShippingPostalCode = '60179';
        ctredt.objOrderOverviewQry.BillingStreet = 'beverly st1 n dearborn';
        ctredt.objOrderOverviewQry.BillingCity = 'beverly st1 n dearborn';
        ctredt.objOrderOverviewQry.BillingState = 'IL';
        ctredt.objOrderOverviewQry.BillingPostalCode = '60179';
        ctredt.objOrderOverviewQry.DOS_Order_Number__c = '23';
        ctredt.objOrderOverviewQry.RMA_Order_Number__c = '34';
        ctredt.objOrderOverviewQry.Origin_Order_Date__c = system.today().addDays(-1);
        ctredt.objOrderOverviewQry.Delivery_Charge__c = 1;
        ctredt.objOrderOverviewQry.Premium_Delivery_Charge__c = 1;
        ctredt.objOrderOverviewQry.Haulaway_Charge__c = 1;
        ctredt.checkAddress();
        ctredt.getAddressList();
        
        ctredt.selectedAddr = 'GEO CODE: 00 | COUNTY CODE: 031 | COUNTY NAME: COOK' ;
        ctredt.actionSaveAdjustment();
        
        ctredt.selectedSaveAdjustment = 'Exchange';
        ctredt.actionSaveAdjustment();
                
        ctredt.actionDelete();
        pageRef.getParameters().put('sid', '1');
        ctredt.actionDelete();
    }   
    
    static testMethod void creation_cd(){
        
        AdjustmentFactory.insertBasics();
        
        StandaloneCreationController ctredt = new StandaloneCreationController();
        
        PageReference pageRef = Page.StandaloneCreation; 
        pageRef.getParameters().put('prcd', 'uncrate_k');
        pageRef.getParameters().put('key', 'ServicesSelect_One');
        Test.setCurrentPage(pageRef);
        
        ctredt.getAdjustmentSelection();
        ctredt.getAdjPart();
        ctredt.getPAWarrantyPart();
        ctredt.getInstallPart();
        
        ctredt.actionLoadProducts();
        ctredt.selectedAdjustment = 'Credit Memo';
        ctredt.selectedSCOAccount = '1100000007';
        ctredt.actionLoadProducts();
        ctredt.getHeaderReasonCode();
        
        
        ctredt.actionLoadAccessories();
        ctredt.selectedproductcode = '02608262000';
        ctredt.selectedzipcode = '60179';
        ctredt.actionLoadAccessories();
        
        
        ctredt.selInstallation = null;
        ctredt.selInstallPrice = null;
        ctredt.actionSelected();
        
        ctredt.getInstallationService();
        ctredt.selInstallation = null;
        ctredt.selInstallPrice = null;
        ctredt.actionInstallation();
        
        ctredt.actionAddToList();
        
        ctredt.selectedmemoproductcode = '02608262000';
        pageRef.getParameters().put('type', 'prod');
        ctredt.FindProducts();
        ctredt.actionAddtoAdjustment();
        
        ctredt.selectedpart = '40010500000';
        pageRef.getParameters().put('type', 'part');
        ctredt.FindProducts();
        ctredt.actionAddtoAdjustment();
        
        ctredt.selectedprotection = '07062376000';
        pageRef.getParameters().put('type', 'prot');
        ctredt.FindProducts();
        ctredt.actionAddtoAdjustment();
        
        ctredt.selectedinstall = '01026200000';
        pageRef.getParameters().put('type', 'inst');
        ctredt.FindProducts();
        ctredt.actionAddtoAdjustment();
        
        
        
        ctredt.actionDelete();
        pageRef.getParameters().put('sid', '1');
        ctredt.actionDelete();

 //       ctredt.actionAddToList();

        
        ctredt.checkAddress();
        ctredt.objOrderOverviewQry.Origin_Order_Date__c = system.today();
        ctredt.objOrderOverviewQry.Delivery_Charge__c = -1;
        ctredt.objOrderOverviewQry.Premium_Delivery_Charge__c = -1;
        ctredt.objOrderOverviewQry.Haulaway_Charge__c = -1;
        ctredt.checkAddress();

        ctredt.objOrderOverviewQry.Reason_Code__c = 'S12';
        ctredt.objOrderOverviewQry.Purchase_Number__c = '12';
        ctredt.objOrderOverviewQry.Shipping_Contact_First_Name__c = 'Fn';
        ctredt.objOrderOverviewQry.Shipping_Contact_Last_Name__c = 'Ln';
        ctredt.objOrderOverviewQry.Shipping_Contact_Phone__c = '1234567890';
        ctredt.objOrderOverviewQry.Shipping_Contact_Email__c = 'fn@ln.com';
        ctredt.objOrderOverviewQry.ShippingStreet = 'beverly st1 n dearborn';
        ctredt.objOrderOverviewQry.ShippingCity = 'beverly st1 n dearborn';
        ctredt.objOrderOverviewQry.ShippingState = 'IL';
        ctredt.objOrderOverviewQry.ShippingPostalCode = '60179';
        ctredt.objOrderOverviewQry.BillingStreet = 'beverly st1 n dearborn';
        ctredt.objOrderOverviewQry.BillingCity = 'beverly st1 n dearborn';
        ctredt.objOrderOverviewQry.BillingState = 'IL';
        ctredt.objOrderOverviewQry.BillingPostalCode = '60179';
        ctredt.objOrderOverviewQry.DOS_Order_Number__c = '23';
        ctredt.objOrderOverviewQry.RMA_Order_Number__c = '34';
        ctredt.objOrderOverviewQry.Origin_Order_Date__c = system.today().addDays(-1);
        ctredt.objOrderOverviewQry.Delivery_Charge__c = 1;
        ctredt.objOrderOverviewQry.Premium_Delivery_Charge__c = 1;
        ctredt.objOrderOverviewQry.Haulaway_Charge__c = 1;
        ctredt.checkAddress();
        ctredt.getAddressList();
        
        ctredt.selectedAddr = 'GEO CODE: 00 | COUNTY CODE: 031 | COUNTY NAME: COOK' ;
        ctredt.actionSaveAdjustment();
        
        ctredt.selectedSaveAdjustment = 'Debit Memo';
        ctredt.actionSaveAdjustment();
                
        
    }   
    
    
}