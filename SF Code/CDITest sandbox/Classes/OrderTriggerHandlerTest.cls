@isTest
public with sharing class OrderTriggerHandlerTest {
    @TestSetup
    static void makeData(){
        Lead newLead = new Lead(LastName='Test', Company='Test Company', Email='testemail@gmail.com');
        Order__c newOrder = new Order__c(Customer_Email__c='testemail@gmail.com', Order_Details__c=
            'Title : Mindfulness\n' +
            'Quantity : 2\n' +
            'Total : 0\n' +
            '------------\n' +
            'Title : Leadership and Emotional Intelligence\n' +
            'Quantity : 1\n' +
            'Total : 0'
        );
        Program__c newProg1 = new Program__c(Name='Mindfulness');
        Program__c newProg2 = new Program__c(Name='Leadership and Emotional Intelligence');
        List<Program__c> progs = new List<Program__c>{newProg1, newProg2};
        insert progs;
        insert newLead;
        insert newOrder;
    }

    @isTest
    static void testInsert() {
        List<Account> accounts = [SELECT Id, npe01__One2OneContact__r.Email FROM Account WHERE npe01__One2OneContact__r.Email='testemail@gmail.com'];
        System.assertEquals(1, accounts.size());
        List<Registered_Program__c> regProgs = [SELECT Id, Program__r.Name, Places_Reserved__c FROM Registered_Program__c LIMIT 2];
        System.assertEquals('Mindfulness', regProgs[0].Program__r.Name);
        System.assertEquals(2, regProgs[0].Places_Reserved__c);
    }

    @isTest
    static void testUpdate() {
        Order__c o = [SELECT Id, Customer_Email__c FROM Order__c WHERE Customer_Email__c='testemail@gmail.com'];
        o.Order_Details__c=
            'Title : Mindfulness\n' +
            'Quantity : 4\n' +
            'Total : 0\n' +
            '------------\n' +
            'Title : Leadership and Emotional Intelligence\n' +
            'Quantity : 1\n' +
            'Total : 0';
        update o;

        // Assert new Registered Program records
        List<Account> accounts = [SELECT Id, npe01__One2OneContact__r.Email FROM Account WHERE npe01__One2OneContact__r.Email='testemail@gmail.com'];
        System.assertEquals(1, accounts.size());
        List<Registered_Program__c> regProgs = [SELECT Id, Program__r.Name, Places_Reserved__c FROM Registered_Program__c LIMIT 2];
        System.assertEquals('Mindfulness', regProgs[0].Program__r.Name);
        System.assertEquals(4, regProgs[0].Places_Reserved__c);
    }
}
