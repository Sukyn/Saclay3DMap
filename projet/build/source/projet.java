import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class projet extends PApplet {


WorkSpace workspace;
Hud hud;

public void setup() {
  // Display setup
  
  // Setup Head Up Display
  this.hud = new Hud();
  
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

public void draw(){
  this.workspace.update();
  this.hud.begin();
  this.hud.displayFPS();
  this.hud.end();
}

public void keyPressed() {
  switch (key) {
    case 'w':
    case 'W':
      // Hide/Show grid & Gizmo
      this.workspace.toggle();
      break;
  }
}
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
  /*
  public void displayCamera(Camera  camera){

  }*/
}


class WorkSpace {
  PShape gizmo;
  PShape grid;
  public WorkSpace(int size){
    // Gizmo
    this.gizmo = createShape();
    this.gizmo.beginShape(LINES);
    this.gizmo.noFill();

    // Red X
    this.gizmo.stroke(0xAAFF3F7F);
    this.gizmo.strokeWeight(1.0f);
    this.gizmo.vertex(-size/2, 0, 0);
    this.gizmo.vertex(size/2, 0, 0);
    this.gizmo.strokeWeight(3.0f);
    this.gizmo.vertex(0, 0, 0);
    this.gizmo.vertex(size/100, 0, 0);
    // Green Y
    this.gizmo.stroke(0xAA3FFF7F);
    this.gizmo.strokeWeight(1.0f);
    this.gizmo.vertex(0,-size/2,  0);
    this.gizmo.vertex(0,size/2,  0);
    this.gizmo.strokeWeight(3.0f);
    this.gizmo.vertex(0,0,  0);
    this.gizmo.vertex(0,size/100,  0);
    // Blue Z
    this.gizmo.stroke(0xAA3F7FFF);
    this.gizmo.strokeWeight(1.0f);
    this.gizmo.vertex(0,  0,-size/2);
    this.gizmo.vertex(0,  0,size/2);
    this.gizmo.strokeWeight(3.0f);
    this.gizmo.vertex( 0,0, 0);
    this.gizmo.vertex( 0, 0,size/100);

    this.gizmo.endShape();




    // Grid drawing
    this.grid = createShape();
    this.grid.beginShape(LINES);
    this.grid.noFill();
    this.grid.strokeWeight(0.5f);
    this.grid.stroke(0, 0, 0);
    for (int i = -50; i < 50; i++){
      this.grid.vertex(i*size/100, -size/2, 0);
      this.grid.vertex(i*size/100, size/2, 0);
      this.grid.vertex(-size/2, i*size/100,  0);
      this.grid.vertex(size/2, i*size/100, 0);
    }
    this.grid.endShape();
  }

  /**
  * Update Gizmo
  */
  public void update(){
    shape(this.grid);
    shape(this.gizmo);

  }

  /**
  * Toggle Grid & Gizmo visibility.
  */
  public void toggle() {
     this.gizmo.setVisible(!this.gizmo.isVisible());
     this.grid.setVisible(!this.grid.isVisible());
  }
}
  public void settings() {  fullScreen(P3D);  smooth(4); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "projet" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
