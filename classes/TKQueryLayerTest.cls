@isTest
public class TKQueryLayerTest {
    static testMethod void getOpportunityByCampaignIdTest() {
        Id rtype = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('doctorsSurgery').getRecordTypeId();
        Account a = new Account(Name='Name',
                                RecordTypeId=rtype);
        insert a;
        
        Id oppoRtype = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Recruitment Doctor').getRecordTypeId();
        Opportunity o = new Opportunity(Name='OPPO',
                                        StageName='New',
                                        CloseDate=System.Today(),
                                        RecordTypeId=oppoRtype,
                                        AccountId=a.Id
                                       );
        insert o;

        Campaign c = new Campaign(Name='Test',
                                  Opportunity__c = o.Id);
        insert c;

        QualificationDoctor__c dq = new QualificationDoctor__c(Name='Test',
                                                               Opportunity__c = o.Id);
        dq.MedicalDiscipline__c = 'Allgemeinchirurgie';
        dq.QualificationLevel__c = 'Facharzt';
        insert dq;

        Opportunity actual = TKQueryLayer.getOpportunityByCampaignId(c.Id);
        System.assert(actual != null);
    }
    
    static testMethod void getCandidateByIdTest() {
        Id rtype = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('doctor').getRecordTypeId();
        Account candidate = new Account(LastName='Name',
                                        FirstName='Name',
		                                RecordTypeId=rtype);
        insert candidate;


        CompetenceDoctorAccount__c cda = new CompetenceDoctorAccount__c();
        cda.Name = 'CDA';
        cda.Account__c = candidate.Id;
        cda.MedicalDiscipline__c = 'Allgemeinchirurgie';
        cda.QualificationLevel__c = 'Facharzt';
        insert cda;

        Account actual = TKQueryLayer.getCandidateById(candidate.Id);
        System.assert(actual != null);
    }

    static testMethod void getSearchPresetsTest() {
        List<SearchPreset__mdt> actual = TKQueryLayer.getSearchPresets();
        System.assert(actual != null);
        System.assertEquals(actual.size(), 26);
    }
}