interface {

	/**
	 * Sets/Gets a default order.
	 */
	public void function setDefaultOrder(o);
	public string function getDefaultOrder();

	/**
	 * Sets/Gets the order.
	 */
	public void function setOrder(o);
	public string function getOrder();

	/**
	 * Returns the data in a structure that can be iterated through in key-value pairs.
	 */
	public function getData();
	
	/**
	 * Returns an html control based on the page size interval and the number
	 * of options specified.   So if the page size interval is 25, and the 
	 * options is 4, then the options will be 25, 50,75, 100.
	 *
	 * @param int options The number of options to have in the select
	 */
	public function getPageSizeControl(options);

	/**
	 * Creates the page summary based on the template and page information.
	 */
	public function getPageSummary();
	
	/**
	 * Returns the pager based on the page information and settings.
	 */
	 public function getPagerControl();

}