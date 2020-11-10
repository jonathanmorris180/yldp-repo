public with sharing class OrderTriggerHandler {
    public static void handleOrder(Order__c o) {
        if(relatedContactExists(o)) {
            System.debug('--Lead has already been converted--');
            List<List<String>> orderDetails = parseOrder(o.Order_Details__c);

            // Use this query to get Registered Programs where Account's Contact's email matches (if needed in the future)
            /* List<Registered_Program__c> regProgs = [SELECT Id, Account__r.npe01__One2OneContact__r.Email FROM Registered_Program__c WHERE Account__r.npe01__One2OneContact__r.Email=:o.Customer_Email__c]; */

            // Create new Registered Programs ones with new order info
            createRegisteredPrograms(o);
        }

        if(!relatedContactExists(o)) {
            System.debug('--Lead needs to be converted--');

            // Update payment made on Lead (which fires Process Builder)
            Lead leadToConvert = [SELECT Id, Email FROM Lead WHERE Email =:o.Customer_Email__c LIMIT 1];
            if(leadToConvert != null) {
                leadToConvert.Payment_made__c = true;
                update leadToConvert;
            }
    
            // Create Registered Program records
            createRegisteredPrograms(o);
        }
    }

    private static List<List<String>> parseOrder(String s) {
        List<String> listOfLines = s.split('\n');
        List<String> programTitles = new List<String>();
        List<String> programQuantities = new List<String>();
        List<List<String>> titlesAndQuantities = new List<List<String>>();
        for(String line : listOfLines) {
            if(line.contains('Title : ')) {
                System.debug('--Line contains Title--');
                line = line.removeStart('Title : ');
                programTitles.add(line.trim());
            } else if(line.contains('Quantity : ')) {
                line = line.removeStart('Quantity : ');
                programQuantities.add(line);
            }
            titlesAndQuantities.add(programTitles);
            titlesAndQuantities.add(programQuantities);
        }
        return titlesAndQuantities;
    }

    private static Boolean relatedContactExists(Order__c o) {
        System.debug('--Checking for related Contact--');
        List<Contact> relatedContact = [SELECT Id, Email FROM Contact WHERE Email=:o.Customer_Email__c];
        if(relatedContact.isEmpty()) {
            return false;
        }
        else return true;
    }

    private static void createRegisteredPrograms(Order__c o) {
        List<List<String>> orderDetails = parseOrder(o.Order_Details__c);
        List<String> quantities = orderDetails[1];
        List<String> programNames = orderDetails[0];
        List<Program__c> programs = [SELECT Id, Name FROM Program__c WHERE Name IN :programNames];
        Contact contact = [SELECT Id, Email, AccountId FROM Contact WHERE Email =:o.Customer_Email__c LIMIT 1];
        List<Registered_Program__c> regProgsToInsert = new List<Registered_Program__c>();

        System.debug('programNames: ' + programNames);
        System.debug('quantities: ' + quantities);
        System.debug('programs: ' + programs);
        System.debug('contact: ' + contact);
        System.debug('contact account id: ' + contact.AccountId);
        
        for(Integer i=0; i<programNames.size(); i++) {
            Registered_Program__c newRegP = new Registered_Program__c();
            newRegP.Account__c = contact.AccountId;
            newRegP.Program__c = programs[i].Id;
            newRegP.Name = programs[i].Name;
            System.debug('quantity: ' + quantities[i]);
            newRegP.Places_Reserved__c = Integer.valueOf(quantities[i].deleteWhitespace());
            regProgsToInsert.add(newRegP);
        }
        insert regProgsToInsert;
    }
}
