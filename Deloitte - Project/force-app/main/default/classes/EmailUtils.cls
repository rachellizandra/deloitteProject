public with sharing class EmailUtils {
    public static Messaging.SingleEmailMessage sendEmail(List<String> toAddresses, List<String> ccAddresses, OrgWideEmailAddress orgWideEmailAddress, Id templateId, Id whatId, Id targetObjectId, /*List<Messaging.EmailFileAttachment> anexos,*/ User usuario ) {
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(toAddresses);        
        email.setTreatTargetObjectAsRecipient(false);
        email.setSaveAsActivity(false);
        email.setTemplateId(templateId);
        
        if( ccAddresses != null && ccAddresses.size() > 0 ) {
            email.setCcAddresses( ccAddresses );
        }
        
        if( orgWideEmailAddress == null ) {
            email.setSenderDisplayName( usuario.Name );
            email.setReplyTo(usuario.Email);
        } else {
            email.setOrgWideEmailAddressId(orgWideEmailAddress.Id);
        }
        if( whatId != null ) {
            email.setWhatId( whatId );
        }
        
        if( targetObjectId != null ) {
            email.setTargetObjectId( targetObjectId );
        }
        
        //email.setFileAttachments( anexos );
        return email;
    }
    
    public static void sendEmail(List<String> toAddresses, List<String> ccAddresses, OrgWideEmailAddress orgWideEmailAddress, Id templateId, Id whatId, Id targetObjectId/*, List<Messaging.EmailFileAttachment> anexos */) {
        User usuario = [Select Id, Name, Email from User where Id = :UserInfo.getUserId()];
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(toAddresses);  
        email.setSaveAsActivity(false);
        email.setTreatTargetObjectAsRecipient(false);
        email.setTemplateId(templateId);
        
        if( ccAddresses != null && ccAddresses.size() > 0 ) {
            email.setCcAddresses( ccAddresses );
        }
        
        if( orgWideEmailAddress == null ) {
            email.setSenderDisplayName( usuario.Name );
            email.setReplyTo(usuario.Email);
        } else {
            email.setOrgWideEmailAddressId(orgWideEmailAddress.Id);
        }
        if( whatId != null ) {
            email.setWhatId( whatId );
        }
        
        if( targetObjectId != null ) {
            email.setTargetObjectId( targetObjectId );
        }
        
        //email.setFileAttachments( anexos );
        
        if( !Test.isRunningTest() ) {
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        }		
        
    }
}