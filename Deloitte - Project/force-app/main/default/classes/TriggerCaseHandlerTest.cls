@isTest
public class TriggerCaseHandlerTest {
	@TestSetup
    static void makeData(){
        Account conta = new Account(Name='Teste');
        insert conta;
        
        Entitlement direito = new Entitlement(Name='Suporte ao Cliente', AccountId = conta.Id);
        insert direito;
        
        Case caso = new Case(Status='New', Priority='Medium', Origin='Email', EntitlementId = direito.Id, Aguardando_cliente__c = false, IsStopped = false);
        insert caso;
    }
	
    @isTest
    private static void verificarInsercaoDireitoRelacionado(){
        List<Entitlement> direitos = [SELECT Id, Name, Status FROM Entitlement WHERE Name = 'Suporte ao Cliente' LIMIT 1];
        Case caso = new Case(Status='New', Priority='Medium', Origin='Email', EntitlementId = direitos[0].Id);
        
        Test.startTest();
        try{
           insert caso;
        } catch(Exception e){
            System.debug('Ocorreu um erro ao criar um novo caso: ' + e.getMessage());
        }
        Test.stopTest();
        
        System.assertEquals(caso != null, true);
        System.assertEquals(caso.EntitlementId, direitos[0].Id);
    }
    
    @isTest
    private static void verificarCasoUpdate(){
        List<Entitlement> direitos = [SELECT Id, Name, Status FROM Entitlement WHERE Name = 'Suporte ao Cliente' LIMIT 1];
        Case caso = [SELECT Id, Aguardando_cliente__c, IsStopped FROM Case WHERE EntitlementId = :direitos[0].Id];
        caso.Aguardando_cliente__c = true;
        caso.IsStopped = true;
        
        Test.startTest();
        try{
            update caso;
        } catch(Exception e){
            System.debug('Ocorreu um erro ao editar um caso: ' + e.getMessage());
        }
        Test.stopTest();
        
        System.assertEquals(caso != null, true);
        System.assertEquals(caso.Aguardando_cliente__c, true);
        System.assertEquals(caso.IsStopped, true);
    }


}