public interface ITrigger {

	void bulkBefore();

	void bulkAfter();

	void beforeInsert(Sobject obj);

	void beforeUpdate(Sobject oldObj, Sobject newObj);

	void beforeDelete(Sobject obj);

	void afterInsert(Sobject obj);

	void afterUpdate(Sobject oldObj, Sobject newObj);

	void afterDelete(Sobject obj);

	void andFinally();
}