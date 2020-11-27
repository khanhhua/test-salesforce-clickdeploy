/**
 * Created by Cristofer Soler - MaibornWolff GmbH - on 2019-04-10.
 */

@IsTest
private class MarketoAPICalloutTest {

    @testSetup
    static void setup() {
        List<CampaignMember> campaignMembersList = new List<CampaignMember>();
        List<Contact> contactList = new List<Contact>();


        Account account = SObjectFactory.generateAccount();
        account.Name = 'TestAcc';
        insert account;

        Opportunity opp = SObjectFactory.generateOpportunity(account);
        insert opp;

        for (Integer i = 0; i < 100; i++) {
            Contact contact = SObjectFactory.generateContact(account);
            contact.LastName = 'test' + i;
            if (math.mod(i,2) == 0 ) {
                contact.HasOptedOutOfEmail = true;
            }
            contactList.add(contact);
        }

        insert contactList;

        List<Campaign> cam = [SELECT Id, Status, MarketoAPICallout__c, Opportunity__c, Subject_Line__c, Email_Body__c, T_MarketoSenderAddress__c From Campaign LIMIT 1];
        Campaign singleCampaign = new Campaign();
        if (!cam.isEmpty()) {

            cam[0].MarketoAPICallout__c = false;
            cam[0].Opportunity__c = opp.Id;
            cam[0].Subject_Line__c = 'Hello';
            cam[0].Email_Body__c = 'Sehr geehrte Damen und Herren, ...';
            cam[0].Status = 'In_Preparation';
            update cam;
            singleCampaign = cam[0];
            update singleCampaign;
        }else{

            singleCampaign = SObjectFactory.generateCampaign(opp);
            singleCampaign.Name ='TestCampaign';

            insert singleCampaign;
        }


        CampaignMemberStatus cms = SObjectFactory.generateCampaignMemberStatus(singleCampaign);
        insert cms;




        for (Contact singleContact : contactList) {
            CampaignMember campaignMemberContact1 = SObjectFactory.generateCampaignMember(singleContact, singleCampaign);
            campaignMembersList.add(campaignMemberContact1);
        }

        insert campaignMembersList;


    }

    @isTest static void test_callout() {


        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new APIAuthCalloutMock());

        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock.
        String t = '123456789';
        String tT = 'bearer';
        String j = '{"test":"test"}';
        String i = '1047';
        Test.startTest();

        HttpResponse response = MarketoAPICallouts.getTokenCallout();
        HttpResponse response2 = MarketoAPICallouts.requestCampaign(t,tT, j, i);
        Test.stopTest();

        System.assertEquals(200, response.getStatusCode());
        System.assertEquals(200, response2.getStatusCode());


    }

    @isTest static void test_trigger() {

        Campaign testCampaign = [SELECT Id, MarketoAPICallout__c From Campaign LIMIT 1];
        testCampaign.MarketoAPICallout__c = true;

        Test.startTest();

        Test.setMock(HttpCalloutMock.class, new APIAuthCalloutMock());
        update testCampaign;

        Test.stopTest();

        List<CampaignMember> cmSent = [SELECT id, Status FROM CampaignMember WHERE Status = 'Sent'];
        List<CampaignMember> cmAll = [SELECT id, Status FROM CampaignMember WHERE Status != 'In Preparation'];
        List<CampaignMemberStatus> cmAllStatus = [SELECT id, Label, CampaignId FROM CampaignMemberStatus WHERE CampaignId = :testCampaign.Id];
        System.debug('Status: ' + cmSent);
        System.debug('CMStatus: ' + cmAllStatus);
        System.assertequals(50, cmSent.size(), cmAll);

    }

    @isTest static void test_batch() {


        Campaign testCampaign = [SELECT Id, MarketoAPICallout__c From Campaign LIMIT 1];
        testCampaign.MarketoAPICallout__c = true;

        update testCampaign;
        Test.startTest();

        Test.setMock(HttpCalloutMock.class, new APIAuthCalloutMock());
        MarketoAPICalloutBatch mBatch = new MarketoAPICalloutBatch(testCampaign.Id);
        String theJobId = Database.executeBatch(mBatch, 50);


        Test.stopTest();

        List<CampaignMember> cmSent = [SELECT id, Status FROM CampaignMember WHERE Status = 'Sent'];
        List<CampaignMember> cmAll = [SELECT id, Status FROM CampaignMember WHERE Status != 'In Preparation'];

        System.assertequals(50, cmSent.size(), cmAll);
        System.assert(theJobId != null);

    }

}