class Hud {
  private PMatrix3D hud;
  Hud() {
     // Should be constructed just after P3D size() or fullScreen()
     this.hud = g.getMatrix((PMatrix3D) null);
  }

  // On prépare le terrain pour la construction de l'HUD
  private void begin() {
    g.noLights();
    g.pushMatrix();
    // On le fait passer au dessus des autres formes
    g.hint(PConstants.DISABLE_DEPTH_TEST);
    g.resetMatrix();
    g.applyMatrix(this.hud);
  }

  // Et on nettoie derrière nous
  private void end() {
    g.hint(PConstants.ENABLE_DEPTH_TEST);
    g.popMatrix();
  }


  /**
  * Procédure d'affichage des FPS
  */
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

  /**
  * Procédure d'affichage des informations de la caméra
  */
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
    text("Longitude  "+ String.valueOf((int)(camera.longitude*180/PI) + " °"),100, 50);
    text("Colatitude   "+ String.valueOf((int)(camera.colatitude*180/PI) + " °"),100, 80);
    text("Radius   "+ String.valueOf((int)camera.radius) + " m",100, 110);
  }

  /**
  * Procédure d'affichage du menu des commandes
  */
  public void displayHelp(){
    // Top right area
    noStroke();
    fill(96);
    rectMode(CORNER);
    rect(width-220, 10, 200, 305, 5, 5, 5, 5);
    // Value
    fill(0xF0);
    textMode(SHAPE);
    textSize(20);
    textAlign(CENTER, CENTER);
    text("Commandes", width-120, 20);
    textSize(17);
    text("Camera", width-120, 50);
    textSize(14);
    text("Déplacement : Flèches, ZQSD", width-120, 70);
    text("Zoom avant : P", width-120, 90);
    text("Zoom arrière : M", width-120, 110);
    textSize(17);
    text("Buildings : B", width-120, 150);
    text("Routes : R", width-120, 175);
    text("Shader vélo : V", width-120, 200);
    text("Shader picnic : F", width-120, 225);
    text("Texture du sol : L", width-120, 250);
    text("Lumière : C", width-120, 275);
    text("Tracé GPX : G", width-120, 300);
  }


  /**
  * Procédure d'affichage du HUD
  */
  public void update(Camera camera) {
    this.begin();
    this.displayFPS();
    this.displayCamera(camera);
    this.displayHelp();
    this.end();
  }
}
