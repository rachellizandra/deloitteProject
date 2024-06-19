public class ApexRestEmployee {
    public static HttpResponse cadastrarProfissional(String name, String email){
        String endPoint = 'https://deloittebr--operate.sandbox.my.site.com/services/apexrest/webhookSObject';
        String auth = 'Basic ca2d6a1664b79d0c65b92f7ac447ee7057aa82c7';
        String jsonstr = '{"Email__c" :"' + email + '","Name":"' + name +'"}';
        System.debug('jsonstr: ' + jsonstr);
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setHeader('Content-Type','application/json;charset=UTF-8');
        req.setHeader('Authentication', auth);
        req.setBody(jsonstr);
        req.setMethod('POST');
        req.setEndpoint(endPoint);
        HttpResponse response = new HttpResponse();
        
        if(!Test.isRunningTest()){
            response = http.send(req);
        }
        
        if(response.getStatusCode() != 200) {
            System.debug('O status code retornado não foi o esperado: ' + response.getStatusCode() + ' ' + response.getStatus());
        } else {
            System.debug(response.getBody());
        }
        
        return response;
    }
    
    public static HttpResponse atualizarProfissional(String name, String email, Id idEmployee){
        String endPoint = 'https://deloittebr--operate.sandbox.my.site.com/services/apexrest/webhookSObject';
        String auth = 'Basic ca2d6a1664b79d0c65b92f7ac447ee7057aa82c7';
        String jsonstr = '{"Email__c": "' + email + '","Name": "' + name + '", "Id":"' + idEmployee +'"}';
        System.debug('jsonstr: ' + jsonstr);
        HttpResponse response = new HttpResponse();
        
        if(idEmployee != null){
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            req.setHeader('Content-Type','application/json;charset=UTF-8');
            req.setHeader('Authentication', auth);
            req.setBody(jsonstr);
            req.setMethod('PATCH');
            req.setEndpoint(endPoint);
            
            if(!Test.isRunningTest()){
                response = http.send(req);                
            }
            
            if(response.getStatusCode() != 200) {
                System.debug('O status code retornado não foi o esperado: ' + response.getStatusCode() + ' ' + response.getStatus());
            } else {
                System.debug(response.getBody());
            }
        }
        
        return response;
    }
}