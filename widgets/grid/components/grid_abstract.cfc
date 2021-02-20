/**
 * Displays the data from the data source with paging, sorting, and filtering.
 * This assumes that the data is a set of records with key value pairs like a result from
 * a DB query.
 */
component output="false" accessors="true"{

	/**
	 * ColdFusion generates the accessor methods (getter and setter) for each property in this CFC that can be invoked.
 	 * See: http://help.adobe.com/en_US/ColdFusion/10.0/Developing/WSc3ff6d0ea77859461172e0811cbec0999c-7ff5.html#WS1E722CDD-3AA0-4e17-86DB-EF6D12FC6750
 	 */

	/**
	 * The data source that will provide the data.  Must implement
	 * the data_source_interface.
	 */
	property struct dataSource;

	/**
	 * A struct of fields to display in the grid. Must implement the field inteface.
	 * Default: Empty struct
	 */
	property struct fields;

	/**
	 * The order to iterate through the fields in.
	 */
	property array fieldsOrder;

	/**
	 * The message to show when there are no data that matches the filter in the grid.
	 */
	property string noResultsMessage;

	property string ajaxPathToController;

	property boolean ajaxUpdate;

	/**
	 * A struct of fields to display at the top of the grid. Must implement the field interface.
	 */
	property array externalFilters;

	/**
	 * A string, path to a partial file. ex. An export button
	 */
	property array partials;

	/**
	 * The template for the grid.  Place holders are replaced with the specific
	 * part of the grid.  They are: {pager}, {summary}, {items}, {page_select}
	 * Default:
	 *	<div class='container'>
	 * 		<div class='row-fluid'>
	 *			<div class='span6'>
	 *			{external_filters}
	 *			</div>
	 *			<div class='span6 text-right'>
	 *			{parital}
	 *			</div>
	 *		</div>
	 *		<div class='row-fluid'>
	 *			<div class='span6'>
	 *			{summary}
	 *			{page_select}
	 *			</div>
	 *			<div class='span6 text-right'>
	 *			{pager}
	 *			</div>
	 *		</div>
	 *		<div class='row-fluid'>
	 *			<div class='span12'>
	 *	 			{items}
	 *			</div>
	 *		</div>
	 *		<div class='row-fluid'>
	 *			<div class='span12 text-center'>
	 *			{pager}
	 *			</div>
	 *		</div>
	 *	</div>
	 */
	property string template;

	/**
	 * Sets defaults.
	 */
	public function init() {
		ajaxUpdate = true;
		if (structKeyExists(REQUEST,"customcfupfront")) {
			ajaxPathToController = REQUEST.customcfupfront['MODULEFILENAME'];
		} else {
			ajaxPathToController = CGI.SCRIPT_NAME;
		}

		noResultsMessage = "No records were found that match your criteria.";
		fields = StructNew();
		fieldsOrder = ArrayNew(1);

		externalFilters = ArrayNew(1);
		partials = ArrayNew(1);

		template = "
			<div class='row-fluid'>
	 			<div class='span6'>
	 			{external_filters}
	 			</div>
	 			<div class='span6 text-right'>
	 			{partials}
	 			</div>
	 		</div>
			<div class='row-fluid'>
				<div class='span6'>
				{summary}
				{page_select}
				</div>
				<div class='span6 text-right'>
				{pager}
				</div>
			</div>
			<div class='row-fluid'>
				<div class='span12'>
				{items}
				</div>
			</div>
			<div class='row-fluid'>
				<div class='span12 text-center'>
				{pager}
				</div>
			</div>";
	}

	private function checkFilterConditions() {

		switch(GetMetaData(datasource).FULLNAME) {

			default:
			case "cs-customcf.ecu-cf-framework.helpers.datasource.db":
				// Get filter condtions and add it to a db datasource
				// Build the filter WHERE clause conditions based on the options selected.
				whereConditions = ArrayNew(1);
				// Check for filters
				for(field in fields) {
					// Add conditions for Types
					if(fields[field].hasFilter() && fields[field].isFilterable()) {
						filterValue = fields[field].getFilter().getFilterValue();
 
						if(Len(filterValue)) {
							if(Len(fields[field].getFilter().getField())){
								dbField = fields[field].getFilter().getField();
							} else {
								dbField = fields[field].getName();
							}

							//If range filter, do additional logic
							if(GetMetaData(fields[field].getFilter()).FULLNAME == "cs-customcf.ecu-cf-framework.widgets.grid.filters.range"){
								//range filter must provide an array of structs (id, value) with value set to the displayed text, and the id set to ranges. The first and last will be single integers (ex. 25) and will be inclusive, all middle value will be two integers separated by only a comma (25,50).
								filterSource = fields[field].getFilter().getSource();

								if (ArrayLen(filterSource)){
									filterValues = filterValue.split(",");

									if (ArrayLen(filterValues) == 2){
										dbFieldMin = dbField & "Min";
										dbFieldMax = dbField & "Max";

										dataSource.query().addParam(name = dbFieldMin, value = filterValues[1], cfsqltype ="CF_SQL_VARCHAR");
										dataSource.query().addParam(name = dbFieldMax, value = filterValues[2], cfsqltype ="CF_SQL_VARCHAR");

										ArrayAppend(whereConditions, "#dbField# BETWEEN :#dbFieldMin# AND :#dbFieldMax#");
									} else {
										if (filterValues[1] == filterSource[1].max){
											//If it is the first item use < (less than)
											dataSource.query().addParam(name = dbField, value = filterValue, cfsqltype ="CF_SQL_VARCHAR");
											ArrayAppend(whereConditions, "#dbField# <= :#dbField#");
										} else if (filterValues[1] == filterSource[ArrayLen(filterSource)].min){
											//If it is the last item use > (greater than)
											dataSource.query().addParam(name = dbField, value = filterValue, cfsqltype ="CF_SQL_VARCHAR");
											ArrayAppend(whereConditions, "#dbField# >= :#dbField#");
										}
									}
								}
							} else {
								if(Len(dbField)) {
									dataSource.query().addParam(name = dbField, value = '%' & filterValue & '%', cfsqltype ="CF_SQL_VARCHAR");
									ArrayAppend(whereConditions, "#dbField# LIKE :#dbField#");
								}
							}
						}
					}
				}


				for (filter in externalFilters){
					if (Len(filter.getSubselect())){
						//Multiselect external filter
						filterValue = filter.getFilterValue();
						filterValues = ListToArray(filterValue);

						subselects = ArrayNew(1);
						for (value in filterValues){
							ArrayAppend(subselects, "(" & filter.getParentField() & " IN (" & filter.getSubselect() & " " & filter.getChildrenField() & " = " & value & "))");
						}

						if (ArrayLen(subselects)){
							subselects = "(" & ArrayToList(subselects, " " & filter.getSubSelectType() & " ") & ")";
							ArrayAppend(whereConditions, subselects);
						}
					} else {
						//Not a multiselect external filter
					}
				}

				if (ArrayLen(whereConditions)) {
					currentWhere = dataSource.getWhere();
					whereConditions = ArrayToList(whereConditions, " AND ");
					if(Len(currentWhere)) {
						whereConditions = whereConditions & " AND " & currentWhere;
					}
					dataSource.setWhere(whereConditions);
				}
				break;

		}

	}


	/**
	 * Adds a field component to the grid.
	 *
	 * @param name Should be a unique string.   If the name already
	 * exists then the field will be overwritten.
	 */
	public function addField(string name, field) {
		ArrayAppend(fieldsOrder, name);
		StructInsert(fields, name, field, true);
	}

	public function createExternalFilter(filter) {
		filter = createFilter(filter);
		ArrayAppend(externalFilters, filter);
	}

	public function addPartial(path) {
		ArrayAppend(partials, path);
	}

	public function createField(any config) {
		if (isSimpleValue(config)) {
			// Build the default field if only a field name (string) is given.
			// Default is a text field with a text filter.
			config = {
				"field" = {
					"type" = "", // default controlled in switch
					"name" = config,
					"sortable" = true,
					"filterable" = true
				},
				"filter" = {
					"type" = "", // default controlled in switch
					"name" = config
				}
			};

		} else {
			// Default field settings for createField
			if(!structKeyExists(config.field,"type")) {
				config.field.type = ""; // default controlled in switch
			}
			if(!structKeyExists(config.field,"filterable")) {
				config.field.filterable = true; // default controlled in switch
			}
			if(!structKeyExists(config.field,"sortable")) {
				config.field.sortable = true; // default controlled in switch
			}

			// configure the format
			if(structKeyExists(config.field,"format")) {
				if (structKeyExists(config.field.format,"formatter")) {
					config.field.format = format.formatter; // Custom formatter.  Has to implement the formatter interface
				} else {
					config.field.format = new "cs-customcf.ecu-cf-framework.helpers.formatter"(config.field.format);
				}
			}
		}

		// Build the field
		switch(config.field.type) {

			default:
			case "text":
				field = new "cs-customcf.ecu-cf-framework.widgets.grid.fields.text"(config.field);
				break;

			case "image":
				field = new "cs-customcf.ecu-cf-framework.widgets.grid.fields.image"(config.field);
				break;

			case "function":
				field = new "cs-customcf.ecu-cf-framework.widgets.grid.fields.function"(config.field);
				break;

			case "query_field_link":
				field = new "cs-customcf.ecu-cf-framework.widgets.grid.fields.query_field_link"(config.field);
				break;
		}

		// Build the filter
		if (field.isFilterable()) {

			// Default field settings for createField
			if(!structKeyExists(config,"filter")) {
				config.filter = {};
			}
			if (!structKeyExists(config.filter,"type")) {
				config.filter.type = ""; // default controlled in switch
			}
			// Set the filter input name to the field name if not provided.
			if(!structKeyExists(config.filter,"name")) {
				config.filter.inputName = field.getName();
			} else {
				config.filter.inputName = config.filter.name;
			}

			filter = createFilter(config);
			field.setFilter(filter);
		}

		this.addField(field.getName(), field);
	}

	private function createFilter(config){
		switch(config.filter.type) {
			default:
			case "text":
				filter = new "cs-customcf.ecu-cf-framework.widgets.grid.filters.text"(config.filter);
				break;

			case "select":
				filter = new "cs-customcf.ecu-cf-framework.widgets.grid.filters.select"(config.filter);
				break;

			case "select2":
				filter = new "cs-customcf.ecu-cf-framework.widgets.grid.filters.select2"(config.filter);
				break;

			case "clear":
				filter = new "cs-customcf.ecu-cf-framework.widgets.grid.filters.clear"(config.filter);
				break;

			case "range":
				filter = new "cs-customcf.ecu-cf-framework.widgets.grid.filters.range"(config.filter);
				break;
		}
		return filter;
	}

	/**
	 * Determins if a filed has aleady been added.
	 */
	public boolean function isField(string field) {
		return StructKeyExists(fields, field);
	}

	/**
	 * Replaces the placeholders in the template and returns the grid.
	 */
	public string function render () {
		checkFilterConditions();
		js = "";

		if(ajaxUpdate) {

			js = "

			<script type='text/javascript'>

				$(function(){

					// Prevent form submittion on enter

				$('.gridFilter').removeAttr('onChange'); // Remove no ajax default
					$('.gridFilter').on('change', function() {
							
						$.ajax({
								// The link we are accessing.
								url: '" & ajaxPathToController & "?action=updateGrid',

								// The type of request.
								type: 'post',

								// The type of data that is getting returned.
								dataType: 'html',

								data: data = { 
									[$(this).attr('name')]: $(this).val(),
									sortBy : $(this).data('sortby'),
									orderBy : $(this).data('orderby'),
									page : $(this).data('page'),
									page_size :$(this).data('page_size')
								},

								error: function() {
									$( '##ecu-grid' ).html( '<p>An error occured.  Please reload the page and try again.  If this presists please <a href=\'http://www.ecu.edu/cs-itcs/ithelpdesk/questions.cfm\'>open ticket with support</a>.</p>' );

								},

								success: function( strData ){
			
									// Load the content in to the page.
									$( '##ecu-grid' ).html( strData );

								}
							}
						);
					});

					// Sort Links
					$('.ecu-grid-sort-link').on('click', function() {

						$.ajax(
							{
								// The link we are accessing.
								url: '" & ajaxPathToController & "?action=updateGrid',

								// The type of request.
								type: 'get',

								// The type of data that is getting returned.
								dataType: 'html',

								// data to send to server
								data: 'sortBy=' + $(this).data('sort-by') + '&orderBy=' + $(this).data('order-by') + '&page=' + $(this).data('page') + '&page_size=' + $(this).data('page-size'),

								error: function() {
									$( '##ecu-grid' ).html( '<p>An error occured.  Please reload the page and try again.  If this presists please <a href=\'http://www.ecu.edu/cs-itcs/ithelpdesk/questions.cfm\'>open ticket with support</a>.</p>' );

								},

								success: function( strData ){

									// Load the content in to the page.
									$( '##ecu-grid' ).html( strData );

								}
							}
						);

						// Prevent default click.
						return( false );
					});

					// Grid Filter
					$('.gridFilterInputForm').submit(function(e) {
					    e.preventDefault();
					});
					$('.gridFilterInput').on('keyup', function(event) {

						if(event.keyCode == 13) {

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
										$( '##ecu-grid' ).html( strData );

									}
								}
							);
						}
					});

					// Page Size
					$('##items_per_page').removeAttr('onchange');
					$('##items_per_page').change(function() {

						$.ajax(
							{
								// The link we are accessing.
								url: '" & ajaxPathToController & "?action=updateGrid',

								// The type of request.
								type: 'get',

								// The type of data that is getting returned.
								dataType: 'html',

								data: $('.pageSize').serialize(),

								error: function() {

									$( '##ecu-grid' ).html( '<p>An error occured.  Please reload the page and try again.  If this presists please <a href=\'http://www.ecu.edu/cs-itcs/ithelpdesk/questions.cfm\'>open ticket with support</a>.</p>' );
								},

								success: function( strData ){

									// Load the content in to the page.
									$( '##ecu-grid' ).html( strData );

								}
							}
						);

						// Prevent default click.
						return( false );

					});

				   	// pager control
					$('.pager ul > li a').click(function() {

						queryParameters = 'page=' + $(this).data('page') + '&page_size=' + $(this).data('page-size')

						if($(this).data('sortby')) {
							queryParameters = 	queryParameters + '&sortBy=' + $(this).data('sortby');
						}

						if($(this).data('orderby')) {
							queryParameters = 	queryParameters + '&orderBy=' + $(this).data('orderby');
						}					
						$.ajax(
							{
								// The link we are accessing.
								url: '" & ajaxPathToController & "?action=updateGrid',

								// The type of request.
								type: 'get',

								// The type of data that is getting returned.
								dataType: 'html',

								// data to send to server
								data: queryParameters,

								error: function() {
									$( '##ecu-grid' ).html( '<p>An error occured.  Please reload the page and try again.  If this presists please <a href=\'http://www.ecu.edu/cs-itcs/ithelpdesk/questions.cfm\'>open ticket with support</a>.</p>' );
								},

								success: function( strData ){

									// Load the content in to the page.
									$( '##ecu-grid' ).html( strData );

								}
							}
						);

						// Prevent default click.
						return( false );
					});

				   	// pagination control
					$('.pagination ul > li a').click(function() {

						queryParameters = 'page=' + $(this).data('page') + '&page_size=' + $(this).data('page-size')

						if($(this).data('sortby')) {
							queryParameters = 	queryParameters + '&sortBy=' + $(this).data('sortby');
						}

						if($(this).data('orderby')) {
							queryParameters = 	queryParameters + '&orderBy=' + $(this).data('orderby');
						}	

						$.ajax(
							{
								// The link we are accessing.
								url: '" & ajaxPathToController & "?action=updateGrid',

								// The type of request.
								type: 'get',

								// The type of data that is getting returned.
								dataType: 'html',

								// data to send to server
								data: queryParameters,

								error: function() {
									$( '##ecu-grid' ).html( '<p>An error occured.  Please reload the page and try again.  If this presists please <a href=\'http://www.ecu.edu/cs-itcs/ithelpdesk/questions.cfm\'>open ticket with support</a>.</p>' );
								},

								success: function( strData ){
									// Load the content in to the page.
									$('##ecu-grid').html(strData);
								}
							}
						);

						// Prevent default click.
						return( false );
					});

				});
			</script>";
		}

		css = "<style>

		table form {
			padding:0;
			margin:0;
		}

		.pagination {
			margin-bottom:0;
			margin-top:20px;
		}

		.pageSize, .pageSize select {
			margin-bottom:0;
		}

		##labTable > thead > tr:nth-child(2) > td:nth-child(6) {
			padding-top: 15px;
		}

		.top-filters {
			padding-top:10px;
		}

		.ecu-grid-sort-link .icon-chevron-up, .ecu-grid-sort-link .icon-chevron-down {
			margin-left: 6px;
		}

		</style>";

		output = css & js & "<div id='ecu-grid'>" & ReplaceNoCase(template, "{items}", getItems(), "All");
		output = ReplaceNoCase(output, "{page_select}", dataSource.getPageSizeControl(), "All");
		output = ReplaceNoCase(output, "{summary}", dataSource.getPageSummary(), "All");
		output = ReplaceNoCase(output, "{pager}", dataSource.getPagerControl(), "All");

		if (!(ArrayIsEmpty(partials))){
			output = ReplaceNoCase(output, "{partials}", FileRead(ExpandPath("/cs-customcf/classroomtech/views/_export.cfm")));
		} else {
			output = ReplaceNoCase(output, "{partials}", "");
		}

		if (!(ArrayIsEmpty(externalFilters))){
			for (filter in externalFilters){
				output = ReplaceNoCase(output, "{external_filters}", filter.renderFilter());

			}
		} else {
			output = ReplaceNoCase(output, "{external_filters}", "");
		}
		output = output & "</div>";
		return output;
	}

	/**
	 * Returns a link that allows sorting for the field
	 */
	public function getSortLink(string title, string sortBy) {

		href = "?sortBy=" & encodeForURL(sortBy);
		icon = "";
		data = "data-sort-by='" & encodeForURL(sortBy) & "'";
		if (!StructKeyExists(URL, "orderBy")) {
			href = href & "&orderBy=ASC";
			data = data & " data-order-by='ASC'";
			if(StructKeyExists(URL, "sortBy") && (sortBy == URL.sortBy)) {
				icon = "<i class='icon-chevron-up'></i>";
			} else {
				sortList = listToArray(dataSource.getDefaultOrder(), ",", false);
				for (sort in sortList) {
					posDesc = Find("DESC", sort);
					posFieldName = Find(sortBy, sort);
					if ( posDesc > 0) {
						if ( posFieldName > 0 ) {
							icon = "<i class='icon-chevron-down'></i>";
						}
					} else {
						posAsc = Find("ASC", sort);
						if ( posAsc > 0) {
							if ( posFieldName > 0 ) {
								href = "?sortBy=" & encodeForURL(sortBy) & "&orderBy=DESC";
								data = "data-sort-by='" & encodeForURL(sortBy) & "' data-order-by='DESC'";
								icon = "<i class='icon-chevron-up'></i>";
							}
						} else {
							if ( posFieldName > 0 ) {
								href = "?sortBy=" & encodeForURL(sortBy) & "&orderBy=DESC";
								data = "data-sort-by='" & encodeForURL(sortBy) & "' data-order-by='DESC'";
								icon = "<i class='icon-chevron-up'></i>";
							}
						}
					}
				}
			}
		} else if(URL.orderBy == "ASC") {
			href = href & "&orderBy=DESC";
			data = data & " data-order-by='DESC'";
			if(StructKeyExists(URL, "sortBy") && (sortBy == URL.sortBy)) {
				icon = "<i class='icon-chevron-up'></i>";
			}
		} else {
			href = href & "&orderBy=ASC";
			data = data & " data-order-by='ASC'";
			if(StructKeyExists(URL, "sortBy") && (sortBy == URL.sortBy)) {
				icon = "<i class='icon-chevron-down'></i>";
			}
		}
		href = href & "&page_size=" & datasource.pager().getPageSize();
		data = data & " data-page-size='" & datasource.pager().getPageSize() & "'";
		href = href & "&page=1";
		data = data & " data-page='1'";
		return "<a class='ecu-grid-sort-link' href='" & href & "'" & data & ">" & title & icon & "</a>";
	}


	/**
	 * Builds the actual layout of the grid...list, table, etc.
	 */
	public string function getItems () {
		throw(type="Application",message="Method Must Be Overridden",detail="The getItems method must be overridden in a specific grid component.");
	}

}