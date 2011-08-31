trigger AccountTrigger on Account (before insert, before update) {
    Metaphone.calculate(Trigger.new,'Name','NameMetaphoneEncoded__c');
}