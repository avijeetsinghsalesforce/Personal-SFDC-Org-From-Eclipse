global class PostInstallClass implements InstallHandler {
  global void onInstall(InstallContext context) {
    if(context.previousVersion() == null) {
        Datetime sysTime = System.now().addSeconds( 300 );      
        String chronExpression = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        System.schedule( 'SelfSchedule' + sysTime, chronExpression, new SelfSchedule() ); 
    }
  }
}