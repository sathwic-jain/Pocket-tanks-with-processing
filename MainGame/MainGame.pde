Map map; //map
PVector[] players = new PVector[2]; //array of players
boolean[] playerFired = new boolean[2]; //to keep track whether the player has fired or not
ArrayList<ArrayList<PVector>> gridCols = new ArrayList<ArrayList<PVector>>(); //grid - map
boolean movePhase; 
//boolean shootPhase; 
int playerTurn ; //player turn(0 and 1)
boolean notMoving = false; //whether the players are moving or not.
boolean showLine; //to show the cannon mouth of the tanks
boolean shootingPhase = false; //to know if its the shooting Phase
boolean fired; //if the bullet has been fired or not.
PVector firePoint;
float theta; //angle of elavation
PVector referenceX; //a reference vector to get the angle.
PVector wind = new PVector(0.0,0.0); //wind vector.
PVector drag = new PVector(0.0,0.0); //friction or air drag for the bullet.
int blockWidth = 100; //blockWidth
int blockHeight = 40;
boolean collided = false; //if the bullet collided with anything or not
PVector mouse; //to keep track of the mouse while aiming
//PVector dir;
PVector bullet; //bullet vector
PVector  velocityProjectile; //velocity vector of the bullet

PVector gravity = new PVector(0.0,0.0); //gravity vector .
PVector defaultGravity = new PVector(0, 9.8/60); //default gravity for the bullet.

int value = 70; //minimum firing force value(later minimized according to pixels).

boolean leftTank = false; //if the bullet has left tank or not.
boolean outOfBounds; //if the bullet goes out of bounds

int[] score = {0,0}; //keep track of scores.

int winner;
boolean gameOver=false;
boolean abilityUsed = false; //to check whether an ability has been used.
int[] gravityGun = new int[2];
int[] landSlider = new int[2];
int[] flashBomb = new int[2];
boolean hidden = false;
int hiddenPlayer; //hiding the flashing player.
float force; //force of fire.
void setup() {
    fullScreen();
  initialize();
}

void draw() {
  noStroke();
  fill(255, 30); //to create trail
  rectMode(CORNERS);
  rect(0, 0, width, height);
  if(!gameOver){ //checking game over
  map.displayGrid();
  displayStats(); //display statistics of the game
  if(hidden){ //hidden in case of flashbomb
     fill(255);
     rectMode(CORNERS);
     rect(0,0,width,height);
   map.hidden(hiddenPlayer);
  } else {
  map.displayPlayers(); //display all players
  }
  notMoving = map.updatePlayerBlocks(); //to update player blocks
  if (notMoving && !abilityUsed) { 
    projectile(players[playerTurn]); //projectile updated only when the players are not moving 
    fill(0);
    if (fired){
      updateProjectory();
      checkPlayerHit();
      checkCollision();
    }
  }
  if (collided) { //if collision occurs update map/
    map.updateBlocks();
  }
  isGameOver();
  } else {
  gameOverPage();
  }
  //changing player turn if fired.
  if(collided || outOfBounds || abilityUsed){ //switching player turns
  if (playerFired[playerTurn] || abilityUsed) {
    playerFired[playerTurn] = false;
    if (playerTurn == 0) {
      playerTurn = 1;
    } else {
      playerTurn = 0;
    }
      abilityUsed = false;
      if(hidden == true){
       hidden = false; 
      }
  }
  

  }
} 

//function that creates the cannon for projectile launch
void projectile(PVector player) {
  if(!shootingPhase){
  //&& !abilityUsed) {
  pushMatrix();
  mouse = new PVector(mouseX, mouseY);
  mouse.sub(player);
  translate(player.x, player.y);
  mouse.setMag(value);
  mouse.limit(300);
  fill(0);
  int randomred = (int) random(255);
  int randomblue = (int) random(255);
  int randomgreen = (int) random(255);
  stroke(randomred, randomblue, randomgreen);
  strokeWeight(5);
  line(0, 0, mouse.x, mouse.y); //teh cannon.
      referenceX = new PVector(width, 0);
    theta =PVector.angleBetween(referenceX, mouse);  //angle calculated in reference to the x axis
  popMatrix();
 // }
}
}

