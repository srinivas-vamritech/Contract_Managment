/*
    @apexDoc The DummyWelcomeController class manages the welcome message in Salesforce.
*/
public with sharing class DummyWelcomeController {
    /*
    @apexDoc The welcomeMessage property stores the welcome message to be displayed in Salesforce.
    */
    public String welcomeMessage { get; set; }
    /*
    @apexDoc The default constructor initializes the welcomeMessage with a default value.
    */
    public DummyWelcomeController() {
        welcomeMessage = 'Welcome to Salesforce!';
    }
}