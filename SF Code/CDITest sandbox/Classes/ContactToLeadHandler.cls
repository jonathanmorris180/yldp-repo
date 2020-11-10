public with sharing class ContactToLeadHandler {

    public static void convertContacts(List<Contact> lstOfContacts) {

        // Lists
        List<Lead> lstOfLeads = new List<Lead>();
        List<Account> accsToDelete = new List<Account>();

        // Iterate over Contacts
        for(Contact c : lstOfContacts) {
            Lead newLead = new Lead();
            Account accToDelete = new Account();

            // Create a Lead
            newLead.FirstName = c.FirstName;
            newLead.LastName = c.LastName;
            newLead.Email = c.Email;
            newLead.OwnerId = c.OwnerId;
            newLead.Company = 'N/A';
            newLead.LeadSource = 'YLDP Site - User Registration';
            lstOfLeads.add(newLead);

            // Add to list for deletion
            accToDelete.Id = c.AccountId;
            accsToDelete.add(accToDelete);
        }

        if(checkDupes(lstOfContacts) == false) {
            insert lstOfLeads;
        }
        delete accsToDelete;
    }

    public static Boolean checkDupes(List<Contact> conts) {
        Boolean isDupe = false;
        List<String> emails = new List<String>();
        for(Contact c : conts) {
            emails.add(c.Email);
        }
        List<Lead> duplicates = [SELECT Id, Email FROM Lead WHERE Email IN :emails];
        if(!duplicates.isEmpty()) {
            isDupe = true;
        }
        return isDupe;
    }
}
