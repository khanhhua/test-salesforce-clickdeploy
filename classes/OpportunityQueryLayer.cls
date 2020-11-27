/**
 * Created by cristofers on 2019-09-24.
 */

public with sharing class OpportunityQueryLayer extends SObjectQueryLayer {
    @TestVisible
    protected override Schema.SObjectType getSObjectType() {
        return Opportunity.sObjectType;
    }
    public Opportunity getOpportunityByCampaign (Id oppId) {
        return [
                SELECT Id, OwnerId
                FROM Opportunity
                WHERE Id = :oppId
                LIMIT 1
        ];
    }

}