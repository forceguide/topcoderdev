@isTest
public with sharing class PRO_SchedulerControllerTest {
	
	// Test query Log Scheduler class without batch
	static testMethod void test_SchedulerWithoutBatch() {
		Test.startTest();

		// Schedule the test job
        String strSchedule = '0 0 0 3 9 ? 2014';
        
		String jobId = System.schedule('PRO_SchedulerController'+system.now(), strSchedule, new PRO_SchedulerController());

		// Get the information from the CronTrigger API object
		CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];

		 // Verify the expressions are the same
      	System.assertEquals(strSchedule, ct.CronExpression);
      	
      	// Verify the job has not run
     	System.assertEquals(0, ct.TimesTriggered);
     	System.assert(ct.TimesTriggered != 1);

		Test.stopTest();
	}
}