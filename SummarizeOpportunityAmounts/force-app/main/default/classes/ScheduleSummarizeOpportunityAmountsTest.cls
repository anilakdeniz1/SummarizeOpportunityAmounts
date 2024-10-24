/** 
* @author Sami Anıl Akdeniz <anilakdeniz1@gmail.com>
* @date 24/10/2024
* @description Test class for ScheduleSummarizeAllOppAmountsBatch Class
*/
@isTest
public with sharing class ScheduleSummarizeOpportunityAmountsBatchTest {
    public static String CRON_EXP = '0 2 * * * ?';
    /** 
    * @descritpion Test method for ScheduleSummarizeAllOppAmountsBatch Class
    */ 
    @isTest
    private static void testScheduler() {

        Test.startTest();

        String jobId = System.schedule('Summarize Batch',CRON_EXP, new ScheduleSummarizeAllOppAmountsBatch());

        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered FROM CronTrigger WHERE Id = :jobId];
        
        System.assertEquals(CRON_EXP, ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);
        System.assertEquals(CRON_EXP, ct.CronExpression);
        
        Test.stopTest();
    }
}