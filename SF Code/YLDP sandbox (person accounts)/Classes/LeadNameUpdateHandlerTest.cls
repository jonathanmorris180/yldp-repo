@isTest
public with sharing class LeadNameUpdateHandlerTest {
    @isTest
    static void testLeadInsert() {

        // Test mother
        Lead l1 = new Lead();
        l1.FirstName = 'Web';
        l1.LastName = 'LastNameTest1';
        l1.LeadSource = 'YLDP Site - Need More Information';
        l1.Mother_s_Firstname__c = 'Rita';
        l1.Mother_s_Lastname__c = 'Skeeter';
        insert l1;

        // Test father
        Lead l2 = new Lead();
        l2.FirstName = 'Web';
        l2.LastName = 'LastNameTest2';
        l2.LeadSource = 'YLDP Site - Need More Information';
        l2.Mother_s_Firstname__c = 'Joe';
        l2.Mother_s_Lastname__c = 'Bloggs';
        insert l2;

        // Test guardian 1
        Lead l3 = new Lead();
        l3.FirstName = 'Web';
        l3.LastName = 'LastNameTest3';
        l3.LeadSource = 'YLDP Site - Need More Information';
        l3.Mother_s_Firstname__c = 'Mary';
        l3.Mother_s_Lastname__c = 'Jane';
        insert l3;

        // Test guardian 2
        Lead l4 = new Lead();
        l4.FirstName = 'Web';
        l4.LastName = 'LastNameTest4';
        l4.LeadSource = 'YLDP Site - Need More Information';
        l4.Mother_s_Firstname__c = 'Jane';
        l4.Mother_s_Lastname__c = 'Smith';
        insert l4;

        // Assert name change
        Integer i = [SELECT Count() FROM Lead WHERE Name IN ('Rita Skeeter', 'Joe Bloggs', 'Mary Jane', 'Jane Smith')];
        System.assertEquals(4, i);
    }
}
