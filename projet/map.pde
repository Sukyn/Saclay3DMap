Map3D map;

void setup() {

  // Display setup
  size(800, 600, P2D);
  smooth(8);
  noLoop();

  // Load Height Map
  this.map = new Map3D("paris_saclay.data");

  // South West
  Map3D.MapPoint sw = this.map.new MapPoint(
    Map3D.xllCorner, 
    Map3D.yllCorner
    );
  println(
    "South West :", sw, 
    "\n=> ", this.map.new GeoPoint(sw), 
    "\n=> ", this.map.new ObjectPoint(sw)
    );

  // North East
  Map3D.MapPoint ne = this.map.new MapPoint(
    Map3D.xllCorner + Map3D.width, 
    Map3D.yllCorner + Map3D.height
    );
  println(
    "North East :", ne, 
    "\n=> ", this.map.new GeoPoint(ne), 
    "\n=> ", this.map.new ObjectPoint(ne)
    );

  float w = (float)Map3D.width;
  float h = (float)Map3D.height;

  // South West (direct)
  Map3D.ObjectPoint osw = this.map.new ObjectPoint(-w/2.0f, +h/2.0f);
  println("South West (direct) :", osw);

  // North East (direct)
  Map3D.ObjectPoint one = this.map.new ObjectPoint(+w/2.0f, -h/2.0f);
  println("North East (direct) :", one);
}

void draw() {
}
