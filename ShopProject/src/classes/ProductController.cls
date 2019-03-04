public with sharing class ProductController {
    
    public String value{get;set;}
      
    public ProductController(){
         
          value=ApexPages.currentPage().getParameters().get('q');
                        
    }
    
    public PageReference goOrder() {
        PageReference ref=Page.OrderPage;
        ref.setRedirect(true);
        ref.getParameters().put('q',value);
        return ref;
    }
    
    public Product_Table__c getProduct(){
        if(value != null)
          return [SELECT Name,Image_Url__c,Product_Description__c,Unit_Price__c,Units__c FROM Product_Table__c WHERE ID =:value];
        else{ return null;}
          
    }
    
    

}