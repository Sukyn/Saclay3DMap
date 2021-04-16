

class Roads {
  PShape roads;
  JSONArray features;
  Map3D map;

  public Roads(Map3D map, String fileName){
    this.map = map;
    this.roads = createShape(GROUP);

    File ressource = dataFile(fileName);
    if (!ressource.exists() || ressource.isDirectory()) {
      println("ERROR: Trail file " + fileName + " not found.");
      exitActual();
    }

    // Load geojson and check features collection
    JSONObject geojson = loadJSONObject(fileName);
    if (!geojson.hasKey("type")) {
      println("WARNING: Invalid GeoJSON file.");
      return;
    } else if (!"FeatureCollection".equals(geojson.getString("type", "undefined"))) {
      println("WARNING: GeoJSON file doesn't contain features collection.");
      return;
    }

    // Parse features
    this.features =  geojson.getJSONArray("features");
    if (features == null) {
      println("WARNING: GeoJSON file doesn't contain any feature.");
      return;
    }

    for (int f=0; f<features.size(); f++) {

      PShape lane = createShape();
      lane.beginShape(QUAD_STRIP);

      JSONObject feature = features.getJSONObject(f);
      if (!feature.hasKey("geometry"))
        break;

      if (!feature.hasKey("properties"))
          break;

      String laneKind = "unclassified";
      laneKind = feature.getJSONObject("properties").getString("highway", "unclassified");
      color laneColor = 0xFFFFFF00;
      double laneOffset = 1.50d;
      float laneWidth = 0.5f;

        switch (laneKind) {
              case "motorway":
                 laneColor = 0xFFe990a0;
                 laneOffset = 3.75d;
                 laneWidth = 8.0f;
                 break;
              case "trunk":
                 laneColor = 0xFFfbb29a;
                 laneOffset = 3.60d;
                 laneWidth = 7.0f;
                 break;
              case "trunk_link":
              case "primary":
                 laneColor = 0xFFfdd7a1;
                 laneOffset = 3.45d;
                 laneWidth = 6.0f;
                 break;
              case "secondary":
              case "primary_link":
                 lane.beginShape(QUAD_STRIP);
                 lane.fill(255, 255, 255);
                 laneColor = 0xFFf6fabb;
                 laneOffset = 3.30d;
                 laneWidth = 5.0f;
                 break;
              case "tertiary":
              case "secondary_link":
                 laneColor = 0xFFE2E5A9;
                 laneOffset = 3.15d;
                 laneWidth = 4.0f;
                 break;
              case "tertiary_link":
              case "residential":
              case "construction":
              case "living_street":
                 laneColor = 0xFFB2B485;
                 laneOffset = 3.00d;
                 laneWidth = 3.5f;
                 break;
              case "corridor":
              case "cycleway":
              case "footway":
              case "path":
              case "pedestrian":
              case "service":
              case "steps":
              case "track":
              case "unclassified":
                 laneColor = 0xFFcee8B9;
                 laneOffset = 2.85d;
                 laneWidth = 1.0f;
                 break;
              default:
               laneColor = 0xFFFF0000;
               laneOffset = 1.50d;
               laneWidth = 0.5f;
               println("WARNING: Roads kind not handled : ", laneKind);
               break;
        }
        // Display threshold (increase if more performance needed...)
        if (laneWidth < 1.0f)
         break;

      lane.fill(laneColor);
      //lane.noFill();
      lane.noStroke();
    //  lane.stroke(laneColor);
    //  lane.strokeWeight((float)laneWidth);
      lane.emissive(0x7F);
      String isBridge = feature.getJSONObject("properties").getString("bridge", "N/A");
      JSONObject geometry = feature.getJSONObject("geometry");
      switch (geometry.getString("type", "undefined")) {

      case "LineString":

        JSONArray coordinates = geometry.getJSONArray("coordinates");
          JSONArray first_point = coordinates.getJSONArray(0);
          Map3D.GeoPoint f_gp = this.map.new GeoPoint(first_point.getFloat(0), first_point.getFloat(1));
          f_gp.elevation += laneOffset;
          Map3D.ObjectPoint f_mp = this.map.new ObjectPoint(f_gp);
          Map3D.ObjectPoint s_mp = f_mp;

            for (int p=0; p < coordinates.size(); p++) {
              if (s_mp.inside()) {

                Map3D.ObjectPoint t_mp = s_mp;
                if (p != coordinates.size()-1) {
                JSONArray third_point = coordinates.getJSONArray(p+1);
                Map3D.GeoPoint t_gp = this.map.new GeoPoint(third_point.getFloat(0), third_point.getFloat(1));
                t_gp.elevation += laneOffset;
                t_mp = this.map.new ObjectPoint(t_gp);
                }

                PVector Va = new PVector(t_mp.y - f_mp.y, f_mp.x - t_mp.x).normalize().mult(laneWidth/2.0f);
                if (isBridge == "N/A"){
                  lane.normal(0.0f, 0.0f, 1.0f);
                  lane.vertex(s_mp.x - Va.x, s_mp.y - Va.y, s_mp.z);
                  lane.normal(0.0f, 0.0f, 1.0f);
                  lane.vertex(s_mp.x + Va.x, s_mp.y + Va.y, s_mp.z);

                } else {
                  // GERER LES PONTS ICI SVP
                  // TO DO
                  lane.normal(0.0f, 0.0f, 1.0f);
                  lane.vertex(s_mp.x - Va.x, s_mp.y - Va.y, s_mp.z);
                  lane.normal(0.0f, 0.0f, 1.0f);
                  lane.vertex(s_mp.x + Va.x, s_mp.y + Va.y, s_mp.z);
                }
                f_mp = s_mp;
                s_mp = t_mp;
              }
            }


        break;

      default:
        println("WARNING: GeoJSON '" + geometry.getString("type", "undefined") + "' geometry type not handled.");
        break;
      }

    lane.endShape();
    this.roads.addChild(lane);

    }
  }

  void update() {
    shape(this.roads);
  }

  void toggle(){
    this.roads.setVisible(!this.roads.isVisible());
  }
}
