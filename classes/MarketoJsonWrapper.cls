/**
 * Created by Cristofer Soler - MaibornWolff GmbH - on 2019-04-01.
 */

public class MarketoJsonWrapper {
    private Campaign campaign;
    private User campaignUser;
    private List<CampaignMember> campaignMembers;
    private Set<String> marketoCheckEmailSet;

    public MarketoJsonWrapper(Campaign c, List<CampaignMember> cmList, User cUser, Set<String> mSet) {
        this.campaign = c;
        this.campaignMembers = cmList;
        this.campaignUser = cUser;
        this.marketoCheckEmailSet = mSet;
		System.debug('Campaign: ' + c);
    }

    public String SetupJsonString(){


        JSONGenerator gen = JSON.createGenerator(true);

        // Write data to the JSON string.
        gen.writeStartObject();
        gen.writeFieldName('input');
        gen.writeStartObject();
        gen.writeFieldName('leads');
        gen.writeStartArray();
        for(CampaignMember singleCampaignMember : campaignMembers){
            if (!String.isEmpty(singleCampaignMember.Contact.MarketoID__c) ) {
                gen.writeStartObject();
                gen.writeNumberField('id', integer.valueof(singleCampaignMember.Contact.MarketoID__c));
                gen.writeEndObject();
            }
        }
        gen.writeEndArray();
        gen.writeFieldName('tokens');
        gen.writeStartArray();
        gen.writeStartObject();
        gen.writeStringField('name', '{{my.Email Subject Line}}');
        gen.writeStringField('value', campaign.Subject_Line__c);
        gen.writeEndObject();
        gen.writeStartObject();
        gen.writeStringField('name', '{{my.Email Body}}');
        gen.writeStringField('value', campaign.Email_Body__c);
        gen.writeEndObject();
		gen.writeStartObject();
        gen.writeStringField('name', '{{my.Email From Address}}');
        gen.writeStringField('value', campaign.T_MarketoSenderAddress__c);
        gen.writeEndObject();
        gen.writeStartObject();
        gen.writeStringField('name', '{{my.User Email}}');
        gen.writeStringField('value', campaignUser.Email);
        gen.writeEndObject();
        gen.writeStartObject();
        gen.writeStringField('name', '{{my.User First Name}}');
        gen.writeStringField('value', campaignUser.FirstName);
        gen.writeEndObject();
        gen.writeStartObject();
        gen.writeStringField('name', '{{my.User Last Name}}');
        gen.writeStringField('value', campaignUser.LastName);
        gen.writeEndObject();
        gen.writeStartObject();
        gen.writeStringField('name', '{{my.User Company}}');
        gen.writeStringField('value', campaignUser.Company__c);
        gen.writeEndObject();
        gen.writeStartObject();
        gen.writeStringField('name', '{{my.User Position}}');
        gen.writeStringField('value', campaignUser.Title);
        gen.writeEndObject();
        gen.writeStartObject();
        gen.writeStringField('name', '{{my.User Address}}');
        gen.writeStringField('value', campaignUser.Street);
        gen.writeEndObject();
        gen.writeStartObject();
        gen.writeStringField('name', '{{my.User Postal Code}}');
        gen.writeStringField('value', campaignUser.PostalCode);
        gen.writeEndObject();
        gen.writeStartObject();
        gen.writeStringField('name', '{{my.User City}}');
        gen.writeStringField('value', campaignUser.City);
        gen.writeEndObject();
        gen.writeStartObject();
        gen.writeStringField('name', '{{my.User Phone}}');
        checkNullValues(gen,'value', campaignUser.Phone);
        gen.writeEndObject();
        gen.writeStartObject();
        gen.writeStringField('name', '{{my.User Mobile}}');
        checkNullValues(gen,'value', campaignUser.MobilePhone);
        gen.writeEndObject();
        gen.writeStartObject();
        gen.writeStringField('name', '{{my.User Fax}}');
        checkNullValues(gen,'value', campaignUser.Fax);
        gen.writeEndObject();
        gen.writeStartObject();
        gen.writeStringField('name', '{{my.Seat Of The Society}}');
        gen.writeStringField('value', campaignUser.SeatOfTheSociety__c);
        gen.writeEndObject();
        gen.writeStartObject();
        gen.writeStringField('name', '{{my.Commercial Register Addition}}');
        checkNullValues(gen,'value', campaignUser.CommercialRegisterAddition__c);
        gen.writeEndObject();
        gen.writeStartObject();
        gen.writeStringField('name', '{{my.Commercial Register}}');
        gen.writeStringField('value', campaignUser.CommercialRegister__c);
        gen.writeEndObject();
        gen.writeStartObject();
        gen.writeStringField('name', '{{my.Campaign ID}}');
        gen.writeStringField('value', campaign.Campaign_ID__c);
        gen.writeEndObject();
        gen.writeStartObject();
        gen.writeStringField('name', '{{my.url}}');
        gen.writeStringField('value', campaign.Jobportal_Link__c);
        gen.writeEndObject();
        gen.writeEndArray();
        gen.writeEndObject();
        gen.writeEndObject();
        String jsonString = gen.getAsString();
        return jsonString;


    }
    
