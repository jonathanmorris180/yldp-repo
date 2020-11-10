public with sharing class RegisteredStudentTriggerHandler {

    public static Boolean checkAlreadyRegistered(List<Registered_Student__c> r) {
        System.debug('--Checking not already registered--');
        Map<Student__c, List<Registered_Student__c>> regsToStuds = returnMap(r);
        for(Student__c s : regsToStuds.keySet()) {
            String enrolledProgs = s.Enrolled_Programs__c;
            if(enrolledProgs != null) {
                List<String> progNames = new List<String>();
                if(enrolledProgs.contains(';')) {
                    System.debug('enrolledProgs contains the ; character');
                    progNames = enrolledProgs.split(';');
                }
                System.debug('progNames: ' + progNames);
                List<Registered_Student__c> regs = regsToStuds.get(s);
                List<String> regStudProgNames = new List<String>();
                for(Registered_Student__c reg : regs) {
                    regStudProgNames.add(reg.Program__r.Name);
                }
                System.debug('regStudProgNames: ' + regStudProgNames);
                for(String str : progNames) {
                    if(regStudProgNames.contains(str)) {
                        for(Registered_Student__c reg : regsToStuds.get(s)) {
                            System.debug('Adding Error');
                            return true;
                        }
                    }
                }
            }
        }
        return false;
    }

    public static void addEnrolledPrograms(List<Registered_Student__c> r) {
        Map<Student__c, List<Registered_Student__c>> regsToStuds = returnMap(r);
        System.debug('regsToStuds: ' + regsToStuds);
        // Loop through map to update records
        List<Student__c> studentsToUpdate = new List<Student__c>();
        for(Student__c s : regsToStuds.keySet()) {
            List<Registered_Student__c> regs = regsToStuds.get(s);
            if(s.Enrolled_Programs__c == null) {
                String programs = getPrograms(regs);
                System.debug('Program names: ' + programs);
                s.Enrolled_Programs__c = programs;
                studentsToUpdate.add(s);
            } else {
                String programs = getPrograms(regs);
                System.debug('Program names: ' + programs);
                s.Enrolled_Programs__c += ';' + programs;
                studentsToUpdate.add(s);
            }
        }
        update studentsToUpdate;
    }

    public static void deleteEnrolledPrograms(List<Registered_Student__c> r) {
        Map<Student__c, List<Registered_Student__c>> regsToStuds = returnMap(r);
        // Loop through map to update records
        List<Student__c> studentsToUpdate = new List<Student__c>();
        for(Student__c s : regsToStuds.keySet()) {
            if(s.Enrolled_Programs__c != null) {
                List<Registered_Student__c> regs = regsToStuds.get(s);
                List<String> programs = new List<String>();
                for(Registered_Student__c regStu : regs) {
                    programs.add(regStu.Program__r.Name);
                }
                for(String str : programs) {
                    String ernolledProgs = s.Enrolled_Programs__c;
                    if(ernolledProgs.contains(str + ';')) {
                        s.Enrolled_Programs__c = ernolledProgs.remove(str + ';');
                    } else {
                        s.Enrolled_Programs__c = ernolledProgs.remove(';' + str);
                    }
                }
                System.debug('Programs to remove: ' + programs);
                studentsToUpdate.add(s);
                System.debug('Students to update: ' + studentsToUpdate);
            } 
        }
        update studentsToUpdate;
    }

    private static Map<Student__c, List<Registered_Student__c>> returnMap(List<Registered_Student__c> r) {
        // List of Registered Student record IDs
        List<Id> ids = new List<Id>();
        for(Registered_Student__c regStu : r) {
            ids.add(regStu.Id);
        }
        List<Registered_Student__c> reg = [SELECT Id, Name, Program__r.Name, Student__c FROM Registered_Student__c WHERE Id IN :ids];
        System.debug('Registered Students from trigger: ' + reg);

        // Get the Student record IDs from the Registered Student list
        List<Id> studentIds = new List<Id>();
        for(Registered_Student__c regStu : reg) {
            studentIds.add(regStu.Student__c);
        }

        // Get a list of Students whose ID matches
        List<Student__c> students = [SELECT Id, Enrolled_Programs__c FROM Student__c WHERE Id IN :studentIds];
        System.debug('Students in list: ' + students);

        // Create a map of Registered Students and Students
        Map<Student__c, List<Registered_Student__c>> regsToStuds = new Map<Student__c, List<Registered_Student__c>>();
        for(Student__c s : students) {
            List<Registered_Student__c> regs = new List<Registered_Student__c>();
            for(Registered_Student__c regStu : reg) {
                if(regStu.Student__c == s.Id) {
                    regs.add(regStu);
                }
            }
            regsToStuds.put(s, regs);
            System.debug('Student being put into map: ' + s);
            System.debug('Registered Students being put into map: ' + regs);
        }
        System.debug('Map of Students to Registered Students: ' + regsToStuds);
        return regsToStuds;
    }

    private static String getPrograms(List<Registered_Student__c> l) {
        List<String> programs = new List<String>();
        for(Registered_Student__c regStu : l) {
            programs.add(regStu.Program__r.Name);
        }
        System.debug('getPrograms method: ' + programs);
        return String.join(programs, ';');
    }
}
