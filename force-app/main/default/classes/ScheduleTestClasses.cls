@isTest
public class ScheduleTestClasses {
    
    static testMethod void test_ScheduledProductDocuments(){
         Test.StartTest();   
       DataInsertFactory.insertQuote();
        
       ScheduledProductDocuments rt = new ScheduledProductDocuments();
       String srt = '0 13 * * * ?';
       String jobID = system.schedule('ScheduledProductDocumentsTest', srt, rt);
        
       ScheduledQuoteApproval rt2 = new ScheduledQuoteApproval();
       String srt2 = '0 13 * * * ?';
       String jobID2 = system.schedule('ScheduledQuoteApprovalTest', srt2, rt2);

        List<SBQQ__Quote__c> lstTestQuote = new List<SBQQ__Quote__c>();
        lstTestQuote = [SELECT Id FROM SBQQ__Quote__c ORDER BY Id];
        List<Id> lstQuoteId = new List<Id>();
        lstQuoteId.add(lstTestQuote[0].Id);
        QuoteBusinessHours.quoteBusiensshour_method(lstQuoteId);
        
        List<Opportunity> lstOpportunity = new List<Opportunity>();
        lstOpportunity = [SELECT Id FROM Opportunity ORDER BY Id];
        ApexPages.StandardSetController sc = new ApexPages.StandardSetController(lstOpportunity);
        QuoteFlowButtonController ctrlqfb = new QuoteFlowButtonController(sc);
        ctrlqfb.redirectNewQuote();
        QuoteProjectButtonController ctrlqpb = new QuoteProjectButtonController(sc);
        ctrlqpb.redirectNewQuote();
        
        List<Delivery_Estimate__c> lstTestDeliveryEstimate = new List<Delivery_Estimate__c>();
        Delivery_Estimate__c test_de_1 = new Delivery_Estimate__c();
        test_de_1.Quote__c = lstTestQuote[0].Id;
        test_de_1.Opportunity_Name__c = lstOpportunity[0].Id;
        test_de_1.Building_Count__c = 1;
        test_de_1.Floors_Per_Building__c = 1;
        test_de_1.Units_Per_Building__c = 1;
        test_de_1.Units_Per_Floor__c = 1;
        test_de_1.Units_per_week__c = 1;
        lstTestDeliveryEstimate.add(test_de_1);
        insert lstTestDeliveryEstimate;
        
        List<Delivery_Estimate__c> lstTestDeliveryEstimateQry = new List<Delivery_Estimate__c>();
        lstTestDeliveryEstimateQry = [SELECT Id FROM Delivery_Estimate__c ORDER BY Id];
        
        List<Delivery_Estimate_Feedback__c> lstTestDeliveryEstimateFeedback = new List<Delivery_Estimate_Feedback__c>();
        Delivery_Estimate_Feedback__c test_def_1 = new Delivery_Estimate_Feedback__c();
        test_def_1.Delivery_Estimate__c = lstTestDeliveryEstimateQry[0].Id;
        lstTestDeliveryEstimateFeedback.add(test_def_1);
        insert lstTestDeliveryEstimateFeedback;
        
        List<Delivery_Estimate_Feedback__c> lstTestDeliveryEstimateFeedbackQry = new List<Delivery_Estimate_Feedback__c>();
        lstTestDeliveryEstimateFeedbackQry = [SELECT Id FROM Delivery_Estimate_Feedback__c ORDER BY Id];
        
        update lstTestDeliveryEstimateFeedback;
        delete lstTestDeliveryEstimateFeedback;
        
        PageReference pageRef2 = Page.RouteDeliveryEstimate; 
        pageRef2.getParameters().put('id', lstTestDeliveryEstimateQry[0].Id);
        Test.setCurrentPage(pageRef2);
        
        ApexPages.StandardController sc2 = new ApexPages.StandardController(lstTestDeliveryEstimateQry[0]);
        RouteDeliveryEstimateController ctrlrde = new RouteDeliveryEstimateController(sc2);
        ctrlrde.routeHandler();
        
         Test.stopTest();   
    }
}