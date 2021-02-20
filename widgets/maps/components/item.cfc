component output="false" accessors="true" {
 
 	property string id;

	property struct item;

	property array shapes;

	public function init() {
		shapes = ArrayNew(1);
	}

	public function loadItem(i) {

		id = i;
		var queryService = new Query();
		queryService.setDatasource("homepage_tools");
		queryService.setName("itemQuery");
		queryService.addParam(name="id", value=i, cfsqltype="CF_SQL_INTERGER");
		queryService.setSQL("SELECT * FROM maps_items LEFT JOIN maps_icons on maps_icons.id = maps_items.icon_id WHERE maps_items.id = :id");
		var itemQuery = queryService.execute().getResult();
		
		// Get item info
		switch(itemQuery.type_id) {

			case 1: // Generic Item
				break;

			case 2: // Building
				var queryService = new Query();
				queryService.setDatasource("homepage_tools");
				queryService.setName("buildingService");
				queryService.addParam(name="id", value=itemQuery.child_id, cfsqltype="CF_SQL_INTERGER");
				queryService.setSQL("SELECT university_buildings.code, university_buildings.name FROM homepage_tools.university_buildings LEFT JOIN maps_items ON maps_items.child_id = university_buildings.id WHERE university_buildings.id = :id");
				var buildingQuery = queryService.execute().getResult();
				
				item.code = buildingQuery['code'][1];
				item.name = buildingQuery['name'][1];	
				break;

			case 3: // Parking Lot
				break;

			case 4: // Emergency Blue Lights
				break;

			case 5: // Building Rooms
				var queryService = new Query();
				queryService.setDatasource("homepage_tools");
				queryService.setName("buildingRoomService");
				queryService.addParam(name="id", value=itemQuery.child_id, cfsqltype="CF_SQL_INTERGER");
				queryService.setSQL("SELECT university_buildings.code, university_buildings.name, university_buildings_rooms.room FROM homepage_tools.university_buildings_rooms LEFT JOIN university_buildings ON university_buildings.id = university_buildings_rooms.building_id LEFT JOIN maps_items ON maps_items.child_id = university_buildings.id WHERE university_buildings_rooms.id = :id");
				var buildingRoomQuery = queryService.execute().getResult();
				
				item.code = buildingRoomQuery['code'][1];
				item.name = buildingRoomQuery['name'][1];	
				item.room = buildingRoomQuery['room'][1];

				break;
		}

		// Get all Shapes
		queryService.setDatasource("homepage_tools");
		queryService.setName("mapShapesService");
		queryService.addParam(name="itemid", value=id, cfsqltype="CF_SQL_INTERGER");
		queryService.setSQL("SELECT * FROM homepage_tools.maps_shapes where item_id = :itemid");
		var mapsShapesQuery = queryService.execute().getResult();
				
		for(shape in mapsShapesQuery) {

			s = new "cs-customcf.ecu-cf-framework.widgets.maps.components.shape"();
			s.setId(shape.id);
			s.setType(shape.type);
			s.setStrokeColor(itemQuery.stroke_color);
			s.setFillColor(itemQuery.fill_color);
			s.setIconImage(itemQuery.image);
			s.setIconName(itemQuery.name);

			//Get all Points
			queryService.setDatasource("homepage_tools");
			queryService.setName("pointsService");
			queryService.addParam(name="id", value=shape.id, cfsqltype="CF_SQL_INTERGER");
			queryService.setSQL("SELECT * FROM homepage_tools.maps_points where shape_id = :id");
			var pointsQuery = queryService.execute().getResult();	

			for(point in pointsQuery) {
				p = new "cs-customcf.ecu-cf-framework.widgets.maps.components.point"();
				p.setId(point.id);
				p.setLng(point.lng);
				p.setLat(point.lat);
				s.addPoint(p);
			}

			ArrayAppend(shapes, s);
		}
		
		return itemQuery;
	}

	public function addShape(map_shape) {
		ArrayAppend(shapes, map_shape);
	}

}
