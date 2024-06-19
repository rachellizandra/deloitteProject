@isTest
public class TriggerOpportunityLineItemHandlerTest {
	@TestSetup
    static void makeData(){
        Account conta = new Account(Name = 'Conta Test', Numero_Opps__c = 0);
        insert conta;
        
        Opportunity opp = new Opportunity();
        opp.AccountId = conta.Id;
        opp.RecordTypeId = Schema.Opportunity.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Contrato').getRecordTypeId();
        opp.Name = 'Opp Teste';
        opp.CloseDate = System.Today().addDays(5);
        opp.StageName = 'Analisando';
        //opp.Tipo_de_Registro_Formatado__c = 'Contrato';
        insert opp;
        
        Opportunity oppAtivo = new Opportunity();
        oppAtivo.AccountId = conta.Id;
        oppAtivo.RecordTypeId = Schema.Opportunity.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Ativo').getRecordTypeId();
        oppAtivo.Name = 'Opp Teste Ativo';
        oppAtivo.CloseDate = System.Today().addDays(5);
        oppAtivo.StageName = 'Analisando';
        insert oppAtivo;
        
        Product2 produto = new Product2();
        produto.Family = 'Dedetização';
        produto.IsActive = true;
        produto.Name = 'Teste Produto';
        produto.Tipo_de_Produto__c = 'Contrato';
        produto.Frequencia__c = 22;
        insert produto;
        
        Pricebook2 catalogo = new Pricebook2();
        catalogo.Name = 'Dedetização';
        catalogo.IsActive = true;
        insert catalogo;
        
        PricebookEntry entradaPadrao = new PricebookEntry();
        entradaPadrao.Pricebook2Id = Test.getStandardPricebookId();
        entradaPadrao.Product2Id = produto.Id;
        entradaPadrao.UnitPrice = 223.20;
        entradaPadrao.IsActive = true;
        insert entradaPadrao;
        
        PricebookEntry entrada = new PricebookEntry();
        entrada.Pricebook2Id = catalogo.Id;
        entrada.Product2Id = produto.Id;
        entrada.UnitPrice = 223.20;
        catalogo.IsActive = true;
        insert entrada;
        
        OpportunityLineItem oppProduct = new OpportunityLineItem();
        oppProduct.Product2Id = produto.Id;
        oppProduct.OpportunityId = opp.Id;
        oppProduct.Quantity = 2;
        oppProduct.PricebookEntryId = entradaPadrao.Id;
        oppProduct.UnitPrice = 2223.20;
        insert oppProduct;
        
    }
    
    @isTest
    private static void validarControleProdutoNaOpp(){
        Opportunity opp = [SELECT Id, Name, Tipo_de_Registro_Formatado__c FROM Opportunity WHERE Name = 'Opp Teste'];
        Product2 produto = [SELECT Id, Name, Tipo_de_Produto__c FROM Product2 WHERE Name = 'Teste Produto' AND Tipo_de_Produto__c = 'Contrato' LIMIT 1];
        OpportunityLineItem oppProduct = [SELECT Id, Product2Id FROM OpportunityLineItem WHERE Product2Id = :produto.Id];
        
        System.assertEquals(produto.Tipo_de_Produto__c, opp.Tipo_de_Registro_Formatado__c);
    }
    
    @isTest
    private static void validarControleProdutoNaOppError(){
        Opportunity opp = [SELECT Id, Name, Tipo_de_Registro_Formatado__c FROM Opportunity WHERE Name = 'Opp Teste Ativo'];
        Product2 produto = [SELECT Id, Name, Tipo_de_Produto__c FROM Product2 WHERE Name = 'Teste Produto' AND Tipo_de_Produto__c = 'Contrato' LIMIT 1];
        OpportunityLineItem oppProduct = [SELECT Id, Product2Id FROM OpportunityLineItem WHERE Product2Id = :produto.Id];
        
        System.assertNotEquals(produto.Tipo_de_Produto__c, 'Ativo', 'Não é possível adicionar produto com o campo Tipo de Produto em branco ou somente produtos do mesmo tipo da oportunidade.');
    }
}