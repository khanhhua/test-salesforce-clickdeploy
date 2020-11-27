public class QuoteCloneController { 
    @InvocableMethod(label='Clone a quote' description='CLone by visual flow')
	public static List<List<Quote>> cloneQuote(List<List<Quote>> insertParams) {
        List<List<Quote>> results = new List<List<Quote>>();
        Quote quote = insertParams.get(0).get(0);
        Set<String> QuoteFields = schema.Quote.sobjecttype.getdescribe().fields.getmap().keyset();
        Quote quoteToClone = (Quote)Database.query('select '+ String.join(new list<string>(quotefields),',')+' from quote where id = \'' + quote.Id + '\'');
	    Quote clonedQuote = quoteToClone.clone(false,false,false,false);
        clonedQuote.OpportunityId = quote.OpportunityId;
        clonedQuote.OwnerId = UserInfo.getUserId();
        clonedQuote.Status = 'Draft';
        
        INSERT clonedQuote;
        
        cloneQuoteLineItems(clonedQuote.Id, quote.Id);
        
        List<Quote> quoteList = new List<Quote>{ clonedQuote };
        results.add(quoteList);
        return results;
    }
    
    private static void cloneQuoteLineItems(ID clonedQuoteId, ID quoteId) {
        Set<String> quoteLineFields = Schema.QuoteLineItem.SObjectType.getDescribe().fields.getmap().keyset();
        List<QuoteLineItem> lineItemsToClone = (List<QuoteLineItem>) Database.query('Select '+ String.join(new List<string>(QuoteLineFields),',')+' From quoteLineItem where quoteId = \''+ quoteId +'\'');
		List<QuoteLineItem> clonedLineItems = lineItemsToClone.deepClone(false,false,false);
        
        for(QuoteLineItem lineItem : clonedLineItems) {
            lineItem.QuoteId = clonedQuoteId;
        }
        
        INSERT clonedLineItems;
    }
}