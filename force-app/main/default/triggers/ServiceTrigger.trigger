trigger ServiceTrigger on Service__c (before insert, before update) {
    new ServiceTriggerHandler().run();
}