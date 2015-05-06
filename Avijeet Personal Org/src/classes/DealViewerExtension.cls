/**
* Class DealViewerExtension
* Extension to provide custom functionality to the Deal Viewer page 
*/
public with sharing class DealViewerExtension    {
    //transient variable to hold contact record currently reffered by Standard Controller
    public Contact con {get;set;}
    //non transient variables to calculate values in current Deal Viewer Session
    public Double todayAcceptanceRate {get;set;}
    public Integer dealsReviewedToday {get;set;}
    public Integer dealsAcceptedToday {get;set;}
    public Integer dealsRejectedToday {get;set;}
    public Integer dealsAvailableToday {get;set;}      
    //holding constant values as final and static Strings    
    private static final String DEFAULT_ICON_RESOURCE_NAME = 'GenericFish';
    private static final String DEFAULT_ICON_RESOURCE_URL ;   
    private static final String ACCEPTED_ACTION = 'Accepted'; 
    private static final String AVAILABLE_STATUS= 'Available'; 
    private static final String UNAVAILABLE_STATUS= 'Unavailable';  
    private static final String ATTACHMENT_DOWNLOAD_URL_PREFIX= '/servlet/servlet.FileDownload?file=';
    //saving Standard Controller to make use of view() function to redirect back to contact
    private ApexPages.StandardController stdController;    
    //defining standard list controller to perform pagination
    public ApexPages.StandardSetController dealCon {get;set;}
    //defining list to store records returned by standard set controller
    public List<Deal__c> dealList {get;set;}
    //defining list of deal wrapper inner class which is actually shown on VF page
    public List<DealWrapper> dealWrapperList {get;set;}
    //defining a map to keep track and persist chanes done on a record returned by pagination
    public Map<id,DealWrapper> dealWrapperMap {get;set;}    
    //defining variable to hold deal id on which action got performed
    public transient String actionedDealId {get;set;}
    //defining variable to hold contact id on which action got performed
    public transient String actionedContactId {get;set;}
    //defining variable to hold type of action was performed
    public transient String actionPerformed {get;set;}
    
    static{
        DEFAULT_ICON_RESOURCE_URL = getDefaultResourceURL(DEFAULT_ICON_RESOURCE_NAME);
    }
    
    //constructor of extension
    public DealViewerExtension(ApexPages.StandardController stdController)    {
        //initialise standardController
        this.stdController = stdController;        
        //initialise Contact        
        this.con = [SELECT Name, Acceptance_Rate__c, Deals_Accepted__c , Deals_Rejected__c FROM Contact WHERE Id =: Id.valueOf(stdController.getId())];
        //initialise numeric varibles which hold Current Deal Viewer Session data
        this.todayAcceptanceRate = 0.0;
        this.dealsReviewedToday = 0;
        this.dealsAcceptedToday = 0;
        this.dealsRejectedToday = 0;       
        //intialise lists of wrapper object
        this.dealList = new List<Deal__c>();
        this.dealWrapperList = new List<DealWrapper>();
        this.dealWrapperMap = new Map<id,DealWrapper>();        
        //querying deal records and passing them to standradsetcontroller to perform pagination
        String queryStr = 'SELECT Available_Deals__c,Name,Valid_Through__c, (SELECT Id FROM Attachments LIMIT 1) FROM Deal__c WHERE Valid_Through__c >= Today AND Available_Deals__c > 0 ORDER BY Valid_Through__c ASC , Available_Deals__c ASC , Name ASC';
        //intialise standard set controller
        dealCon = new ApexPages.StandardSetController(Database.getQueryLocator(queryStr));       
        //get total count of records
        dealsAvailableToday = dealCon.getRecords().size();        
        //set page size to 5
        dealCon.setPageSize(5);        
        //get all records in a list
        dealList = dealCon.getRecords();  
        
        //iterate and create Deal Wrapper List to show on VF page
        for(Deal__c deal : dealList) {
            //put record in Map as well             
            dealWrapperMap.put(deal.id, new DealWrapper(deal)); 
            //put record in the wrapper list           
            dealWrapperList.add(dealWrapperMap.get(deal.id));
        }          
    }
        
    // indicates whether there are more records after the current page set.
    public Boolean hasNext {
        get {
            return dealCon.getHasNext();
        }
        set;
    }
 
    // indicates whether there are more records before the current page set.
    public Boolean hasPrevious {
        get {
            return dealCon.getHasPrevious();
        }
        set;
    }
 
    // returns the page number of the current page set
    public Integer pageNumber {
        get {
            return dealCon.getPageNumber();
        }
        set;
    }
 
    // returns the first page of records
    public void first() {
        dealCon.first();
        //prepare wrapper list from wrappermap to persist previousely visited records
        prepareDealWrapperList();
    }
 
    // returns the last page of records
    public void last() {
        dealCon.last();
        //prepare wrapper list from wrappermap to persist previousely visited records
        prepareDealWrapperList();
        
    }
 
    // returns the previous page of records
    public void previous() {
        dealCon.previous();
        //prepare wrapper list from wrappermap to persist previousely visited records
         prepareDealWrapperList();        
    }
 
    // returns the next page of records
    public void next() {
        dealCon.next();
        //prepare wrapper list from wrappermap to persist previousely visited records
        prepareDealWrapperList();
    }
    
    //saves the state of the dealwrapper in a map so that it is persisted
    public void prepareDealWrapperList() {
        //clear dealwrapperlist
        dealWrapperList.clear();
        //fetch new set of records from standard set controller
        dealList = (List<Deal__c>)dealCon.getRecords() ;
        //iterate thorugh the records returned
        for(Deal__c deal : dealList) {
            //if state is not saved in wrapper map save in wrapper map
            if(!dealWrapperMap.containsKey(deal.id)) {                
                dealWrapperMap.put(deal.Id, new DealWrapper(deal)) ;
            }
            //if state is saved in wrapper map get record from wrapper map 
            dealWrapperList.add(dealWrapperMap.get(deal.Id));
        }
    }
    
    //redirects back to the contact record
    public PageReference redirectToContactRecord()    {
        return stdController.view();
    }
    
    //helper function to fetch the resource URL for default icon
    public static String getDefaultResourceURL(String resourceName)    {  
        //Fetching the resource  
        List<StaticResource> resourceList = [SELECT Name, NamespacePrefix, SystemModStamp FROM StaticResource WHERE Name = :resourceName];                              
        //Checking if the result is returned or not  
        if(resourceList.size() == 1)    {  
           //Getting namespace  
           String namespace = resourceList[0].NamespacePrefix;  
           //Getting Resource URL  
           return '/resource/' + resourceList[0].SystemModStamp.getTime() + '/' + (namespace != null && namespace != '' ? namespace + '__' : '') + resourceName;   
        }  
        else return '';  
    }  
    
    public void createDealAction()    {       
        //insert deal action record
        try    {
            if (!Deal_Action__c.sObjectType.getDescribe().isCreateable())    {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'** Insufficient access to perform aaction on deal **'));               
            }
            else    {
                //create deal action record
                Deal_Action__c dealAction = new Deal_Action__c();
                
                system.debug('--deal action--'+actionPerformed);
                system.debug('--contact id--'+actionedContactId);
                system.debug('--deal id--'+actionedDealId);
                
                dealAction.action__c = actionPerformed;            
                dealAction.Contact__c = Id.valueof(actionedContactId);            
                dealAction.Deal__c = Id.valueof(actionedDealId);
                insert dealAction;   
                
                //set isActioned=true on the deal record in the wrapper and set status to actionperformed
                for (DealWrapper dw : dealWrapperList)    {
                    if (dw.deal.id == Id.valueOf(actionedDealId)){
                        dw.isActioned = true;  
                        dw.status = actionPerformed;                
                        //decrement available deals count by 1
                    }
                }     
                //check the action performed by the user
                if (actionPerformed == ACCEPTED_ACTION )    {
                    //increase session's deals accepted count
                    dealsAcceptedToday  = dealsAcceptedToday + 1;            
                }
                else    {
                    //increase session's deals rejected count
                    dealsRejectedToday = dealsRejectedToday + 1;
                } 
                //decrease deals by 1 available as a deal has been just accepted/rejected
                dealsAvailableToday = dealsAvailableToday - 1;
                //calculate deals avialable today remaining
                dealsReviewedToday = dealsAcceptedToday + dealsRejectedToday ; 
                //calculate acceptence rate
                //if deals accepted today > 0
                if (dealsAcceptedToday > 0){
                    //calculate acceptance rate
                    todayAcceptanceRate = ( Double.valueOf(dealsAcceptedToday)/Double.valueOf(dealsReviewedToday))*100;
                }
                else    {
                    //set acceptance rate to 0
                    todayAcceptanceRate = 0;
                } 
                //fetch contact record again after updation  
                con = [SELECT Acceptance_Rate__c, Deals_Accepted__c , Deals_Rejected__c FROM Contact WHERE Id =: Id.valueOf(stdController.getId())];            
            }
        }  
        catch (System.DmlException dmlException)    {
            //dml exception occuring due to Prevent overselling validation rule
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,dmlException.getDmlMessage(0)));
        }
        catch(Exception e)    {
            //generic exception handler
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'** Unexpected error occured **'+e.getMessage()));
        }     
    }   
    
    //wrapper object to hold deal records and additional properties to display in page
    public class DealWrapper    {
        //variable to hold deal record
        public Deal__c deal {get;set;}  
        //variable to hold status      
        public String status {get;set;}
        //vraible to hold iconurl
        public String iconUrl {get;set;}
        //boolean variabel to specify if a deal has been actioned upon or not
        public Boolean isActioned {get;set;}        
        
        // parameterized constructor
        public DealWrapper (Deal__c deal)    {
            this.deal = deal;            
            this.status = (this.deal.Available_Deals__c > 0) ? AVAILABLE_STATUS : UNAVAILABLE_STATUS;
            this.isActioned = false;
            this.iconUrl = getResourceURL(deal);
        }       
        
        //helper method to assign Icon URL depending on attachment is present or not
        public String getResourceURL(Deal__c deal)    {        
            String iconUrl='';
            //if there is only one attachment with deal (as assumed in assignment)
            if (deal.Attachments.size() == 1)    {
                //form icon url
                iconUrl = ATTACHMENT_DOWNLOAD_URL_PREFIX + deal.Attachments[0].id;
            }
            else    {
                iconUrl = DEFAULT_ICON_RESOURCE_URL;
            }        
            return iconUrl;
        }       
    }    
}