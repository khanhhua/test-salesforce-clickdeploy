/**
 * Created by Cristofer Soler - MaibornWolff GmbH - on 2019-04-01.
 *
 * description: The callouts called from this class are not treated Bulkify - single campaign callout -
 */
public class SfoToMarketo{

    private static CampaignMembersQueryLayer campaignMemberSelector;

    static{
        campaignMemberSelector = new CampaignMembersQueryLayer();
    }


    public static void validate(Set<Id> campaignIds){
        Id firstCampaignId = new List<Id> (campaignIds).get(0);

        List<Campaign> campaignList = [SELECT Id, Status, MarketoAPICallout__c FROM Campaign WHERE MarketoAPICallout__c = true AND Id IN  :campaignIds];
        List<CampaignMember> campaignMembers = campaignMemberSelector.getCMBasedOnCampaignIdAndStatus(firstCampaignId);
        List<CampaignMember> campaignMembersWithOtpOutTrue = campaignMemberSelector.getCMBasedOnCampaignIdAndOptOutTrue(firstCampaignId);

        for (Campaign singleCampaign : campaignList){

            if(!campaignMembers.isEmpty()) {

                MarketoAPICalloutBatch mBatch = new MarketoAPICalloutBatch(singleCampaign.Id);
                Database.executeBatch(mBatch, 50);
            }else{
                for(CampaignMember singleCampaignMember : campaignMembersWithOtpOutTrue){
                    singleCampaignMember.Status = 'Cancelled';

                }
                singleCampaign.MarketoAPICallout__c = false;
                singleCampaign.Status = 'Cancelled';

            }
        }

        update campaignList;
        update campaignMembersWithOtpOutTrue;
    }

}