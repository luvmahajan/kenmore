public without sharing class OrderItemTriggerHandler {
    public static void afterInsert(list<OrderItem> orderItemList, map<Id, OrderItem> orderItemNewMap){
    	// Run the After Insert logic for the Contract Line Item(s).
    	updateContractLineItems('After Insert', orderItemList, orderItemNewMap, orderItemNewMap);
    }
    
    public static void afterUpdate(list<OrderItem> orderItemList, map<Id, OrderItem> orderItemNewMap, map<Id, OrderItem> orderItemOldMap){
    	// Run the After Update logic for the Contract Line Item(s).
    	updateContractLineItems('After Update', orderItemList, orderItemNewMap, orderItemOldMap);
    }
    
    public static void beforeDelete(list<OrderItem> orderItemList, map<Id, OrderItem> orderItemOldMap){
    	// Run the Before Delete logic for the Contract Line Item(s).
    	updateContractLineItems('Before Delete', orderItemList, orderItemOldMap, orderItemOldMap);
    }
    
    public static void updateContractLineItems(String triggerEventType, list<OrderItem> orderItemList, map<Id, OrderItem> orderItemNewMap, map<Id, OrderItem> orderItemOldMap){
    	
        Set<String> setParentOrder = new Set<String>();
        
        for(Id oin:orderItemNewMap.keyset()){
            setParentOrder.add(orderItemNewMap.get(oin).OrderId);
        }
        
        
        Map<String, String> mapOrderSequence = new Map<String, String>();
    	list<OrderItem> lstOLI = new list<OrderItem>();
   //     lstOLI =  [select Id, OrderId, Product2Id, Number__c from OrderItem where Id in :orderItemNewMap.keySet()];
   //     lstOLI =  [select Id, OrderId, Product2Id, Number__c from OrderItem  ORDER BY Id DESC LIMIT 50000 ];
        lstOLI =  [select Id, OrderId, Product2Id, Number__c from OrderItem WHERE OrderId IN:setParentOrder ];
        for(OrderItem lo:lstOLI){
            mapOrderSequence.put(lo.OrderId + lo.Number__c, lo.Product2Id);
        }
        system.debug('lstOLI--> ' + lstOLI );
        system.debug('lstOLI.size()--> ' + lstOLI.size() );
        system.debug('mapOrderSequence--> ' + mapOrderSequence );
        system.debug('mapOrderSequence.size()--> ' + mapOrderSequence.size() );
        system.debug('orderItemNewMap.keySet()--> ' + orderItemNewMap.keySet() );
        system.debug('orderItemNewMap.size--> ' + orderItemNewMap.size() );
        map<String, Decimal> oiReleasedQuantityMap = new map<String, Decimal>();
    	map<String, Decimal> oiReleasedValueMap = new map<String, Decimal>();
    	map<String, Decimal> oiShippedQuantityMap = new map<String, Decimal>();
    	map<String, Decimal> oiCancelledQuantityMap = new map<String, Decimal>();
    	map<String, Decimal> oiCancelledPriceMap = new map<String, Decimal>();
    	map<String, OrderItem> prodIdOrdItemMap = new map<String, OrderItem>();
    	set<Id> contractIds = new set<Id>();
    	list<Contract_Line_Item__c> updateContLineItemsList = new list<Contract_Line_Item__c>();
    	
    //	for(OrderItem oi: [select Order.ContractId, Order.Type, Product2Id, Quantity, UnitPrice, Billable_Quantity__c, Cancelled_Quantity__c, Line_Item_Unique_Value__c, OrderId, Number__c, Parent_Part_Number__c, Tax_Rate__c, Item_Tax__c, SBQQ__TaxAmount__c, Order.Parent_Order__r.Type from OrderItem where Id in :orderItemNewMap.keySet()]){
    	for(OrderItem oi: [select Order.ContractId, Order.Type, Product2Id, Quantity, UnitPrice, Billable_Quantity__c, Cancelled_Quantity__c, OrderId, Number__c, Parent_Part_Number__c, Tax_Rate__c, Item_Tax__c, SBQQ__TaxAmount__c, Order.Parent_Order__r.Type from OrderItem where Id in :orderItemNewMap.keySet()]){
    		String parent =  (oi.Parent_Part_Number__c==null || oi.Parent_Part_Number__c=='' || oi.Parent_Part_Number__c=='0') ? mapOrderSequence.get(oi.OrderId + oi.Number__c):mapOrderSequence.get(oi.OrderId + oi.Parent_Part_Number__c);
            String UniqueValue = oi.Order.ContractId + string.valueOf(oi.Product2Id) + parent ;
            
            system.debug('UniqueValue--> ' + UniqueValue );
            
            Decimal qty = 0;
    		Decimal unitPrce = 0;
    		Decimal billableQty = 0;
    		Decimal totalPrice = 0;
    		Decimal cancelledQty = 0;
    		Decimal cancelledPrice = 0;
    		Decimal oldQty = 0;
    		Decimal oldUnitPrce = 0;
    		Decimal oldBillableQty = 0;
    		Decimal oldTotalPrice = 0;
    		Decimal oldcancelledQty = 0;
    		Decimal oldcancelledPrice = 0;
    		Decimal taxRate = 0;
    		Decimal tax = 0;
            
    		// Make sure there are 0s and not null values.
    		if(oi.Quantity == null){
    			oi.Quantity = 0;
    		}
    		
    		if(oi.UnitPrice == null){
    			oi.UnitPrice = 0;
    		}
    		
    		if(oi.Billable_Quantity__c == null){
    			oi.Billable_Quantity__c = 0;
    		}
    		
    		if(oi.Cancelled_Quantity__c == null){
    			oi.Cancelled_Quantity__c = 0;
    		}
    		
    		if(oi.Tax_Rate__c == null){
    			oi.Tax_Rate__c = 0;
    		}
    		
    		if(oi.Tax_Rate__c == null){
    			oi.Tax_Rate__c = 0;
    		}
    		
    		if(oi.Item_Tax__c == null){
    			oi.Item_Tax__c = 0;
    		}
    		
    		if(triggerEventType == 'After Insert'){
    			qty = oi.Quantity;
    			unitPrce = oi.UnitPrice;
    		//	unitPrce = oi.UnitPrice + (oi.UnitPrice * oi.Tax_Rate__c) ;
    		//	unitPrce = oi.UnitPrice + oi.Item_Tax__c ;
    			billableQty = oi.Billable_Quantity__c;
    			cancelledQty = oi.Cancelled_Quantity__c;
                totalPrice = qty * unitPrce;
                cancelledPrice = cancelledQty * unitPrce;
    		}
    		
    		if(triggerEventType == 'After Update'){
    			OrderItem oldOrderItem = orderItemOldMap.get(oi.Id);
    			
    			if(oldOrderItem.Quantity == null){
    				oldQty = 0;
    			} else{
    				oldQty = oldOrderItem.Quantity;
    			}
    			
    			if(oldOrderItem.UnitPrice == null){
	    			oldUnitPrce = 0;
	    		} else{
    				oldUnitPrce = oldOrderItem.UnitPrice;
    			}
	    		
    	//		if(oldOrderItem.Tax_Rate__c == null || oldOrderItem.UnitPrice==null ){
    	//			oldUnitPrce += 0;
    	//		} else{
    	//			oldUnitPrce += oldOrderItem.UnitPrice * oldOrderItem.Tax_Rate__c;
    	//		}
                
    	//		if(oldOrderItem.Item_Tax__c == null ){
    	//			oldUnitPrce += 0;
    	//		} else{
    	//			oldUnitPrce += oldOrderItem.Item_Tax__c;
    	//		}
                
	    		if(oldOrderItem.Billable_Quantity__c == null){
	    			oldBillableQty = 0;
	    		} else{
    				oldBillableQty = oldOrderItem.Billable_Quantity__c;
    			}
	    		
	    		if(oldOrderItem.Cancelled_Quantity__c == null){
	    			oldcancelledQty = 0;
	    		} else{
    				oldcancelledQty = oldOrderItem.Cancelled_Quantity__c;
    			}
	    		
    			if(oldQty != oi.Quantity){
    				// The Quantity has been updated, so find out if it increased or decreased.
    				qty = oi.Quantity - oldQty;
    			}
    			
    			if(oldUnitPrce != oi.UnitPrice){
    	//		if(oldUnitPrce != oi.UnitPrice + oi.UnitPrice * oi.Tax_Rate__c){
    	//		if(oldUnitPrce != oi.UnitPrice + oi.Item_Tax__c){
    				// The UnitPrice has been updated, so find out if it increased or decreased.
    				unitPrce = oi.UnitPrice - oldUnitPrce;
    		//		unitPrce = oi.UnitPrice + (oi.UnitPrice * oi.Tax_Rate__c) - oldUnitPrce;
    		//		unitPrce = oi.UnitPrice + oi.Item_Tax__c - oldUnitPrce;
    			}
    			
    			if(oldBillableQty != oi.Billable_Quantity__c){
    				// The Billable_Quantity__c has been updated, so find out if it increased or decreased.
    				billableQty = oi.Billable_Quantity__c - oldBillableQty;
    			}
    			
    			if(oldcancelledQty != oi.Cancelled_Quantity__c){
    				// The Billable_Quantity__c has been updated, so find out if it increased or decreased.
    				cancelledQty = oi.Cancelled_Quantity__c - oldcancelledQty;
    			}
    			
    			oldTotalPrice = oldQty * oldUnitPrce;
                
           //     totalPrice = qty * unitPrce;
                totalPrice = qty * oldUnitPrce + unitPrce * oi.Quantity ;
          //      cancelledPrice = cancelledQty * unitPrce;
                cancelledPrice = cancelledQty * oldUnitPrce + unitPrce * oi.Cancelled_Quantity__c ;
                
    		}
    		
    		if(triggerEventType == 'Before Delete'){
    			qty = 0 - oi.Quantity;
    			unitPrce = 0 - oi.UnitPrice;
    		//	unitPrce = 0 - (oi.UnitPrice + (oi.UnitPrice * oi.Tax_Rate__c) );
    		//	unitPrce = 0 - (oi.UnitPrice + oi.Item_Tax__c );
    			billableQty = 0 - oi.Billable_Quantity__c;
    			cancelledQty = 0 - oi.Cancelled_Quantity__c;
                totalPrice = qty * unitPrce;
                cancelledPrice = cancelledQty * unitPrce;
    		}
    		
    		/*
    		// Group each OrderItem by its Product2Id and summarize the values.
    		if(oiReleasedQuantityMap.get(oi.Product2Id) != null){
    			// This is not first OrderItem related to this Contract, so we need to add or subtract it from the previous value.
    			if(oi.Order.Type == 'Order' || oi.Order.Type == 'Debit Memo' || oi.Order.Type == 'Change Request'){
    				// Calculate the Release Quantity.
    				Decimal tempRelQuantity = oiReleasedQuantityMap.get(oi.Product2Id);
    				
    				tempRelQuantity = tempRelQuantity + qty;
    				
    				oiReleasedQuantityMap.put(oi.Product2Id, tempRelQuantity);
    				
    				// Calculate the Release Value.
    				Decimal tempRelValue = oiReleasedValueMap.get(oi.Product2Id);
    				
    				tempRelValue = tempRelValue + totalPrice;
    				
    				oiReleasedValueMap.put(oi.Product2Id, tempRelValue);
    				
    				// Calculate the Shipped Quantity.
					Decimal tempShippedQuantity = oiShippedQuantityMap.get(oi.Product2Id);
    				
    				tempShippedQuantity = tempShippedQuantity + billableQty;
    				
    				oiShippedQuantityMap.put(oi.Product2Id, tempShippedQuantity);
    			} else if(oi.Order.Type == 'Return' || oi.Order.Type == 'Credit Memo' || oi.Order.Type == 'Cancel'){
    				// Calculate the Release Quantity.
    				Decimal tempNegRelQuantity = oiReleasedQuantityMap.get(oi.Product2Id);
    				
    				tempNegRelQuantity = tempNegRelQuantity - qty;
    				
    				oiReleasedQuantityMap.put(oi.Product2Id, tempNegRelQuantity);
    				
    				// Calculate the Release Value.
    				Decimal tempNegRelValue = oiReleasedValueMap.get(oi.Product2Id);
    				
    				tempNegRelValue = tempNegRelValue - totalPrice;
    				
    				oiReleasedValueMap.put(oi.Product2Id, tempNegRelValue);
    				
    				// Calculate the Shipped Quantity.
					Decimal tempNegShippedQuantity = oiShippedQuantityMap.get(oi.Product2Id);
    				
    				tempNegShippedQuantity = tempNegShippedQuantity - billableQty;
    				
    				oiShippedQuantityMap.put(oi.Product2Id, tempNegShippedQuantity);
    			}
    		} else{*/
            
            /*
    			// This is the first OrderItem related to this Contract.
    			if(oi.Order.Type == 'Order' || oi.Order.Type == 'Debit Memo' || oi.Order.Type == 'Change Request'){
    				// Calculate the Release Quantity.
    				oiReleasedQuantityMap.put(oi.Line_Item_Unique_Value__c, qty);
    				
    				// Calculate the Release Value.
    				oiReleasedValueMap.put(oi.Line_Item_Unique_Value__c, totalPrice);
    				
    				// Calculate the Shipped Quantity.
    				oiShippedQuantityMap.put(oi.Line_Item_Unique_Value__c, billableQty);
                    
    				// Calculate the Cancelled Quantity.
    				oiCancelledQuantityMap.put(oi.Line_Item_Unique_Value__c, cancelledQty);
                    
    				// Calculate the Cancelled Price.
    				oiCancelledPriceMap.put(oi.Line_Item_Unique_Value__c, cancelledPrice);
                    
    			} else if(oi.Order.Type == 'Return' || oi.Order.Type == 'Credit Memo' || oi.Order.Type == 'Cancel'){
    				// Calculate the Release Quantity.
    				qty = 0 - qty;
    				
    				oiReleasedQuantityMap.put(oi.Line_Item_Unique_Value__c, qty);
    				
    				// Calculate the Release Value.
    				totalPrice = 0 - totalPrice;
    				
    				oiReleasedValueMap.put(oi.Line_Item_Unique_Value__c, totalPrice);
    				
    				// Calculate the Shipped Quantity.
    				billableQty = 0 - billableQty;
                    
    				oiShippedQuantityMap.put(oi.Line_Item_Unique_Value__c, billableQty);
    				
    				// Calculate the Cancelled Quantity.
    				cancelledQty = 0 - cancelledQty;
                    
    				oiCancelledQuantityMap.put(oi.Line_Item_Unique_Value__c, cancelledQty);
    				
    				// Calculate the Cancelled Price.
    				cancelledPrice = 0 - cancelledPrice;
                    
    				oiCancelledPriceMap.put(oi.Line_Item_Unique_Value__c, cancelledPrice);
    			}
            */
           
    			// This is the first OrderItem related to this Contract.
    			if(oi.Order.Type == 'Order' || oi.Order.Type == 'Debit Memo' || oi.Order.Type == 'Change Request'){
    				// Calculate the Release Quantity.
    				oiReleasedQuantityMap.put(UniqueValue, qty);
    				
    				// Calculate the Release Value.
    				oiReleasedValueMap.put(UniqueValue, totalPrice);
    				
    				// Calculate the Shipped Quantity.
    				oiShippedQuantityMap.put(UniqueValue, billableQty);
                    
    				// Calculate the Cancelled Quantity.
    				oiCancelledQuantityMap.put(UniqueValue, cancelledQty);
                    
    				// Calculate the Cancelled Price.
    				oiCancelledPriceMap.put(UniqueValue, cancelledPrice);
                    
    			} else if(oi.Order.Type == 'Return' || oi.Order.Type == 'Credit Memo' || oi.Order.Type == 'Cancel'){
    				// Calculate the Release Quantity.
    			//	qty = 0 - qty;
                    if(oi.Order.Type == 'Credit Memo' && oi.Order.Parent_Order__r.Type == 'Return' ){
    				qty = 0 ;
                    }else{
    				qty = 0 - qty;
                    }
    				
    				oiReleasedQuantityMap.put(UniqueValue, qty);
    				
    				// Calculate the Release Value.
    			//	totalPrice = 0 - totalPrice;
                    if(oi.Order.Type == 'Credit Memo' && oi.Order.Parent_Order__r.Type == 'Return' ){
    				totalPrice = 0 ;
                    }else{
    				totalPrice = 0 - totalPrice;
                    }
    				
    				oiReleasedValueMap.put(UniqueValue, totalPrice);
    				
    				// Calculate the Shipped Quantity.
    				billableQty = 0 - billableQty;
                    
    				oiShippedQuantityMap.put(UniqueValue, billableQty);
    				
    				// Calculate the Cancelled Quantity.
    			//	cancelledQty = 0 - cancelledQty;
                    if(oi.Order.Type == 'Credit Memo' && oi.Order.Parent_Order__r.Type == 'Return' ){
    				cancelledQty = 0 ;
                    }else{
    				cancelledQty = 0 - cancelledQty;
                    }
                    
    				oiCancelledQuantityMap.put(UniqueValue, cancelledQty);
    				
    				// Calculate the Cancelled Price.
    				cancelledPrice = 0 - cancelledPrice;
                    if(oi.Order.Type == 'Credit Memo' && oi.Order.Parent_Order__r.Type == 'Return' ){
    				cancelledPrice = 0 ;
                    }else{
    				cancelledPrice = 0 - cancelledPrice;
                    }
                    
    				oiCancelledPriceMap.put(UniqueValue, cancelledPrice);
    			}
            
            
    	//	}
    		
    		contractIds.add(oi.Order.ContractId);
    	//	prodIdOrdItemMap.put(oi.Line_Item_Unique_Value__c, oi);
    		prodIdOrdItemMap.put(UniqueValue, oi);
    		
    		system.debug('oiReleasedQuantityMap value: ' + oiReleasedQuantityMap);
    		system.debug('oiShippedQuantityMap value: ' + oiShippedQuantityMap);
    		system.debug('oiReleasedValueMap value: ' + oiReleasedValueMap);
    		system.debug('oiCancelledQuantityMap value: ' + oiCancelledQuantityMap);
    		system.debug('oiCancelledPriceMap value: ' + oiCancelledPriceMap);
    	}
    	
    //	for(Contract_Line_Item__c cli: [select Contract__c, Product__c, Items_Processed__c, Amount_Processed__c, Shipped_Quantity__c, Line_Item_Unique_Value__c, ProductParentUnique__c from Contract_Line_Item__c where Contract__c in :contractIds]){
    	for(Contract_Line_Item__c cli: [select Contract__c, Product__c, Items_Processed__c, Amount_Processed__c, Shipped_Quantity__c, ProductParentUnique__c from Contract_Line_Item__c where Contract__c in :contractIds]){
    		// Make sure there are 0s and not null values.
    		if(cli.Items_Processed__c == null){
    			cli.Items_Processed__c = 0;
    		}
    		
    		if(cli.Amount_Processed__c == null){
    			cli.Amount_Processed__c = 0;
    		}
    		
    		if(cli.Shipped_Quantity__c == null){
    			cli.Shipped_Quantity__c = 0;
    		}
    		
            String ContractUniqueValue = string.valueOf(cli.Contract__c) + string.valueOf(cli.Product__c) + (cli.ProductParentUnique__c!=null?cli.ProductParentUnique__c.substring(0,18):'') ;
            /*
    		// Does this Order Product's Product match the Contract Line Item's Product?
    		if(oiReleasedQuantityMap.get(cli.Line_Item_Unique_Value__c) != null){
				// Calculate the Release Quantity.
				cli.Items_Processed__c = cli.Items_Processed__c + oiReleasedQuantityMap.get(cli.Line_Item_Unique_Value__c);
				
				// Calculate the Release Value.
				if(oiReleasedValueMap.get(cli.Line_Item_Unique_Value__c) != null){
					cli.Amount_Processed__c = cli.Amount_Processed__c + oiReleasedValueMap.get(cli.Line_Item_Unique_Value__c);
				}
				
				// Calculate the  Release Quantity from cancelled quantity.
				if(oiCancelledQuantityMap.get(cli.Line_Item_Unique_Value__c) != null){
					cli.Items_Processed__c = cli.Items_Processed__c - oiCancelledQuantityMap.get(cli.Line_Item_Unique_Value__c);
				}
				
				// Calculate the  Release Quantity & Release Value, from cancelled price.
				if(oiCancelledPriceMap.get(cli.Line_Item_Unique_Value__c) != null){
					cli.Amount_Processed__c = cli.Amount_Processed__c - oiCancelledPriceMap.get(cli.Line_Item_Unique_Value__c);
				}
				
				// Calculate the Shipped Quantity.
				if(oiShippedQuantityMap.get(cli.Line_Item_Unique_Value__c) != null){
					cli.Shipped_Quantity__c = cli.Shipped_Quantity__c + oiShippedQuantityMap.get(cli.Line_Item_Unique_Value__c);
				}
    			
    			// These Contract Line Items will be updated.
    			updateContLineItemsList.add(cli);
    		}
    		*/
    		// Does this Order Product's Product match the Contract Line Item's Product?
    		if(oiReleasedQuantityMap.get(ContractUniqueValue) != null){
				// Calculate the Release Quantity.
				cli.Items_Processed__c = cli.Items_Processed__c + oiReleasedQuantityMap.get(ContractUniqueValue);
				
    		system.debug('oiReleasedValueMap.get(ContractUniqueValue): ' + oiReleasedValueMap.get(ContractUniqueValue));
    		system.debug('cli.Amount_Processed__c: ' + cli.Amount_Processed__c);
				// Calculate the Release Value.
				if(oiReleasedValueMap.get(ContractUniqueValue) != null){
					cli.Amount_Processed__c = cli.Amount_Processed__c + oiReleasedValueMap.get(ContractUniqueValue);
				}
				
				// Calculate the  Release Quantity from cancelled quantity.
				if(oiCancelledQuantityMap.get(ContractUniqueValue) != null){
					cli.Items_Processed__c = cli.Items_Processed__c - oiCancelledQuantityMap.get(ContractUniqueValue);
				}
				
    		system.debug('oiReleasedValueMap.get(ContractUniqueValue): ' + oiReleasedValueMap.get(ContractUniqueValue));
    		system.debug('cli.Amount_Processed__c: ' + cli.Amount_Processed__c);
				// Calculate the  Release Quantity & Release Value, from cancelled price.
				if(oiCancelledPriceMap.get(ContractUniqueValue) != null){
					cli.Amount_Processed__c = cli.Amount_Processed__c - oiCancelledPriceMap.get(ContractUniqueValue);
				}
    		system.debug('oiReleasedValueMap.get(ContractUniqueValue): ' + oiReleasedValueMap.get(ContractUniqueValue));
    		system.debug('cli.Amount_Processed__c: ' + cli.Amount_Processed__c);
				
				// Calculate the Shipped Quantity.
				if(oiShippedQuantityMap.get(ContractUniqueValue) != null){
					cli.Shipped_Quantity__c = cli.Shipped_Quantity__c + oiShippedQuantityMap.get(ContractUniqueValue);
				}
    			
    			// These Contract Line Items will be updated.
    			updateContLineItemsList.add(cli);
    		}
            
    		system.debug('oiReleasedQuantityMap value: ' + oiReleasedQuantityMap);
    		system.debug('cli.Items_Processed__c value: ' + cli.Items_Processed__c);
    		system.debug('cli.Amount_Processed__c value: ' + cli.Amount_Processed__c);
    		system.debug('updateContLineItemsList value: ' + updateContLineItemsList);
    	}
    	
    	update updateContLineItemsList;
    }
}