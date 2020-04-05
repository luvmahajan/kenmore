@isTest
public class RescheduleCancelTest {

    static testMethod void ord_btn(){
        String orderid = '';
        String selectedAdjustment = 'Return';
        orderid = insertOrder(selectedAdjustment);
        
        system.debug('orderid--> ' + orderid );
        
        PageReference pageRef = Page.RescheduleCancel; 
        pageRef.getParameters().put('id', orderid);
        pageRef.getParameters().put('action', 'reschedule');
        Test.setCurrentPage(pageRef);
        
        RescheduleCancelController ctredt = new RescheduleCancelController();
        ctredt.calculateDeliveryDates();
        ctredt.gotoAdjustment();
        ctredt.getRescheduleCancelReason();
        ctredt.getPickUpDateDropDown();
        ctredt.actionReschedule();
        ctredt.selRschReason = '1';
        ctredt.selPickupDate = string.valueOf(system.today());
        ctredt.actionReschedule();
        ctredt.actionCancel();
        ctredt.selCnlReason = 'A';
        ctredt.actionCancel();
        ctredt.actionNoCancel();
        ctredt.actionConfirmCancel();
        
        Order objOrder = new Order();
        objOrder = [SELECT Id, Name, type 
                         FROM Order
                    WHERE Id =:orderid
                         LIMIT 1
                        ];
        objOrder.type = 'Credit Memo';
        update objOrder;
        RescheduleCancelController ctredt2 = new RescheduleCancelController();
        ctredt2.actionConfirmCancel();
        
        
        /*
        ctredt.getOrderTypeDrop();
        ctredt.selectedordertype = null;
        ctredt.gotoMSASign22();
        ctredt.selectedordertype = '';
        ctredt.gotoMSASign22();
        ctredt.gotoAdjustmentPage22();
        ctredt.gotoAdjustmentPage33();
        ctredt.gotoAdjustmentPage44();
		*/
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
             objOrderInsert.Status = 'Completed';
        /*
        if(isNew){
            objOrderInsert.Status = 'Adjustment Created';
        }else{
            objOrderInsert.Status = 'Completed';
        }*/
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
        objOrderInsert.B2B_Order_Id__c = 'R800000830';
        objOrderInsert.Status = 'Submitted';
        objOrderInsert.Delivery_Date__c = system.today();
        
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
        objInsPartsOrderItem.SBQQ__Status__c = 'Completed';
        
        insert objInsPartsOrderItem;
        
        return saveOrderId;
        
    }
    
    
    
    
}