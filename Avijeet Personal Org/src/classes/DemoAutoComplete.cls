public class DemoAutoComplete {
    public String accName{get;set;}
    public Id accId{get;set;}
    
    public DemoAutoComplete(){
    
    }
    public PageReference refresh(){
        return null;
    }
    @RemoteAction
    public static list<Account> getAccounts(string s){
        list<Account>accList = new list<Account>();
        if(s != ''){
            String query = 'select name from account where Name like \'' + s + '%\'';
            accList = database.query(query);
        }    
        return accList;
    }
    }