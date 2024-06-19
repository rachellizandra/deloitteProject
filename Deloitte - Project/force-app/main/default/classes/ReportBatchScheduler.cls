global class ReportBatchScheduler implements Schedulable {
    global void execute(SchedulableContext ctx){
      exportReport();
    }
    
    @future(callout=true)
    public static void exportReport() {
        List<Case> casos = [SELECT Id, Status FROM Case WHERE Status != 'Closed'];
        if(!casos.isEmpty()){
            //ApexPages.PageReference objPage = new ApexPages.PageReference('/servlet/PrintableViewDownloadServlet?isdtp=p1&reportId='+reportId);
            //ApexPages.PageReference objPage = new ApexPages.PageReference('/'+reportId+'?csv=1&exp=1&enc=UTF-8&isdtp=p1');
            ApexPages.PageReference report = new ApexPages.PageReference('/00Oak000001gfIPEAY?csv=1&exp=1&enc=UTF-8&isdtp=p1');
            Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
            attachment.setFileName('report.csv');
            attachment.setContentType('text/csv');
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setFileAttachments(new Messaging.EmailFileAttachment[] { attachment } );
            message.setSubject('Open Cases by Status Report from Salesforce');
            message.setPlainTextBody('The report is attached.');
            message.setToAddresses( getMailAddresses() );
            if(!Test.isRunningTest()){
                attachment.setBody(Blob.valueof(report.getContent().toString()));
                Messaging.sendEmail( new Messaging.SingleEmailMessage[] { message } );
            }
        }
    }
    
    public static List<String> getMailAddresses(){
        List<String> idList = new List<String>();
        List<String> mailToAddresses = new List<String>(); 
        
        Group gp = [SELECT (SELECT UserOrGroupId FROM GroupMembers) FROM Group WHERE Name = 'Suporte aos Casos'];
        for (GroupMember gm : gp.GroupMembers) {
            idList.add(gm.UserOrGroupId);
        }
        List<User> userList = [SELECT Email FROM User WHERE Id IN :idList];
        for(User usuario : userList) {
            mailToAddresses.add(usuario.email);
        } 
        return mailToAddresses;
    }
}