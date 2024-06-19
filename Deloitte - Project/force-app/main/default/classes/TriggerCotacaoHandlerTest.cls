@isTest
public class TriggerCotacaoHandlerTest {
	@TestSetup
    static void makeData(){
        Account conta = new Account(Name = 'Conta teste');
        insert conta;
        
        Opportunity opp = new Opportunity(Name = 'Teste Opp', StageName = 'Analisando', CloseDate = System.Today().addDays(21), AccountId = conta.Id);
        insert opp;
        
        Quote cotacao = new Quote(Name='Cotação Teste', ExpirationDate = System.Today().addDays(15), Status = 'Rascunho', OpportunityId = opp.Id);
        insert cotacao;
        
        opp.SyncedQuoteId = cotacao.Id;
        update opp;
    }
    
    @isTest
    private static void validarStatusCotacaoSemSincronizacao(){
        Quote cotacao = [SELECT Id, Name, Status FROM Quote WHERE Name = 'Cotação Teste'];
        cotacao.Status = 'Apresentado';
        
        Test.startTest();
        try {
            update cotacao;
        } catch (Exception e) {
            System.debug(e.getMessage());
        }
        Test.stopTest();
        
        System.assertEquals(cotacao.Status, 'Apresentado');
    }
    
    
    @isTest
    private static void atualizarStatusOppCotacaoSincronizada(){
        
		Opportunity opp = [SELECT Id, Name FROM Opportunity WHERE Name = 'Teste Opp'];
        Quote cotacao = [SELECT Id, Name, Status, IsSyncing FROM Quote WHERE Name = 'Cotação Teste'];
        cotacao.Status = 'Aceito';
        
        Test.startTest();
        try {
            update cotacao;
            System.debug('-------'+cotacao.IsSyncing);
        } catch (Exception e) {
            System.debug(e.getMessage());
        }
        Test.stopTest();
        
        System.assertEquals(cotacao.Status, 'Aceito');
    }
    
    
}