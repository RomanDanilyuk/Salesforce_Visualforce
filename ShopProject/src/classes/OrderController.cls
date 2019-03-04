public  class OrderController {

    public PageReference validateCount() {
        if(count>good.Units__c){
            ApexPages.Message msg=new ApexPages.Message(ApexPages.Severity.Warning,'Unit Count is over. Max size is ' + good.Units__c);
            ApexPages.addMessage(msg);
        }
        return null;
    }


    public PageReference actionCancel() {
        PageReference page=Page.Product_List_Page;
        page.setRedirect(true);
        return page;
    }

    List<Contact> contactDB=new List<Contact>();
    public Product_Table__c good{get;set;}
    public Contact cnt{ get; set; }
    public String value{get;set;}  
    public Integer count{get;set;}
    public Boolean isEnough=true;
    public Boolean isValid=true;
    public Integer balance;
    List<Contact> currContact=new List<Contact>();
    
    public OrderController(){
          value=ApexPages.currentPage().getParameters().get('q');    
          cnt=new Contact();
                                 
    }
    
    public Product_Table__c getProduct(){
        if(value != null){
          good=[SELECT Name,Image_Url__c,Product_Description__c,Unit_Price__c,Units__c FROM Product_Table__c WHERE ID =:value];      
          return good;
        }else{return null;}
                  
    }
    
    public PageReference getDBContact() {
             contactDB.clear();
             cnt.FirstName='';
             cnt.LastName='';
            if(cnt.Email != null){
            contactDB=[SELECT FirstName, LastName, Email FROM Contact WHERE Email=:cnt.Email LIMIT 1];           
                if(contactDB.size()>0){
                cnt.FirstName=contactDB[0].FirstName;
                cnt.LastName=contactDB[0].LastName;          
                            
                }
                             
          }
    
        return null;
        
    }
      
    
    public Boolean isAmountEnough(){
        balance=(Integer)good.Units__c-count;            
        if(balance<0)
            isEnough=false;
        else{
            good.Units__c=balance;
            update good;}
        
        return isEnough;      
    }
    
    public Boolean isContactValid(){
        Boolean checkLast;
        if(cnt.FirstName != null && cnt.LastName != null){
        Boolean checkFirst = pattern.matches('^(?![ .]+$)[a-zA-Z .]*$', cnt.FirstName);
        checkLast = pattern.matches('^(?![ .]+$)[a-zA-Z .]*$', cnt.LastName);
            if(checkFirst == false || checkLast == false){isValid=false;}                      
            
        }else if(cnt.FirstName == null){
            checkLast = pattern.matches('^(?![ .]+$)[a-zA-Z .]*$', cnt.LastName);
            if(checkLast == false){isValid=false;}                      
            
        }
        return isValid;
     
                  
    }
    
     public PageReference Checkout() {
         
     if(cnt.Email!=null){
             isContactValid();
             currContact=[SELECT FirstName, LastName, Email FROM Contact WHERE Email=:cnt.Email LIMIT 1];
             
             if(isValid){
             if(currContact.size()>0){
                 currContact[0].FirstName=cnt.FirstName;
                 currContact[0].LastName=cnt.LastName;
                 update currContact[0];
             }else if(cnt.FirstName != null){
                 Contact newContact=new Contact();
                 newContact.FirstName=cnt.FirstName;
                 newContact.LastName=cnt.LastName;
                 newContact.Email=cnt.Email;
                 insert newContact;
                 currContact.add(newContact);
             }else if(cnt.FirstName == null){
                 Contact newContact=new Contact();              
                 newContact.LastName=cnt.LastName;
                 newContact.Email=cnt.Email;
                 insert newContact;
                 currContact.add(newContact);
             }
                      
                 isAmountEnough();
                 
                 if(isEnough==true && count>0){
                     Order__c order=new Order__c();
                     order.Product__c=good.ID;
                     order.Units__c=count;
                     order.Order_Amount__c=good.Unit_Price__c*count;
                     order.Contact__c=currContact[0].ID;
                     order.Name = good.Name +' '+ order.Order_amount__c; 
                     insert order;             
                                          
                     ApexPages.Message msg=new ApexPages.Message(ApexPages.Severity.confirm,'Your order successful create!');
                     ApexPages.addMessage(msg);
                     cnt.Email='';
                     cnt.FirstName='';
                     cnt.LastName='';
                     count=0;
                           
                     }else{
                          ApexPages.Message msg=new ApexPages.Message(ApexPages.Severity.Error,'Your order can not be create! Please, check values.');
                          ApexPages.addMessage(msg);
                     }
                 } else{
                          ApexPages.Message msg=new ApexPages.Message(ApexPages.Severity.Error,'You enter incorrect First Name or LastName!');
                          ApexPages.addMessage(msg);
                 }
                                  
             }else{
              ApexPages.Message msg=new ApexPages.Message(ApexPages.Severity.Error,'Please, enter email.');
                          ApexPages.addMessage(msg);
             }
                           
         
        
                 
          return null;
}
   
   
}