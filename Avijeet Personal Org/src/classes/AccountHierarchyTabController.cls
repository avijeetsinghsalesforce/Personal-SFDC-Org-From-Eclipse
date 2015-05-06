/******************************************************************************************
Apex Class Name : AccountHierarchyTabController
Version         : 1.0
             
Description     : This apex class is used to display the Contacts and Opportunites that are related
                  to account hierarchy. This class is invoked when user clicks on 'Account Hierarchy'
                  button on the account detail page. All contacts and opportunites that are related to 
                  all the accounts in the hierarchy are displayed on the page on respective contact and
                  opportunity tabs. 
                  Columns that are displayed on the page are based on 'Hierarchy Fields' custom setting.

*******************************************************************************************/

Public Class AccountHierarchyTabController{
  
    //Variable declaration
  
    Public Set<Id> AccIds = new Set<Id>();
    public String qryCon = 'select name,AccountId,Account.Name';
    public String qryOpp = 'select name,AccountId,Account.Name,ownerId,owner.name';
    
    public String sortDirection{get;set;}
    public String sortExpression{get;set;} 
    
    public String nullsLast{get;set;}
     
    public String conLb1{get;set;}
    public String conLb2{get;set;}
    public String conLb3{get;set;}
    public String conLb4{get;set;}
    public String conLb5{get;set;}
    public String conLb6{get;set;}
    public String conLb7{get;set;}
    public String conLb8{get;set;}
    public String conLb9{get;set;}
    public String conLb10{get;set;}
    

    public String oppLb1{get;set;}
    public String oppLb2{get;set;}
    public String oppLb3{get;set;}
    public String oppLb4{get;set;}
    public String oppLb5{get;set;}
    public String oppLb6{get;set;}
    public String oppLb7{get;set;}
    public String oppLb8{get;set;}
    public String oppLb9{get;set;}
    public String oppLb10{get;set;}  
    
    //Fetch all the fields from custom setting 'Hierarchy Fields'
    
    public static List<Hierarchy_Fields__c> hierFlds = Hierarchy_Fields__c.getall().values();
    public static List<Hierarchy_Fields__c> conHierflds=new List<Hierarchy_Fields__c>();
    public static List<Hierarchy_Fields__c> oppHierflds=new List<Hierarchy_Fields__c>();
    
    /*
        These maps contain all the fields that are identified by their sObject type (Opportunity and Contact respectively).
        You can then use this to not only check if these fields exists, but can further help you find out what display type
        that field is for formatting purposes.
    */
    public static Map<String,Schema.SObjectField> OpportunityFieldMap = Schema.sObjectType.Opportunity.Fields.getMap();
    public static Map<String,Schema.SObjectField> ContactFieldMap = Schema.sObjectType.Contact.Fields.getMap(); 
    
    public List<wrpContact> wrpConLst;
    List<wrpOpportunity> wrpOppLst;
    public boolean showcomponent{get;set;}
    
    //Constructor
   
    public AccountHierarchyTabController(ApexPages.StandardController controller) {
      AccIds  = HierarchyComponentController.accountIds;
      sortDirection = 'asc';
      sortExpression='name';
      showcomponent=false;
      nullsLast='';
      
      
        List<Double> lst=new List<Double>();
        Map<Double,Hierarchy_Fields__c> mapConHierflds=new Map<Double,Hierarchy_Fields__c>();
        Map<Double,Hierarchy_Fields__c> maOppHierflds=new Map<Double,Hierarchy_Fields__c>();
        
            for(integer i=0;i<hierFlds.size();i++)
                if(hierFlds[i].Object_Name__c=='Contact')
                  mapConHierflds.put(hierFlds[i].Sort_Order__c,hierFlds[i]);
                else if(hierFlds[i].Object_Name__c=='Opportunity')
                 maOppHierflds.put(hierFlds[i].Sort_Order__c,hierFlds[i]);
        lst.addall(mapConHierflds.keySet());
        lst.sort();
        for(Double d:lst)
          conHierflds.add(mapConHierflds.get(d));
        lst.clear();
        
        lst.addall(maOppHierflds.keySet());
        lst.sort();
        for(Double d:lst)
          oppHierflds.add(maOppHierflds.get(d));                
    }
    
    //Set Controller for all the contacts in the account hierarchy.
     
     public ApexPages.StandardSetController setcon{
        get {
            if(setcon== null) {
              for(integer i=0;i<conHierflds.size();i++){
               
                   qryCon+=','+conHierflds[i].Name;
                   
                   if(i==0)
                     conLb1=(conHierflds[i].Field_Label__c==null?'':conHierflds[i].Field_Label__c);
                   if(i==1)
                     conLb2=(conHierflds[i].Field_Label__c==null?'':conHierflds[i].Field_Label__c);
                   if(i==2)
                     conLb3=(conHierflds[i].Field_Label__c==null?'':conHierflds[i].Field_Label__c);
                   if(i==3)
                     conLb4=(conHierflds[i].Field_Label__c==null?'':conHierflds[i].Field_Label__c);
                   if(i==4)
                     conLb5=(conHierflds[i].Field_Label__c==null?'':conHierflds[i].Field_Label__c); 
                   if(i==5)
                     conLb6=(conHierflds[i].Field_Label__c==null?'':conHierflds[i].Field_Label__c);
                   if(i==6)
                     conLb7=(conHierflds[i].Field_Label__c==null?'':conHierflds[i].Field_Label__c);
                   if(i==7)
                     conLb8=(conHierflds[i].Field_Label__c==null?'':conHierflds[i].Field_Label__c);
                   if(i==8)
                     conLb9=(conHierflds[i].Field_Label__c==null?'':conHierflds[i].Field_Label__c);
                   if(i==9)
                     conLb10=(conHierflds[i].Field_Label__c==null?'':conHierflds[i].Field_Label__c);
              }     
                 
              qryCon+=' from Contact where AccountId in: AccIds order by '+sortExpression+' '+sortDirection+' '+nullsLast+'  limit 800';
              setcon= new ApexPages.StandardSetController(Database.getQueryLocator(qryCon));
            }
           return setcon;
        }
        set;
      }
      
      //Wrapper list to display contacts with 10 different customizable columns.
      
      public List<wrpContact> getContacts(){
         wrpConLst=new List<wrpContact>();
         List<Contact> conlst=setcon.getRecords();
         for(Contact c:conlst)
           wrpConLst.add(new wrpContact(c));
          return wrpConLst;
      }
      
      //Wrapper list to display opportunities with 10 different customizable columns.
      
      public List<wrpOpportunity> getOpportunity(){
         wrpOppLst=new List<wrpOpportunity>();
         List<Opportunity> opplst=setopp.getRecords();
         for(Opportunity o:opplst)
           wrpOppLst.add(new wrpOpportunity(o));
          return wrpOppLst;
      }
 

       public void next(){
          setcon.next();
      }
      
       public void previous(){
           setcon.previous();
      }
      
      /* Wrapper class for contacts. This wrapper class is used to dynamically display the 
      columns on the page. */
      
      public class wrpContact{
      
        public String f1{get;set;}
        public String f2{get;set;}
        public String f3{get;set;}
        public String f4{get;set;}
        public String f5{get;set;}
        public String f6{get;set;}
        public String f7{get;set;}
        public String f8{get;set;}
        public String f9{get;set;}
        public String f10{get;set;}
        public contact con{get;set;}   
        
        
        public wrpContact(Contact c){
            
             for(integer i=0;i<conHierflds.size();i++){
                   if(i==0)
                     f1= FormatField(c, i);//((''+c.get(conHierflds[i].Name))==''+null?'':(''+c.get(conHierflds[i].Name)));
                   if(i==1)
                     f2= FormatField(c, i);//((''+c.get(conHierflds[i].Name))==''+null?'':(''+c.get(conHierflds[i].Name)));
                   if(i==2)
                     f3= FormatField(c, i);//((''+c.get(conHierflds[i].Name))==''+null?'':(''+c.get(conHierflds[i].Name)));
                   if(i==3)
                     f4= FormatField(c, i);//((''+c.get(conHierflds[i].Name))==''+null?'':(''+c.get(conHierflds[i].Name)));
                   if(i==4)
                     f5= FormatField(c, i);//((''+c.get(conHierflds[i].Name))==''+null?'':(''+c.get(conHierflds[i].Name)));
                   if(i==5)
                     f6= FormatField(c, i);//((''+c.get(conHierflds[i].Name))==''+null?'':(''+c.get(conHierflds[i].Name)));
                   if(i==6)
                     f7= FormatField(c, i);//((''+c.get(conHierflds[i].Name))==''+null?'':(''+c.get(conHierflds[i].Name)));
                   if(i==7)
                     f8= FormatField(c, i);//((''+c.get(conHierflds[i].Name))==''+null?'':(''+c.get(conHierflds[i].Name)));
                   if(i==8)
                     f9= FormatField(c, i);//((''+c.get(conHierflds[i].Name))==''+null?'':(''+c.get(conHierflds[i].Name)));
                   if(i==9)
                     f10= FormatField(c, i);//((''+c.get(conHierflds[i].Name))==''+null?'':(''+c.get(conHierflds[i].Name)));  
             } 
             con=c;    
        }
        
        /*
            This method simply takes an sObject and a field number. The field number then selects a field within the respective sObject's
            heirarcy custom settings, which holds the display names and the field names on the sObject you specify.
            
            Based on your slection, if the field needs formatted prior to being read out to the screen. It can be done through here.
            
            Note: It would be a bit easier to do this on the VisualForce side.
        */
        private String FormatField(sObject FormatObject, Integer FieldNumber)
        {
            //If the field number is outside the bounds of your conHierflds List, return a blank String.
            if(FieldNumber < -1 || FieldNumber >= conHierflds.size())
                return '';
                
            //If the number is within bounds, we 'describe' that field to get more information on it - i.e. it's display type.
            Schema.DescribeFieldResult FieldResults = ContactFieldMap.get(conHierflds[FieldNumber].Name).getDescribe();
            
            //Now that we know the display type, we simply check for any types that need formatting.
            if(FieldResults.getType() == Schema.DisplayType.Date || FieldResults.getType() == Schema.DisplayType.DateTime)
            {
                //For the date, I simply convert the field value to a DateTime and output the results with a format string.
                //More info can be found here: http://salesforce.stackexchange.com/questions/8246/getting-format-for-date
                DateTime FomratDate = (DateTime) FormatObject.get(conHierflds[FieldNumber].Name); 
                 try {
                        return String.valueOf(FomratDate.format('MM/dd/yyyy'));
                    }
                    catch (System.NullPointerException ex) {
                        return ('');
                    }
            }
            else if(FieldResults.getType() == Schema.DisplayType.Currency)
            {
                //Here, I convert the raw currency amount to a string and then parse accordingly.
                String UnformattedCurrency = String.valueOf(FormatObject.get(conHierflds[FieldNumber].Name));
                
                /*
                    I found this code at the following link: http://salesforce.stackexchange.com
                        /questions/318/what-is-a-concise-function-that-formats-a-string-decimal-into-a-currency-forma
                    This code is locale safe (meaning in other currencies, it will still stand in most cases).
                */
                String FormattedCurrency = (Decimal.valueOf(UnformattedCurrency == null || 
                    UnformattedCurrency.trim() == '' ? '0' : UnformattedCurrency).setScale(2) + 0.001 ).format();
                
                return '$' + FormattedCurrency.substring(0, FormattedCurrency.length() - 1);
            }
            else if(FieldResults.getType() == Schema.DisplayType.Boolean)
                return (Boolean) FormatObject.get(conHierflds[FieldNumber].Name) ? 'True' : '';
            //Lastly, I check if it is a Boolean. Per the verbal requirements, if the value is false, I return a blank String.
            //Otherwise, I return 'True'
            
            //If it is neither of the display types, it is safe to simply cast the value as a String and return.
            return String.valueOf(FormatObject.get(conHierflds[FieldNumber].Name));
        }  
      }
      
       /* Wrapper class for opportunity. This wrapper class is used to dynamically display the 
      columns on the page. */
      
      public class wrpOpportunity{
      
        public String f1{get;set;}
        public String f2{get;set;}
        public String f3{get;set;}
        public String f4{get;set;}
        public String f5{get;set;}
        public String f6{get;set;}
        public String f7{get;set;}
        public String f8{get;set;}
        public String f9{get;set;}
        public String f10{get;set;}
        public opportunity opp{get;set;}
            
        
        
        public wrpOpportunity(Opportunity o){  
        
             for(integer i=0;i<oppHierflds.size();i++){
               if(i==0)
                 f1= FormatField(o, i);//((''+c.get(conHierflds[i].Name))==''+null?'':(''+c.get(conHierflds[i].Name)));
               if(i==1)
                 f2= FormatField(o, i);//((''+c.get(conHierflds[i].Name))==''+null?'':(''+c.get(conHierflds[i].Name)));
               if(i==2)
                 f3= FormatField(o, i);//((''+c.get(conHierflds[i].Name))==''+null?'':(''+c.get(conHierflds[i].Name)));
               if(i==3)
                 f4= FormatField(o, i);//((''+c.get(conHierflds[i].Name))==''+null?'':(''+c.get(conHierflds[i].Name)));
               if(i==4)
                 f5= FormatField(o, i);//((''+c.get(conHierflds[i].Name))==''+null?'':(''+c.get(conHierflds[i].Name)));
               if(i==5)
                 f6= FormatField(o, i);//((''+c.get(conHierflds[i].Name))==''+null?'':(''+c.get(conHierflds[i].Name)));
               if(i==6)
                 f7= FormatField(o, i);//((''+c.get(conHierflds[i].Name))==''+null?'':(''+c.get(conHierflds[i].Name)));
               if(i==7)
                 f8= FormatField(o, i);//((''+c.get(conHierflds[i].Name))==''+null?'':(''+c.get(conHierflds[i].Name)));
               if(i==8)
                 f9= FormatField(o, i);//((''+c.get(conHierflds[i].Name))==''+null?'':(''+c.get(conHierflds[i].Name)));
               if(i==9)
                 f10= FormatField(o, i);//((''+c.get(conHierflds[i].Name))==''+null?'':(''+c.get(conHierflds[i].Name)));  
            /*
                   if(i==0){
                     //If Field is close date, then format the date to MM/DD/YYYY
                     if(oppHierflds[i].Name=='CloseDate'){
                       f1=''+o.get(oppHierflds[i].Name);                       
                       f1=f1.trim().substring(0,10);
                     }else
                     f1=((''+o.get(oppHierflds[i].Name))==''+null?'':(''+o.get(oppHierflds[i].Name)));                  
                   }
                   if(i==1){
                     if(oppHierflds[i].Name=='CloseDate'){
                       f2=''+o.get(oppHierflds[i].Name);                       
                       f2=f2.trim().substring(0,10);
                     }else
                       f2=((''+o.get(oppHierflds[i].Name))==''+null?'':(''+o.get(oppHierflds[i].Name)));
                   }
                   if(i==2){
                     if(oppHierflds[i].Name=='CloseDate'){
                       f3=''+o.get(oppHierflds[i].Name);                       
                       f3=f3.trim().substring(0,10);
                     }else
                      f3=((''+o.get(oppHierflds[i].Name))==''+null?'':(''+o.get(oppHierflds[i].Name)));
                   }
                   if(i==3){
                     if(oppHierflds[i].Name=='CloseDate'){
                       f4=''+o.get(oppHierflds[i].Name);                       
                       f4=f4.trim().substring(0,10);
                     }else
                      f4=((''+o.get(oppHierflds[i].Name))==''+null?'':(''+o.get(oppHierflds[i].Name)));
                   }
                   if(i==4){
                     if(oppHierflds[i].Name=='CloseDate'){
                       f5=''+o.get(oppHierflds[i].Name);                       
                       f5=f5.trim().substring(0,10);
                     }else
                      f5=((''+o.get(oppHierflds[i].Name))==''+null?'':(''+o.get(oppHierflds[i].Name)));
                   }
                   if(i==5){
                     if(oppHierflds[i].Name=='CloseDate'){
                       f6=''+o.get(oppHierflds[i].Name);                       
                       f6=f6.trim().substring(0,10);
                     }else
                       f6=((''+o.get(oppHierflds[i].Name))==''+null?'':(''+o.get(oppHierflds[i].Name)));
                   }
                   if(i==6){
                     if(oppHierflds[i].Name=='CloseDate'){
                       f7=''+o.get(oppHierflds[i].Name);                       
                       f7=f7.trim().substring(0,10);
                     }else
                       f7=((''+o.get(oppHierflds[i].Name))==''+null?'':(''+o.get(oppHierflds[i].Name)));
                   }
                   if(i==7){
                     if(oppHierflds[i].Name=='CloseDate'){
                       f8=''+o.get(oppHierflds[i].Name);                       
                       f8=f8.trim().substring(0,10);
                     }else
                       f8=((''+o.get(oppHierflds[i].Name))==''+null?'':(''+o.get(oppHierflds[i].Name)));
                   }
                   if(i==8){
                     if(oppHierflds[i].Name=='CloseDate'){
                       f9=''+o.get(oppHierflds[i].Name);                       
                       f9=f9.trim().substring(0,10);
                     }else
                       f9=((''+o.get(oppHierflds[i].Name))==''+null?'':(''+o.get(oppHierflds[i].Name)));
                   }
                   if(i==9){
                     if(oppHierflds[i].Name=='CloseDate'){
                       f10=''+o.get(oppHierflds[i].Name);                       
                       f10=f10.trim().substring(0,10);
                     }else
                       f10=((''+o.get(oppHierflds[i].Name))==''+null?'':(''+o.get(oppHierflds[i].Name)));                  
                   }
                   */
              } 
              opp=o;    
        }
        
        private String FormatField(sObject FormatObject, Integer FieldNumber)
        {
            if(FieldNumber < -1 || FieldNumber >= oppHierflds.size())
                return '';
            
            Schema.DescribeFieldResult FieldResults = OpportunityFieldMap.get(oppHierflds[FieldNumber].Name).getDescribe();
            
            if(FieldResults.getType() == Schema.DisplayType.Date || FieldResults.getType() == Schema.DisplayType.DateTime)
            {
                DateTime FomratDate = (DateTime) FormatObject.get(oppHierflds[FieldNumber].Name); 
                return String.valueOf(FomratDate.format('MM/dd/yyyy'));
            }
            else if(FieldResults.getType() == Schema.DisplayType.Currency)
            {
                String UnformattedCurrency = String.valueOf(FormatObject.get(oppHierflds[FieldNumber].Name));
                String FormattedCurrency = (Decimal.valueOf(UnformattedCurrency == null || 
                    UnformattedCurrency.trim() == '' ? '0' : UnformattedCurrency).setScale(2) + 0.001 ).format();
                
                return '$' + FormattedCurrency.substring(0, FormattedCurrency.length() - 1);
            }
            else if(FieldResults.getType() == Schema.DisplayType.Boolean)
                return (Boolean) FormatObject.get(oppHierflds[FieldNumber].Name) ? 'True' : '';
            
            return String.valueOf(FormatObject.get(oppHierflds[FieldNumber].Name));
        }          
      }
      
      /*
        This method is invoked when user clicks on any one of the columns on the contacts tab.
        This method sorts the contact list based on the column name that is clicked.
      */
      public void sortTable(){
          setcon=null;
           List<Double> lst=new List<Double>();
        Map<Double,Hierarchy_Fields__c> mapConHierflds=new Map<Double,Hierarchy_Fields__c>();
     
        
            for(integer i=0;i<hierFlds.size();i++)
                if(hierFlds[i].Object_Name__c=='Contact')
                  mapConHierflds.put(hierFlds[i].Sort_Order__c,hierFlds[i]);
                
        lst.addall(mapConHierflds.keySet());
        lst.sort();
        for(Double d:lst)
          conHierflds.add(mapConHierflds.get(d));
        lst.clear();
                        
         
          String paramvalue=Apexpages.currentpage().getParameters().get('sortField');
          for(integer i=0;i<conHierflds.size();i++)
              if(conHierflds[i].Field_label__c==paramvalue)
                  sortExpression=conHierflds[i].name;
                  
           if(paramvalue=='name')
              sortExpression='name';
           else if(paramvalue=='account.name')
              sortExpression='account.name';
            
         if(sortDirection=='asc')
              sortDirection='desc';
         else
              sortDirection='asc'; 
         qryCon = 'select name,AccountId,Account.Name'; 
         
         if(sortDirection=='asc') 
            nullsLast='';
         else
            nullsLast='Nulls Last';             
      }
      
      //Set Controller for all the contacts in the account hierarchy.
      
      public ApexPages.StandardSetController setopp{
        get {
            if(setopp== null) {
               for(integer i=0;i<oppHierflds.size();i++){
                
                   qryOpp+=','+oppHierflds[i].Name;
                   
                   if(i==0)
                     oppLb1=(oppHierflds[i].Field_Label__c==null?'':oppHierflds[i].Field_Label__c);
                   if(i==1)
                     oppLb2=(oppHierflds[i].Field_Label__c==null?'':oppHierflds[i].Field_Label__c);
                   if(i==2)
                     oppLb3=(oppHierflds[i].Field_Label__c==null?'':oppHierflds[i].Field_Label__c);
                   if(i==3)
                     oppLb4=(oppHierflds[i].Field_Label__c==null?'':oppHierflds[i].Field_Label__c);
                   if(i==4)
                     oppLb5=(oppHierflds[i].Field_Label__c==null?'':oppHierflds[i].Field_Label__c);
                   if(i==5)
                     oppLb6=(oppHierflds[i].Field_Label__c==null?'':oppHierflds[i].Field_Label__c);
                   if(i==6)
                     oppLb7=(oppHierflds[i].Field_Label__c==null?'':oppHierflds[i].Field_Label__c);
                   if(i==7)
                     oppLb8=(oppHierflds[i].Field_Label__c==null?'':oppHierflds[i].Field_Label__c);
                   if(i==8)
                     oppLb9=(oppHierflds[i].Field_Label__c==null?'':oppHierflds[i].Field_Label__c);
                     
                   if(i==9)
                     oppLb10=(oppHierflds[i].Field_Label__c==null?'':oppHierflds[i].Field_Label__c);                   
              }     
                 
              qryOpp+=' from Opportunity where AccountId in: AccIds order by '+sortExpression+'  '+sortDirection+' '+nullsLast+' limit 800';
              setopp= new ApexPages.StandardSetController(Database.getQueryLocator(qryOpp));
            }           
            return setopp;
        }
        set;
      }
      
       /*
        This method is invoked when user clicks on any one of the columns on the opportunities tab.
        This method sorts the opportunity list based on the column name that is clicked.
      */
      public void sortOppTable(){
          setopp=null;
          
        List<Double> lst=new List<Double>();
        Map<Double,Hierarchy_Fields__c> maOppHierflds=new Map<Double,Hierarchy_Fields__c>();
        
            for(integer i=0;i<hierFlds.size();i++)
               if(hierFlds[i].Object_Name__c=='Opportunity')
                 maOppHierflds.put(hierFlds[i].Sort_Order__c,hierFlds[i]);
              
        lst.addall(maOppHierflds.keySet());
        lst.sort();
        for(Double d:lst)
          oppHierflds.add(maOppHierflds.get(d));
          
          String paramvalue=Apexpages.currentpage().getParameters().get('oppSortField');
          for(integer i=0;i<oppHierflds.size();i++)
              if(oppHierflds[i].Field_label__c==paramvalue)
                  sortExpression=oppHierflds[i].name;
           
         if(paramvalue=='name')
              sortExpression='name';
         else if(paramvalue=='account.name')
              sortExpression='account.name';
               
            
         if(sortDirection=='asc')
              sortDirection='desc';
         else
              sortDirection='asc'; 
         qryOpp = 'select name,AccountId,ownerId,owner.name,Account.Name'; 
         
         if(sortDirection=='asc') 
            nullsLast='';
         else
            nullsLast='Nulls Last' ;
      }
      
      /*
         This method is invoked when user clicks on 'Customize columns' link on the hierarchy page on any one
         of the following tabs: Account,Contact and Opportunity.
         This method helps in rendering the available fields for account,contact or opportunity on the page.The 
         available fields can be selected for customizable columns feature.
      */
      
      public void showComponent(){
        showComponent=true;
      }
  
}