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
  * @params map : La carte avec laquelle on travaille
  * @params fileName : Le nom de notre fichier contenant l'image GPS
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
        Map3D.ObjectPoint bl = this.map.new ObjectPoint(i*tileSize, j*tileSize);
        Map3D.ObjectPoint tl = this.map.new ObjectPoint((i+1)*tileSize, j*tileSize);
        Map3D.ObjectPoint tr = this.map.new ObjectPoint((i+1)*tileSize, (j+1)*tileSize);
        Map3D.ObjectPoint br = this.map.new ObjectPoint(i*tileSize, (j+1)*tileSize);
        // On calcule leurs normales
        PVector nbl = bl.toNormal();
        PVector ntl = tl.toNormal();
        PVector ntr = tr.toNormal();
        PVector nbr = br.toNormal();
        // On trace l'affiché en file de fer simplement en traçant un rectangle
        this.wireFrame.vertex(bl.x, bl.y, bl.z);
        this.wireFrame.vertex(tl.x, tl.y, tl.z);
        this.wireFrame.vertex(tr.x, tr.y, tr.z);
        this.wireFrame.vertex(br.x, br.y, br.z);
        // Idem pour la vision satellite, à quelques détails près...
        // ... on fixe les normales pour la lumière
        this.satellite.normal(nbl.x, nbl.y, nbl.z);
        // ... on ajoute un attribut "heat" pour afficher les cartes de chaleur
        this.satellite.attrib("heat", 0.0f, 0.0f, 0.0f);
        this.satellite.vertex(bl.x, bl.y, bl.z, u, v);
        this.satellite.normal(ntl.x, ntl.y, ntl.z);
        this.satellite.attrib("heat", 0.0f, 0.0f, 0.0f);
        this.satellite.vertex(tl.x, tl.y, tl.z, u+tileSize*uvmap.width/5000, v);
        this.satellite.normal(ntr.x, ntr.y, ntr.z);
        this.satellite.attrib("heat", 0.0f, 0.0f, 0.0f);
        this.satellite.vertex(tr.x, tr.y, tr.z, u+tileSize*uvmap.width/5000, v+tileSize*uvmap.height/3000);
        this.satellite.normal(nbr.x, nbr.y, nbr.z);
        this.satellite.attrib("heat", 0.0f, 0.0f, 0.0f);
        this.satellite.vertex(br.x, br.y, br.z, u, v+tileSize*uvmap.height/3000);

        // utilise uvmap.height permet de ne pas dépendre de la taille
        // du fichier contenant l'image !
        v += tileSize*uvmap.height/3000;
      }
      // utilise uvmap.width permet de ne pas dépendre de la taille
      // du fichier contenant l'image !
      u += tileSize*uvmap.width/5000;
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
