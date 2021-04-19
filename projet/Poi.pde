
class Poi {

  Land land;

  /**
  * Constructeur de la classe
  * @param land : Le terrain sur lequel on travaille
  */
  Poi(Land land){
    this.land = land;
  }

  /**
  * Fonction qui récupère les points d'un fichier
  * @param fileName : le nom du fichier geojson
  * @return la liste des PVector associés au fichier
  */
  ArrayList<PVector> getPoints(String fileName){

    // On vérifie que le fichier existe
    File ressource = dataFile(fileName);
    if (!ressource.exists() || ressource.isDirectory()) {
      println("ERROR: Trail file " + fileName + " not found.");
      exitActual();
    }

    // Charge geojson et vérifie les fonctionnalités
    JSONObject geojson = loadJSONObject(fileName);
    if (!geojson.hasKey("type")) {
      println("WARNING: Invalid GeoJSON file.");
    } else if (!"FeatureCollection".equals(geojson.getString("type", "undefined"))) {
      println("WARNING: GeoJSON file doesn't contain features collection.");
    }

    // Analyse les fonctionnalités
    JSONArray features =  geojson.getJSONArray("features");
    if (features == null) {
      println("WARNING: GeoJSON file doesn't contain any feature.");
    }

    // On crée un nouveau tableau
    ArrayList<PVector> result = new ArrayList<PVector>();

    // Pour chaque point de notre fichier, on l'ajoute à notre tableau de PVector
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

  /**
  * Procédure de calcul des distances entre
  * les points d'intérets et notre terrain
  */
  void calculdistance(){
    // Récupération des points d'intérêt
    ArrayList<PVector> bykeParking = this.getPoints("bicycle.geojson");
    ArrayList<PVector> picnic = this.getPoints("picnic.geojson");
    ArrayList<PVector> restaurant = this.getPoints("restaurant.geojson");

    for (int v = 0; v < this.land.satellite.getVertexCount(); v++) {
      // Initialise l'emplacement aux point cibles
      PVector location = new PVector();
      this.land.satellite.getVertex(v, location);
      // Initialise les distances au maximum
      float nearestbykeParkingDistance = 250;
      float nearestPicNicTableDistance = 250;
      float nearestRestaurantDistance = 250;
      // Calcule la station bykeParking la plus proche
      for (int p=0; p < bykeParking.size(); p++) {
        PVector point = bykeParking.get(p);
        float d = dist(location.x, location.y, point.x, point.y);
        if (d < nearestbykeParkingDistance)
          nearestbykeParkingDistance = d;
      }
      // Calcule la station picnic la plus proche
      for (int p=0; p < picnic.size(); p++) {
        PVector point = picnic.get(p);
        float d = dist(location.x, location.y, point.x, point.y);
        if (d < nearestPicNicTableDistance)
          nearestPicNicTableDistance = d;
      }
      // Calcule la station picnic la plus proche
      for (int p=0; p < restaurant.size(); p++) {
        PVector point = restaurant.get(p);
        float d = dist(location.x, location.y, point.x, point.y);
        if (d < nearestRestaurantDistance)
          nearestRestaurantDistance = d;
      }
      // Règle les attributs
      this.land.satellite.setAttrib("heat",
                                    v,
                                    nearestbykeParkingDistance/250,
                                    nearestPicNicTableDistance/250,
                                    nearestRestaurantDistance/250);
    }
  }

}
