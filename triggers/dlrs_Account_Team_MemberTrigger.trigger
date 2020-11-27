/**
 * Auto Generated and Deployed by the Declarative Lookup Rollup Summaries Tool package (dlrs)
 **/
trigger dlrs_Account_Team_MemberTrigger on Account_Team_Member__c
    (before delete, before insert, before update, after delete, after insert, after undelete, after update)
{
    dlrs.RollupService.triggerHandler(Account_Team_Member__c.SObjectType);
}