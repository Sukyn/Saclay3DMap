
class Poi {

  Land land;

  Poi(Land land){
    this.land = land;
  }

  // ArrayList de PVector qui contient des GeoPoint
  ArrayList<PVector> getPoints(String fileName){

    File ressource = dataFile(fileName);
    if (!ressource.exists() || ressource.isDirectory()) {
      println("ERROR: Trail file " + fileName + " not found.");
      exitActual();
    }



    // Load geojson and check features collection
    JSONObject geojson = loadJSONObject(fileName);
    if (!geojson.hasKey("type")) {
      println("WARNING: Invalid GeoJSON file.");
    } else if (!"FeatureCollection".equals(geojson.getString("type", "undefined"))) {
      println("WARNING: GeoJSON file doesn't contain features collection.");
    }

    // Parse features
    JSONArray features =  geojson.getJSONArray("features");
    if (features == null) {
      println("WARNING: GeoJSON file doesn't contain any feature.");
    }

    ArrayList<PVector> result = new ArrayList<PVector>();

    for (int f = 0; f < features.size(); f++){
      JSONObject feature = features.getJSONObject(f);
      if (!feature.hasKey("geometry"))
        break;

       JSONArray point = feature.getJSONObject("geometry").getJSONArray("coordinates");
       Map3D.GeoPoint gp = this.land.map.new GeoPoint(point.getFloat(0), point.getFloat(1));
       Map3D.ObjectPoint mp = this.land.map.new ObjectPoint(gp);
       result.add(mp.toVector());
    }
  return result;
  }

  void calculdistance(){
    // Getting points of interests
    ArrayList<PVector> bykeparking = this.getPoints("bicycle.geojson");
    ArrayList<PVector> picnic = this.getPoints("picnic.geojson");

    for (int v = 0; v < this.land.satellite.getVertexCount(); v++) {
      // Initializing location with the targetted point
      PVector location = new PVector();
      this.land.satellite.getVertex(v, location);
      // Initializing distances at the maximum
      float nearestBykeParkingDistance = 250;
      float nearestPicNicTableDistance = 250;
      // Calculating the nearest BykeParking station
      for (int p=0; p < bykeparking.size(); p++) {
        PVector point = bykeparking.get(p);
        float d = dist(location.x, location.y, point.x, point.y);
        if (d < nearestBykeParkingDistance)
          nearestBykeParkingDistance = d;
      }
      // Calculating the nearest PicNic station
      for (int p=0; p < picnic.size(); p++) {
        PVector point = picnic.get(p);
        float d = dist(location.x, location.y, point.x, point.y);
        if (d < nearestPicNicTableDistance)
          nearestPicNicTableDistance = d;
      }
      // Setting attributes
      this.land.satellite.setAttrib("heat", v, nearestBykeParkingDistance/250, nearestPicNicTableDistance/250);
    }
  }

}
