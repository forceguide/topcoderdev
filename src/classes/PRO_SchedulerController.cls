global class PRO_SchedulerController implements Schedulable {

    // interface method
    global void execute(SchedulableContext sc) {
        
        // get the social media data
        PRO_BatchController batch = new PRO_BatchController();
		if (!Test.isRunningTest()) Database.executebatch(batch,10);
        
        // Schedule the next job
        System.schedule('Scheduler Controller'+System.now(),'0 0 0-23 ? * *',new PRO_SchedulerController());
    }
}