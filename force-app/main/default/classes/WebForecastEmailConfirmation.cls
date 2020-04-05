public with sharing class WebForecastEmailConfirmation {

    private ApexPages.StandardController con;

    public WebForecastEmailConfirmation(ApexPages.StandardController controller) {
        con = controller;
    }

    Public Class ItemCollection {
        String Name;
        String Item;
        String DDC_Item;
        String RRC_Item;
        String Week_Date;
        Integer Quantity;

        ItemCollection(Web_Forecast_Line_Item__c itemRecord, Date Week_Date, Decimal Quantity ) {
            this.Name       = itemRecord.Name;
            this.Item       = itemRecord.Item_Formatted__c;
            this.DDC_Item   = itemRecord.DDC_Item__c;
            this.RRC_Item   = itemRecord.RRC_Item__c;
            this.Week_Date  = Week_Date.month() + '/' + Week_Date.day() + '/' + Week_Date.year();
            this.Quantity   = Quantity.intValue();
        }
    }

    public PageReference EmailandAttach(){

        Web_Forecast__c Forescastdet = (Web_Forecast__c) con.getRecord();
        Web_Forecast__c header = [select Id, Name, Admin_Initials__c, Project__c, Sales_Rep_Name__c, Sales_Rep_Email__c, District_Manager__c, Ship_to_Zipcode__r.name from Web_Forecast__c where Id = :Forescastdet.Id];
        Web_Forecast_Line_Item__c[] items = [SELECT Id, Name, DDC_Item__c, Item__c, Item_Formatted__c, RRC_Item__c, Item_Dist_Type__c,
                Week1__c, Week2__c, Week3__c,Week4__c, Week5__c, Week6__c, Week7__c, Week8__c, Week9__c, Week10__c, Week11__c, Week12__c, Week13__c,
                Week14__c, Week15__c, Week16__c,Week17__c, Week18__c, Week19__c, Week20__c, Week21__c, Week22__c, Week23__c, Week24__c, Week25__c, Week26__c,
                Qty_Week1__c, Qty_Week2__c, Qty_Week3__c, Qty_Week4__c, Qty_Week5__c, Qty_Week6__c, Qty_Week7__c, Qty_Week8__c, Qty_Week9__c, Qty_Week10__c, Qty_Week11__c, Qty_Week12__c, Qty_Week13__c,
                Qty_Week14__c, Qty_Week15__c, Qty_Week16__c, Qty_Week17__c, Qty_Week18__c, Qty_Week19__c, Qty_Week20__c, Qty_Week21__c, Qty_Week22__c, Qty_Week23__c, Qty_Week24__c, Qty_Week25__c, Qty_Week26__c,
                LastModifiedDate FROM Web_Forecast_Line_Item__c where Web_Forecast_Header__c = :header.Id];

        system.debug('### Forecase Header' + header);
        system.debug('### Forecase Items' + items);
        system.debug('Header project checkbox' +header.Project__c);

        string project;
        if(header.Project__c == True){
            project = 'CTA';
        } else {
            project = 'FCS';
        }
        system.debug('project/contract checkbox' +project);

        List<ItemCollection> DDC_items = new List<ItemCollection>();
        List<ItemCollection> RRC_items = new List<ItemCollection>();

        for (Web_Forecast_Line_Item__c aItem: items) {

            if( aItem.Qty_Week1__c != null ) {
                ItemCollection lv_item = new ItemCollection(aItem,aItem.Week1__c, aItem.Qty_Week1__c );
                if(aItem.Item_Dist_Type__c == 'DD') DDC_items.add(lv_item);
                else if(aItem.Item_Dist_Type__c == 'TW') RRC_items.add(lv_item);
            }
            if( aItem.Qty_Week2__c != null ) {
                ItemCollection lv_item = new ItemCollection(aItem,aItem.Week2__c, aItem.Qty_Week2__c);
                if(aItem.Item_Dist_Type__c == 'DD') DDC_items.add(lv_item);
                else if(aItem.Item_Dist_Type__c == 'TW') RRC_items.add(lv_item);
            }
            if( aItem.Qty_Week3__c != null ) {
                ItemCollection lv_item = new ItemCollection(aItem,aItem.Week3__c, aItem.Qty_Week3__c);
                if(aItem.Item_Dist_Type__c == 'DD') DDC_items.add(lv_item);
                else if(aItem.Item_Dist_Type__c == 'TW') RRC_items.add(lv_item);
            }
            if( aItem.Qty_Week4__c != null ) {
                ItemCollection lv_item = new ItemCollection(aItem,aItem.Week4__c, aItem.Qty_Week4__c);
                if(aItem.Item_Dist_Type__c == 'DD') DDC_items.add(lv_item);
                else if(aItem.Item_Dist_Type__c == 'TW') RRC_items.add(lv_item);
            }
            if( aItem.Qty_Week5__c != null ) {
                ItemCollection lv_item = new ItemCollection(aItem,aItem.Week5__c, aItem.Qty_Week5__c);
                if(aItem.Item_Dist_Type__c == 'DD') DDC_items.add(lv_item);
                else if(aItem.Item_Dist_Type__c == 'TW') RRC_items.add(lv_item);
            }
            if( aItem.Qty_Week6__c != null ) {
                ItemCollection lv_item = new ItemCollection(aItem,aItem.Week6__c, aItem.Qty_Week6__c);
                if(aItem.Item_Dist_Type__c == 'DD') DDC_items.add(lv_item);
                else if(aItem.Item_Dist_Type__c == 'TW') RRC_items.add(lv_item);
            }
            if( aItem.Qty_Week7__c != null ) {
                ItemCollection lv_item = new ItemCollection(aItem,aItem.Week7__c, aItem.Qty_Week7__c);
                if(aItem.Item_Dist_Type__c == 'DD') DDC_items.add(lv_item);
                else if(aItem.Item_Dist_Type__c == 'TW') RRC_items.add(lv_item);
            }
            if( aItem.Qty_Week8__c != null ) {
                ItemCollection lv_item = new ItemCollection(aItem, aItem.Week8__c, aItem.Qty_Week8__c);
                if(aItem.Item_Dist_Type__c == 'DD') DDC_items.add(lv_item);
                else if(aItem.Item_Dist_Type__c == 'TW') RRC_items.add(lv_item);
            }
            if( aItem.Qty_Week9__c != null ) {
                ItemCollection lv_item = new ItemCollection(aItem,aItem.Week9__c, aItem.Qty_Week9__c);
                if(aItem.Item_Dist_Type__c == 'DD') DDC_items.add(lv_item);
                else if(aItem.Item_Dist_Type__c == 'TW') RRC_items.add(lv_item);
            }
            if( aItem.Qty_Week10__c != null ) {
                ItemCollection lv_item = new ItemCollection(aItem,aItem.Week10__c, aItem.Qty_Week10__c);
                if(aItem.Item_Dist_Type__c == 'DD') DDC_items.add(lv_item);
                else if(aItem.Item_Dist_Type__c == 'TW') RRC_items.add(lv_item);
            }
            if( aItem.Qty_Week11__c != null ) {
                ItemCollection lv_item = new ItemCollection(aItem, aItem.Week11__c, aItem.Qty_Week11__c);
                if(aItem.Item_Dist_Type__c == 'DD') DDC_items.add(lv_item);
                else if(aItem.Item_Dist_Type__c == 'TW') RRC_items.add(lv_item);
            }
            if( aItem.Qty_Week12__c != null ) {
                ItemCollection lv_item = new ItemCollection(aItem, aItem.Week12__c, aItem.Qty_Week12__c);
                if(aItem.Item_Dist_Type__c == 'DD') DDC_items.add(lv_item);
                else if(aItem.Item_Dist_Type__c == 'TW') RRC_items.add(lv_item);
            }
            if( aItem.Qty_Week13__c != null ) {
                ItemCollection lv_item = new ItemCollection( aItem, aItem.Week13__c, aItem.Qty_Week13__c);
                if(aItem.Item_Dist_Type__c == 'DD') DDC_items.add(lv_item);
                else if(aItem.Item_Dist_Type__c == 'TW') RRC_items.add(lv_item);
            }
            if( aItem.Qty_Week14__c != null ) {
                ItemCollection lv_item = new ItemCollection( aItem, aItem.Week14__c, aItem.Qty_Week14__c);
                if(aItem.Item_Dist_Type__c == 'DD') DDC_items.add(lv_item);
                else if(aItem.Item_Dist_Type__c == 'TW') RRC_items.add(lv_item);
            }
            if( aItem.Qty_Week15__c != null ) {
                ItemCollection lv_item = new ItemCollection( aItem, aItem.Week15__c, aItem.Qty_Week15__c);
                if(aItem.Item_Dist_Type__c == 'DD') DDC_items.add(lv_item);
                else if(aItem.Item_Dist_Type__c == 'TW') RRC_items.add(lv_item);
            }
            if( aItem.Qty_Week16__c != null ) {
                ItemCollection lv_item = new ItemCollection( aItem, aItem.Week16__c, aItem.Qty_Week16__c);
                if(aItem.Item_Dist_Type__c == 'DD') DDC_items.add(lv_item);
                else if(aItem.Item_Dist_Type__c == 'TW') RRC_items.add(lv_item);
            }
            if( aItem.Qty_Week17__c != null ) {
                ItemCollection lv_item = new ItemCollection( aItem, aItem.Week17__c, aItem.Qty_Week17__c);
                if(aItem.Item_Dist_Type__c == 'DD') DDC_items.add(lv_item);
                else if(aItem.Item_Dist_Type__c == 'TW') RRC_items.add(lv_item);
            }
            if( aItem.Qty_Week18__c != null ) {
                ItemCollection lv_item = new ItemCollection( aItem, aItem.Week18__c, aItem.Qty_Week18__c);
                if(aItem.Item_Dist_Type__c == 'DD') DDC_items.add(lv_item);
                else if(aItem.Item_Dist_Type__c == 'TW') RRC_items.add(lv_item);
            }
            if( aItem.Qty_Week19__c != null ) {
                ItemCollection lv_item = new ItemCollection( aItem, aItem.Week19__c, aItem.Qty_Week19__c);
                if(aItem.Item_Dist_Type__c == 'DD') DDC_items.add(lv_item);
                else if(aItem.Item_Dist_Type__c == 'TW') RRC_items.add(lv_item);
            }
            if( aItem.Qty_Week20__c != null ) {
                ItemCollection lv_item = new ItemCollection( aItem, aItem.Week20__c, aItem.Qty_Week20__c);
                if(aItem.Item_Dist_Type__c == 'DD') DDC_items.add(lv_item);
                else if(aItem.Item_Dist_Type__c == 'TW') RRC_items.add(lv_item);
            }
            if( aItem.Qty_Week21__c != null ) {
                ItemCollection lv_item = new ItemCollection( aItem, aItem.Week21__c, aItem.Qty_Week21__c);
                if(aItem.Item_Dist_Type__c == 'DD') DDC_items.add(lv_item);
                else if(aItem.Item_Dist_Type__c == 'TW') RRC_items.add(lv_item);
            }
            if( aItem.Qty_Week22__c != null ) {
                ItemCollection lv_item = new ItemCollection( aItem, aItem.Week22__c, aItem.Qty_Week22__c);
                if(aItem.Item_Dist_Type__c == 'DD') DDC_items.add(lv_item);
                else if(aItem.Item_Dist_Type__c == 'TW') RRC_items.add(lv_item);
            }
            if( aItem.Qty_Week23__c != null ) {
                ItemCollection lv_item = new ItemCollection( aItem, aItem.Week23__c, aItem.Qty_Week23__c);
                if(aItem.Item_Dist_Type__c == 'DD') DDC_items.add(lv_item);
                else if(aItem.Item_Dist_Type__c == 'TW') RRC_items.add(lv_item);
            }
            if( aItem.Qty_Week24__c != null ) {
                ItemCollection lv_item = new ItemCollection( aItem, aItem.Week24__c, aItem.Qty_Week24__c);
                if(aItem.Item_Dist_Type__c == 'DD') DDC_items.add(lv_item);
                else if(aItem.Item_Dist_Type__c == 'TW') RRC_items.add(lv_item);
            }
            if( aItem.Qty_Week25__c != null ) {
                ItemCollection lv_item = new ItemCollection( aItem, aItem.Week25__c, aItem.Qty_Week25__c);
                if(aItem.Item_Dist_Type__c == 'DD') DDC_items.add(lv_item);
                else if(aItem.Item_Dist_Type__c == 'TW') RRC_items.add(lv_item);
            }
            if( aItem.Qty_Week26__c != null ) {
                ItemCollection lv_item = new ItemCollection( aItem, aItem.Week26__c, aItem.Qty_Week26__c);
                if(aItem.Item_Dist_Type__c == 'DD') DDC_items.add(lv_item);
                else if(aItem.Item_Dist_Type__c == 'TW') RRC_items.add(lv_item);
            }
        }
        system.debug('### DDC_items collection to CSV' + DDC_items);
        system.debug('### RRC_items collection to CSV' + RRC_items);

        // ********************************** DDC CSV File Creation ********************************** //

        List<Messaging.Emailfileattachment> emailfileAttachments  = new   List<Messaging.Emailfileattachment>();

        string finalStringDDC = '';
        string recordStringDDC = '';
        DateTime dT = System.now();
        Date myDate = date.newinstance(dT.year(), dT.month(), dT.day());

        if(DDC_items.size() > 0){
            for (ItemCollection aItem: DDC_items) {

                recordStringDDC = 'jporra1' + ',' + header.Name + ',' + aItem.Item + ',' + aItem.DDC_Item + ',' + 'CSL' + ',' + 'I'
                        + ',' + Project + ',' + aItem.Week_Date + ',' + aItem.Quantity + ',' + header.Ship_to_Zipcode__r.name
                        + ',' + header.Sales_Rep_Name__c + ',' + header.District_Manager__c + ',' + header.Admin_Initials__c + ',' + header.Sales_Rep_Email__c + '\n';

                finalStringDDC = finalStringDDC + recordStringDDC;
            }

            String DDC_FileName = header.Name+' '+'IDRP'+' '+'DDC'+ ' '+String.valueof(myDate)+'.csv';

            Messaging.EmailFileAttachment DDCAttc = new Messaging.EmailFileAttachment();
            DDCAttc.setFileName(DDC_FileName);
            DDCAttc.setBody(Blob.valueOf(finalStringDDC));
            emailfileAttachments.add(DDCAttc);

            Attachment DDCattachment = new Attachment();
            DDCattachment.Body = Blob.valueOf(finalStringDDC);
            DDCattachment.Name = DDC_FileName;
            DDCattachment.ParentId = header.Id;
            insert DDCattachment;
            system.debug('### DDC Attachment Successful');
        }

        // ********************************** RRC CSV File Creation ********************************** //
        string finalStringRRC = '';
        string recordStringRRC = '';

        if(RRC_items.size() > 0){

            for (ItemCollection aItem: RRC_items) {

                recordStringRRC =  aItem.Item + ',' + aItem.RRC_Item + ',' + aItem.Week_Date
                        + ',' + header.Name + ',' + '0' + ','+ aItem.Quantity + ',' + header.Sales_Rep_Email__c + '\n';
                finalStringRRC = finalStringRRC + recordStringRRC ;
            }

            String RRC_FileName = header.Name+' '+'IDRP'+' '+'RRC'+' '+String.valueof(myDate)+'.csv';

            Messaging.EmailFileAttachment RRCAttc = new Messaging.EmailFileAttachment();
            RRCAttc.setFileName(RRC_FileName);
            RRCAttc.setBody(Blob.valueOf(finalStringRRC));
            emailfileAttachments.add(RRCAttc);

            Attachment RRCattachment = new Attachment();
            RRCattachment.Body = Blob.valueOf(finalStringRRC);
            RRCattachment.Name = RRC_FileName;
            RRCattachment.ParentId = header.Id;
            insert RRCattachment;
            system.debug('### RRC Attachment Successful');
        }



        // ********************************** E-MAIL SEND ********************************** //

        Messaging.SingleEmailMessage dummyemail = new Messaging.SingleEmailMessage();

        EmailTemplate template = [SELECT Id from EmailTemplate where DeveloperName = 'Web_Forecast_Email_Confirmation'];
        Contact dummyContact = [select id, Email from Contact where email != null limit 1];
        //jirala
        Savepoint sp = Database.setSavepoint();
            
        List<Zip_Code__c> lstTestZipCode = new List<Zip_Code__c>();
        
        Zip_Code__c test_zipcode_1 = new Zip_Code__c();
        test_zipcode_1.Name = '60601';
        test_zipcode_1.OwnerId = system.UserInfo.getUserId();
        test_zipcode_1.State__c = 'IL';
        
        lstTestZipCode.add(test_zipcode_1);
        
        insert lstTestZipCode;
                   
        Account a = new Account(name = 'Some Acc');
        a.BillingPostalCode = '60601';
        insert a;

        Contact contact = new Contact();
        contact.FirstName = 'WebForecast Email Out';
        contact.LastName = 'Dummy' ;
        contact.AccountId = a.Id;
        contact.Email = 'CDL@test.com';
        insert contact;

        dummyemail.setTargetObjectId(dummyContact.Id);
        dummyemail.setSaveAsActivity(false);
        dummyemail.setTemplateId(template.Id);
        dummyemail.setWhatId(header.Id);
        dummyemail.setToAddresses(new list<string>{ contact.Email });
        //dummyemail.setFileAttachments(emailfileAttachments);
        system.debug('dummyemail: ' + dummyemail);

        Messaging.sendEmail(new Messaging.SingleEmailMessage[]{ dummyemail });
        Database.rollback(sp);

        Messaging.SingleEmailMessage nowRealEmailToSend = new Messaging.SingleEmailMessage();
        nowRealEmailToSend.setSenderDisplayName('hofflog@searshc.com');
        //nowRealEmailToSend.setFromAddress('hofflog@searshc.com');
        nowRealEmailToSend.setToAddresses(new list<string>{ header.Sales_Rep_Email__c });
        nowRealEmailToSend.setPlainTextBody(dummyemail.getPlainTextBody());
        nowRealEmailToSend.setHTMLBody(dummyemail.getHTMLBody());
        nowRealEmailToSend.setSubject(dummyemail.getSubject());
        nowRealEmailToSend.setFileAttachments(emailfileAttachments);
        //nowRealEmailToSend.add(emailToSend);
        Messaging.SendEmailResult [] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[]{ nowRealEmailToSend });
        System.debug('nowRealEmailToSend // ' + nowRealEmailToSend);

        for(Messaging.SendEmailResult sendMessageresult : results){
            if (!sendMessageresult.isSuccess()) {
                System.StatusCode statusCode = sendMessageresult.getErrors()[0].getStatusCode();
                system.debug('###Email Error: '+sendMessageresult.getErrors()[0].getMessage()) ;
                Forescastdet.EmailStatus__c = 'Email Error: '+sendMessageresult.getErrors()[0].getMessage();
            }
            else{
                system.debug('###Email Sent Successfull');
                Forescastdet.EmailStatus__c = 'Email sent successfully on '+DateTime.now().format()+' To '+header.Sales_Rep_Email__c;
            }
        }

        con.save();  //header record save with email status.
        return new Pagereference('/'+header.Id);  //page re-direct to refresh header page.
    }
}