public class DeserializeAdjustmentOrderAPI {

	public String order_reference_number;
    public String order_id;

	public static DeserializeAdjustmentOrderAPI parse(String json) {
		return (DeserializeAdjustmentOrderAPI) System.JSON.deserialize(json, DeserializeAdjustmentOrderAPI.class);
	}
}