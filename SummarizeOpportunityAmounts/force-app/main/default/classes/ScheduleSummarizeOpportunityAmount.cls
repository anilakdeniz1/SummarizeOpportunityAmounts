/** 
* @author Sami Anıl Akdeniz <anilakdeniz1@gmail.com>
* @date 24/10/2024
* @description Schedule class for SummarizeAllOppAmountsBatch Class
* Test Class : ScheduleSummarizeOpportunityAmountsBatchTest
* Test Class Coverage : %100
*/
public class ScheduleSummarizeOpportunityAmounts implements Schedulable {
    /**
    * @description Scheduleable method for SummarizeOpportunityAmountsBatch
    * @param SchedulableContext sc
    */ 
    public void execute(SchedulableContext sc) {
        SummarizeAllOppAmountsBatch batch = new SummarizeAllOppAmountsBatch();
    }
}