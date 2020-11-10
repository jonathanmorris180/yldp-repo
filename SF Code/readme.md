# Readme
* Two YLDP sandboxes were used when writing this code: YLDP and CDITest
* The CDITest sandbox contains *MOST* of the code, while the YLDP sandbox contains the trigger and handler class/test class for the "Need More Information" form 
* Ideally, the code in this sandbox should be merged with the code from the CDITest sandbox before deployment to production
* Trigger context variables can be used to run the **LeadNameUpdateHandler** class from the **LeadTrigger** trigger in the **CDITest** sandbox (i.e. there is a trigger with the same name in the YLDP sandbox that needs to be merged with the CDITest LeadTrigger trigger)