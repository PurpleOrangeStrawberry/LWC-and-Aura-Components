import RecipientId from '@salesforce/schema/WorkBadge.RecipientId';
import { LightningElement, api, track } from 'lwc';

export default class IntakeLWComponent extends LightningElement {

    @api nameIntake;
    @api nameCreateIntake;

    @track intakeId;
    @track fieldsIntake;
    @track isCreateClicked;


    handleChange(event) {
        try{
            this.intakeId = event.detail.value[0];
            this.isCreateClicked = false;
            console.log(JSON.parse(JSON.stringify(this.intakeId)));
        }
        catch(e){
            this.intakeId = null;
        }
        
    }

    connectedCallback() {
        console.log(this.nameIntake);
        this.fieldsIntake = this.nameIntake.split(';');
    }
}