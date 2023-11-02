// déclaration des objets
Camera camera;
PShape  podiumShape, goatShape, groundShape;
PImage textureGoat, textureSnow;
PVector vecteur;
float goatRotationY = 0; // pour tourner la chèvre sur axe y
boolean discoMode = false; // Variable pour le mode disco
float spotRotation  = 0; // Angle pour faire tourner les spots autour de l'axe y

void setup() {
  size(700, 600, P3D);
  smooth(3);
  camera = new Camera(this);
  vecteur = new PVector(0, -3, 10);
  camera.setPosition(vecteur);

  // Chargement des modèles 3D
  goatShape = loadShape("goat.obj");
  podiumShape = loadShape("podium.obj");
  groundShape = loadShape("ground.obj");

  // Chargez les textures
  textureGoat = loadImage("goat_texture.png");
  textureSnow = loadImage("snow_texture.png");
  // Application des textures aux objets

  goatShape.setTexture(textureGoat);
  podiumShape.setTexture(textureSnow);
  groundShape.setTexture(textureSnow);

  // Modification de l'échelle et de la position des objets
  groundShape.scale(30); // Homothétie de facteur 30 pour le sol
  goatShape.scale(2);
  goatShape.translate(0, 1.2, 0);
}

void spots(float rotation) {

  float angle = PI/3 + rotation; //Faire tourner les spots autour de la chèvre (autour de l'axe y)
  int rayon = 20;

  // les couleurs sont de type float mais j'ai mis type int car je n'aurais pas besion des nombres réels pour consommer l'espace mémoire :)
  int[][] couleurs = {
    {255, 0, 0}, // rouge
    {0, 255, 0}, // vert
    {0, 0, 255}, // blue
    {255, 255, 0}, // jaune
    {255, 0, 255}, // magenta
    {0, 255, 255}, // cyan
  };

  float x = 0, y = -20, z = 0;

  for (int i = 0; i < 6; i++) {
    x = rayon * cos(angle * i);
    z = rayon * sin(angle * i);

    // Calcul du vecteur de direction pour le spot ce vecteur est obtenu avec le calcule suivant:
    // composante du vecteur (coordonnées de direction - coordonnées de départ) / magnitude
    float nx = (0 - x)/rayon ;
    float ny = 1 ;
    float nz =  (0 - z)/rayon ;

    spotLight(couleurs[i][0], couleurs[i][1], couleurs[i][2],
      x, y, z,
      nx, ny, nz,
      PI / 4, 400);
  }
}

void draw() {
  background(0);
  if (discoMode)
  {
    spotRotation  += radians(10); // augmentation de l'angle de rotation à chaque itération du draw()
    spots(spotRotation );
  } else {
    ambientLight(50, 50, 50);
    directionalLight(255, 255, 255, -1, 1, -1);
  }

  // Afficher le sol

  shape(groundShape);

  // podium
  shape(podiumShape, 0, 0);

  //chèvre
  rotate(PI);
  rotateY(goatRotationY);
  goatRotationY+=0.05;
  shape(goatShape, 0, 0); // Affichez l'objet PShape à l'écran
}

void keyPressed() {
  if (key == 'm' || key == 'M') {
    // Basculez le mode disco
    discoMode = !discoMode;
  }
}
