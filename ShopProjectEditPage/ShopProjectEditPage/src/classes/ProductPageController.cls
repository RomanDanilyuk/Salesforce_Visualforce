public with sharing class ProductPageController {

   

    private String sortDirection = 'ASC';
    private String sortexp = 'Name';
    List<Product__c> selList;
    
    public Boolean flag { get; set; }
    private Integer count = 0;
    private Integer pagesize = 15;
    private Integer totalsize { get; set; } 
    public String searchValue { get; set; }
    List<Product__c> prdList { get; set; }
    
    
    public ProductPageController(){
     totalsize = [select count() from Product__c];
     searchValue = '';  
             
    }
    
     public List<Product__c> getProducts() {
     
         String sortString = sortExp + ' ' + sortDirection; 
         if(flag == true){
            try {
                prdList = Database.query('SELECT Id, Name, Price__c, Units__c, Available__c, Type__c, Release__c, Added__c, Selected__c FROM Product__c ORDER BY ' + sortString + 
            ' limit ' + pagesize + ' offset ' + count + '');
                
                return prdList;
                
            } catch (QueryException e){       
                ApexPages.addMessages(e);   
                return null;
            }
            
        }       
        else{
         System.debug('else');
          searchByName();         
          return prdList;
          }
          
    }
    
    public PageReference searchByName() {
              
        if(searchValue.length() > 0){     
              
            String search = '\'%' + searchValue + '%\'';
            String search1 = '%' + searchValue + '%';
            String sortString = sortExp + ' ' + sortDirection;
            
            prdList = new List<Product__c>();
            prdList = Database.query('SELECT Id, Name, Price__c, Units__c, Available__c, Type__c, Release__c, Added__c, Selected__c FROM Product__c WHERE Name LIKE ' + search + ' ORDER BY ' + sortString + 
        ' limit ' + pagesize + ' offset ' + count + '');    
            totalsize =  [SELECT count() FROM Product__c WHERE Name LIKE : search1 ];
            if(totalsize <= pagesize)
                count = 0;
            System.debug(prdList);
        }
        else{
         String sortString = sortExp + ' ' + sortDirection;       
        prdList = Database.query('SELECT Id, Name, Price__c, Units__c, Available__c, Type__c, Release__c, Added__c, Selected__c FROM Product__c ORDER BY ' + sortString + 
        ' limit ' + pagesize + ' offset ' + count + '');
        totalsize = [select count() from Product__c];
        }
        
        return null;
    }
    
    public PageReference FirstPage(){
        count = 0;
       
        return null;
        }
        
    public PageReference Previous() {
      count -= pagesize;
      ViewData();
      return null;
   }    
    
    public PageReference Next(){
        count += pagesize;
        
        return null;
    }  
    public PageReference LastPage(){
        count = totalsize - math.mod(totalsize, pagesize);        
        return null;
    }  
    
    public Boolean getDisablePrevious(){
        if(count > 0) 
            return false;
        else return true;
    }
    public Boolean getDisableNext(){
        if(count + pagesize < totalsize)
            return false;
            else
            return true;
    }
    
    public Integer getTotalsize(){
        return totalsize;
    }
    
    public Integer getPageNumber(){
        /*Integer size = count / pagesize + 1;
        if(size >  getTotalPages())
            size = getTotalPages();           
        return size;*/
        return count / pagesize + 1;
    
    }
    public Integer getTotalPages(){    
        if(math.mod(totalsize,pagesize) > 0)
            return totalsize / pagesize + 1;
        else
            return totalsize / pagesize;  
        
    }
    
   
   
   public String sortExpression
   {
     get
     {
        return sortExp;
     }
     set
     {
       //if the column is clicked on then switch between Ascending and Descending modes
       if (value == sortExp)
         sortDirection = (sortDirection == 'ASC')? 'DESC' : 'ASC';
       else
         sortDirection = 'ASC';
       sortExp = value;
     }
   }

 public String getSortDirection()
 {
    if (sortExpression == null || sortExpression == '')
      return 'ASC';
    else
     return sortDirection;
 }

 public void setSortDirection(String value)
 {  
   sortDirection = value;
 }
 
    public PageReference  ViewData(){
        
        String sortString = sortExp + ' ' + sortDirection;
        try{       
        prdList = Database.query('SELECT Id, Name, Price__c, Units__c, Available__c, Type__c, Release__c, Added__c, Selected__c FROM Product__c ORDER BY ' + sortString + 
        ' limit ' + pagesize + ' offset ' + count + '');
        }catch(QueryException e){
            ApexPages.addMessages(e);  
        }
            return null;
    }
    
  

    public PageReference deleteSelectedRecords() {
        
        selList = new List<Product__c>();        
        for(Product__c prod : prdList){
           if(prod.Selected__c == true)
           selList.add(prod);               
        }  
               
          List<Product__c> productsId = [SELECT Id FROM Product__c WHERE Id IN : selList];
            
         delete productsId;    
        return null;
        
    } 


    public PageReference addRecord() {
        PageReference page = Page.NewProduct;
        page.setRedirect(true);
        return page;
    }


    public PageReference deleteRecord() {
        
        Id idProduct = ApexPages.currentPage().getParameters().get('productId');  
        System.debug(idProduct);
        Product__c currProd = [SELECT Id FROM Product__c WHERE id = : idProduct LIMIT 1]; 
       
        delete currProd; 
        return null;
    }


    public PageReference editRecord() {
    
        String edit = Apexpages.currentpage().getParameters().get('editId');  
        System.debug(edit);

        pageReference pageRef = new pageReference(URL.getSalesforceBaseUrl().toExternalForm() + '/e?retURL=' + edit);  

        return pageRef;  
        
    }

      
   

}