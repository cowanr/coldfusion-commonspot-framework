/**
 * Extends the tr html tag and adds the bootstrap 2 options for table rows.
 */
 component extends="cs-customcf.ecu-cf-framework.helpers.html.tags.table.tr" output="false" accessors="true"{

	/**
	 * ColdFusion generates the accessor methods (getter and setter) for each property in this CFC that can be invoked. 
 	 * See: http://help.adobe.com/en_US/ColdFusion/10.0/Developing/WSc3ff6d0ea77859461172e0811cbec0999c-7ff5.html#WS1E722CDD-3AA0-4e17-86DB-EF6D12FC6750
 	 */
 	 
 	/**
 	 * The bootsrap 2 table row option to use.
 	 * Default: Empty string.
	property string option;

	/**
	 * Set default values.
	 */
	public function init() {
		option = "";
		super.init();
	}

	/**
	 * Set the option to use. The options must be a valid option.  Return True if successfull, false otherwise.
	 *
	 * @param string o A valid bootstrap 2 table row option.
	 * @return boolean True if successful, false otherwise.
	 */
	public boolean function setOption(string o) {
		options = ArrayNew(1);
		options[1] = "success";
		options[2] = "error";
		options[3] = "warning";
		options[4] = "info";

		if (ArrayContains(options, o)) {
			option = o;
			return true;
		}
		return false;
	}

	/**
	 * Sets the table row options to success
	 */
	public void function showSuccess() {
		option = "success";
	}

	/**
	 * Sets the table row options to error
	 */
	public void function showError() {
		option = "error";
	}

	/**
	 * Sets the table row options to warning
	 */
	public void function showWarning() {
		option = "warning";
	}

	/**
	 * Sets the table row options to info
	 */
	public void function showInfo() {
		option = "info";
	}

	/**
	 * Builds the tr tag and returns it.
	 *
	 * @return string the tr tag.
	 */
	public string function render() {
		attrs = Duplicate(attributes);
		if (Len(option)) { 
			class = option;
			if (isAttribute("class")) {
				class = class & " " & getAttribute("class");
			}
			attrs["class"] = class;
		}
		return "<tr " & stringifyAttributes(attrs) & "/>";
	}
}