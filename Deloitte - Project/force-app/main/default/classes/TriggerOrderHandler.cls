public class TriggerOrderHandler {
    public static void run() {
        List<Order> newList = (List<Order>) Trigger.new;
        Map<Id, Order> oldMap = (Map<Id, Order>) Trigger.oldMap; 
        
        if(Trigger.isAfter && Trigger.isUpdate){
            criarCombo(newList, oldMap);
        }
    }

    public static void criarCombo(List<Order> newList, Map<Id, Order> oldMap){
        Map<Id, Order> mapOrders = new Map<Id, Order>();
        List<Combo__c> combosToInsert = new List<Combo__c>();
        Map<Id, Id> orderAccountMap = new Map<Id, Id>();
        Map<Id, Id> mapAccountCombo = new Map<Id, Id>();

        for(Order pedido : newList){
            if(oldMap.get(pedido.Id).Status != pedido.Status && pedido.Status == 'Aprovado' && pedido.AccountId != null){
                mapOrders.put(pedido.Id, pedido);
                orderAccountMap.put(pedido.Id, pedido.AccountId);
            }
        }

        if(!orderAccountMap.isEmpty()){
            for(Account conta : [SELECT Id, Name, (SELECT Id, Name, Status__c FROM Combos__r WHERE Status__c = 'Ativo') FROM Account WHERE Id IN :orderAccountMap.values()]){
                for(Combo__c combo : conta.Combos__r){
                    mapAccountCombo.put(conta.Id, combo.Id);
                }
            }
        }

        Map<Id, OrderItem> orderItemMap = new Map<Id, OrderItem>([SELECT Id, OrderId, Product2Id, Product2.Family FROM OrderItem WHERE OrderId IN :mapOrders.keySet()]);
        Map<String, String> mapFamilyId = new Map<String, String>();

        if(!orderItemMap.isEmpty()){
            for(OrderItem prod : orderItemMap.values()){
                mapFamilyId.put(prod.Product2.Family, prod.Product2Id);
            }
        }

        Integer index = 0;
        if(!mapOrders.isEmpty()){
            for(Id orderId : mapOrders.keySet()){
                Combo__c combo = new Combo__c();
                combo.Name = 'Combo ' + (1 + index++);

                if(mapAccountCombo.containsKey(orderAccountMap.get(orderId))){
                    combo.Status__c = 'Inativo';
                } else {
                    combo.Status__c = 'Ativo';
                }

                combo.Account__c = orderAccountMap.get(orderId);
                combo.Order__c =  orderId;
                combo.Fixo__c = (mapFamilyId.containsKey('Fixo') ? mapFamilyId.get('Fixo') : '');
                combo.Movel__c = (mapFamilyId.containsKey('Móvel') ? mapFamilyId.get('Móvel') : '');
                combo.Internet__c = (mapFamilyId.containsKey('Banda larga') ? mapFamilyId.get('Banda larga') : '');
                combo.TV__c = (mapFamilyId.containsKey('TV') ? mapFamilyId.get('TV') : '');
                combo.ValorMensal__c = ((mapOrders.get(orderId).Discount__c != null && mapOrders.get(orderId).Discount__c == 0) ? mapOrders.get(orderId).TotalAmount * mapOrders.get(orderId).Discount__c : mapOrders.get(orderId).TotalAmount);
                combosToInsert.add(combo);
            }

            if(!combosToInsert.isEmpty()){
                insert combosToInsert;
            }
        }
    }
}