public with sharing class RKlwcController {
    
    @AuraEnabled
    public static void deleteRecords(String recordId, String cString){
        List<Reisekosten__c> rkList = new List<Reisekosten__c>();
        rkList = [SELECT Id, Category__c, Contract__c FROM Reisekosten__c WHERE Category__c = : cString AND Contract__c = : recordId];
        if(rkList.size()> 0){
            try {
                delete rkList;
            } catch (Exception ex) {
                throw new AuraHandledException(ex.getMessage());
            }
        }

    }

}