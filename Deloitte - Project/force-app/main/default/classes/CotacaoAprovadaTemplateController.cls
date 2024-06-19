public without sharing class CotacaoAprovadaTemplateController {
    public Id quoteId {get;set;}
    public List<QuoteLineItem> getItems(){
        return [
            SELECT Id, Product2.Name, Quantity, Subtotal, Discount, TotalPrice
            FROM QuoteLineItem
            WHERE QuoteId = :quoteId
        ];
    }
}