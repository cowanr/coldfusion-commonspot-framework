/**
 * A filter that displays a validated list in a select drop down.
 *
 * Example:
 *  // Peripheral filter
 *	peripheralFilter = new "cs-customcf.ecu-cf-framework.widgets.grid.filters.select"();
 *	peripheralFilter.setInputName("filter_peripheral");
 *	peripheralFilter.setValue("id");
 *	peripheralFilter.setLabel("name");
 *
 *  // Peripherals filter Source
 *  queryService = new Query();
 *  queryService.setDatasource("homepage_tools");
 *	queryService.setName("peripheralsQuery");
 *	queryService.setSQL("SELECT * FROM labs_peripherals ORDER BY name");
 *	peripheralsQuery = queryService.execute().getResult();
 *	peripheralFilter.setSource(peripheralsQuery);
 * 	seats = new "cs-customcf.ecu-framework.widgets.grid.fields.function"();
 * 	seats.setTitle("Seats Open");
 * 	seats.setFunction(seatsFunction);
 *
 *  // Add the filter to the field
 *  peripheraField = new "cs-customcf.ecu-cf-framework.widgets.grid.fields.function"();
 *  ...
 *  peripheraField.setFilter(peripheralFilter);
 *
 */
component output="false" extends="filter_abstract" accessors="true" {

	/**
	 * ColdFusion generates the accessor methods (getter and setter) for each property in this CFC that can be invoked.
 	 * See: http://help.adobe.com/en_US/ColdFusion/10.0/Developing/WSc3ff6d0ea77859461172e0811cbec0999c-7ff5.html#WS1E722CDD-3AA0-4e17-86DB-EF6D12FC6750
 	 */

 	/**
 	 * The source struct for the select options.  Struct should have rows of key/value pairs.
 	 * Default: Empty struct
 	 */
 	property any source;

  	/**
 	 * The key for the label from the source
 	 * Default: Empty String
 	 */

  	/**
 	 * The key for the value from the source
 	 * Default: Empty String
 	 */

	public function init(config = {}) {
		input = new "cs-customcf.ecu-cf-framework.helpers.html.tags.form.select"();
				input = super.setUrlDataAttributes(input);
		source = StructNew();

		if(structKeyExists(config,"source")) {
			source = config.source;
		}

		if(structKeyExists(config,"field")) {
			field = config.field;
		}
		super.init(config);
	}

	public string function renderFilter() {

		// Set up select attributes
		input.addAttribute("name", inputName);
		input.addAttribute("onChange", "this.form.submit()");
		input.addAttribute("id", "filter_" & inputName);
		class = input.getAttribute("class");
		input.addAttribute("class", class & " gridFilter span12");

		// Set the selected value
		input.setSelected(this.getFilterValue());

		// Add Blank option
		option = new "cs-customcf.ecu-cf-framework.helpers.html.tags.form.select.option"();
		option.addAttribute("value", "");
		input.addOption(option);

		// Add the options for the filter select
		var i = 0;
		for(range in source) {
			option = new "cs-customcf.ecu-cf-framework.helpers.html.tags.form.select.option"();
			if (!(range.min == 'null')){
				if (!(range.max == 'null')){
					option.setText(range.min & " - " & range.max);
					option.addAttribute("value", range.min & "," & range.max);
				} else {
					option.setText("&ge; " & (range.min + 1));
					option.addAttribute("value", range.min);
				}
			} else {
				option.setText("&le; " & (range.max - 1));
					option.addAttribute("value", range.max);
			}
			input.addOption(option);
			i++;
		}

		output = formTag.render() & input.render() & formTag.renderClose();
		return output;
	}
}