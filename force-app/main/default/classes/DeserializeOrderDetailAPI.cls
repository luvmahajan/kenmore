public class DeserializeOrderDetailAPI {
    
	public String order_reference_number;
	public String account_number;
	public String order_no;
	public String status;
	public PaymentMethod payment_method;
	public Boolean common_carrier;
    
	public class PaymentMethod {
		public String display_name;
		public String uid;
		public String expiry;
		public String type1;
		public String authorized_purchaser;
    }


	public static DeserializeOrderDetailAPI parse(String json) {
		return (DeserializeOrderDetailAPI) System.JSON.deserialize(json, DeserializeOrderDetailAPI.class);
	}
    

}