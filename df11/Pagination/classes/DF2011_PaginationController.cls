public class DF2011_PaginationController{

    public ApexPages.StandardSetController setController {get; private set;}
    public Integer empSize {get; set;}
    
    public DF2011_PaginationController(){
        queryForRecords();    
    }
    public PageReference filterRecords(){
        queryForRecords();
        return null;
    }    
    public List<Account> getRecords(){
        return setController.getRecords();
    }
    private void queryForRecords(){
        String soqlToExecute ='select Id,IsPersonAccount,Name,BillingStreet,BillingState,BillingCountry,BillingPostalCode,NumberOfEmployees from Account';        if(empSize !=null){
            soqlToExecute +=' where NumberOfEmployees >=:empSize';
        }
        setController = new ApexPages.StandardSetController(Database.getQueryLocator(soqlToExecute));
    
    }
    
    

}