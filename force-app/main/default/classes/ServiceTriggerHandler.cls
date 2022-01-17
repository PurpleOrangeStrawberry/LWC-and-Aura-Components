public without sharing class ServiceTriggerHandler extends TriggerHandler{

    //Overriding events
    public override void beforeUpdate(){
        updateLastServiceDate(trigger.new);
    }

    public override void beforeInsert(){
        setLastServiceDate(trigger.new);
    }


    //Main funcs
    public static void setLastServiceDate(List<Service__c> services){
        Set<Id> serviceIds = new Set<Id>();
        for (Service__c srv: services){
            serviceIds.add(srv.Service_Contact__c);
        }

        Map<Id, Contact> contMap = new Map<Id, Contact>([SELECT Id, Last_Service_Date__c FROM Contact WHERE Id IN :serviceIds]);
        List<Contact> contList = new List<Contact>();
        for (Service__c srv: services){
            Contact contObj = contMap.get(srv.Service_Contact__c);
            contObj.Last_Service_Date__c = srv.Service_Date__c;
            contList.add(contObj);
        }  
        update contList;
    }

    public static void updateLastServiceDate(List<Service__c> services){
        Map<Id, Service__c> servicesOld = (Map<Id, Service__c>)Trigger.oldMap;

        for (Service__c srv: services){
            if(srv.Service_Contact__c != null && 
            (servicesOld == null || 
            srv.Service_Contact__c != servicesOld.get(srv.Id).Service_Contact__c ||
            srv.Service_Date__c != servicesOld.get(srv.Id).Service_Date__c)){
                setLastServiceDate(trigger.new);
            }
        }
    }
}