    public String SetupJsonForCheckString(){

        JSONGenerator gen = JSON.createGenerator(true);

        gen.writeStartObject();
        gen.writeFieldName('input');
        gen.writeStartObject();
        gen.writeFieldName('leads');
        gen.writeStartArray();
        for(String marketoId : marketoCheckEmailSet){
            gen.writeStartObject();
            gen.writeNumberField('id', integer.valueof(marketoId));
            gen.writeEndObject();

        }
        
        gen.writeEndArray();
        gen.writeFieldName('tokens');
        gen.writeStartArray();
        gen.writeStartObject();
        gen.writeStringField('name', '{{my.Email Subject Line}}');
        gen.writeStringField('value', campaign.Subject_Line__c);
        gen.writeEndObject();
        gen.writeStartObject();
        gen.writeStringField('name', '{{my.Email Body}}');
        gen.writeStringField('value', campaign.Email_Body__c);
        gen.writeEndObject();
		gen.writeStartObject();
        gen.writeStringField('name', '{{my.Email From Address}}');
        gen.writeStringField('value', campaign.T_MarketoSenderAddress__c);
        gen.writeEndObject();
        gen.writeStartObject();
        gen.writeStringField('name', '{{my.User Email}}');
        gen.writeStringField('value', campaignUser.Email);
        gen.writeEndObject();
        gen.writeStartObject();
        gen.writeStringField('name', '{{my.User First Name}}');
        gen.writeStringField('value', campaignUser.FirstName);
        gen.writeEndObject();
        gen.writeStartObject();
        gen.writeStringField('name', '{{my.User Last Name}}');
        gen.writeStringField('value', campaignUser.LastName);
        gen.writeEndObject();
        gen.writeStartObject();
        gen.writeStringField('name', '{{my.User Company}}');
        gen.writeStringField('value', campaignUser.Company__c);
        gen.writeEndObject();
        gen.writeStartObject();
        gen.writeStringField('name', '{{my.User Position}}');
        gen.writeStringField('value', campaignUser.Title);
        gen.writeEndObject();
        gen.writeStartObject();
        gen.writeStringField('name', '{{my.User Address}}');
        gen.writeStringField('value', campaignUser.Street);
        gen.writeEndObject();
        gen.writeStartObject();
        gen.writeStringField('name', '{{my.User Postal Code}}');
        gen.writeStringField('value', campaignUser.PostalCode);
        gen.writeEndObject();
        gen.writeStartObject();
        gen.writeStringField('name', '{{my.User City}}');
        gen.writeStringField('value', campaignUser.City);
        gen.writeEndObject();
        gen.writeStartObject();
        gen.writeStringField('name', '{{my.User Phone}}');
        checkNullValues(gen,'value', campaignUser.Phone);
        gen.writeEndObject();
        gen.writeStartObject();
        gen.writeStringField('name', '{{my.User Mobile}}');
        checkNullValues(gen,'value', campaignUser.MobilePhone);
        gen.writeEndObject();
        gen.writeStartObject();
        gen.writeStringField('name', '{{my.User Fax}}');
        checkNullValues(gen,'value', campaignUser.Fax);
        gen.writeEndObject();
        gen.writeStartObject();
        gen.writeStringField('name', '{{my.Seat Of The Society}}');
        gen.writeStringField('value', campaignUser.SeatOfTheSociety__c);
        gen.writeEndObject();
        gen.writeStartObject();
        gen.writeStringField('name', '{{my.Commercial Register Addition}}');
        checkNullValues(gen,'value', campaignUser.CommercialRegisterAddition__c);
        gen.writeEndObject();
        gen.writeStartObject();
        gen.writeStringField('name', '{{my.Commercial Register}}');
        gen.writeStringField('value', campaignUser.CommercialRegister__c);
        gen.writeEndObject();
        gen.writeStartObject();
        gen.writeStringField('name', '{{my.Campaign ID}}');
        gen.writeStringField('value', campaign.Campaign_ID__c);
        gen.writeEndObject();
        gen.writeStartObject();
        gen.writeStringField('name', '{{my.url}}');
        gen.writeStringField('value', campaign.Jobportal_Link__c);
        gen.writeEndObject();
        gen.writeEndArray();
        gen.writeEndObject();
        gen.writeEndObject();
        String jsonString = gen.getAsString();
        return jsonString;


    }

    public void checkNullValues(JSONGenerator gen, String fieldName, String fieldValue){
        if(String.isEmpty(fieldValue)){
            gen.writeNullField(fieldName);
        } else{
            gen.writeStringField(fieldName, fieldValue);
        }
    }
}