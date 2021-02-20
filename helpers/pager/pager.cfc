/**
 * Pager that can be used to paginate any data.   It implements the pager interface so that
 * it can work with a datasource that uses a pager.
 *
 * This component provides the basic functions any pager will need to navigate paged data.  It
 * uses the Bootstrap 2 pager component for the front end. All options outlined in Bootstrap 2
 * documentation Pager documentation can be used.  If you need the Boostrap 2 Pagination then use that
 * component instead.
 *
 * http://getbootstrap.com/2.3.2/components.html#pagination
 *
 * Example: Boostrap 2 Pager that is Aligned and the Previous link is disabled.
 *	pager = new Pager();
 *  pager.setPage(1);
 *  pager.setNumberOfItems(100);
 * 	pager.setPageSize(75);
 *  pager.setPageSizeInterval(25);
 *  pager.frontEnd().setDisablePrevious(true);
 *  pager.frontEnd().setAlign(true);
 *  output = pager.getPageSizeControl(4) // Will return the a page size select with options for 15, 50, 75, 100.
 *  output = pager.getPageSummary() // Will return the summary - Display 1-75 of 100 items
 *  output = pager.getPagerControl(); // Will return a pager control that does not loop, is aligned, and has the previous link disabled
 *
 * See cs-customcf.ecu-cf-framework.helpers.html.bootstrap2.pager for all configuration options.
 * If you are not happy with Bootstrap Pager you can extend this component to add features as necessary.
 * See the Pagination component for an example.
 */
