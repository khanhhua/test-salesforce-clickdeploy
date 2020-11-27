/**
 * Created by Cristofer Soler - 2020-09-04
 */
global class MCCalloutBatch implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful{

    CampaignMembersQueryLayer campaignMemberSelector;
    CampaignQueryLayer campaignSelector;
    UserQueryLayer userSelector;
    OpportunityQueryLayer opportunitySelector;
    StatusHandler state;
    CalloutManager manager;
    Campaign campaign;
    Opportunity opportunity;
    User user;
    Id campaignId;
    String token;
    String tokenType;
    Integer tokenExpires;
    String restInstanceURL;


    global MCCalloutBatch(Id cId) {
        campaignId = cId;
        campaignMemberSelector = new CampaignMembersQueryLayer();
        campaignSelector = new CampaignQueryLayer();
        userSelector = new UserQueryLayer();
        opportunitySelector = new OpportunityQueryLayer();
        state = new StatusHandler();
        manager = new CalloutManager();
    }

    global List<CampaignMember> start(Database.BatchableContext BC) {

        List<CampaignMember> campaignMembers = campaignMemberSelector.getCMBasedOnCampaignIdAndStatusMC(campaignId);
        campaign = campaignSelector.getCampaignById(campaignId);
        opportunity = campaign.Opportunity__r;
        user = opportunity.Owner;

        AuthToken at = manager.getAuthToken(campaignId);
        token = at.token;
        tokenType = at.tokenType;
        tokenExpires = at.tokenExpire;
        restInstanceURL = at.restInstanceURL;
        return campaignMembers;
    }

    global void execute(Database.BatchableContext BC, List<CampaignMember> scope) {
        List<CampaignMember> newStatusScope = new List<CampaignMember>();

        if (String.isEmpty(token) || tokenExpires < 100) {

            AuthToken at = manager.getAuthToken(campaignId);
            token = at.token;
            tokenType = at.tokenType;
            tokenExpires = at.tokenExpire;
            restInstanceURL = at.restInstanceURL;

        }
        
        if (!String.isEmpty(token) && tokenExpires > 100) {
            MCJsonWrapper wrapper = new MCJsonWrapper(campaignId, scope, user);
            String jsonS = wrapper.SetupJsonString();
            HttpResponse responseRequestCampaign = manager.sendCampaign(token, tokenType, restInstanceURL, jsonS);
            newStatusScope = state.getStatusCampaignMembers(responseRequestCampaign, scope, campaign);
        }
        update newStatusScope;

    }

    global void finish(Database.BatchableContext BC) {


        List<CampaignMember> campaignMembersCheck = campaignMemberSelector.getCMBasedOnCampaignCheckMarketoId(campaignId);
        List<CampaignMember> campaignMembersSend = campaignMemberSelector.getCMBasedOnCampaignWithStatusSendMC(campaignId);

        if(campaignMembersCheck != null){
            state.setStatusCampaignMemberCheck(campaignMembersCheck);
        }
        Campaign newCampaignStatus = state.setCampaignStatus(campaignMembersSend, campaign, user);
        update newCampaignStatus;
    }

}