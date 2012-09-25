trigger AccountTrigger on Account (before insert, before update) {
    for(Account record : Trigger.new){
        AccountFooRecordType rt = AccountFooRecordType.getInstance();
    }
}