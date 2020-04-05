public class DeserializeAdjustmentDeliveryAPI {

	public DeliveryCalendarResponse deliveryCalendarResponse;
    
	public class DeliveryCalendarResponse {
		public Integer retCode;
		public String retReason;
		public Integer zip;
		public List<TimeSlotList> timeSlotList;
	}
    
	public class TimeSlotList {
		public String windowCode;
		public List<String> dates;
	}

	public static DeserializeAdjustmentDeliveryAPI parse(String json) {
			return (DeserializeAdjustmentDeliveryAPI) System.JSON.deserialize(json, DeserializeAdjustmentDeliveryAPI.class);
	}
        
    
}