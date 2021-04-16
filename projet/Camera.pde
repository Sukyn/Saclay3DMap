
class Camera {
  float longitude;
  float colatitude;
  float radius;
  float x;
  float y;
  float z;
  float pos_x;
  float pos_y;
  boolean lightning;

  public Camera(float longitude, float colatitude, float radius){
    this.longitude = longitude;
    this.colatitude = colatitude;
    this.radius = radius;
    this.x = radius*sin(colatitude)*cos(longitude);
    this.y = radius*sin(colatitude)*sin(longitude);
    this.z = radius*cos(colatitude);
    this.pos_x = 0;
    this.pos_y = 0;
    this.lightning = false;
  }

  public void update(){
    camera(
      this.x, -this.y, this.z,
      pos_x, pos_y, 0,
      0, 0, -1
      );
    // Sunny vertical lightning


    if (lightning) {
      resetShader();
      ambientLight(0x7F, 0x7F, 0x7F);
      directionalLight(0xA0, 0xA0, 0xA0, 0, 0, -1);
    }

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

  public void x_move(float delta){
    this.pos_x += delta;
  }
  public void y_move(float delta){
    this.pos_y += delta;
  }
}
