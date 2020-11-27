public with sharing class ReisekostenArtQueryLayer extends SObjectQueryLayer {
    @TestVisible
    protected override Schema.SObjectType getSObjectType() {
            return Reisekosten_Art__c.sObjectType;
    }

    
    @AuraEnabled(Cacheable=true)
    public static List<Reisekosten_Art__c> getReisekostenArtenFromRK(String recordId, String recordTypeName, String categoryName) {
            return [
                    SELECT Id, Reisekosten__c, Reisekosten__r.RecordType.Name,Reisekosten__r.Category__c, Reisekosten__r.Contract__c, Reisekosten__r.Quote__c, Reisekosten__r.Accommodation_Refund__c, Reisekosten__r.Refund__c, Fahrkosten_und_Mobilit_t_Erstattungsart__c, Sonstiges__c, for_Month_Quote__c, Unterkunft_Erstattung_Art_Klinik__c, Unterkunft_Erstattung_Art_Mitarbeiter__c, Verpflegung_Erstattung__c, 
                	(Select id, Auspraegung_Mitarbeiter_Unterkunft__c,Auspraegung_Fahrkosten_Mobilitaet__c,Anzahl_Sonstiges__c,Auspraegung_Fahrkosten_und_Mobilitaet_B__c,Auspraegung_Fahrkosten_und_Mobilitaet_O__c,Auspraegung_Unterkunft_Klinik__c, Bahn_Heimfahrten_pro_Monat__c, KM_Pauschale_Heimfahrten_pro_Monat__c, krankheitsbedingte_Auspraegung__c, maximaler_Betrag_arbeitstaeglich__c,maximaler_Betrag_Flugticket__c,maximaler_Betrag_kalendert_glich__c, maximaler_Betrag_krankheitsb_Ausfall__c, maximaler_Betrag_Sonstiges__c, Zuschlag__c,Zuschlag_arbeitstaeglich__c, Zuschlag_kalendertaeglich__c, PNV_Heimfahrten_pro_Monat__c, Fruehstueck_bis_maximaler_Betrag__c, Uebernachtung_bis_maximaler_Betrag__c, maximaler_Betrag_Reisekostenrechts__c, Einmalpauschale_bis_maximaler_Betrag__c, Anzahl_Flug_Tickets__c FROM Auspraegungen__r)
                    FROM Reisekosten_Art__c
                   WHERE (Reisekosten__r.Quote__c = :recordId OR Reisekosten__r.Contract__c = :recordId) AND Reisekosten__r.RecordType.Name = :recordTypeName AND Reisekosten__r.Category__c = :categoryName
            ];
            
    }
    

}