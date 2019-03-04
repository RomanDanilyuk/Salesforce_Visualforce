public with sharing class ProductTriggerHandler {
    
    public static void beforeInsert(List<Product__c> products){
        
        for (Product__c product : products){
            if(product.Units__c > 0)
            	product.Available__c = true;
           
        }
        
        
    }
    
     public static void beforeUpdate(List<Product__c> newProducts){
       
        for (Product__c product : newproducts){
            
            if(product.Units__c > 0)
            product.Available__c = true;
            else
                product.Available__c = false;
        }
        
        
    }


}