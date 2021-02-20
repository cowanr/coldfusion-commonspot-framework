/**
 *	The abstract class that all filter components should extend.
 *  Implements the filter interface.
 */
component output="false" implements="filter_interface" accessors="true" {

	/**
	 * ColdFusion generates the accessor methods (getter and setter) for each property in this CFC that can be invoked.
 	 * See: http://help.adobe.com/en_US/ColdFusion/10.0/Developing/WSc3ff6d0ea77859461172e0811cbec0999c-7ff5.html#WS1E722CDD-3AA0-4e17-86DB-EF6D12FC6750
 	 */

 	/**
 	 * The form component for building the filter form.
 	 */
 	property struct formTag;

 	/**
 	 * The ID value assigned to the cache object when it was created.
 	 */
 	property string cacheId;

 	/**
 	 * Specifies the cache region where you can place the cache object.
 	 */
 	property string cacheRegion;

 	/**
 	 * The name for the input
 	 */
 	property string inputName;

 	/**
 	 * The field to compare against in the SQL WHERE clause
 	 */
 	property string field;

 	/**
 	* The field to compare against the "IN" clause
 	*/
 	property string parentfield;

 	/**
 	* The field to use in the "IN" clause
 	*/
 	property string childrenfield;

 	/*
	* Subselect is used for filters that have a one to many relationship. multiselects, select2s, checkboxes, etc.
 	*/
 	property string subselect;

 	/*
	* Subselect type assumes "OR" but you can specifiy "AND"
 	*/
 	property string subselectType;

 	public function init(config = {}) {
 		formTag = new "cs-customcf.ecu-cf-framework.helpers.html.tags.form"();
 		formTag.addAttribute("method", "post");

 		inputName = "default_filter";
		cacheRegion = "ecu-cf-framework-grid-filters_" & session.sessionid;

		if(structKeyExists(config,"field")) {
			field = config.field;
		}

		if(structKeyExists(config,"parentfield")) {
			parentfield = config.parentfield;
		}
		if(structKeyExists(config,"childrenfield")) {
			childrenfield = config.childrenfield;
		}

 		if(structKeyExists(config,"inputName")) {
			setInputName(config.inputName);
		}

		if(structKeyExists(config,"subselect")) {
			setSubselect(config.subselect);
		}

		if(structKeyExists(config,"subselectType")) {
			if (config.subselectType != "AND"){
				setSubselectType("OR");
			} else {
				setSubselectType("AND");
			}
		}
 	}

 	public function setInputName(name) {
 		inputName = name;
 		setCacheId();
 		putFilterValue(); // Update cache if new value has posted.
 	}

 	public function setCacheId() {
 		cacheId = "ecu-filter-" & inputName & "_" & session.sessionid;
 	}

 	public function putFilterValue() {

 		if(StructKeyExists(form, inputName)) {
 			CachePut(cacheId, form[inputName], CreateTimeSpan(0,1,0,0), CreateTimeSpan(0,0,30,0), cacheRegion);
 		}
 		if(StructKeyExists(url, inputName)) {
 			CachePut(cacheId, url[inputName], CreateTimeSpan(0,1,0,0), CreateTimeSpan(0,0,30,0), cacheRegion);
 		}
 	}

 	public function clearFilterValue() {
 		CacheRemove(cacheId, true, cacheRegion);
 	}

 	public struct function setUrlDataAttributes(formInput) {
 		StructDelete(URL, "resetIntranet");
 		StructDelete(URL, "action");
 		for(key in URL) {
			formInput.addAttribute("data-" & key, URL[key]);
		}
		return formInput;
 	}

	public function getFilterValue() {
		if (CacheRegionExists(cacheRegion) && CacheIdExists(cacheId, cacheRegion)) {
			return CacheGet(cacheId, cacheRegion);
		} else {
			return "";
		}

	}

	public string function renderFilter () {
		throw(type="Application",message="Method Must Be Overridden",detail="The renderFilter method must be overridden in a specific filter component.");
	}
}