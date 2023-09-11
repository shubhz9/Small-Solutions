import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import extCallout from '@salesforce/apex/TestExternalCallout.getContactsFromANIMALApi';


export default class TestExtCallout extends LightningElement {
    @track apiResponse;

    onButtonClick(){
        extCallout({})
        .then( result => {
            this.apiResponse = result;
        })
        .catch( error => {
            const eve = new ShowToastEvent({ title : 'ERROR', message: 'Error Occured' });
        })
    }
}