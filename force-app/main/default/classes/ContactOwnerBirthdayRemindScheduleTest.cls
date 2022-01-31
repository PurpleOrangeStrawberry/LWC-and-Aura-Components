@isTest
public with sharing class ContactOwnerBirthdayRemindScheduleTest{

    @TestSetup
    static void setup(){
        List<Contact> contactList = new List<Contact>();

        Date testdate = System.today().addMonths(3).addYears(-18);  
        System.debug(testdate);

        Contact contactOne = new Contact(Lastname = 'TestContOne', Birthdate = testdate);
        Contact contactTwo = new Contact(Lastname = 'TestContTwo', Birthdate = testdate);
        contactList.add(contactOne);
        contactList.add(contactTwo);
        insert contactList;
    }
    
    @isTest
    static void testScheduleReminder() {
        Test.startTest();
        ContactOwnerBirthdayRemindSchedule reminder = new ContactOwnerBirthdayRemindSchedule();
        String scheduleExpression = '0 0 0 * * ?';
        String jobId = System.schedule('Three month to birthday remind', scheduleExpression, reminder);

        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        
        System.assertEquals(scheduleExpression, ct.CronExpression, 'Verify the expressions are the same');

        System.assertEquals(0, ct.TimesTriggered, 'Verify the job has not run');

        System.assertEquals(String.valueOfGmt(System.today().addDays(1)), String.valueOf(ct.NextFireTime), 'Verify the next time the job will run');

        Test.stopTest();
    }
}