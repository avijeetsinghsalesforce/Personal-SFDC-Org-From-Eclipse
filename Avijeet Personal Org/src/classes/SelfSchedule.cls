global class SelfSchedule implements schedulable
    {    
        global void execute( SchedulableContext SC )
        {        

           ScheduleClassLog__c logRecord = new ScheduleClassLog__c();
           logRecord.Creation_TimeStamp__c = System.now();
           database.insert(logRecord,false);
            
            
                SelfSchedule.start();


            // abort me and start again
            System.abortJob( SC.getTriggerId() );
        }

        public static void start()
        {
            // start keepalive again in 5 mins
            Datetime sysTime = System.now().addSeconds( 300 );      
            String chronExpression = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
            System.schedule( 'SelfSchedule ' + sysTime, chronExpression, new SelfSchedule() );
        }        
        

    }