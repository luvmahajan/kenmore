public class SerializeAdjustmentDeliveryAPI {

	public DeliveryCalendarRequest deliveryCalendarRequest;

	public class DeliveryCalendarRequest {
		public String clientCode;
		public String sellingStoreID;
		public String timeWindow;
		public Double cubes;
		public Integer nofItems;
		public String servicetime;
		public String startDate;
		public String address1;
		public String address2;
		public String city;
		public String state;
		public String zip;
	}

	public static SerializeAdjustmentDeliveryAPI parse(String json) {
            return (SerializeAdjustmentDeliveryAPI) System.JSON.deserialize(json, SerializeAdjustmentDeliveryAPI.class);
	}


}