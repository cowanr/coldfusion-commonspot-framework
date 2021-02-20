/**
 * Data Source built around the CF Query.  Implements the data source inferface.
 *
 * Uses the a SQL Select statement to retrieve, paginate, and sort the data.
 *
 * Example Usage:
 *
 * dataSource = new "cs-customcf.ecu-cf-framework.helpers.datasource.db"();
 * dataSource.query().setDataSource("homepage_tools");
 * dataSource.query().setName("labsQuery");
 * dataSource.setSelect("labs_labs.id, labs_labs.room, labs_labs.type_id, labs_type.type, admin_buildings.name as building_name");
 * dataSource.setFrom("homepage_tools.labs_labs");
 * dataSource.addJoin("LEFT JOIN homepage_tools.admin_buildings on labs_labs.building_id = admin_buildings.id");
 * dataSource.addJoin("LEFT JOIN homepage_tools.labs_type on labs_labs.type_id = labs_type.id");
 * dataSource.setGroup("labs_labs.id");
 * dataSource.setDefaultOrder("admin_buildings.name, labs_labs.room");
 * data = dataSource.getData();
 */
component output="false" implements="data_source_interface" accessors="true" {

	/**
	 * ColdFusion generates the accessor methods (getter and setter) for each property in this CFC that can be invoked.
 	 * See: http://help.adobe.com/en_US/ColdFusion/10.0/Developing/WSc3ff6d0ea77859461172e0811cbec0999c-7ff5.html#WS1E722CDD-3AA0-4e17-86DB-EF6D12FC6750
 	 */

	/**
	 * The CF query.  Should not be set directly.
	 * Default: Init to a CF Query.
	 */
	property query query;

	/**
	 * The results of the query.
	 * Default: Empty Struct.
	 */
	property struct results;

	/**
	 * The SQL select expression.  Do not include the SELECT keyword.
	 * Example: table.field1 as t, table.field2, table.field.3
	 * Default: Empty String
	 */
	property string select;

	/**
	 * The SQL table references.  Do not include the FROM keyword.
	 * JOINS can be part of the string or added using the joins array.
	 * Example: table1
	 * Default: Empty String
	 */
	property string from;

	/**
	 * An array of joins.  It will be turn into a string and concatenated on the end
	 * of the FROM string
	 * Example: LEFT JOIN homepage_tools.admin_buildings on labs_labs.building_id = admin_buildings.id
	 * Default: Empty Array
	 */
	property array joins;

	/**
	 * The where condition.  Do no include the WHERE keyword.
	 * Example: field1 = value1 AND field2 = value2
	 * Default: Empty String
	 */
	property string where;

	/**
	 * The group by column.  Do no include the GROUP BY keyword.
	 * Example: field1
	 * Default: Empty String
	 */
	property string group;

	/**
	 * The default order. Do not include the ORDER keyword.
	 * Example: field1 ASC, field2, DESC
	 * Default: Empty String
	 */
	property string defaultOrder;

	/**
	 * The order to sort by. Do not include the ORDER keyword.
	 * Example: field1 ASC, field2, DESC
	 * Default: Empty String
	 */
	property string order;

	/**
	 * The pager for the data. Must implement the pager interface
	 * Default: cs-customcf.ecu-cf-framework.helpers.pagination
	 */
	property struct pager;

	/**
	 * Sets default values and init the component.
	 */
	public function init() {
		query = createObject("component", "query");
		pager = new "cs-customcf.ecu-cf-framework.helpers.pager.pagination"();
		results = StructNew();
		select = "*";
		from = "";
		joins = ArrayNew(1);
		defaultOrder = "";
		order = "";
		group = "";
		where = "";
	}

	/**
	 * Sets the default order
	 */
	public void function setDefaultOrder(o) {
		defaultOrder = o;
	}

	/**
	 * Sets the order
	 */
	public void function setOrder(o) {
		order = o;
	}

	/**
	 * Swiches the pager between the two bootstrap pagers in helpers.
	 *	pagination - A pager control with numbers.
	 *  pager - A pager with only next and previous controls.
	 *
	 * @param string type The type of pager to use.
	 */
	public function usePager(string type) {
		switch (type) {
			case "pagination":
				pager = new "cs-customcf.ecu-cf-framework.helpers.pager.pagination"();
				break;

			case "pager":
				pager = new "cs-customcf.ecu-cf-framework.helpers.pager.pager"();
				break;
		}
	}

	/**
	 * Add a new join to the joins array
	 *
	 * @param string The join to add
	 */
	 public function addJoin(string join) {
		ArrayAppend(joins, join);
	}

	/**
	 * Returns the query component so that it can be configured directly.
	 */
	public function query() {
		return query;
	}

	/**
	 * Returns the pager component so that it can be configured directly.
	 */
	public struct function pager() {
		return pager;
	}

	/**
	 * Returns the results from the query.
	 */
	public function getData() {

		if (!Len(from)) {
			throw(type="Application",message="Query From Table Not Set",detail="Must be a valid table in the data source.");
		}

		/**
		 * Get Page Data
		 */
		sql = "SELECT " & select & " FROM " & from;

		if(!ArrayIsEmpty(joins)) {
			sql = sql & " " & ArrayToList(joins, " ");
		}

		if (Len(where)) {
			sql = sql & " WHERE " & where;
		}

		if (Len(group)) {
			sql = sql & " GROUP BY " & group;
		}

		if (!Len(order) && Len(defaultOrder)) {
			sql = sql & " ORDER BY " & defaultOrder;
		}

		if (Len(order)) {
			sql = sql & " ORDER BY " & order;
		}

		query.setSQL(sql);
		
		pager.setNumberOfItems(query.execute().getPrefix().recordcount);

		if (pager.getNumberOfItems() > pager.getPageSize()) {
			offset = (pager.getPage()-1) * pager.getPageSize();
			sql = sql & " LIMIT " & offset & "," & pager.getPageSize();
		}

		query.setSQL(sql);

		results = query.execute().getResult();

		return results;
	}

	/**
	 * Creates a HTML Select based on the page size interval and the number
	 * of options specified.   So if the page size interval is 25, and the
	 * options is 4, then the select options will be 25, 50,75, 100.
	 *
	 * @param int options The number of options to have in the select
	 * @return string A html select with the number of options specified.
	 */
	public function getPageSizeControl(options = 4) {
		return pager.getPageSizeControl(options);
	}

	/**
	 * Creates the page summary based on the template and page information.
	 *
	 * @return string The page summary.
	 */
	public function getPageSummary() {
		return pager.getPageSummary();
	}

	/**
	 * Returns the pager based on the page information and settings.
	 *
	 * @return string The pager control.
	 */
	public function getPagerControl() {
		//writeDump(this);
		return pager.getPagerControl();
	}

}