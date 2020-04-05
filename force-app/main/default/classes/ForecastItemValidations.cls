public class ForecastItemValidations {
    
    public static void ForecastItemBeforeValidations(Web_Forecast_Line_Item__c LineItem) {

        system.debug ('Line item details ' +LineItem);

        if(LineItem.Item__c != null && LineItem.Division__c != null){

        String lv_item = LineItem.Item__c;
        if(LineItem.Item__c.length() == 4) {
            lv_item = lv_item + ' ';
        }

        LineItem.Item_Formatted__c = LineItem.Division__c + '-' + lv_item.rightPad(5, '0') + '-' + '000';
        system.debug('LineItem.Item__c--> '+LineItem.Item_Formatted__c);
        //Get shipto zipcode from header
        //Step1. Validate if it is a valid div/item or not
        //Query FCST_Item table

        Web_Forecast__c header = [select Id, Ship_to_Zipcode__r.name from Web_Forecast__c where Id = :LineItem.Web_Forecast_Header__c];
        system.debug('Header--> '+header);
        FCST_Item_Info__c[] fcstitemdet = [select Dist_Type__c, Item_8721_Stock__c, Status__c from FCST_Item_Info__c where Item_Num__c = :LineItem.Item_Formatted__c];
        system.debug('FCST_Item_Info--> '+fcstitemdet);
        Transitions_Item__c[] transitem = [select Old_Item__c, New_Item__c from Transitions_Item__c where Old_Item__c = :LineItem.Item_Formatted__c];
        system.debug('Transitions_Item--> '+transitem);
        Zipcode_DDC_RRC__c[] DDC_info = [select DDC__c, RRC__c from Zipcode_DDC_RRC__c where Name = :header.Ship_to_Zipcode__r.name];
        system.debug('Zipcode_DDC_RRC--> '+DDC_info);
        LineItem.DDC_Item__c = DDC_info[0].DDC__c;
        LineItem.RRC_Item__c = DDC_info[0].RRC__c;

        //Unique item key


        Web_Forecast_Line_Item__c[] itemuniquequery = [SELECT Id, Item__c FROM Web_Forecast_Line_Item__c where Web_Forecast_Header__c = :header.Id and Item_Formatted__c = :LineItem.Item_Formatted__c
                                                            and id <> :LineItem.Id ];
        system.debug('duplicate item' +itemuniquequery);
        if(itemuniquequery.size() > 0){
            LineItem.Item__c.addError( 'Duplicate item is not allowed. Item has already been entered');
        }

        if(fcstitemdet.size() > 0) {

            if(transitem.size() > 0) {
                //Step2: Is it a Transition item? Query Transitions Item table
                if(transitem[0].Old_Item__c <> transitem[0].New_Item__c) {
                    //raise error message to User saying transition item exists
                    LineItem.Item__c.addError( transitem[0].Old_Item__c+' is discontinued, please use transition item '+transitem[0].New_Item__c.substring(4,9));
                  //  LineItem.addError( transitem[0].Old_Item__c+' is discontinued, please use transition item '+transitem[0].New_Item__c);
                }
            }

            //Step3: Check If DDC = '8721' check FCST_item table, field 8721_stock to determine if set to Yes -- If not change DDC to '8870'
            //Query Zipcode table
            if((DDC_info[0].DDC__c == '8721' && fcstitemdet[0].Item_8721_Stock__c == 'N' )) {
                LineItem.DDC_Item__c = '8870';  //update DDC on header to
            }

            LineItem.Item_Dist_Type__c = fcstitemdet[0].Dist_Type__c;

        } else{
            //Raise error message "Item is not valid"
            LineItem.Item__c.addError('Division/Item Cannot Be Forecast');
        }

    }
    }
    
}