@IsTest
private class QuoteCloneControllerTest {
    @testSetup
    static void setup() {
        Account acc = SObjectFactory.generateAccount();
        INSERT acc;
        
        Account pers = new Account();
        pers.FirstName = 'Max';
        pers.LastName = 'Mustermann';
        INSERT pers;
        
		Opportunity opp = SObjectFactory.generateOpportunity(acc);
        INSERT opp;
        
        Quote quote = new Quote();
        quote.OpportunityId = opp.ID;
        quote.Person_Account__c = pers.Id;
        quote.Name = 'UnitTest';
        quote.doctari_client__c = 'doctari Fachpflege GmbH';
        INSERT quote;
    }
    
	@isTest static void cloneQuote() {
		List<Quote> quoteList = [Select id, OpportunityId From Quote Where Name = 'UnitTest'];
        List<List<Quote>> invocableParams = new List<List<Quote>> {quoteList};
            
        Test.startTest();
        QuoteCloneController.cloneQuote(invocableParams);
        Test.stopTest();
        
        List<Quote> foundQuotes = [Select id, OpportunityId From Quote Where Name = 'UnitTest'];
        system.assertEquals(2, foundQuotes.size());
    }
}