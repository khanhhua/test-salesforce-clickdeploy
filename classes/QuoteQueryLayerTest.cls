@isTest
public class QuoteQueryLayerTest {
    
    @IsTest
    static void layerTest(){
        QuoteQueryLayer layer = new QuoteQueryLayer();
        Account acc = SObjectFactory.generateInstitutAccount();
        acc.Name = 'TestAcc1';
        INSERT acc;
        Contact con = SObjectFactory.generateContact(acc);
        con.Salutation = 'Mr.';
        INSERT con;
        Account pacc = SObjectFactory.generatePersonAccount();
        pacc.Salutation = 'Mr.';
        INSERT pacc;
        Opportunity opp =  SObjectFactory.generateOpportunity2(acc, con);
        INSERT opp;
        Quote quote = SObjectFactory.generateQuote(pacc,acc, opp);
        INSERT quote;
        sObjectType oType =  layer.getSObjectType();
        List<Quote> otherQuery = new List<Quote>(); 
        otherQuery.add(QuoteQueryLayer.getQuotebyId(quote.Id));
        System.assert(otherQuery.size() > 0);
    }


}