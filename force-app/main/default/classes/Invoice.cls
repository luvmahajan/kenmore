/** @Description
*   This is the decorator object for the custom object Invoice__c that implements
*   functionality to create Invoices with Invoice Line Items, create PDFs and handle Attachments
*/
public virtual class Invoice { 
    
    /** @Description    The decorated original SObject */
    public Invoice__c Record {public get; private set;}
    
    /** @Description    The invoice line items */
    public List<InvoiceLineItem> LineItems {public get; private set;}
    
    public String invoicedateformatted {
        public get {
            return Record.Invoice_Date__c.format();
        }
    }
    
    public String invoiceduedate {
        public get {
            Date dueDate = Record.Invoice_Date__c.addDays(30);
            return dueDate.format();
        }
    }
    
    
    /** @Description    Initialize the object by invoice id */
    public Invoice(String recordId) {
        try {
            this([
                SELECT 	Id,
                Name,
                ADDR1__c,
                ADDR2__c,
                ADDR3__c,
                Bill_To__c,
                Billing_Unit__c,
                City__c,
                Customer_PO__c,
                Invoice_Number__c,
                Invoice_Territory_ID__c,
                Invoice_Type__c,
                Invoice_Date__c,
                Order__c,
                Order_Number__c,
                Parent_Account__c,
                Parent_Account__r.Name,
                Parent_Account__r.BillingStreet,
                Parent_Account__r.BillingState,
                Parent_Account__r.BillingCity,
                Parent_Account__r.BillingPostalCode,
                Rep_Name__c,
                Ship_to_Name__c,
                Ship_to_Name_2__c,
                State__c,
                Zip__c, 
                Grand_Total__c,
                Invoice_Total__c,
                Tax_Total__c,
                Pay_Type__c,
                (SELECT Id,Sequence__c,Product__c,Product_Description__c,Invoice_Id_Line_No__c,Order_Date_Entered__c,Pay_Type__c,Quantity__c,
                     Tax_Amount__c,Total_Price__c,Unit_Price__c,product__r.Name, product__r.ProductCode 
                     FROM Invoice_Line_Items__r  ORDER BY Sequence__c ASC )
                FROM Invoice__c WHERE Id = :recordId
                
            ]);
        } catch (Exception e) {
        }
        
        system.debug('invoice query result '+ Record );
    }
    
    /** @Description    Initialize the object with the fully queried record */
    public Invoice(Invoice__c originalRecord) {
        Record = originalRecord;
        
        // get line items from related records
        LineItems = new List<InvoiceLineItem>();
        if (originalRecord.Invoice_Line_Items__r != null) {
            for (Invoice_Line_Item__c ili : originalRecord.Invoice_Line_Items__r) {
                LineItems.add(new InvoiceLineItem(ili));
            }

            List<InvoiceLineItem> LineItemsTemp =  new List<InvoiceLineItem>();
            Integer n = LineItems.size();
            for (Integer i = 0; i < n; i++) {
                for (Integer j = 1; j < (n-i); j++) { 
                    if (integer.valueof(LineItems[j-1].Record.Sequence__c) > integer.valueof(LineItems[j].Record.Sequence__c)) { 
                        LineItemsTemp.add(LineItems[j-1]);
                        LineItems[j-1] = LineItems[j];
                        LineItems[j] = LineItemsTemp[0];
                        LineItemsTemp.clear();
                    }
                }
            }

        }
    }
}