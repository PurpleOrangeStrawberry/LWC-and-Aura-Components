@isTest
public with sharing class ServiceTriggerHandlerTest {

    @TestSetup
    static void setup(){
        Contact contactOne = new Contact(Lastname='ContactOne');
        Contact contactTwo = new Contact(Lastname='ContactTwo');
        insert contactOne;
        insert contactTwo;

        Service__c serviceOne = new Service__c(Name='ServiceOne', Service_Date__c=Date.newInstance(2022, 1, 1), Service_Contact__c=contactOne.Id);
        Service__c serviceTwo = new Service__c(Name='ServiceTwo', Service_Date__c=Date.newInstance(2022, 4, 9), Service_Contact__c=contactTwo.Id);
        insert serviceOne;
        insert serviceTwo;

        Contact contactBeforeUpdate = new Contact(Lastname='ContactBefore');
        insert contactBeforeUpdate;
        Service__c serviceThree = new Service__c(Name='ServiceThree', Service_Date__c=Date.newInstance(2022, 2, 3), Service_Contact__c=contactBeforeUpdate.Id);
        insert serviceThree;
        
        Contact contactAfterUpdate = new Contact(Lastname='ContactAfter');
        insert contactAfterUpdate;
        
        serviceThree.Service_Contact__c = contactAfterUpdate.Id;
        update serviceThree;
        serviceThree.Service_Date__c = Date.newInstance(2022, 3, 4);
        update serviceThree;
    }

    @isTest 
    static void testInsertLastServiceDate(){
        List<Service__c> services = [SELECT Id, Service_Contact__c, Service_Date__c FROM Service__c];
        Set<Id> serviceIds = new Set<Id>();
        for (Service__c srv: services){
            serviceIds.add(srv.Service_Contact__c);
        }

        Map<Id, Contact> contMap = new Map<Id, Contact>([SELECT Id, Last_Service_Date__c FROM Contact WHERE Id IN :serviceIds]);
        for (Service__c srv: services){
            Contact contObj = contMap.get(srv.Service_Contact__c);
            System.assertEquals(contObj.Last_Service_Date__c, srv.Service_Date__c, 'Contact Last Service date has to be equal Service Date');
        }  
    }
    
    @isTest 
    static void testUpdateLastServiceDate(){

        List<Service__c> services = [SELECT Id, Service_Contact__c, Service_Date__c FROM Service__c];
        Set<Id> serviceIds = new Set<Id>();
        for (Service__c srv: services){
            serviceIds.add(srv.Service_Contact__c);
        }

        Map<Id, Contact> contMap = new Map<Id, Contact>([SELECT Id, Last_Service_Date__c FROM Contact WHERE Id IN :serviceIds]);
        for (Service__c srv: services){
            Contact contObj = contMap.get(srv.Service_Contact__c);
            System.assertEquals(contObj.Last_Service_Date__c, srv.Service_Date__c, 'Contact Last Service date has to be equal Service Date');
        }
    }
}
