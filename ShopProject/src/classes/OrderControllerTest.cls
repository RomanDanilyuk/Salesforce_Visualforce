@isTest
public class OrderControllerTest {
    
    @isTest
    public static void TestContructorWithValue(){
        Product_Table__c newProd = new Product_Table__c( Name = 'Phone', Unit_Price__c = 7, Units__c=40);
        insert newProd;
        
        Test.setCurrentPageReference(new PageReference('Page.OrderPage'));
		System.currentPageReference().getParameters().put('q', newProd.ID);       
        OrderController controller = new OrderController();
        System.assert(controller.value != null);
        
    }
    
    @isTest
     public static void TestContructorWithoutValue(){
        
        Test.setCurrentPageReference(new PageReference('Page.OrderPage'));
		       
        OrderController controller = new OrderController();
        System.assert(controller.value == null);
        
    }
    
    @isTest
    public static void  getProductTestWithValue(){
        Product_Table__c newProd = new Product_Table__c( Name = 'Phone', Unit_Price__c = 7, Units__c=40);
        insert newProd;
               
        OrderController controller = new OrderController();
        controller.value=newProd.Id;
        
        Product_Table__c productDB = controller.getProduct();
        System.assertEquals(newProd.ID, productDB.ID);
        
        
    }
    
     @isTest
    public static void  getProductTestWithoutValue(){
        
        OrderController controller = new OrderController();
        
        Product_Table__c productDB = controller.getProduct();
        System.assertEquals(null, productDB);
        
        
    }

    
    @isTest
    public static void actionCancelTest(){
         
        OrderController controller = new OrderController();
        PageReference productListPage = new PageReference('/apex/product_list_page');
        PageReference newPage = controller.actionCancel();
        System.assertEquals( productListPage.getUrl(), newPage.getUrl());
         
    }
    
    
    @isTest
    public static void isAmountEnoughTrueTest(){
        
        Product_Table__c newProd = new Product_Table__c( Name = 'Phone', Unit_Price__c = 7, Units__c=40);
        insert newProd;       
        OrderController controller = new OrderController();
        controller.good=newProd;
        controller.count = 5;
        controller.good.Units__c = newProd.Units__c;
        controller.isEnough = true;
        
        Boolean res=controller.isAmountEnough();
 		System.assertEquals(true, res);		       
       
        
    }
    
    @isTest
    public static void isAmountEnoughFalseTest(){
        
        Product_Table__c newProd = new Product_Table__c( Name = 'Phone', Unit_Price__c = 7, Units__c=40);
        insert newProd;       
        OrderController controller = new OrderController();
        controller.good=newProd;
        controller.count = 100;
        controller.good.Units__c = newProd.Units__c;
        controller.isEnough = true;
        
        Boolean res=controller.isAmountEnough();
 		System.assertEquals(false, res);		       
       
        
    }
    
    @isTest
    public static void isContactValidTrueTest(){
     Contact newContact = new Contact(FirstName = 'FirstName' , LastName = 'LastName' , Email = 'email@gmail.com');
        insert newContact;
        OrderController controller = new OrderController();
        controller.isValid = true;
        controller.cnt = newContact;
        controller.cnt.FirstName = newContact.FirstName;
        controller.cnt.LastName = newContact.LastName;
        Boolean res = controller.isContactValid();
        System.assertEquals(true, res);

        
    }
    
