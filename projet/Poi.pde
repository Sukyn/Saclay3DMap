
class Poi {

  Land land;

  public Poi(Land land){
    this.land = land;
    float nearestBykeParkingDistance = 0.0f;
    float nearestPicNicTableDistance = 0.0f;
    //this.land.attrib("heat", nearestBykeParkingDistance, nearestPicNicTableDistance); 
  }

  JSONArray getPoints(String fileName){

    File ressource = dataFile(fileName);
    if (!ressource.exists() || ressource.isDirectory()) {
      println("ERROR: Trail file " + fileName + " not found.");
      exitActual();
    }

    JSONArray result = new JSONArray();

    // Load geojson and check features collection
    JSONObject geojson = loadJSONObject(fileName);
    if (!geojson.hasKey("type")) {
      println("WARNING: Invalid GeoJSON file.");
      return result;
    } else if (!"FeatureCollection".equals(geojson.getString("type", "undefined"))) {
      println("WARNING: GeoJSON file doesn't contain features collection.");
      return result;
    }

    // Parse features
    JSONArray features =  geojson.getJSONArray("features");
    if (features == null) {
      println("WARNING: GeoJSON file doesn't contain any feature.");
      return result;
    }


    for (int f = 0; f < features.size(); f++){
      JSONObject feature = features.getJSONObject(f);
      if (!feature.hasKey("geometry"))
        break;

       JSONArray coordinates = feature.getJSONObject("geometry").getJSONArray("coordinates");
       result.append(coordinates);
    }
    return result;
  }
}
