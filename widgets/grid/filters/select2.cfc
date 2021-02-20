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


component output="false" extends="select" accessors="true" {

	property string fieldLabel;

	public function init(config = {}) {

		if(structKeyExists(config,"fieldLabel")) {
			fieldLabel = config.fieldLabel;
		}
		if(structKeyExists(config,"subselect")) {
			subselect = config.subselect;
		}

		super.init(config);
	}

	public string function renderFilter() {

		// Set up select attributes
		input.addAttribute("name", inputName);
		input.addAttribute("multiple", "multiple");
		input.addAttribute("id", "filter_" & inputName);
		class = input.getAttribute("class");
		input.addAttribute("class", class & " extFilter span12");

		// Set the selected value
		input.setSelected(this.getFilterValue());

		// Add Blank option
		option = new "cs-customcf.ecu-cf-framework.helpers.html.tags.form.select.option"();

		// Add the options for the filter select
		for(row in source) {
			option = new "cs-customcf.ecu-cf-framework.helpers.html.tags.form.select.option"();
			option.setText(row[label]);
			option.addAttribute("value", row[value]);
			input.addOption(option);
		}

		css = "<link href='/cs-customcf/ecu-cf-framework/libraries/select2/select2.css' rel='stylesheet' type='text/css'>";

		if (structKeyExists(REQUEST,"customcfupfront")) {
			ajaxPathToController = REQUEST.customcfupfront['MODULEFILENAME'];
		} else {
			ajaxPathToController = CGI.SCRIPT_NAME;
		}

		js = "
			<script type='text/javascript' src='/cs-customcf/ecu-cf-framework/libraries/select2/select2.min.js'></script>
			<script type='text/javascript'>
				$(document).ready(function() {
					$('##filter_" & inputName & "').select2({
						'width':'275px',
					});
				});
				function submitGrid(input){
					//alert(input.val());
					$.ajax({
						// The link we are accessing.
						url: '" & ajaxPathToController & "?action=updateGrid',

						// The type of request.
						type: 'post',

						// The type of data that is getting returned.
						dataType: 'html',

						data: $(this).serialize(),

						error: function() {
							$( '##ecu-grid' ).html( '<p>An error occured.  Please reload the page and try again.  If this presists please <a href=\'http://www.ecu.edu/cs-itcs/ithelpdesk/questions.cfm\'>open ticket with support</a>.</p>' );
						},

						success: function( strData ){
							// Load the content in to the page.
							$('##ecu-grid').html(strData);
						}
					});
				}
			</script>
		";

		output = css & js & fieldLabel & ": " & formTag.render() & input.render() & " <input style='margin-left:10px;' type='button' value='Search' onClick='this.form.submit()'/> <input name='clearFilters' type='submit' value='Reset'>" & formTag.renderClose();

		return output;
	}
}