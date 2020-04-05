global with sharing class SetTimeZoneController {     
    public class ReturnStatus{
        boolean success;
        String message;    
    }
     
    @RemoteAction
    global static String getPreference(String userTimeZone){
        ReturnStatus returnStatus = new ReturnStatus();
        returnStatus.success = true;
        returnStatus.message = 'None';
        try{
            if(userTimeZone != userInfo.getTimeZone().getID()){
                User user = [SELECT ID, Time_Zone_Preference__c  FROM User WHERE ID =:UserInfo.getUserId()];
                returnStatus.message = user.Time_Zone_Preference__c;               
        		
            }
        }catch(Exception e){
             
        }
         
        return JSON.serialize(returnStatus);
    }
     
    @RemoteAction
    global static String setTimeZone(String userTimeZone){
        ReturnStatus returnStatus = new ReturnStatus();
        returnStatus.success = true;
        returnStatus.message = 'Its turtles all the way down';
        try{
            if(userTimeZone != userInfo.getTimeZone().getID()){
                //User self = [SELECT ID, TimeZoneSidKey FROM User WHERE ID =:UserInfo.getUserId()];
                User user = new User();
                user.id = userInfo.getUserId();
                user.TimeZoneSidKey = userTimeZone;
                update user;
                returnStatus.message = 'Successfully Changed the time zone to ' + userTimeZone;
            }
        }catch(Exception e){
            returnStatus.success = false;
            returnStatus.message = e.getMessage();
        }
        return JSON.serialize(returnStatus);
    }
}