/**
 * Created by Cristofer Soler - on 2020-09-08.
 */

@isTest
global class APIAuthMCCalloutMock implements HttpCalloutMock{
    private static String expireTime;
    private static String jsonCmList;

    global APIAuthMCCalloutMock(String ex, String jsonCM){
        expireTime = ex;
        jsonCmList = jsonCM;
    }

    // Implement this interface method
    global static HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{ '+ 
        '"access_token":"eyJhbLciOiJIPzI",'+
        '"token_type":"bearer",' + 
        '"rest_instance_url":"mcpcq2j9b-nfnvjn6fc7-4113c94.rest.marketingcloudapis.com",' + 
        '"expires_in":'+ expireTime +',' + 
        '"errorcode": 109001,'+
        '"message": "MCMS_UTM_ResponsesHasErrors: subscribers failed to queue",'+
        '"responses": ['+ jsonCmList +']}');
        System.debug('FakeResponse: ' + response.getbody());
        
        response.setStatusCode(202);
        return response;
    }
}