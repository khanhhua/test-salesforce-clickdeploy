/**
 * Auto Generated and Deployed by the Declarative Lookup Rollup Summaries Tool package (dlrs)
 **/
trigger dlrs_QualificationDoctorTrigger on QualificationDoctor__c
    (before delete, before insert, before update, after delete, after insert, after undelete, after update)
{
    dlrs.RollupService.triggerHandler(QualificationDoctor__c.SObjectType);
}