trigger AutomaticallyBinding on Product_Table__c (before insert) {
    
    if( Trigger.isBefore && Trigger.isInsert){
        ProductTriggerHandler.handleBeforeInsert(Trigger.new);
    }
}