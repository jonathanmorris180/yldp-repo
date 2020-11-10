trigger OrderTrigger on Order__c (after insert, after update) {
    if(Trigger.isAfter && Trigger.isInsert) {
        for(Order__c o : Trigger.New) {
            System.debug('--After Insert Trigger fired--');
            OrderTriggerHandler.handleOrder(o);
        }
    }

    if(Trigger.isAfter && Trigger.isUpdate) {
        for(Order__c o : Trigger.New) {
            System.debug('--After Update Trigger fired--');
            OrderTriggerHandler.handleOrder(o);
        }
    }
}