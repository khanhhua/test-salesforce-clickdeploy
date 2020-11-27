@isTest
public class AutoConvertLeadsTest {

    private static Lead initGoodLead(string name) {
        return new Lead(
            Lastname = name,
            Status = 'New',
            AccountRecordType__c = 'Caregiver'
        );
        
    }
    
    private static Lead initBadLead(string name) {
        return new Lead(
            Lastname = name,
            Status = 'New',
            AccountRecordType__c = 'Healthcare Institution'
        );
        
    }

    @IsTest
    static void test_AutoConvertLeads() {
        DateTime CreateLeadDate = System.now();
        string status = 'Qualifiziert';
        string LastName = 'abc123ApexClassTest';
        System.assertEquals(0, Database.countQuery('SELECT COUNT() FROM Lead WHERE Status=:status'));
        string notConvertLeadStatus = Label.LeadStatusNichtKonvertierbar;

        Lead leadLater = initGoodLead(LastName);
        insert leadLater;
        
        Lead leadBad = initBadLead(LastName);
        insert leadBad;

        Test.setCreatedDate(leadLater.Id, CreateLeadDate.addMinutes(-15));
        Test.setCreatedDate(leadBad.Id, CreateLeadDate.addMinutes(-15));
        Boolean issueOccured = false;
        Test.startTest();
  
        try {
            Lead leadGoodNow = initGoodLead(LastName);
            insert leadGoodNow;  
            
            SchedulableContext sc = null;
            AutoConvertLeads acl = new AutoConvertLeads();
            acl.execute(sc);                
        } catch (DMLException dmlIssue) {
            issueOccured = true;
        }
        Test.stopTest();
        if (!issueOccured) {
            System.assertNotEquals(0, Database.countQuery('SELECT COUNT() FROM Lead WHERE Status=:status'));
            System.assertNotEquals(0, Database.countQuery('SELECT COUNT() FROM Lead WHERE Status=:notConvertLeadStatus'));
        }
    }

}