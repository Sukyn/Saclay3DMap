
class Camera {
  float longitude;
  float colatitude;
  float radius;
  float x;
  float y;
  float z;
  boolean lightning;

  public Camera(float longitude, float colatitude, float radius){
    this.longitude = longitude;
    this.colatitude = colatitude;
    this.radius = radius;
    this.x = radius*sin(colatitude)*cos(longitude);
    this.y = radius*sin(colatitude)*sin(longitude);
    this.z = radius*cos(colatitude);
    this.lightning = false;
  }

  public void update(){
    camera(
      this.x, -this.y, this.z,
      0, 0, 0,
      0, 0, -1
      );
    // Sunny vertical lightning
    ambientLight(0x7F, 0x7F, 0x7F);
    if (lightning)
      directionalLight(0xA0, 0xA0, 0xA0, 0, 0, -1);
    lightFalloff(0.0f, 0.0f, 1.0f);
    lightSpecular(0.0f, 0.0f, 0.0f);
  }

  public void adjustRadius(float offset){
    if (this.radius+offset < width*3.0 && this.radius+offset > width*0.5){
      this.radius += offset;
      this.x = radius*sin(colatitude)*cos(longitude);
      this.y = radius*sin(colatitude)*sin(longitude);
      this.z = radius*cos(colatitude);
    }
  }
  public void adjustLongitude(float delta){
    if (this.longitude+delta > -3*PI/2 && this.longitude+delta < PI/2){
      this.longitude += delta;
      this.x = radius*sin(colatitude)*cos(longitude);
      this.y = radius*sin(colatitude)*sin(longitude);
    }
  }
  public void adjustColatitude(float delta){
    if (this.colatitude+delta > 0.000001 && this.colatitude+delta < PI/2){
      this.colatitude += delta;
      this.x = radius*sin(colatitude)*cos(longitude);
      this.y = radius*sin(colatitude)*sin(longitude);
      this.z = radius*cos(colatitude);
    }
  }

  public void toggle(){
    this.lightning = !this.lightning;
  }
}
