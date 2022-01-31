public class ContactOwnerBirthdayRemindBatch implements Database.Batchable<sObject> {
    
    public Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator('SELECT Id, Name, Birthdate, Owner.Email FROM Contact WHERE Is_Three_Months_Before_Birthday__c = true');
    }

    public void execute(Database.BatchableContext bc, List<Contact> records){
        sendBirthdayEmail(records);
    }

    public void sendBirthdayEmail(List<Contact> contBirth){

        Map<String, List<Contact>> emailContactsMap = new Map<String, List<Contact>>();

        for (Contact cont : contBirth){
            if (!emailContactsMap.containsKey(cont.Owner.Email)){
                emailContactsMap.put(cont.Owner.Email, new List<Contact>());
            }
            emailContactsMap.get(cont.Owner.Email).add(cont);
        }

        Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage>();
        for (String mail: emailContactsMap.keySet()){
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.toAddresses = new String[]{mail};
            message.subject = 'Contacts Turning 18';
            String bodyMessage = 'Here is a list of contacts turning 18 in 3 month:';
    
            for (Contact cont: emailContactsMap.get(mail)){
                if (cont.Owner.Email == mail){
                    String contUrl = URL.getSalesforceBaseUrl().toExternalForm() + '/' + cont.Id;
                    bodyMessage += '\n' + cont.Name + ' (' + contUrl + ')' + ' - ' + cont.Birthdate;
                }
            }
            message.plainTextBody = bodyMessage;
            messages.add(message);
        }
        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
    }

    public void finish(Database.BatchableContext bc){
        // post-processing operations
    }
}