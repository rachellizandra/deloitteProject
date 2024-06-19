trigger TriggerOpportunityLineItem on OpportunityLineItem (before insert, after insert, before update, after update) {
	TriggerOpportunityLineItemHandler.run();
}