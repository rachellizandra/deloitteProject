trigger TriggerCase on Case (before insert, after insert, after update) {
	TriggerCaseHandler.run();
}