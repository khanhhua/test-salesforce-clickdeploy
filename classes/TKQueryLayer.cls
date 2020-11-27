/**
 * Created by khanhhua on 2020-08-17.
 */
public with sharing class TKQueryLayer {
    @AuraEnabled(Cacheable=true)
    public static Opportunity getOpportunityByCampaignId(String recordId) {
        return [
            SELECT Id, RecordType.DeveloperName, PlacementModel__c, StageName, InstitutionType__c, DateFrom__c, DateTo__c, Station__c,
                Keyword__c, Account.Id, Account.ShippingAddress, Account.ShippingLatitude, Account.ShippingLongitude,
                (SELECT Id, MedicalDiscipline__c, QualificationLevel__c, TechnicalQualifications__c, AdditionalDesignations__c
                    FROM Qualifications_Doctor__r),
                (SELECT Id, CaregiverJobs__c, CaregiverFurtherEducation__c, CaregiverPracticalExperience__c
                FROM Qualifications_Caregiver__r)
            FROM Opportunity
            WHERE Id IN (SELECT Opportunity__c FROM Campaign WHERE Id =: recordId)
        ];
    }

    @AuraEnabled(cacheable=true)
    public static Account getCandidateById(String recordId) {
        return [
            SELECT Id, RecordType.DeveloperName, TechnicalQualifications__c, PlacementTypes__c, PersonMailingAddress, PersonMailingLatitude, PersonMailingLongitude, RadiusKm__c,
                   (SELECT MedicalDiscipline__c, AdditionalDesignations__c, QualificationLevel__c
                   FROM Kompetenzen__r),
                   (SELECT CaregiverJob__c, CaregiverFurtherEducation__c, CaregiverPracticalExperience__c
                   FROM KompetenzenPflegerAccount__r),
                   (SELECT AccountId, Id, OwnerId, Person_Account__c, OperatingTime__c 
                   FROM Contracts__r 
                   WHERE Person_Account__c =: recordId)
            FROM Account
            WHERE Id =: recordId
        ];
    }

    @AuraEnabled(cacheable=true)
    public static List<SearchPreset__mdt> getSearchPresets() {
        return [
            SELECT Label, DeveloperName, Operator__c, AdditionalDesignations__c, MedicalDiscipline__c, Type__c, CaregiverJob__c, OtherTrainingAndDevelopment__c, 
            CaregiverFurtherEducation__c, CaregiverPracticalExperience__c
            FROM SearchPreset__mdt
        ];
    }
}