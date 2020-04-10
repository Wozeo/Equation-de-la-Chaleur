
//Parametres Simulation
int frequenceRecord = 20;//Tout les frequenceRecord, une image s'enregistre (si record = true)
int NX = 200, NT = 1000;
float K = 0.1, L = 1, Time = 0.02;
float dx = L/(NX-1);
float dt = Time/(NT);
int dimSource = int(NX/20);
boolean pause = false;
boolean record = false;
float valeurSource = 1;
float sourceP = 0.5;

//Variables Simulation
float x[] = new float[NX];
float T[][] = new float[NX][NX];
float source [][][] = new float[NX][NX][3];
int temps = 0;

//Affichage
float contraste = 1;//Contraste
float cp = 1.1;//Variation de contraste
float ra = 240, ba = 20, va = 20, rd = 50, vd = 115, bd = 245;//couleurs

//Souris
int cd = 0;
int cdt = 2;

void setup() {
  for (int i = 0; i < NX; i += 1) {
    x[i] = i*dx;
  }
  for (int i = 0; i < NX; i += 1) {
    for (int j = 0; j < NX; j +=1) {
      T[i][j] = 0;
    }
  }
  size(700, 700);
  background(255);
}

void settings() {
  String[]settings = loadStrings("settings.txt");
  String[]l1 = settings[0].split(" ");
  size(int(l1[1]), int(l1[2]));
}


void draw() {
  
  //Fond Paramètre
  noStroke();
  fill(255);
  rect(width/2, 0, width/2, height);
  
  //Simulation
  if (pause == false) {
    float Ttemp[][] = new float[NX][NX];
    for (int i = 0; i < NX; i ++) {
      for (int j = 0; j < NX; j ++) {
        if (j == 0) {
          if (i == 0) {
            Ttemp[i][j] = T[i][j]+(K*dt/(dx*dx))*(T[i+1][j]-2*T[i][j]+T[i][j+1]);
          } else if (i  == NX -1) {
            Ttemp[i][j] = T[i][j]+(K*dt/(dx*dx))*(-2*T[i][j]+T[i-1][j]+T[i][j+1]);
          } else {
            Ttemp[i][j] = T[i][j]+(K*dt/(dx*dx))*(T[i+1][j]-3*T[i][j]+T[i-1][j]+T[i][j+1]);
          }
        } else if (j == NX-1) {
          if (i == 0) {
            Ttemp[i][j] = T[i][j]+(K*dt/(dx*dx))*(T[i+1][j]-2*T[i][j]+T[i][j-1]);
          } else if (i  == NX -1) {
            Ttemp[i][j] = T[i][j]+(K*dt/(dx*dx))*(-2*T[i][j]+T[i-1][j]+T[i][j-1]);
          } else {
            Ttemp[i][j] = T[i][j]+(K*dt/(dx*dx))*(T[i+1][j]-3*T[i][j]+T[i-1][j]+T[i][j-1]);
          }
        } else {
          if (i == 0) {
            Ttemp[i][j] = T[i][j]+(K*dt/(dx*dx))*(T[i+1][j]-3*T[i][j]+T[i][j-1]+T[i][j+1]);
          } else if (i  == NX -1) {
            Ttemp[i][j] = T[i][j]+(K*dt/(dx*dx))*(-3*T[i][j]+T[i-1][j]+T[i][j-1]+T[i][j+1]);
          } else {
            Ttemp[i][j] = T[i][j]+(K*dt/(dx*dx))*(T[i+1][j]-4*T[i][j]+T[i-1][j]+T[i][j-1]+T[i][j+1]);
          }
        }
      }
    }
    for (int i = 0; i < NX; i ++) {
      for (int j = 0; j < NX; j ++) {
        if (source[i][j][0] == i && i != 0) {
          Ttemp[i][j] = source[i][j][2];
        }
      }
    }
    for (int j = 0; j < NX; j ++) {
      for (int i = 0; i < NX; i ++) {
        T[i][j] = Ttemp[i][j];
      }
    }

    for (int i = 0; i < NX; i ++) {
      for (int j = 0; j < NX; j ++) {
        color c = color(rd+(ra-rd)*(T[i][j]/contraste+0.5), vd+(va-vd)*(T[i][j]/contraste+0.5), bd+(ba-bd)*(T[i][j]/contraste+0.5));
        fill(c);
        stroke(c);
        rect( i*(width/2)/NX, j*height/NX, (width/2)/NX, height/NX);
      }
    }
    temps ++;
  }

  //Placement Sources
  if (mousePressed && cd > cdt) {
    int xS = int(mouseX*NX/(width/2));
    int yS = int(mouseY*NX/height);

    if (xS >= 0 && xS < NX && yS >= 0 && yS < NX) {
      if (mouseButton == LEFT) {
        if (xS+dimSource < NX && yS+dimSource < NX) { 
          for (int k = 0; k < dimSource; k ++) {
            for (int l = 0; l < dimSource; l ++) {
              source[xS+k][yS+l][0] = xS+k;
              source[xS+k][yS+l][1] = yS+l;
              source[xS+k][yS+l][2] = valeurSource;
              color c = color(rd+(ra-rd)*(valeurSource/contraste+0.5), vd+(va-vd)*(valeurSource/contraste+0.5), bd+(ba-bd)*(valeurSource/contraste+0.5));
              fill(c);
              rect( mouseX, mouseY, dimSource*(width/2)/NX, dimSource*height/NX);
            }
          }
        }
      } else {
        if (xS+dimSource < NX && yS+dimSource < NX) { 
          for (int k = 0; k < dimSource; k ++) {
            for (int l = 0; l < dimSource; l ++) {
              source[xS+k][yS+l][0] = 0;
              source[xS+k][yS+l][1] = 0;
              source[xS+k][yS+l][2] = valeurSource;
            }
          }
        }
      }
    }
    cd = 0;
  }
  
  //Souris
  if(cd <= cdt){
    cd ++;
  }
  
  
  //Affichage des paramètres
  affichage();
  
  
  //Record
  if (temps%frequenceRecord == 0 && record) {
    saveFrame("sortie/frames-######.png");
  }
}

