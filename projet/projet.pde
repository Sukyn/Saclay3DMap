WorkSpace workspace; // Grille et espace de travail
Hud hud; // Informations utiles sur l'écran
Camera camera; // Gestion de la caméra
Map3D map; // Carte sur laquelle on travaille
Land land; // Terrain associé à la carte
Gpx gpx; // Tracé d'un chemin avec informations
Railways railways; // Tracé des voies ferrées
Roads roads; // Tracé des routes
Buildings buildings; // Tracé des bâtiments
Poi poi; // Tracé des points d'intérêts (carte de chaleur)
int sensibility; // Sensibilité des commandes de déplacement

PShader programmeShader; // Shader pour afficher les Poi

boolean hudVisible; // Booléen sur la visibilité du HUD

boolean picnic; // Booléen sur l'affichage des table de picnic dans le shader
boolean bicycle; // Booléen sur l'affichage des stations velo dans le shader
boolean restaurant; // Booléen sur l'affichage des restaurants dans le shader

void setup() {
  // Charge la carte des altitudes
  this.map = new Map3D("paris_saclay.data");

  // Prépare les coordonnées système locales pour la grille et le gizmo
  this.workspace = new WorkSpace(250*100);

  // Mise en place du terrain
  this.land = new Land(this.map,"paris_saclay_4k.jpg");

  // Mise en place de l'affichage
  fullScreen(P3D);
  smooth(4);
  frameRate(60);
  // Dessin initial
  background(0x40);

  programmeShader = loadShader("myFrag.glsl", "myVert.glsl");
  // Affichage Tête Haute
  this.hud = new Hud();

  // Caméra 3D  (X+ droite / Z+ haut / Y+ Frontal)
  this.camera = new Camera(-PI/2, 1.19, 2690);

  // Facilite les mouvements de caméra
  hint(ENABLE_KEY_REPEAT);

  this.poi = new Poi(this.land);
  this.poi.calculdistance();

  this.gpx = new Gpx(this.map, "trail.geojson");
  this.railways = new Railways(this.map, "railways.geojson");
  this.roads = new Roads(this.map, "roads.geojson");

  this.buildings = new Buildings(this.map);
  this.buildings.add("buildings_city.geojson", 0xFFaaaaaa);
  this.buildings.add("buildings_IPP.geojson", 0xFFCB9837);
  this.buildings.add("buildings_EDF_Danone.geojson", 0xFF3030FF);
  this.buildings.add("buildings_CEA_algorithmes.geojson", 0xFF30FF30);
  this.buildings.add("buildings_Thales.geojson", 0xFFFF3030);
  this.buildings.add("buildings_Paris_Saclay.geojson", 0xFFee00dd);

  this.picnic = false;
  this.bicycle = false;
  this.restaurant = false;
  this.sensibility = 10;
  this.hudVisible = true;

}

void draw(){
  background(0x40);
  this.workspace.update();
  this.camera.update();

   // On envoie nos booléens au shader pour pouvoir les afficher ou non
  programmeShader.set("picnic", this.picnic);
  programmeShader.set("bicycle", this.bicycle);
  programmeShader.set("restaurant", this.restaurant);
  shader(programmeShader);
  this.land.update();
  resetShader();

  this.buildings.update();
  this.gpx.update();
  this.railways.update();
  this.roads.update();
  if (this.hudVisible) {
    this.hud.update(this.camera, this.sensibility);
  }
}

void keyPressed() {
  if (key == CODED){
    switch(keyCode){
      case UP:
        this.camera.adjustColatitude(-PI*this.sensibility/1000);
        break;
      case DOWN:
        this.camera.adjustColatitude(PI*this.sensibility/1000);
        break;
      case LEFT:
        this.camera.adjustLongitude(-PI*this.sensibility/1000);
        break;
      case RIGHT:
        this.camera.adjustLongitude(PI*this.sensibility/1000);
        break;
    }
  } else {
    switch (key) {
      case 'w':
      case 'W':

        // Cache/Montre la grille et le Gizmo
        this.workspace.toggle();
        break;

      case 'f':
      case 'F':
        // Cache/Montre les tables de picnic
        this.picnic = !(this.picnic);
        break;
      case 'v':
      case 'V':
        // Cache/Montre les stations pour vélos
        this.bicycle = !(this.bicycle);
        break;
      case 'x':
      case 'X':
        // Cache/Montre les restaurants
        this.restaurant = !(this.restaurant);
        break;
      case 'l':
      case 'L':
        // Cache/Montre le terrain
        this.land.toggle();
        break;
      case 'r':
      case 'R':
        // Cache/Montre les routes et voies ferrées
        this.railways.toggle();
        this.roads.toggle();
        break;
      case '+':
      case 'p':
      case 'P':
        // Zoom avant
        this.camera.adjustRadius(-this.sensibility);
        break;
      case 'g':
      case 'G':
        // Cache/Montre le gpx
        this.gpx.toggle();
        break;
      case '-':
      case 'm':
      case 'M':
        // Zoom arrière
        this.camera.adjustRadius(this.sensibility);
        break;
      case 'c':
      case 'C':
        // Cache/Montre les lumières
        this.camera.toggle();
        break;
      case 'b':
      case 'B':
        // Cache/Montre les bâtiments
        this.buildings.toggle();
        break;
      case 'h':
      case 'H':
        // Cache/Montre les bâtiments
        this.hudVisible = !(this.hudVisible);
        break;

      case 'z':
      case 'Z':
        // Regarder vers le haut
        this.camera.yMove(-2*this.sensibility);
        break;
      case 'q':
      case 'Q':
        // Regarder vers la gauche
        this.camera.xMove(-2*this.sensibility);
        break;
      case 's':
      case 'S':
        // Regarder vers le bas
        this.camera.yMove(2*this.sensibility);
        break;
      case 'd':
      case 'D':
        // Regarder vers la droite
        this.camera.xMove(2*this.sensibility);
        break;
      case 'o':
      case 'O':
        // Augmentation de la sensibilité
        this.sensibility += 1;
        break;
      case 'i':
      case 'I':
        // Diminution de la sensibilité
        if (this.sensibility > 0)
        this.sensibility -= 1;
        break;
      case 'y':
      case 'Y':
        this.workspace.toggle();
      }
    }

}

void mouseWheel(MouseEvent event) {
  float ec = event.getCount();
  this.camera.adjustRadius(ec);
}

void mouseDragged() {
  if (mouseButton== CENTER){
    // Horizontale Camera
    float dx = mouseX - pmouseX;
    this.camera.adjustLongitude(dx*2*this.sensibility/10000);
    // Verticale Camera
    float dy = mouseY - pmouseY;
    this.camera.adjustColatitude(dy*2*this.sensibility/10000);
  }
}

void mousePressed() {
  if (mouseButton == LEFT)
    // Selection du gpx selectionné
    this.gpx.clic(mouseX, mouseY);
}
