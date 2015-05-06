public class ProductSelectorController {
    
    public string oppId{get; set;}
    public boolean isError{get; set;}
    public Map<Id,String> productMap;
    public Opportunity opportunity{get; set;}
    private static Opportunity_Product_Selector__c config;
    private List<OpportunityLineItem> oppLineItems ;
    public List<LineItemWrapper> lineItemWrapper {get;set;}
    public Id priceBookId; 
    private static String opportunityPriceBookName;
    public boolean showSalesPrice{get;set;}
    public boolean hideSalesPrice{get;set;}
    /* Constructor
    */
    public ProductSelectorController(){     
        selectable = true;
        isError = false;
        productMap = new Map<Id,String>();
        renderSalesPrice();
        initItems();
        
  }
  
  /* Initialize
    */
  public void initItems() {
    oppId = System.currentPagereference().getParameters().get('oppId');
    if(oppId == NULL || !validateId(oppId)) {
        isError = true;
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,   
                                'Please check selected Opportunity.'));
        return;
    }
    //**//opportunity = [SELECT Price_Book__c ,Name ,Id,CurrencyIsoCode FROM Opportunity WHERE Id =: oppId];
    opportunity = [SELECT Price_Book__c ,Name ,Id FROM Opportunity WHERE Id =: oppId];
    opportunityPriceBookName = opportunity.Price_Book__c;
    priceBookId = [SELECT Id FROM Pricebook2 WHERE Name =: opportunity.Price_Book__c limit 1].Id;
    if(opportunity.Price_Book__c == 'CommTest') {
        isError = true;
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,   
                                'Product Selector Page is not configured to process Commtest products.'));
        return;
    }
    oppLineItems = getOpportunityLineItems(getFields());
    if(oppLineItems.size() > 0) {
        populateWrapper(oppLineItems);
    } else {
        lineItemWrapper = new List<LineItemWrapper>();
    }
    config = getLevels(opportunity.Price_Book__c);
  }
  
  private void populateWrapper(List<OpportunityLineItem> oppLineItems) {
    lineItemWrapper = new List<LineItemWrapper>();
    Map<Id,String> mpProdDesc = getProdDescMap(oppLineItems);
    for(OpportunityLineItem lineItem : oppLineItems) {
        lineItemWrapper.add(new LineItemWrapper(lineItem.PricebookEntry.Product2.Id,
                                                lineItem.Product_Name__c ,lineItem,mpProdDesc.get(lineItem.PricebookEntry.Product2.Id)));
    }
  }
  
  public Map<Id,String> getProdDescMap(List<OpportunityLineItem> oppLineItems) {
    config = config!= NULL ? config :getLevels(opportunity.Price_Book__c);
    Map<Id,String> prodDescMap = new Map<Id,String>(); 
    List<String> lstProductId = new List<String>(); 
    for(OpportunityLineItem lineItem : oppLineItems) {
        String temp = ' \'' +String.escapeSingleQuotes(lineItem.PricebookEntry.Product2.Id)+ '\' ';
        System.debug('temp >>>> '+ temp);
        lstProductId.add(temp);
    }
    String prodcutIdString = String.join(lstProductId,',');
    System.debug('prodcutIdString >>>> '+ prodcutIdString);
    List<Product2> lstProduct = ProductSelectorUtil.getProducts(config, prodcutIdString,0);
    for(Product2 product : lstProduct) {
        String prodDesc = getProdcutDesc(product,config);
        prodDescMap.put(product.Id,prodDesc);
    }
    return prodDescMap;
  }
  
  /* Check if String is ID
  */
  static public boolean validateId(String Idparam) {
        String id = String.escapeSingleQuotes(Idparam);
        if((id.length() == 15 || id.length() == 18) && Pattern.matches('^[a-zA-Z0-9]*$', id)) {
            return true;
        }
        return false;
    }
  /* Get Opportunity Line Item Field Set 
  */
  public List<Schema.FieldSetMember> getFields() {
    List<Schema.FieldSetMember> lstFields = SObjectType.OpportunityLineItem.FieldSets.Product_Selector.getFields();
    List<Integer> indexes = new List<Integer>();
    for(Integer i = 0; i < lstFields.size() ;i++ ) {
        if(lstFields[i].getFieldPath() == 'Product_Name__c') {
            indexes.add(i);
        }
        if(lstFields[i].getFieldPath() == 'ListPrice') {
            indexes.add(i);
        }
        if(lstFields[i].getFieldPath() == 'UnitPrice') {
            indexes.add(i);
        }
    }
    for(Integer i : indexes) {
        lstFields.remove(i);
    }
    return lstFields;
  }
  
  /* Get Opportunity Line Items 
  */
  public List<OpportunityLineItem> getOpportunityLineItems(List<Schema.FieldSetMember> lstFieldSet) {
    config = config!= NULL ? config :getLevels(opportunity.Price_Book__c);
    String prodcutFields = '';
    if(config.Level_1__c != NULL) {
        String level1 = String.valueOf(config.Level_1__c);
        prodcutFields += (level1 == NULL ? config.Null_Label__c :' PricebookEntry.Product2.'+level1) + ' , ' ;  
    }
    if(config.Level_2__c != NULL) {
        String level2 = String.valueOf(config.Level_2__c);
        prodcutFields += (level2 == NULL ? config.Null_Label__c :' PricebookEntry.Product2.'+level2) + ' , ' ;  
    }
    if(config.Level_3__c != NULL) {
        String level3 = String.valueOf(config.Level_3__c);
        prodcutFields += (level3 == NULL ? config.Null_Label__c :' PricebookEntry.Product2.'+level3) + ' , ' ;  
    }
    if(config.Level_4__c != NULL) {
        String level4 = String.valueOf(config.Level_4__c);
        prodcutFields += (level4 == NULL ? config.Null_Label__c :' PricebookEntry.Product2.'+level4) + ', ' ;   
    }           
    String query = 'SELECT '+prodcutFields;
    for(Schema.FieldSetMember f : lstFieldSet) {
        query += f.getFieldPath() + ', ';
    }
    query += 'Id ,PricebookEntryId ,PricebookEntry.Product2.Id ,ListPrice, UnitPrice ';
    if(!query.contains('Product_Name__c')) {
        query += ' ,Product_Name__c ';
    }
    query += ' FROM OpportunityLineItem ';
    query += 'Where OpportunityId = \''+oppId+'\' ';
    /*
    if((!fieldSet.contains('Quantity')) && (!fieldSet.contains('UnitPrice'))) {
        isError = true;
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,   
                                'Either Quantity or Sales Price are selected fields to display , Please contact Admin'));
        return NULL;
    }*/
    return Database.query(query);
  } 
  
   
  
    public String getJsonString() { 
        //return getAttachment(opportunity.Id);
      string str = null;       
      if(opportunity == NULL || opportunity.Price_Book__c == NULL || opportunity.Price_Book__c == 'CommTest') {
      return NULL;
    }
    //str = ProductSelectorUtil.getProductTree(opportunity.Price_Book__c);
    str = ProductSelectorUtil.getLazyProductTree(opportunity.Price_Book__c);
    System.debug('><>> str'+str);
    return str; 
  }
  
  @RemoteAction
  public static List<ProductSelectorUtil.Node> getNextLevel(String currentLevelKey,String pricebookName) {
    List<ProductSelectorUtil.Node> childNodesLst = getLevelData(currentLevelKey,pricebookName);
    system.debug('childNodesLst ><>>' + childNodesLst);
    return childNodesLst;
  }
  
  @RemoteAction
  public static List<SearchWrapper> getSearchedProducts(String searchKey,String pricebookName) { 
     
      return  getProductsJson(searchKey,pricebookName);
    //List<ProductSelectorUtil.Node> childNodesLst = getLevelData(currentLevelKey,pricebookName);
    //system.debug('childNodesLst ><>>' + childNodesLst);
    //return childNodesLst;
  }
  
  public static List<SearchWrapper> getProductsJson(String searchKey,String pricebookName) {
      Map<String, Opportunity_Product_Selector__c> allConfig = Opportunity_Product_Selector__c.getAll();
      Opportunity_Product_Selector__c config_Remote = allConfig.get(pricebookName);
        String query = 'SELECT Id , Oracle_SKU__c FROM Product2 WHERE Price_List__c = \'' +config_Remote.Pricebook__c +'\' ' ;
        if(searchKey != null && searchKey != ''){ 
          searchKey = '%'+searchKey+'%';
            query +=  ' AND Oracle_SKU__c Like \'' +searchKey +'\' Order by Oracle_SKU__c ASC LIMIT 10';
        }
        System.debug('query >>> '+query); 
        List<Product2> lstProduct = (List<Product2>) Database.query(query);   
        System.debug('lstProduct.size() >>> '+lstProduct.size());  
        //JSONGenerator gen = JSON.createGenerator(true);
        //gen.writeStartArray();
        List<SearchWrapper> lstSearchWrper = new List<SearchWrapper>();
        for(Product2 product : lstProduct) {
            lstSearchWrper.add(new SearchWrapper(product.Id,product.Oracle_SKU__c));
        //gen.writeStartObject();      
        //gen.writeStringField('label', product.Oracle_SKU__c);
        //gen.writeStringField('value', product.Id );
        //gen.writeEndObject();
        }
      //gen.writeEndArray();
      //return gen.getAsString();
      return lstSearchWrper;
  }
  
  public static List<ProductSelectorUtil.Node> getLevelData(String levelKey,String pricebookName) {
    List<String> lvlList = levelKey.split('--');
    Integer currentLevel = 0;
    // Clicked on level 1
    if(lvlList.size() == 1) {
        currentLevel = 1;
    }
    // Clicked on level 2
    if(lvlList.size() == 2) {
        currentLevel = 2;
    }
    // Clicked on level 3
    if(lvlList.size() == 3) {
        currentLevel = 3;
    } 
    return ProductSelectorUtil.getLevel(pricebookName, levelKey, currentLevel);
  }
  
  
  /* Add a blank row to the line item list
  */ 
  public Pagereference saveRecords() {
    if(lineItemWrapper == NULL || lineItemWrapper.size() == 0) {
        isError = true;
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,   
                           'Please select Produts to continue.'));
                return NULL;             
    }
    List<OpportunityLineItem> lineItemsToInsert = new List<OpportunityLineItem>();
    for(LineItemWrapper lines : lineItemWrapper){
        if(lines.lineItem.UnitPrice == NULL) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,   
                           '"12 Month Opportunity" field cannot be left blank.'));
                return NULL;
        }
      lineItemsToInsert.add(lines.lineItem);
    }
    try {
        upsert lineItemsToInsert;
    } catch(Exception ex) {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage()
        ));
        return NULL;
    }
    Pagereference ref = new Pagereference('/'+opportunity.Id);
    ref.setRedirect(true);
    return ref;
  }
  
  public Pagereference cancel() {
    Pagereference ref = new Pagereference('/'+opportunity.Id);
    ref.setRedirect(true);
    return ref;
  }
  
  /* Add a blank row to the line item list
  */ 
  public Pagereference addRow() {
    if(selectedProductId == NULL || selectedProductName == NULL) {
        return NULL;
    }
    for(LineItemWrapper lines : lineItemWrapper){
        if(lines.productId == selectedProductId) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,   
                                'Selected product is already added to the Line Item list.'));
                return NULL;
        }
    }
    //**//System.debug(selectedProductId +'---'+ priceBookId +'---'+ opportunity.CurrencyIsoCode);
    System.debug(selectedProductId +'---'+ priceBookId +'---'+ opportunity);
    //**//PricebookEntry  pbe = getPricebookEntry(selectedProductId , priceBookId , opportunity.CurrencyIsoCode);
    PricebookEntry  pbe = getPricebookEntry1(selectedProductId , priceBookId);
    if(pbe == NULL) {
        // TODO : Add Error
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,   
                                'There is no Pricebook Entry for the selected product '));
        return NULL;
    }
    OpportunityLineItem lineItem = New OpportunityLineItem(OpportunityId = opportunity.Id ,PricebookEntryId = pbe.Id);
    lineItem.Quantity = 1;
    //lineItem.UnitPrice = 1;
    String productDescription = getProdcutDesc(selectedProductId);    
    lineItemWrapper.add(new LineItemWrapper(selectedProductId , selectedProductName , lineItem , productDescription));
    selectedProductName = NULL;
    selectedProductId = NULL;
    return NULL;
  }
  
  /* Create a breadcrumb of Prodcut levels 
  */
  public String getProdcutDesc(Id selectedProductId) {
    config = config!= NULL ? config :getLevels(opportunity.Price_Book__c);
    String prodcutIdString = '\''+selectedProductId+'\'';
    List<Product2> lstProduct = ProductSelectorUtil.getProducts(config, prodcutIdString,0);
    String prodDesc = '';
      for(Product2 product : lstProduct){
      prodDesc = getProdcutDesc(product,config);
    }
    return prodDesc;
  }
  
  public String getProdcutDesc(Product2 product,Opportunity_Product_Selector__c conf) {
    String prodDesc = '';
    if(conf.Level_1__c != NULL) {
        String level1 = String.valueOf(product.get(conf.Level_1__c));
        prodDesc += (level1 == NULL ? conf.Null_Label__c :level1) + ' > ' ; 
    }
    if(conf.Level_2__c != NULL) {
        String level2 = String.valueOf(product.get(conf.Level_2__c));
        prodDesc += (level2 == NULL ? conf.Null_Label__c :level2) + ' > ' ; 
    }
    if(conf.Level_3__c != NULL) {
        String level3 = String.valueOf(product.get(conf.Level_3__c));
        prodDesc += (level3 == NULL ? conf.Null_Label__c :level3) + ' > ' ; 
    }
    if(conf.Level_4__c != NULL) {
        String level4 = String.valueOf(product.get(conf.Level_4__c));
        prodDesc += (level4 == NULL ? conf.Null_Label__c :level4) + '' ;    
    }
    
    return prodDesc;
  }
  
  
  /* Remove the selected row
  */ 
  public Pagereference removeRow() {
    Integer index;
    if(selectedProductId == NULL || selectedProductId == '') {
        return NULL;
    }
    OpportunityLineItem lineItemToDelete;
    for(Integer i = 0; i < lineItemWrapper.size() ;i++ ) {
        if(lineItemWrapper[i].productId == selectedProductId) {
            if(lineItemWrapper[i].lineItem.Id != NULL) {
              lineItemToDelete = new OpportunityLineItem(Id = lineItemWrapper[i].lineItem.Id);
            }
            index = i;
        }
    }
    if(index != NULL) {
        lineItemWrapper.remove(index);
        selectedProductName = NULL;
        selectedProductId = NULL;
    }
    if(lineItemToDelete != NULL) {
        try {
            delete lineItemToDelete;
        } catch(Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage()
            ));
            return NULL;
        }    
    }
    
    return NULL;
  }
  
  /* Get  Pricebook Entry
  */  
 /* public static PricebookEntry getPricebookEntry(Id productId , Id priceBookId , String currencyType){
      PricebookEntry pbe = [SELECT Id FROM PricebookEntry where Product2Id = :productId AND Pricebook2Id = :priceBookId
                             AND CurrencyIsoCode = :currencyType];
      return pbe;
  }
  */
  public static PricebookEntry getPricebookEntry1(Id productId , Id priceBookId ){
      PricebookEntry pbe = [SELECT Id FROM PricebookEntry where Product2Id = :productId AND Pricebook2Id = :priceBookId];
      return pbe;
  }
  
  /* Selected Prodcut Id from the Tree
  */
    public string selectedProductId;
    
    public string getselectedProductId(){
        return selectedProductId;
    }
    
    public void setselectedProductId(string sValue){                
        this.selectedProductId = sValue;                
    }
    
    /* Selected Prodcut Name from the Tree
  */
    public string selectedProductName;
    
    public string getselectedProductName(){
        return selectedProductName;
    }
    
    public void setselectedProductName(string sValue){              
        this.selectedProductName = sValue;              
    }
    
    public Boolean selectable {get; set;}
    
    public String selectNodeKeys {get; set;} {
        selectable = false;
        selectNodeKeys = 'No value selected';
    }
    
    public Map<Id,String> getProductMap() {
        if(productMap != NULL && (!productMap.isEmpty())) {
            return productMap;
        }
        config = config!= NULL ? config :getLevels(opportunity.Price_Book__c);
        for(Product2 product: ProductSelectorUtil.getProducts(config)) {
            productMap.put(product.Id,product.Name);
        }
        return productMap;
    }
    
    /* Create a List of Product for auto-complete
    */
    public String getProducts() {
        if(opportunity == NULL || opportunity.Price_Book__c == NULL || opportunity.Price_Book__c == 'CommTest') {
            isError = true;
          return NULL;
        }       
        config = config!= NULL ? config :getLevels(opportunity.Price_Book__c);
        List<SearchWrapper> searchProductList = getProductsJson(null,config.Pricebook__c);
        
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartArray();
        for(SearchWrapper product :searchProductList) {
        gen.writeStartObject();      
        gen.writeStringField('label', product.label);
        gen.writeStringField('value', product.value);
        gen.writeEndObject();
        }
      gen.writeEndArray();
      return gen.getAsString();
    }
    
    public String currentKey{get; set;}
    
    public class LineItemWrapper {
        public OpportunityLineItem lineItem {get; set;}
        public String productName {get; set;}
        public Id productId {get; set;}
        public String prodDesc {get; set;}
        public LineItemWrapper(Id productId ,String productName, OpportunityLineItem lineItem ) {
          this.productId = productId;
          this.productName = productName;
          this.lineItem = lineItem;
          this.prodDesc = '';
        }
        public LineItemWrapper(Id productId ,String productName, OpportunityLineItem lineItem ,String prodDesc) {
          this.productId = productId;
          this.productName = productName;
          this.lineItem = lineItem;
          this.prodDesc = prodDesc;
    }
  }   
  /* Get Product Tree levels from Custom Settings
  */
  public static Opportunity_Product_Selector__c getLevels(String pricebook) {
    
    Map<String, Opportunity_Product_Selector__c> allConfig = Opportunity_Product_Selector__c.getAll();
        Opportunity_Product_Selector__c config1 = allConfig.get(pricebook);
        if(config1 != NULL) {
            return config1;
        }
        return NULL;
  }
  
  public class SearchWrapper {
    public String value {get;set;}
    public String label {get;set;}
    
    public SearchWrapper(String value,String label) {
        this.value = value;
        this.label = label;
    }
  }
  
  public void renderSalesPrice(){
      String profileId = userInfo.getProfileId();
      String profileName = [select name from profile where id=:profileID].name;
      if(profileName== 'CCOP PLM'){
          showSalesPrice = false;
          hideSalesPrice = true;
      }else{
          showSalesPrice = true;
          hideSalesPrice = false;
     }
  }
}