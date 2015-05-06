/**
* Class DealActionHandler
* Trigger Handler for the Deal_Action__c Sobject. 
* This class implements the Triggerable interface to help ensure the trigger code is bulkified and all in one place.
* Static variables not required as no need to persist any data across the before and after trigger. 
*/
public without sharing class DealActionHandler implements Triggerable    {
    //Set to hold related Contact Id's
    private Set<Id> contactIdSet = new Set<Id>();
    //Set to hold related Deal Id's
    private Set<Id> dealIdSet = new Set<Id>();
    //List to hold contacts having id in contactidset 
    private Map<Id,Contact> contactMap= new Map<Id,Contact>();
    //List to hold deal having id in dealidSet
    private Map<Id,Deal__c> dealMap = new Map<Id,Deal__c>();
    //String constant to be used
    private static final String ACCEPTED_ACTION = 'Accepted';
    private static final String REJECTED_ACTION = 'Rejected';
    
    public void bulkBefore()    {
        //no action here
    }
    
    /**
    * Public method to perform collection and bulkified query against database
    */
    public void bulkAfter()    {
        //if the action is delete use Trigger.old as Trigger.new is not available
        if (Trigger.isDelete){
            //fetch the Contact Id's related to the Deal Action records being deleted
            contactIdSet = fetchContactIds(Trigger.old);
            //fetch the Deal id's related to the Deal Action records being deleted
            dealIdSet = fetchDealIds(Trigger.old);                       
        } 
        //if the action is insert/update/undelete use Trigger.new
        else {
            //fetch the Contact Id's related to the Deal Action records being deleted
            contactIdSet = fetchContactIds(Trigger.new);
            //fetch the Deal id's related to the Deal Action records being deleted
            dealIdSet = fetchDealIds(Trigger.new); 
            //If update trigger
            if (Trigger.isUpdate)    {
                //add related Contact record Id's present in Trigger.old as well if not already present in set fetched from Trigger.new
                contactIdSet.addAll(fetchContactIds(Trigger.old));
                //add related Deal record Id's present in Trigger.old as well if not alredy present in set fetched from Trigger.new
                dealIdSet.addAll(fetchDealIds(Trigger.old));
            }            
        }
        //fetch all Deal records with Id's in dealidset with Available Deals, Acceptences and Rejections field
        dealMap = new Map<Id,Deal__c>([SELECT Id, Acceptances__c, Rejections__c, Available_Deals__c, Max_Acceptances__c FROM Deal__c WHERE Id IN : dealIdSet]);
        //fetch all Contact records with Id's in contactidset with Deals Accepted and Deals Rejected field
        contactMap = new Map<Id,Contact>([SELECT Id, Deals_Accepted__c, Deals_Rejected__c FROM Contact WHERE Id IN : contactIdSet]);                    
    }
 
    public void beforeInsert(SObject so)    {
        //no action here
    }
 
    public void beforeUpdate(SObject oldSo, SObject so)    {
        //no action here
    }
 
    public void beforeDelete(SObject so)    {      
        //no action here  
    }
    
    /**
    * Public method to perform incerement / decrement of count variables on Contact / Deal on insertion of Deal Action
    * and perform validation for preventing overselling
    * Arguments: Sobject passed by handler
    */
    public void afterInsert(SObject so)    {
        //cast the sobject passed from handler to Deal Action
        Deal_Action__c dealAction = (Deal_Action__c)so;
        //if Deal Action with Action = Rejected gets inserted
        if (dealAction.Action__c == REJECTED_ACTION)    {
            //check if Deal Action record has a Deal present
            if (dealAction.Deal__c != null)    {
                //get related Deal record details from map already fetched
                Deal__c relatedDeal = dealMap.get(dealAction.Deal__c);
                //increment Rejections by 1    
                //skipping null check as default value = 0;            
                relatedDeal.Rejections__c = relatedDeal.Rejections__c + 1;                
                //put record back in map
                dealMap.put(dealAction.Deal__c,relatedDeal);
            }
            //check if Deal Action record has a Contact present
            if (dealAction.Contact__c != null)    {
                //get related Contact record details from map already fetched
                Contact relatedContact = contactMap.get(dealAction.Contact__c);
                //increment Deals Rejected on Contact by 1  
                //skipping null check as default value = 0;              
                relatedContact.Deals_Rejected__c = relatedContact.Deals_Rejected__c + 1;
                //put record back in map
                contactMap.put(dealAction.Contact__c,relatedContact);
            }            
        }
        //if Deal Action with Action = Accepted gets inserted
        else if (dealAction.Action__c == ACCEPTED_ACTION )    {
            //check if Deal Action record has a Deal present
            if (dealAction.Deal__c != null)    {
                //get related Deal record details from map already fetched
                Deal__c relatedDeal = dealMap.get(dealAction.Deal__c);
                //increment Acceptances by 1 provided it does not reaches Max Acceptances limit on Deal record
                if ((relatedDeal.Acceptances__c) < (relatedDeal.Max_Acceptances__c))    {
                    //increment
                    relatedDeal.Acceptances__c = relatedDeal.Acceptances__c + 1;
                    //put record back in map
                    dealMap.put(dealAction.Deal__c,relatedDeal);
                }
                else{
                    dealAction.addError('** This deal is no longer available!! **'); 
                }
            }
            //check if Deal Action record has a Contact present
            if (dealAction.Contact__c != null)    {
                //get related Contact record details from map already fetched
                Contact relatedContact = contactMap.get(dealAction.Contact__c);
                //increment Deals Accepted by 1
                relatedContact.Deals_Accepted__c = relatedContact.Deals_Accepted__c + 1;
                //put back in map
                contactMap.put(dealAction.Contact__c,relatedContact);
            }            
        }
    }
    
    /**
    * Public method to perform incerement / decrement of count variables on Contact / Deal on updation of Deal Action
    * Arguments : Sobject passed by Handler
    * Update operation consists of two steps
    * 1. Removal of deal action record from previous Deal/Contact. Delegate this to afterDelete()
    * 2. Addition of deal action record to new Deal/Contact. Delegate this to afterInsert();
    */
    public void afterUpdate(SObject oldSo, SObject so)    {       
        //Stage 1:- Do reductions in totals count in Contact and Deal using old Deal Action record (delete of Old Record)
        afterDelete(oldSo);
        //Stage 2:- Do additions in totals count in Contact and Deal using new Deal Action record (insert of new Record)
        afterInsert(so);       
    }
    
    /**
    * Public method to perform incerement / decrement of count variables on Contact / Deal on deletion of Deal Action
    * Arguments : Sobject passed by handler
    */
    public void afterDelete(SObject so)    {
        //cast the sobject passed from handler to Deal Action
        Deal_Action__c dealAction = (Deal_Action__c)so;
        //if Deal Action record with Action = Rejected gets deleted
        if (dealAction.Action__c == REJECTED_ACTION)    {
            //check if Deal Action record has a Deal present
            if (dealAction.Deal__c != null)    {
                //get related Deal record details from map already fetched
                Deal__c relatedDeal = dealMap.get(dealAction.Deal__c);
                //decrement Rejections by 1 if it is greater than 0 else keep it at 0
                if (relatedDeal.Rejections__c > 0)    {
                    relatedDeal.Rejections__c = relatedDeal.Rejections__c - 1;
                }
                else    {                    
                    relatedDeal.Rejections__c = 0;
                }
                //put changed record in map
                dealMap.put(dealAction.Deal__c,relatedDeal);
            }
            //check if Deal Action record has a Contact present
            if (dealAction.Contact__c != null)    {
                //get related Contact record details from map already fetched
                Contact relatedContact = contactMap.get(dealAction.Contact__c);
                //decrement Deal Rejected by 1 if it is greater than 0 else keep it at 0
                if (relatedContact.Deals_Rejected__c > 0)    {
                    relatedContact.Deals_Rejected__c = relatedContact.Deals_Rejected__c - 1;
                }
                else    {                    
                    relatedContact.Deals_Rejected__c = 0;
                }
                //put back changed record in the map
                contactMap.put(dealAction.Contact__c,relatedContact);
            }            
        }
        //if Deal Action record with Action = Accepted gets deleted
        else if (dealAction.Action__c == ACCEPTED_ACTION)    {
            //check if Deal Action record has a Deal present
            if (dealAction.Deal__c != null)    {
                //get related Deal record details from map already fetched
                Deal__c relatedDeal = dealMap.get(dealAction.Deal__c);
                //decrement Acceptences by 1 if it is greater than 0 else keep it at 0
                if (relatedDeal.Acceptances__c > 0)    {
                    relatedDeal.Acceptances__c = relatedDeal.Acceptances__c - 1;
                }
                else    {                    
                    relatedDeal.Acceptances__c = 0;
                }
                //put changed record in map
                dealMap.put(dealAction.Deal__c,relatedDeal);
            }
            //check if Deal Action record has a Contact present
            if (dealAction.Contact__c != null)    {
                //get related Contact record details from map already fetched
                Contact relatedContact = contactMap.get(dealAction.Contact__c);
                //decrement Deal Accepted by 1 if it is greater than 0 else keep it at 0
                if (relatedContact.Deals_Accepted__c > 0)    {
                    relatedContact.Deals_Accepted__c = relatedContact.Deals_Accepted__c - 1;
                }
                else    {                    
                    relatedContact.Deals_Accepted__c = 0;
                }
                //put back changed record in the map
                contactMap.put(dealAction.Contact__c,relatedContact);
            }            
        }
    } 
    
    /**
    * Public method to perform incerement / decrement of count variables on Contact / Deal on undeletion of Deal Action
    * and Perform Prevent overselling validation as well.
    * Undelete operation is similar to insert so let delegate it to afterInsert()
    */
    public void afterUndelete(SObject so)    {
        //similar to insert operation so delegate it to the same function
        afterInsert(so);
    } 
    
    /**
    * Public method to perform updations on the related records
    */
    public void andFinally()    {        
        //update related Deals
        update dealMap.values();
        //update related Contacts
        update contactMap.values();        
        
    }
    
    /**
    * Public helper function to return a set of contact id's when a list of Deal Actions is passed to it.
    * Arguments : List<Deal_Action__c>
    * Return Type : Set<Id>
    */
    public Set<Id> fetchContactIds(List<Deal_Action__c> dealActions)    {
        Set<Id> contactIdSet = new Set<Id>();
        for (Deal_Action__c dealAction : dealActions)    {
            if (dealAction.Contact__c!=null)    {
                contactIdSet.add(dealAction.Contact__c);
            }
        }
        return contactIdSet;
    }
    
    /**
    * Public helper function to return a set of contact id's when a list of Deal Actions is passed to it.
    * Arguments : List<Deal_Action__c>
    * Return Type : Set<Id>
    */
    public Set<Id> fetchDealIds(List<Deal_Action__c> dealActions)    {
        Set<Id> dealIdSet = new Set<Id>();
        for (Deal_Action__c dealAction : dealActions)    {
            if (dealAction.Deal__c!=null)    {
                dealIdSet.add(dealAction.Deal__c);
            }
        }
        return dealIdSet;
    }
}