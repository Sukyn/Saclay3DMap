WorkSpace workspace;
Hud hud;
Camera camera;

WorkSpace workspace;
Hud hud;

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
  this.camera = new Camera(PI/2, 1.19, 2690);
  this.camera.update();

  //Make camera move easier
  hint(ENABLE_KEY_REPEAT);
}

void draw(){
  this.workspace.update();
<<<<<<< HEAD
  this.hud.begin();
  this.hud.displayFPS();
=======
  this.camera.update();
  this.hud.begin();
  this.hud.displayFPS();
  this.hud.displayCamera(this.camera);
>>>>>>> 088f6b96313505b0147b6c26d471356ba0d18773
  this.hud.end();
}

void keyPressed() {
<<<<<<< HEAD
  switch (key) {
    case 'w':
    case 'W':
      // Hide/Show grid & Gizmo
      this.workspace.toggle();
      break;
=======
  if (key == CODED){
    switch(keyCode){
      case UP:
        this.camera.adjustColatitude(1000);
        break;
      case DOWN:
        this.camera.adjustColatitude(-1000);
        break;
      case LEFT:
        this.camera.adjustLongitude(1000);
        break;
      case RIGHT:
        this.camera.adjustLongitude(-1000);
        break;
    }
  } else {
    switch (key) {
      case 'w':
      case 'W':
        // Hide/Show grid & Gizmo
        this.workspace.toggle();
        break;
      case '+':
        this.camera.adjustRadius(-1000);
        break;
      case '-':
        this.camera.adjustRadius(1000);
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
    this.camera.adjustLongitude(dx);
    // Camera Vertical
    float dy = mouseY - pmouseY;
    this.camera.adjustColatitude(dy);
>>>>>>> 088f6b96313505b0147b6c26d471356ba0d18773
  }
}
