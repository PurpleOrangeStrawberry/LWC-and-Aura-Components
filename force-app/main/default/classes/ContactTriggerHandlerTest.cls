@isTest
public with sharing class ContactTriggerHandlerTest {

    @TestSetup
    static void setup(){
        Program__c programOne = new Program__c();
        Program__c programTwo = new Program__c();

        programOne.Name = 'TestProgramOne';
        programTwo.Name = 'TestProgramTwo';

        insert programOne;
        insert programTwo;

        Contact contOne = new Contact(Lastname='TestContactOne', Current_Program__c = programOne.Id);
        Contact contTwo = new Contact(Lastname='TestContactTwo', Current_Program__c = programTwo.Id);

        insert contOne;
        insert contTwo;
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
        Program__c programBeforeUpdate = new Program__c();
        Program__c programAfterUpdate = new Program__c();
        programBeforeUpdate.Name = 'TestBeforeUpdateProgram';
        programAfterUpdate.Name = 'TestAfterUpdateProgram';
        insert programBeforeUpdate;
        insert programAfterUpdate;

        Contact contUpdate = new Contact(Lastname='TestContactUpdate', Current_Program__c = programBeforeUpdate.Id);
        insert contUpdate;

        contUpdate.Current_Program__c = programAfterUpdate.Id;
        update contUpdate;


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
