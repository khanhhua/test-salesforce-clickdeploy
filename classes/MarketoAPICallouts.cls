public class MarketoAPICallouts {


	public static HttpResponse getTokenCallout(){

		String clientID = '730a2024-d19a-4c84-bf26-5b09b196d92a';
		String clientSecret = 't4ruvfgmbVyRLWxZIhMhUcgyoslb1sMF';
		String endpoint = 'https://996-HGU-763.mktorest.com/identity/oauth/token?grant_type=client_credentials&client_id='+ clientID +'&client_secret=' + clientSecret;

		HttpRequest req = new HttpRequest();
		req.setMethod('GET');
		req.setEndpoint(endpoint);

		HttpResponse res;

		res = new Http().send(req);

		return res;
	}

	public static HttpResponse requestCampaign(String t, String tT, String jsonString, String cId){


		String token = t;
		String tokenType = tT;
		String campaignId = cId;
		String endpoint = 'https://996-HGU-763.mktorest.com/rest/v1/campaigns/' + campaignId +'/trigger.json';


		HttpResponse res;
		if (!String.isEmpty(token)) {

			HttpRequest req = new HttpRequest();
			req.setMethod('GET');
			req.setEndpoint(endpoint);
			req.setHeader('Authorization', tokenType + ' ' + token);
			req.setHeader('Content-Type', 'application/json');
			req.setBody(jsonString);
			req.setTimeout(120000);
			res = new Http().send(req);

		}
		return res;



	}

}