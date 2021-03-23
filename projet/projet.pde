
void setup() {
  size(1000, 1000, P3D);
  background(100,100,100);
  // 3D camera (X+ right / Z+ top / Y+ Front)
  camera(
       0  , 2500, 1000,
       0, 0, 0,
       0, 0, -1   );
}

void draw(){
  shape(this.gizmo);
}
