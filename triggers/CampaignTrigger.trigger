/**
 * Created by Cristofer Soler - MaibornWolff GmbH -  on 2019-04-05.
 */

trigger CampaignTrigger on Campaign (after update) {

    if(checkRecursive.runOnce() && !System.isBatch()) {
        SfoToMarketo.validate(Trigger.newMap.keySet());
    }
}