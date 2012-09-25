Example implementation of Strategy Design Pattern in Apex using Geocoding as the problem domain.

## Setup
<ol>
  <li>Deploy Custom Setting: GlobalVariable__c</li>
  <li>Deploy four classes: Geocoder, GeocodeService, GoogleMapsImpl, and MapQuestImpl</li>
  <li>Run following code to create record in Custom Setting:
</li>
</ol>
    GlobalVariable__c record = null;
    try{
        record = [select id,value__c from GlobalVariable__c where name = 'strategies'];
    }catch(QueryException e){}
    System.debug(record);
    if(record == null) record = new GlobalVariable__c(name= 'strategies');
    record.value__c = 'googlemaps,mapquest';
    if(record.id != null) update record;
    else                  insert record;

## Usage
    System.debug((new Geocoder('googlemaps')).getLatLong('moscone center'));
    //=>DEBUG|(0.0, 0.0)
    System.debug((new Geocoder('mapquest')).getLatLong('moscone center'));
    //=>DEBUG|(1.0, 1.0)
