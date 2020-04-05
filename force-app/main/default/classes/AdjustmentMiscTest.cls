@isTest
public class AdjustmentMiscTest {

    static testMethod void adj504Action(){
        String orderid = '';
        String selectedAdjustment = 'Return';
        orderid = insertOrder(selectedAdjustment);
        
        system.debug('orderid--> ' + orderid );
        
        List<Id> lstOrderId = new List<Id>();
        lstOrderId.add(orderid);

        
  //      Call504Action ctredt = new Call504Action();
        Call504Action.call504action_method(lstOrderId);
    }


    static testMethod void adjsub_rx(){
        String orderid = '';
        String selectedAdjustment = 'Return';
        orderid = insertOrder(selectedAdjustment);
        
        system.debug('orderid--> ' + orderid );
        
        PageReference pageRef = Page.OrderAdjustmentSubmission; 
        pageRef.getParameters().put('id', orderid);
        Test.setCurrentPage(pageRef);
        
        OrderAdjustmentSubmissionController ctredt = new OrderAdjustmentSubmissionController();

        ctredt.isStandalone = false;
        ctredt.actionGoToEdit();
        ctredt.isStandalone = true;
        ctredt.actionGoToEdit();
        ctredt.actionGoToOrderHeader();
        ctredt.submitApprovalRequest();
        ctredt.calculateDeliveryDates();
        ctredt.getDeliveryDate();
        
        ctredt.getPaymentMethod();
        ctredt.actionCreditCardPayment();
        ctredt.actionPayment();
        ctredt.payType = 'Credit Card';
        ctredt.actionPayment();
        ctredt.selectedCreditCard = 'b3ab14d06e920137e2be001a4a00005b';
        ctredt.actionPayment();
        ctredt.getCreditCardPaymentMethod();
                
        ctredt.actionSendOrderAPI();
        ctredt.payType = 'Credit Card';
        ctredt.selectedAuthPurchaser = 'selectedAuthPurchaser';
        ctredt.selectedAdjustment = 'Return';
        ctredt.delDate = '2020-12-05';
        ctredt.actionSendOrderAPI();
        
        
    }
        
    static testMethod void adjsub_cd(){
        String orderid = '';
        String selectedAdjustment = 'Credit Memo';
        orderid = insertOrder(selectedAdjustment);
        
        system.debug('orderid--> ' + orderid );
        
        PageReference pageRef = Page.OrderAdjustmentSubmission; 
        pageRef.getParameters().put('id', orderid);
        Test.setCurrentPage(pageRef);
        
        OrderAdjustmentSubmissionController ctredt = new OrderAdjustmentSubmissionController();

        ctredt.isStandalone = false;
        ctredt.actionGoToEdit();
        ctredt.isStandalone = true;
        ctredt.actionGoToEdit();
        ctredt.actionGoToOrderHeader();
    //    ctredt.submitApprovalRequest();
        ctredt.calculateDeliveryDates();
        ctredt.getDeliveryDate();
        
        ctredt.getPaymentMethod();
        ctredt.actionCreditCardPayment();
        ctredt.actionPayment();
        ctredt.payType = 'Credit Card';
        ctredt.actionPayment();
        ctredt.selectedCreditCard = 'b3ab14d06e920137e2be001a4a00005b';
        ctredt.actionPayment();
        ctredt.getCreditCardPaymentMethod();
                
        ctredt.actionSendOrderAPI();
        ctredt.payType = 'Credit Card';
        ctredt.selectedAuthPurchaser = 'selectedAuthPurchaser';
        ctredt.selectedAdjustment = 'Credit Memo';
        ctredt.delDate = '2020-12-05';
        ctredt.actionSendOrderAPI();
        
        
    }
        
    
    static testMethod void ord_btn(){
        String orderid = '';
        String selectedAdjustment = '';
        orderid = insertOrder(selectedAdjustment);
        
        system.debug('orderid--> ' + orderid );
        
        PageReference pageRef = Page.OrderButtonGroup; 
        pageRef.getParameters().put('id', orderid);
        Test.setCurrentPage(pageRef);
        
        OrderButtonGroupController ctredt = new OrderButtonGroupController();
        
        ctredt.getOrderTypeDrop();
        ctredt.selectedordertype = null;
        ctredt.gotoMSASign22();
        ctredt.selectedordertype = '';
        ctredt.gotoMSASign22();
        ctredt.gotoAdjustmentPage22();
        ctredt.gotoAdjustmentPage33();
        ctredt.gotoAdjustmentPage44();
    }
    
