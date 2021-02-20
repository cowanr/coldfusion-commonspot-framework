/**
 * Allows you to build a pager with the bootstrap pagination options.   All options are available from
 * the bootstrap 2 documentation.
 *
 * http://getbootstrap.com/2.3.2/components.html#pagination
 *
 * Example pager:
 *
 * pager = new "cs-customcf.ecu-cf-framework.helpers.html.bootstrap2.pagination"();
 * pager.setNumberOfPages(5);
 * pager.setActivePage(5);
 * pager.setDisableNext(true);
 * pager.setDisableLast(true);
 * pager.setSize("large");
 * output = pager.render()
 *
 * Output is:
 *	<div class="pagination pagination-large"> // Large size pager
 *	  <ul>
 *	    <li><a href="#">&laquo;</a></li> // first page
 * 		<li><a href="#">&lgt;</a></li> // previous page
 *	    <li><a href="#">1</a></li>
 *	    <li><a href="#">2</a></li>
 *	    <li><a href="#">3</a></li>
 *	    <li><a href="#">4</a></li>
 *	    <li class="active"><span>5</span></li> // current page
 *	    <li class="disabled"><span>&gt;</span></li> // next page
 * 		<li class="disabled"><span>&raquo;</span></li> // last page
 *	  </ul>
 *	</div>
 */
