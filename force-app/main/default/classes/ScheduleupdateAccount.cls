Global class ScheduleupdateAccount  implements Schedulable {
 
global void execute(SchedulableContext SC) {
      
      updateAccount up = new updateAccount();
      
      Database.executebatch(up);
      
   }
}