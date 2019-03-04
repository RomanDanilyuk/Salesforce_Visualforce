public class ProductListController {
    List<Product_Table__c> products;
    public String value{get;set;}
    
    public ProductListController(){
        products=[SELECT ID, Name, Product_Description__c, Image_Url__c,Unit_Price__c from Product_Table__c];
       
    }
    
    public List<Product_Table__c> getProducts() {
         return products;   
    }
    
    
    public PageReference goOrder() {
        PageReference ref=Page.OrderPage;
        ref.setRedirect(true);
        ref.getParameters().put('q',value);
        System.debug(value);
        return ref;
        
        
    }
    
}