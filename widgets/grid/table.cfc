/**
 * Displays the data from the data source in a table.
 * It extends the Bootstrap 2 table component. All options outlined in Bootstrap 2
 * Table documentation can be used.
 *
 * Example:
 *
 *  table = new "cs-customcf.ecu-cf-framework.widgets.grid.table"();
 *  dataSourc = new "cs-customcf.ecu-cf-framework.helpers.datasource.db"();
 *  ... CONFIGURE DATASOURCE ...
 *  table.setDataSource(dataSource);
 *	table.setStriped(true); // Bootstrap 2 table option
 *  table.addRowOption(1,"1","success");  // This says that if the first columns value is equal to 1 then add success to the row class
 *
 *  ... CONFIGURE FILTERS ...
 *
 *  // Lab Type Column
 *	typeField = new "cs-customcf.ecu-cf-framework.widgets.grid.fields.query_field"();
 *	typeField.setField("type");
 *	typeField.setSortable(true);
 *	typeField.setLabel("Type");
 *	typeField.setFilter(typeFilter);
 *	table.addField("type", typeField);
 *
 *	columns = ArrayNew(1);
 *	ArrayAppend(columns, typeField); // Make the lab type column the first column
 *	ArrayAppend(columns, "name"); // Make the field name from the query to be the second column
 *
 *	table.setColumns(columns);
 *	table.render(); // Writes the table to the browser.
 */
