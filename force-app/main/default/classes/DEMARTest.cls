@isTest
public class DEMARTest {
    
    static testMethod void test_DemarShipperAddress(){
        
        String ran = DataInsertFactory.insertQuote();
            
        List<SBQQ__Quote__c> lstTestQuote = new List<SBQQ__Quote__c>();
        lstTestQuote = [SELECT Id FROM SBQQ__Quote__c ORDER BY Id];
        
        List<Product2> lstTestProduct = new List<Product2>();
        lstTestProduct = [SELECT Id FROM Product2 ORDER BY Id];
        
        List<Product_Specification__c > lstTestSpecificationInsert = new List<Product_Specification__c >();
        Product_Specification__c objTestSpecificationInsert = new Product_Specification__c();
        for(Product2 pr:lstTestProduct ){
            objTestSpecificationInsert = new Product_Specification__c(Product__c = pr.Id, Name = 'Color', Specification_Name__c = 'Color Family', Specification__c = 'White');lstTestSpecificationInsert.add(objTestSpecificationInsert);
            objTestSpecificationInsert = new Product_Specification__c(Product__c = pr.Id, Name = 'Certifications & Ratings', Specification_Name__c = 'ADA Compliant', Specification__c = 'TRUE');lstTestSpecificationInsert.add(objTestSpecificationInsert);
            objTestSpecificationInsert = new Product_Specification__c(Product__c = pr.Id, Name = 'Certifications & Ratings', Specification_Name__c = 'Energy Star Compliant', Specification__c = 'TRUE');lstTestSpecificationInsert.add(objTestSpecificationInsert);
            objTestSpecificationInsert = new Product_Specification__c(Product__c = pr.Id, Name = 'Dimensions', Specification_Name__c = 'Length', Specification__c = '23');lstTestSpecificationInsert.add(objTestSpecificationInsert);
            objTestSpecificationInsert = new Product_Specification__c(Product__c = pr.Id, Name = 'Dimensions', Specification_Name__c = 'Height', Specification__c = '23');lstTestSpecificationInsert.add(objTestSpecificationInsert);
            objTestSpecificationInsert = new Product_Specification__c(Product__c = pr.Id, Name = 'Dimensions', Specification_Name__c = 'Width', Specification__c = '23');lstTestSpecificationInsert.add(objTestSpecificationInsert);
            objTestSpecificationInsert = new Product_Specification__c(Product__c = pr.Id, Name = 'Dimensions', Specification_Name__c = 'Weight', Specification__c = '23');lstTestSpecificationInsert.add(objTestSpecificationInsert);
     //       objTestSpecificationInsert.Product__c = pr.Id;
     //       objTestSpecificationInsert.Name = 'Color';
     //       objTestSpecificationInsert.Specification_Name__c = 'Color Family';
     //       objTestSpecificationInsert.Specification__c = 'White';
            
        }
        insert lstTestSpecificationInsert;
        
        PageReference pageRef = Page.DemarShipperAddress; 
        pageRef.getParameters().put('id', lstTestQuote[0].Id);
        Test.setCurrentPage(pageRef);
        
        DemarShipperAddressController ctredt = new DemarShipperAddressController();
        ctredt.storeNumber = '1234';
        ctredt.redirectQLE();

        PageReference pageRef2 = Page.RouteDelivery; 
        pageRef2.getParameters().put('id', lstTestQuote[0].Id);
        Test.setCurrentPage(pageRef2);
        
        RouteDeliveryController ctredt2 = new RouteDeliveryController();
        ctredt2.redirectQLE();

        PageReference pageRef3 = Page.DemarCharges; 
        pageRef3.getParameters().put('id', lstTestQuote[0].Id);
        Test.setCurrentPage(pageRef3);
        
        DemarChargesController ctredt3 = new DemarChargesController();
        ctredt3.redirectQLE();

        
         //   string resdoc = response.getBody();
            string resdoc = 'resdoc';
            system.debug('resdoc:' +resdoc);
            
            SerializeCalenderAPI obj1 = SerializeCalenderAPI.parse(resdoc);
            system.debug('obj1:' +obj1);
         
            SerializeOrderAPI obj2 = SerializeOrderAPI.parse(resdoc);
            system.debug('obj2:' +obj2);
         
        

    } 
}