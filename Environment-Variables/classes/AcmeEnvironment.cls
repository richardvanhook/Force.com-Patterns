global class AcmeEnvironment {

    global static final String KEY_AMAZON_S3_PRIVATE_KEY = 'AmazonS3.PrivateKey';

    global static String amazonS3PrivateKey {
        set{ EnvironmentVariable.put(KEY_AMAZON_S3_PRIVATE_KEY,value); }
        get{ return EnvironmentVariable.get(KEY_AMAZON_S3_PRIVATE_KEY); }
    } 
    
    //normally I put test methods in their own class
    //doing this for readability
    private static testmethod void test_podName(){
    	AcmeEnvironment.amazonS3PrivateKey = 'abc123';
        System.assertEquals('abc123',EnvironmentVariable.get(KEY_AMAZON_S3_PRIVATE_KEY));
        System.assertEquals('abc123',AcmeEnvironment.amazonS3PrivateKey);
    }

 }