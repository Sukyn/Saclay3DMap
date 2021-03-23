

class WorkSpace() {
  PShape gizmo;
  public WorkSpace(PShape gizmo){
    // Gizmo
    this.gizmo = createShape();
    this.gizmo.beginShape(LINES);
    this.gizmo.noFill();
    this.gizmo.strokeWeight(3.0f);
    // Red X
    this.gizmo.stroke(0xAAFF3F7F);
    this.gizmo.vertex(0, 0, 0);
    this.gizmo.vertex(300, 0, 0);
    // Green Y
    this.gizmo.stroke(0xAA3FFF7F);
    this.gizmo.vertex(0, 0, 0);
    this.gizmo.vertex(0, 300, 0);
    // Blue Z
    this.gizmo.stroke(0xAA3F7FFF);
    this.gizmo.vertex(0, 0, 0);
    this.gizmo.vertex(0, 0, 300);
    this.gizmo.endShape();
  }

  public void update(){
    // Réalise l'affichage du gizmo
  }

  /**
  * Toggle Grid & Gizmo visibility.
  */
  public void toggle() {
     this.gizmo.setVisible(!this.gizmo.isVisible());
  } 
}
