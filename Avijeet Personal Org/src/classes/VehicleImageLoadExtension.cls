global with sharing class VehicleImageLoadExtension {
    public Contact con{get;set;}
    public static Vehicle__c vehicle{get;set;}
    public VehicleImageLoadExtension(ApexPages.StandardController controller) {
        this.con = (Contact)controller.getRecord();
    }
    
    public PageReference loadImage()    {
    String a = 'a';
    return null;
    }
    
    @RemoteAction
    global static void loadVehicleImage(String vehicleName) {
        vehicle = [SELECT Vehicle_Image__c FROM Vehicle__c WHERE Name =:vehicleName];
    }

}