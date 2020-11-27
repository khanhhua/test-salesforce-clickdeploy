public class ReisekostenQueryLayer extends SObjectQueryLayer {
    @TestVisible
    protected override Schema.SObjectType getSObjectType() {
            return Reisekosten__c.sObjectType;
    }

    
    @AuraEnabled(Cacheable=true)
    public static List<Reisekosten__c> getReisekostenFromQ(String recordId) {
            return [
                    SELECT Id, Quote__c, Contract__c, Contract__r.Status,
                         (Select id, Abreisetag__c, Anreisetag__c, Anzahl_Personen__c, Anzahl_Zimmer__c, Entfernung_Klinik_Unterkunft_max__c, Haustier__c, Kostentraeger_doctari__c, Kostentraeger_Klinik__c, Kostentraeger_Mitarbeiter__c, max_Preis_pro_Nacht__c, Parkplatz_erwuenscht__c, Rechnung_wird_bezahlt_von__c, Sonderwuensche__c, Verpflegung_erwuenscht__c, benoetigte_Unterkunftstage__c, Kochgelegenheit_gew_nscht__c FROM Unterkunftsbuchungen__r)
                    FROM Reisekosten__c
                   WHERE (Quote__c = :recordId OR Contract__c = : recordId)
            ];
            
    }
}