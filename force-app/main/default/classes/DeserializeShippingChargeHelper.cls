public class DeserializeShippingChargeHelper {
    
public class AccessorialCharges {
		public String AccessorialCode;
		public Double Charge;
	}

	public List<AccessorialCharges> AccessorialCharges;
	public Double FuelSurcharge;
	public String ResponseCode;
	public String ResponseMessage;
	public Double TransportationCharge;
	
	public static DeserializeShippingChargeHelper parse(String json) {
          //      if(!Test.isRunningTest()){
                    return (DeserializeShippingChargeHelper) System.JSON.deserialize(json, DeserializeShippingChargeHelper.class);
        //        }else{
        //            return null; 
        //        }
	}
    
  /*
//String json = '{ \"AccessorialCharges\": [ { \"AccessorialCode\": \"STAIRS\", \"Charge\": 5 }, { \"AccessorialCode\": \"PALLET\", \"Charge\": 10 } ], \"FuelSurcharge\": 61.64, \"ResponseCode\": \"Success\", \"ResponseMessage\": null, \"TransportationCharge\": 260.1 }';
String json = '{ \"AccessorialCharges\": [ { "AccessorialCode\": "STAIRS", "Charge": 5 }, { "AccessorialCode": "PALLET", "Charge": 10 } ], "FuelSurcharge": 61.64, "ResponseCode": "Success", "ResponseMessage": null, "TransportationCharge": 260.1 }';
ShippingChargeTestController obj = ShippingChargeTestController.parse(json);
system.debug('obj--> ' + obj );

for(ShippingChargeTestController.AccessorialCharges ac:obj.AccessorialCharges){
    system.debug('ac.AccessorialCode--> ' + ac.AccessorialCode );
    system.debug('ac.Charge--> ' + ac.Charge );
}

system.debug('obj.FuelSurcharge--> ' + obj.FuelSurcharge );
system.debug('obj.ResponseCode--> ' + obj.ResponseCode );
system.debug('obj.ResponseMessage--> ' + obj.ResponseMessage );
system.debug('obj.TransportationCharge--> ' + obj.TransportationCharge );


String a2j = JSON.serialize(obj);
system.debug('a2j--> ' + a2j );
system.debug('json--> ' + json );
*/
    
    
    
}