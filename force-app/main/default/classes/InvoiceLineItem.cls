/** @Description
*   This is the decorator object for the custom object InvoiceLineItem__c.
*/
public class InvoiceLineItem {
    public Invoice_Line_Item__c Record {public get; private set;}
    public InvoiceLineItem(Invoice_Line_Item__c originalRecord) {
        Record = originalRecord;
    }
}