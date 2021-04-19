import java.util.*;

class Hud {
  private PMatrix3D hud;
  Hud() {
     // Doit être construit juste après le P3D
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
    // Zone en bas à droite
    noStroke();
    fill(96);
    rectMode(CORNER);
    rect(10, height-30, 60, 20, 5, 5, 5, 5);
    // Valeur
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
    // Zone en haut à gauche
    noStroke();
    fill(96);
    rectMode(CORNER);
    rect(20, 10, 200, 130, 5, 5, 5, 5);
    // Valeur
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

    List<String> commandes = Arrays.asList(
      "Déplacement : Flèches, ZQSD",
      "Zoom avant : P",
      "Zoom arrière : M",
      "Buildings : B",
      "Routes : R",
      "Shader vélo : V",
      "Shader picnic : F",
      "Shader restaurant : X",
      "Texture du sol : L",
      "Lumière : C",
      "Tracé GPX : G",
      "Sensibilité : O, I",
      "Gizmo & Grille : Y"
      );
    // Zone en haut à droite
    noStroke();
    fill(96);
    rectMode(CORNER);
    int offset = 25;
    int position = 60;
    rect(width-320, 10, 310, position+offset*commandes.size(), 5, 5, 5, 5);
    // Valeur
    fill(0xF0);
    textMode(SHAPE);
    textSize(20);
    textAlign(CENTER, CENTER);
    text("Commandes", width-160, 20);

    for (int i = 0; i < commandes.size(); i++){
      text(commandes.get(i), width-160, position);
      position += offset;
    }
  }

  public void displaySensibility(int sensibility) {
    // Top left area
    noStroke();
    fill(96);
    rectMode(CORNER);
    rect(width-170, height-60, 150, 40, 5, 5, 5, 5);
    // Value
    fill(0xF0);
    textMode(SHAPE);
    textSize(14);
    textAlign(CENTER, CENTER);
    text("Sensibilité :  "+ String.valueOf(sensibility),width-90, height-40);
  }
  /**
  * Procédure d'affichage du HUD
  */
  public void update(Camera camera, int sensibility) {
    this.begin();
    this.displayFPS();
    this.displayCamera(camera);
    this.displayHelp();
    this.displaySensibility(sensibility);
    this.end();
  }
}
