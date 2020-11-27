@isTest
public class SObjectQueryLayerTest {

    static testmethod void getFieldListStringTest() {
        CampaignMembersQueryLayer layer = new CampaignMembersQueryLayer();

        Test.startTest();
        String fieldString = layer.getFieldListString('Selector_test');
        Test.stopTest();
    }

    static testmethod void getQueryTest() {
        CampaignMembersQueryLayer layer = new CampaignMembersQueryLayer();
        String condition = 'Status = "In Preparation"';

        Test.startTest();
        String query = layer.getQuery('Selector_test', condition);
        Test.stopTest();
        system.debug(query);
        System.assertEquals(query, 'SELECT Id,Status FROM CampaignMember WHERE Status = "In Preparation"');
    }

    static testmethod void selectByIdTest_PassSet() {
        CampaignWrapper wrapper = generateTestData();

        CampaignMember campaignMemberOpbject = [SELECT Id, Status FROM CampaignMember WHERE CampaignId = :wrapper.campaign.Id];
        Set<ID> campaignMemberIDs = new Set<Id>{wrapper.campaignMember.Id};
        CampaignMembersQueryLayer layer = new CampaignMembersQueryLayer();

        Test.startTest();
        List<CampaignMember> listCMs = (List<CampaignMember>) layer.selectById('Id', campaignMemberIDs, 'Selector_test');
        Test.stopTest();

        System.assert(listCMs.size() == 1);
        System.assertEquals(listCMs.get(0), campaignMemberOpbject);
    }

    static testmethod void selectByIdTest_PassID() {

        CampaignWrapper wrapper = generateTestData();

        CampaignMember campaignMemberOpbject = [SELECT Id, Status FROM CampaignMember WHERE CampaignId = :wrapper.campaign.Id];
        CampaignMembersQueryLayer layer = new CampaignMembersQueryLayer();

        Test.startTest();
        List<CampaignMember> listCMs = (List<CampaignMember>) layer.selectById('Id', campaignMemberOpbject.Id, 'Selector_test');


        Test.stopTest();

        System.assert(listCMs.size() == 1);
        System.assertEquals(listCMs.get(0), campaignMemberOpbject);
    }

    static testmethod void selectByFieldValTest() {
        CampaignWrapper wrapper = generateTestData();

        CampaignMember campaignMemberOpbject = [SELECT Id, CampaignId FROM CampaignMember WHERE CampaignId = :wrapper.campaign.Id];
        CampaignMembersQueryLayer layer = new CampaignMembersQueryLayer();

        Test.startTest();
        List<CampaignMember> listCMs = (List<CampaignMember>) layer.selectByFieldVal('Id', campaignMemberOpbject.Id, 'Selector_test');
        Test.stopTest();

        System.assert(listCMs.size() == 1);
        System.assertEquals(listCMs.get(0).Id, campaignMemberOpbject.Id);
    }

    static CampaignWrapper generateTestData(){
        Account testAccount = SObjectFactory.generateAccount();
        testAccount.Name = 'TestAcc1';
        INSERT testAccount;
        Opportunity opp1 =  SObjectFactory.generateOpportunity(testAccount);
        INSERT opp1;
        Contact con1 =  SObjectFactory.generateContact(testAccount);
        INSERT con1;
        Campaign cam1 =  SObjectFactory.generateCampaign(opp1);
        INSERT cam1;
        CampaignMemberStatus cms1 =  SObjectFactory.generateCampaignMemberStatus(cam1);
        INSERT cms1;
        CampaignMember cm =  SObjectFactory.generateCampaignMember(con1, cam1);
        INSERT cm;

        CampaignWrapper testWrapper = new CampaignWrapper();
        testWrapper.account = testAccount;
        testWrapper.campaign = cam1;
        testWrapper.campaignMember = cm;
        testWrapper.campaignMemberStatus = cms1;
        testWrapper.opportunity = opp1;
        testWrapper.contact = con1;

        return testWrapper;
    }

    public class CampaignWrapper {
        public Account account {get; set;}
        public Campaign campaign {get; set;}
        public CampaignMember campaignMember {get; set;}
        public Opportunity opportunity {get; set;}
        public Contact contact {get; set;}
        public CampaignMemberStatus campaignMemberStatus {get; set;}

    }
}