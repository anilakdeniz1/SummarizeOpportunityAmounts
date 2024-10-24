/** 
* @author Sami Anıl Akdeniz <anilakdeniz1@gmail.com>
* @date 24/10/2024
* @description Contains test methods for creating sObjects
*/
@isTest
public with sharing class TestUtility {
   
    public static Account createAccount() {
        
        Account anAccount = new Account(
            Name = 'Test Account',
            Type = 'Customer',
            Industry = 'Technology',
            Phone = '123-456-7890',
            Email = 'test_account@test.com'
        );

        insert anAccount;
        
        return anAccount;
    }

    public static Contact createContact() {

        Contact aContact = new Contact(
            AccountId = testAcc.Id,
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'test@example.com',
            Is_Primary_Contact__c = true
        );

        insert aContact;

        return aContact;
    }

    public static List<Opportunity> createOpportunities(Integer count,Id accountId) {

        List<Opportunity> opportunities = new List<Opportunity>();
        for (Integer i=0; i<count; i++) {
            Opportunity anOpportunity = new Opportunity(
                AccountId = accountId,
                Name = 'Test Opportunity ' + i,
                StageName = 'Open',
                Amount = 10000 + (i * 10000),
                CloseDate = Date.today().addDays(i)
            );
            opportunities.add(testOpp);
        }

        insert opportunities;

        return opportunities;
    }
}