void affichage() {
  
  
  pushStyle();
  stroke(0);
  line(width/2, 0, width/2, height);
  fill(0);
  textSize(ry(35));
  text("Parametres", rx(970), ry(40));
  popStyle();


  pushStyle();//record on/off : r
  if (record) {
    strokeWeight(rx(5));
    stroke(0);
    fill(250, 100, 100);
  } else {
    strokeWeight(rx(3));
    stroke(50);
    noFill();
  }
  rect(rx(775), ry(75), rx(250), ry(75));
  fill(0);
  textSize(ry(20));
  text("Enregistrement : r", rx(815), ry(120));
  popStyle();


  pushStyle();//pause on/off : espace
  if (pause) {
    strokeWeight(rx(5));
    stroke(0);
    fill(250, 100, 100);
  } else {
    strokeWeight(rx(3));
    stroke(50);
    noFill();
  }
  rect(rx(1075), ry(75), rx(250), ry(75));
  fill(0);
  textSize(ry(20));
  text("Pause : espace", rx(1115), ry(120));
  popStyle();


  pushStyle();
  for (int i = 0; i < 4; i ++) {
    strokeWeight(rx(3));
    stroke(50);
    noFill();
    for (int j = 0; j < 4; j ++) {
      rect(rx(775)+rx(50)*j, ry(200+i*100), rx(50), ry(50));
    }
    rect(rx(775), ry(250+i*100), rx(200), ry(50));

    line(rx(775+25-7), ry(200+25+i*100), rx(775+25+8), ry(200+10+i*100));
    line(rx(775+25-7), ry(200+25+i*100), rx(775+25+8), ry(200+40+i*100));

    line(rx(775+25-7+50), ry(200+25+i*100), rx(775+25+8+50), ry(200+10+i*100));
    line(rx(775+25-7+50), ry(200+25+i*100), rx(775+25+8+50), ry(200+40+i*100));

    line(rx(775+25-7-8), ry(200+25+i*100), rx(775+25), ry(200+10+i*100));
    line(rx(775+25-7-8), ry(200+25+i*100), rx(775+25), ry(200+40+i*100));

    line(rx(775+25+8+100), ry(200+25+i*100), rx(775+25-7+100), ry(200+10+i*100));
    line(rx(775+25+8+100), ry(200+25+i*100), rx(775+25-7+100), ry(200+40+i*100));

    line(rx(775+25+8+150), ry(200+25+i*100), rx(775+25-7+150), ry(200+10+i*100));
    line(rx(775+25+8+150), ry(200+25+i*100), rx(775+25-7+150), ry(200+40+i*100));

    line(rx(775+25+8+158), ry(200+25+i*100), rx(775+25-7+158), ry(200+10+i*100));
    line(rx(775+25+8+158), ry(200+25+i*100), rx(775+25-7+158), ry(200+40+i*100));
  }
  popStyle();


  pushStyle();//valeur source +/- : haut/bas
  fill(0);
  textSize(ry(20));
  text(str(int(valeurSource*1000)/1000.0), rx(830), ry(285));
  text("Temperature Source \n->flèche haut/bas", rx(1000), ry(230));
  popStyle();


  pushStyle();//sourceP +/- : gauche/droite
  int d = 100;
  fill(0);
  textSize(ry(20));
  text(str(int(sourceP*1000)/1000.0), rx(830), ry(285+d));
  text("Precision T Source \n->flèche gauche/droite", rx(1000), ry(230+d));
  popStyle();


  pushStyle();//dimSource +/- : p/m
  d = 200;
  fill(0);
  textSize(ry(20));
  text(str(dimSource), rx(830), ry(285+d));
  text("Dimension source \n->touche p/m", rx(1000), ry(230+d));
  popStyle();


  pushStyle();//contraste *//      o/l
  d = 300;
  fill(0);
  textSize(ry(20));
  text(str(contraste), rx(830), ry(285+d));
  text("Contraste \n->touche o/l", rx(1000), ry(230+d));
  popStyle();
  
  
  pushStyle();
  fill(30);
  textSize(ry(30));
  text("Framerate : "+frameRate,rx(780),ry(660));
  popStyle();
  
  
  if (mousePressed && mouseButton == LEFT) {
    if ((mouseX) > rx(775) && mouseX < rx(775+50) && mouseY > ry(200) && mouseY < ry(200+50)) {
      valeurSource -= sourceP;
    }
    if ((mouseX) > rx(775+150) && mouseX < rx(775+200) && mouseY > ry(200) && mouseY < ry(200+50)) {
      valeurSource += sourceP;
    }

    if ((mouseX) > rx(775) && mouseX < rx(775+50) && mouseY > ry(300) && mouseY < ry(300+50)) {
      sourceP -= 0.1;
    }
    if ((mouseX) > rx(775+150) && mouseX < rx(775+200) && mouseY > ry(300) && mouseY < ry(300+50)) {
      sourceP += 0.1;
    }

    if ((mouseX) > rx(775) && mouseX < rx(775+50) && mouseY > ry(400) && mouseY < ry(400+50)) {
      dimSource --;
    }
    if ((mouseX) > rx(775+150) && mouseX < rx(775+200) && mouseY > ry(400) && mouseY < ry(400+50)) {
      dimSource ++;
    }
    if ((mouseX) > rx(775) && mouseX < rx(775+50) && mouseY > ry(500) && mouseY < ry(500+50)) {
      contraste /= cp;
    }
    if ((mouseX) > rx(775+150) && mouseX < rx(775+200) && mouseY > ry(500) && mouseY < ry(500+50)) {
      contraste *= cp;
    }
  }
  
  
}

