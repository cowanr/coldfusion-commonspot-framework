 Creates an A to Z listing with an index at top.  Look at the ITCS A-Z page as an example
 
 It assumes the data is going to come from a DB via a query object.
 
 Example:
 
 queryService = new Query();
 queryService.setDatasource("homepage_tools");
 queryService.setSQL("SELECT LEFT(name, 1) as section_id, name, CONCAT('item.cfm?action=page&page=', id) AS url FROM itcs_pages ORDER BY name");
 data = queryService.execute().getResult();
 
 queryService = new Query();
 queryService.setDatasource("homepage_tools");
 queryService.setSQL("SELECT DISTINCT LEFT(name, 1) as letter FROM itcs_pages ORDER BY letter");
 index = queryService.execute().getResult();
  
 atoz = new "cs-customcf.ecu-cf-framework.widgets.atoz.atoz"();
 atoz.setData(data);
 atoz.setIndex(index); // Optional:  If index is not set then no index is created.
 atoz.render();