@IsTest
private class MCCalloutTest {
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
            contact.FirstName = 'Max' + i;
            contact.LastName = 'test' + i;
            contact.Email = 'test'+i+'@test.de';
            if (math.mod(i,2) == 0 ) {
                contact.Titel__c = 'Dr.';
                contact.HasOptedOutOfEmail = true;
            }
            contactList.add(contact);
        }

        insert contactList;

        List<Campaign> cam = [SELECT Id, Status, Opportunity__c, Subject_Line__c, Email_Body__c From Campaign LIMIT 1];
        Campaign singleCampaign = new Campaign();
        if (!cam.isEmpty()) {

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
        List<CampaignMember> cmList = [SELECT Id, Contact.Id, Contact.FirstName, Contact.Email, Contact.Titel__c, Contact.Salutation FROM CampaignMember WHERE Contact.HasOptedOutOfEmail = false];
        String ex = '1080';
        String cmString;
        for (Integer i = 0; i < cmList.size(); i++) {
            String singleCMString = '{"messageKey": "'+ cmList[i].Id + '",';
            if (math.mod(i,2) == 0 ) {
                String errorString = '"errorcode": 109106,"message": "MCMS_UTM_Validation_MissingRequiredField_to: Invalid subscriber"},';
                singleCMString = singleCMString+ errorString;
            }
            cmString = cmString + singleCMString;
        }
        
        
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new APIAuthMCCalloutMock(ex,cmString));
    
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock.
        String t = '123456789';
        String tT = 'bearer';
        String j = '{"test":"test"}';
        String rI = 'testurl.de';
        Test.startTest();
    
        HttpResponse response = MCAPICallout.getTokenCallout();
        HttpResponse response2 = MCAPICallout.sendCampaign(t,tT, rI, j);
        Test.stopTest();

        System.assertEquals(202, response.getStatusCode());
        System.assertEquals(202, response2.getStatusCode());
    
    
    }

    @isTest static void test_calloutNoToken() {

        Campaign testCampaign = [SELECT Id From Campaign LIMIT 1];

        Test.startTest();

        MCCalloutBatch mBatch = new MCCalloutBatch(testCampaign.Id);
        String theJobId = Database.executeBatch(mBatch, 50);

        Test.stopTest();

        System.assert(theJobId != null);


    }

    @isTest static void test_batch() {
        

        Campaign testCampaign = [SELECT Id From Campaign LIMIT 1];
        List<CampaignMember> cmList = [SELECT Id, CampaignId, Contact.Id, Contact.FirstName, Contact.Email, Contact.Titel__c, Contact.Salutation FROM CampaignMember WHERE Contact.HasOptedOutOfEmail = false AND CampaignId = :testCampaign.Id];
        String ex = '1080';
        String cmString;
        String singleCMString;
        for (Integer i = 0; i < cmList.size(); i++) {
            if (i == cmList.size()-1) {
                singleCMString = '{"messageKey": "'+ cmList[i].Id + '"}';
            }else{
                singleCMString = '{"messageKey": "'+ cmList[i].Id + '"},';
            }
            if (cmString != null) {
                cmString = cmString + singleCMString;
            } else {
                cmString = singleCMString;
            }
        }
        List<Campaign> cList = new List<Campaign>();
        cList.add(testCampaign);
        Test.startTest();
        CampaignValidator.validate(cList);
        Test.setMock(HttpCalloutMock.class, new APIAuthMCCalloutMock(ex, cmString));
        MCCalloutBatch mBatch = new MCCalloutBatch(testCampaign.Id);
        String theJobId = Database.executeBatch(mBatch, 50);


        Test.stopTest();

        List<CampaignMember> cmSent = [SELECT id, Status FROM CampaignMember WHERE Status = 'Sent'];
        List<CampaignMember> cmAll = [SELECT id, Status FROM CampaignMember];

        System.assertequals(50, cmSent.size(), cmAll);
        System.assert(theJobId != null);

    }

    @isTest static void test_changeActiv() {


        Campaign testCampaign = [SELECT Id From Campaign LIMIT 1];
        List<CampaignMember> cmList = [SELECT Id, CampaignId, Contact.Id, Contact.FirstName, Contact.Email, Contact.Titel__c, Contact.Salutation FROM CampaignMember WHERE Contact.HasOptedOutOfEmail = false AND CampaignId = :testCampaign.Id];
        String ex = '1080';
        String cmString;
        String singleCMString;
        for (Integer i = 0; i < cmList.size(); i++) {
            if (i == cmList.size()-1) {
                singleCMString = '{"messageKey": "'+ cmList[i].Id + '"}';
            }else{
                singleCMString = '{"messageKey": "'+ cmList[i].Id + '"},';
            }
            if (cmString != null) {
                cmString = cmString + singleCMString;
            } else {
                cmString = singleCMString;
            }
        }
        List<Campaign> cList = new List<Campaign>();
        cList.add(testCampaign);
        Test.startTest();
        CampaignValidator.validate(cList);

        Test.setMock(HttpCalloutMock.class, new APIAuthMCCalloutMock(ex, cmString));

        Contact changedContact = [SELECT Name, HasOptedOutOfEmail, LastName FROM Contact WHERE HasOptedOutOfEmail = FALSE LIMIT 1];
        changedContact.HasOptedOutOfEmail = true;
        update changedContact;

        

        Test.stopTest();

        List<CampaignMember> cmSent = [SELECT id, Status FROM CampaignMember WHERE Status = 'Sent'];
        CampaignMember cmChangedContact = [SELECT id, Status, LastName FROM CampaignMember WHERE Contact.Id = :changedContact.Id];
        List<CampaignMember> cmAll = [SELECT id, Status FROM CampaignMember WHERE Status != 'In Preparation'];

        System.assertequals(49, cmSent.size(), cmAll);
        System.assert(cmChangedContact.Status != 'Sent');

    }

    @isTest static void test_NotSent() {

        Campaign testCampaign = [SELECT Id, Status From Campaign LIMIT 1];
        Contact OptOutTrueContact = [SELECT Name, HasOptedOutOfEmail, LastName, Id FROM Contact WHERE HasOptedOutOfEmail = FALSE LIMIT 1];
        OptOutTrueContact.HasOptedOutOfEmail = true;
        update OptOutTrueContact;
        Contact InaktivContact = [SELECT Name, HasOptedOutOfEmail, LastName, Id, Account.Status__c FROM Contact WHERE  Account.Status__c != 'Inaktiv' LIMIT 1];
        InaktivContact.Account.Status__c = 'Inaktiv';
        update InaktivContact;
        List<CampaignMember> changeCampaignMember = [SELECT Id, Status FROM CampaignMember WHERE ContactId != : OptOutTrueContact.Id AND ContactId != : InaktivContact.Id LIMIT 50];
        delete changeCampaignMember;
        List<CampaignMember> cmList = [SELECT Id, CampaignId, Contact.Id, Contact.FirstName, Contact.Email, Contact.Titel__c, Contact.Salutation FROM CampaignMember WHERE Contact.HasOptedOutOfEmail = false AND CampaignId = :testCampaign.Id];
        String ex = '1080';
        String cmString;
        String singleCMString;
        for (Integer i = 0; i < cmList.size(); i++) {
            if (i == cmList.size()-1) {
                singleCMString = '{"messageKey": "'+ cmList[i].Id + '", "errorcode": 109106}';
            }else{
                singleCMString = '{"messageKey": "'+ cmList[i].Id + '","errorcode": 109106},';
            }
            if (cmString != null) {
                cmString = cmString + singleCMString;
            } else {
                cmString = singleCMString;
            }
        }

        List<Campaign> cList = new List<Campaign>();
        cList.add(testCampaign);
        Test.startTest();
        CampaignValidator.validate(cList);

        Test.setMock(HttpCalloutMock.class, new APIAuthMCCalloutMock(ex, cmString));

        Test.stopTest();



        Campaign testCampaignNew = [SELECT Id, Status FROM Campaign WHERE Id = :testCampaign.Id];

        System.assert(testCampaignNew.Status == 'Cancelled');

    }

    @isTest static void test_NoCms() {

        String ex = '1080';
        Campaign testCampaign = [SELECT Id, Status From Campaign LIMIT 1];
        List<CampaignMember> changeCampaignMember = [SELECT Id FROM CampaignMember WHERE CampaignId =: testCampaign.Id];
        delete changeCampaignMember;
        String emptyJson = '{}';
        List<Campaign> cList = new List<Campaign>();
        cList.add(testCampaign);
        Test.startTest();
        CampaignValidator.validate(cList);
        
        Test.setMock(HttpCalloutMock.class, new APIAuthMCCalloutMock(ex, emptyJson));


        Test.stopTest();

        List<CampaignMember> cmAll = [SELECT id, Status FROM CampaignMember];
        Campaign testCampaignNew = [SELECT Id, Status From Campaign LIMIT 1];

        System.assertequals(0, cmAll.size());
        System.assert(testCampaignNew.Status == 'Cancelled');

    }

    @isTest static void test_CmsSent() {


        Campaign testCampaign = [SELECT Id, Status From Campaign LIMIT 1];
        List<CampaignMember> changeCampaignMember = [SELECT Id, Status, Contact.Account.Status__c, Contact.Id, Contact.HasOptedOutOfEmail, Campaign.Id FROM CampaignMember WHERE Campaign.Id =: testCampaign.Id];
        String ex = '1080';
        String emptyJson = '{}';
        for (CampaignMember singleCampaignMember :changeCampaignMember){
            singleCampaignMember.Status = 'Sent';
        }

        update changeCampaignMember;
        List<Campaign> cList = new List<Campaign>();
        cList.add(testCampaign);
        Test.startTest();
        CampaignValidator.validate(cList);

        Test.setMock(HttpCalloutMock.class, new APIAuthMCCalloutMock(ex, emptyJson));

        Test.stopTest();

        List<CampaignMember> cmAll = [SELECT id, Status FROM CampaignMember WHERE Status = :'Sent'];
        Campaign testCampaignNew = [SELECT Id, Status From Campaign LIMIT 1];

        System.assert(cmAll.size() != null);
        System.assertEquals('Sent',testCampaignNew.Status, testCampaignNew);

    }


    @isTest static void test_error() {

        Campaign testCampaign = [SELECT Id From Campaign LIMIT 1];
        
        List<CampaignMember> cmList = [SELECT Id, CampaignId, Contact.Id, Contact.FirstName, Contact.Email, Contact.Titel__c, Contact.Salutation FROM CampaignMember WHERE Contact.HasOptedOutOfEmail = false AND CampaignId = :testCampaign.Id];
   
        String ex = '1080';
        String cmString;
        String singleCMString;
        for (Integer i = 0; i < cmList.size(); i++) {
            if (i == cmList.size()-1) {
                singleCMString = '{"messageKey": "'+ cmList[i].Id + '", "errorcode": 109106}';
            }else{
                singleCMString = '{"messageKey": "'+ cmList[i].Id + '","errorcode": 109106},';
            }
            if (cmString != null) {
                cmString = cmString + singleCMString;
            } else {
                cmString = singleCMString;
            }
        }

        List<Campaign> cList = new List<Campaign>();
        cList.add(testCampaign);
        Test.startTest();
        CampaignValidator.validate(cList);

        Test.setMock(HttpCalloutMock.class, new APIAuthMCCalloutMock(ex, cmString));

        Test.stopTest();

        Campaign testCampaignNew = [SELECT Id, Status From Campaign LIMIT 1];
        Debug__c newdebug = [SELECT id, Campaign__c FROM Debug__c WHERE Campaign__c = :testCampaign.Id LIMIT 1];

        System.assert(newdebug != null);
        System.assert(testCampaignNew.Status == 'Cancelled');
    }

    @isTest static void getObjectType() {

        Schema.SObjectType typeCampaign = Campaign.getSObjectType();
        CampaignQueryLayer cql = new CampaignQueryLayer();
        Schema.SObjectType typeC = cql.getSObjectType();

        System.assertEquals(typeCampaign, typeC);
    }

    @isTest static void test_expiredToken() {

        Campaign testCampaign = [SELECT Id From Campaign LIMIT 1];
        String ex = '100';
        String cmString = '{}';
        List<Campaign> cList = new List<Campaign>();
        cList.add(testCampaign);
        Test.startTest();
        CampaignValidator.validate(cList);
        Test.setMock(HttpCalloutMock.class, new APIAuthMCCalloutMock(ex, cmString));
        Test.stopTest();

        Campaign testCampaignNew = [SELECT Id, Status From Campaign LIMIT 1];
        System.assertEquals('Cancelled', testCampaignNew.Status);

    }



    

}