trigger LeadTrigger on Lead (before insert) {
    if(Trigger.isBefore && Trigger.isInsert) {
        for(Lead l : Trigger.New) {
            if(l.LeadSource == 'YLDP Site - Need More Information' && l.FirstName == 'Web') {
                LeadNameUpdateHandler.updateLead(l);
            }
        }
    }
}