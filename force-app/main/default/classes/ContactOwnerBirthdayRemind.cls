global with sharing class ContactOwnerBirthdayRemind implements Schedulable {

    private final String JOB_NAME = 'Three month to birthday remind';

    global void execute(SchedulableContext ctx) {
        if (ctx != null){
            Date birthdayCheck = Date.today().addMonths(3);

            List<Contact> resultBirthday = new List<Contact>();
            List<Contact> contBirth = [SELECT Id, Name, Birthdate FROM Contact WHERE Birthdate != null];
            if (contBirth != null && contBirth.size() > 0){
                for (Contact cont: contBirth){
                    if (cont.BirthDate.monthsBetween(birthdayCheck) == 3){
                        resultBirthday.add(cont);
                    }
                }
            }
            if (resultBirthday != null && resultBirthday.size() > 0){
                sendBirthdayEmail(resultBirthday);
            }   
            findAndAbortJob(ctx);
        }
    }   

    private void findAndAbortJob(SchedulableContext cont){
		if (cont == null){
			return;
		}
		List<CronJobDetail> cronDetail = [SELECT Id FROM CronJobDetail WHERE Name= :JOB_NAME LIMIT 1];
		if (cronDetail.isEmpty()){
			return;
		}
		List<CronTrigger> cronTriggers = [SELECT Id FROM CronTrigger WHERE CronJobDetailId = :cronDetail[0].Id];
		if(cronTriggers.isEmpty()){
			return;
		}
        
        //Aborting the job named that stands fot birthday remind
        //and reschedules it
		try{
			System.abortJob(cronTriggers[0].Id);
			rescheduleBirthdayRemind();
		}
		catch (Exception e){
			System.debug(e.getMessage());
		}
	}
    
    public void rescheduleBirthdayRemind(){
        Datetime eachDayRepeat = System.now().addDays(1);
        String scheduleExpression = '' + eachDayRepeat.second() + 
                                    ' ' + eachDayRepeat.minute() + 
                                    ' ' + eachDayRepeat.hour() + 
                                    ' ' + eachDayRepeat.day() + 
                                    ' ' + eachDayRepeat.month() + 
                                    ' ? ' + eachDayRepeat.year();

        System.schedule(JOB_NAME, scheduleExpression, new ContactOwnerBirthdayRemind());
    }

    public void sendBirthdayEmail(List<Contact> resultBirthday){
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.toAddresses = new String[] {'jeykyllua21@gmail.com'};
        message.subject = 'Contacts Turning 18';
        String bodyMessage = 'Here is a list of contacts turning 18 in 3 month:';

        for (Contact cont: resultBirthday){
            String contUrl = URL.getSalesforceBaseUrl().toExternalForm() + '/' + cont.id;
            bodyMessage += '\n' + cont.Name + ' (' + contUrl + ')' + ' - ' + cont.Birthdate;
        }

        message.plainTextBody = bodyMessage;
        Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);

        if (results[0].success) {
            System.debug('The email was sent successfully.');
        } else {
            System.debug('The email failed to send' + results[0].errors[0].message);
        }
    }
}