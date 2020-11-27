Public Class Crons implements Schedulable
{
    private static List<string> JobIds = new List<String>();
    
    public static void execute(SchedulableContext SC) {
        AutoConvertLeads acl = new AutoConvertLeads();
        system.schedule(Label.LeadConvertJobName + '00', '0 00 * * * ?', acl);
        system.schedule(Label.LeadConvertJobName + '05', '0 05 * * * ?', acl);
        system.schedule(Label.LeadConvertJobName + '10', '0 10 * * * ?', acl);
        system.schedule(Label.LeadConvertJobName + '15', '0 15 * * * ?', acl);
        system.schedule(Label.LeadConvertJobName + '20', '0 20 * * * ?', acl);
        system.schedule(Label.LeadConvertJobName + '25', '0 25 * * * ?', acl);
        system.schedule(Label.LeadConvertJobName + '30', '0 30 * * * ?', acl);
        system.schedule(Label.LeadConvertJobName + '35', '0 35 * * * ?', acl);
        system.schedule(Label.LeadConvertJobName + '40', '0 40 * * * ?', acl);
        system.schedule(Label.LeadConvertJobName + '45', '0 45 * * * ?', acl);
        system.schedule(Label.LeadConvertJobName + '50', '0 50 * * * ?', acl);
        system.schedule(Label.LeadConvertJobName + '55', '0 55 * * * ?', acl); 

    }
}