void mouseClicked() {
  if (mouseButton == LEFT) {
    if ((mouseX) > rx(775) && mouseX < rx(775+250) && mouseY > ry(75) && mouseY < ry(150)) {
      record = !record;
    }
    if ((mouseX) > rx(1075) && mouseX < rx(1325) && mouseY > ry(75) && mouseY < ry(150)) {
      pause = !pause;
    }
    if ((mouseX) > rx(775+50) && mouseX < rx(775+100) && mouseY > ry(200) && mouseY < ry(200+50)) {
      valeurSource -= sourceP;
    }
    if ((mouseX) > rx(775+100) && mouseX < rx(775+150) && mouseY > ry(200) && mouseY < ry(200+50)) {
      valeurSource += sourceP;
    }
    if ((mouseX) > rx(775+50) && mouseX < rx(775+100) && mouseY > ry(200+100) && mouseY < ry(200+50+100)) {
      sourceP -= 0.1;
    }
    if ((mouseX) > rx(775+100) && mouseX < rx(775+150) && mouseY > ry(200+100) && mouseY < ry(200+50+100)) {
      sourceP += 0.1;
    }
    if ((mouseX) > rx(775+50) && mouseX < rx(775+100) && mouseY > ry(200+2*100) && mouseY < ry(200+50+2*100)) {
      dimSource --;
    }
    if ((mouseX) > rx(775+100) && mouseX < rx(775+150) && mouseY > ry(200+2*100) && mouseY < ry(200+50+2*100)) {
      dimSource ++;
    }
    if ((mouseX) > rx(775+50) && mouseX < rx(775+100) && mouseY > ry(200+3*100) && mouseY < ry(200+50+3*100)) {
      contraste /= cp;
    }
    if ((mouseX) > rx(775+100) && mouseX < rx(775+150) && mouseY > ry(200+3*100) && mouseY < ry(200+50+3*100)) {
      contraste *= cp;
    }
  }
}


float rx(float x) {
  return x*width/1400;
}


float ry(float y) {
  return y*height/700;
}


void keyPressed() {
  if (keyCode == 38) {
    valeurSource += sourceP;
    println("Valeur Source : "+int(valeurSource*1000)/1000.0);
  } else if (keyCode == 40) {
    valeurSource -= sourceP;
    println("Valeur Source : "+int(valeurSource*1000)/1000.0);
  } else if (keyCode == 37) {
    sourceP -= 0.1;
    println("Précision source : "+ int(sourceP*1000)/1000.0);
  } else if (keyCode == 39) {
    sourceP += 0.1;
    println("Précision source : "+ int(sourceP*1000)/1000.0);
  } else if (keyCode == 80) {
    dimSource ++;
    println("Dimension source : "+ dimSource);
  } else if (keyCode == 77 && dimSource > 0) {
    dimSource --;
    println("Dimension source : "+ dimSource);
  } else if (keyCode == 32) {
    pause = !pause;
    println("pause");
  } else if (keyCode == 79) {//o
    contraste *= cp;
    println("Contraste : "+contraste);
  } else if (keyCode == 76) {//l
    contraste /= cp;
    println("Contraste : "+contraste);
  }else if(keyCode == 82){//r
    record = !record;
  }
}
