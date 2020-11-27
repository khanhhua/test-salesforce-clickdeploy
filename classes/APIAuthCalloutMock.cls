/**
 * Created by Cristofer Soler - MaibornWolff GmbH - on 2019-04-01.
 */

@isTest
global class APIAuthCalloutMock implements HttpCalloutMock{

    // Implement this interface method
    global static HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"access_token":"0511b4b2-ea54-406d-9528-4a76ad3bbf79:lon","token_type":"bearer","success":false,"errors":[{"code":"1004","message":"Lead [1234567890] not foundRe"}]}');
        response.setStatusCode(200);
        return response;
    }
}