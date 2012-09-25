public class AccountFooRecordType {
    private static AccountFooRecordType instance = null;
    public String id {get;private set;}
    private AccountFooRecordType(){
        id = Account.sObjectType.getDescribe()
            .getRecordTypeInfosByName().get('Foo').getRecordTypeId();
    }
    public static AccountFooRecordType getInstance(){
        if(instance == null) instance = new AccountFooRecordType();
        return instance;
    }
}