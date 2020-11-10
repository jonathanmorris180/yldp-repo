public class MembersAreaController {

    public String recordId {get; set;}
    private final Student__c std;
    public ApexPages.StandardController myStdController {get; set;}
    private final String email = ApexPages.currentPage().getParameters().get('email');
    public ApexPages.StandardSetController setCon {
        get {
            if(setCon == null) {
                setCon = new ApexPages.StandardSetController(Database.getQueryLocator([SELECT Id, Name, Grade__c, Date_of_Birth__c, Delete_Record__c, Enrolled_Programs__c, Account__r.npe01__One2OneContact__r.Email FROM Student__c WHERE Account__r.npe01__One2OneContact__r.Email=:email]));
            }
            return setCon;
        }
        set;
    }
    public ApexPages.StandardSetController setCon2 {
        get {
            if(setCon2 == null) {
                setCon2 = new ApexPages.StandardSetController(Database.getQueryLocator([SELECT Id, Program__r.Name, Places_Reserved__c FROM Registered_Program__c WHERE Account__r.npe01__One2OneContact__r.Email=:email]));
            }
            return setCon2;
        }
        set;
    }
    
    // Constructors
    public MembersAreaController(ApexPages.StandardSetController controller) {
        this.std = (Student__c)controller.getRecord();
    }
    
    public MembersAreaController(ApexPages.StandardController stdController) {
        this.myStdController = stdController;
    }
    
    // Methods
    public List<Registered_Program__c> getRegisteredPrograms() {
        return (List<Registered_Program__c>)setCon2.getRecords();
    }
    
    public List<Student__c> getStudents() {
        return (List<Student__c>)setCon.getRecords();
    }
    
    public String getRelatedAccount() {
        Account acct = [SELECT Id, Name, npe01__One2OneContact__r.Email FROM Account WHERE npe01__One2OneContact__r.Email=:email];
        return acct.Name;
    }
    
    public PageReference deleteRecord() {
        System.debug('--Deleting record--');
        Student__c s = [SELECT Id FROM Student__c WHERE Id=:recordId LIMIT 1];
        System.debug('Student to delete from VF page: ' + s);
        delete s;
        PageReference pr = new PageReference('/apex/yldpMemberPage?email=' + email);
        pr.setRedirect(true);
        return pr;
    }
    
    public PageReference saveAndNew() {
        System.debug('--Saving record--');
        Student__c s = (Student__c)myStdController.getRecord();
        System.debug('Record being saved: ' + s);
        insert s;
        PageReference pr = new PageReference('/apex/yldpMemberPage?email=' + email);
        pr.setRedirect(true);
        return pr;
    }
}