void mouseReleased() { //when mouse is released the cannon fires.
  if (!shootingPhase && notMoving) {
    shootingPhase = true;
    showLine = false;
    collided = false;
    leftTank = false;
    outOfBounds = false;
    fill(0);
    bullet = new PVector(players[playerTurn].x, players[playerTurn].y);
    noStroke();
    ellipse(bullet.x, bullet.y, 30, 30); 
    fired = true;
    //finding fired angle
    referenceX = new PVector(width, 0);
    //theta =PVector.angleBetween(referenceX, mouse);
    theta =(PVector.angleBetween(referenceX, mouse));
     if((mouse.cross(referenceX)).z<0){
   theta = 2*PI - theta;   //calculatinf the theta appropriately according to the x axis
  }
    velocityProjectile = new PVector(cos(theta)*(3.0/6), -sin(theta)*(3.0/6)); 
    force =(float) value/7;
    velocityProjectile.mult(value/7);
    value = 70;
    playerFired[playerTurn] = true;
  }
}

void mouseDragged() { //the force is calculated according to the drag after clicking
  pushMatrix();
  translate(players[playerTurn].x,players[playerTurn].y);
  fill(0);
  PVector tempMouse = new PVector(mouseX,mouseY);
  PVector tempPMouse = new PVector(pmouseX,pmouseY);
  tempMouse.sub(players[playerTurn]);
  tempPMouse.sub(players[playerTurn]);
  fill(0);
  if (!shootingPhase) {
      if(dist(0,0,tempMouse.x,tempMouse.y)<dist(0,0,tempPMouse.x,tempPMouse.y)){ 
        if (value>50) {
          value--;
          force =(float) value/7;
        }
      } else if(dist(0,0,tempMouse.x,tempMouse.y)>dist(0,0,tempPMouse.x,tempPMouse.y)){
      if (value<700) {
        value++;
        mouse.mult(value);
        force =(float) value/7;
      }
      }
  }
  popMatrix();
}
  
void updateProjectory() { //the position of bullet is updated.
  if (!collided) {
    velocityProjectile.add(gravity);
    //finding and adding the drag,as it is dependent on the velocity.
    drag.x = velocityProjectile.x;
    drag.y = velocityProjectile.y;
    drag = drag.mult(-0.01);
    drag.limit(1); //drag velocity limit
    bullet.add(velocityProjectile);
    bullet.add(drag);
    bullet.add(wind);
    fill(138, 98, 100);
    noStroke();
    ellipse(bullet.x, bullet.y, 30, 30);
  } //<>//
  if (bullet.x > width || bullet.y > height || bullet.x < 0) {
    bullet = new PVector(0, 0);
    velocityProjectile.mult(0);
    shootingPhase = false;
    fired = false;
    outOfBounds = true;
    showLine = true;
    setWind();
  }
}

//funciton that checks if the collision has occured
void checkCollision() {
  ArrayList<PVector> tempList = new ArrayList<PVector>();
  PVector temp = null;
  float xCloseDistance;
  float yCloseDistance;
  float distanceCalculated;
outer: for (int i = 0; i < gridCols.size(); i++) {
    tempList = gridCols.get(i);
    for (int j = 0; j < tempList.size(); j++) {
      xCloseDistance = constrain(bullet.x, gridCols.get(i).get(j).x - (blockWidth/2), gridCols.get(i).get(j).x + (blockWidth/2));
      yCloseDistance = constrain(bullet.y, gridCols.get(i).get(j).y - (blockHeight/2), gridCols.get(i).get(j).y + (blockHeight/2));       
      distanceCalculated = dist(xCloseDistance, yCloseDistance, bullet.x, bullet.y);
      if (distanceCalculated <= 15) {
        temp = tempList.get(j);
        //tempList.remove(temp);
        bullet.mult(0);
        collided = true;
        showLine = true;
        shootingPhase = false;
        setWind();
        break outer;
      }
    }
  }
  tempList.remove(temp); //removing the block hit.
  return;
}

