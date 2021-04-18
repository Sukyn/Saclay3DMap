

class Railways {
  /**
  * La forme de la ligne de train
  */
  PShape railways;

  /**
  * Constructeur de la classe
  * @params map : La carte sur laquelle on travaille
  * @params fileName : le nom du fichier geojson représentant notre voie ferrée
  */
  public Railways(Map3D map, String fileName){

    // On vérifie que le fichier existe bien
    File ressource = dataFile(fileName);
    if (!ressource.exists() || ressource.isDirectory()) {
      println("ERROR: Trail file " + fileName + " not found.");
      exitActual();
    }

    // Charge geojson et vérifie les fonctionnalités
    JSONObject geojson = loadJSONObject(fileName);
    if (!geojson.hasKey("type")) {
      println("WARNING: Invalid GeoJSON file.");
      return;
    } else if (!"FeatureCollection".equals(geojson.getString("type", "undefined"))) {
      println("WARNING: GeoJSON file doesn't contain features collection.");
      return;
    }

    // Analyse les fonctionnalités
    JSONArray features =  geojson.getJSONArray("features");
    if (features == null) {
      println("WARNING: GeoJSON file doesn't contain any feature.");
      return;
    }

    // Notre réseau de train est un groupe de voie ferrée individuelles
    this.railways = createShape(GROUP);

    // On fixe une largeur
    int laneWidth = 5;

    // Et pour chaque voie ferrée, on la trace
    for (int f=0; f<features.size(); f++) {

      // On crée une ligne de chemin de fer
      PShape lane = createShape();
      lane.beginShape(QUAD_STRIP);
      lane.fill(255, 255, 255); // Couleur
      lane.noStroke();
      lane.emissive(0x7F); // Lumière

      // On recupère les infos de la ligne qui nous intéresse
      JSONObject feature = features.getJSONObject(f);
      if (!feature.hasKey("geometry"))
        break;
      JSONObject geometry = feature.getJSONObject("geometry");
      switch (geometry.getString("type", "undefined")) {

        // On ne doit avoir que des LineString normalement
        case "LineString":

          JSONArray coordinates = geometry.getJSONArray("coordinates");

          /**
          * Ce système un peu élaboré permet de tracer les routes en utilisant
          * les normales par rapport à ses points voisins sans avoir
          * besoin de recaculer les différents points
          * (complexité optimisée)
          */

          // On récupère le premier point
          JSONArray firstPoint = coordinates.getJSONArray(0);
          Map3D.GeoPoint fGp = map.new GeoPoint(firstPoint.getFloat(0), firstPoint.getFloat(1));
          fGp.elevation += 7.5d;
          Map3D.ObjectPoint fMp = map.new ObjectPoint(fGp);
          /** Et on initialise le second point avec le même point !
          * ça permet après de pouvoir définir notre troisième point à
          * l'identique lors du premier passage dans la boucle
          * ça gère notamment les cas où il y a très peu de points dans notre ligne
          */
          Map3D.ObjectPoint sMp = fMp;

          // Pour tous les points, on rentre dans la boucle
          for (int p=0; p < coordinates.size(); p++) {

            /** sMp est en fait le point que l'on trace à chaque passage de boucle
            * c'est celui qui est entre le first et le third !
            */

            // On vérifie qu'il est bien dans notre carte
            if (sMp.inside()) {

              // On initialise le troisieme point au second
              // (utile s'il n'y a que deux points !)
              Map3D.ObjectPoint tMp = sMp;

              // Si l'on est sur le dernier point, le troisieme point est identique au
              // second (parce qu'il n'y en a pas après), donc on ne le recalcule pas
              if (p != coordinates.size()-1){
                JSONArray thirdPoint = coordinates.getJSONArray(p+1);
                Map3D.GeoPoint tGp = map.new GeoPoint(thirdPoint.getFloat(0), thirdPoint.getFloat(1));
                tGp.elevation += 7.5d;
                // On a ainsi calculé notre troisieme point
                tMp = map.new ObjectPoint(tGp);
              }

              // On calcule la normale selon le point d'avant et d'après
              PVector Va = new PVector(tMp.y - fMp.y, fMp.x - tMp.x).normalize().mult(laneWidth/2.0f);
              // On trace notre ligne
              lane.normal(0.0f, 0.0f, 1.0f);
              lane.vertex(sMp.x - Va.x, sMp.y - Va.y, sMp.z);
              lane.normal(0.0f, 0.0f, 1.0f);
              lane.vertex(sMp.x + Va.x, sMp.y + Va.y, sMp.z);

              // Et on n'oublie pas d'avancer nos points
              fMp = sMp;
              sMp = tMp;
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
  }

  /**
  * Procédure d'affichage des formes
  */
  void update() {
    shape(this.railways);
  }

  /**
  * Procédure pour rendre visible le tracé de notre voie ferrée
  */
  void toggle(){
    this.railways.setVisible(!this.railways.isVisible());
  }
}
