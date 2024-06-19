trigger TriggerCotacao on Quote (before insert, after insert, before update, after update) {
	TriggerCotacaoHandler.run();
}