component output="false" implements="pager_interface" accessors="true" {

	/**
	 * ColdFusion generates the accessor methods (getter and setter) for each property in this CFC that can be invoked.
 	 * See: http://help.adobe.com/en_US/ColdFusion/10.0/Developing/WSc3ff6d0ea77859461172e0811cbec0999c-7ff5.html#WS1E722CDD-3AA0-4e17-86DB-EF6D12FC6750
 	 */

	/**
	 * The current page the pager is on.
	 *
	 * Default: 1
	 */
	property int page;

	/**
	 * Weather to loop the page when the first or last page is reached.  If false then then
	 * previous or next control is disabled when on the first and last page respectively.
	 * If true then navigation goes from the first page to last page and vice versa.
	 *
	 * Default: false
	 */
	property boolean loop;

	/**
	 * The number of items that are being paged.
	 *
	 * Default: 0
	 */
	property int numberOfItems;

	/**
	 * The number of items to show on each page.
	 *
	 * Default: pageSizeInterval
	 */
	property int pageSize;

	/**
	 * The interval to use for the page size options.  If left to default then the
	 * page size options would be 25, 50, 75, etc.
	 *
	 * Default: 25
	 */
	property int pageSizeInterval;

	/**
	 * The front end for the pager.   Defaults to use the Bootstrap 2 Pager classes.
	 * If you want to use Pagination, then use the Pagination component.
	 *
	 * Default:  cs-customcf.ecu-cf-framework.helpers.html.bootstrap2.pager
	 */
	property struct frontEnd;

	/**
	 * Template for showing the page summary.  Placeholders with will be replaced with
	 * page information.  Available place holders are {start}, {end}, {numberOfItems},
	 * and {numberOfPages}
	 *
	 * Default: Displaying {start} - {end} of {numberOfItems}
	 */
	property string summaryTemplate;

	/**
	 * Sets default values and init the component.
	 */
	public function init() {
		loop = false;
		pageSizeInterval = 25;
		if (StructKeyExists(URL, "page") && isNumeric(URL.page)) {
			setPage(URL.page);
		} else {
			page = 1;
		}
		if (StructKeyExists(URL, "page_size") && isNumeric(URL.page_size)) {
			setPageSize(URL.page_size);
		} else {
			pageSize = pageSizeInterval;
		}
		numberOfPages = 1;
		numberOfItems = 0;

		summaryTemplate = "Displaying {start} - {end} of {numberOfItems}";
		frontEnd = new "cs-customcf.ecu-cf-framework.helpers.html.bootstrap2.pager"();
	}

	/**
	 * Sets Page Size Interval
	 */
	public void function setPageSizeInterval(size) {

		pageSizeInterval = size;
	}

	/**
	 * Sets number of items
	 */
	public void function setNumberOfItems(number) {
		if (!isNumeric(number)) {
			number = 0;
		}

		if (number < 1) {
			number = 0;
		}

		numberOfItems = number;
	}

	/**
	 * Sets Page Size
	 */
	public void function setPageSize(size) {

		pageSize = size;
	}

	public function getPageSize() {
		if (StructKeyExists(URL, "page_size") && isNumeric(URL.page_size)) {
			setPageSize(URL.page_size);
		}
		return pageSize;
	}

	/**
	 * Returns the frontEnd component so that it can be configured directly.
	 */
	public function frontEnd() {
		return frontEnd;
	}

	/**
	 * Creates a HTML Select based on the page size interval and the number
	 * of options specified.   So if the page size interval is 25, and the
	 * options is 4, then the select options will be 25, 50,75, 100.
	 *
	 * @param int options The number of options to have in the select
	 * @return string A html select with the number of options specified.
	 */
	public string function getPageSizeControl(options = 4) {
		if(numberOfItems <= pageSize) {
			//frontEnd.setActivePage(1);
			return "";
		}

		if (!isNumeric(options)) {
			size = 4;
		}
		output = "<form method='get' class='pageSize'><select id='items_per_page' style='width:65px;' name='page_size' onchange='this.form.submit()'>";
		for (i=1;i<=options;i++) {
			option = pageSizeInterval * i;
			output = output & "<option value='" & option & "' ";
			if (option == pageSize) {
				output = output & "selected";
			}
			output = output & ">" & option & "</option>";
		}
		output = output & "</select>";
		StructDelete(URL, "page");
		StructDelete(URL, "page_size");
		StructDelete(URL, "resetIntranet");
		StructDelete(URL, "action");
		for(u in URL) {
			output = output & "<input type='hidden' name='" & u & "' value='" & URL[u] & "'>";
		}
		output = output & "<input type='hidden' name='page' value='1'></form>";
		return output;
	}

	/**
	 * Sets the current page.   If the page is less than 1, then the page
	 * is set to 1.
	 *
	 * @param p int The current page.
	 */
	public void function setPage(p) {
		if (!isNumeric(p)) {
			p = 1;
		}

		if (p < 1) {
			p = 1;
		}

		page = p;
	}

	/**
	 * Creates the page summary based on the template and page information.
	 * Placeholders with will be replaced with page information.  Available place
	 * holders are {start}, {end}, {numberOfItems}, and {numberOfPages}
	 *
	 * @return string The page summary.
	 */
	public string function getPageSummary() {
		
		if ( numberOfItems <= 0 ) {
			return "";
		}

		numberOfPages = ceiling(numberOfItems/pageSize);
		if (page >= numberOfPages) {
			page = numberOfPages;
		}

		start = ((page-1) * pageSize) + 1;
		end = pageSize * page;
		if (end > numberOfItems) {
			end = numberOfItems;
		}

		output = Replace(summaryTemplate, "{start}", start, "All");
		output = Replace(output, "{end}", end, "All");
		output = Replace(output, "{numberOfItems}", numberOfItems, "All");
		output = Replace(output, "{numberOfPages}", numberOfPages, "All");

		return output;
	}

	/**
	 * Returns the pager based on the page information and settings.
	 *
	 * @return string The pager control.
	 */
	public string function getPagerControl() {
		StructDelete(URL, "action");
		if(numberOfItems <= pageSize) {
			//frontEnd.setActivePage(1);
			return "";
		}

		if (StructKeyExists(URL, "page")) {
			page = URL.page;
		} else {
			page = 1;
		}
		//frontEnd.setActivePage(page);
		numberOfPages = ceiling(numberOfItems/pageSize);
		nextPage = numberOfPages;
		previousPage = 1;

		if (loop) {
			if(page == 1) {
				previousPage = numberOfPages;
			} else {
				previousPage = page - 1;
			}

			if (page >= numberOfPages) {
				nextPage = 1;
			} else {
				nextPage = page + 1;
			}
		} else {
			if(page == 1) {
				frontEnd.setDisablePrevious(false);
			}

			if (page >= numberOfPages) {
				frontEnd.setDisableNext(true);
			}
		}
		frontEnd.setNextPage(nextPage);
		frontEnd.setPreviousPage(previousPage);
		frontEnd.setPageSize(pageSize);
		return frontEnd.render();
	}
}