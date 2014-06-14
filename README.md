XmlSyncToMySql
==============

This repository includes a code for synchronizing XMLs data into a MySql DB's tables using a pure XML + MySql solution.

Our specific solution:
======================
A scheduled event (see code) calling a stored-procedure (see code) with a products.xml (see code) text as a parameter that parse the XML and loading it straight into the corresponded database tables. 

This is the high-level flow of the process:
============================
ProductsDataSyncEvent event is raised on a daily basis ->
Calling the SyncProductsDataFromXML SP with the products XML ->
The XML is parsed and loaded into the DB's tables

Usage example:
==============
```
  SET @productsXml = LOAD_FILE('C:/MySqlXmlSync/products.xml');
  
  CALL SyncProductsDataFromXML(@productsXml);
```
