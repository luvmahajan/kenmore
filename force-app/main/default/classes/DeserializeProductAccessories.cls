public class DeserializeProductAccessories {

	public Product product;

	public class Product {
		public Services services;
	}

	public class Services {
		public Required_parts required_parts;
		public Delivery_options delivery_options;
		public Configuration_options configuration_options;
		public List<Installation_services> installation_services;
	}

	public class Required_parts {
		public List<Select_Parts> select_all;
		public List<Select_Parts> select_one;
	}

	public class Select_Parts {
		public String part_number;
		public String product_name;
		public Price price;
		public String description;
		public String image_url;
	}

	public class Price {
		public String sellPrice;
		public String fixedPrice;
		public String regularPrice;
	}

	public class Delivery_options {
		public List<Select_Delivery> select_all;
		public List<Select_Delivery> select_one;
		public List<Optional> optional;
	}
    
	public class Select_Delivery {
		public String option_code;
		public String part_number;
		public String description;
		public String price;
		public String hookup_tasks;
	}

	public class Optional {
		public String option_code;
		public String part_number;
		public String description;
		public String base_price;
		public Double addon_price;
	}
    
	public class Configuration_options {
		public List<Select_Configuration> select_one;        
	}

	public class Select_Configuration {
		public String option_code;
		public String description;
	}

	public class Installation_services {
		public String part_number;
		public String division;
		public String line;
		public String sub_line;
		public String short_desc;
		public String description;
		public String price;
	}


		
	public static DeserializeProductAccessories parse(String json) {
   //     if(!Test.isRunningTest()){
			return (DeserializeProductAccessories) System.JSON.deserialize(json, DeserializeProductAccessories.class);
  //      }else{
  //          return null; 
  //      }
	}

}