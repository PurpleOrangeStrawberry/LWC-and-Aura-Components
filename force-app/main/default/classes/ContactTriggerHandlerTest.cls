@isTest
public with sharing class ContactTriggerHandlerTest {

    @TestSetup
    static void setup(){
        List<Program__c> programList = new List<Program__c>();
        Program__c programOne = new Program__c(Name = 'TestProgramOne');
        Program__c programTwo = new Program__c(Name = 'TestProgramTwo');
        Program__c programUpdate = new Program__c(Name = 'UpdateProgram');
        programList.add(programOne);
        programList.add(programTwo);
        programList.add(programUpdate);
        insert programList;

        //Test insert
        List<Contact> contactList = new List<Contact>();
        Contact contOne = new Contact(Lastname='TestContactOne', Current_Program__c = programOne.Id);
        Contact contTwo = new Contact(Lastname='TestContactTwo', Current_Program__c = programTwo.Id);
        contactList.add(contOne);
        contactList.add(contTwo);
        insert contactList;

        //Test update
        contOne.Current_Program__c = programUpdate.Id;
        update contactList;
    }

    @isTest 
    static void testInsertCurrentProgramName(){
        List<Contact> contactList = [SELECT Id, Current_Program__c, Current_Program_Name__c FROM Contact];
        Set<Id> prIds = new Set<Id>();
        for (Contact cn : contactList){
            prIds.add(cn.Current_Program__c);     
        }
        
        Map<Id, Program__c> programs = new Map<Id, Program__c>([SELECT Id, Name FROM Program__c WHERE Id IN :prIds]);
        for (Contact conts : contactList){
            System.assertEquals(conts.Current_Program_Name__c, programs.get(conts.Current_Program__c).Name, 'Current_Program_Name have to be equal the name of Current_Program');
        } 
    }
    
    @isTest 
    static void testUpdateCurrentProgramName(){
        List<Contact> contactList = [SELECT Id, Current_Program__c, Current_Program_Name__c FROM Contact];
        Set<Id> prIds = new Set<Id>();
        for (Contact cn : contactList){
            prIds.add(cn.Current_Program__c);  
        }
        
        Map<Id, Program__c> programs = new Map<Id, Program__c>([SELECT Id, Name FROM Program__c WHERE Id IN :prIds]);
        for (Contact conts : contactList){
            System.assertEquals(conts.Current_Program_Name__c, programs.get(conts.Current_Program__c).Name, 'Current_Program_Name have to be equal the name of Current_Program');
        } 
    }
}
