@isTest
public with sharing class ContactToLeadHandlerTest {
    @TestSetup
    static void makeData() {
        // List of contacts to insert and update
        List<Contact> testContacts = new List<Contact>();
        for(Integer i=0; i<10; i++) {
            Contact c = new Contact(FirstName='Test', LastName='Contact' + i, OwnerId='0053C000002q37DQAQ'); // Don't add an email here as it causes a record update
            testContacts.add(c);
        }
        insert testContacts;
    }
    
    @isTest
    static void testContactCreation() {
        List<Contact> contList = [SELECT Id, Name, FirstName FROM Contact WHERE Name LIKE 'Test Contact%'];
        System.debug('contList: ' + contList);
        for(Contact c : contList) {
            c.FirstName = 'UpdatedTest';
        }
        Test.startTest();
        update contList;
        Test.stopTest();

        // Assert results
        Integer i = [SELECT Count() FROM Lead WHERE Name LIKE 'UpdatedTest Contact%'];
        System.assertEquals(10, i);
    }

    @isTest
    static void createDupe() {
        Contact c = new Contact(FirstName='George', LastName='Smith', OwnerId='0053C000002q37DQAQ', Email='dupeemail@gmail.com');
        Contact c2 = new Contact(FirstName='George', LastName='Smith', OwnerId='0053C000002q37DQAQ', Email='dupeemail@gmail.com');
        insert c;

        // Try updating with duplicate info
        Integer i = [SELECT Count() FROM Lead WHERE Email='dupeemail@gmail.com'];
        System.assertEquals(1, i);
    }
}
