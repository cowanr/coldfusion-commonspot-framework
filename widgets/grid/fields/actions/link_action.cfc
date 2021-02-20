/**
 * Creates a html link for the action. Allows you to add query paramerters to the url
 * from the row data struct by using a place holder.
 *
 * field.FIELD_NAME == row[FIELD_NAME]
 *
 * Example:
 *
 *  infoIcon = new "cs-customcf.ecu-cf-framework.helpers.html.bootstrap2.glyphicons"();
 *	infoIcon.setIcon("icon-info-sign");
 *	infoIcon.showPurpleIcon();
 *	infoAction = new "cs-customcf.ecu-cf-framework.widgets.grid.table.columns.actions.link_action"();
 *	infoAction.setImage(infoIcon);
 *	infoAction.setLabel("Lab Information");
 *	infoAction.addAttribute("href","lab.cfm");
 *	infoAction.addAttribute("target","_blank");
 *	infoAction.addQueryParameter("id", "field.id"); 
 */
 component extends="cs-customcf.ecu-cf-framework.helpers.html.tags.a" implements="action_interface" output="false" accessors="true"{

	/**
	 * ColdFusion generates the accessor methods (getter and setter) for each property in this CFC that can be invoked. 
 	 * See: http://help.adobe.com/en_US/ColdFusion/10.0/Developing/WSc3ff6d0ea77859461172e0811cbec0999c-7ff5.html#WS1E722CDD-3AA0-4e17-86DB-EF6D12FC6750
 	 */

	/** 
	 * An array of unpared query parameters.
	 * Default: Empty struct
	 */
	property struct unparsedQueryParameters;

	property struct unparsedAttributes;

	/** 
	 * Add a new attribute to the tag.  Overwrites if the attribute already exists.
	 * 
	 * @param string key - The attribute name.  ie id or class
	 * @param string value - The attribute value.
	 */
	public void function addAttribute(string key, string value) {
		StructInsert(unparsedAttributes, trim(key), trim(value), true);
		return super.addAttribute(key, value);
	}

	/**
	 * Deletes all the attributes
	 *
	 * @return boolean True, on successful execution; False, otherwise.
	 */
	public function clearAttributes() {
		StructClear(unparsedAttributes);
		return super.clearAttributes();
	}

	/**
	 * Deletes a specific attribute.
	 *
	 * @param string key The attribute to delete
	 * @return boolean Returns Yes if key exists; No if it does not.
	 */
	public function deleteAttribute(string key) {
		StructDelete(unparsedAttributes, key, true);
		return super.deleteAttribute(key);
	}

	/**
	 * Set defaults
	 */
	public function init() {
		super.init();
		unparsedQueryParameters = StructNew();
		unparsedAttributes = StructNew();
	}

	/**
	 * Overrids the addQueryParameter to add to the unparsed struct
	 *
	 * @param string key
	 * @param string value
	 */
	public void function addQueryParameter(string key, string value) {
		StructInsert(unparsedQueryParameters, key, value, true);
		super.addQueryParameter(key, value);
	}

	/**
	 * Converts any string that starts with "field." to the 
	 * value in the corresponding row field. 
	 * 
	 * field.FIELD_NAME == row[FIELD_NAME]
	 */
	private void function parseQueryParameters(row) {
		for(parameter in unparsedQueryParameters) {
			pos = Find("field.", unparsedQueryParameters[parameter]);
			if ( pos > 0) {
	    		fieldName = Right(unparsedQueryParameters[parameter], Len(unparsedQueryParameters[parameter]) - 6);
	    		if (StructKeyExists(row, fieldName)) {
	    			queryParameters[parameter] = row[fieldName];
	    		} 
	    	}
		}
	}

	/**
	 * Converts any string that starts with "field." to the 
	 * value in the corresponding row field. 
	 * 
	 * field.FIELD_NAME == row[FIELD_NAME]
	 */
	private void function parseAttributes(row) {
		for(parameter in unparsedAttributes) {
			tmpAttribute = unparsedAttributes[parameter];

			while(Find("field.", tmpAttribute) != 0) {

				result = REFind("field.[a-zA-Z0-9-_]*", tmpAttribute,1,"TRUE");
				if(result.pos[1] > 0) {
					replaceStr = Mid(tmpAttribute, result.pos[1], result.len[1]);
					fieldName = Mid(tmpAttribute, result.pos[1] + 6, result.len[1]-6);
					valueStr = row[fieldName];
					tmpAttribute = Replace(tmpAttribute, replaceStr, valueStr, "all");
				}
	    	}

	    	if(tmpAttribute != attributes[parameter]) {
	    		attributes[parameter] = tmpAttribute;
	    	}
		}
	}

	/**
	 * Renders the action for the action column
	 */
	public string function renderAction(row = "") {
		parseAttributes(row);
		parseQueryParameters(row);
		return super.render();
	}
}