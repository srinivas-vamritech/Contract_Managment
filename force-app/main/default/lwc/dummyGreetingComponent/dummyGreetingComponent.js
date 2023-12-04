import { LightningElement,track } from 'lwc';

export default class DummyGreetingComponent extends LightningElement {
    @track greeting = 'Hello, World!';
}