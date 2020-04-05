public class DeserializeCalenderAPI {
/*
	public class Time_slots {
		public String id;
		public String time_range;
		public String offset_price;
	}
*/
	public String order_reference_number;
	public List<Delivery_dates> delivery_dates;

	public class Delivery_dates {
		public String date1;
		public Boolean store_reservation;
	//	public List<Time_slots> time_slots;
	}

	
	public static DeserializeCalenderAPI parse(String json) {
		return (DeserializeCalenderAPI) System.JSON.deserialize(json, DeserializeCalenderAPI.class);
	}
}