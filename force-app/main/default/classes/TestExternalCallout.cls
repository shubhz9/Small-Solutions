/**
 * @description       : 
 * @author            : Shubham Raut
 * @group             : 
 * @last modified on  : 09-11-2023
 * @last modified by  : Shubham Raut
 * Modifications Log
 * Ver   Date         Author         Modification
 * 1.0   09-11-2023   Shubham Raut   Initial Version
**/
public with sharing class TestExternalCallout {
    public static void makeCallout() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();

        request.setEndpoint('https://th-apex-http-callout.herokuapp.com/animals');
        request.setMethod('GET');

        HttpResponse response = http.send(request);

        if(response.getStatusCode() == 200){
            List<Contact> conList = new List<Contact>();
            Map<String, Object> objectMap = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
            System.debug('@@-- ' + objectMap);
            System.debug('@@-- ' + objectMap.keySet());
            System.debug('@@-- ' + objectMap.values());

            List<Object> animalList = (List<Object>) objectMap.get('animals');
            for(Object animal: animalList) {
                System.debug(animal);
                Contact con = new Contact();
                con.LastName = String.valueOf(animal);
                conList.add(con);
            }

            insert conList;

        }else{
            System.debug('@@-- response ERROR - ' );
        }
    }

    @AuraEnabled
    public static List<Contact> getContactsFromANIMALApi(){
        try {
            makeCallout();
            return [SELECT Id, LastName FROM Contact WHERE CreatedDate = TODAY LIMIT 1000];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}