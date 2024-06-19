@isTest
public class ReportBatchSchedulerTest {
	@isTest
    static void testExportReport() {
        Case testCase = new Case(Status = 'New', Origin = 'Email');
        insert testCase;

        Test.startTest();
        ReportBatchScheduler.exportReport();
        Test.stopTest();

        List<String> expectedEmails = ReportBatchScheduler.getMailAddresses();
        String actualEmail = 'rachellizandra@outlook.com';
        System.assertEquals(expectedEmails[0], actualEmail);
    }
}