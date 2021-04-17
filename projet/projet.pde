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

PShader programmeShader; // Shader pour afficher les Poi

boolean picnic; // Booléen sur l'affichage des table de picnic dans le shader
boolean bicycle; // Booléen sur l'affichage des stations velo dans le shader

void setup() {
  // Load Height Map
  this.map = new Map3D("paris_saclay.data");

  this.land = new Land(this.map,"paris_saclay_4k.jpg");
  // Display setup
  fullScreen(P3D);
  // Setup Head Up Display

  programmeShader = loadShader("myFrag.glsl", "myVert.glsl");
  this.hud = new Hud();

  smooth(4);
  frameRate(60);
  // Initial drawing
  background(0x40);
  // Prepare local coordinate system grid & gizmo
  this.workspace = new WorkSpace(250*100);

  // 3D camera (X+ right / Z+ top / Y+ Front)
  this.camera = new Camera(-PI/2, 1.19, 2690);
  this.camera.update();

  //Make camera move easier
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

  this.picnic = true;
  this.bicycle = true;

}

void draw(){
  background(0x40);
  this.workspace.update();
  this.camera.update();

   // On envoie nos booléens au shader pour pouvoir les afficher ou non
  programmeShader.set("picnic", this.picnic);
  programmeShader.set("bicycle", this.bicycle);
  shader(programmeShader);
  this.land.update();
  resetShader();

  this.buildings.update();
  this.gpx.update();
  this.railways.update();
  this.roads.update();
  this.hud.update(this.camera);
}

void keyPressed() {
  if (key == CODED){
    switch(keyCode){
      case UP:
        this.camera.adjustColatitude(-PI/100);
        break;
      case DOWN:
        this.camera.adjustColatitude(PI/100);
        break;
      case LEFT:
        this.camera.adjustLongitude(-PI/100);
        break;
      case RIGHT:
        this.camera.adjustLongitude(PI/100);
        break;
    }
  } else {
    switch (key) {
      case 'w':
      case 'W':

        // Hide/Show grid & Gizmo
        this.workspace.toggle();
        break;

      case 'f':
      case 'F':
        // Hide/Show picnic table
        this.picnic = !(this.picnic);
        break;
      case 'v':
      case 'V':
        // Hide/Show bicycle station
        this.bicycle = !(this.bicycle);
        break;
      case 'l':
      case 'L':
        // Hide/Show Land
        this.land.toggle();
        break;
      case 'r':
      case 'R':
        // Hide/Show roads and railways
        this.railways.toggle();
        this.roads.toggle();
        break;
      case '+':
      case 'p':
      case 'P':
        // Zoom in
        this.camera.adjustRadius(-10);
        break;
      case 'g':
      case 'G':
        // Hide/Show gpx
        this.gpx.toggle();
        break;
      case '-':
      case 'm':
      case 'M':
        // Zoom out
        this.camera.adjustRadius(10);
        break;
      case 'c':
      case 'C':
        // Hide/Show lights
        this.camera.toggle();
        break;
      case 'b':
      case 'B':
        // Hide/Show buildings
        this.buildings.toggle();
        break;
      case 'z':
      case 'Z':
        // Look to the top
        this.camera.y_move(-20);
        break;
      case 'q':
      case 'Q':
        // Look to the left
        this.camera.x_move(-20);
        break;
      case 's':
      case 'S':
        // Look to the bottom
        this.camera.y_move(20);
        break;
      case 'd':
      case 'D':
        // Look to the right
        this.camera.x_move(20);
        break;
      }
    }

}

void mouseWheel(MouseEvent event) {
  float ec = event.getCount();
  this.camera.adjustRadius(ec);
}

void mouseDragged() {
  if (mouseButton== CENTER){
    // Camera Horizontal
    float dx = mouseX - pmouseX;
    this.camera.adjustLongitude(dx*0.002);
    // Camera Vertical
    float dy = mouseY - pmouseY;
    this.camera.adjustColatitude(dy*0.002);
  }
}

void mousePressed() {
  if (mouseButton == LEFT)
    // Selection du gpx selectionné
    this.gpx.clic(mouseX, mouseY);
}
