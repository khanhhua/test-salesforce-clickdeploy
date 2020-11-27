public with sharing class QuoteQueryLayer extends SObjectQueryLayer {
    @TestVisible
    protected override Schema.SObjectType getSObjectType() {
            return Quote.sObjectType;
    }

    @AuraEnabled(Cacheable=true)
    public static Quote getQuotebyId(String recordId) {
            return [
                SELECT Id, QuoteNumber, Name,doctari_client__c, Person_Account__r.Name, Creation_of_contract_Employee__c, limitation_type__c, Entry_date__c, RecruitingAs__c, FurtherEducation__c, Work_area_in_facility__c, RequestedStateCanton__c, PLZArea__c, PreferredCity__c, Radiuskm__c, working_hours_per_month__c, Hourly_rate__c, gross_monthly_fee__c, Company_car__c, BC_100__c, Own_car__c, MailingAddress__c, OtherPersonalAddress__c, Comment__c, Owner.Name, CreatedBy.Name, LastModifiedBy.Name 
                FROM Quote 
                WHERE Id = :recordId
            ];
    }

    @AuraEnabled(Cacheable=true)
    public static Quote getQuoteWithRelatedListsbyId(String recordId) {
            return [
                SELECT Id, 
                (SELECT Id, Quote__c FROM Traveling_Costs__r WHERE Quote__c = :recordId),
                (SELECT Id, Quote__c FROM OperationTime__r WHERE Quote__c = :recordId),
                (SELECT Id, QuoteId FROM QuoteLineItems WHERE QuoteId = :recordId)
                FROM Quote 
                WHERE Id = :recordId
            ];
    }
}