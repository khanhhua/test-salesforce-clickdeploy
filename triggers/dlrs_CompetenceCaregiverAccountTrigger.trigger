/**
 * Auto Generated and Deployed by the Declarative Lookup Rollup Summaries Tool package (dlrs)
 **/
trigger dlrs_CompetenceCaregiverAccountTrigger on CompetenceCaregiverAccount__c
    (before delete, before insert, before update, after delete, after insert, after undelete, after update)
{
    dlrs.RollupService.triggerHandler(CompetenceCaregiverAccount__c.SObjectType);
}