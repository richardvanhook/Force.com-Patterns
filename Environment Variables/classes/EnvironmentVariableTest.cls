@IsTest
private class EnvironmentVariableTest {

    private static testmethod void test_get_bad_input(){
        //no asserts, just making sure this doesn't throw an exception
        // if an exception were thrown, then this test would fail
        System.assertEquals(null,EnvironmentVariable.get(null));
        System.assertEquals(null,EnvironmentVariable.get('   '));
    }

    private static testmethod void test_put_bad_input(){
        //no asserts, just making sure this doesn't throw an exception
        // if an exception were thrown, then this test would fail
        System.assertEquals(null,EnvironmentVariable.put(null,null));
        System.assertEquals(null,EnvironmentVariable.put('   ',null));
    }

    private static testmethod void test_put_insert(){
        deleteEnvironmentVariableWithNameIfExists('test 123');

        String previousValue = EnvironmentVariable.put('test 123',null);
        assertEnvironmentVariableExistsWith('test 123',null);
        System.assertEquals(null,previousValue);
        System.assertEquals(null,EnvironmentVariable.get('test 123'));

        previousValue = EnvironmentVariable.put('test 123','xyz');
        assertEnvironmentVariableExistsWith('test 123','xyz');
        System.assertEquals(null,previousValue);
        System.assertEquals('xyz',EnvironmentVariable.get('test 123'));

        previousValue = EnvironmentVariable.put('test 123','abc');
        assertEnvironmentVariableExistsWith('test 123','abc');
        System.assertEquals('xyz',previousValue);
        System.assertEquals('abc',EnvironmentVariable.get('test 123'));
    }

    private static testmethod void test_put_update(){
        deleteEnvironmentVariableWithNameIfExists('test 123');
        EnvironmentVariable__c record = new EnvironmentVariable__c(
            name     = 'test 123'
            ,Value__c = 'xyz'
        );  
        insert record;
        assertEnvironmentVariableExistsWith('test 123','xyz');

        String previousValue = EnvironmentVariable.put('test 123','abc');
        assertEnvironmentVariableExistsWith('test 123','abc');
        System.assertEquals('xyz',previousValue);
        System.assertEquals('abc',EnvironmentVariable.get('test 123'));
    }

    private static void deleteEnvironmentVariableWithNameIfExists(String name){
        EnvironmentVariable__c record = null;
        try{
            record = [    
               select id 
               from EnvironmentVariable__c 
               where name = :name 
               limit 1 
            ];
        }catch(QueryException e){}
        if(record != null) delete record;
    }

    private static void assertEnvironmentVariableExistsWith(String name, String value){
        EnvironmentVariable__c record = null;
        try{
            record = [    
               select value__c 
               from EnvironmentVariable__c 
               where name = :name 
               limit 1 
            ];
        }catch(QueryException e){}
        System.assertNotEquals(null,record);
        System.assertEquals   (value,record.value__c);
    }


}