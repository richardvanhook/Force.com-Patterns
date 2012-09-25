global class BatchScheduler implements Schedulable{
	private Integer batchMode;
	public static Integer STEP_1=1;
	public static Integer STEP_2=2;
	
   	global BatchScheduler(Integer mode){
    	this.batchMode=mode;
    }
	global void execute(SchedulableContext sc) {
		try {
			//Abort the existing schedule as this is a 1 time scheduled
			//job and should not run again
			CronTrigger ct = [SELECT id,CronExpression,
				   	   TimesTriggered, NextFireTime 
			       	       FROM CronTrigger 
 			       	       WHERE id = :sc.getTriggerId()];
			if (ct != null){
				System.abortJob(ct.Id);
			}
		} catch (Exception e) {
			System.debug('There are no jobs currently scheduled.'); 
		}
		//Call your next Apex Batch class 
		if(batchMode == STEP_2){
			SecondBatch 2ndBatch = new SecondBatch(); 
			Database.executeBatch(2ndBatch);
		}
	}
}