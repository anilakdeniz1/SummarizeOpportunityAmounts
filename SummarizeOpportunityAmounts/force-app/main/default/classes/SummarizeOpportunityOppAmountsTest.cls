/** 
* @author Sami Anıl Akdeniz <anilakdeniz1@gmail.com>
* @date 24/10/2024
* @description Test class for SummarizeOpportunityOppAmounts
*/
public with sharing class SummarizeOpportunityOppAmountsTest {
   
    /** 
    * @descritpion Test method for whether the batch executes or not
    */ 
    @isTest
    static void checkBatchExecuted() {
        
        Test.startTest();
        SummarizeAllOppAmountsBatch batch = new SummarizeAllOppAmountsBatch();
        Id jobId = Database.executeBatch(batch);
        Test.stopTest();

        System.assertNotEquals(null, jobId, 'Batch should be executed.');
    }

    /** 
    * @descritpion Test method for getting opp amounts by stages
    */ 
    @isTest
    private static void getOpportunitySummaryAmounts() {
        Account anAccount = TestUtility.createAccount();
        List<Account> accounts = new List<Account> {anAccount};

        Test.startTest();
        List<Map<Id, Decimal>> summarizedMaps = SummarizeAllOppAmounts.summarizeAllOppAmounts(accounts);
        Test.stopTest();

        System.assertEquals(3, summarizedMaps.size(), 'There should be 3 maps.');

         for (Integer i=0; i<3; i++) {   
            Map<Id, Decimal> accMap = new Map<Id, Decimal>();     
            if (i == 0) {
                accMap = summarizedMaps[i];
                System.assertEquals(150000, accMap.get(acc.Id), 'Amount should be 60000.');
            }else if(i == 1) {
                accMap = summarizedMaps[i];
                System.assertEquals(60000, accMap.get(acc.Id), 'Amount should be 150000.');
            }else if(i == 2) {
                accMap = summarizedMaps[i];
                System.assertEquals(340000, accMap.get(acc.Id), 'Amount should be 340000.');
            }
         }
    }
    
    /** 
    * @descritpion Test method for testing whether the email is sent or not
    */ 
    @isTest
    private static void sendEmail_whenStagesAreWonLostOpen(){
      
        Account anAccount = new Account();
        
        Map<Id, Decimal> testMap1 = new Map<Id, Decimal>{acc.Id => 100000};
        Map<Id, Decimal> testMap2 = new Map<Id, Decimal>{acc.Id => 200000};
        Map<Id, Decimal> testMap3 = new Map<Id, Decimal>{acc.Id => 300000};

        List<Map<Id, Decimal>> listOfMaps = new List<Map<Id, Decimal>>{testMap1, testMap2, testMap3};

        Test.startTest();
        SummarizeAllOppAmountsHandler.sendEmail(listOfMaps);
        Integer invocations = Limits.getEmailInvocations();
        Test.stopTest();

        System.assertEquals(1, invocations, '1 Email should be sent.');      
    }
}