@isTest
public with sharing class ServiceTriggerHandlerTest {

    @TestSetup
    static void setup(){
        List<Contact> contactList = new List<Contact>();
        Contact contactOne = new Contact(Lastname='ContactOne');
        Contact contactTwo = new Contact(Lastname='ContactTwo');
        contactList.add(contactOne);
        contactList.add(contactTwo);
        insert contactList;

        //Test insert
        List<Service__c> serviceList = new List<Service__c>();
        Service__c serviceOne = new Service__c(Name='ServiceOne', Service_Date__c=Date.newInstance(2022, 1, 1), Service_Contact__c=contactOne.Id);
        Service__c serviceTwo = new Service__c(Name='ServiceTwo', Service_Date__c=Date.newInstance(2022, 4, 9), Service_Contact__c=contactTwo.Id);
        serviceList.add(serviceOne);
        serviceList.add(serviceTwo);
        insert serviceList;

        //Test update
        serviceOne.Service_Date__c = Date.newInstance(2022, 2, 2);
        update serviceList;
    }

    @isTest 
    static void testInsertLastServiceDate(){
        List<Service__c> services = [SELECT Id, Service_Contact__c, Service_Date__c FROM Service__c];
        Set<Id> serviceContactIds = new Set<Id>();
        for (Service__c srv: services){
            serviceContactIds.add(srv.Service_Contact__c);
        }

        Map<Id, Contact> contMap = new Map<Id, Contact>([SELECT Id, Last_Service_Date__c FROM Contact WHERE Id IN :serviceContactIds]);
        for (Service__c srv: services){
            Contact contObj = contMap.get(srv.Service_Contact__c);
            System.assertEquals(contObj.Last_Service_Date__c, srv.Service_Date__c, 'Contact Last Service date has to be equal Service Date');
        }  
    }
    
    @isTest 
    static void testUpdateLastServiceDate(){

        List<Service__c> services = [SELECT Id, Service_Contact__c, Service_Date__c FROM Service__c];
        Set<Id> serviceContactIds = new Set<Id>();
        for (Service__c srv: services){
            serviceContactIds.add(srv.Service_Contact__c);
        }

        Map<Id, Contact> contMap = new Map<Id, Contact>([SELECT Id, Last_Service_Date__c FROM Contact WHERE Id IN :serviceContactIds]);
        for (Service__c srv: services){
            Contact contObj = contMap.get(srv.Service_Contact__c);
            System.assertEquals(contObj.Last_Service_Date__c, srv.Service_Date__c, 'Contact Last Service date has to be equal Service Date');
        }
    }
}
