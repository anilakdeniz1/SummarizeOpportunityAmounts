/** 
* @author Sami Anıl Akdeniz <anilakdeniz1@gmail.com>
* @date 24/10/2024
* @description Handler class for SummarizeAllOppAmountsBatch Class
* Test Class : SummarizeAllOppAmountsHandlerTest
* Test Class Coverage : %100
*/
public with sharing class SummarizeOpportunityAmountHandler {

    public static Map<Id, Decimal> totalClosedWonAmountByAccountId = new Map<Id, Decimal>();
    public static Map<Id, Decimal> totalOpenAmountByAccountId = new Map<Id, Decimal>();
    public static Map<Id, Decimal> totalClosedLostAmountByAccountId = new Map<Id, Decimal>();
    public static List<Map<Id, Decimal>> accAmountMaps = new List<Map<Id, Decimal>>();
    public static List<Account> accounts = new List<Account>();

    /**
    * @description A method that gets the total amount of closed won, closed lost and open
    * @param accList List<Account>
    */
    public static List<Map<Id,Decimal>> summarizeAllOpportunityAmount(List<Account> accList) {

        for (Account acc : accList) {
            Decimal closedWonOppAmount = 0;
            Decimal openOppAmount = 0;
            Decimal closedLostOppAmount = 0;
            for (Opportunity opp : acc.Opportunities) {
                if (opp.Amount > 0 && opp.StageName == 'Closed Won'){
                    if (opp.StageName == 'Closed Won') {

                        if (!totalClosedWonAmountByAccountId.containsKey(acc.Id)) {
                            totalClosedWonAmountByAccountId.put(acc.Id, 0);
                        }
                        
                        closedWonOppAmount += opp.Amount;
                        totalClosedWonAmountByAccountId.put(acc.Id, closedWonOppAmount);

                    } else if(opp.StageName == 'Closed Lost') {

                        if (!totalClosedLostAmountByAccountId.containsKey(acc.Id)) {
                            totalClosedLostAmountByAccountId.put(acc.Id, 0);
                        }
                        
                        closedLostOppAmount += opp.Amount;
                        totalClosedLostAmountByAccountId.put(acc.Id, closedLostOppAmount);

                    }else if(opp.StageName == 'Open') {

                        if (!totalOpenAmountByAccountId.containsKey(opp.AccountId)) {
                            totalOpenAmountByAccountId.put(opp.AccountId, 0);
                        }

                        openOppAmount += opp.Amount;
                        totalOpenAmountByAccountId.put(opp.AccountId, openOppAmount);

                    }
                }  
            }
        }
        accAmountMaps.add(totalClosedWonAmountByAccountId);
        accAmountMaps.add(totalOpenAmountByAccountId);
        accAmountMaps.add(totalClosedLostAmountByAccountId);
        return accAmountMaps;
    }

    public static void sendEmail(List<Map<Id, Decimal>> mapsList) {

        accounts = [SELECT Id, Name, (SELECT Id, FirstName, LastName, Email FROM Contacts WHERE Is_Primary_Contact__c = true) 
                                      FROM Account
                                      WITH SECURITY_ENFORCED];
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();

        for (Account acc : accounts) {
            if (acc.Contacts != null && acc.Contacts.size() > 0) {
                for (Contact con : acc.Contacts) {
                    
                    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();

                    String emailBody = 'Hello ' + conObj.FirstName + ' ' + conObj.LastName   + ' from ' + acctObj.Name + ',<br><br>';
                    emailBody += 'Below is a table of opportunities related to the account :' + acctObj.Name + '. <br><br>'; 
                    emailBody += '<table border="1"><tr><th style="background-color: #f2f2f2;">Account</th><th style="background-color: #f2f2f2;">Stage</th><th style="background-color: #f2f2f2;">Amount</th></tr>';
                    emailBody += '<tr><td>' + acctObj.Name + '</td><td>Open</td><td>' + mapsList[1].get(acctObj.Id) + '</td></tr>';
                    emailBody += '<tr><td>' + acctObj.Name + '</td><td>Closed Won</td><td>' + mapsList[0].get(acctObj.Id) + '</td></tr>';
                    emailBody += '<tr><td>' + acctObj.Name + '</td><td>Closed Lost</td><td>' + mapsList[2].get(acctObj.Id) + '</td></tr></table>';

                    email.setSubject('Opportunity Summary for ' + Date.today().month() + '/' + Date.today().year());

                    if (con.Email != null && con.Email != '') {
                        String emailAdress = con.Email;
                        String[] to = new string[] {emailAdress};
                        email.setToAddresses(to);
                        email.setHtmlBody(emailBody);
                        emails.add(email);
                    }
                }
            }
        }

        if (emails.size() > 0) {
            Messaging.sendEmail(emails);
        }
    } 
}