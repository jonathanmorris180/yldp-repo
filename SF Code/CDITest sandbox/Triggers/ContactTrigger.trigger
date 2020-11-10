trigger ContactTrigger on Contact (after update) {

    // After update
    if(Trigger.isAfter && Trigger.isUpdate) {
        Set<String> ids = new Set<String>();
        List<String> names = new List<String>();
        for(Contact c : Trigger.New) {
            ids.add(c.OwnerId);
            names.add(c.FirstName);
        }
        if(ids.size() == 1 && ids.contains('0053C000002q37DQAQ') && names[0] != null) {
            ContactToLeadHandler.convertContacts(Trigger.New);
        }
    }
}