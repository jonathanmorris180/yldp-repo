trigger RegisteredStudentTrigger on Registered_Student__c (after insert, before delete) {
    if(Trigger.isAfter && Trigger.isInsert) {
        System.debug('--Running after insert trigger--');
        if(RegisteredStudentTriggerHandler.checkAlreadyRegistered(Trigger.New)) {
            for(Registered_Student__c r : Trigger.New) {
                r.addError('This student has already been registered for this program');
            }
        }
        RegisteredStudentTriggerHandler.addEnrolledPrograms(Trigger.New);
    }
    if(Trigger.isBefore && Trigger.isDelete) {
        System.debug('--Running before delete trigger--');
        RegisteredStudentTriggerHandler.deleteEnrolledPrograms(Trigger.Old);
    }
}