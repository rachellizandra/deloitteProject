public class TriggerCotacaoHandler {
    public static void run(){
        List<Quote> newList = (List<Quote>) Trigger.new;
        Map<Id, Quote> oldMap = (Map<Id, Quote>) Trigger.oldMap;
        
        if(Trigger.isAfter && Trigger.isInsert){
		    atualizarStatusOppPrimeiraCotacao(newList);
        } else if(Trigger.isBefore && Trigger.isInsert){
			validaStatusCotacaoSemSincronizacao(newList, oldMap);
        } else if(Trigger.isUpdate && Trigger.isAfter){
            //aprovarProcessoSemDesconto(newList, oldMap);
            atualizarStatusOppCotacaoSincronizada(newList, oldMap);
        } else if(Trigger.isUpdate && Trigger.isBefore){
			validaStatusCotacaoSemSincronizacao(newList, oldMap);
        }
    }
    
    private static void validaStatusCotacaoSemSincronizacao(List<Quote> newList, Map<Id, Quote> oldMap){
        
        if(!newList.isEmpty()){
            for(Quote cotacao : newList){
                if((cotacao.Status == 'Apresentado' || cotacao.Status == 'Aceito') /*&&  cotacao.Status != oldMap.get(cotacao.Id).Status*/ && cotacao.IsSyncing == false){
                    cotacao.addError('Uma cotação não pode estar Apresentado ou Aceito, sem estar sincronizada.');
                }
            }
        }
    }
    
    private static void atualizarStatusOppCotacaoSincronizada(List<Quote> newList, Map<Id, Quote> oldMap){
        Set<Id> oppIds = new Set<Id>();
        
        if(!newList.isEmpty()){
            for(Quote cotacao : newList){
                if(cotacao.OpportunityId != null){
                    oppIds.add(cotacao.OpportunityId);
                }
            }
        }
        
        Map<Id, Opportunity> mapOpps = new Map<Id, Opportunity>([SELECT Id, StageName FROM Opportunity WHERE Id IN :oppIds]);

        for(Quote cotacao : newList){
            if(mapOpps.containsKey(cotacao.OpportunityId)){
                Opportunity opp = mapOpps.get(cotacao.OpportunityId);
                if(cotacao.Status == 'Apresentado' && cotacao.Status != oldMap.get(cotacao.Id).Status && cotacao.IsSyncing == true){
                    opp.StageName = 'Cotação enviada';
                } else if(cotacao.Status == 'Aceito' && cotacao.Status != oldMap.get(cotacao.Id).Status){
                    opp.StageName = 'Ganha';
                }
            }
        }
        
        try {
            update mapOpps.values();
        } catch(Exception e) {
            System.debug('Não foi possível atualizar oportunidade: ' + e.getMessage());
        }
    }
    
    private static void atualizarStatusOppPrimeiraCotacao(List<Quote> newList){
		Set<Id> oppIds = new Set<Id>();
        
        if(!newList.isEmpty()){
            for(Quote cotacao : newList){
                if(cotacao.OpportunityId != null){
                    oppIds.add(cotacao.OpportunityId);
                }
            }
        }
        
        Map<Id, Opportunity> mapOpps = new Map<Id, Opportunity>([SELECT Id, StageName, Numero_de_Cotacoes__c, Numero_Quotes__c, (SELECT Id FROM Quotes) FROM Opportunity WHERE Id IN :oppIds]);
        
        if(!mapOpps.isEmpty()){
            for(Opportunity opp : mapOpps.values()){
                opp.Numero_Quotes__c = opp.Quotes.size();
            } 
            
            update mapOpps.values();
        }
        
        for(Quote cotacao : newList){
            Opportunity opp = mapOpps.get(cotacao.OpportunityId);
            if(mapOpps.containsKey(cotacao.OpportunityId) && opp.Numero_Quotes__c == 1){
                opp.StageName = 'Orçamento';
            }
        }
        
        try {
           update mapOpps.values();
        } catch(Exception e) {
            System.debug('Não foi possível atualizar oportunidade: ' + e.getMessage());
        }
        
    } 
    
    /*public static void aprovarProcessoSemDesconto(List<Quote> newList, Map<Id, Quote> oldMap){
        Set<Id> cotacaoIds = new Set<Id>();
        
        if(!newList.isEmpty()){
            for(Quote cotacao : newList){
                if(cotacao.Status == 'Em revisão' && (oldMap.get(cotacao.Id).Status != cotacao.Status) && (cotacao.Desconto__c == null || cotacao.Desconto__c == 0)) {
                    cotacaoIds.add(cotacao.Id);
                    System.debug('cotacaoIds' + cotacaoIds);
                }
            }
        }
        
       List<ProcessInstanceWorkItem> processoapv = [SELECT Id FROM ProcessInstanceWorkItem WHERE ProcessInstance.TargetObjectId IN :cotacaoIds AND ProcessInstance.Status = 'Pending'];
        
        if(processoapv.size() > 0) {
            for(ProcessInstanceWorkItem processo : processoapv){
                Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
                req.setComments('Solicitação aprovada.');
                req.setAction('Approve');       
                req.setNextApproverIds(new Id[] {UserInfo.getUserId()});
                req.setWorkitemId(processo.Id);
                
                Approval.ProcessResult result = Approval.process(req);
                System.debug('Ação '+ req.getAction());
            }
        }
    }*/
}