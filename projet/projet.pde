WorkSpace workspace;
Hud hud;
Camera camera;
Map3D map;
Land land;
Gpx gpx;
Railways railways;
Roads roads;

void setup() {
  // Display setup
  fullScreen(P3D);
  // Setup Head Up Display
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

  // Load Height Map
  this.map = new Map3D("paris_saclay.data");
  this.land = new Land(this.map,"paris_saclay.jpg");
  this.gpx = new Gpx(this.map, "trail.geojson");
  this.railways = new Railways(this.map, "railways.geojson");
  this.roads = new Roads(this.map, "roads.geojson");
}

void draw(){
  background(0x40);
  this.workspace.update();
  this.camera.update();
  this.land.update();
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
      case '-':
      case 'm':
      case 'M':
        this.camera.adjustRadius(10);
        break;
      case 'c':
      case 'C':
        this.camera.toggle();
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
    this.camera.adjustLongitude(dx);
    // Camera Vertical
    float dy = mouseY - pmouseY;
    this.camera.adjustColatitude(dy);
  }
}

void mousePressed() {
  if (mouseButton == LEFT)
    this.gpx.clic(mouseX, mouseY);
}
