/**
* Trigger on Deal_Action__c Sobject
*/
trigger DealActionManagementTrigger on Deal_Action__c (before delete, before insert, before update, after delete, after insert, after update, after undelete) {
    //get handler from TriggerFactory for DealActionhandler class and execute
    TriggerFactory.createAndExecuteHandler(DealActionHandler.class);
}