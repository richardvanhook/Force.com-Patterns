global class FirstBatch implements Database.Batchable<SObject>,Database.Stateful{
	private Integer mode;
	global FirstBatch(Integer mode){
		this.batchMode=mode;
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC){
		//Execute your query
	}
	global void execute(Database.BatchableContext BC, List<sObject> scope){
		//Process each batch of records
	}
	global void finish(Database.BatchableContext BC){
		
		//Do any cleanup process for FirstBatch
		
		//Send any notifications

		//Schedule the next batch to execute 1 minute after the current one ends.
		//1. Create the cron expression
		String scheduleString='0';//0 seconds
		Datetime currTime = System.now();
		currTime = currTime.addMinutes(1);
		scheduleString+=' '+currTime.minute();
		scheduleString+=' '+currTime.hour();
		scheduleString+=' '+currTime.day();
		scheduleString+=' '+currTime.month();
		scheduleString+=' ?';
		scheduleString+=' '+currTime.year();
		
		//2. Create a good jobname
		//Create a job name that is easy to monitor
		String jobName = 'MYBATCH-'+System.now().format('MM-dd-yyyy-hh:');
		
		//2. Schedule the job to run
		BatchSchedular stsUpdate = new BatchSchedular(BAtchScheduler.STEP_2);
		System.schedule(jobName,scheduleString,stsUpdate);
	} 
	
}