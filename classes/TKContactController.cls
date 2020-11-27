public with sharing class TKContactController {
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContactsWithAccountIds(List<String> ids) {  
        return [
            SELECT Id, Name, FirstName, LastName, Title, Email, AccountId, Salutation
            FROM Contact
            WHERE AccountId IN :ids
        ];
    }
}