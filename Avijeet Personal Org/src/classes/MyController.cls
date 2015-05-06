public without sharing class MyController {
  Account account;
  public static integer abc{get;set;}
  public integer cde{get;set;}
  public Map<id, Account> accounts {get;set;}
   
  public PageReference save() {
    try{
        update account;
       }
    catch(DmlException ex){
        ApexPages.addMessages(ex);
       }
    return null;
  }
    
  public MyController ()    {
      abc=1;
      cde=1;
      accounts = new Map<Id, Account>([SELECT Id,name FROM ACCOUNT]);
  }  

  public String getName() {
    return 'MyController';
  }

  public Account getAccount() {
    if(account == null)
      account = [select id, name, numberoflocations__c from Account
        where id = :ApexPages.currentPage().getParameters().get('id')];
      return account;

  }
}