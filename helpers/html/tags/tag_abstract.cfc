/**
 *	The abstract class that all html tags components should extend.
 *  Implements the tag interface. Do not initiate and use directly.
 */
 component 
 	hint="Abstract Class for HTML Tag Components. Should not be initiated directly, only extended." 
 	implements="cs-customcf.ecu-cf-framework.helpers.html.html_interface" 
 	output="false" 
 	accessors="true"{

	/**
	 * ColdFusion generates the accessor methods (getter and setter) for each property in this CFC that can be invoked. 
 	 * See: http://help.adobe.com/en_US/ColdFusion/10.0/Developing/WSc3ff6d0ea77859461172e0811cbec0999c-7ff5.html#WS1E722CDD-3AA0-4e17-86DB-EF6D12FC6750
 	 */

 	/**
 	 * HTML tag attributes.
 	 * Default: Empty Struct
 	 */
	property struct attributes;

	/**
	 * Set Defaults
	 */
	public function init() {
		attributes = StructNew();
	}

	/** 
	 * Add a new attribute to the tag.  Overwrites if the attribute already exists.
	 * 
	 * @param string key - The attribute name.  ie id or class
	 * @param string value - The attribute value.
	 */
	public void function addAttribute(string key, string value) {
		StructInsert(attributes, trim(key), trim(value), true);
	}

	/**
	 * Checks to see if the attribute has been added.
	 * 
	 * @param string key The attribute to check
	 * @return boolean True if attribute found, false otherwise.
	 */
	public function isAttribute(string key) {
		return StructKeyExists(attributes, key);
	}

	/**
	 * Checks to see if there are any attributes.
	 *
	 * @return boolean True if attributes exists, false otherwise.
	 */
	public function hasAttributes() {
		if (StructIsEmpty(attributes)) {
			return false;
		} else {
			return true;
		}
	}

	/**
	 * Returns the value for the specified attribute.  Returns
	 * an empty string if the attribute doesn't exist.
	 *
	 * @param string key The attribute
	 * @return string The value or an empty string.
	 */
	public function getAttribute(string key) {
		if (StructKeyExists(attributes, key)) {
			return attributes[key];
		} else {
			return "";
		}
	}

	/**
	 * Deletes all the attributes
	 *
	 * @return boolean True, on successful execution; False, otherwise.
	 */
	public function clearAttributes() {
		return StructClear(attributes);
	}

	/**
	 * Deletes a specific attribute.
	 *
	 * @param string key The attribute to delete
	 * @return boolean Returns Yes if key exists; No if it does not.
	 */
	public function deleteAttribute(string key) {
		return StructDelete(attributes, key, true);
	}

	/**
	 * Truns the attributes into a space seperated string.  It defaults to stringify the
	 * component attributes, but you can pass in an optional struct to stringify.  The struct key must
	 * be the attribute name and the struct value for that key is the attribute value.
	 *
	 * @param mixed attributes (optional) An structure to stringify 
	 * @return string The attributes as a string.
	 */
	public string function stringifyAttributes(attrs = "") {
		if (isSimpleValue(attrs)) {
			attrs = attributes;
		}

		var str = "";
		for(key in attrs) {
			str = str & EncodeForHTMLAttribute(key, true) & "='" & EncodeForHTMLAttribute(attrs[key], true) & "' ";
		}
		return str;
	}

	/**
	 * Returns the html tag as a string.
	 * Must override this function or it will throw an error.
	 */
	public string function render() {
		throw(type="Application",message="Method Must Be Overridden",detail="The render method must be overridden in a specific tag component.");
	}
}