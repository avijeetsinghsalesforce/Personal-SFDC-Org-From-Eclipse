public without sharing class DealActionManagement	{
	//helper function to return a set of contact id's when a list of Deal Actions is passed to it.
    public static Set<Id> fetchContactIds(List<Deal_Action__c> dealActions)    {
        Set<Id> contactIdSet = new Set<Id>();
        for (Deal_Action__c dealAction : dealActions)    {
            if (dealAction.Contact__c!=null)    {
                contactIdSet.add(dealAction.Contact__c);
            }
        }
        return contactIdSet;
    }
    //helper function to return a set of contact id's when a list of Deal Actions is passed to it.
    public static Set<Id> fetchDealIds(List<Deal_Action__c> dealActions)    {
        Set<Id> dealIdSet = new Set<Id>();
        for (Deal_Action__c dealAction : dealActions)    {
            if (dealAction.Deal__c!=null)    {
                dealIdSet.add(dealAction.Deal__c);
            }
        }
        return dealIdSet;
    }
}