/**
* Rend un objet Land.
* Prépare l'ombre, la structure en fil de fer et les formes texturées de land
* @param map  Objet Map3D correspondant à l'élévation associées à Land
* @return     Objet Land
*/

class Land {
  Map3D map;

  /**
  * Forme de l'ombre du terrain
  */
  PShape shadow;

  /**
  * Forme du terrain en fil de fer
  */
  PShape wireFrame;

  /**
  * Forme du terrain avec la texture satellite
  */
  PShape satellite;

  /**
  * Constructeur de la classe
  * @param map : La carte avec laquelle on travaille
  * @param fileName : Le nom de notre fichier contenant l'image satellite
  */
  Land(Map3D map, String fileName) {

    // On vérifie que le fichier existe
    File ressource = dataFile(fileName);
    if (!ressource.exists() || ressource.isDirectory()) {
      println("ERROR: Land texture file " + fileName + " not found.");
      exitActual();
    }

    // Et on charge l'image
    PImage uvmap = loadImage(fileName);

    // La taille des tuiles est arbitraire,
    // Cette taille est correcte parce que ça ne fait pas trop lagguer mais
    // reste suffisamment précise
    final float tileSize = 25f;

    this.map = map;

    // On récupère la taille de notre map
    float w = (float)Map3D.width;
    float h = (float)Map3D.height;
    float widthRatio = tileSize*uvmap.width/(int)w;
    float heightRatio = tileSize*uvmap.height/(int)h;
    // Forme de l'ombre
    this.shadow = createShape();
    this.shadow.beginShape(QUADS);
    this.shadow.fill(0x992F2F2F);
    this.shadow.noStroke();
    // On construit simplement une ombre au sol
    // de la taille de notre terrain
    this.shadow.vertex(- w/2, - h/2, -10.0f);
    this.shadow.vertex(- w/2, h/2, -10.0f);
    this.shadow.vertex(w/2, h/2, -10.0f);
    this.shadow.vertex(w/2, - h/2, -10.0f);
    this.shadow.endShape();

    this.satellite = createShape();
    this.satellite.beginShape(QUADS);
    this.satellite.texture(uvmap);
    this.satellite.noFill();
    this.satellite.noStroke();
    this.satellite.emissive(0xD0);

    this.wireFrame = createShape();
    this.wireFrame.beginShape(QUADS);
    this.wireFrame.noFill();
    this.wireFrame.stroke(#888888);
    this.wireFrame.strokeWeight(0.5f);

    // U permet d'attribuer des coordonnées pour la texture
    int u = 0;
    for (int i = (int)(-w/(2*tileSize)); i < w/(2*tileSize); i++){
      // V permet d'attribuer des coordonnées pour la texture
      int v = 0;
      for (int j = (int)(-h/(2*tileSize)); j < h/(2*tileSize); j++){
        // On récupère nos quatre points
        Map3D.ObjectPoint bottomLeft = this.map.new ObjectPoint(i*tileSize, j*tileSize);
        Map3D.ObjectPoint topLeft = this.map.new ObjectPoint((i+1)*tileSize, j*tileSize);
        Map3D.ObjectPoint topRight = this.map.new ObjectPoint((i+1)*tileSize, (j+1)*tileSize);
        Map3D.ObjectPoint bottomRight = this.map.new ObjectPoint(i*tileSize, (j+1)*tileSize);
        // On calcule leurs normales
        PVector normalBottomLeft = bottomLeft.toNormal();
        PVector normalTopLeft = topLeft.toNormal();
        PVector ntr = topRight.toNormal();
        PVector normalBottomRight = bottomRight.toNormal();
        // On trace l'affiché en file de fer simplement en traçant un rectangle
        this.wireFrame.vertex(bottomLeft.x, bottomLeft.y, bottomLeft.z);
        this.wireFrame.vertex(topLeft.x, topLeft.y, topLeft.z);
        this.wireFrame.vertex(topRight.x, topRight.y, topRight.z);
        this.wireFrame.vertex(bottomRight.x, bottomRight.y, bottomRight.z);
        // Idem pour la vision satellite, à quelques détails près...
        // ... on fixe les normales pour la lumière
        this.satellite.normal(normalBottomLeft.x, normalBottomLeft.y, normalBottomLeft.z);
        // ... on ajoute un attribut "heat" pour afficher les cartes de chaleur
        this.satellite.attrib("heat", 0.0f, 0.0f, 0.0f);
        this.satellite.vertex(bottomLeft.x, bottomLeft.y, bottomLeft.z, u, v);
        this.satellite.normal(normalTopLeft.x, normalTopLeft.y, normalTopLeft.z);
        this.satellite.attrib("heat", 0.0f, 0.0f, 0.0f);
        this.satellite.vertex(topLeft.x, topLeft.y, topLeft.z, u+widthRatio, v);
        this.satellite.normal(ntr.x, ntr.y, ntr.z);
        this.satellite.attrib("heat", 0.0f, 0.0f, 0.0f);
        this.satellite.vertex(topRight.x, topRight.y, topRight.z, u+widthRatio, v+heightRatio);
        this.satellite.normal(normalBottomRight.x, normalBottomRight.y, normalBottomRight.z);
        this.satellite.attrib("heat", 0.0f, 0.0f, 0.0f);
        this.satellite.vertex(bottomRight.x, bottomRight.y, bottomRight.z, u, v+heightRatio);

        // utilise uvmap.height permet de ne pas dépendre de la taille
        // du fichier contenant l'image !
        v += heightRatio;
      }
      // utilise uvmap.width permet de ne pas dépendre de la taille
      // du fichier contenant l'image !
      u += widthRatio;
    }
    this.satellite.endShape();
    this.wireFrame.endShape();


    // Visibilité initiale des formes
    this.shadow.setVisible(true);
    this.wireFrame.setVisible(false);
    this.satellite.setVisible(true);
  }

  /**
  * Procédure d'affichage des formes
  */
  void update(){
    shape(this.shadow);
    shape(this.wireFrame);
    shape(this.satellite);
  }

  /**
  * Procédure pour rendre visible le terrain,
  * On alterne entre affichage satellite et affichage fil de fer
  */
  void toggle(){
    this.shadow.setVisible(!this.shadow.isVisible());
    this.wireFrame.setVisible(!this.wireFrame.isVisible());
    this.satellite.setVisible(!this.satellite.isVisible());
  }
}
