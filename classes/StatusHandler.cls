/**
 * Created by cristofers on 2020-09-07.
 */

public with sharing class StatusHandler {

    private static String CANCELLED = 'Cancelled';
    private static String SENT = 'Sent';
    private static String SUCCESSRESULT = 'success';
    private static String ERRORSRESULT = 'errorcode';
    private static String CODE = 'code';
    private static String INAKTIV = 'Inaktiv';
    private static String RESPONSES = 'responses';
    private static String MESSAGEKEY = 'messageKey';
    private static String MESSAGE = 'message';

    String statusString;
    Set<Id> camapignmemberIdSetSent;
    Set<Id> camapignmemberIdSetCancelled;



    public List<CampaignMember> getStatusCampaignMembers(HttpResponse responseRequestCampaign, List<CampaignMember> campaignMembers, Campaign campaign){

        List<Object> errors;
        List<Object> response;
        List<Debug__c> debugs = new List<Debug__c>();
        String errorMessageString;
        camapignmemberIdSetSent = new Set<Id>();
        camapignmemberIdSetCancelled = new Set<Id>();

        if (responseRequestCampaign.getStatusCode() == 202) {
            Map<String, Object> resultSecoundCallout = (Map<String, Object>) JSON.deserializeUntyped(responseRequestCampaign.getBody());
            
            response = (List<Object>)resultSecoundCallout.get(RESPONSES);
            

            for (Object obj : response) {
                Map<String, Object> responseResult = (Map<String, Object>)obj;
                if (responseResult.keyset().contains(ERRORSRESULT)) {
                    camapignmemberIdSetCancelled.add((Id)responseResult.get(MESSAGEKEY));
                    Integer error = (Integer)responseResult.get(ERRORSRESULT);
                    String errorMessage = (String)responseResult.get(MESSAGE);
                    debugs.add(new Debug__c(ErrorCode__c = error, Message__c = errorMessage, Campaign__c = campaign.Id, CampaignmemberIds__c = (String)responseResult.get(MESSAGEKEY)));
                }else {
                    camapignmemberIdSetSent.add((Id)responseResult.get(MESSAGEKEY));
                }
            }
            if (debugs != null && !debugs.isEmpty()) {
                insert debugs;
            }

        } else {
            camapignmemberIdSetCancelled.addAll((new Map<Id,CampaignMember>(campaignMembers)).keySet());
            errorMessageString = responseRequestCampaign.getStatusCode() + ' ' + responseRequestCampaign.getStatus();
            addDebug(errorMessageString, errors,campaign.Id, camapignmemberIdSetCancelled);
        }

        List<CampaignMember> cmWithStatusUpdate = setStatusCampaignMembers(campaignMembers);

        return cmWithStatusUpdate;

    }

    public List<CampaignMember> setStatusCampaignMembers(List<CampaignMember> campaignMembers){

        for (CampaignMember singleCampaignMember : campaignMembers){
            if (camapignmemberIdSetCancelled.contains(singleCampaignMember.Id)) {
                singleCampaignMember.Status = CANCELLED;
            } else if (camapignmemberIdSetSent.contains(singleCampaignMember.Id)) {
                singleCampaignMember.Status = SENT;
            } 
        }
        return campaignMembers;

    }

    public void setStatusCampaignMemberCheck(List<CampaignMember> campaignMembersCheck){

        for (CampaignMember singleCampaignMember : campaignMembersCheck){
            if(singleCampaignMember.Contact.HasOptedOutOfEmail = true || singleCampaignMember.Contact.Status__c == INAKTIV){
                singleCampaignMember.Status = CANCELLED;
            }
        }
        update campaignMembersCheck;

    }

    public Campaign setCampaignStatus(List<CampaignMember> campaignMembersSend, Campaign campaign, User user){
        if(campaignMembersSend != null && !campaignMembersSend.isEmpty()){

            campaign.Status = SENT;

            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

            String[] toAddresses = new String[] {user.Email};
            mail.setToAddresses(toAddresses);
            mail.setSubject(campaignMembersSend[0].Campaign.Subject_Line__c);
            mail.setHtmlBody('Sehr geehrte/r Anrede Vorname Nachname, <br>'
                    + campaignMembersSend[0].Campaign.Email_Body__c +  ' <br>Job-ID: ' + String.valueOf(campaign.Campaign_ID__c));

            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }else{
            campaign.Status = CANCELLED;
        }

        return campaign;
    }

    public void setPreCampaignStatusSent(Map<Id, List<CampaignMember>> campaignMembersSendMap, List<Campaign> campaigns){

        for (Campaign singleCampaign : campaigns){
            if (campaignMembersSendMap.get(singleCampaign.Id) != null) {
                    singleCampaign.Status = SENT;

            }
        }
        update campaigns;

    }

    public void setPreCampaignStatusCancelled(List<Campaign> campaigns){

        for (Campaign singleCampaign : campaigns){
            singleCampaign.Status = CANCELLED;
        }
        update campaigns;

    }

    public void setPreCampaignMemberStatusCancelled(Map<Id, List<CampaignMember>> campaignMembersSendMap, List<Campaign> campaigns){

        List<CampaignMember> cmList;
        for(Campaign singleCampaign : campaigns){
            cmList = campaignMembersSendMap.get(singleCampaign.Id);
            singleCampaign.Status = CANCELLED;
            if (cmList != null && !cmList.isEmpty()) {
                for(CampaignMember singleCampaignMember : cmList){
                    singleCampaignMember.Status = CANCELLED;
                }
            }

        }
        update cmList;
        
    }

    public void addDebug(String errorMessageString, List<Object> errors, Id campaignId, Set<Id> campaignMembersIdSet){
        Debug__c debug;

        if (!String.isEmpty(errorMessageString)) {
            debug = new Debug__c(Message__c = errorMessageString, Campaign__c = campaignId, CampaignmemberIds__c = campaignMembersIdSet.toString());
            insert debug;
        }
    }
}