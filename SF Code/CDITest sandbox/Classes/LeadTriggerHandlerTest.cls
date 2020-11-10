@isTest
public with sharing class LeadTriggerHandlerTest {
    @isTest
    static void runTest() {
        Lead l = new Lead(FirstName='spam', LastName='spam');
        try {
            insert l;  
        } catch (Exception e) {
            Boolean results = e.getMessage().contains('This seems like a spam lead!');
            System.assertEquals(true, results);
        }
    }
}