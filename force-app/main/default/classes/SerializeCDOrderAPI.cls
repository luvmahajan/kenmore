public class SerializeCDOrderAPI {
	public String order_reference;
	public String purchase_order_number;
	public String order_id;
	public String reason_code;
	public String category;
	public String account_number;
	public Shipping_address shipping_address;
	public Payment_method payment_method;
	public List<Items> items;

	public class Shipping_address {
		public String address_line_1;
		public String address_line_2;
		public String zip;
		public String city;
		public String state;
		public String geo_code;
		public String county_code;
		public String county_name;
		public String first_name;
		public String last_name;
		public String email;
		public String day_phone;
	}

	public class Payment_method {
		public String type;
		public String authorized_purchaser;
		public String uid;
	}

	public class Items {
		public String part_number;
		public Double selling_price;
		public Double list_price;
		public Integer quantity;
		public String type;
	}
    

	
	public static SerializeCDOrderAPI parse(String json) {
            return (SerializeCDOrderAPI) System.JSON.deserialize(json, SerializeCDOrderAPI.class);
	}

    
}