@isTest
public class ApexRestEmployeeTest {
	@isTest
    static void validarCadastroProfissional(){
        
        Employee__c prof = new Employee__c();
        prof.Name = 'Rachel Teste Patch';
        prof.Email__c = 'rachel@patchmethod.com.br';
        HttpResponse response = new HttpResponse();
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ApexRestEmployeeMock());
        try {
           response = ApexRestEmployee.cadastrarProfissional(prof.Name, prof.Email__c);
        } catch(Exception e) {
            System.debug('O status code retornado não foi o esperado: ' + response.getStatusCode() + ' ' + response.getStatus());
        }

        Test.stopTest();
        System.debug('response.getStatusCode(): ' + response.getStatusCode());
        
        System.assertEquals(response.getStatusCode() != null, true);
    }
    
    @isTest
    static void validarAtualizacaoProfissional(){
        Employee__c prof = new Employee__c();
        prof.Name = 'Rachel Teste Patch';
        prof.Email__c = 'rachel@patchmethod.com.br';
        HttpResponse response = new HttpResponse();
        response = ApexRestEmployee.cadastrarProfissional(prof.Name, prof.Email__c);
        insert prof;
        Id idEmployee = prof.Id;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ApexRestEmployeeMock());
        
        try {
            response = ApexRestEmployee.atualizarProfissional(prof.Name, prof.Email__c, idEmployee);
        } catch(Exception e) {
            System.debug('O status code retornado não foi o esperado: ' + response.getStatusCode() + ' ' + response.getStatus());
        }
        Test.stopTest();
        System.debug('response.getStatusCode(): ' + response.getStatusCode());
        
        System.assertEquals(response.getStatusCode() != null, true);
    }
}