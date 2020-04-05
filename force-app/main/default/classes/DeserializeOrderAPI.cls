public class DeserializeOrderAPI {

	public String order_reference_number;
    public Integer order_id;

	public static DeserializeOrderAPI parse(String json) {
		return (DeserializeOrderAPI) System.JSON.deserialize(json, DeserializeOrderAPI.class);
	}
}