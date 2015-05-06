trigger OpportunityProductTriggers on OpportunityLineItem (before insert,after insert,before delete,after delete, before update, after update) {
//creation of opportunitylineitemhistory
  
   if (!Trigger.isDelete){       
        
        List<Id> pricebookEntryIds = new List<Id>();             
        for (OpportunityLineItem lineItem: trigger.new)    {
            pricebookEntryIds.add(lineItem.PricebookEntryId);           
        }    
        Map<Id,PriceBookEntry> pricebookEntryMap = new Map<Id,PricebookEntry>([SELECT Id, Pricebook2.Name, Product2Id FROM PricebookEntry WHERE Id IN :pricebookEntryIds]);
        List<Id> productIds = new List<Id>();
        for (PricebookEntry pbe : pricebookEntryMap.values()){
            productIds.add(pbe.product2Id);
        }
        
        Map<Id, Product2> productMap = new Map<Id,Product2>([SELECT Id, Name FROM Product2 WHERE Id IN : productIds]);       
        
        Map<Id,Product2> productPriceBookEntryMap = new Map<Id,Product2>();
        for (PricebookEntry pbe : pricebookEntryMap.values()){
            productPriceBookEntryMap.put(pbe.Id, productMap.get(pbe.Product2Id));
        }
        
        //creation history
        if(Trigger.isInsert && Trigger.isAfter) {
        system.debug('----going for creatinng history fo create event--');
            for (OpportunityLineItem lineItem : Trigger.new){         
                
                    
                OpportunityLineItem newLineItem = lineItem ;                
               
                    for (Schema.DescribeFieldResult fieldDescribe : OpportunityLineItemHistoryCreator.opportunityLineItemFieldsToTrack.values()) {
                        if ( newLineItem.get(fieldDescribe.getName())!=null) {        
                                                               
                            OpportunityLineItemHistoryCreator.historiesToInsert.add(OpportunityLineItemHistoryCreator.createCreationHistory(fieldDescribe,newLineItem,productPriceBookEntryMap.get(newLineItem.PriceBookEntryId).Id));                           
                        }                    
                        
                    } 
            }
        }
        
        
        
        
        //updation history
        
        if(Trigger.isUpdate && Trigger.isAfter) {
        system.debug('----going for creatinng history fo update event--');
            for (OpportunityLineItem lineItem : Trigger.new){                              
              
                    OpportunityLineItem newLineItem = lineItem;
                    OpportunityLineItem oldLineItem = Trigger.oldMap.get(lineItem.Id);          
                    for (Schema.DescribeFieldResult fieldDescribe : OpportunityLineItemHistoryCreator.opportunityLineItemFieldsToTrack.values()) {
                        if (oldLineItem.get(fieldDescribe.getName()) != newLineItem.get(fieldDescribe.getName())) { 
                                                        
                            OpportunityLineItemHistoryCreator.historiesToInsert.add(OpportunityLineItemHistoryCreator.createModificationHistory(fieldDescribe,oldLineItem,newLineItem,productPriceBookEntryMap.get(newLineItem.PriceBookEntryId).Id));
                            
                        }
                    }              
            }
        }
        
        system.debug('----going for inserting history--');
        OpportunityLineItemHistoryCreator.insertHistories();
    
  }
  if (Trigger.isAfter && Trigger.isDelete){
        List<Id> pricebookEntryIds = new List<Id>();             
        for (OpportunityLineItem lineItem: trigger.new)    {
            pricebookEntryIds.add(lineItem.PricebookEntryId);           
        }    
        Map<Id,PriceBookEntry> pricebookEntryMap = new Map<Id,PricebookEntry>([SELECT Id, Pricebook2.Name, Product2Id FROM PricebookEntry WHERE Id IN :pricebookEntryIds]);
        List<Id> productIds = new List<Id>();
        for (PricebookEntry pbe : pricebookEntryMap.values()){
            productIds.add(pbe.product2Id);
        }
        
        Map<Id, Product2> productMap = new Map<Id,Product2>([SELECT Id, Name FROM Product2 WHERE Id IN : productIds]);       
        
        Map<Id,Product2> productPriceBookEntryMap = new Map<Id,Product2>();
        for (PricebookEntry pbe : pricebookEntryMap.values()){
            productPriceBookEntryMap.put(pbe.Id, productMap.get(pbe.Product2Id));
        }
        
        //deletion history
        for (OpportunityLineItem lineItem : Trigger.old){               
                
            }
            
               
  }
        
}