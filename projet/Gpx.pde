

class Gpx {

  /**
  * Forme du sol
  */
  PShape track;

  /**
  * Forme des lignes verticales
  */
  PShape posts;

  /**
  * Forme des boules des épingles
  */
  PShape thumbTracks;

  JSONArray features;

  // Position sélectionnée par l'utilisateur (pour afficher les informations)
  int selectedPosition;

  Map3D map;

  // Hauteur des épingles
  int height = 80;

  /**
  * Constructeur de la classe
  * @params map : Le terrain sur lequel on travaille
  * @params fileName : le nom du fichier de notre tracé GPX
  */
  public Gpx(Map3D map, String fileName){
    this.map = map;

    // On ne sélectionne pas de position tant que l'utilisateur n'a pas cliqué
    this.selectedPosition = -1;

    // On vérifie que le fichier mentionné par l'utilisateur existe bien
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
    this.features =  geojson.getJSONArray("features");
    if (features == null) {
      println("WARNING: GeoJSON file doesn't contain any feature.");
      return;
    }

    // Le tracé au sol
    this.track = createShape();
    this.track.beginShape();
    this.track.noFill();

    // Le composant de l'épingle
    this.posts = createShape();
    this.posts.beginShape(LINES);

    // La boule de l'épingle
    this.thumbTracks = createShape();
    this.thumbTracks.beginShape(POINTS);

    this.track.strokeWeight(3.5); // Taille
    this.track.stroke(255, 0, 0); // Couleur
    this.posts.strokeWeight(3.8);
    this.posts.stroke(100, 0, 0);
    this.thumbTracks.strokeWeight(30);
    this.thumbTracks.stroke(0xFFFF3F3F);

    // Pour chaque élement de notre tracé GPX, on relie les points
    for (int f=0; f<features.size(); f++) {

      // On vérifie que le fichier est correctement construit
      JSONObject feature = features.getJSONObject(f);
      if (!feature.hasKey("geometry"))
        break;
      JSONObject geometry = feature.getJSONObject("geometry");
      switch (geometry.getString("type", "undefined")) {

      /**
      * Le GPX est composé de points d'intérets que l'on représentera en épingle
      * et de tracés "Track" qui les relient entre eux au sol
      */
      case "LineString":

        // GPX Track
        JSONArray coordinates = geometry.getJSONArray("coordinates");
        if (coordinates != null)
          for (int p=0; p < coordinates.size(); p++) {
            // On relie les différents points des coordonnées entre eux
            JSONArray point = coordinates.getJSONArray(p);
            Map3D.GeoPoint gp = this.map.new GeoPoint(point.getFloat(0), point.getFloat(1));
            Map3D.ObjectPoint mp = this.map.new ObjectPoint(gp);
            this.track.vertex(mp.x, mp.y, mp.z);
          }
        break;

      case "Point":

        // Point de passage GPX
        if (geometry.hasKey("coordinates")) {
          JSONArray point = geometry.getJSONArray("coordinates");
          Map3D.GeoPoint gp = this.map.new GeoPoint(point.getFloat(0), point.getFloat(1));
          Map3D.ObjectPoint mp = this.map.new ObjectPoint(gp);
          // On construit nos épingles
          this.posts.vertex(mp.x, mp.y, mp.z);
          this.posts.vertex(mp.x, mp.y, mp.z+this.height);
          this.thumbTracks.vertex(mp.x, mp.y, mp.z+this.height);
        }
        break;

      // Les GPX ne sont que des Point et des Lignes, sinon c'est pas normal
      default:
        println("WARNING: GeoJSON '" + geometry.getString("type", "undefined") + "' geometry type not handled.");
        break;
      }
    }
    this.track.endShape();
    this.posts.endShape();
    this.thumbTracks.endShape();
  }

  /**
  * Procédure d'affichage des formes
  */
  void update(){
    shape(this.track);
    shape(this.posts);
    shape(this.thumbTracks);
    // Si une épingle est selectionnée, on affiche la description associée
    if (this.selectedPosition != -1 && this.track.isVisible())
      description(this.selectedPosition, camera);
  }

  /**
  * Procédure pour rendre visible le GPX
  */
  void toggle(){
    this.track.setVisible(!this.track.isVisible());
    this.posts.setVisible(!this.posts.isVisible());
    this.thumbTracks.setVisible(!this.thumbTracks.isVisible());
  }


  /**
  * Procédure pour la gestion de clic : On selectionne l'épingle la plus proche
  */
  void clic(int mouseX, int mouseY) {

    // On initialize la distance minimale à la taille du terrain
    float minDist = dist(0, 0, (int)this.map.width, (int)this.map.height);

    // Et on recherche quel est l'épingle la' plus proche
    for (int v = 0; v < this.thumbTracks.getVertexCount(); v++){

      PVector hit = this.thumbTracks.getVertex(v);

      // Pour chaque épingle, on calcule sa distance au point cliqué
      float d = dist(screenX(hit.x, hit.y, hit.z), screenY(hit.x, hit.y, hit.z), mouseX, mouseY);
      // Et on stock la plus proche
      if (d < minDist) {
        minDist = d;
        this.selectedPosition = v;
      }

    }
    // On affiche la couleur de l'épingle différemment pour montrer
    // qu'elle est sélectionnée
    for (int v = 0; v < this.thumbTracks.getVertexCount(); v++){
      if (v == this.selectedPosition){
          this.thumbTracks.setStroke(v, 0xFF3FFF7F);
      } else
          this.thumbTracks.setStroke(v, 0xFFFF3F3F);
    }
  }

  /**
  * Procédure d'affichage de la description de l'épingle
  */
  void description(int v, Camera camera){

    // Si on n'a pas d'information, description vaudra "Pas d'information"
    String description = this.features.getJSONObject(v+1).getJSONObject("properties").getString("desc", "Pas d'information");

    pushMatrix();
    // On définit la couleur du texte à blanc (arbitraire)
    fill(0xFFFFFFFF);
    // On récupère l'épingle recherchée
    PVector hit = this.thumbTracks.getVertex(v);
    // Et on se positionne par rapport à ses coordonnées
    translate(hit.x, hit.y, hit.z + this.height);

    // L'affichage du texte l'épingle sera ainsi toujours placé face
    // à l'utilisateur
    rotateZ(-camera.longitude-HALF_PI);
    rotateX(-camera.colatitude);

    // Désactiver le DEPTH TEST permet de faire en sorte que le texte
    // reste visible même lorsque l'on passe sous le terrain
    g.hint(PConstants.DISABLE_DEPTH_TEST);
    textMode(SHAPE);
    textSize(48);
    textAlign(LEFT, CENTER);
    text(description, 0, 0);
    g.hint(PConstants.ENABLE_DEPTH_TEST);

    popMatrix();
  }
}
