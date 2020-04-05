@isTest
public class VFInvoicePdfControllerTest {
    
    static void makeData(){
        DataInsertFactory.insertQuote();
        Account objAccount = new Account();
        objAccount = [SELECT Id FROM Account LIMIT 1];
        List<Invoice__c> objInvoice = new List<Invoice__c>();
        objInvoice = [SELECT Id FROM Invoice__c];
        
        system.debug('objInvoice --> ' + objInvoice );
        system.debug('objInvoice.size() --> ' + objInvoice.size() );
        
        	Invoice__c invoicelist = new Invoice__c();
           	invoicelist.Invoice_number__c = 'Test123';
            invoicelist.order_number__c = '12345678';
            invoicelist.Invoice_Date__c = system.today();
            invoicelist.Parent_Account__c = objAccount.Id;
            invoicelist.Customer_PO__c = 'Test Invoice';  
            invoicelist.Ship_to_Name__c = 'Test Ship to Name';
            invoicelist.ADDR1__c = 'Test ship address';
        
        List<Invoice__c> Invoices = new List<Invoice__c>();
        Invoices.add(invoicelist);
        
          insert Invoices;
        
       Invoice_Line_Item__c InvoiceLineItems = TestDataFactory.createInvoiceLineItems(Invoices[0].Id);
            insert InvoiceLineItems;

    }
     
  //  @isTest
    static testMethod void InvoicePrintTestPDF() {
        // SETUP
        makeData();
        
        List<Invoice__c> Invoices = new List<Invoice__c>();
        Invoices = [SELECT Id FROM Invoice__c LIMIT 1];
        
        Test.setCurrentPage(Page.InvoicePdf);
        ApexPages.currentPage().getParameters().put('Id', Invoices[0].Id);
        
        system.debug('IRALA');
        system.debug('IRALA---'+new VFInvoicePdfController().Invoice.Record);
        system.debug('IRALA---'+new VFInvoicePdfController().PdfTitle);
        
        // VERIFY
        System.assertNotEquals(null, new VFInvoicePdfController().Invoice, 'Invoice');
        System.assertNotEquals(null, new VFInvoicePdfController().Invoice.Record, 'Invoice.Record');
        System.assertnotEquals('', new VFInvoicePdfController().PdfTitle, 'PdfTitle');
        System.assertnotEquals('', new VFInvoicePdfController().Invoice.invoiceduedate, 'invoiceduedate');
        System.assertnotEquals('', new VFInvoicePdfController().Invoice.invoicedateformatted, 'invoicedateformatted');
       
    }   
}


/*

@isTest
public class VFInvoicePdfControllerTest {

    public static List<Invoice__c> Invoices;

    @TestSetup
    static void makeData(){
        //Account a = TestDataFactory.createAccounts();
        //List<Account> a = TestDataFactory.createAccounts(1);
        //insert a;

       // Invoices = TestDataFactory.createInvoice(1,a[0].Id);
        Invoices = TestDataFactory.createInvoice(1);
          insert Invoices;
        
       Invoice_Line_Item__c InvoiceLineItems = TestDataFactory.createInvoiceLineItems(Invoices[0].Id);
            insert InvoiceLineItems;

    }
     
    @isTest
    static void InvoicePrintTestPDF() {
        // SETUP
        makeData();
        Test.setCurrentPage(Page.InvoicePdf);
        ApexPages.currentPage().getParameters().put('Id', Invoices[0].Id);
        
        system.debug('IRALA');
        system.debug('IRALA---'+new VFInvoicePdfController().Invoice.Record);
        system.debug('IRALA---'+new VFInvoicePdfController().PdfTitle);
        
        // VERIFY
        System.assertNotEquals(null, new VFInvoicePdfController().Invoice, 'Invoice');
        System.assertNotEquals(null, new VFInvoicePdfController().Invoice.Record, 'Invoice.Record');
        System.assertnotEquals('', new VFInvoicePdfController().PdfTitle, 'PdfTitle');
        System.assertnotEquals('', new VFInvoicePdfController().Invoice.invoiceduedate, 'invoiceduedate');
        System.assertnotEquals('', new VFInvoicePdfController().Invoice.invoicedateformatted, 'invoicedateformatted');
       
    }   
}

*/