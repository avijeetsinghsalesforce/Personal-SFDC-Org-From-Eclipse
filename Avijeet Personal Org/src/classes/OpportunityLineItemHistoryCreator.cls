public class OpportunityLineItemHistoryCreator{
    
    public static Map<String,Schema.DescribeFieldResult>opportunityLineItemFieldsToTrack;
    public static List<Opportunity_Product_Field_History__c> historiesToInsert = new List<Opportunity_Product_Field_History__c>();    
    public static String CCOP_PRICEBOOK_NAME= 'CCOP';
    
    static
    {
        createFieldsToTrackList();
        
    }
   
    
    
    //static method to create hoistry records and insert them
    public static void createFieldsToTrackList(){
        Map<String, Schema.SObjectField> allOpportunityLineItemFieldsMap = Schema.SObjectType.OpportunityLineItem.fields.getMap();
        opportunityLineItemFieldsToTrack = new Map<String, Schema.DescribeFieldResult>();
        for (Schema.SObjectField opportunityLineItemField : allOpportunityLineItemFieldsMap.values()) {
            Schema.DescribeFieldResult describeResult = opportunityLineItemField.getDescribe();
            //choose which fields to track depending on the field type
            if (describeResult.getType() == Schema.DisplayType.Boolean ||
                describeResult.getType() == Schema.DisplayType.Combobox ||
                describeResult.getType() == Schema.DisplayType.Currency ||
                describeResult.getType() == Schema.DisplayType.Date ||
                describeResult.getType() == Schema.DisplayType.DateTime ||
                describeResult.getType() == Schema.DisplayType.Double ||
                describeResult.getType() == Schema.DisplayType.Email ||
                describeResult.getType() == Schema.DisplayType.Integer ||
                describeResult.getType() == Schema.DisplayType.MultiPicklist ||
                describeResult.getType() == Schema.DisplayType.Percent ||
                describeResult.getType() == Schema.DisplayType.Phone ||
                describeResult.getType() == Schema.DisplayType.Picklist ||
                describeResult.getType() == Schema.DisplayType.String ||
                describeResult.getType() == Schema.DisplayType.TextArea ||
                describeResult.getType() == Schema.DisplayType.Time ||
                describeResult.getType() == Schema.DisplayType.URL) 
                {
                    //don't add standard fields that are not necessary
                if (describeResult.getName() != 'CreatedDate' &&
                        describeResult.getName() != 'LastModifiedDate' &&
                        describeResult.getName() != 'SystemModstamp' &&
                        //only add fields that are visible to the current user
                        describeResult.isAccessible() &&
                        //do not add formula fields
                        !describeResult.isCalculated() &&
                        describeResult.getName() != 'ProductCode' &&
                        describeResult.getName() != 'Name'
                        )
                    {
                        opportunityLineItemFieldsToTrack.put(describeResult.getName(), describeResult);
                    }
                }
            }
    }
    
    public static Opportunity_Product_Field_History__c createModificationHistory(Schema.DescribeFieldResult field, OpportunityLineItem oldOpportunityLineItem, OpportunityLineItem newOpportunityLineItem, Id product2Id) {
               
        Opportunity_Product_Field_History__c opportunityLineItemHistory = new Opportunity_Product_Field_History__c();
        opportunityLineItemHistory.Opportunity_Line_Item_Id__c = oldOpportunityLineItem.Id;
        opportunityLineItemHistory.Opportunity__c = oldOpportunityLineItem.OpportunityId;
        opportunityLineItemHistory.Event__c = 'Edit';
        opportunityLineItemHistory.Field__c = field.getLabel();
        opportunityLineItemHistory.User__c = UserInfo.getUserId();
        opportunityLineItemHistory.Product__c = oldOpportunityLineItem.PricebookEntry.Product2Id;        
        opportunityLineItemHistory.Old_Value__c = String.valueOf(oldOpportunityLineItem.get(field.getName()));
        opportunityLineItemHistory.New_Value__c = String.valueOf(newOpportunityLineItem.get(field.getName()));      
        opportunityLineItemHistory.Date__c = System.now();
        opportunityLineItemHistory.Product__c = product2Id;
        // shorten strings that are longer than 255 characters (can happen if the field has the type textArea)
        if (opportunityLineItemHistory.Old_Value__c != null) opportunityLineItemHistory.Old_Value__c = opportunityLineItemHistory.Old_Value__c.abbreviate(255);
        if (opportunityLineItemHistory.New_Value__c != null) opportunityLineItemHistory.New_Value__c = opportunityLineItemHistory.New_Value__c.abbreviate(255);
             
        return opportunityLineItemHistory;
        
       
    }
    
    public static Opportunity_Product_Field_History__c createCreationHistory(Schema.DescribeFieldResult field, OpportunityLineItem newOpportunityLineItem, Id product2Id) {
        
        
        Opportunity_Product_Field_History__c opportunityLineItemHistory = new Opportunity_Product_Field_History__c();
        opportunityLineItemHistory.Opportunity_Line_Item_Id__c = newOpportunityLineItem.Id;
        opportunityLineItemHistory.Opportunity__c = newOpportunityLineItem.OpportunityId;
        opportunityLineItemHistory.Event__c = 'Create';
        opportunityLineItemHistory.Field__c = field.getLabel();
        opportunityLineItemHistory.User__c = UserInfo.getUserId();
        opportunityLineItemHistory.Product__c = newOpportunityLineItem.PricebookEntry.Product2Id;
        opportunityLineItemHistory.New_Value__c =  String.valueOf(newOpportunityLineItem.get(field.getName()));
        opportunityLineItemHistory.Date__c = System.now();
        opportunityLineItemHistory.Product__c = product2Id;
        // shorten strings that are longer than 255 characters (can happen if the field has the type textArea)
        opportunityLineItemHistory.Old_Value__c = null;
        if (opportunityLineItemHistory.New_Value__c != null) opportunityLineItemHistory.New_Value__c = opportunityLineItemHistory.New_Value__c.abbreviate(255);    
           
        return opportunityLineItemHistory;        
       
    }
    
    public static void insertHistories(){
        if (!historiesToInsert.isEmpty()) {
            //remove duplicate history entries
            List<Opportunity_Product_Field_History__c> historiesToInsertWithoutDuplicates = new List<Opportunity_Product_Field_History__c>();
            Set<Opportunity_Product_Field_History__c> historiesSet = new Set<Opportunity_Product_Field_History__c>();
            historiesSet.addAll(historiesToInsert);
            historiesToInsertWithoutDuplicates.addAll(historiesSet);
    
            //insert the rest
            system.debug('----list to insert----'+historiesToInsertWithoutDuplicates);
            Database.insert(historiesToInsertWithoutDuplicates,false);
            historiesToInsert.clear();
        } 
    }
    
}