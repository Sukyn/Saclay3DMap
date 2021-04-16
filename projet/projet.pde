WorkSpace workspace;
Hud hud;
Camera camera;
Map3D map;
Land land;
Gpx gpx;
Railways railways;
Roads roads;
Buildings buildings;
Poi poi;
PShader programmeShader;
boolean shader;

void setup() {
  // Load Height Map
  this.map = new Map3D("paris_saclay.data");

  this.land = new Land(this.map,"paris_saclay.jpg");
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

  this.shader = true;

}

void draw(){
  background(0x40);
  this.workspace.update();
  this.camera.update();
  programmeShader.set("on_off", this.shader);
  shader(programmeShader);
  this.land.update();
  resetShader();
  this.gpx.update();
  this.railways.update();
  this.roads.update();
  this.buildings.update();
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

      case 's':
      case 'S':
        this.shader = !(this.shader);
        break;
      case 'l':
      case 'L':
        // Hide/Show Land
        this.land.toggle();
        break;
      case 'r':
      case 'R':
        this.railways.toggle();
        this.roads.toggle();
        break;
      case '+':
      case 'p':
      case 'P':
        this.camera.adjustRadius(-10);
        break;
      case 'g':
      case 'G':
        this.gpx.toggle();
        break;
      case '-':
      case 'm':
      case 'M':
        this.camera.adjustRadius(10);
        break;
      case 'c':
      case 'C':
        this.camera.toggle();
        break;
      case 'b':
      case 'B':
        this.buildings.toggle();
        break;
      case 'z':
      case 'Z':
        this.camera.y_move(-10);
        break;
      case 'q':
      case 'Q':
        this.camera.x_move(-10);
        break;
      case 'x':
      case 'X':
        this.camera.y_move(10);
        break;
      case 'd':
      case 'D':
        this.camera.x_move(10);
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
    this.gpx.clic(mouseX, mouseY);
}
