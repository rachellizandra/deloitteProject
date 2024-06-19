@isTest
public class TriggerOpportunityHandlerTest {
    
    @TestSetup
    static void makeData(){
        Account conta = new Account(Name = 'Conta Test', Numero_Opps__c = 0);
        insert conta;
        
        Opportunity opp = new Opportunity();
        opp.AccountId = conta.Id;
        opp.RecordTypeId = Schema.Opportunity.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Novo_Cliente').getRecordTypeId();
        opp.Name = 'Opp Teste';
        opp.CloseDate = System.Today().addDays(5);
        opp.StageName = 'Analisando';
        insert opp;
    }
    
	@isTest
    static void criarPrimeiraOppEEnviarEmail(){
        
        Account conta = [SELECT Id, Name, Numero_Opps__c, Numero_de_Oportunidades__c FROM Account WHERE Name = 'Conta Test'];
        
		Opportunity opp = [SELECT Id, Name FROM Opportunity WHERE Name = 'Opp Teste'];
        
        System.assertEquals(conta.Numero_Opps__c, 1);
        
    }
}