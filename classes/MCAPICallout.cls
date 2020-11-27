/**
 * Created by Cristofer Soler - 2020-09-04
 */
public class MCAPICallout {

    public class Auth {
		public String client_id;
        public String client_secret;
        public String grant_type;
        public String scope;
        public String account_id;

		public Auth(String username, String password) {
            this.grant_type = 'client_credentials';
			this.client_id = username;
            this.client_secret = password;
            this.scope = 'email_send';
            this.account_id = System.Label.MCAccountID;
		}

		public String toJSON() {
			return JSON.serializePretty(this);
		}
	}


    public static HttpResponse getTokenCallout(){

        String endpoint = System.Label.MCAuthEndpoint;

		HttpRequest req = new HttpRequest();
		req.setMethod('POST');
        req.setEndpoint('callout:MC');
        req.setHeader('Content-Type', 'application/json');
        req.setBody(new Auth('{!$Credential.UserName}','{!$Credential.Password}').toJSON());
		HttpResponse res;

		res = new Http().send(req);

		return res;
    }
    
    public static HttpResponse sendCampaign(String t, String tT, String rURL, String jsonString){


		String token = t;
        String tokenType = tT;
        String restURL = rURL;

		String endpoint = System.Label.MCMailEndpoint;


		HttpResponse res;
		if (!String.isEmpty(token)) {

			HttpRequest req = new HttpRequest();
			req.setMethod('POST');
			req.setEndpoint(restURL + endpoint);
			req.setHeader('Authorization', tokenType + ' ' + token);
			req.setHeader('Content-Type', 'application/json');
			req.setBody(jsonString);
            req.setTimeout(120000);
			res = new Http().send(req);

		}
		return res;



	}
}