void checkPlayerHit() { //checks if the player is hit.

  float xCloseDistance;
  float yCloseDistance;
  float distanceCalculated;
  int firedTank = playerTurn;
  for (int i = 0; i< players.length; i++) {
    if(leftTank){ //if the bullet has left the tank.
            xCloseDistance = constrain(bullet.x, players[i].x - (blockWidth/2), players[i].x + (blockWidth/2));
           yCloseDistance = constrain(bullet.y, players[i].y - (blockHeight/2), players[i].y + (blockHeight/2)); 
           distanceCalculated = dist(xCloseDistance, yCloseDistance, bullet.x, bullet.y);
           if(i == firedTank){ //friendly fire
                  if ((distanceCalculated <= 15)) {
                   bullet.mult(0);
                   collided = true;
                   showLine = true;
                   fired = false;
                   shootingPhase = false;
                   if(i == 0) {
                    score[1] ++; 
                   } else {
                    score[0]++; 
                   }
                  }  
         } else { //enemy hit
                 if ((distanceCalculated <= 15)) {
                  bullet.mult(0);
                  collided = true;
                   showLine = true;
                   fired = false;
                   shootingPhase = false;
                   setWind();
                   if(i == 0) {
                    score[1] ++; 
                   } else {
                    score[0]++; 
                   }
           }
           }
    } else if (i == firedTank) { //if the bullet has not left the fired tank, do not calculate the collision but check the fire leaving.
        if((abs(bullet.x - players[i].x) > (blockWidth/2 + 15)) || (abs(bullet.y - players[i].y)) > ( blockHeight/2 + 15) && !leftTank){
          leftTank = true;
    }
    }
    }
    }

//various key actions for movements and abilities.
void keyPressed() {
  if (!shootingPhase) {
    if (key == 'd' || key =='D') {
      boolean canMove = moveRight(playerTurn); 
      if (canMove) {
        players[playerTurn].x =  players[playerTurn].x + blockWidth;
        players[playerTurn].y = players[playerTurn].y;
      }
    } else if (key == 'a' || key == 'A') {
      boolean canMove = moveLeft(playerTurn); 
      if (canMove) {
        players[playerTurn].x =  players[playerTurn].x - blockWidth;
        players[playerTurn].y = players[playerTurn].y;
      }
    }
  }

   if(key == 'g' || key == 'G') {
     if(gravityGun[playerTurn] > 0){

        changeGravity();
        abilityUsed = true;
        gravityGun[playerTurn] = 0;
     }
   } else if(key == 'x' || key =='X'){
     if(landSlider[playerTurn]>0){
       removecol();
       landSlider[playerTurn] = 0;
       abilityUsed = true;
     }
  } else if(key == 'f' || key =='F'){
       if(flashBomb[playerTurn]>0){
         flashBomb[playerTurn] = 0;
         fill(255);
         rectMode(CORNERS);
         rect(0,0,width,height);
       //map.hidden(playerTurn);
       hiddenPlayer = playerTurn;
       hidden = true;
        if (playerTurn == 0) {
          playerTurn = 1;
          } else {
          playerTurn = 0;
          }
     }
  } else if(key == 'r' || key =='R') {
   initialize();
   drag.mult(0);
   wind.mult(0);
   force = 0.0;
   
  }
  //else if(key == 'p') { //for easy checking of the game. Uncomment the section to remove the lands using p and check the game wins.
  // removecol();
  //}
}

