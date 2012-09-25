public class Geocoder {
    public class NameException extends Exception{} 
    public static final Map<String,GeocodeService> strategies;
    static{
    	GlobalVariable__c gv = GlobalVariable__c.getInstance('strategies');
        List<String> strategyNames = new List<String>();
        if(gv != null && gv.value__c != null) strategyNames = gv.value__c.split(',');
        strategies = new Map<String,GeocodeService>();
        for(String name : strategyNames){
        	try{
	            strategies.put(name
	               ,(GeocodeService)Type.forName(name+'impl').newInstance());
        	}catch(Exception e){continue;} //skip bad config silently
        }
    }
    private GeocodeService strategy;
    public Geocoder(String s){
    	if(!strategies.containsKey(s)) throw new NameException(s + ' not found');
    	strategy = strategies.get(s);
    }
    public List<Double> getLatLong(String address){
        return strategy.getLatLong(address);
    }
}