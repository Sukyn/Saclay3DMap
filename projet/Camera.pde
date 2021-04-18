
class Camera {

  // Coordonnées sphériques
  float longitude;
  float colatitude;
  float radius;
  // Coordonnées cartésiennes
  float x;
  float y;
  float z;
  // Coordonnées de déplacement de la caméra
  float posX;
  float posY;
  // Variable indiquant si on affiche la lumière ou non
  boolean lightning;

  /**
  * Constructeur de la classe
  * @params longitude  : angle entre les vecteurs x et le vecteur du
  *                      projeté orthogonal du point
  * @params colatitude : angle entre les vecteurs z et le vecteur du point
  * @params radius     : distance du point au centre
  */
  public Camera(float longitude, float colatitude, float radius){
    this.longitude = longitude;
    this.colatitude = colatitude;
    this.radius = radius;
    /**
    * Formules de transformation en coordonnées cartésiennes
    * @see https://fr.wikipedia.org/wiki/Coordonn%C3%A9es_sph%C3%A9riques
    */
    this.x = radius*sin(colatitude)*cos(longitude);
    this.y = radius*sin(colatitude)*sin(longitude);
    this.z = radius*cos(colatitude);

    // Variables modifiées par l'utilisateur
    this.posX = 0;
    this.posY = 0;
    this.lightning = false;
  }

  /**
  * Procédure d'affichage de la caméra
  */
  public void update(){
    /**
    * On positionne la caméra selon les coordonnées cartésiennes de notre classe
    * et on positionne le regard selon pos_x et pos_y
    */
    camera(
      this.x, -this.y, this.z,
      posX, posY, 0,
      0, 0, -1
      );

    if (lightning) {
      // LUMIERE MAESTRO !
      // Sunny vertical lightning
      ambientLight(0x7F, 0x7F, 0x7F);
      directionalLight(0xA0, 0xA0, 0xA0, 0, 0, -1);
      lightFalloff(0.0f, 0.0f, 1.0f);
      lightSpecular(0.0f, 0.0f, 0.0f);
    }
  }

  /**
  * Gestion du zoom de la caméra
  * @params offset : La modification du rayon
  */
  public void adjustRadius(float offset){
    // On définit des bornes de zoom max et mini
    // Il n'est donc pas possible de mettre le nez trop près du gâteau
    if (this.radius+offset < width*3.0 && this.radius+offset > width*0.5){
      this.radius += offset;
      // On recalcule les coordonnées cartésiennes selon le nouveau rayon
      this.x = radius*sin(colatitude)*cos(longitude);
      this.y = radius*sin(colatitude)*sin(longitude);
      this.z = radius*cos(colatitude);
    }
  }
  /**
  * Gestion du zoom de la longitude
  * @params offset : La modification de la longitude
  */
  public void adjustLongitude(float delta){
    // Il n'est pas non plus de faire le tour du monde à l'infini
    if (this.longitude+delta > -3*PI/2 && this.longitude+delta < PI/2){
      this.longitude += delta;
      this.x = radius*sin(colatitude)*cos(longitude);
      this.y = radius*sin(colatitude)*sin(longitude);
      // Note : on ne recalcule pas z parce que c'est inutile
    }
  }
  /**
  * Gestion du zoom de la colatitude
  * @params offset : La modification de la colatitude
  */
  public void adjustColatitude(float delta){
    // Ni de passer sous le sol
    if (this.colatitude+delta > 0.000001 && this.colatitude+delta < PI/2){
      this.colatitude += delta;
      this.x = radius*sin(colatitude)*cos(longitude);
      this.y = radius*sin(colatitude)*sin(longitude);
      this.z = radius*cos(colatitude);
    }
  }

  /**
  * Procédure pour rendre visible les lumières
  */
  public void toggle(){
    this.lightning = !this.lightning;
  }

  /**
  * Gestion de l'orientation de la vision horizontale
  */
  public void xMove(float delta){
    this.posX += delta;
  }
  /**
  * Gestion de l'orientation de la vision verticale
  */
  public void yMove(float delta){
    this.posY += delta;
  }
}
