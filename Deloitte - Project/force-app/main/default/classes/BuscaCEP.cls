public class BuscaCEP {
    @InvocableMethod(callout=true label='Obter endereço por CEP e Atualizar Lead')
    public static void obterEnderecoPorCEP(List<FlowInput> entradas){
        FlowInput entrada = entradas[0];
        
        // Criar requisição HTTP para chamar a API ViaCEP
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://viacep.com.br/ws/' + entrada.cep + '/json/');
        req.setMethod('GET');
        
        // Criar instância da classe Http para realizar a chamada HTTP
        Http http = new Http();
        HttpResponse resposta = http.send(req);
        
        if(resposta.getStatusCode() == 200){
            // Deserializar a resposta JSON em um mapa genérico de chave-valor
            Map<String, Object> resultado = (Map<String, Object>) JSON.deserializeUntyped(resposta.getBody());
            
            Lead lead = new Lead();
            lead.Id = entrada.leadId;
            lead.City = (String) resultado.get('localidade');
            lead.State = (String) resultado.get('uf');
            lead.PostalCode = (String) resultado.get('cep');
            lead.Street = (String) resultado.get('logradouro');
            lead.Bairro__c = (String) resultado.get('bairro');
            lead.Complemento__c = (String) resultado.get('complemento');
            
            try {
                update lead;
            } catch (Exception e) {
                System.debug('Ocorreu um erro ao realizar a requisição: ' + e.getMessage());
            }
        }
    }
    
    // Estrutura de dados de entrada do flow
    public class FlowInput{
       @InvocableVariable
        public String cep;
        @InvocableVariable
        public String leadId;
    }
}