//function to check if the playter can move right
boolean moveRight(int playerTurn) {
  if (players[playerTurn].x + blockWidth >= width) {
    return false;
  }
  for (int i = 0; i < gridCols.size(); i++) { 
    if (gridCols.get(i).get(0).x > players[playerTurn].x) {
      ArrayList<PVector> tempList = gridCols.get(i);
      for (int j = 0; j < tempList.size(); j++) {
        if (gridCols.get(i).get(j).y < players[playerTurn].y) {
          int distance =(int) dist(players[playerTurn].x, players[playerTurn].y, tempList.get(j).x, tempList.get(j).y);
          if (distance <= blockWidth) {
            return false;
          }
        }
      }
    }
  }
  return true;
}
//function to check if the playter can move right
boolean moveLeft(int playerTurn) {
  if (players[playerTurn].x - blockWidth <= 0) {
    return false;
  }
  for (int i = 0; i < gridCols.size(); i++) {
    if(gridCols.get(i).size() != 0){
    if (gridCols.get(i).get(0).x < players[playerTurn].x) {
      ArrayList<PVector> tempList = gridCols.get(i);
      for (int j = 0; j < tempList.size(); j++) {
        if (gridCols.get(i).get(j).y < players[playerTurn].y) {
          int distance =(int) dist(players[playerTurn].x, players[playerTurn].y, tempList.get(j).x, tempList.get(j).y);
          if (distance <= blockWidth) {
            return false;
          }
        }
      }
    }
    }
  }
  return true;
}

//removing the column in front of the player.
void removecol() {
  ArrayList<PVector> delCol = new ArrayList<PVector>();
  if(playerTurn == 0) {
   for(int i = 0; i < gridCols.size() - 1; i++){
    if(gridCols.get(i).size() != 0) {
      if(players[playerTurn].x + blockWidth == gridCols.get(i).get(0).x){
        delCol = gridCols.get(i);
      }
   }
  }
  } else if(playerTurn == 1){
       for(int i = 0; i < gridCols.size() - 1; i++){
    if(gridCols.get(i).size() != 0) {
      if(players[playerTurn].x - blockWidth == gridCols.get(i).get(0).x){
        delCol = gridCols.get(i);
      }
   }
  }
  }
  gridCols.remove(delCol);
}


void isGameOver() {
  for(int i = 0; i<2;i++){
   if(score[i] >= 5) {
     gameOver = true;
    winner = i; 
   }
  }
}

void displayStats(){
  textSize(22);
   // Display text at the top-left corner of the screen
  textAlign(LEFT, TOP);
  text("Player1", 10, 10);
  text("Score : " + score[0], 10, 35);
  text("Power moves : G(" +gravityGun[0] + "), X(" +(landSlider[0]) + "), F(" + (flashBomb[0]) +")", 10, 82);
  if(playerTurn == 0){
  text("Elevation : " + theta, 10, 60);  
}
  text("Airdrag : (x:) " + drag.x + " , (y:) " + drag.y, 10, 127);
  text("Gravity : " + gravity.y, 10, 152);
  text("Force : " + force +"% ",10, 177);
  text("Wind(x) : " + wind.x, width - 250, 127);
  
  // Display text at the top-right corner of the screen
  textAlign(RIGHT, TOP);
  text("Player2", width - 10, 10);

  text("Score : " + score[1],width - 10, 35);
   if(playerTurn == 1){
  text("Elevation : " + theta,width - 10, 60);  
  }
  text("Power moves : G(" +gravityGun[1] + "), X(" +(landSlider[1]) + "), F(" + (flashBomb[1]) + ")", width - 13, 82); 
}

//function that sets the wind.
void setWind(){
  wind.mult(0);
  //random generation of wind velocity
  float windFactor =  random(100);
  float windPower = windFactor/100;
  wind.x += windPower;
  int directionWind = (int) random(1,3);
  directionWind -= 2; //here we just need -1 -negative direction, 0 - no wind, 1- positive direction.
  wind = wind.mult(directionWind);
}

void setGravity(float g){
  gravity.y = g;
}

void changeGravity(){
 float g =  random (10.0/60, 40.0/60);
 setGravity(g);
}

//initializing the basic variables. This is called when r is pressed.
void initialize(){
  setGravity(defaultGravity.y);
  map = new Map(100, 40, players, gridCols);
  playerFired[0] = false;
  playerFired[1] = false;
  setWind();
  playerTurn = 0;
  for(int i=0 ;i < players.length; i++){
  gravityGun[i] = 1;
  landSlider[i] = 1;
  flashBomb[i] = 1;
  }
}

void gameOverPage(){
  textAlign(CENTER);
  textSize(100);
  fill(0);
 text("The Winner is player" + (winner + 1), width/2,height/2); 
 textSize(20);
 text("Press r to restart the game",width/2,(height/2)+120);
}
