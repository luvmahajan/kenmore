({
    callCreateContractAction : function(component, event, helper) {        
        var actionAPI = component.find("quickActionAPI");
        var fields = {Id: {value: component.get("v.recordId")}};
        var args = {actionName: "SBQQ__Quote__c.CreateContract", entityName: "SBQQ__Quote__c", targetFields: fields};
        actionAPI.setActionFieldValues(args).then(function(result) {
            actionAPI.invokeAction(args);
            console.log('Create Contract action called');
        }).catch(function(e) {
            if(e.errors) {
                console.log(e.errors);
            }
        });
    }})