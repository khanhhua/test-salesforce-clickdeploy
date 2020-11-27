global class MarketoAPICalloutBatch implements Database.Batchable<sObject>, Database.AllowsCallouts{

    Id campaignId;
    CampaignMembersQueryLayer campaignMemberSelector;
    ParserErrorMarketoAPICallout parser;

    global MarketoAPICalloutBatch(Id cId) {
        campaignId = cId;
        campaignMemberSelector = new CampaignMembersQueryLayer();
        parser = new ParserErrorMarketoAPICallout();
    }

    global List<CampaignMember> start(Database.BatchableContext BC) {

        List<CampaignMember> campaignMembers = campaignMemberSelector.getCMBasedOnCampaignIdAndStatus(campaignId);
        return campaignMembers;
    }

    global void execute(Database.BatchableContext BC, List<CampaignMember> scope) {
        String statusString;
        Set<String> marketoIdSet;
        String errorMessageString;
        List<Object> errors;
        Debug__c debug;
        HttpResponse responseToken;
        HttpResponse responseRequestCampaign;

        Campaign campaign = [SELECT Id, Jobportal_Link__c, Campaign_ID__c, Status, Opportunity__c, MarketoAPICallout__c, Subject_Line__c, Email_Body__c, T_MarketoSenderAddress__c FROM Campaign WHERE Id = :campaignId];
        Opportunity opp = [SELECT Id, OwnerId, RecordTypeId FROM Opportunity WHERE Id = :campaign.Opportunity__c];
        User campaignUser = [SELECT Id, Title, FirstName, LastName, Company__c, Street, City, PostalCode, Phone, Fax, Register__c, Email, MobilePhone, SeatOfTheSociety__c, CommercialRegisterAddition__c, CommercialRegister__c FROM User WHERE Id = :opp.OwnerId];
        if (!Test.isRunningTest()) {
            responseToken = MarketoAPICallouts.getTokenCallout();
        } else{
            HttpRequest req = new HttpRequest();
            responseToken = APIAuthCalloutMock.respond(req);
        }

        if (responseToken.getStatusCode() == 200) {

            Map<String, Object> resultT = (Map<String, Object>) JSON.deserializeUntyped(responseToken.getBody());

            String token = resultT.get('access_token').toString();
            String tokenType = resultT.get('token_type').toString();
            String marketoCampaignId;
            String oppTypeLabel = System.Label.Opportunity_Type;
            String recordTypeName = campaign.T_MarketoSenderAddress__c;
            if(recordTypeName == oppTypeLabel){
                //marketoCampaignId = '1200';
                marketoCampaignId = '1047';
            }else{
                //marketoCampaignId = '1200';
                marketoCampaignId = '1135';
            }

            if (!String.isEmpty(token)) {
                
				System.debug('Campaign: ' + campaign);
                MarketoJsonWrapper wrapper = new MarketoJsonWrapper(campaign, scope, campaignUser, null);
                String jsonS = wrapper.SetupJsonString();
                if (!Test.isRunningTest()) {
                    responseRequestCampaign = MarketoAPICallouts.requestCampaign(token, tokenType, jsonS, marketoCampaignId);
                }else{
                    HttpRequest req = new HttpRequest();
                    responseRequestCampaign = APIAuthCalloutMock.respond(req);
                }
                if (responseRequestCampaign.getStatusCode() == 200) {
                    Map<String, Object> resultSecoundCallout = (Map<String, Object>) JSON.deserializeUntyped(responseRequestCampaign.getBody());

                    String success = resultSecoundCallout.get('success').toString();
                    errors = (List<Object>)resultSecoundCallout.get('errors');

                    if (success == 'true') {
                        statusString = 'Sent';
                    }else{
                        if (errors != null) {
                            marketoIdSet = parser.errorMarketoId(errors);
                            statusString = 'Sent';
                        }
                    }
                } else {
                    errorMessageString = responseRequestCampaign.getStatusCode() + ' ' + responseRequestCampaign.getStatus();
                    statusString = 'Cancelled';
                }
            }
        } else {
            errorMessageString = responseToken.getStatusCode() + ' ' + responseToken.getStatus();
            statusString = 'Cancelled';

        }

        for (CampaignMember singleCampaignMember : scope){
            if (marketoIdSet != null) {
                    if(marketoIdSet.contains(singleCampaignMember.Contact.MarketoID__c)){
                        singleCampaignMember.Status = 'Cancelled';
                    }else{
                        singleCampaignMember.Status = statusString;
                    }
            }else {
                singleCampaignMember.Status = statusString;
            }
        }
        if (!String.isEmpty(errorMessageString)) {
            debug = new Debug__c(Message__c = errorMessageString);
            insert debug;
        }
        if (errors != null) {
            for(Object singleError : errors){
                Map<String,Object> error = (Map<String,Object>)singleError;
                String errorString = error.get('message').toString();
                String errorCode = error.get('code').toString();
                debug = new Debug__c(Message__c = errorString, MarketoErrorNumber__c = errorCode);
            }
            insert debug;
        }

        update scope;

    }

    global void finish(Database.BatchableContext BC) {
        List<CampaignMember> campaignMembersCheck = campaignMemberSelector.getCMBasedOnCampaignCheckMarketoId(campaignId);
        List<CampaignMember> campaignMembersSend = campaignMemberSelector.getCMBasedOnCampaignWithStatusSend(campaignId);
        Campaign campaign = [SELECT Id, Status,Jobportal_Link__c, Campaign_ID__c, Opportunity__c, MarketoAPICallout__c,Subject_Line__c, Email_Body__c, T_MarketoSenderAddress__c FROM Campaign WHERE Id = :campaignId];
        Opportunity opp = [SELECT Id, OwnerId, RecordTypeId FROM Opportunity WHERE Id = :campaign.Opportunity__c];
        User campaignUser = [SELECT Id, Title, FirstName, LastName, Company__c, Street, City, PostalCode, Phone, Fax, Register__c, Email, MobilePhone, SeatOfTheSociety__c, CommercialRegisterAddition__c, CommercialRegister__c FROM User WHERE Id = :opp.OwnerId];

        String marketoIdString = System.Label.MarketoTestMailAccounts;
        List<String> marketoCheckIdList = new List<String>();
        Set<String> marketoCheckIdSet = new Set<String>();
        
        Debug__c debug;
        HttpResponse responseToken;
        HttpResponse responseRequestCampaign;

        if (String.isNotBlank(marketoIdString) && marketoIdString.contains(',')) {
            marketoCheckIdList = marketoIdString.split(',');
            marketoCheckIdSet.addAll(marketoCheckIdList);
        }else {
            marketoCheckIdSet.add(marketoIdString);
        }

        if (!Test.isRunningTest()) {
            responseToken = MarketoAPICallouts.getTokenCallout();
        } else{
            HttpRequest req = new HttpRequest();
            responseToken = APIAuthCalloutMock.respond(req);
        }
        if (responseToken.getStatusCode() == 200) {
            Map<String, Object> resultT = (Map<String, Object>) JSON.deserializeUntyped(responseToken.getBody());

            String token = resultT.get('access_token').toString();
            String tokenType = resultT.get('token_type').toString();
            String marketoCampaignId;
            String oppTypeLabel = System.Label.Opportunity_Type;
            String recordTypeName = campaign.T_MarketoSenderAddress__c;
            if(recordTypeName == oppTypeLabel){
                //marketoCampaignId = '1200';
				marketoCampaignId = '1047';
            }else{
                //marketoCampaignId = '1200';
                marketoCampaignId = '1135';
            }


            if (!String.isEmpty(token)) {

                if (String.isNotBlank(marketoIdString)) {
                    System.debug('Campaign: ' + campaign);
                    MarketoJsonWrapper wrapper2 = new MarketoJsonWrapper(campaign, campaignMembersSend, campaignUser, marketoCheckIdSet);
                    String jsonS = wrapper2.SetupJsonForCheckString();

                    if (!Test.isRunningTest()) {
                        responseRequestCampaign = MarketoAPICallouts.requestCampaign(token, tokenType, jsonS, marketoCampaignId);
                    } else {
                        HttpRequest req = new HttpRequest();
                        responseRequestCampaign = APIAuthCalloutMock.respond(req);
                    }
                }
            }
        }else {
            debug = new Debug__c(Message__c =  responseToken.getStatusCode() + ' ' + responseToken.getStatus());
            insert debug;

        }


        if(campaignMembersCheck != null){
            for (CampaignMember singleCampaignMember : campaignMembersCheck){
                if(singleCampaignMember.Contact.HasOptedOutOfEmail = true || String.isEmpty(singleCampaignMember.Contact.MarketoID__c)){
                    singleCampaignMember.Status = 'Cancelled';
                }
            }
            update campaignMembersCheck;
        }
        
        if(campaignMembersCheck != null){
            for (CampaignMember singleCampaignMember : campaignMembersCheck){
                if(singleCampaignMember.Contact.HasOptedOutOfEmail = true || String.isEmpty(singleCampaignMember.Contact.MarketoID__c)){
                    singleCampaignMember.Status = 'Cancelled';
                }
            }
            update campaignMembersCheck;
        }
        if(!campaignMembersSend.isEmpty()){

            campaign.Status = 'Sent';
            campaign.MarketoAPICallout__c = false;

            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

            String[] toAddresses = new String[] {campaignUser.Email};
            mail.setToAddresses(toAddresses);
            mail.setSubject(campaignMembersSend[0].Campaign.Subject_Line__c);
            mail.setHtmlBody('Sehr geehrte/r Anrede Vorname Nachname, <br>'
                    + campaignMembersSend[0].Campaign.Email_Body__c +  ' <br>Job-ID: ' + String.valueOf(campaign.Campaign_ID__c));

            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });


        }else{
            campaign.Status = 'Cancelled';
            campaign.MarketoAPICallout__c = false;
        }
        update campaign;
    }
}