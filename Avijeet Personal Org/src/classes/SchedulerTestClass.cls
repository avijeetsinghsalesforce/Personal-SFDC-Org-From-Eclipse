@isTest
public class SchedulerTestClass{
    @isTest
    static void testInstallScript() {
    PostInstallClass postinstall = new PostInstallClass();
    Test.testInstall(postinstall,null);    
    }
    @isTest
    static void testScheduler() {
       Test.startTest();
       Datetime sysTime = System.now().addSeconds( 300 );      
       String chronExpression = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
       System.schedule( 'SelfSchedule ' + sysTime, chronExpression, new SelfSchedule() );   
       Test.stopTest();
    }
    @isTest
    static void testScheduler1() {
       Test.startTest();
       SelfSchedule.start(); 
       Test.stopTest();
    }
    
}