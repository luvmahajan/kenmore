public class SerializeRXOrderAPI {

	public String order_reference;
	public String purchase_order_number;
	public Boolean common_carrier_location;
	public String order_id;
	public String reason_code;
	public String category;
	public Double delivery_charge;
	public Double premium_delivery_charge;
	public Double haulaway_charge;
	public String account_number;
	public String original_rma_number;
	public String order_reservation_number;
	public String original_order_date;
	public String pickup_date;
	public String delivery_instructions;
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
		public Double original_price;
		public Integer quantity;
		public String type;
		public String return_reason_code;
		public String return_category_code;
		public List<Required_parts> required_parts;
		public Delivery_option delivery_option;
	}
       
	public class Required_parts {
		public String part_number;
		public Double price;
		public Double original_price;
		public String return_reason_code;
		public String return_category_code;
	}

    public class Delivery_option {
		public String description;
		public String option_code;
		public Double addon_price;
		public String part_number;
	}

    	
	public static SerializeRXOrderAPI parse(String json) {
            return (SerializeRXOrderAPI) System.JSON.deserialize(json, SerializeRXOrderAPI.class);
	}

    
}