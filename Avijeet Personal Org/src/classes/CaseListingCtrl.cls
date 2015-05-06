public with sharing class CaseListingCtrl {
  
    public list<Case> caseList{get;set;}
    public list<CaseListWrapper> caseWrapperList{get;set;}
    public ApexPages.StandardSetController caseCon { get; set; }
    public map<id,boolean> checkBoxMap {get; set;}
    public map<id,CaseListWrapper> caseListWrapperMap {get; set;}  
    public string selectedCases{get;set;}
  
  
    public CaseListingCtrl(ApexPages.StandardController controller){
        caseList = new list<Case>();
        caseWrapperList = new list<CaseListWrapper>();
        checkBoxMap = new map<id,boolean>();   
        caseListWrapperMap = new map<id,caseListWrapper>();
        selectedCases ='';
        String queryStr = 'Select id, contactId, Accountid, subject, description, Priority, Status, CreatedDate FROM Case Order By CreatedDate DESC';
        caseCon =  new ApexPages.StandardSetController(Database.getQueryLocator(queryStr));    
        caseCon.setPageSize(5);
        caseList = (list<Case>)caseCon.getRecords() ;        
        for(Case c : caseList) {
            caseListWrapperMap.put(c.id, new caseListWrapper(c));
            caseWrapperList.add(caseListWrapperMap.get(c.id));
        }     
    }
  
    public class caseListWrapper{
        public Case c{get;set;}
        public Boolean isSelected{get;set;}        
        
        public caseListWrapper(Case c){
            this.c = c;            
        }
    }
  
    public Pagereference selectedCases(){    
    
        for(caseListWrapper caseObj : caseListWrapperMap.values()) {
            if(caseObj.isSelected) {        
                selectedCases += caseObj.c.id+'-';        
            }
        }    
   
        if(caseListWrapperMap.size()>0){      
            System.debug('caseListWrapperMap===>'+caseListWrapperMap);
            return new Pagereference('/apex/pp?&selectedCases='+selectedCases);
        }else{
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select atleast one case'));      
            return null;
        }
  
    }
  
    // indicates whether there are more records after the current page set.
    public Boolean hasNext {
        get {
            return caseCon.getHasNext();
        }
        set;
    }
 
    // indicates whether there are more records before the current page set.
    public Boolean hasPrevious {
        get {
            return caseCon.getHasPrevious();
        }
        set;
    }
 
    // returns the page number of the current page set
    public Integer pageNumber {
        get {
            return caseCon.getPageNumber();
        }
        set;
    }
 
    // returns the first page of records
    public void first() {
        caseCon.first();
        preparecaseList();
    }
 
    // returns the last page of records
    public void last() {
        caseCon.last();
        preparecaseList();
        
    }
 
    // returns the previous page of records
    public void previous() {
        caseCon.previous();
         preparecaseList();        
    }
 
    // returns the next page of records
    public void next() {
        caseCon.next();
        preparecaseList();
    }
 
    public void preparecaseList() {
        caseWrapperList.clear();
        caseList = (list<Case>) caseCon.getRecords() ;
        for(Case c : caseList) {
            if(!caseListWrapperMap.containsKey(c.id)) {
                caseListWrapperMap.put(c.Id, new caseListWrapper(c)) ;
            }
            caseWrapperList.add(caseListWrapperMap.get(c.Id));
        }
    }
}