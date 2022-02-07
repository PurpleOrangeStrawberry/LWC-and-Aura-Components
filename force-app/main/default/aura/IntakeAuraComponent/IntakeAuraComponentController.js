({
    handleIntackeChange: function(component, event, helper) {
        
        console.log(JSON.parse(JSON.stringify(component.get('v.intakeId'))));
         
    },

    doInit: function(component, event, helper) {
        console.log(component.get("v.apiNames"));
        let fieldsIntake = component.get("v.apiNames");
        let array = [];
        array = fieldsIntake.split(';');
        component.set('v.apiSplitedNames', array);
    }
})
