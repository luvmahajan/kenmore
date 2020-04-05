public without sharing class InvoiceLineItemTriggerHandler {
    public static void afterInsert(list<Invoice_Line_Item__c> invLineItemList, map<Id, Invoice_Line_Item__c> invLineItemNewMap){
    	// Run the After Insert logic for the Contract Line Item(s).
    	updateContractLineItems('After Insert', invLineItemList, invLineItemNewMap, invLineItemNewMap);
    }
    
    public static void afterUpdate(list<Invoice_Line_Item__c> invLineItemList, map<Id, Invoice_Line_Item__c> invLineItemNewMap, map<Id, Invoice_Line_Item__c> invLineItemOldMap){
    	// Run the After Update logic for the Contract Line Item(s).
    	updateContractLineItems('After Update', invLineItemList, invLineItemNewMap, invLineItemOldMap);
    }
    
    public static void beforeDelete(list<Invoice_Line_Item__c> invLineItemList, map<Id, Invoice_Line_Item__c> invLineItemOldMap){
    	// Run the After Delete logic for the Contract Line Item(s).
    	updateContractLineItems('Before Delete', invLineItemList, invLineItemOldMap, invLineItemOldMap);
    }
    
    public static void updateContractLineItems(String triggerEventType, list<Invoice_Line_Item__c> invLineItemList, map<Id, Invoice_Line_Item__c> invLineItemNewMap, map<Id, Invoice_Line_Item__c> invLineItemOldMap){
    	
        Set<String> setParentInvoice = new Set<String>();
        
        for(Id iin:invLineItemNewMap.keyset()){
            setParentInvoice.add(invLineItemNewMap.get(iin).Invoice__c);
        }
        
        Map<String, String> mapInvoiceSequence = new Map<String, String>();
    	list<Invoice_Line_Item__c> lstILI = new list<Invoice_Line_Item__c>();
   //     lstILI =  [select Id, Invoice__c, Product__c, Sequence__c from Invoice_Line_Item__c where Id in :invLineItemNewMap.keySet()];
   //     lstILI =  [select Id, Invoice__c, Product__c, Sequence__c from Invoice_Line_Item__c ORDER BY Id DESC LIMIT 50000];
        lstILI =  [select Id, Invoice__c, Product__c, Sequence__c from Invoice_Line_Item__c WHERE Invoice__c IN:setParentInvoice ];
        for(Invoice_Line_Item__c li:lstILI){
            mapInvoiceSequence.put(li.Invoice__c + li.Sequence__c, li.Product__c);
        }
        
        system.debug('lstILI--> ' + lstILI );
        system.debug('lstILI.size()--> ' + lstILI.size() );
        system.debug('mapInvoiceSequence--> ' + mapInvoiceSequence );
        system.debug('mapInvoiceSequence.size()--> ' + mapInvoiceSequence.size() );
        system.debug('invLineItemNewMap.keySet()--> ' + invLineItemNewMap.keySet() );
        system.debug('invLineItemNewMap.size--> ' + invLineItemNewMap.size() );
   //     map<Id, Decimal> iliBilledQuantityMap = new map<Id, Decimal>();
        map<String, Decimal> iliBilledQuantityMap = new map<String, Decimal>();
        map<String, Decimal> iliBilledValueMap = new map<String, Decimal>();
    	map<Id, Invoice_Line_Item__c> prodIdInvLineItemMap = new map<Id, Invoice_Line_Item__c>();
    	set<Id> contractIds = new set<Id>();
    	list<Contract_Line_Item__c> updateContLineItemsList = new list<Contract_Line_Item__c>();
    	
    	for(Invoice_Line_Item__c ili: [select Invoice__c, Invoice__r.Order__r.ContractId, Product__c, Quantity__c, Sequence__c, High_Level_Item_No__c, Unit_Price__c, Tax_Amount__c from Invoice_Line_Item__c where Id in :invLineItemNewMap.keySet()]){
    		String parent =  (ili.High_Level_Item_No__c=='0' || ili.High_Level_Item_No__c==null || ili.High_Level_Item_No__c==''  )?mapInvoiceSequence.get(ili.Invoice__c + ili.Sequence__c):mapInvoiceSequence.get(ili.Invoice__c + ili.High_Level_Item_No__c);
            String UniqueValue = ili.Invoice__r.Order__r.ContractId + string.valueOf(ili.Product__c) + parent ;
            
            system.debug('parent--> ' + parent );
            system.debug('mapInvoiceSequence--> ' + mapInvoiceSequence );
            system.debug('UniqueValue--> ' + UniqueValue );
            
            Decimal qty = 0;
    		Decimal oldQty = 0;
    		Decimal unitPrice = 0;
    		Decimal oldunitPrice = 0;
    		Decimal totalPrice = 0;
    		Decimal oldtotalPrice = 0;
    		
    		// Make sure there are 0s and not null values.
    		if(ili.Quantity__c == null){
    			ili.Quantity__c = 0;
    		}
    		
    		if(ili.Unit_Price__c == null){
    			ili.Unit_Price__c = 0;
    		}
    		
    		if(ili.Tax_Amount__c == null){
    			ili.Tax_Amount__c = 0;
    		}
    		
    		if(triggerEventType == 'After Insert'){
    			qty = ili.Quantity__c;
    		//	unitPrice = ili.Unit_Price__c;
    			unitPrice = ili.Unit_Price__c + ili.Tax_Amount__c ;
                totalPrice = qty * unitPrice;
    		}
    		
    		if(triggerEventType == 'After Update'){
    			Invoice_Line_Item__c oldInvLineItem = invLineItemOldMap.get(ili.Id);
    			
    			if(oldInvLineItem.Quantity__c == null){
    				oldQty = 0;
    			} else{
    				oldQty = oldInvLineItem.Quantity__c;
    			}
                
    			if(oldInvLineItem.Unit_Price__c == null){
    				oldunitPrice = 0;
    			} else{
    				oldunitPrice = oldInvLineItem.Unit_Price__c;
    			}
                
    			if(oldInvLineItem.Tax_Amount__c == null){
    				oldunitPrice += 0;
    			} else{
    				oldunitPrice += oldInvLineItem.Tax_Amount__c;
    			}
                
    			if(oldQty != ili.Quantity__c){
    				// The Quantity has been updated, so find out if it increased or decreased.
    				qty = ili.Quantity__c - oldQty;
                }
                
    	//		if(oldunitPrice != ili.Unit_Price__c ){
    			if(oldunitPrice != (ili.Unit_Price__c + ili.Tax_Amount__c )){
    				// The Quantity has been updated, so find out if it increased or decreased.
    			//	unitPrice = ili.Unit_Price__c - oldunitPrice;
    				unitPrice = ili.Unit_Price__c + ili.Tax_Amount__c - oldunitPrice;
                }
                
    		system.debug('qty: ' + qty);
    		system.debug('unitPrice: ' + unitPrice);
                
    			oldtotalPrice = oldQty * oldunitPrice;
                totalPrice = qty * oldunitPrice + unitPrice * ili.Quantity__c ;
            //    totalPrice = tqty * unitPrice;
    		}
    		
    		if(triggerEventType == 'Before Delete'){
    			qty = 0 - ili.Quantity__c;
    	//		unitPrice = 0 - ili.Unit_Price__c;
    			unitPrice = 0 - (ili.Unit_Price__c + ili.Tax_Amount__c );
                totalPrice = qty * unitPrice;
    		}
    		
    		system.debug('oldtotalPrice: ' + oldtotalPrice);
    		system.debug('totalPrice: ' + totalPrice);
            /*
    		// Group each Invoice_Line_Item__c by its Product__c and summarize the values.
    		if(iliBilledQuantityMap.get(ili.Product__c) != null){
    			// This is not first Invoice_Line_Item__c related to this Invoice, so we need to add it to the previous value.
    			// Calculate the Billed Quantity.
    			Decimal tempBilledQuantity = iliBilledQuantityMap.get(ili.Product__c);
    			
    			tempBilledQuantity = tempBilledQuantity + qty;
    			
    			iliBilledQuantityMap.put(ili.Product__c, tempBilledQuantity);
    		} else{
    			// This is the first Invoice_Line_Item__c related to this Invoice.
    			// Calculate the Release Quantity.
				iliBilledQuantityMap.put(ili.Product__c, qty);
    		}
*/
            
    		// Group each Invoice_Line_Item__c by its Product__c and summarize the values.
    		if(iliBilledQuantityMap.get(UniqueValue) != null){
    			// This is not first Invoice_Line_Item__c related to this Invoice, so we need to add it to the previous value.
    			// Calculate the Billed Quantity.
    			Decimal tempBilledQuantity = iliBilledQuantityMap.get(UniqueValue);
    			
    			tempBilledQuantity = tempBilledQuantity + qty;
    			
    			iliBilledQuantityMap.put(UniqueValue, tempBilledQuantity);
    		} else{
    			// This is the first Invoice_Line_Item__c related to this Invoice.
    			// Calculate the Release Quantity.
				iliBilledQuantityMap.put(UniqueValue, qty);
    		}
            
    		// Group each Invoice_Line_Item__c by its Product__c and summarize the values.
    		if(iliBilledValueMap.get(UniqueValue) != null){
    			// This is not first Invoice_Line_Item__c related to this Invoice, so we need to add it to the previous value.
    			// Calculate the Billed Quantity.
    			Decimal tempBilledValue = iliBilledValueMap.get(UniqueValue);
    			
    			tempBilledValue = tempBilledValue + totalPrice;
    			
    			iliBilledValueMap.put(UniqueValue, tempBilledValue);
    		} else{
    			// This is the first Invoice_Line_Item__c related to this Invoice.
    			// Calculate the Release Quantity.
				iliBilledValueMap.put(UniqueValue, totalPrice);
    		}
            
    		
    		contractIds.add(ili.Invoice__r.Order__r.ContractId);
    	}
        
    		system.debug('iliBilledQuantityMap: ' + iliBilledQuantityMap);
    		system.debug('iliBilledValueMap: ' + iliBilledValueMap);
    	
    	for(Contract_Line_Item__c cli: [select Contract__c, Product__c, Billed_Quantity__c, ProductParentUnique__c, Billed_Value__c from Contract_Line_Item__c where Contract__c in :contractIds]){
    		// Make sure there are 0s and not null values.
    		if(cli.Billed_Quantity__c == null){
    			cli.Billed_Quantity__c = 0;
    		}
    		
    		if(cli.Billed_Value__c == null){
    			cli.Billed_Value__c = 0;
    		}
    		
            /*
    		// Does this Invoice Line Item's Product match the Contract Line Item's Product?
    		if(iliBilledQuantityMap.get(cli.Product__c) != null){
				// Calculate the Release Quantity.
				cli.Billed_Quantity__c = cli.Billed_Quantity__c + iliBilledQuantityMap.get(cli.Product__c);
    			
    			// These Contract Line Items will be updated.
    			updateContLineItemsList.add(cli);
    		}
    		*/
            
            String ContractUniqueValue = string.valueOf(cli.Contract__c) + string.valueOf(cli.Product__c) + (cli.ProductParentUnique__c!=null?cli.ProductParentUnique__c.substring(0,18):'') ;
 //           system.debug('string.valueOf(cli.Contract__c)--> ' + string.valueOf(cli.Contract__c) );
 //           system.debug('string.valueOf(cli.Product__c)--> ' + string.valueOf(cli.Product__c) );
 //           system.debug('cli.ProductParentUnique__c--> ' + cli.ProductParentUnique__c );
            system.debug('ContractUniqueValue--> ' + ContractUniqueValue );
    		// Does this Invoice Line Item's Product match the Contract Line Item's Product?
    		if(iliBilledQuantityMap.get(ContractUniqueValue) != null || iliBilledValueMap.get(ContractUniqueValue) != null ){
                if(iliBilledQuantityMap.get(ContractUniqueValue) != null ){
				// Calculate the Release Quantity.
				cli.Billed_Quantity__c = cli.Billed_Quantity__c + iliBilledQuantityMap.get(ContractUniqueValue);
                }
                if(iliBilledValueMap.get(ContractUniqueValue) != null ){
				// Calculate the Release Quantity.
				cli.Billed_Value__c = cli.Billed_Value__c + iliBilledValueMap.get(ContractUniqueValue);
                }
                
    			// These Contract Line Items will be updated.
    			updateContLineItemsList.add(cli);
    		}
            
    		system.debug('iliBilledQuantityMap: ' + iliBilledQuantityMap);
    		system.debug('iliBilledValueMap: ' + iliBilledValueMap);
    		system.debug('cli.Billed_Quantity__c value: ' + cli.Billed_Quantity__c);
    		system.debug('cli.Billed_Value__c value: ' + cli.Billed_Value__c);
    		system.debug('updateContLineItemsList value: ' + updateContLineItemsList);
    	}
    	
    	update updateContLineItemsList;
    }
}