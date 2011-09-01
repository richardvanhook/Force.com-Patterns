global class SecondBatch implements Database.Batchable<SObject>,Database.Stateful{
	
	global Database.QueryLocator start(Database.BatchableContext BC){
		//Execute your query
	}
	global void execute(Database.BatchableContext BC, List<sObject> scope){
		//Process each batch of records
	}
	global void finish(Database.BatchableContext BC){
		
		//Do any cleanup process for FirstBatch
		
		//Send any notifications

	} 
	
}