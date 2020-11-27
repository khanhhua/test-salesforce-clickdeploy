/**
 * Created by Cristofer Soler - MaibornWolff GmbH - on 2019-10-11.
 */
global class ScheduleMarketoAPICalloutBatch implements Schedulable{
    Campaign campaign;
    
    global ScheduleMarketoAPICalloutBatch(Campaign c){
        campaign = c;
    }
    
    global void execute(SchedulableContext sc)
    {
        //Integer batchSize = Integer.valueOf(System.Label.MarketoCalloutBatchsize);
        //MarketoAPICalloutBatch job = new MarketoAPICalloutBatch(campaign.Id, sc.getTriggerId());
        //database.executebatch(job,batchSize); 
        
    }
   
}