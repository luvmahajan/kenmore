public class DeserializePaymentOptionsAPI {

//	public PaymentOptionsResponse paymentOptionsResponse;
    
//	public class PaymentOptionsResponse {
		public List<CreditCards> credit_cards;
//	}
    
	public class CreditCards {
		public String display_name;
		public String uid;
		public String expiry;
		public boolean default1;
	}

	public static DeserializePaymentOptionsAPI parse(String json) {
			return (DeserializePaymentOptionsAPI) System.JSON.deserialize(json, DeserializePaymentOptionsAPI.class);
	}
        
    
}