component extends="cs-customcf.ecu-cf-framework.helpers.html.tags.div" output="false" accessors="true"{

	/**
	 * ColdFusion generates the accessor methods (getter and setter) for each property in this CFC that can be invoked.
 	 * See: http://help.adobe.com/en_US/ColdFusion/10.0/Developing/WSc3ff6d0ea77859461172e0811cbec0999c-7ff5.html#WS1E722CDD-3AA0-4e17-86DB-EF6D12FC6750
 	 */

 	/**
 	 * An array of pages to disable.
 	 * Default: Empty array
 	 */
	property array disabledPages;

	/**
	 * Boolean for disabling the previous control
	 * If true then disable the control.
	 * Default: false
	 */
	property boolean disablePrevious;

	/**
	 * Boolean for disabling the next control
	 * If true then disable the control.
	 * Default: false
	 */
	property boolean disableNext;

	/**
	 * Boolean for disabling the last control
	 * If true then disable the control.
	 * Default: false
	 */
	property boolean disableLast;

	/**
	 * Boolean for disabling the first control
	 * If true then disable the control.
	 * Default: false
	 */
	property boolean disableFirst;

	/**
	 * Boolean to show the first and last controls.
	 * If true then show the controls, false do not show.
	 * Default: true
	 */
	property boolean showFirstLast;

	/**
	 * The size of the pager.
	 * Default: normal
	 */
	 property string size;

	/**
	 * Available bootstrap options for pager size.
	 */
	property struct sizes;

	/**
	 * The alignment of the pager.
	 * Default: left
	 */
	property string alignment;

	/**
	 * Available bootstrap options for pager alignment.
	 */
	property struct aligmnets;

	/**
	 * The current page
	 * Default: 1
	 */
	property int activePage;

	/**
	 * The number of pagers the pager has.
	 * Default: 1
	 */
	property int numberOfPages;

	/**
	 * The label for the previous control.
	 * Default: &lt;
	 */
	property string previous;

	/**
	 * The label for the Next control.
	 * Default: &gt;
	 */
	property string next;

	/**
	 * The label for the first control.
	 * Default: &laquo;
	 */
	property string first;

	/**
	 * The label for the last control.
	 * Default: &raquo;
	 */
	property string last;

	/**
	 * The number of items to show on each page.
	 *
	 * Default: 25
	 */
	property int pageSize;

	/**
	 * The number of buttons to show before and after the current page.
	 *
	 * Default: 2
	 */
	property int numOfPageButtons;

	/**
	 * Set defaults
	 */
	public function init() {

		showFirstLast = true;
		disabledPages = ArrayNew(1);
		disablePrevious = false;
		disableNext = false;
		disableFirst = false;
		disableLast = false;
		size = "normal";
		pageSize = 25;
		alignment = "left";
		activePage = 1;
		numberOfPages = 1;
		numOfPageButtons = 2;

		first = "&laquo;";
		previous = "&lt;";
		next = "&gt;";
		last = "&raquo;";

		alignments = StructNew();
		alignments.left = "";
		alignments.center = "pagination-centered";
		alignments.right = "pagination-right";

		sizes = StructNew();
		sizes.mini = "pagination-mini";
		sizes.normal = "";
		sizes.large = "pagination-large";
		sizes.small = "pagination-small";

		super.init();
	}

	/**
	 * Add pages to be disabled
	 *
	 * @paran int p The page number to add.
	 */
	public function addDisabledPages(int p) {
		ArrayAppend(disabledPages, p);
	}

	/**
	 * Removes all disabled pages.
	 *
	 * @return boolean True if successful, false otherwise.
	 * 
	 */
	public function clearDisabledPages() {
		return ArrayClear(disabledPages);
	}

	/**
	 * Builds the pager and returns it.
	 *
	 * @return string the pager.
	 */
	public string function render () {

		Application.includeOnce("\cs-customcf\ecu-cf-framework\helpers\utility\struct.cfm");
		StructDelete(URL, "page");
		StructDelete(URL, "page_size");
		StructDelete(URL, "resetIntranet");
		urlDataAttributes = "";
		if(StructIsEmpty(URL)) {
			queryString = "";
		} else {
			queryString = structToList(URL, "&") & "&";
			for(key in URL) {
				urlDataAttributes = urlDataAttributes & " data-" & key & "='" & URL[key] & "'";
			}
		}

		class = ArrayNew(1);
		ArrayAppend(class, "pagination");

		switch(size) {
			case "mini":
				ArrayAppend(class, sizes.mini);
				break;

			default:
			case "normal":
				break;

			case "large":
				ArrayAppend(class, sizes.large);
				break;

			case "small":
				ArrayAppend(class, sizes.small);
				break;
		}

		switch(alignment) {
			case "center":
				ArrayAppend(class, alignments.center);
				break;

			default:
			case "left":
				break;

			case "right":
				ArrayAppend(class, alignments.right);
				break;
		}
		addAttribute("class", ArrayToList(class, " "));

		ul = new "cs-customcf.ecu-cf-framework.helpers.html.tags.ul"();

		if (showFirstLast) {
			liFirst = new "cs-customcf.ecu-cf-framework.helpers.html.tags.list.li"();
			if (disableFirst) {
				liFirst.addAttribute("class", "disabled");
				 text = "<span>" & first & "</span>";
			} else {
				dataString = "data-page=1" & " data-page-size=" & EncodeForURL(pageSize) & urlDataAttributes;
				text = "<a " & dataString & " href='?" & queryString & "page=1'" & "&page_size=" & EncodeForURL(pageSize) & ">" & first & "</a>";
			}
			liFirst.setText(text);
			ul.addLi(liFirst);
		}

		liPrevious = new "cs-customcf.ecu-cf-framework.helpers.html.tags.list.li"();
		if (disablePrevious) {
			liPrevious.addAttribute("class", "disabled");
			previousPage = activePage;
			text = "<span>" & previous & "</span>";
		} else {
			previousPage = activePage -1;
			dataString = "data-page=" & EncodeForURL(previousPage) & " data-page-size=" & EncodeForURL(pageSize) & urlDataAttributes;
			text = "<a " & dataString & " href='?" & queryString & "page=" & EncodeForURL(previousPage) & "&page_size=" & EncodeForURL(pageSize) & "'>" & previous & "</a>";
		}
		liPrevious.setText(text);
		ul.addLi(liPrevious);

		for(i=1;i<=numberOfPages;i++) {
			if ((i > (activePage-numOfPageButtons-1)) && (i < (activePage+numOfPageButtons+1))){
				class = ArrayNew(1);
				if (i == activePage ) {
					ArrayAppend(class, "active");
					text = "<span>" & i & "</span>";
				} else {
					dataString = "data-page=" & EncodeForURL(i) & " data-page-size=" & EncodeForURL(pageSize) & urlDataAttributes;
					text = "<a " & dataString & " href='?" & queryString & "page=" & EncodeForURL(i) & "&page_size=" & EncodeForURL(pageSize) & "'>" & i & "</a>";
				}

				if (ArrayContains(disabledPages, i)) {
					ArrayAppend(class, "disabled");
				}
				liPage = new "cs-customcf.ecu-cf-framework.helpers.html.tags.list.li"();
				if (ArrayLen(class)) {
					liPage.addAttribute("class", ArrayToList(class, " "));
				}
				liPage.setText(text);
				ul.addLi(liPage);
			}
		}

		liNext = new "cs-customcf.ecu-cf-framework.helpers.html.tags.list.li"();
		if (disableNext) {
			liNext.addAttribute("class", "disabled");
			nextPage = activePage;
			text = text = "<span>" & next & "</span>";;
		} else {
			nextPage = activePage + 1;
			dataString = "data-page=" & EncodeForURL(nextPage) & " data-page-size=" & EncodeForURL(pageSize) & urlDataAttributes;
			text = "<a " & dataString & " href='?" & queryString & "page=" & EncodeForURL(nextPage) & "&page_size=" & EncodeForURL(pageSize) & "'>" & next & "</a>";
		}
		liNext.setText(text);
		ul.addLi(liNext);

		if (showFirstLast) {
			liLast = new "cs-customcf.ecu-cf-framework.helpers.html.tags.list.li"();
			if (disableLast) {
				liLast.addAttribute("class", "disabled");
				 text = "<span>" & last & "</span>";
			} else {
				dataString = "data-page=" & EncodeForURL(numberOfPages) & " data-page-size=" & EncodeForURL(pageSize) & urlDataAttributes;
				text = "<a " & dataString & " href='?" & queryString & "page=" & EncodeForURL(numberOfPages) & "&page_size=" & EncodeForURL(pageSize) & "'>" & last & "</a>";
			}
			liLast.setText(text);
			ul.addLi(liLast);
		}

		output = super.render();
		output = output & ul.render();
		output = output & super.renderClose();

		return output;
	}

}