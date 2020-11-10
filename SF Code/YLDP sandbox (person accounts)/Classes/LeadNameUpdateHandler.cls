public with sharing class LeadNameUpdateHandler {
    public static void updateLead(Lead lead) {
        if(lead.Mother_s_Firstname__c != null) {
            lead.FirstName = lead.Mother_s_Firstname__c;
            lead.LastName = lead.Mother_s_Lastname__c;
            lead.Email = lead.Mother_s_Email__c;
        } else if (lead.Father_s_Firstname__c != null) {
            lead.FirstName = lead.Father_s_Firstname__c;
            lead.LastName = lead.Father_s_Lastname__c;
            lead.Email = lead.Father_s_Email__c;
        } else if (lead.Guardian_1_Firstname__c != null) {
            lead.FirstName = lead.Guardian_1_Firstname__c;
            lead.LastName = lead.Guardian_1_Lastname__c;
            lead.Email = lead.Guardian_1_Email__c;
        } else if (lead.Guardian_2_Firstname__c != null) {
            lead.FirstName = lead.Guardian_2_Firstname__c;
            lead.LastName = lead.Guardian_2_Lastname__c;
            lead.Email = lead.Guardian_2_Email__c;
        }
    }
}