     @isTest
    public static void isContactValidFalseTest(){
     Contact newContact = new Contact(FirstName = 'FirstName' , LastName = 'Last12Name' , Email = 'email@gmail.com');
        insert newContact;
        OrderController controller = new OrderController();
        controller.isValid = true;
        controller.cnt = newContact;
        controller.cnt.FirstName = newContact.FirstName;
        controller.cnt.LastName = newContact.LastName;
        Boolean res = controller.isContactValid();
        System.assertEquals(false, res);
        
        
    }
    @isTest
    public static void CheckoutInsertedTest(){
       Contact newContact = new Contact(FirstName = 'FirstName' , LastName = 'LastName' , Email = 'email@gmail.com');
        insert newContact;
        OrderController controller = new OrderController();
        controller.isValid = true;
        controller.cnt = newContact;
        controller.cnt.FirstName = newContact.FirstName;
        controller.cnt.LastName = newContact.LastName;
        controller.cnt.Email = newContact.Email;
        Product_Table__c newProd = new Product_Table__c( Name = 'Phone', Unit_Price__c = 7, Units__c=40);
        insert newProd;       
        controller.good=newProd;
        controller.count = 5;
        controller.good.Units__c = newProd.Units__c;
        controller.isEnough = true;
        List<Contact> oldList = [SELECT ID FROM Contact WHERE FirstName =: controller.cnt.FirstName];

        controller.cnt.FirstName = 'AnotherFirstName';
        controller.Checkout();
        List<Contact> newList = [SELECT ID FROM Contact WHERE FirstName =: controller.cnt.FirstName];
        
        System.assert(oldList.size() != newList.size());

    }
    
    @isTest
    public static void CheckoutNullFirstNameNullTest(){
       Contact newContact = new Contact(LastName = 'LastName' , Email = 'email@gmail.com');
        OrderController controller = new OrderController();
        controller.isValid = true;
        controller.cnt = newContact;
        controller.cnt.LastName = newContact.LastName;
        controller.cnt.Email = newContact.Email;
        Product_Table__c newProd = new Product_Table__c( Name = 'Phone', Unit_Price__c = 7, Units__c=40);
        insert newProd;       
        controller.good=newProd;
        controller.count = 5;
        controller.good.Units__c = newProd.Units__c;
        controller.isEnough = true;
        List<Contact> oldList = [SELECT ID FROM Contact WHERE FirstName =: null];

        controller.Checkout();
        List<Contact> newList = [SELECT ID FROM Contact WHERE FirstName =: null];
        
        System.assert(oldList.size() != newList.size());

    }
    
     @isTest
    public static void CheckoutFirstNameTest(){
       Contact newContact = new Contact(FirstName = 'FirstName', LastName = 'LastName' , Email = 'email@gmail.com');
        OrderController controller = new OrderController();
        controller.isValid = true;
        controller.cnt = newContact;
        controller.cnt.FirstName = newContact.FirstName;
        controller.cnt.LastName = newContact.LastName;
        controller.cnt.Email = newContact.Email;
        Product_Table__c newProd = new Product_Table__c( Name = 'Phone', Unit_Price__c = 7, Units__c=40);
        insert newProd;       
        controller.good=newProd;
        controller.count = 5;
        controller.good.Units__c = newProd.Units__c;
        controller.isEnough = true;
        List<Contact> oldList = [SELECT ID FROM Contact WHERE FirstName != '' ];

        controller.Checkout();
        List<Contact> newList = [SELECT ID FROM Contact WHERE FirstName != ''];
        
        System.assert(oldList.size() != newList.size());

    }
    
    @isTest
    public static void getContactDBTest(){
       Contact newContact = new Contact(FirstName = 'FirstName', LastName = 'LastName' , Email = 'email@gmail.com');
        insert newContact;
        OrderController controller = new OrderController();
        controller.cnt = newContact;
		controller.cnt.FirstName = '';
        controller.cnt.LastName = '';   
        controller.cnt.Email = newContact.Email;
      
        
        controller.getDBContact();
		System.assertEquals(newContact.FirstName, controller.cnt.FirstName);        
             
    }
    
    @isTest
    public static void validateCountTest(){
        
       OrderController controller = new OrderController();
        controller.count = 5;
        Product_Table__c newProd = new Product_Table__c( Name = 'Phone', Unit_Price__c = 6, Units__c=3);
        insert newProd; 
        controller.good = newProd;
        controller.good.Units__c = newProd.Units__c;
         boolean b = false;
   
        controller.validateCount();
        List<Apexpages.Message> msgs = ApexPages.getMessages();

	   for(Apexpages.Message msg:msgs){
            if (msg.getDetail().contains('Unit Count is over. Max size is ' +  controller.good.Units__c )) b = true;
       }
	
		System.assert(b);
    }
    
}