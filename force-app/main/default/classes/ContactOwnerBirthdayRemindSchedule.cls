global with sharing class ContactOwnerBirthdayRemindSchedule implements Schedulable {

    global void execute(SchedulableContext ctx) {
        if (ctx != null){
            ContactOwnerBirthdayRemindBatch cntbatch = new ContactOwnerBirthdayRemindBatch();
            Id batchId = Database.executeBatch(cntbatch);
        }
    }   
}