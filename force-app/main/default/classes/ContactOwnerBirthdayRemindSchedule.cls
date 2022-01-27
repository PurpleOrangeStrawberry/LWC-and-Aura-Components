global with sharing class ContactOwnerBirthdayRemindSchedule implements Schedulable {

    global void execute(SchedulableContext ctx) {
        if (ctx != null){
            List<Contact> contBirth = [SELECT Id, Name, Birthdate, Owner.Email FROM Contact WHERE Is_Three_Months_Before_Birthday__c = true];

            sendBirthdayEmail(contBirth);
        }
    }   

    public void sendBirthdayEmail(List<Contact> contBirth){

        Set<String> ownersEmailsSet = new Set<String>();
        for (Contact cont : contBirth){
            ownersEmailsSet.add(cont.Owner.Email);
        }

        for (String mail: ownersEmailsSet){
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.toAddresses = new String[]{mail};
            message.subject = 'Contacts Turning 18';
            String bodyMessage = 'Here is a list of contacts turning 18 in 3 month:';
    
            for (Contact cont: contBirth){
                if (cont.Owner.Email == mail){
                    String contUrl = URL.getSalesforceBaseUrl().toExternalForm() + '/' + cont.Id;
                    bodyMessage += '\n' + cont.Name + ' (' + contUrl + ')' + ' - ' + cont.Birthdate;
                }
            }
            message.plainTextBody = bodyMessage;
            Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        }
    }
}