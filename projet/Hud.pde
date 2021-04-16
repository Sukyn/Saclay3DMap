class Hud {
  private PMatrix3D hud;
  Hud() {
     // Should be constructed just after P3D size() or fullScreen()
     this.hud = g.getMatrix((PMatrix3D) null);
  }

  private void begin() {
    g.noLights();
    g.pushMatrix();
    g.hint(PConstants.DISABLE_DEPTH_TEST);
    g.resetMatrix();
    g.applyMatrix(this.hud);
  }

  private void end() {
    g.hint(PConstants.ENABLE_DEPTH_TEST);
    g.popMatrix();
  }

  private void displayFPS() {
    // Bottom left area
    noStroke();
    fill(96);
    rectMode(CORNER);
    rect(10, height-30, 60, 20, 5, 5, 5, 5);
    // Value
    fill(0xF0);
    textMode(SHAPE);
    textSize(14);
    textAlign(CENTER, CENTER);
    text(String.valueOf((int)frameRate) + " fps", 40, height-20);
  }
  public void displayCamera(Camera camera){
    // Top left area
    noStroke();
    fill(96);
    rectMode(CORNER);
    rect(20, 10, 200, 130, 5, 5, 5, 5);
    // Value
    fill(0xF0);
    textMode(SHAPE);
    textSize(14);
    textAlign(CENTER, CENTER);
    text("Camera", 120, 20);
    text(" Longitude   "+ String.valueOf((int)(camera.longitude*180/PI) + " °"),80, 50);
    text(" Colatitude   "+ String.valueOf((int)(camera.colatitude*180/PI) + " °"),80, 80);
    text(" Radius   "+ String.valueOf((int)camera.radius) + " m",80, 110);
  }
  public void displayHelp(){
    noStroke();
    fill(96);
    rectMode(CORNER);
    rect(width-200, 10, 180, 285, 5, 5, 5, 5);
    // Value
    fill(0xF0);
    textMode(SHAPE);
    textSize(20);
    textAlign(CENTER, CENTER);
    text("Commandes", width-110, 20);
    textSize(17);
    text("Camera", width-110, 50);
    textSize(14);
    text("Déplacement : Flèches", width-110, 70);
    text("Zoom avant : P", width-110, 90);
    text("Zoom arrière : M", width-110, 110);
    textSize(17);
    text("Buildings : B", width-110, 150);
    text("Routes : R", width-110, 175);
    text("Shader : S", width-110, 200);
    text("Texture du sol : L", width-110, 225);
    text("Lumière : C", width-110, 250);
    text("Tracé GPX : G", width-110, 275);
  }

  public void update(Camera camera) {
    this.begin();
    this.displayFPS();
    this.displayCamera(camera);
    this.displayHelp();
    this.end();
  }
}
