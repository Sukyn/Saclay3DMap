

class Railways {
  PShape railways;
  JSONArray features;
  Map3D map;

  public Railways(Map3D map, String fileName){
    this.map = map;
    this.railways = createShape(GROUP);
    int laneWidth = 2;




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
      lane.fill(255, 255, 255);
      lane.stroke(255, 255, 255);
      lane.strokeWeight(4);


      JSONObject feature = features.getJSONObject(f);
      if (!feature.hasKey("geometry"))
        break;
      JSONObject geometry = feature.getJSONObject("geometry");
      switch (geometry.getString("type", "undefined")) {

      case "LineString":

        // GPX Track
        JSONArray coordinates = geometry.getJSONArray("coordinates");
        if (coordinates.size() > 2){

          JSONArray first_point = coordinates.getJSONArray(0);
          Map3D.GeoPoint f_gp = this.map.new GeoPoint(first_point.getFloat(0), first_point.getFloat(1));
          f_gp.elevation += 7.5d;
          Map3D.ObjectPoint f_mp = this.map.new ObjectPoint(f_gp);
          Map3D.ObjectPoint s_mp = f_mp;

          for (int p=0; p < coordinates.size(); p++) {
            if (s_mp.inside()) {

              Map3D.ObjectPoint t_mp;
              if (p == coordinates.size()-1) t_mp = s_mp;
              else {
                JSONArray third_point = coordinates.getJSONArray(p+1);
                Map3D.GeoPoint t_gp = this.map.new GeoPoint(third_point.getFloat(0), third_point.getFloat(1));
                t_gp.elevation += 7.5d;
                t_mp = this.map.new ObjectPoint(t_gp);
              }

              PVector Va = new PVector(t_mp.y - f_mp.y, t_mp.x - f_mp.x).normalize().mult(laneWidth/2.0f);
              lane.normal(0.0f, 0.0f, 1.0f);
              lane.vertex(s_mp.x - Va.x, s_mp.y - Va.y, s_mp.z);
              lane.normal(0.0f, 0.0f, 1.0f);
              lane.vertex(s_mp.x + Va.x, s_mp.y + Va.y, s_mp.z);

              f_mp = s_mp;
              s_mp = t_mp;
            }
          }
        }

        break;

      default:
        println("WARNING: GeoJSON '" + geometry.getString("type", "undefined") + "' geometry type not handled.");
        break;
      }

    lane.endShape();
    this.railways.addChild(lane);
    }
  //  this.railways.endShape();

  }

  void update() {
    shape(this.railways);
  }

  void toggle(){
    this.railways.setVisible(!this.railways.isVisible());
  }
}
