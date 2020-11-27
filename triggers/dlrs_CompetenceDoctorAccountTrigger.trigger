/**
 * Auto Generated and Deployed by the Declarative Lookup Rollup Summaries Tool package (dlrs)
 **/
trigger dlrs_CompetenceDoctorAccountTrigger on CompetenceDoctorAccount__c
    (before delete, before insert, before update, after delete, after insert, after undelete, after update)
{
    dlrs.RollupService.triggerHandler(CompetenceDoctorAccount__c.SObjectType);
}