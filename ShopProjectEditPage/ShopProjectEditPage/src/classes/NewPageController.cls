public with sharing class NewPageController {

    private Boolean isValid = true;
    public Product__c newProd { get; set; }
    
    public NewPageController(){
        newProd = new Product__c();
    }
   
    public Boolean isNameValid(){            
        isValid = pattern.matches('^(?![ .]+$)[a-zA-Z .]*$', newProd.Name);     
        return isValid;
        
    }

    public PageReference Save() {
       isNameValid();
       
        System.debug(isValid);
        if(isValid == true){
            if(newProd.Price__c > 0){
            Product__c prd = new Product__c();
            prd.Name = newProd.Name;
            prd.Price__c = newProd.Price__c;
            prd.Units__c = newProd.Units__c;
            prd.Type__c = newProd.Type__c;
            prd.Added__c = newProd.Added__c;
            prd.Release__c = newProd.Release__c;
            insert prd;
            newProd.Name = '';
            newProd.Price__c = 0;
            newProd.Units__c = 0;
            newProd.Added__c = null;
            newProd.Release__c = null;
            newProd.Type__c = null;
            }else{
             ApexPages.Message msg=new ApexPages.Message(ApexPages.Severity.Error,'Price can not be a 0.');
                          ApexPages.addMessage(msg);
            }
        
        }else {
        ApexPages.Message msg=new ApexPages.Message(ApexPages.Severity.Error,'You enter incorrect value!.');
                          ApexPages.addMessage(msg);
            }
        
        
        return null;
    }


    public PageReference actionCancel() {
        PageReference page = Page.ProductPage;
        page.setRedirect(true);       
        return page;
    }


}