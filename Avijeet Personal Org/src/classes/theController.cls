public class theController{
public string out{
get{
system.debug('----getter enter----'+out);
if(out!=null){out='comment';}
system.debug('----getter exit----'+out);
return out;
}
Set{
system.debug('----setter enter----'+out+'--with value--'+value);
Out='abc';
}
}
public string b{get;set;}
Public thecontroller(){
system.debug('----enter controller----'+out);
Out='controller';
Out='c';
Out='d';
Out='e';
b='test';
system.debug('----exit controller----'+out);
}
}