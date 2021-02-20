/**
 * A filter that displays a clear icon and clears all filters in a cache region
 *
 * Example:
 * clearFilter = new "cs-customcf.ecu-cf-framework.widgets.grid.filters.clear"();
 * actionField.setFilter(clearFilter);
 *
 * And then you have to have an action (clearGridFilters) on the controller that will execute when clicked.
 *
 * switch(action) {
 *  ...
 * 	case "clearGridFilters":
 *		clearFilter = new "cs-customcf.ecu-cf-framework.widgets.grid.filters.clear"();
 *		clearFilter.clearAllFilterValues(); // Will clear any cached filters for this session
 *		break;
 * }
 */
 component output="false" extends="filter_abstract" accessors="true" {

 	property struct link;

 	public function init(config = {}) {
 		clearIcon = new "cs-customcf.ecu-cf-framework.helpers.html.tags.img"();
		clearIcon.addAttribute("src", "//" & Application.ECUAssets & "/images/x3.gif");
		link = new "cs-customcf.ecu-cf-framework.helpers.html.tags.a"();
		link.addAttribute("href", "##");
		link.addAttribute("id", "ecu-clear-filter");
		link.addAttribute("title", "Clear Filters");
		link.addAttribute("onClick", "clearGridFilters()");
		link.setElement(clearIcon);
		super.setInputName("clear_filter");
		super.init(config);

		// Clear the filters if necessary
		if(StructKeyExists(URL, "clearFilters")) {
			clearAllFilterValues();
		}
 	}

 	public string function renderFilter() {
 		return link.render();
 	}

	public string function renderJs() {

		return "
		<script>
		function clearGridFilters() {

			// AJAX to clear the filters
			$.ajax({
			  type: 'POST',
			  url: '?clearFilters=1',
			})
			  .done(function() {
			    // similar behavior as an HTTP redirect
				window.location.replace('//' +location.host + location.pathname);
			  });
		}
		</script>
		";
	}

 	public function clearAllFilterValues() {
 		if (CacheRegionExists(cacheRegion)) {
			cacheRemoveAll(cacheRegion);
 		}
 	}
 }