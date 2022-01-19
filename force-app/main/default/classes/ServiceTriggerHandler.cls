public without sharing class ServiceTriggerHandler extends TriggerHandler{

    //Overriding events
    public override void beforeUpdate(){
        List<Service__c> services = trigger.new;
        Map<Id, Service__c> servicesOld = (Map<Id, Service__c>)Trigger.oldMap;

        for (Service__c srv: services){
            if(srv.Service_Contact__c != null && 
            (srv.Service_Contact__c != servicesOld.get(srv.Id).Service_Contact__c ||
             srv.Service_Date__c != servicesOld.get(srv.Id).Service_Date__c)){
                setLastServiceDate();
            }
        }
    }

    public override void beforeInsert(){
        setLastServiceDate();
    }


    //Main funcs
    public static void setLastServiceDate(){
        List<Service__c> services = trigger.new;
        Set<Id> serviceContactIds = new Set<Id>();
        for (Service__c srv: services){
            serviceContactIds.add(srv.Service_Contact__c);
        }

        Map<Id, Contact> contMap = new Map<Id, Contact>([SELECT Id, Last_Service_Date__c FROM Contact WHERE Id IN :serviceContactIds]);
        List<Contact> contList = new List<Contact>();
        for (Service__c srv: services){
            Contact contObj = contMap.get(srv.Service_Contact__c);
            if ((contObj.Last_Service_Date__c < srv.Service_Date__c) || contObj.Last_Service_Date__c == null){
                contObj.Last_Service_Date__c = srv.Service_Date__c;
                contList.add(contObj);
            }
        }  
        update contList;
    }
}
