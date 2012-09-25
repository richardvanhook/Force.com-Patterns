public class weather_controller {

	/* Custom controller */

	/* Property to display list of weather records */
    public List<DecoratedWeather> listOfWeather {
        get {
            if (listOfWeather == null) {
                listOfWeather = new List<DecoratedWeather>();
                
                for (Weather__c weather : [select name, temperature__c from Weather__c]) {
                    listOfWeather.add(new DecoratedWeather(weather));
                }
                
            }
            
            return listOfWeather;
        }
        
        private set;
    }
    
    /* Saves */
    public void SaveRecords() {
        List <Weather__c> weatherRecords = new List <Weather__c>();
        
        for (DecoratedWeather d : listOfWeather) {
            weatherRecords.add(d.weather);
        }          
        
        update weatherRecords;
    }

}