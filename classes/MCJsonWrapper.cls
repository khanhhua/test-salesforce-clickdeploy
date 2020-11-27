/**
 * Created by Cristofer Soler - 2020-09-04.
 */
public class MCJsonWrapper {
    private Id campaignId;
    private User campaignUser;
    private List<CampaignMember> campaignMembers;

    public MCJsonWrapper(Id cId, List<CampaignMember> cmList, User cUser) {
        this.campaignId = cId;
        this.campaignMembers = cmList;
        this.campaignUser = cUser;
    }

    public String SetupJsonString(){

        String nameETemplate = System.Label.EmailTemplateJson;
        EmailTemplate eTemplate = [SELECT Id FROM EmailTemplate WHERE Name = :nameETemplate]; 
        Entry currentEntry = new Entry();
        
        for(CampaignMember singleCampaignMember : campaignMembers){
            currentEntry.recipients.add(createRecipient(singleCampaignMember));
        }

        Attributes attributes = new Attributes(campaignMembers[0].Campaign.Subject_Line__c, campaignMembers[0].Campaign.Email_Body__c);
        Messaging.SingleEmailMessage mail = Messaging.renderStoredEmailTemplate(eTemplate.Id, campaignUser.Id, campaignId);
        String firstString = JSON.serializePretty(currentEntry);
        String secondString = JSON.serializePretty(attributes);
        String mcAttributes = secondString.substring(0,secondString.length()-2) + ',' + mail.getPlainTextBody() + '}';
        String jsonString = firstString.substring(0,firstString.length()-2) + ', "attributes" :' + mcAttributes + '}';
        System.debug('Json: ' + jsonString);
        return jsonString;
    }

    public Recipient createRecipient(CampaignMember singleCampaignMember) {
        Recipient result = new Recipient();
        result.contactKey = singleCampaignMember.ContactId;
        result.to = singleCampaignMember.Contact.Email;
        result.messageKey = singleCampaignMember.Id;
        result.attributes = new ContactAttributes(singleCampaignMember.Contact.FirstName, singleCampaignMember.Contact.LastName, singleCampaignMember.Contact.Titel__c, singleCampaignMember.Contact.Salutation);
        return result;
    }

    public class Entry  {
        public String definitionKey = 'kampagnen_massenmailing';
        public List<Recipient> recipients = new List<Recipient>();
    }

    public class Recipient {
        public String contactKey;
        public String to;
        public String messageKey;
        public ContactAttributes attributes;
    }

    public class ContactAttributes {
        public String firstName;
        public String lastName;
        public String title;
        public String salutation;

        public ContactAttributes (String firstName, String lastName, String title, String salutation) {
            this.firstName = firstName;
            this.lastName = lastName;
            this.title = title;
            this.salutation = salutation;
        }
    }


    public class Attributes {
        public String SubjectLine;
        public String EmailBody;

        public Attributes (String SubjectLine, String EmailBody){
            this.SubjectLine = SubjectLine;
            this.EmailBody = EmailBody;
        }
    }

}