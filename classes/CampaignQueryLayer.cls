/**
 * Created by cristofers on 2020-09-04.
 */

public with sharing class CampaignQueryLayer extends SObjectQueryLayer {
    @TestVisible
    protected override Schema.SObjectType getSObjectType() {
        return Campaign.sObjectType;
    }


    public Campaign getCampaignById (Id campaignId) {
        return [
                SELECT Id, Status, MarketoAPICallout__c, Opportunity__c, T_Sender_Address__c, T_Sender_Name__c, Subject_Line__c, Email_Body__c, Campaign_ID__c, Opportunity__r.Owner.Title, Opportunity__r.Owner.FirstName, Opportunity__r.Owner.LastName, Opportunity__r.Owner.Company__c, Opportunity__r.Owner.Street, Opportunity__r.Owner.City, Opportunity__r.Owner.PostalCode, Opportunity__r.Owner.Phone, Opportunity__r.Owner.Fax, Opportunity__r.Owner.Register__c, Opportunity__r.Owner.Email, Opportunity__r.Owner.MobilePhone, Opportunity__r.Owner.SeatOfTheSociety__c, Opportunity__r.Owner.CommercialRegisterAddition__c, Opportunity__r.Owner.CommercialRegister__c
                FROM Campaign
                WHERE Id  = :campaignId
        ];
    }

}