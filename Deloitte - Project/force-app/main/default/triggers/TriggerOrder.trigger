trigger TriggerOrder on Order (before insert, after insert, before update, after update) {
    TriggerOrderHandler.run();
}