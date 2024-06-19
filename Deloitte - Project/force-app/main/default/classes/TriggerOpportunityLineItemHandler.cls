public class TriggerOpportunityLineItemHandler {
    public static void run(){
        
        List<OpportunityLineItem> newList = (List<OpportunityLineItem>) Trigger.new;
        Map<Id, OpportunityLineItem> oldMap = (Map<Id, OpportunityLineItem>) Trigger.oldMap;
        
        if(Trigger.isAfter && Trigger.isInsert){
			validarControleProduto(newList);
        }  
    }
    
    private static void validarControleProduto(List<OpportunityLineItem> newList){
        
        Map<Id, Product2> mapProdutos = new Map<Id, Product2>([SELECT Id, Name, Tipo_de_Produto__c FROM Product2]);
        Map<Id, Opportunity> mapOpps = new Map<Id, Opportunity>([SELECT Id, Tipo_de_Registro_Formatado__c FROM Opportunity]);
        
        if(!newList.isEmpty()){
            for(OpportunityLineItem oppItem : newList){
                Product2 product = mapProdutos.get(oppItem.Product2Id);
                Opportunity opp = mapOpps.get(oppItem.OpportunityId);
                if(opp.Tipo_de_Registro_Formatado__c != product.Tipo_de_Produto__c || product.Tipo_de_Produto__c == null){
                    oppItem.addError('Não é possível adicionar produto com o campo Tipo de Produto em branco ou somente produtos do mesmo tipo da oportunidade.');
                }
            }
        }
    }
}