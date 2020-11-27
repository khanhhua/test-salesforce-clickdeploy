@isTest
public class QueryLayerTest {
    
    @IsTest
    static void quoteQuerylayerTest(){
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
        List<Quote> otherQuoteQuery = new List<Quote>(); 
        otherQuoteQuery.add(QuoteQueryLayer.getQuoteWithRelatedListsbyId(quote.Id));
        System.assert(otherQuery.size() > 0);
        System.assert(otherQuoteQuery.size() > 0);
    }

    @IsTest
    static void accountQuerylayerTest(){
        AccountQueryLayer layer = new AccountQueryLayer();
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
        Dokumente__c dokument = SObjectFactory.generateDocument(pacc);
        INSERT dokument;
        sObjectType oType =  layer.getSObjectType();
        List<String> documentType = new List<String>();
        documentType.add('MasernATTEST');
        List<Account> otherQuery = new List<Account>();
        otherQuery.add(AccountQueryLayer.getAccountbyQuoteId(quote.Id, documentType));
        System.debug('Qurey: '+ otherQuery);
        System.assert(otherQuery.size() > 0);
    }


}