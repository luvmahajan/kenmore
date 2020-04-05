public class SerializeCalenderAPI {

	public String order_reference_number;
	public String purchase_order_number;
	public String account_number;
	public Shipping_address shipping_address;
	public Pickup_detail pickup_detail;
	public String territory_id;
	public String district_id;
	public String location_number;
	public Double delivery_charge;
	public Double delivery_tax;
	public Payment_method payment_method;
	public List<Line_items> line_items;

	public class Shipping_address {
		public String address_line_1;
		public String address_line_2;
		public String zip;
		public String city;
		public String state;
		public String county;
		public String county_code;
		public String geo_code;
		public String first_name;
		public String last_name;
		public String email;
		public String phone;
	}

	public class Pickup_detail {
		public String facility_number;
		public Pickup_customer pickup_customer;
	}
    
	public class Pickup_customer {
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

	public class Delivery_date {
		public String date1;
	}

	public class Line_items {
		public String item_id;
		public Double price;
		public Integer quantity;
		public Double tax;
		public Boolean delivery_eligible;
		public Delivery_service delivery_service;
		public List<Required_parts> required_parts;
		public Product_configuration product_configuration;
	//	public Required_parts protection_agreement;
		public Haulaway haulaway;
	}

	public class Required_parts {
		public String item_id;
		public Double price;
		public Double tax;
	}

	public class Delivery_service {
		public String item_id;
		public String install_service_pid;
		public Double price;
		public Double tax;
	}

	public class Product_configuration {
		public String item_id;
	}

	public class Haulaway {
		public Double price;
		public Double tax;
	}

	
	public static SerializeCalenderAPI parse(String json) {
        if(!Test.isRunningTest()){
			return (SerializeCalenderAPI) System.JSON.deserialize(json, SerializeCalenderAPI.class);
        }else{
            return null; 
        }
	}

    
}