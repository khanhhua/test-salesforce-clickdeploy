@isTest
public class RKlwcControllerTest {
   
    
    @IsTest
    static void deleteTest(){
        ReisekostenArtQueryLayer layer = new ReisekostenArtQueryLayer();
        ReisekostenQueryLayer layer2 = new ReisekostenQueryLayer();
        RKlwcController controller = new RKlwcController();
        Account acc = SObjectFactory.generateInstitutAccount();
        acc.Name = 'TestAcc1';
        INSERT acc;
        Contact con = SObjectFactory.generateContact(acc);
        INSERT con;
        Account pacc = SObjectFactory.generatePersonAccount();
        INSERT pacc;
        Opportunity opp =  SObjectFactory.generateOpportunity2(acc, con);
        INSERT opp;
        Quote quote = SObjectFactory.generateQuote(pacc,acc, opp);
        INSERT quote;
        Reisekosten__c rk = SObjectFactory.generateReisekosten(acc, opp, quote);
        rk.Category__c = 'Unterkunft';
        INSERT rk;
        Reisekosten_Art__c rkArt = SObjectFactory.generateReisekostenArt(rk);
        INSERT rkArt;
        sObjectType oType =  layer.getSObjectType();
        sObjectType oType2 =  layer2.getSObjectType();
        List<Reisekosten__c> rkListBefor = ReisekostenQueryLayer.getReisekostenFromQ(quote.Id);
        List<Reisekosten_Art__c> rkArtListBefor = ReisekostenArtQueryLayer.getReisekostenArtenFromRK(quote.Id, 'Doctor/Caregiver', 'Unterkunft');
        Test.startTest();
        RKlwcController.deleteRecords(quote.Id, 'Unterkunft');
        RKlwcController.deleteRecords('', '');
        Test.stopTest();
        List<Reisekosten_Art__c> rkArtListAfter = ReisekostenArtQueryLayer.getReisekostenArtenFromRK(quote.Id, 'Doctor/Caregiver', 'Unterkunft');
        System.assert(rkListBefor.size() >  0);
        System.assert(rkArtListBefor.size() > 0);
        System.assert(rkArtListAfter.size() < 1);
    }


}