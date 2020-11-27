/**
 * Created by Cristofer Soler - 2019-04-01.
 */

public with sharing class CampaignMembersQueryLayer extends SObjectQueryLayer {
        @TestVisible
        protected override Schema.SObjectType getSObjectType() {
                return CampaignMember.sObjectType;
        }
        //for MC
        public List<CampaignMember> getCMBasedOnCampaignIdSetAndStatus(Set<Id> campaignIds) {
                return [
                        SELECT Id, CampaignId, Status, ContactId, Contact.HasOptedOutOfEmail, Contact.Email, Contact.FirstName, Contact.LastName, Contact.Titel__c, Contact.Salutation, Campaign.Campaign_ID__c, Campaign.Status, Campaign.Opportunity__c, Campaign.Subject_Line__c , Campaign.Email_Body__c, Campaign.Jobportal_Link__c, Campaign.T_Sender_Address__c, Campaign.T_Sender_Name__c
                        FROM CampaignMember
                        WHERE CampaignId IN :campaignIds
                        AND (Status = 'In Preparation' OR Status = 'Cancelled')
                        AND Contact.HasOptedOutOfEmail = false
                        AND Contact.Account.Status__c != 'Inaktiv'
                        ];
            }
    
        //Marketo
        public List<CampaignMember> getCMBasedOnCampaignIdAndStatus(Id campaignId) {
                return [
                        SELECT Id, CampaignId, Status, ContactId, Contact.HasOptedOutOfEmail, Contact.MarketoID__c, Contact.Email, Contact.FirstName, Contact.LastName, Contact.Titel__c, Contact.Salutation, Campaign.Campaign_ID__c, Campaign.Status, Campaign.MarketoAPICallout__c, Campaign.Opportunity__c, Campaign.Subject_Line__c , Campaign.Email_Body__c, Campaign.Jobportal_Link__c, Campaign.T_Sender_Address__c
                        FROM CampaignMember
                        WHERE CampaignId = :campaignId
                        AND Campaign.MarketoAPICallout__c = true
                        AND (Status = 'In Preparation' OR Status = 'Cancelled')
                        AND Contact.HasOptedOutOfEmail = false
                        AND Contact.MarketoID__c != null
                ];
        }
        //MC
        public List<CampaignMember> getCMBasedOnCampaignIdAndStatusMC(Id campaignId) {
            return [
                    SELECT Id, CampaignId, Status, ContactId, Contact.HasOptedOutOfEmail, Contact.Email, Contact.FirstName, Contact.LastName, Contact.Titel__c, Contact.Salutation, Campaign.Campaign_ID__c, Campaign.Status, Campaign.Opportunity__c, Campaign.Subject_Line__c , Campaign.Email_Body__c, Campaign.Jobportal_Link__c, Campaign.T_Sender_Address__c, Campaign.T_Sender_Name__c
                    FROM CampaignMember
                    WHERE CampaignId = :campaignId
                    AND (Status = 'In Preparation' OR Status = 'Cancelled')
                    AND Contact.HasOptedOutOfEmail = false
                    AND Contact.Account.Status__c != 'Inaktiv'
            ];
        }
        //for Marketo
        public List<CampaignMember> getCMBasedOnCampaignIdAndOptOutTrue(Id campaignId) {
            return [
                    SELECT Id, Status, CampaignId, Contact.HasOptedOutOfEmail
                    FROM CampaignMember
                    WHERE CampaignId = :campaignId
                    AND Contact.HasOptedOutOfEmail = true
            ];
        }
        //for MC
        public List<CampaignMember> getCMBasedOnCampaignIdSetAndOptOutTrue(Set<Id> campaignIds) {
            return [
                    SELECT Id, Status, CampaignId, Contact.HasOptedOutOfEmail, Contact.Status__c
                    FROM CampaignMember
                    WHERE CampaignId IN :campaignIds
                    AND (Contact.HasOptedOutOfEmail = true OR Contact.Account.Status__c = 'Inaktiv')
            ];
        }
    
        public List<CampaignMember> getCMBasedOnCampaignCheckMarketoId(Id campaignId) {
            return [
                    SELECT Id, CampaignId, Status, ContactId, Contact.HasOptedOutOfEmail, Contact.MarketoID__c, Campaign.Status, Campaign.Campaign_ID__c, Campaign.MarketoAPICallout__c, Campaign.Opportunity__c, Campaign.Subject_Line__c ,Campaign.Email_Body__c, Campaign.T_Sender_Address__c, Campaign.Jobportal_Link__c, Campaign.T_Sender_Name__c
                    FROM CampaignMember
                    WHERE CampaignId = :campaignId
                    AND (Status = 'In Preparation' OR Status = 'Cancelled')
            ];
        }
        //for Marketo
        public List<CampaignMember> getCMBasedOnCampaignWithStatusSend(Id campaignId) {
            return [
                    SELECT Id, CampaignId, Status, ContactId, Contact.HasOptedOutOfEmail, Contact.MarketoID__c, Campaign.Status, Campaign.Campaign_ID__c, Campaign.MarketoAPICallout__c, Campaign.Opportunity__c, Campaign.Subject_Line__c ,Campaign.Email_Body__c, Campaign.T_Sender_Address__c, Campaign.Jobportal_Link__c
                    FROM CampaignMember
                    WHERE CampaignId = :campaignId
                    AND Campaign.MarketoAPICallout__c = true
                    AND (Status = 'Sent')
                    AND Contact.HasOptedOutOfEmail = false
                    AND Contact.MarketoID__c != null
            ];
        }
        //for MC
        public List<CampaignMember> getCMBasedOnCampaignWithStatusSendMC(Id campaignId) {
            return [
                    SELECT Id, CampaignId, Status, ContactId, Contact.HasOptedOutOfEmail, Campaign.Status, Campaign.Campaign_ID__c,  Campaign.Opportunity__c, Campaign.Subject_Line__c ,Campaign.Email_Body__c, Campaign.T_Sender_Address__c, Campaign.Jobportal_Link__c
                    FROM CampaignMember
                    WHERE CampaignId = :campaignId
                    AND (Status = 'Sent')
                    AND Contact.HasOptedOutOfEmail = false
            ];
        }
    
        //for MC
        public List<CampaignMember> getCMBasedOnCampaignSetWithStatusSend(Set<Id> campaignIds) {
            return [
                    SELECT Id, CampaignId, Status, ContactId, Contact.HasOptedOutOfEmail, Contact.MarketoID__c, Campaign.Status, Campaign.Opportunity__c, Campaign.Subject_Line__c ,Campaign.Email_Body__c
                    FROM CampaignMember
                    WHERE CampaignId IN :campaignIds
                    AND Status = 'Sent'
                    AND Contact.HasOptedOutOfEmail = false
            ];
        }
    
    
    
    }