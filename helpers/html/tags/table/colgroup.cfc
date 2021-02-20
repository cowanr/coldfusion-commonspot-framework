/**
 * Renders a colgroup tag for a table.
 *
 * Example:
 *
 * colgroup = new colgroup();
 * colgroup.addAttribute("class", "foo-class");
 *
 * col = new col();
 * col.addAttribute("class", "col-class");
 * col.addAttribute("span", 2);
 *
 * colgroup.addCol(col);
 * output = colgroup.render(); // returns <colgroup class="foo-class"><col span="2" class="col-class"></colgroup>
 */
component extends="cs-customcf.ecu-cf-framework.helpers.html.tags.tag_abstract" output="false" accessors="true"{

	/**
	 * ColdFusion generates the accessor methods (getter and setter) for each property in this CFC that can be invoked. 
 	 * See: http://help.adobe.com/en_US/ColdFusion/10.0/Developing/WSc3ff6d0ea77859461172e0811cbec0999c-7ff5.html#WS1E722CDD-3AA0-4e17-86DB-EF6D12FC6750
 	 */
		
	/** 
	 * Array of col elements for colgroup
	 */
	property array cols;

	/**
	 * Set defaults
	 */	
	public function init() {
		cols = ArrayNew(1);
		super.init();
	}

	/**
	 * Adds and COL element to the COLGROUP
	 *
	 * @param col col element that implements the html tag interface.
	 */
	public void function addCol(struct col) {
		ArrayAppend(cols, col);
	}

	/**
	 * Renders the element.
	 *
	 * @return string the element.
	 */
	public string function render() {
		if (!hasAttributes()) {
			return "";
		}
		output =  "<colgroup " & stringifyAttributes() & ">";

		for (col in cols) {
			output = output & col.render();
		}

		return output & "</colgroup>";
	}
}