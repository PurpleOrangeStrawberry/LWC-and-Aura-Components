public without sharing class ContactTriggerHandler extends TriggerHandler{

    //Overriding events
    public override void beforeInsert(){
        setCurrentProgramName(trigger.new);
    }

    public override void beforeUpdate(){
        updateCurrentProgramName(trigger.new);
    }


    public static void setCurrentProgramName(List<Contact> contactList){    
        Set<Id> prIds = new Set<Id>();
        for (Contact cont : contactList){
            prIds.add(cont.Current_Program__c);     
        }

        Map<Id, Program__c> programs = new Map<Id, Program__c>([SELECT Id, Name FROM Program__c WHERE Id IN :prIds]);
        for (Contact conts : contactList){
            conts.Current_Program_Name__c = programs.get(conts.Current_Program__c).Name;
        }  
    }

    public static void updateCurrentProgramName(List<Contact> contactList){    
        Map<Id, Contact> contactOld = (Map<Id, Contact>)Trigger.oldMap;

        for (Contact cont: contactList){
            if (cont.Current_Program__c != null && 
            (contactOld == null || 
            cont.Current_Program__c != contactOld.get(cont.Id).Current_Program__c)){
                setCurrentProgramName(trigger.new);
            }
        }
    }
}