component extends="components.grid_abstract" output="false" accessors="true"{

	/**
	 * ColdFusion generates the accessor methods (getter and setter) for each property in this CFC that can be invoked.
 	 * See: http://help.adobe.com/en_US/ColdFusion/10.0/Developing/WSc3ff6d0ea77859461172e0811cbec0999c-7ff5.html#WS1E722CDD-3AA0-4e17-86DB-EF6D12FC6750
 	 */

 	/**
 	 * The table settings
 	 */
 	property table table;

	/**
	 *	The caption for the table. Uses the html tag component to build and render.
	 *	Default: cs-customcf.ecu-cf-framework.helpers.html.tags.table.caption
	 */
	property caption caption;

	/**
	 *	The colgroup for the table. Uses the html tag component to build and render.
	 *	Default: cs-customcf.ecu-cf-framework.helpers.html.tags.table.colgroup
	 */
	property colgroup colgroup;

	/**
	 * A struct containing the row options for the columns.  The row options are the
	 * bootstrap 2 row options.
	 */
	property struct rowOptions;

	/**
	 * An array that holds the columns to hide on mobile.
	 * columns start at 1 and go left to right.
	 * So in the example above the lab type column is column 1.
	 */
	property array hideColumnsOnMobile;

	property struct headerAttributes;
	/**
	 * Sets defaults.
	 */
	public function init() {
		rowOptions = StructNew();
		hideColumnsOnMobile = ArrayNew(1);
		headerAttributes = StructNew();
		table = new "cs-customcf.ecu-cf-framework.helpers.html.bootstrap2.table.table"();
		caption = new "cs-customcf.ecu-cf-framework.helpers.html.tags.table.caption"();
		colgroup = new "cs-customcf.ecu-cf-framework.helpers.html.tags.table.colgroup"();
		super.init();
	}

	public function hideColumnOnMobile(column) {
		ArrayAppend(hideColumnsOnMobile, column);
	}

	public void function addHeaderAttributes(field, attributes) {
		StructInsert(headerAttributes, field, attributes, true);
	}

	public function createField(config = {}) {
		if(isStruct(config) && structKeyExists(config,"table")) {
			if(structKeyExists(config.table,"showMobile") && !config.table.showMobile) {
				column = ArrayLen(fieldsOrder) + 1;
				hideColumnOnMobile(column);
			}

			if (structKeyExists(config.table,"headerAttributes") && structKeyExists(config.field,"name")) {
				addHeaderAttributes(config.field.name, config.table.headerAttributes);
			}
		}
		super.createField(config);
	}

	/**
	 * Adds a row option. The row options are defined in the bootstrap 2 documentation
	 * and the Bootstrap 2 TR component.
	 * http://getbootstrap.com/2.3.2/base-css.html#tables
	 *
	 * @param column  The column to match the value against.
	 * @param match   The value to match against
	 * @param class   The boostrat 2 class to apply if there is a match.
	 */
	public boolean function addRowOption(field_name, match, class) {
		var rowClass = StructNew();
		rowClass.class = class;
		rowClass.match = match;

		StructInsert(rowOptions, field_name, rowClass, true);

		return true;
	}

	/**
	 * Builds the actual table.
	 */
	public string function getItems () {
		output = "";
		length = ArrayLen(hideColumnsOnMobile);
		if (length > 0) {
			output = "
			<style>
			@media only screen and (max-width: 800px) {
				##labTable td:nth-child(#hideColumnsOnMobile[1]#),
				##labTable th:nth-child(#hideColumnsOnMobile[1]#) {display: none;}
			}

			@media only screen and (max-width: 640px) {
			";

			for(i=1;i<=length;i++) {
				output = output & "
				##labTable td:nth-child(#hideColumnsOnMobile[i]#),
				##labTable th:nth-child(#hideColumnsOnMobile[i]#)";
				if (i != length) {
					output = output & ",";
				}
			}

			output = output & "{display: none;}
			}
			</style>
			";
		}

		// Start Table
		output = output & table.render();

		// Table Caption
		output = output & caption.render();

		// Table Colgroup
		output = output & colgroup.render();

		// Table Header Rows
		output = output & "<thead><tr>";

		for(field in fieldsOrder) {

			title = EncodeForHTML(fields[field].getLabel());
			if (fields[field].isSortable()) {
				title = getSortLink(title, field);
			}
			th = new "cs-customcf.ecu-cf-framework.helpers.html.tags.table.th"();
			if(StructKeyExists(headerAttributes, field)) {
				th.setAttributes(headerAttributes[field]);
			}
			output = output & th.render() & title & th.renderClose();
		}
		output = output & "</tr><tr>";

		js = "";
		filterRow = "";
		hasFilters = false;
		for(field in fieldsOrder) {
			text = "";
			filter = fields[field].getFilter();
			if (StructKeyExists(filter, "renderFilter")) {
				hasFilters = true;
				if (StructKeyExists(filter, "renderJS")) {
					js = js & " " & filter.renderJs();
				}
				text = filter.renderFilter();
			}
			filterRow = filterRow & "<td>" & text & "</td>";
		}
		if(hasFilters) {
			output = output & filterRow;
		}
		output = output & "</tr></thead>";


		// Table Body Rows
		output = output & "<tbody>";

		// Set for order
		if(StructKeyExists(URL, "sortBy")) {
			sortBy = URL.sortBy;
			sortOrder = "desc";
			if(StructKeyExists(URL, "orderBy")) {
				sortOrder = URL.orderBy;
			}

			order = sortBy & " " & sortOrder;
			dataSource.setOrder(order);
		}

		data = dataSource.getData();
	
		for(row in data) {
			cells = "";
			tr = new "cs-customcf.ecu-cf-framework.helpers.html.bootstrap2.table.tr"();

			for(field in fieldsOrder) {
				if (StructKeyExists(rowOptions, field)) {
					if (fields[field].getValue(row) == rowOptions[field].match) {
						tr.setOption(rowOptions[field].class);
					}
				}
				cells = cells & "<td class='ecu-grid-" & field & "'>" & fields[field].render(row) & "</td>";
			}

			output = output & tr.render();
			output = output & cells;
			output = output & tr.renderClose();
		}

		output = output & "</tbody>";

		// End the table
		output = output & table.renderClose();

		// Display no results message
		if ( data.RecordCount == 0) {
			output = output & "<div class='ecu-lab-no-results'>" & noResultsMessage & "</div>";
		}

		output = output & js;

		return output;
	}

}