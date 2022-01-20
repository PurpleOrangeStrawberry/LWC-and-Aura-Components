public without sharing class ContactTriggerHandler extends TriggerHandler{

    //Overriding events
    public override void beforeUpdate(){
        setCurrentProgramName(trigger.new, (Map<Id, Contact>)Trigger.oldMap);
    }

    public override void beforeInsert(){
        setCurrentProgramName(trigger.new, (Map<Id, Contact>)Trigger.oldMap);
    }

    //Main funcs
    public static void setCurrentProgramName(List<Contact> contactList, Map<Id, Contact> contactOld){    
        Set<Id> prIds = new Set<Id>();
        for (Contact cont : contactList){
            if (Trigger.old == null || cont.Current_Program__c != contactOld.get(cont.Id).Current_Program__c){
                prIds.add(cont.Current_Program__c);    
            }
        }

        if(prIds != null){
            Map<Id, Program__c> programs = new Map<Id, Program__c>([SELECT Id, Name FROM Program__c WHERE Id IN :prIds]);
            for (Contact conts : contactList){
                conts.Current_Program_Name__c = programs.get(conts.Current_Program__c).Name;
            } 
        }   
    }
}
