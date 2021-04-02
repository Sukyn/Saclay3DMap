

class Buildings {
  PShape buildings;
  Map3D map;

  public Buildings(Map3D map){
    this.map = map;
    this.buildings = createShape(GROUP);
  }

  public void add(String fileName, color couleur){

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
    JSONArray features =  geojson.getJSONArray("features");
    if (features == null) {
      println("WARNING: GeoJSON file doesn't contain any feature.");
      return;
    }


    for (int f=0; f<features.size(); f++) {

      JSONObject feature = features.getJSONObject(f);
      if (!feature.hasKey("geometry"))
        break;

      if (!feature.hasKey("properties"))
          break;

      int levels = feature.getJSONObject("properties").getInt("building:levels", 1);
      JSONObject geometry = feature.getJSONObject("geometry");
      switch (geometry.getString("type", "undefined")) {

      case "Polygon":

        PShape walls = createShape();
        PShape roof = createShape();
        roof.beginShape();
        walls.beginShape(QUAD_STRIP);
        roof.fill(couleur);
        walls.fill(couleur);
        roof.emissive(0x60);
        walls.emissive(0x30);
        // Note : Il faudrait calculer les normales (cf. fin de l'énoncé)
        JSONArray coordinates = geometry.getJSONArray("coordinates");
          for (int p=0; p < coordinates.size(); p++) {
              JSONArray building_numero = coordinates.getJSONArray(p);
              for (int h = 0; h < building_numero.size(); h++) {
                JSONArray point_array = building_numero.getJSONArray(h);
                Map3D.GeoPoint geopoint = this.map.new GeoPoint(point_array.getFloat(0), point_array.getFloat(1));
                Map3D.ObjectPoint mp = this.map.new ObjectPoint(geopoint);
                if (mp.inside()){
                  float top = Map3D.heightScale*3.0f*(float)levels;
                  roof.vertex(mp.x, mp.y, mp.z + top);
                  walls.vertex(mp.x, mp.y, mp.z);
                  walls.vertex(mp.x, mp.y, mp.z + top);
                }
              }
            }
        walls.endShape();
        roof.endShape();
        this.buildings.addChild(roof);
        this.buildings.addChild(walls);
        break;

      default:
        println("WARNING: GeoJSON '" + geometry.getString("type", "undefined") + "' geometry type not handled.");
        break;
      }

    }
  }

  void update() {
    shape(this.buildings);
  }

  void toggle(){
    this.buildings.setVisible(!this.buildings.isVisible());
  }
}
