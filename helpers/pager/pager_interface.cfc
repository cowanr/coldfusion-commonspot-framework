/**
 * Interface for pagers that will work with any data source object in the grid widget
 */
 interface {

	/**
	 * Sets/Gets the current page.
	 */
	public void function setPage(p);
	public int function getPage();

	/**
	 * Sets/Gets the number of items that are being paged.
	 */
	public void function setNumberOfItems(number);
	public int function getNumberOfItems();

	/**
	 * Sets/Gets the current number of items to show per page.
	 */
	public void function setPageSize(size);
	public function getPageSize();

	/**
	 * Sets/Gets the number of items to show current page.
	 */
	public void function setPageSizeInterval(size);
	public int function getPageSizeInterval();

	/**
	 * Returns a HTML control to select the page size based on the page size interval and the number
	 * of options that you wish displayed.
	 *
	 * If the page size interval is 25 and the number of options is 4, then the control should
	 * have options for 25, 50, 75, and 100 items per page.
	 *
	 * @param int options  The number of options to show.
	 * @return string  The control for selecting a page size.
	 */
	public string function getPageSizeControl(options);

	/**
	 * Returns the summary of the page based on the page size, number of items, etc.
	 *
	 * example:  Display 1-25 of 88 items
	 *
	 * @return string  The summary of the page.
	 */
	public string function getPageSummary();

	/**
	 * Returns a control to navigate the pages.
	 *
	 * First, last, next, previous, page number links are examples of what is exptected.
	 *
	 * @return string A control to navigate the pages.
	 */
	public string function getPagerControl();
}