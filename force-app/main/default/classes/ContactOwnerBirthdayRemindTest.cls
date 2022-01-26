@isTest
public with sharing class ContactOwnerBirthdayRemindTest{

    @TestSetup
    static void setup(){
        List<Contact> contactList = new List<Contact>();
        Contact contactOne = new Contact(Lastname = 'TestContOne', Birthdate = Date.newInstance(2022, 1, 1));
        Contact contactTwo = new Contact(Lastname = 'TestContTwo', Birthdate = Date.newInstance(2022, 1, 2));
        contactList.add(contactOne);
        contactList.add(contactTwo);
        insert contactList;
    }

    @isTest
    static void testScheduleReminder() {
        Test.startTest();
        Datetime eachDayRepeat = System.now().addDays(1);
        String scheduleExpression = '' + eachDayRepeat.second() + 
                                    ' ' + eachDayRepeat.minute() + 
                                    ' ' + eachDayRepeat.hour() + 
                                    ' ' + eachDayRepeat.day() + 
                                    ' ' + eachDayRepeat.month() + 
                                    ' ? ' + eachDayRepeat.year();


        String jobId =  System.schedule('test', scheduleExpression, new ContactOwnerBirthdayRemind());

        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];

        
        System.assertEquals(scheduleExpression, ct.CronExpression, 'Verify the expressions are the same');

        System.assertEquals(0, ct.TimesTriggered, 'Verify the job has not run');

        System.assertEquals(String.valueOfGmt(eachDayRepeat), String.valueOf(ct.NextFireTime), 'Verify the next time the job will run');

        Test.stopTest();
    }
       

}
