trigger LeadTrigger on Lead  (before insert) {
    if(Trigger.isBefore && Trigger.isInsert) {
        for(Lead l : Trigger.New) {
            if(LeadTriggerHandler.checkForSpamLeads(l)) {
                l.addError('This seems like a spam lead!');
            }
        }
    }
}