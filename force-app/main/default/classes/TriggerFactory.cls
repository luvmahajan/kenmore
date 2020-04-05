public with sharing class TriggerFactory {

	/**
     * Throws a TriggerException if no handler has been coded.
     */
    public static void createHandler(Schema.sObjectType soType)
    {
        // Get a handler appropriate to the object being processed
        ITrigger handler = getHandler(soType);
         
        // Make sure we have a handler registered.
        if (handler == null)
        {
            throw new TriggerException('No Trigger Handler registered for Object Type: ' + soType);
        }         
        
        execute(handler);
    }
     
    private static void execute(ITrigger handler)
    {        
        if (Trigger.isBefore)
        {            
            handler.bulkBefore();

            if (Trigger.isDelete)
            {
                for (SObject so : Trigger.old)
                {
                    handler.beforeDelete(so);
                }
            }
            else if (Trigger.isInsert)
            {
                for (SObject so : Trigger.new)
                {
                    handler.beforeInsert(so);
                }
            }
            else if (Trigger.isUpdate)
            {
                for (SObject so : Trigger.old)
                {
                    handler.beforeUpdate(so, Trigger.newMap.get(so.Id));
                }
            }
        }
        else
        {
            handler.bulkAfter();
             
            if (Trigger.isDelete)
            {
                for (SObject so : Trigger.old)
                {
                    handler.afterDelete(so);
                }
            }
            else if (Trigger.isInsert)
            {
                for (SObject so : Trigger.new)
                {
                    handler.afterInsert(so);
              	}
            }
            else if (Trigger.isUpdate)
            {
                for (SObject so : Trigger.old)
                {
                    handler.afterUpdate(so, Trigger.newMap.get(so.Id));
                }
            }
        }
         
        // Perform any post processing
        handler.andFinally();
    }

    private static ITrigger getHandler(Schema.sObjectType soType)
    {
    	String objectName = soType.getDescribe().getName();
    	String handlerName = null;

    	if(objectName.toLowerCase().endsWith('__c')){
    		Integer index = objectName.toLowerCase().indexOf('__c');
    		handlerName = objectName.substring(0, index) + 'Handler';
    	}
    	else{
    		handlerName = objectName + 'Handler';
    	}

    	handlerName = handlerName.remove('_');
    	Type objectType = Type.forName(handlerName);
      
        return (objectType == null) ? null : (ITrigger)objectType.newInstance();
    }
}