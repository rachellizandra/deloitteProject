@IsTest
public class BuscarCEPTest {
    
    @TestSetup
    static void makeData(){
        Lead lead = new Lead();
        lead.FirstName = 'Rachel';
        lead.LastName = 'Lizandra';
        lead.Company = 'LTDA';
        insert lead;
    }
	
    @IsTest
    public static void obterEnderecoPorCEP(){
        
        Lead lead = [SELECT Id, FirstName, Company, State FROM Lead WHERE FirstName = 'Rachel' AND Company = 'LTDA' LIMIT 1];
        
        // Configurar mock para simular a chamada à API ViaCEP
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('GetCepResource');
        mock.setStatusCode(200);
        
        Test.setMock(HttpCalloutMock.class, mock);
        
        //Entrada para o FlowInput
        BuscaCEP.FlowInput entrada = new BuscaCEP.FlowInput();
        entrada.cep = '01001-000';
        entrada.leadId = lead.Id;
        
        List<BuscaCEP.FlowInput> entradas = new List<BuscaCEP.FlowInput>();
        entradas.add(entrada);
        
        Test.startTest();
        
        try {
            BuscaCEP.obterEnderecoPorCEP(entradas);
        } catch (Exception e) {
            System.debug('Ocorreu um erro ao realizar a requisição: ' + e.getMessage());
        }
        
        Test.stopTest();
        
        lead = [SELECT Id, State FROM Lead WHERE Id = :lead.Id];
        System.assertEquals('SP', lead.State, 'Estado não localizado.');
    }
}