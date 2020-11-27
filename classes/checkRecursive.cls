/**
 * Created by Cristofer Soler - MaibornWolff GmbH - on 2019-04-01.
 */

public class checkRecursive{
    private static boolean run = true;

    public static boolean runOnce(){
        if(run){
            run=false;
            return true;
        }else{
            return run;
        }
    }
}