    static testMethod void ord_btn2(){
        String orderid = '';
        String selectedAdjustment = 'Return';
        orderid = insertOrder(selectedAdjustment);
        
        system.debug('orderid--> ' + orderid );
        
        
        PageReference pageRef = Page.OrderButtonGroup; 
        pageRef.getParameters().put('id', orderid);
        Test.setCurrentPage(pageRef);
        
        OrderButtonGroupController ctredt = new OrderButtonGroupController();
        ctredt.gotoAdjustmentReschedule();
        ctredt.gotoAdjustmentCancel();
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
    
    static testMethod void sd_adj(){
        
        string resdoc = '';
        
        resdoc = '{ "deliveryCalendarRequest": { "zip": "30302", "timeWindow": "ALL", "state": "GA", "startDate": "2019-11-15", "servicetime": "10", "sellingStoreID": "09346", "nofItems": 1, "cubes": 0, "clientCode": "COMM", "city": "Atlanta", "address2": "", "address1": "2753 BLAKELY LN" } }';
        system.debug('resdoc:' +resdoc);
        
        SerializeAdjustmentDeliveryAPI obj1 = SerializeAdjustmentDeliveryAPI.parse(resdoc);
        system.debug('obj1:' +obj1);
        
        resdoc = '{ "shipping_address": { "zip": "60179", "state": "IL", "last_name": "Contact", "geo_code": "00", "first_name": "Luv", "email": "luvmahajan.0512@gmail.com", "day_phone": "(872) 163-2311", "county_name": "COOK", "county_code": "031", "city": "hoffman estates", "address_line_2": "", "address_line_1": "beverly st" }, "reason_code": "A01", "purchase_order_number": "pn23", "payment_method": { "uid": "8664447078aa0137e2f6001a4a00005b", "type": "CC", "authorized_purchaser": "John Doe" }, "order_reference": "SF_ADJUSTMENT_CMR_20191127112852", "order_id": "3228", "items": [ { "type": "OrderItem", "selling_price": 804.14, "quantity": 1, "part_number": "02212776000", "list_price": 804.14 } ], "category": "cmr", "account_number": "1100000007" }';
        system.debug('resdoc:' +resdoc);
        
        SerializeCDOrderAPI obj2 = SerializeCDOrderAPI.parse(resdoc);
        system.debug('obj2:' +obj2);
        
        resdoc = '{ "shipping_address": { "zip": "60179", "state": "IL", "last_name": "Contact", "geo_code": "00", "first_name": "Luv", "email": "luvmahajan.0512@gmail.com", "day_phone": "(872) 163-2311", "county_name": "COOK", "county_code": "031", "city": "hoffman estates", "address_line_2": "", "address_line_1": "beverly st" }, "reason_code": "S01", "purchase_order_number": "pn23", "premium_delivery_charge": 0, "pickup_date": "2019-12-05", "payment_method": { "uid": "8664447078aa0137e2f6001a4a00005b", "type": "CC", "authorized_purchaser": "John Doe" }, "original_rma_number": null, "original_order_date": null, "order_reservation_number": null, "order_reference": "SF_ADJUSTMENT_RET_20191127110626", "order_id": "3228", "items": [ { "type": "OrderItem", "selling_price": 804.14, "return_reason_code": "02", "return_category_code": "30", "required_parts": [ { "return_reason_code": "02", "return_category_code": "30", "price": 13.6, "part_number": "02213000000", "original_price": 10 } ], "quantity": 1, "part_number": "02212776000", "original_price": 804.14, "list_price": 804.14, "delivery_option": { "part_number": null, "option_code": "brownbox_10", "description": "Leave-in-Box Delivery", "addon_price": 855 } } ], "haulaway_charge": 0, "delivery_instructions": "nj", "delivery_charge": 0, "common_carrier_location": true, "category": "Return", "account_number": "1100000007" }';
        system.debug('resdoc:' +resdoc);
        
        SerializeRXOrderAPI obj3 = SerializeRXOrderAPI.parse(resdoc);
        system.debug('obj3:' +obj3);
        
        resdoc = '{ "deliveryCalendarResponse": { "retCode": 0, "retReason": "SUCCESS", "zip": 60179, "timeSlotList": [ { "windowCode": "AM", "dates": [ "2019-09-06", "2019-09-13", "2019-09-20", "2019-09-27", "2019-10-04" ] }, { "windowCode": "TBS", "dates": [ "2019-09-03", "2019-09-04", "2019-09-06", "2019-09-07", "2019-09-09", "2019-09-10", "2019-09-11", "2019-09-13", "2019-09-14", "2019-09-16", "2019-09-17", "2019-09-18", "2019-09-20", "2019-09-21", "2019-09-23", "2019-09-24", "2019-09-25", "2019-09-27", "2019-09-28", "2019-09-30", "2019-10-01" ] }, { "windowCode": "E", "dates": [ "2019-09-03", "2019-09-04", "2019-09-05", "2019-09-06", "2019-09-07", "2019-09-09", "2019-09-10", "2019-09-11", "2019-09-12", "2019-09-13", "2019-09-14", "2019-09-16", "2019-09-17", "2019-09-18", "2019-09-19", "2019-09-20", "2019-09-21", "2019-09-23", "2019-09-24", "2019-09-25", "2019-09-26", "2019-09-27", "2019-09-28", "2019-09-30", "2019-10-01" ] }, { "windowCode": "U", "dates": [ "2019-09-03", "2019-09-04", "2019-09-05", "2019-09-06", "2019-09-07", "2019-09-09", "2019-09-10", "2019-09-11", "2019-09-12", "2019-09-13", "2019-09-14", "2019-09-16", "2019-09-17", "2019-09-18", "2019-09-19", "2019-09-20", "2019-09-21", "2019-09-23", "2019-09-24", "2019-09-25", "2019-09-26", "2019-09-27", "2019-09-28", "2019-09-30", "2019-10-01" ] }, { "windowCode": "H", "dates": [ "2019-09-03", "2019-09-04", "2019-09-05", "2019-09-06", "2019-09-07", "2019-09-09", "2019-09-10", "2019-09-11", "2019-09-12", "2019-09-13", "2019-09-14", "2019-09-16", "2019-09-17", "2019-09-18", "2019-09-19", "2019-09-20", "2019-09-21", "2019-09-23", "2019-09-24", "2019-09-25", "2019-09-26", "2019-09-27", "2019-09-28", "2019-09-30", "2019-10-01" ] } ] } }';
        system.debug('resdoc:' +resdoc);
        
        DeserializeAdjustmentDeliveryAPI obj4 = DeserializeAdjustmentDeliveryAPI.parse(resdoc);
        system.debug('obj4:' +obj4);
        
        resdoc = '{ "order_reference_number": "SF_OrderReferenceNumber", "order_id": "1234" }';
        system.debug('resdoc:' +resdoc);
        
        DeserializeAdjustmentOrderAPI obj5 = DeserializeAdjustmentOrderAPI.parse(resdoc);
        system.debug('obj5:' +obj5);
        
        resdoc = '{ "display_name": "SF_1234", "uid": "1234", "expiry": "1123", "default1": true }';
        system.debug('resdoc:' +resdoc);
        
        DeserializePaymentOptionsAPI obj6 = DeserializePaymentOptionsAPI.parse(resdoc);
        system.debug('obj6:' +obj6);
        
        resdoc = '{ "order_reference_number": "SF_1234", "account_number": "1100000007", "order_no": "1234", "status": "Completed" }';
        system.debug('resdoc:' +resdoc);
        
        DeserializeOrderDetailAPI obj7 = DeserializeOrderDetailAPI.parse(resdoc);
        system.debug('obj7:' +obj7);
        
    }    
    
    
    
    
}