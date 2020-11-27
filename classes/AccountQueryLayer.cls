public with sharing class AccountQueryLayer extends SObjectQueryLayer {
    @TestVisible
    protected override Schema.SObjectType getSObjectType() {
            return Account.sObjectType;
    }

    @AuraEnabled(Cacheable=true)
    public static Account getAccountbyQuoteId(String recordId, List<String> typesString) {
            return [
                SELECT Id, EconomicRegion__c,
                    (SELECT Id, Person_Account__r.Name, Person_Account__c, CheckHUED__c, CommentOperationCheck__c, T_QuoteCheck__c FROM Quotes__r WHERE Id = :recordId),
                    (SELECT Id, TypeOfDocument__c, ValidUntil__c FROM Dokumente__r WHERE TypeOfDocument__c IN :typesString)
                FROM Account 
                WHERE Id IN (SELECT Person_Account__c FROM Quote WHERE Id = :recordId)
            ];
    }
}