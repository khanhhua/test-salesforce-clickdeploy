/**
 * Created by cristofers on 2019-04-16.
 */

public class SObjectFactory {

    public static Account generateAccount(){

        Account account = new Account(Name = 'TestAccount',
                Type = 'Customer');

        return account;
    }

    public static Opportunity generateOpportunity(Account acc){
        Opportunity opp = new Opportunity(Name = 'TestOpp',
                CloseDate = System.Today(),
                StageName = 'New',
                AccountId = acc.Id);

        return opp;
    }

    public static Contact generateContact(Account acc){
        Contact contact1 = new Contact(LastName = 'TestContact',
                AccountId = acc.Id,
                Salutation = 'Mr.',
                MarketoID__c = '1030327',
                HasOptedOutOfEmail = false);

        return contact1;
    }

    public static Campaign generateCampaign(Opportunity opp){
        Campaign campaign = new Campaign(
                Name = 'TestCampaign',
                MarketoAPICallout__c = false,
                Opportunity__c = opp.Id,
                Subject_Line__c = 'Hello',
                Email_Body__c = 'Sehr geehrte Damen und Herren, ...'
        );

        return campaign;
    }

    public static CampaignMemberStatus generateCampaignMemberStatus(Campaign campaign){
        CampaignMemberStatus cms = new CampaignMemberStatus(
                CampaignId = campaign.Id,
                HasResponded=false,
                Label = 'In Preparation',
                SortOrder = 3, isDefault = true
        );

        return cms;
    }

    public static CampaignMember generateCampaignMember(Contact contact, Campaign campaign){
        CampaignMember campaignMemberContact1 = new CampaignMember(ContactId = contact.Id,
                CampaignId = campaign.Id,
                Status = 'In Preparation');

        return campaignMemberContact1;
    }

    public static Opportunity generateOpportunity2(Account acc, Contact con){
        Opportunity opp = new Opportunity(Name = 'TestOpp',
                CloseDate = System.Today(),
                StageName = 'New',
                ContactPersonSpeciality__c = con.Id,
                ContactPersonEmployees__c = con.Id,
                StationMulti__c = 'GER',
                AccountId = acc.Id);

        return opp;
    }

    public static Account generatePersonAccount(){
        Id rtype = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Caregiver').getRecordTypeId();
        Account paccount = new Account(FirstName = 'Test',
                LastName = 'Testerino',
                RecordTypeId = rtype);

        return paccount;
    }

    public static Account generateInstitutAccount(){
        Id rtype = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Healthcare Institution').getRecordTypeId();
        Account Iaccount = new Account(Name = 'Test',
                RecordTypeId = rtype);

        return Iaccount;
    }


    public static Quote generateQuote(Account account,Account account2, Opportunity opp){
        Quote quote = new Quote(
                Name = 'Quote',
                OpportunityId = opp.Id,
                Person_Account__c = account.Id,
                Legal_Entity__c = account2.Id,
                doctari_client__c = 'doctari Fachpflege GmbH');
        return quote;
    }

    public static Reisekosten__c generateReisekosten(Account account, Opportunity opp, Quote quote){
        Id rtype = Schema.SObjectType.Reisekosten__c.getRecordTypeInfosByName().get('Doctor/Caregiver').getRecordTypeId();
        Reisekosten__c reisekosten = new Reisekosten__c(
                Name = 'Reisekosten',
                RecordTypeId = rtype,
                Account__c = account.Id,
                Opportunity__c = opp.Id,
                Quote__c = quote.Id);
        return reisekosten;

    }

    public static Reisekosten_Art__c generateReisekostenArt(Reisekosten__c reisekosten){
        Reisekosten_Art__c reisekostenArt = new Reisekosten_Art__c(
                Reisekosten__c = reisekosten.Id);
        return reisekostenArt;

    }

    public static Dokumente__c generateDocument(Account account){
        Id dRtype = Schema.SObjectType.Dokumente__c.getRecordTypeInfosByName().get('Caregiver Document').getRecordTypeId();
        Dokumente__c document = new Dokumente__c(
                Name = 'Dokument',
                RecordTypeId = dRtype,
                AccountType__c = 'Pfleger',
                TypeOfDocument__c = 'MasernATTEST',
                Account__c = account.Id,
                ValidUntil__c = Date.today().addDays(10));
        return document;

    }



}