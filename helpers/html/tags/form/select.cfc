/**
 * Renders a select tag to include the options.
 *
 * Example:
 *
 * select = new select();
 * select.addAttribute("class", "foo-class");
 *
 * option = new option();
 * option.text = "foo";
 * option.addAttribute("value", "foo");
 * option.addAttribute("class", "option-class");
 *
 * select.addOption(option);
 * output = select.render(); // returns <select class="foo-class"><option value="foo" class="option-class">foo</option></select>
 */
 component extends="cs-customcf.ecu-cf-framework.helpers.html.tags.tag_abstract" output="false" accessors="true"{

	/**
	 * ColdFusion generates the accessor methods (getter and setter) for each property in this CFC that can be invoked.
 	 * See: http://help.adobe.com/en_US/ColdFusion/10.0/Developing/WSc3ff6d0ea77859461172e0811cbec0999c-7ff5.html#WS1E722CDD-3AA0-4e17-86DB-EF6D12FC6750
 	 */

	/**
	 * Array of option elements for select
	 */
	property array options;

	/**
	 * option value to select
	 */
	property string selected;

	/**
	 * Set Defaults
	 */
	public function init() {
		selected = "";
		options = ArrayNew(1);
		super.init();
	}

	/**
	 * Emptys the option elements
	 */
	public function clearOptions() {
		return ArrayClear(options);
	}

	/**
	 * Adds and option element to the select
	 *
	 * @param option option element that implements the html tag interface.
	 */
	public void function addOption(struct option) {
		ArrayAppend(options, option);
	}

	/**
	 * Renders the element.
	 *
	 * @return string the element.
	 */
	public string function render() {
		if (ArrayIsEmpty(options)) {
			return "";
		}
		output =  "<select " & stringifyAttributes() & ">";
		for (option in options) {
			if (getAttribute("multiple") == 'multiple'){
				selectedArray = ListToArray(selected);
				if (ArrayContains(selectedArray, option.getAttribute("value"))){
					option.addAttribute("selected", "selected");
				}
			} else {
				if (selected == option.getAttribute("value")) {
					option.addAttribute("selected", "selected");
				}
			}
			output = output & option.render();
		}

		return output & "</select>";
	}
}