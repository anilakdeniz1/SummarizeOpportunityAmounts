/** 
* @author Sami Anıl Akdeniz <anilakdeniz1@gmail.com>
* @date 24/10/2024
* @description Batch class for summarizing opportunity ammounts
* Test Class : SummarizeOpportunityAmountBatchTest
* Test Class Coverage : %100
*/
global with sharing class SummarizeOpportunityAmountBatch implements Database.Batchable<SObject>, Database.Stateful {

   List<Map<Id, Decimal>> summarizedMapsList = new List<Map<Id, Decimal>>();

    /**
    * @description a method that creates a query to the database
    * @param Database.BatchableContext BC
    */ 
    global Datbase.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator([SELECT Id, 
                                        (SELECT Id, AccountId, Amount, StageName FROM Opportunities) 
                                        FROM Account
                                        WITH SECURITY_ENFORCED]);
    }

    /**
    * @description Calls the method that gets the total amount of each opp stages
    * @param Database.BatchableContext BC
    * @param accList List<Account>
    */
    global void execute(Database.BatchableContext BC, List<Account> accList) {
        summarizedMapsList = SummarizeOpportunityAmountHandler.summarizeAllOppAmounts(accList);
    }

    /**
    * @description Calls the method that sends summarized amounts of opp stages to primary contacts. 
    * @param Database.BatchableContext BC
    */
    global void finish(Database.BatchableContext BC) {
        SummarizeOpportunityAmountHandler.sendEmail(summarizedMapsList);
    }
}