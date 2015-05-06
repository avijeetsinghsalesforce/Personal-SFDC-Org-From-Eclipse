@isTest
private Class TestClass_AccountHierarchyTabController{

 public static TestMethod void accoutHierarchyTest(){
    Account a=new Account(Name='Parent Account');
    insert a;
    Account a1=new Account(Name='Child Account',ParentId=a.id);
    insert a1;
    Contact c=new Contact(LastName='Test Contact',AccountId=a.id);
    insert c;
    Opportunity op=new Opportunity(Name='Test Oportunity',AccountId=a.id,StageName='1 - Prospect Qualification',CloseDate=system.today()+20);
    insert op;
    List<Hierarchy_Fields__c> cstSetLst=new List<Hierarchy_Fields__c>();
    List<Hierarchy_Fields__c> toDel=new List<Hierarchy_Fields__c>();
    for(integer i=0;i<30;i++){
       String lb='',nm='',obj='';
       
       if(i==0){
         lb='Website';
         nm='Website';
       }else if(i==1){
         lb='Type';
         nm='Type';         
       }else if(i==2){
         lb='Ticker Symbol';
         nm='TickerSymbol';         
       }else if(i==3){
         lb='SIC Code';
         nm='SIC';   
       }else if(i==4){
         lb='Employees';
         nm='NumberOfEmployees';                 
       }else if(i==5){
         lb='Rating';
         nm='Rating';         
       }else if(i==6){
         lb='Phone';
         nm='Phone';         
       }else if(i==7){
         lb='Fax';
         nm='Fax';         
       }else if(i==8){
         lb='Industry';
         nm='Industry';         
       }else if(i==9){
         lb='Description';
         nm='Description';         
       }else if(i==10){
         lb='Assistant';
         nm='AssistantName';
       }else if(i==11){
         lb='Birthdate';
         nm='BirthDate';         
       }else if(i==12){
         lb='Email';
         nm='Email'; 
       }else if(i==13){
         lb='Fax Opt Out';
         nm='HasOptedOutOfFax';                   
       }else if(i==14){
         lb='Department';
         nm='Department';         
       }else if(i==15){
         lb='Title';
         nm='Title';         
       }else if(i==16){
         lb='Other Phone';
         nm='OtherPhone';         
       }else if(i==17){
         lb='Asst.Phone';
         nm='AssistantPhone';         
       }else if(i==18){
         lb='Home Phone';
         nm='HomePhone';         
       }else if(i==19){
         lb='Last CU Update Date';
         nm='LastCUUpdateDate';         
       }else if(i==20){
         lb='ForecastCategory';
         nm='ForecastCategoryName';
       }else if(i==21){
         lb='LastModifiedBy';
         nm='LastModifiedById';         
       }else if(i==22){
         lb='Next Step';
         nm='NextStep';         
       }else if(i==23){
         lb='Expected Revenue';
         nm='ExpectedRevenue';         
       }else if(i==24){
         lb='Stage';
         nm='StageName';         
       }else if(i==25){
         lb='Private';
         nm='isPrivate';         
       }else if(i==26){
         lb='Quantity';
         nm='TotalOpportunityQuantity';         
       }else if(i==27){
         lb='Probability(%)';
         nm='Probability';         
       }else if(i==28){
         lb='CreatedBy';
         nm='CreatedById';         
       }else if(i==29){
         lb='Lead Source';
         nm='LeadSource';         
       }
        
        if(i<10)
         obj='Account';
        else if(i<20)
         obj='Contact'; 
        else 
         obj='Opportunity'; 
         
        Hierarchy_Fields__c hf=new Hierarchy_Fields__c(Name=nm,Object_Name__c=obj,Field_Label__c=lb,Sort_Order__c=i);
        cstSetLst.add(hf);       
    }
    toDel=[select id from Hierarchy_Fields__c];
    delete toDel;
    Database.saveResult[] sr=Database.insert(cstSetLst,true); 
      
    ApexPages.StandardController cont=new ApexPages.StandardController(a);
    Pagereference p = Page.AccountHierarchy_TabPage;
    Test.setcurrentpage(p);
    Apexpages.currentPage().getParameters().put('id',a.id);
    AccountHierarchyTabController tabCont=new AccountHierarchyTabController(cont);    
    tabCont.AccIds.add(a.id);
    tabCont.getContacts();
    tabCont.getOpportunity();    
    tabCont.sortTable();
    tabCont.sortOppTable();
    //tabCont.next();
   // tabCont.previous();
    tabCont.showComponent();
    
    // HierarchyComponentController Methods
   HierarchyComponentController hierComp=new HierarchyComponentController();
   
    hierComp.accountNodes=null;
    hierComp.showColumns();
    hierComp.currentAccountId = a.id;
    HierarchyComponentController.AccountNode hierNode=new HierarchyComponentController.AccountNode(a);
    List<HierarchyComponentController.AccountNode> listnode;
    hierComp.accountNodes=listnode;
    listnode=new List<HierarchyComponentController.AccountNode>();
  
    listnode.add(hierNode);
    List<HierarchyComponentController.AccountNode> nodeslist= hierComp.accountNodes;
    hierComp.createChildrenAccountsNodes( listnode);
    hierComp.serializeAndAddFormat(hierNode,' ');
    
    //SortColumns Class Methods
    
    SortColumns sc=new SortColumns();
    sc.objSelected='Account';
    sc.getOrderLst();
    sc.OrderColumns();
    sc.Cancel();
  }

}