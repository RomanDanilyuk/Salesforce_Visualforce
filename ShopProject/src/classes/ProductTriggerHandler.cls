public with sharing class ProductTriggerHandler {
   
    public static void handleBeforeInsert(List<Product_Table__c> newProducts){
        
        List<Date> dateProducts = new List<Date>();
        List<Warehouse__c> warList = new List<Warehouse__c>();
        List<Warehouse__c> newWarList = new List<Warehouse__c>();

        Integer i=0;
        Warehouse__c newWar;
        Org_Configuration__c org = Org_Configuration__c.getInstance();
      	
        if(newProducts[0].Added_Date__c == null)
            newProducts[0].Added_Date__c = date.today();
        
        String stringQuery = 'SELECT Id, Period_Start__c, Period_End__c FROM Warehouse__c WHERE';
   
            for(Product_Table__c prod : newProducts){  
                if(prod.Added_Date__c == null) 
              		prod.Added_Date__c = date.today();
                
                if(prod == newProducts[0]){
                    stringQuery += ' (Period_Start__c <= ' + ((DateTime)newProducts[0].Added_Date__c).format('YYYY-MM-dd') + ' AND Period_End__c >= ' + ((DateTime)newProducts[0].Added_Date__c).format('YYYY-MM-dd') + ')';
                }else{
                    stringQuery += ' OR (Period_Start__c <= ' + ((DateTime)newProducts[0].Added_Date__c).format('YYYY-MM-dd') + ' AND Period_End__c >= ' + ((DateTime)newProducts[0].Added_Date__c).format('YYYY-MM-dd') + ')' ;
                }
            }
        
        System.debug('stringQuery = ' + stringQuery);
        
		List<Warehouse__c> existingWar = Database.query(stringQuery);
        
  
        for(Product_Table__c newProd : newProducts){                     
            
                if(existingWar.size()>0){
            		newProd.Warehouse__c = existingWar[0].Id;
                }else {                  
                    newWar = new Warehouse__c();
                    newWar.Name = 'Warehouse ' + ((DateTime)newProd.Added_Date__c).format('YYYY-MM-dd') + ' '
                        + ((DateTime)newProd.Added_Date__c.addDays((Integer	)org.Period_Term__c)).format('YYYY-MM-dd');
                    newWar.Period_Start__c = newProd.Added_Date__c;
                    newWar.Period_End__c = newProd.Added_Date__c + (Integer)org.Period_Term__c;                    
                    newWarList.add(newWar);
                 	                  
                }
                           
        }
        if(newWarList.size() > 0){
       		 insert newWarList;
        }
    	
        for(Product_Table__c prodItem : newProducts ){
            if(prodItem.Warehouse__c == null){
                prodItem.Warehouse__c = newWarList[i].id;
                i++;
            }
        }
    }
}