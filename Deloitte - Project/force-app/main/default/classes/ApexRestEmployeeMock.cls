@isTest
global class ApexRestEmployeeMock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest request) {
        HttpResponse response = new HttpResponse();
        if(!Test.isRunningTest()){
            response.setHeader('Content-Type', 'application/json;charset=UTF-8');
            response.setBody('{"Email__c":"rachel@patchmethod.com.br","Name":"Rachel Teste Patch"}');
            response.setStatusCode(200);
        }
        return response;
    }
    
}