This feature calculates the number of related opportunities for accounts and automatically sends an email that includes a data table to their primary contacts.

-Scheduler-

/*Script for shcedule the batch
    // Every 10:00 AM
    String dailyCron = '0 0 10 * * ?';
    System.schedule('Daily Job', dailyCron, new ScheduleSummarizeAllOppAmountsBatch());

    // Every Friday at 1:00 PM
    String weeklyCron = '0 0 13 ? * FRI';
    System.schedule('Weekly Job', weeklyCron, new ScheduleSummarizeAllOppAmountsBatch());

    // Last Friday of the month at 6:00 PM
    String monthlyCron = '0 0 18 ? * 6L';
    System.schedule('Monthly Job', monthlyCron, new ScheduleSummarizeAllOppAmountsBatch());*/
