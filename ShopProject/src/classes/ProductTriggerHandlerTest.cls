@isTest
public class ProductTriggerHandlerTest {
    
    @isTest
    public static void  handleBeforeInsertTestWithoutWarehouse(){
        
        Org_Configuration__c org = Org_Configuration__c.getInstance();
        List<Product_Table__c> insertList = new  List<Product_Table__c>();
		org.Period_Term__c = 10;
        insert org;
        for(Integer i=0; i<160; i++){
        	insertList.add(new Product_Table__c(Name = 'ProductName' + i, Added_Date__c = Date.today(), Unit_Price__c = 100 , Units__c = ++i));  					
        }
       	
        insert insertList;
                
        Database.SaveResult[] results = Database.insert(insertList, false);
        
        for(Database.SaveResult result : results)
       		 System.assert(!result.isSuccess());
        
    }
    
    @isTest
    public static void  handleBeforeInsertTest(){
        
        Org_Configuration__c org = Org_Configuration__c.getInstance();
        List<Product_Table__c> insertList = new  List<Product_Table__c>();
		org.Period_Term__c = 10;
        insert org;
        Warehouse__c newWar = new Warehouse__c(Name = 'SomeWarehouse', Period_Start__c = Date.today().addDays(-2) , Period_End__c = Date.today().addDays(+3));
        insert newWar;
        for(Integer i=0; i<160; i++){
        	insertList.add(new Product_Table__c(Name = 'ProductName' + i, Added_Date__c = Date.today(), Unit_Price__c = 100 , Units__c = i++));  					
        }
       	
        insert insertList;
                
        Database.SaveResult[] results = Database.insert(insertList, false);
        
        for(Database.SaveResult result : results)
       		 System.assert(!result.isSuccess());
        
    }
    
    @isTest
    public static void  handleBeforeInsertTestWithNullDateWarehouse(){
        
        Org_Configuration__c org = Org_Configuration__c.getInstance();
        List<Product_Table__c> insertList = new  List<Product_Table__c>();
		org.Period_Term__c = 10;
        insert org;
        for(Integer i=0; i<160; i++){
        	insertList.add(new Product_Table__c(Name = 'ProductName' + i, Unit_Price__c = 100 , Units__c = ++i));  					
        }
       	
        insert insertList;
                
        Database.SaveResult[] results = Database.insert(insertList, false);
        
        for(Database.SaveResult result : results)
       		 System.assert(!result.isSuccess());
        
    }


}