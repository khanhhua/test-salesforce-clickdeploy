/**
 * Created by cristofers on 2019-09-24.
 */

public with sharing class AuthToken {

    public String token;
    public String tokenType;
    public Integer tokenExpire;
    public String restInstanceURL;

    public AuthToken(String t, String tT, Integer tE, String rI){
        this.token = t;
        this.tokenType = tT;
        this.tokenExpire = tE;
        this.restInstanceURL = rI;

    }

}