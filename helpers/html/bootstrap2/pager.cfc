/**
 * Allows you to build a pager with the bootstrap options.   All options are available from
 * the bootstrap 2 documentation.
 *
 * http://getbootstrap.com/2.3.2/components.html#pagination
 *
 * Example pager aligned (justified):
 *
 * pager = new "cs-customcf.ecu-cf-framework.helpers.html.bootstrap2.pager"();
 * pager.setAlign(true);
 * output = pager.render()
 *
 * Output is:
 * <ul class="pager">
 * 	  <li class="previous">
 * 	    <a href="#">Previous</a>
 * 	  </li>
 * 	  <li class="next">
 * 	    <a href="#">Next</a>
 * 	  </li>
 * 	</ul>
 */
 component extends="cs-customcf.ecu-cf-framework.helpers.html.tags.ul" output="false" accessors="true"{

	/**
	 * ColdFusion generates the accessor methods (getter and setter) for each property in this CFC that can be invoked.
 	 * See: http://help.adobe.com/en_US/ColdFusion/10.0/Developing/WSc3ff6d0ea77859461172e0811cbec0999c-7ff5.html#WS1E722CDD-3AA0-4e17-86DB-EF6D12FC6750
 	 */

	/**
	 * The label for the next control.
	 * Default: Next
	 */
	property string next;

	/**
	 * The label for the previous control.
	 * Default: Next
	 */
	property string previous;

	/**
	 * The number of items to show on each page.
	 *
	 * Default: 25
	 */
	property int pageSize;

	/**
	 * The page the previous control should go.
	 * Default: 1
	 */
	property int previousPage;

	/**
	 * The page the next control should go.
	 * Default: 1
	 */
	property int nextPage;

	/**
	 * Boolean on whether to justify the controls
	 * Default: false
	 */
	property boolean align;

	/**
	 * Boolean on whether to disable the previous control
	 * Default: false
	 */
	property boolean disablePrevious;

	/**
	 * Boolean on whether to disable the next control
	 * Default: false
	 */
	property boolean disableNext;

	/**
	 * Sets Defaults
	 */
	public function init() {
		next = "Next";
		previous = "Previous";
		previousPage = 1;
		nextPage = 1;
		pageSize = 25;
		align = false;
		disablePrevious = false;
		disableNext = false;
		super.init();
		liPrevious = new "cs-customcf.ecu-cf-framework.helpers.html.tags.list.li"();
		addLi(liPrevious);
		liNext = new "cs-customcf.ecu-cf-framework.helpers.html.tags.list.li"();
		addLi(liNext);
	}

	/**
	 * Builds the pager and returns it.
	 *
	 * @return string the pager.
	 */
	public string function render() {
		Application.includeOnce("\cs-customcf\ecu-cf-framework\helpers\utility\struct.cfm");
		StructDelete(URL, "page");
		StructDelete(URL, "page_size");
		StructDelete(URL, "resetIntranet");
		if(StructIsEmpty(URL)) {
			queryString = "";
		} else {
			queryString = structToList(URL, "&") & "&";
		}

		addAttribute("class", "pager");

		class = ArrayNew(1);
		lis[1].deleteAttribute("class");
		if (disablePrevious) {
			ArrayAppend(class, "disabled");
		}
		if (align) {
			ArrayAppend(class, "previous");
		}

		if (ArrayLen(class)) {
			lis[1].addAttribute("class", ArrayToList(class, " "));
		}
		dataString = "data-page='" & EncodeForURL(previousPage) & "' data-page-size='" & EncodeForURL(pageSize) & "'";
		lis[1].setText("<a " & dataString  & " href='?" & queryString & "page=" & EncodeForURL(previousPage) & "&page_size=" & EncodeForURL(pageSize) & "'>" & EncodeForHtml(previous) & "</a>");

		class = ArrayNew(1);
		lis[2].deleteAttribute("class");
		if (disableNext) {
			ArrayAppend(class, "disabled");
		}
		if (align) {
			ArrayAppend(class, "next");
		}

		if(ArrayLen(class)) {
			lis[2].addAttribute("class", ArrayToList(class, " "));
		}
		dataString = "data-page='" & EncodeForURL(nextPage) & "' data-page-size='" & EncodeForURL(pageSize) & "'";
		lis[2].setText("<a " & dataString  & " href='?" & queryString & "page=" & EncodeForURL(nextPage) & "&page_size=" & EncodeForURL(pageSize) & "'>" & EncodeForHtml(next) & "</a>");

		return super.render();
	}
}