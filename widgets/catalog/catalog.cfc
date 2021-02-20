/**
 * Creates and displays a program and course listing from Acalog
 * cip code is required, (catalog) type is optional
 * 
 * Example:
 * catalog = new "cs-customcf.ecu-cf-framework.widgets.catalog.catalog"("cipcode", "catalog");
 * catalog.render();
 */
component output="false" accessors="true" {

	//undergraduate catalog id
	property string undergraduateCatalogId;

	//graduate catalog id
	property string graduateCatalogId;

	//acalog degree id
	property string degreeId;

	//acalog degree courses
	property string degreeInfo;

	//catalog url
	property string catalogLink;

	//output
	property string output;

	public function init(cipCode = "", type = "") {

		//acalog API key
		API_KEY = "0eb04e6577f7247ccb10e4c76637444a580974bd";
		
		//acalog API base URL
		API_URL = "http://ecu.apis.acalog.com/v1";
		
		queryService = new Query();
		queryService.setDatasource("homepage_tools"); 
		result = queryService.execute(sql="SELECT * FROM homepage_tools.acalog_current_catalog").getResult(); 

		GRADUATE_CATALOG = result.catalog_id[1];
		UNDERGRADUATE_CATALOG = result.catalog_id[2];

		degreeId = "";
		degreeInfo = [];

		if (Len(cipCode)) {

			if(Len(type)) {

				// type is "graduate"
				if (type == "graduate") {
					degreeId = cipCodeSearch(cipCode, GRADUATE_CATALOG);
					

					if (degreeId NEQ "Not Found"){
						//get catalog url
						catalogLink = getCatalogURL(degreeId, GRADUATE_CATALOG);
						degreeInfo = getCourses(degreeId, GRADUATE_CATALOG);
						buildOutput(degreeInfo);
					} else {
						output= "Degree Not Found";
					}

				}
				// type is "undergraduate"
				if (type == "undergraduate") {
					degreeId = cipCodeSearch(cipCode, UNDERGRADUATE_CATALOG);
					
					if (degreeId NEQ "Not Found"){
						//get catalog url
						catalogLink = getCatalogURL(degreeId, UNDERGRADUATE_CATALOG);
						degreeInfo = getCourses(degreeId, GRADUATE_CATALOG);
						buildOutput(degreeInfo);
					} else {
						output= "Degree Not Found";
					}

				}

			}
			// look up type
			else {
				neededCatalog = gradOrUndergradCatalog();
				if (Len(neededCatalog)) {
					degreeId = cipCodeSearch(cipCode, neededCatalog);

					if (degreeId NEQ "Not Found"){
						//get catalog url
						catalogLink = getCatalogURL(degreeId, graduateCatalogId);

						degreeInfo = getCourses(degreeId, GRADUATE_CATALOG);
						buildOutput(degreeInfo);
					} else {
						output= "Degree Not Found";
					}
				} else {
					output = "Program not found.";
				}
			}

		}


	}

	/**
	 * Cip Code Search
	 *
	 * Takes a cip code and catalog id and looks up the program information in Acalog
	 */
	public function cipCodeSearch(query, catalogId) {
		httpService = new http();
		httpService.setURL(API_URL & "/search/programs?key=" & API_KEY & "&format=xml&method=search&catalog=" & catalogId & "&query=" & query);
		result = httpService.send().getPrefix();

		if (result.Statuscode contains "200"){
			resultContents = XMLParse(result.Filecontent);
		} else {
			WriteOutput("Unable to connect to service");
			exit;
		}	

		if (StructKeyExists(resultContents, "catalog") &&
			StructKeyExists(resultContents.catalog, "search") &&
			StructKeyExists(resultContents.catalog.search, "results") &&
			StructKeyExists(resultContents.catalog.search.results, "result") && 
			StructKeyExists(resultContents.catalog.search.results.result[1], "id") && 
			StructKeyExists(resultContents.catalog.search.results.result[1].id, "XmlText")
		){
			return resultContents.catalog.search.results.result[1].id.XmlText;
		} else {
			return "Not Found";
		}
		
	}

	/**
	 * Catalog Lookup
	 *
	 * Takes a cip code and uses the Degree Explorer table to try to find which catalog to use
	 * if the catalog type is not specified initially
	 */
	public function gradOrUndergradCatalog (cipCode) {
		result = queryService.execute(sql="SELECT bannerValue FROM degree_explorer_records WHERE cipCode = :cip"); 
		
		getCatalog = result.getResult(); 
		/* getPrefix() returns information like recordcount,sql etc (typically whatever one gets if one uses the result attribute of the cfquery tag */ 
		metaInfo = result.getPrefix(); 
		
		if (Left(getCatalog["bannerValue"][1], 1) EQ "U"){
			returnedValue = UNDERGRADUATE_CATALOG;
		} else {
			returnedValue = GRADUATE_CATALOG;
		}
		return returnedValue;
	}

	/**
	 * Catalog URL
	 *
	 * Takes a degree id and catalog id from Acalog and creates the url to the program
	 */
	public function getCatalogURL(degreeId, catalogId) {

		if (degreeId != "Not Found" ) {
			path = "//catalog.ecu.edu/preview_program.php?catoid=" & catalogId & "&poid=" & degreeId;
		} else {
			path = "";
		}

		return path;
	}

	/**
	 * Course Lookup
	 *
	 * Takes a degree id (id) and catalog id (catalogId) and gets the course results from Acalog
	 */
	public function getCourses(id, catalogId){
		httpService = new http();
		httpService.setURL(API_URL & "/content?key=" & API_KEY & "&format=xml&method=getItems&type=programs&ids[]=" & id & "&catalog=" & catalogId);
		result = httpService.send().getPrefix();

		if (result.Statuscode contains "200"){
			resultContents = XMLParse(result.Filecontent);
		} else {
			WriteOutput("Unable to connect to service");
			exit;
		}
		return resultContents;
	}

	/**
	 * Adhoc Content
	 *
	 * Takes an adhoc content's position (position), the course cores (adhoc), and the course's xpointer (xpointer)
	 * Places adhoc content in it's correct position with course content
	 */
	public function processAdhoc (position, adhoc, xpointer) {

		for (d=1;d LTE ArrayLen(adhoc);d++){
			if (adhoc[d]["XmlName"] EQ "adhoc"){
				//check for course match
				if(FindNoCase(adhoc[d].XmlAttributes["course"], xpointer)) {
					if(adhoc[d].XmlAttributes["position"] == position) {
						
						if(structKeyExists(adhoc[d],"a:title")) {
							if (adhoc[d]["a:title"].XmlText == "blank space") {
								output &= "<br />";
							} else if (adhoc[d]["a:title"].XmlText == "Line Break" || adhoc[d]["a:title"].XmlText == "line break") {
								output &= "<br />";
							} else if (position == 'before' || position == 'after') {
								output &= "<li class='course'>" & adhoc[d]["a:title"].XmlText & "</li>";
							} else {
								output &= adhoc[d]["a:title"].XmlText;
							}
						}

					}
				}
			}
		}

	}
	
	/**
	 * Process Core Course Content
	 *
	 * Takes a course core (core) and adds information to output
	 */
	public function processCores(core){

		//Output Title
		if (StructKeyExists(core, "a:title")){
			output &= "<div style='font-weight:bold;' class='courseTitle'>" & core["a:title"].XmlText & "</div>";
		}
		
		//Output Content
		if (StructKeyExists(core, "a:content")){
			if (StructKeyExists(core["a:content"], "h:p")){
				//Ignore it if it is just a space
				if (Len(Trim(core["a:content"]["h:p"].XmlText)) GT 1){
					output &= "<div class='courseInfo'>" & core["a:content"]["h:p"].XmlText & "</div>";
				}
			}			
		}
		
		output &= "<ul>";
		//Output Courses
		if (StructKeyExists(core, "courses")){
			for (i=1;i LTE ArrayLen(core["courses"]["XmlChildren"]);i++){
				if (core["courses"]["XmlChildren"][i]["XmlName"] EQ "xi:include"){

					//Adhoc before
					processAdhoc("before", core["courses"]["XmlChildren"], core["courses"]["XmlChildren"][i].XmlAttributes["xi:xpointer"]);
					output &= "<li class='course'>" & core["courses"]["XmlChildren"][i]["xi:fallback"]["a:title"]["XmlText"] & " ";
					//Adhoc right
					processAdhoc("right", core["courses"]["XmlChildren"], core["courses"]["XmlChildren"][i].XmlAttributes["xi:xpointer"]);
					output &= "</li>";
					//Adhoc after
					processAdhoc("after", core["courses"]["XmlChildren"], core["courses"]["XmlChildren"][i].XmlAttributes["xi:xpointer"]);

				}
			}
		}
		
		//Process Children
		if (StructKeyExists(core, "children")){
			for (j=1;j LTE ArrayLen(core["children"]["XmlChildren"]);j++){
				ProcessCores(core["children"]["XmlChildren"][j]);
			}
		}
		output &= "</ul>";
		StructClear(core);
	}

	/**
	 * Build Output
	 *
	 * Takes degree information and processes for output
	 */
	public function buildOutput(degreeInfo) {
		output = "<h4 class='degreeProgram'>" & degreeInfo.catalog.programs.program["a:title"].XmlText & "</h4>";

		if (StructKeyExists(degreeInfo.catalog.programs.program["a:content"], "h:p")){
			output &= "<div class='degreeInfo'>" & degreeInfo.catalog.programs.program["a:content"]["h:p"].XmlText & "</div>";
		}

		if (StructKeyExists(degreeInfo.catalog.programs.program, "cores")){
			if (StructKeyExists(degreeInfo.catalog.programs.program.cores, "core")){
				for (c=1;c LTE ArrayLen(degreeInfo.catalog.programs.program.cores.core);c++){
					processCores(degreeInfo.catalog.programs.program.cores.core[c]);
				}
			} else {
				output= "No Courses Listed";
			}
		} else {
			output= "No Courses Listed";
		}
	}

	public string function render() {

		//..

		return output;
	}
}
