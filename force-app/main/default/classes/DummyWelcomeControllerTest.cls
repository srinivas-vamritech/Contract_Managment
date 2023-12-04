@isTest
public with sharing class DummyWelcomeControllerTest {

    @isTest
    static void testWelcomeMessage() {
        // Create an instance of the DummyWelcomeController
        DummyWelcomeController controller = new DummyWelcomeController();
        
        // Verify that the welcomeMessage property is set correctly
        System.assertEquals('Welcome to Salesforce!', controller.welcomeMessage, 'Welcome message is incorrect');
    }
}