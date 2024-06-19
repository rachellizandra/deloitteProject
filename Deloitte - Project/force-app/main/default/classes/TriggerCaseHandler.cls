public class TriggerCaseHandler {
    public static void run(){
        List<Case> newList = (List<Case>) Trigger.new;
        Map<Id, Case> oldMap = (Map<Id, Case>) Trigger.oldMap;
        
        if(Trigger.isBefore && Trigger.isInsert){
            inserirDireitoRelacionadoAoCaso(newList);
        } else if (Trigger.isAfter && Trigger.isInsert){
           
        } else if(Trigger.isAfter && Trigger.isUpdate){
            encerrarContagemTempoMarcos(newList, oldMap);
        }
    }
    
    private static void inserirDireitoRelacionadoAoCaso(List<Case> newList){
        List<Entitlement> direitos = [SELECT Id, Name, Status FROM Entitlement WHERE Name = 'Suporte ao Cliente' AND Status = 'Active' LIMIT 1];
        
        if(direitos.isEmpty()) return;
        
        if(!newList.isEmpty()){
            for(Case caso : newList) {
                if(caso.EntitlementId != null) continue;
                caso.EntitlementId = direitos[0].Id;
            }
        }  
    }
    
    private static void encerrarContagemTempoMarcos(List<Case> newList, Map<Id, Case> oldMap){
        List<Case> casesToUpdate = new List<Case>();
        Set<Id> casoIds = new Set<Id>();
        
        if(!newList.isEmpty()){
            for(Case caso : newList){
                casoIds.add(caso.Id);
            }
        }
        
        Map<Id, Case> casos = new Map<Id, Case>([SELECT Id, Aguardando_cliente__c, IsStopped FROM Case WHERE Id IN :casoIds]);
        
        if(!casos.isEmpty()){
            for(Case caso : casos.values()){
                if(oldMap.get(caso.Id).Aguardando_cliente__c != caso.Aguardando_cliente__c){
                    caso.IsStopped = caso.Aguardando_cliente__c;
                    casesToUpdate.add(caso);
                }
            }
        }
        
        if(!casesToUpdate.isEmpty()){
            update casesToUpdate;
        }
    }
}