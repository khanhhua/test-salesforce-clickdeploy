/**
 * Created by Cristofer Soler - MaibornWolff GmbH - on 2019-04-16.
 */

public with sharing class ParserErrorMarketoAPICallout {


    public Set<String> errorMarketoId(List<Object> errors){
        String marketoIdString;
        String marketoErrorCode;
        List<String> messageStrings;
        Set<String> marketoIdSet = new Set<String>();
        for(Object singleError : errors){
            Map<String,Object> error = (Map<String,Object>)singleError;
            marketoErrorCode = error.get('code').toString();
            switch on marketoErrorCode{
                when '1001'{
                    //Error is generated whenever parameter value has type mismatch. For example string value specified for integer parameter.

                }
                when '1002'{
                    //Error is generated when required parameter is missing from the request

                }
                when '1003'{
                    //When the data submitted is not a valid type for the given endpoint or mode; such as when id is submitted for a lead with action designated as createOnly or when using Request Campaign on a batch campaign.

                }
                when '1004'{
                    //For syncLead, when action is “updateOnly” and if lead is not found
                    marketoIdString = error.get('message').toString().substringBetween('Lead [', ']');
                }
            }

            if(String.isNotBlank(marketoIdString) && marketoIdString.contains(',')){
                messageStrings = marketoIdString.split(', ');
                marketoIdSet.addAll(messageStrings);
            }else{
                marketoIdSet.add(marketoIdString);
            }
        }
        return marketoIdSet;
    }



}