/**
 * Created by Cristofer Soler - 2020-09-04
 */

public class CalloutManager {


    private static Debug__c debug;
    private static String TOKENT = 'token_type';
    private static String ACCESSTOKEN = 'access_token';
    private static String TOKENE = 'expires_in';
    private static String SCOPE = 'email_send';
    private static String RESTURL = 'rest_instance_url';
   
    public AuthToken getAuthToken(Id campaignId){
        String t;
        String tT;
        Integer tE;
        String rI;
        HttpResponse responseToken;

        if (!Test.isRunningTest()) {
            responseToken = MCAPICallout.getTokenCallout();
        } else{
            HttpRequest req = new HttpRequest();
            responseToken = APIAuthMCCalloutMock.respond(req);
        }
        if (responseToken.getStatusCode() == 200 || Test.isRunningTest()) {
            Map<String, Object> resultT = (Map<String, Object>) JSON.deserializeUntyped(responseToken.getBody());

            t = resultT.get(ACCESSTOKEN).toString();
            tT = resultT.get(TOKENT).toString();
            tE = Integer.valueOf(resultT.get(TOKENE));
            rI = resultT.get(RESTURL).toString();

        }else {
            
            debug = new Debug__c(Message__c =  responseToken.getStatusCode() + ' ' + responseToken.getStatus(), Campaign__c = campaignId);
            insert debug;

        }

        AuthToken at = new AuthToken(t, tT, tE, rI);

        return at;

    }

    public HttpResponse sendCampaign(String token, String tokenType, String restURL, String jsonS){

        HttpResponse responseRequestCampaign;

        if (!Test.isRunningTest()) {
            responseRequestCampaign = MCAPICallout.sendCampaign(token, tokenType, restURL, jsonS);
        }else{
            HttpRequest req = new HttpRequest();
            responseRequestCampaign = APIAuthMCCalloutMock.respond(req);
        }

        return responseRequestCampaign;

    }


}