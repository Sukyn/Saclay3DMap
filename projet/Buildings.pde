

class Buildings {
  /**
  * Forme de nos buildings
  */
  PShape buildings;

  /**
  * Carte sur laquelle on travaille
  */
  Map3D map;

  /**
  * Constructeur de notre classe
  * @params map : notre terrain
  */
  public Buildings(Map3D map){
    this.map = map;
    // Buildings est un GROUP qui comportera les
    // différents bâtiments
    this.buildings = createShape(GROUP);
  }

  /**
  * Fonction d'ajout d'un fichier geojson à nos buildings
  * @params fileName : le nom de notre fichier geojson
  * @params couleur : La couleur associée au building
  */
  public void add(String fileName, color couleur){

    // On vérifie d'abord que notre fichier existe bien dans notre répertoire
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

    // Pour chaque élement de feature, on va construire nos bâtiments
    for (int f=0; f<features.size(); f++) {

      // On vérifie la construction de notre JSONObject
      JSONObject feature = features.getJSONObject(f);
      if (!feature.hasKey("geometry"))
          break;
      if (!feature.hasKey("properties"))
          break;

      // On récupère le nombre d'étages du building
      int levels = feature.getJSONObject("properties").getInt("building:levels", 1);
      JSONObject geometry = feature.getJSONObject("geometry");

      switch (geometry.getString("type", "undefined")) {

        case "Polygon":
          // Note : Pour les buildings on ne travaille que sur des polygones
          JSONArray coordinates = geometry.getJSONArray("coordinates");
          // Les buildings sont composés de plusieurs bâtiments,
          // on les traite donc individuellement
          for (int p=0; p < coordinates.size(); p++) {
            // Chaque bâtiment est modelisé par ses murs et son toit
            // (le sol et l'intérieur n'étant pas visible de toute manière)
            PShape walls = createShape();
            PShape roof = createShape();
            // Le toit est de type POLYGON car la forme peut varier !
            roof.beginShape(POLYGON);
            // Les murs sont des rectangles, on considère ici qu'il n'y
            // a pas d'excentricité architecturale...
            walls.beginShape(QUAD_STRIP);

            // On les met de la couleur voulue
            roof.fill(couleur);
            walls.fill(couleur);
            // Et on y ajoute un peu de lumière pour les mirettes
            roof.emissive(0x60);
            walls.emissive(0x30);

            // On construit maintenant la forme de notre bâtiment
            JSONArray buildingNumero = coordinates.getJSONArray(p);
            for (int h = 0; h < buildingNumero.size(); h++) {

              // On récupère les coordonnées stockées dans notre fichier
              JSONArray pointArray = buildingNumero.getJSONArray(h);
              Map3D.GeoPoint geopoint = this.map.new GeoPoint(pointArray.getFloat(0), pointArray.getFloat(1));
              Map3D.ObjectPoint mp = this.map.new ObjectPoint(geopoint);
              // On vérifie que le point est bien sur le plan qui nous intéresse
              if (mp.inside()){
                // La hauteur du bâtiment est définie par son nombre d'étage
                float top = Map3D.heightScale*3.0f*(float)levels;
                // On ajoute les points du toit
                roof.vertex(mp.x, mp.y, mp.z + top);
                // Et des murs
                walls.vertex(mp.x, mp.y, mp.z);
                walls.vertex(mp.x, mp.y, mp.z + top);
              }
            }
            walls.endShape();
            // On ajoute le paramètre CLOSE pour que notre polygone se ferme bien
            roof.endShape(CLOSE);
            // On ajoute le batiment à la shape building
            this.buildings.addChild(roof);
            this.buildings.addChild(walls);
            }

          break;

      // On n'a que des polygones dans les buildings
      default:
        println("WARNING: GeoJSON '" + geometry.getString("type", "undefined") + "' geometry type not handled.");
        break;
      }

    }
  }

  /**
  * Procédure d'affichage de la forme
  */
  void update() {
    shape(this.buildings);
  }

  /**
  * Procédure pour rendre visible la forme
  */
  void toggle(){
    this.buildings.setVisible(!this.buildings.isVisible());
  }
}
