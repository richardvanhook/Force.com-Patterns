public with sharing class DecoratedWeather {

	/* class that wraps the weather custom object */

    public Weather__c weather { get; set; }
    public Decimal tempInCelcius { 
        get {
            if (weather != null && tempInCelcius == null )
                tempInCelcius = (5.0/9.0 * (weather.temperature__c - 32)).setScale(2);
                
            return tempInCelcius;
        } 
        set {
            if (weather != null && value != null ) {
                weather.temperature__c = ((9.0/5.0) * (value)).setScale(2) + 32;
            }
            tempInCelcius = value;
        }
    }
    
    public DecoratedWeather (Weather__c weather) {
        this.weather = weather;
    }
    

}