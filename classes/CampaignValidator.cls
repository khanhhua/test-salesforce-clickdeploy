/**
 * Created by Cristofer Soler - 2020-09-04
 */
public with sharing class CampaignValidator {
    private static CampaignMembersQueryLayer campaignMemberSelector;
    private static CampaignQueryLayer campaignSelector;
    private static StatusHandler state;

    static {
        campaignMemberSelector = new CampaignMembersQueryLayer();
        campaignSelector = new CampaignQueryLayer();
        state = new StatusHandler();
    }

    @InvocableMethod
    public static void validate(List<Campaign> campaignList) {

        Set<Id> campaignIds = new Set<Id>();
        campaignIds.addAll((new Map<Id,Campaign>(campaignList)).keySet());

        if (campaignList != null && !campaignList.isEmpty()) {

            List<CampaignMember> campaignMembers = campaignMemberSelector.getCMBasedOnCampaignIdSetAndStatus(campaignIds);
            List<CampaignMember> campaignMembersWithOtpOutTrue = campaignMemberSelector.getCMBasedOnCampaignIdSetAndOptOutTrue(campaignIds);
            List<CampaignMember> campaignMembersSend = campaignMemberSelector.getCMBasedOnCampaignSetWithStatusSend(campaignIds);

            if (campaignMembers != null && !campaignMembers.isEmpty()) {
                //mapper framework - git https://salesforce-opensource-library.com/classes/apex/Collection
                Map<Id, List<CampaignMember>> campaignMemberByACampaignId = (Map<Id, List<CampaignMember>>)
                        Collection.of(campaignMembers)
                                .reduce()
                                .toGroup(CampaignMember.CampaignId);

                for (Campaign singleCampaign : campaignList) {
                    if (campaignMemberByACampaignId.get(singleCampaign.Id) != null) {
                        MCCalloutBatch mBatch = new MCCalloutBatch(singleCampaign.Id);
                        Integer batchSize = Integer.valueOf(System.Label.MCCalloutBatchsize);
                        Database.executeBatch(mBatch, batchSize);
                    }
                }
            } else if (campaignMembersSend != null && !campaignMembersSend.isEmpty()) {

                Map<Id, List<CampaignMember>> campaignMemberSendMap = (Map<Id, List<CampaignMember>>)
                        Collection.of(campaignMembersSend)
                                .reduce()
                                .toGroup(CampaignMember.CampaignId);
                state.setPreCampaignStatusSent(campaignMemberSendMap, campaignList);
            } else if (campaignMembersWithOtpOutTrue != null && !campaignMembersWithOtpOutTrue.isEmpty()) {
                Map<Id, List<CampaignMember>> campaignMemberWithOptOutTureMap = (Map<Id, List<CampaignMember>>)
                        Collection.of(campaignMembersWithOtpOutTrue)
                                .reduce()
                                .toGroup(CampaignMember.CampaignId);

                state.setPreCampaignMemberStatusCancelled(campaignMemberWithOptOutTureMap, campaignList);
            } else {
                state.setPreCampaignStatusCancelled(campaignList);
            }
        }
    }
}