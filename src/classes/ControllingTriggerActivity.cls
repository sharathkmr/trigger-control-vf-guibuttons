public class ControllingTriggerActivity {
    
    // to store the Apex triggers
    private List<ApexTrigger> lis;
    // to store the custom wrapper class data of triggers
    private List<Trigger_Control__c> trigContLis;
    private TriggerHelper apexTrigger;
    private Trigger_Control__c customTriggerControl;
    
    public List<TriggerHelper> trigList {get; set;}
    // to get the row number when user interacts using on/off buttons
    public integer rowNumber {get; set;}
    
    public ControllingTriggerActivity() {
        lis = new List<ApexTrigger>();
        // loading the ApexTrigger records using SOQL
        loadData();
    }
    
    // checkbox update method
    public void updateStatus() {
    	// getting the record using rowNum parameter
    	apexTrigger = trigList.get(Integer.valueOf(ApexPages.currentPage().getParameters().get('rowNum')));
       
        if(!apexTrigger.enabled) {
            // inserting custom settings record
            // disabling the trigger
            trigContLis = Trigger_Control__c.getAll().values();
            System.debug('Trigger_Control__c : '+trigContLis);
            if(Trigger_Control__c.getValues(apexTrigger.at.name) == null) {
                Trigger_Control__c trigControl = new Trigger_Control__c();
                trigControl.name = apexTrigger.at.name;
                System.debug(trigControl);
                insert trigControl;
                System.debug('Inserted Succesfully');
            }
        } else {
            // deleting the custom settings record
            // activating a trigger
            customTriggerControl = Trigger_Control__c.getValues(apexTrigger.at.Name);
            System.debug(customTriggerControl);
            delete customTriggerControl;
            System.debug('Deleted Successfully');
        }
        
        
    }
    
    // Loading triggers data using soql
    public void loadData() {
        lis = [select id, name, status, TableEnumOrId from ApexTrigger];
        trigContLis = Trigger_Control__c.getAll().values();
        
        System.debug(lis);
        if(trigList == null) {
            trigList = new List<TriggerHelper>();
            for(integer i=0; i<lis.size(); i++) {
                boolean enabled = true;
                if(Trigger_Control__c.getValues(lis.get(i).name) != null) {
                    enabled = false;
                }
                trigList.add(new TriggerHelper(lis.get(i), i, enabled));
                }
        }
        
        System.debug(trigList);
        
    }
	
    // GUI on/off update method    
    public void triggerSwitch() {
        System.debug('Trigger Switch on/off');
        
        System.debug('row Number: '+rowNumber);
        
        apexTrigger = trigList.get(rowNumber);
        
        if(apexTrigger.enabled) {
            // inserting custom settings record
            // disabling the trigger
            if(Trigger_Control__c.getValues(apexTrigger.at.name) == null) {
                Trigger_Control__c trigControl = new Trigger_Control__c();
                trigControl.name = apexTrigger.at.name;
                System.debug(trigControl);
                insert trigControl;
                // updating in the list
                trigList.get(rowNumber).enabled = false;
                System.debug('Inserted Succesfully');
                
            }
            
        } else {
            // updating in the list
            trigList.get(rowNumber).enabled = true;
            // deleting the custom settings record
            // activating a trigger
            customTriggerControl = Trigger_Control__c.getValues(apexTrigger.at.Name);
            System.debug(customTriggerControl);
            delete customTriggerControl;
            System.debug('Deleted Successfully');
        }
    }
    
    // wrapper class
    public class TriggerHelper {
        public ApexTrigger at {get; set;}
        public integer count {get; set;}
        public boolean enabled {get; set;}
        public TriggerHelper(ApexTrigger at,integer count, boolean enabled) {
            this.at = at;
            this.count = count;
            this.enabled = enabled;
        }
    }

}