public class CheckMarketoSchedule {
    
    Campaign campaign;
    
    public CheckMarketoSchedule(Campaign c){
        campaign = c;
    }
    
    public void marketoScheduleTime(){
        String jobName = 'New MarketoAPICallout Handler '+ String.valueOf(campaign.Id) + ' ' + String.valueOf(Datetime.now());
        Datetime scheduler;
        Integer minutenSchedule;
        List<CronTrigger> triggers = [
                SELECT Id
                FROM CronTrigger
                WHERE CronJobDetail.Name LIKE 'New MarketoAPICallout Handler%'
        ];

        if(triggers.size() > 0) {
            Integer additionalsMinutes = triggers.size() *2;
            scheduler = System.now().addMinutes(additionalsMinutes);
        }else{
            scheduler = System.now().addMinutes(1);
        }

        String hour = String.valueOf(scheduler.hour());
        String min = String.valueOf(scheduler.minute());
        String ss = String.valueOf(scheduler.second());
        String fireTime = ss + ' ' + min + ' ' + hour + ' * * ?';
        ScheduleMarketoAPICalloutBatch job = new ScheduleMarketoAPICalloutBatch(campaign);

        //Job with the Name will be cancelled when the job was executed
        System.schedule(jobName, fireTime, job);
    }

}