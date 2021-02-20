/**
 * Pager that can be used to paginate any data.   It extends the pager componeent and adds the
 * ability to jump to the first, last, or specific page.  It also implements the pager interface so that
 * it will work with any datasource.
 *
 * This component provides the basic functions any pager will need to navigate paged data.  It
 * uses the Bootstrap 2 pagination component for the front end. All options outlined in Bootstrap 2 
 * documentation Pagination documentation can be used.  If you need the Boostrap 2 Pager then use that
 * component instead.
 *
 * http://getbootstrap.com/2.3.2/components.html#pagination
 *
 * Example: Boostrap 2 Pagination that is large.
 *	pager = new Pagination();
 *  pager.setPage(1);
 *  pager.setNumberOfItems(100);
 * 	pager.setPageSize(75);
 *  pager.setPageSizeInterval(25);
 *  pager.frontEnd().setSize("large");
 *  output = pager.getPageSizeControl(4) // Will return the a page size select with options for 15, 50, 75, 100.
 *  output = pager.getPageSummary() // Will return the summary - Display 1-75 of 100 items
 *  output = pager.getPagerControl(); // Will return a pager control that does not loop and is large size.
 *
 * See cs-customcf.ecu-cf-framework.helpers.html.bootstrap2.pagination for all configuration options.
 */
component extends="pager" output="false" accessors="true"{

	/**
	 * ColdFusion generates the accessor methods (getter and setter) for each property in this CFC that can be invoked. 
 	 * See: http://help.adobe.com/en_US/ColdFusion/10.0/Developing/WSc3ff6d0ea77859461172e0811cbec0999c-7ff5.html#WS1E722CDD-3AA0-4e17-86DB-EF6D12FC6750
 	 */

	/**
	 * Sets default values and init the component.
	 */
	public function init() {
		super.init();
		frontEnd = new "cs-customcf.ecu-cf-framework.helpers.html.bootstrap2.pagination"();
	}

	/**
	 * Returns the pager based on the page information and settings.
	 *
	 * @return string The pager control.
	 */
	public string function getPagerControl() {
		StructDelete(URL, "action");
		if(numberOfItems <= pageSize) {
			return "";
		}

		frontEnd.setActivePage(page);

		if(page == 1) {
			frontEnd.setDisableFirst(true);
			frontEnd.setDisablePrevious(true);
		}

		numberOfPages = ceiling(numberOfItems/pageSize);
		frontEnd.setNumberOfPages(numberOfPages);

		if (page >= numberOfPages) {
			frontEnd.setDisableLast(true);
			frontEnd.setDisableNext(true);
			frontEnd.setActivePage(numberOfPages);
		}
		frontEnd.setPageSize(pageSize);
		
		return frontEnd.render();
	}
}