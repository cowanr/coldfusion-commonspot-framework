/**
 * Creates an A to Z listing with an index at top.
 * 
 * Example:
 * 
 * queryService = new Query();
 * queryService.setDatasource("homepage_tools");
 * queryService.setSQL("SELECT LEFT(name, 1) as section_id, name, CONCAT('item.cfm?action=page&page=', id) AS url FROM itcs_pages ORDER BY name");
 * data = queryService.execute().getResult();
 * 
 * queryService = new Query();
 * queryService.setDatasource("homepage_tools");
 * queryService.setSQL("SELECT DISTINCT LEFT(name, 1) as letter FROM itcs_pages ORDER BY letter");
 * index = queryService.execute().getResult();
 * 
 * atoz = new "cs-customcf.ecu-cf-framework.widgets.atoz.atoz"();
 * atoz.setData(data);
 * atoz.setIndex(index); // Optional:  If index is not set then no index is created.
 * atoz.render();
 */
component output="false" accessors="true" {

	property query data;
	property query index;
	property string linkTarget;

	public string function render() {

		//JS for select
		js = "
		<script>    
		$(document).ready(function () {
	        $('##select-anchor').change( function () {
	            var targetPosition = $($(this).val()).offset().top;
	            $('html,body').animate({ scrollTop: targetPosition}, 'slow');
	        });
	    });
		</script>";

		// CSS to style div
		css = "
		<style>
			ul.ecu-a-z-index li {
				text-decoration:none;
				display: inline;
				padding-left: 2px;
				line-height: 30px;
			}

			.ecu-a-z-index > li > a {
				text-decoration:none;
				line-height: 20px;
				padding: 5px 6px;
				background-color: ##ddd;
				color: ##333;
				-webkit-border-radius: 2px;
				-moz-border-radius: 2px;
				border-radius: 2px;
				font-weight: bold;
			}

			.ecu-a-z-index > li > a:hover {
				text-decoration:none;
				background-color: ##592a8a;
				color: ##fff;
				text-decoration: none;
			}
			.ecu-a-z-list ul {
			    list-style: none;
			    padding: 0;
			    margin: 0;
			}
			ul.ecu-a-z-index li {
			    display: inline;
			    padding-left: 2px;
			    line-height: 30px;
			}

			.ecu-a-z-index {
			    margin: 0 auto;
			    text-align: center;
			}

			.ecu-a-z-section-block {
				margin-bottom: 15px;
			}

			.ecu-a-z-section-block hr {
				margin-top:0;
				margin-bottom: 10px;
			}

			.ecu-a-z-top-link {
				padding-top:15px;
			}

			.ecu-a-z-section-header h4 {
			  border-bottom: 0;
			  font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif;
			  -webkit-font-smoothing: antialiased;
			  color: ##592a8a;
			  font-weight: normal;
			  //font-size: 36px;
			  //line-height: 40px;
			  margin:0;
			}
		</style>";

	
		list = "
			<div class='ecu-a-z-list'>
				<a name='top-of-list'></a>";

		if(IsDefined("index.RecordCount") && index.RecordCount > 1) {
			
			list = list &  "<ul class='hidden-phone ecu-a-z-index'>";
			select = "<select class='hidden-desktop' id='select-anchor'>";

			for (i=1;i LTE index.RecordCount;i=i+1) {
				list = list &  "<li><a href='##" & EncodeForHtml(index.letter[i]) & "'>" & EncodeForHtml(index.letter[i]) & "</a></li>";
				select = select & "<option value='##" & EncodeForHtml(index.letter[i]) & "'>" & EncodeForHtml(index.letter[i]) & "</option>";
			}

			list = list &  "</ul>" & select & "</select>";
		
		list = list &  "
			<hr />";
		}

		if(!StructKeyExists(data, "RecordCount") || data.RecordCount <= 0) {
			list = list &  "There is nothing to show.  Check back later!</div>";
		} else {
			target = '';
			if(IsDefined('linkTarget')) {	
				target = 'target="' & linkTarget & '" ';
			}

 			current = "";
	 		for (i=1;i LTE data.RecordCount;i=i+1) {

				if(current != data.section_id[i]) {
					if(i!=1) {
						list = list &  "
							</ul>
						</div>";
					}

					list = list &  "
					<div class='ecu-a-z-section-block'>
						<div class='ecu-a-z-section-header'>
							<div class='row-fluid'>
								<div id='" & EncodeForHTMLAttribute(data.section_id[i]) & "' class='span6'>
									<h4><a name='" & EncodeForHTMLAttribute(data.section_id[i]) & "'></a>" & EncodeForHtml(data.section_id[i]) & "</h4>
								</div>
								<div class='span6'>";

					if(IsDefined("index.RecordCount") && index.RecordCount > 1) {
						list = list &  "
									<span class='hidden-desktop ecu-a-z-top-link'><a href='##top-of-list'>Top</a></span>
									<span class='hidden-phone ecu-a-z-top-link pull-right'><a href='##top-of-list'>Top</a></span>";
					}
					list = list &  "
								</div>
							</div>
							<hr>
						</div>
						<ul>";
				}
				current = data.section_id[i];

				list = list &  "<li class='indent'><a " & target & "href='" & EncodeForHTMLAttribute(data.url[i]) & "'>" & EncodeForHtml(data.name[i]) & "</a></li>";
			}
							
			list = list &  "</ul>
			</div></div>";
		}
		return js & css & list;
	}
}