
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
  camera(
       0  , 2500, 1000,
       0, 0, 0,
       0, 0, -1   );
}

void draw(){
  this.workspace.update();
  this.hud.begin();
  this.hud.displayFPS();
  this.hud.end();
}

void keyPressed() {
  switch (key) {
    case 'w':
    case 'W':
      // Hide/Show grid & Gizmo
      this.workspace.toggle();
      break;
  }
}
