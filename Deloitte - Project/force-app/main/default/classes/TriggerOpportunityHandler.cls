public with sharing class TriggerOpportunityHandler {
    public static void run() {
        List<Opportunity> newList = (List<Opportunity>) Trigger.new;
        Map<Id, Opportunity> oldMap = (Map<Id, Opportunity>) Trigger.oldMap;

        if(Trigger.isAfter && Trigger.isInsert){
            enviarEmailAvisoCadastro(newList);
        } 
    }

    private static void enviarEmailAvisoCadastro(List<Opportunity> newList){
        Set<Id> setIds = new Set<Id>();
        EmailConfig emailConfig = new EmailConfig();
        emailConfig.orgEmailAddress = [SELECT Id, Address, DisplayName FROM OrgWideEmailAddress WHERE DisplayName = 'Principal'];
        
        if(!newList.isEmpty()){
            Id recordType = Schema.Opportunity.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Novo_Cliente').getRecordTypeId();
            for(Opportunity opp : newList){
                if(opp.RecordTypeId == recordType || opp.Tipo__c == 'Novo Cliente'){
                    setIds.add(opp.AccountId);
                }
            }
        }
        
        Map<Id, Account> mapContas = new Map<Id, Account>([SELECT Id, Numero_de_Oportunidades__c, Numero_Opps__c, Owner.Email, (SELECT Id FROM Opportunities) FROM Account WHERE Id IN :setIds]);
        
        if(!mapContas.isEmpty()){
            for(Account acc : mapContas.values()) {
                acc.Numero_Opps__c = acc.Opportunities.size();
            }
            
            update mapContas.values();
        }
        
        emailConfig.et = [SELECT Id, Subject, Body FROM EmailTemplate WHERE DeveloperName ='Email_Novo_Cliente'];            
        
        if(!mapContas.isEmpty()){
            for(Opportunity opp : newList){
                Account conta = mapContas.get(opp.AccountId);
                System.debug('Está entrando aqui!! 1');
                if(mapContas.containsKey(opp.AccountId) && conta.Numero_Opps__c == 1){
                  	emailConfig.whatId = opp.Owner.Id;
                    emailConfig.targetId = conta.OwnerId;
                    emailConfig.email = mapContas.get(opp.AccountId).Owner.Email;
                    System.debug('Email: ' + mapContas.get(opp.AccountId).Owner.Email);
                    EmailUtils.sendEmail(new List<String>{ emailConfig.email }, null, emailConfig.orgEmailAddress, emailConfig.et.Id, emailConfig.whatId, emailConfig.targetId); 
                }         
            }
        }
    
    }

    public class EmailConfig {
        EmailTemplate et;
        OrgWideEmailAddress orgEmailAddress;
        String whatId;
        String targetId;
        String email;
    }
}