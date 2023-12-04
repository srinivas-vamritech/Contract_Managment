trigger DummyUpdateTriggerOnAcc on Account (before insert) {
for (Account acc : Trigger.new) {
        if (acc.Type == 'Customer') {
            acc.DummyText__c = 'High Value';
        } else {
            acc.DummyText__c = 'Standard';
        }
    }
}