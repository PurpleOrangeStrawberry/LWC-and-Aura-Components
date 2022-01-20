public without sharing class ServiceTriggerHandler extends TriggerHandler{

    //Overriding events
    public override void beforeUpdate(){
        setLastServiceDate(trigger.new, (Map<Id, Service__c>)Trigger.oldMap);
    }

    public override void beforeInsert(){
        setLastServiceDate(trigger.new, (Map<Id, Service__c>)Trigger.oldMap);
    }


    //Main funcs
    public static void setLastServiceDate(List<Service__c> services, Map<Id, Service__c> servicesOld){
        Set<Id> serviceContactIds = new Set<Id>();

        for (Service__c srv: services){
            if(Trigger.old == null || 
                (srv.Service_Contact__c != servicesOld.get(srv.Id).Service_Contact__c ||
                srv.Service_Date__c != servicesOld.get(srv.Id).Service_Date__c)){

                serviceContactIds.add(srv.Service_Contact__c);
            }
        }
        
        if(serviceContactIds != null && serviceContactIds.size() > 0){
            Map<Id, Contact> contMap = new Map<Id, Contact>([SELECT Id, Last_Service_Date__c FROM Contact WHERE Id IN :serviceContactIds]);
            List<Contact> contList = new List<Contact>();
            for (Service__c srv: services){
                Contact contObj = contMap.get(srv.Service_Contact__c);

                if(Trigger.old == null || 
                (srv.Service_Contact__c != servicesOld.get(srv.Id).Service_Contact__c ||
                srv.Service_Date__c != servicesOld.get(srv.Id).Service_Date__c)){
                    if ((contObj.Last_Service_Date__c < srv.Service_Date__c) || contObj.Last_Service_Date__c == null){
                        contObj.Last_Service_Date__c = srv.Service_Date__c;
                        contList.add(contObj);
                    }
                }
            }  
            update contList;
        }
        
    }
}
