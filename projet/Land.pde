/**
* Returns a Land object.
* Prepares land shadow, wireframe and textured shape
* @param map  Land associated elevation Map3D object
* @return     Land object
*/

class Land {
  Map3D map;
  PShape shadow;
  PShape wireFrame;
  PShape satellite;

  Land(Map3D map, String fileName) {

    File ressource = dataFile(fileName);
    if (!ressource.exists() || ressource.isDirectory()) {
      println("ERROR: Land texture file " + fileName + " not found.");
      exitActual();
    }
    PImage uvmap = loadImage(fileName);


    final float tileSize = 25f;
    this.map = map;

    float w = (float)Map3D.width;
    float h = (float)Map3D.height;

    // Shadow shape
    this.shadow = createShape();
    this.shadow.beginShape(QUADS);
    this.shadow.fill(0x992F2F2F);
    this.shadow.noStroke();
    this.shadow.vertex(- w/2, - h/2, -10.0f);
    this.shadow.vertex(- w/2, h/2, -10.0f);
    this.shadow.vertex(w/2, h/2, -10.0f);
    this.shadow.vertex(w/2, - h/2, -10.0f);
    this.shadow.endShape();

    this.satellite = createShape();
    this.satellite.beginShape(QUADS);
    this.satellite.texture(uvmap);
    this.satellite.noFill();
    this.satellite.noStroke();
    this.satellite.emissive(0xD0);
    int u = 0;
    for (int i = (int)(-w/(2*tileSize)); i < w/(2*tileSize); i++){
      int v = 0;
      for (int j = (int)(-h/(2*tileSize)); j < h/(2*tileSize); j++){
        Map3D.ObjectPoint bl = this.map.new ObjectPoint(i*tileSize, j*tileSize);
        Map3D.ObjectPoint tl = this.map.new ObjectPoint((i+1)*tileSize, j*tileSize);
        Map3D.ObjectPoint tr = this.map.new ObjectPoint((i+1)*tileSize, (j+1)*tileSize);
        Map3D.ObjectPoint br = this.map.new ObjectPoint(i*tileSize, (j+1)*tileSize);
        PVector nbl = bl.toNormal();
        PVector ntl = tl.toNormal();
        PVector ntr = tr.toNormal();
        PVector nbr = br.toNormal();
        this.satellite.normal(nbl.x, nbl.y, nbl.z);
        this.satellite.attrib("heat", 0.0f, 0.0f);
        this.satellite.vertex(bl.x, bl.y, bl.z, u, v);
        this.satellite.normal(ntl.x, ntl.y, ntl.z);
        this.satellite.attrib("heat", 0.0f, 0.0f);
        this.satellite.vertex(tl.x, tl.y, tl.z, u+tileSize*uvmap.width/5000, v);
        this.satellite.normal(ntr.x, ntr.y, ntr.z);
        this.satellite.attrib("heat", 0.0f, 0.0f);
        this.satellite.vertex(tr.x, tr.y, tr.z, u+tileSize*uvmap.width/5000, v+tileSize*uvmap.height/3000);
        this.satellite.normal(nbr.x, nbr.y, nbr.z);
        this.satellite.attrib("heat", 0.0f, 0.0f);
        this.satellite.vertex(br.x, br.y, br.z, u, v+tileSize*uvmap.height/3000);


  //      v += tileSize*200/uvmap.width;
        v += tileSize*uvmap.height/3000;
      }
      u += tileSize*uvmap.width/5000;
  //    u += tileSize*80/uvmap.height;
    }
    this.satellite.endShape();

    // Wireframe shape
    this.wireFrame = createShape();
    this.wireFrame.beginShape(QUADS);
    this.wireFrame.noFill();
    this.wireFrame.stroke(#888888);
    this.wireFrame.strokeWeight(0.5f);

    for (int i = (int)(-w/(2*tileSize)); i < w/(2*tileSize); i++){

      for (int j = (int)(-h/(2*tileSize)); j < h/(2*tileSize); j++){
        Map3D.ObjectPoint bl = this.map.new ObjectPoint(i*tileSize, j*tileSize);
        Map3D.ObjectPoint tl = this.map.new ObjectPoint((i+1)*tileSize, j*tileSize);
        Map3D.ObjectPoint tr = this.map.new ObjectPoint((i+1)*tileSize, (j+1)*tileSize);
        Map3D.ObjectPoint br = this.map.new ObjectPoint(i*tileSize, (j+1)*tileSize);

        this.wireFrame.vertex(bl.x, bl.y, bl.z);
        this.wireFrame.vertex(tl.x, tl.y, tl.z);
        this.wireFrame.vertex(tr.x, tr.y, tr.z);
        this.wireFrame.vertex(br.x, br.y, br.z);

      }
    }
    this.wireFrame.endShape();


    // Shapes initial visibility
    this.shadow.setVisible(true);
    this.wireFrame.setVisible(false);
    this.satellite.setVisible(true);
  }

  void update(){
    shape(this.shadow);
    shape(this.wireFrame);
    shape(this.satellite);
  }

  void toggle(){
    this.shadow.setVisible(!this.shadow.isVisible());
    this.wireFrame.setVisible(!this.wireFrame.isVisible());
    this.satellite.setVisible(!this.satellite.isVisible());
  }
}
