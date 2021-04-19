

class WorkSpace {
  PShape gizmo;
  PShape grid;
  public WorkSpace(int size){
    // Gizmo
    this.gizmo = createShape();
    this.gizmo.beginShape(LINES);
    this.gizmo.noFill();

    // Rouge X
    this.gizmo.stroke(0xAAFF3F7F);
    this.gizmo.strokeWeight(1.0f);
    this.gizmo.vertex(-size/2, 0, 0);
    this.gizmo.vertex(size/2, 0, 0);
    this.gizmo.strokeWeight(3.0f);
    this.gizmo.vertex(0, 0, 0);
    this.gizmo.vertex(size/100, 0, 0);
    // Vert Y
    this.gizmo.stroke(0xAA3FFF7F);
    this.gizmo.strokeWeight(1.0f);
    this.gizmo.vertex(0, -size/2, 0);
    this.gizmo.vertex(0, size/2, 0);
    this.gizmo.strokeWeight(3.0f);
    this.gizmo.vertex(0, 0, 0);
    this.gizmo.vertex(0,size/100,  0);
    // Bleu Z
    this.gizmo.stroke(0xAA3F7FFF);
    this.gizmo.strokeWeight(1.0f);
    this.gizmo.vertex(0,  0,-size/2);
    this.gizmo.vertex(0,  0,size/2);
    this.gizmo.strokeWeight(3.0f);
    this.gizmo.vertex( 0,0, 0);
    this.gizmo.vertex( 0, 0,size/100);

    this.gizmo.endShape();

    // Dessin de la grille
    this.grid = createShape();
    this.grid.beginShape(LINES);
    this.grid.noFill();
    this.grid.strokeWeight(0.5f);
    this.grid.stroke(0, 0, 0);
    for (int i = -50; i < 50; i++){
      this.grid.vertex(i*size/100, -size/2, -0.02);
      this.grid.vertex(i*size/100, size/2, -0.02);
      this.grid.vertex(-size/2, i*size/100,  -0.02);
      this.grid.vertex(size/2, i*size/100, -0.02);
    }
    this.grid.endShape();
  }

  /**
  * Mise à jour du Gizmo
  */
  public void update(){
    shape(this.grid);
    shape(this.gizmo);
  }

  /**
  * Active/désactive la visibilité de la grille et du Gizmo.
  */
  public void toggle() {
     this.gizmo.setVisible(!this.gizmo.isVisible());
     this.grid.setVisible(!this.grid.isVisible());
  }
}
