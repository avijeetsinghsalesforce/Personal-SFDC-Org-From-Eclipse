public class ProductSelectorUtil {
        
    // Global JSON generator
    private static JSONGenerator gen {get; set;}
    private static map<Id, boolean> selSavedItems = new map<Id, boolean>();
    private static string oppRecordType {get; set;}
    public static  String LEVEL_NOT_PRESENT = 'level_not_present';
    
    //======================================================================//
    //Create Tree Using the PriceBook passed
    //======================================================================//
    private static Map<String,Node> mpRootNode = new Map<String,Node>();
    
    public static List<Node> createTree(String priceBook) {
      Opportunity_Product_Selector__c config = getLevels(priceBook);
      Integer i = 0;
      for(Product2 product : getProducts(config)) {
        System.debug('Prodcut ><>>'+(i++));
        
        String level1 = String.valueOf(product.get(config.Level_1__c));
        if(String.isBlank(level1)) {
          level1 = config.Null_Label__c;      
        }
        
        if(!mpRootNode.containsKey(level1)) {
          mpRootNode.put(level1,new Node(level1));
        }
        Node ndChildNode = mpRootNode.get(level1);
        if(config.Level_2__c == null) {
            ndChildNode.key = product.Id;
            ndChildNode.isLeafNode = true;
          continue;
        }
        String level2 = String.valueOf(product.get(config.Level_2__c));
        level2 = level2 == NULL ? config.Null_Label__c :level2;
        Node level2Node = addChildNode(level2,ndChildNode);
        if(config.Level_3__c == null) {
            level2Node.key = product.Id;
            level2Node.isLeafNode = true;
          continue;
        }
        String level3 = String.valueOf(product.get(config.Level_3__c));
        level3 = level3 == NULL ? config.Null_Label__c :level3;
        Node level3Node = addChildNode(level3,level2Node);
        if(config.Level_4__c == null) {
            level3Node.key = product.Id;
            level3Node.isLeafNode = true;
          continue;
        }
        String level4 = String.valueOf(product.get(config.Level_4__c));
        level4 = level4 == NULL ? config.Null_Label__c :level4;
        Node level4Node = addChildNode(level4,level3Node);
        level4Node.key = product.Id;
        level4Node.isLeafNode = true;
      }
      
      return mpRootNode.values();
    }
    
    public static Node addChildNode(String ndTitle,Node rootNode){
      if(String.isBlank(ndTitle)) {
        ndTitle = 'NULL VALUE';
      }
      return rootNode.addChildNode(ndTitle);
    }
    
    //===============================================================================//   
  // Sort List of Nodes
    //================================================================================// 
    public static List<Node> sortNodes(List<Node> nodeLst) {
        Map<String,Node> mpNodes = new Map<String,Node>();
        List<Node> sortedNodeList = new List<Node>();
        for(Node node : nodeLst) {
            mpNodes.put(node.title,node);
        }
        List<String> lstNodeTitles = new List<String>();
        lstNodeTitles.addAll(mpNodes.keySet());
        lstNodeTitles.sort();
        for(String title : lstNodeTitles) {
            sortedNodeList.add(mpNodes.get(title));
        }
        return sortedNodeList;
    }
    //===============================================================================//   
  // Create Jason String for List of Nodes (In Hierarchy) for CreateTree
    //================================================================================// 
    public static String getProductTree(String priceBook) {
          
        gen = JSON.createGenerator(true);
        List<Node> nodes = createTree(priceBook);
        gen.writeStartArray();
        for(Node node:sortNodes(nodes)) {
            convertNodeToJSON2(node);   
        }
        gen.writeEndArray();
        return gen.getAsString();
    }
    
  /* Get Product Tree levels from Custom Settings
  */
  public static Opportunity_Product_Selector__c getLevels(String pricebook) {
    
    Map<String, Opportunity_Product_Selector__c> allConfig = Opportunity_Product_Selector__c.getAll();
        Opportunity_Product_Selector__c config = allConfig.get(pricebook);
        if(config != NULL) {
            return config;
        }
        return NULL;
  }
  
  //===============================================================================//   
  // Query Products and retrieve only the Fields mentioned in custom setting
  // Filter : Prodcuts should belong to Opportunities Pricebook and Commtest
  // Products are not applicable
  //================================================================================//
  public static List<Product2> getProducts(Opportunity_Product_Selector__c config , String productIdString, Integer queryLimit) {
    System.debug('config ><<>'+config);
    String fieldNames = ''; 
    if(config.Level_1__c != NULL) {
         fieldNames += config.Level_1__c + ', ';
    }
    if(config.Level_2__c != NULL) {
         fieldNames += config.Level_2__c + ', ';
    }
    if(config.Level_3__c != NULL) {
         fieldNames += config.Level_3__c + ', ';
    }
    if(config.Level_4__c != NULL) {
         fieldNames += config.Level_4__c + ', ';
    }
    fieldNames += 'Id ,Name ';
    String query = 'SELECT ' + fieldNames + ' FROM Product2 ';     
    query += 'WHERE Price_List__c = \'' + String.escapeSingleQuotes(config.Pricebook__c) + '\' ';
    query += ' AND isActive = true ';
    if(productIdString != NULL) {
       query += 'AND Id in (' + productIdString + ') ';
    }
    if(queryLimit != 0) {
      query += ' ORDER BY Name limit '+queryLimit;  
    } else {
      query += ' ORDER BY Name';
    }
         
    System.debug('*************QUERY**************' + query);    
    
    return Database.query(query);
  }
  
  
  public static List<Product2> getProducts(Opportunity_Product_Selector__c config) {
    return getProducts(config,NULL,2000);
  }
  
  /*
  */
  public static Set<String> sortSet(Set<String> setToSort) {
    List<String> listOfSet = new List<String>();
    listOfSet.addAll(setToSort);
    listOfSet.sort();
    Set<String> sortedSet = new Set<String>();
    sortedSet.addAll(listOfSet);
    return sortedSet;
  }
  
  
  //======================== Lazy Tree Starts =======================//
  
  /* Get Tree Levels
  */ 
  public static List<Node> getLevel(String pricebook, String levelKey , Integer lvl) {
    Opportunity_Product_Selector__c config = getLevels(priceBook);
    System.debug('getProdcutQuery ><>> '+getProdcutQuery(config,levelKey,'name'));
    Integer levelCount = getLevelCount(config);
    if(levelCount == (lvl+1)) {
      //Current Level is final level return Products
      String field = (levelCount == 4) ? config.Level_4__c : (levelCount == 3) ? config.Level_3__c : (levelCount == 2) ? config.Level_2__c :config.Level_1__c ;
      return getProdcuts(config,levelKey,field);
    }
    if(lvl == 1) {
      Set<String> currentSet = getSet(config,levelKey,config.Level_2__c);
      return createNodeList(currentSet,levelKey,false);
    }
    if(lvl == 2) {
      Set<String> currentSet = getSet(config,levelKey,config.Level_3__c);
      return createNodeList(currentSet,levelKey,false);
    }
    
    return NULL;
  }
  
  public static List<Node> getProdcuts(Opportunity_Product_Selector__c config,String levelKey,String field) {
    String query = getProdcutQuery(config,levelKey,field);
    List<Product2> lstProdcut = (List<Product2>) Database.query(query);
    List<Node> lstNode = new List<Node>();
    for(Product2 product : lstProdcut) {
      Node node = new Node((String)product.get(field),true);
      node.key = product.Id;
       lstNode.add(node);
    }
    lstNode = sortNodes(lstNode);
    return lstNode;
  }
  
  public static Set<String> getSet(Opportunity_Product_Selector__c config,String levelKey,String field) {
    
    Set<String> setField = new Set<String>();
    String query = getProdcutQuery(config,levelKey,field);
    System.debug('QueRRy ><>> '+query);
    List<Product2> lstProdcut = (List<Product2>) Database.query(query);
    for(Product2 product : lstProdcut) {      
      String levelValue = (String)product.get(field);
      levelValue = levelValue == NULL ? config.Null_Label__c : levelValue;
      setField.add(levelValue);
    }
    return setField;
  }
  
  public static Integer getLevelCount(Opportunity_Product_Selector__c config) {
    Integer i = 0;
    if(config.Level_1__c == NULL ) {
      return i;
    }
    i += 1;
    if(config.Level_2__c == NULL ) {
      return i;
    }
    i += 1;
    if(config.Level_3__c == NULL ) {
      return i;
    }
    i += 1;
    if(config.Level_4__c == NULL ) {
      return i;
    }
    i += 1;        
    return i;
  }
  
  public static String getProdcutQuery(Opportunity_Product_Selector__c config,String levelKey,String field) {
    String query = 'SELECT Id,'+field+ ' FROM Product2 WHERE Price_list__c = \''+
                    String.escapeSingleQuotes(config.Pricebook__c)+'\' ';
    query += ' AND isActive = true AND ';
    List<String> lstLevels = levelKey.split('--');
    for(Integer i = 0; i<lstLevels.size();i++) {      
      if(i == 0) {
        if(config.Level_1__c != NULL) {
          query += config.Level_1__c + ' = \'' +  lstLevels[i]+'\' AND ';
          continue;
        } else {
          break;
        }
      }
      if(i == 1) {
        if(config.Level_2__c != NULL) {
          query += config.Level_2__c + ' = \'' +  lstLevels[i]+'\' AND ';
          continue;
        } else {
          break;
        }
      }
      if(i == 2) {
        if(config.Level_3__c != NULL) {
          query += config.Level_3__c + ' = \'' +  lstLevels[i]+'\' AND ';
          continue;
        } else {
          break;
        }
      }
      if(i == 3) {
        if(config.Level_4__c != NULL) {
          query += config.Level_4__c + ' = \'' +  lstLevels[i]+'\' AND ' ;
          continue;
        } else {
          break;
        }
      }
    }
    if(query.endsWith('AND ')) {
      query = query.subString(0,query.length()-4);
    }
    if(query.contains('\''+config.Null_Label__c+'\'')) {
      query = query.replaceAll('\''+config.Null_Label__c+'\'','null');
    } 
    System.debug('quer ><>> ' +query);
    return query;
  }
  
  /* Get Product Tree (Lazy Loding) 
  *  return 1st level
  */  
  public static String getLazyProductTree(String pricebook) {    
    gen = JSON.createGenerator(true);
    Opportunity_Product_Selector__c config = getLevels(priceBook);
    Set<String> lvlSet = getFirstLevel(config);
    List<Node> lstNodes = createNodeList(lvlSet, NULL,false);   
    gen.writeStartArray();
    for(Node node:sortNodes(lstNodes)) {
    convertNodeToJSON2(node);   
    }
    gen.writeEndArray();
    return gen.getAsString();
  }
  
  public static Set<String> getFirstLevel(Opportunity_Product_Selector__c config) {
    List<Product2> lstProduct = getProducts(config,NULL,0);
    Set<String> setlevel1 = new Set<String>();
    System.debug('lstProduct.size() <><< '+lstProduct.size());
    for(Product2 product : lstProduct){
      if(config.Level_1__c != NULL) {
        String level1Value = (String)product.get(config.Level_1__c);
        level1Value = level1Value == NULL ? config.Null_Label__c : level1Value;    
         setlevel1.add(level1Value);
       }    
    }  
    setlevel1 = sortSet(setlevel1);
    return setlevel1;
  }
  
  public static List<Node> createNodeList(Set<String> levelSet, String key, boolean isLeafNode) {
    List<Node> nodeList = new List<Node>();
    for(String lvl : levelSet) {
      Node node = new Node(lvl,isLeafNode);
      if(key == NULL) {
        node.key = lvl;    
      } else {
        node.key = key + '--'+ lvl;
       }
       nodeList.add(node);
    }
    return sortNodes(nodeList);
  }
  
  
  //======================== Lazy Tree Ends =======================//
    
  /* Convert Node list in Jason format
  */
    private static void convertNodeToJSON2(Node objNW){
    gen.writeStartObject();      
    gen.writeStringField('title', objNW.title);
    gen.writeStringField('key', objNW.key == NULL ? '':objNW.key );
    gen.writeBooleanField('isLazy', objNW.isLeafNode?false:true);
    gen.writeBooleanField('unselectable', objNW.isLeafNode?false:true);
    gen.writeBooleanField('hideCheckbox', objNW.isLeafNode?false:true);   
    gen.writeBooleanField('isFolder', objNW.isLeafNode?false:true);
   
    if (objNW.lstChildNode != NULL && objNW.lstChildNode.size() > 0) {
            gen.writeFieldName('children');
      gen.writeStartArray();
        for (Node node : sortNodes(objNW.lstChildNode)) {       
                    convertNodeToJSON2(node);       
      }
      gen.writeEndArray();
      }
    gen.writeEndObject();
    }
    
 
  //===============================================================================//   
  //Represents a Node in the Tree
  //================================================================================//
    public class Node {
      public String title {get;set;}
      public String key {get;set;}
      public List<Node> lstChildNode {get;set;}   
      private Map<String,Node> mpChildNodeByKey = new Map<String,Node>();     
      public Boolean isLeafNode = false;
      
      public boolean unselectable {get;set;} 
      public boolean hideCheckbox {get;set;} 
      public boolean isLazy {get;set;} 
      public boolean isFolder {get;set;}
      
      public Node(String title) {
        this.title = title;
        this.lstChildNode = new List<Node>();
      }
      
      public Node(String title,Boolean isLeaf) {
        this.title = title;
        this.lstChildNode = new List<Node>();
        this.isLeafNode = isLeaf;
        this.unselectable = !isLeaf;
        this.hideCheckbox = !isLeaf;
        this.isLazy = !isLeaf;
        this.isFolder = !isLeaf;
      }
      
      public Node addChildNode(String title) {
        if(mpChildNodeByKey.containsKey(title)) {
          return mpChildNodeByKey.get(title);
        }
        
        Node ndChildNode = new Node(title);
        this.lstChildNode.add(ndChildNode);
        this.mpChildNodeByKey.put(title,ndChildNode);
        
        return ndChildNode;
      }
    }
  //=================================================================================//
    
}