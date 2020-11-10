public with sharing class LeadTriggerHandler {
    public static Boolean checkForSpamLeads(Lead l) {
        if(l.FirstName == l.LastName) {
            return true;
        }
        else return false;
    }
}
