public with sharing class VFInvoicePdfController {
    
    /** @Description    The fully initialized invoice object for this context  */
    public Invoice Invoice {
        public get {
            String InvoiceId;
            InvoiceId = ApexPages.currentPage().getParameters().get('Id');
            system.debug('invoice print' +invoiceId);
            if(InvoiceId == null ){
                //   InvoiceId = 'a3Y56000000CNuQEAW';                   
            }
            
           if (Invoice == null) {
                Invoice = new Invoice(InvoiceId);
           }
            
            system.debug('invoice return to pdf: '+Invoice);
            return Invoice;           
            
        }
        private set; 
    }
    
    
    public String PdfTitle {
        public get {
            String invoiceno = Invoice.Record.Invoice_Number__c == null ? 'Invoice': Invoice.Record.Invoice_Number__c;
            String currenttimestamp =  string.valueOf(DateTime.now());
            currenttimestamp = currenttimestamp.replace(' ','_');
            currenttimestamp = currenttimestamp.replace(':','_');
            currenttimestamp = currenttimestamp.replace('-','_');
            PdfTitle = 'Invoice_'+invoiceno +'_'+ currenttimestamp;
            return PdfTitle;
            
        }
        private set;
    }
}