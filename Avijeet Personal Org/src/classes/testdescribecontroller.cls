public class testdescribecontroller {
    public Map<String,Schema.sObjectType> gd{get;set;}
    
    public testdescribecontroller (){
        Map<String,Schema.sObjectType> gd = Schema.getGlobalDescribe();
        for (String s: gd.keyset())
            {
                System.debug('--obj name--'+s);
            }
        system.debug('---total objects---'+gd.keyset().size());
    }
}