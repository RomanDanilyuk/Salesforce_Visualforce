trigger onCheckBoxTrigger on Product__c (before insert, before update) {
    if(Trigger.isBefore && Trigger.isInsert)
        ProductTriggerHandler.beforeInsert(Trigger.new);
     else if(Trigger.isBefore && Trigger.isUpdate)
         ProductTriggerHandler.beforeUpdate(Trigger.new);

}