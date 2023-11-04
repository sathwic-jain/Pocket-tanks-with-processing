
class Map{
 int noOfCols;
 int noOfRows;
 int blockWidth;
 int blockHeight;
 int maxCols;
 int maxRow;
 PVector[] cols;
 PVector[] players;
 PVector[] velocity = new PVector[2];
 PVector[] acceleration = new PVector[2];

 PVector distanceFromLand = new PVector(0.0,0.0); //distance from land is used when the block falling has exceeded the boundary. This needs to be reduced to take the block back.

 int randomXLocation1; //for player1
 int randomXLocation2; //for player 2
 ArrayList<ArrayList<PVector>> gridCols; 

 PVector velocityLand = new PVector(0.0,0.0);
 PVector gravityLand = new PVector(0.0,10);
 int[] noOfBounces = {0,0}; // inorder to keep track of the previous velocity,(considering a fail case).
 
Map(int blockWidth,int blockHeight, PVector[] players,ArrayList<ArrayList<PVector>> gridCols){
  
  this.gridCols = gridCols;
  this.players = players;
  this.blockWidth = blockWidth;
  this.blockHeight = blockHeight;
  this.maxCols = width/blockWidth;
  float leftOver = width%blockWidth;
  this.maxRow = height/blockHeight;
  noOfCols = (int) random(maxCols - (maxCols/3), maxCols);
  cols = new PVector[noOfCols];
  randomXLocation1 = (int) random(0, maxCols/4);
  randomXLocation2 = (int) random((maxCols*3)/4, maxCols);
  int dropLocation1 = abs(((randomXLocation1 - 1) * blockWidth) +(blockWidth/2) );
  int dropLocation2 = abs(((randomXLocation2 - 1) * blockWidth) +(blockWidth/2));
  players[0] = new PVector(dropLocation1+(leftOver/2),0);
  players[1] = new PVector(dropLocation2+(leftOver/2),0);

  for(int i = 0; i < players.length; i++) {
    velocity[i] = new PVector(0.0,0.0);
    acceleration[i] = new PVector(0.0,0.0);
    //distanceFromLand[i] = new PVector(0.0,0.0);
  }
  makeGrid();
}
  
  void makeGrid(){
    //filling columns
    int midCol;
     if(noOfCols%2 == 0){
        midCol = noOfCols/2;  
      } else {
       midCol = (noOfCols + 1)/2; 
      }
      cols[midCol - 1] = new PVector(width/2, height - (blockHeight/2));
      for(int i = midCol - 2; i >= 0; i--) {
        cols[i] = new PVector(cols[i+1].x - blockWidth, height - (blockHeight/2));      
    }
      for(int i = midCol; i < noOfCols; i++) { 
         cols[i] = new PVector(cols[i-1].x + blockWidth, height - (blockHeight/2));   
    }
   //filling the rows
   for(int i = 0; i < noOfCols; i++ ){
    if(i == midCol || i == midCol + 1 || i == midCol - 1){ //for the middle area.
      noOfRows = (int) random(maxRow/4, maxRow/2);
    } else {
    noOfRows = (int) random(maxRow/4, (maxRow*3)/4);
    }
    ArrayList<PVector> eachCol = new ArrayList<PVector>();
    eachCol.add(cols[i]);
    for(int j = 1; j <= noOfRows ; j++) {
       eachCol.add(new PVector(eachCol.get(j-1).x, eachCol.get(j-1).y - blockHeight)); 
    }
    gridCols.add(eachCol);
   }
    for(int i = 0; i < noOfCols; i++){
     for(int j = 0; j < gridCols.get(i).size();j++){
     }
    }
  }
  
  void displayGrid(){
       //fill(0);
       fill(30,77,47);
       noStroke();
    rectMode(CENTER);
    for(int i = 0; i < gridCols.size(); i++) {
       for(int j = 0; j < gridCols.get(i).size(); j++){
          rect(gridCols.get(i).get(j).x,gridCols.get(i).get(j).y,blockWidth,blockHeight); 
        }
      } 
  }

  void displayPlayers(){
    stroke(81,209,224);
    strokeWeight(3);
    rectMode(CENTER);
     fill(240,121,10);
     rect(players[0].x, players[0].y, blockWidth, blockHeight);
     rectMode(CENTER);
     fill(143,10,240);
     rect(players[1].x, players[1].y, blockWidth, blockHeight);
  
}
// function to display the players when one player is flashBombed.
  void hidden(int playerTurn){
    if(playerTurn == 0){
    rectMode(CENTER);
    noStroke();
     fill(255);
     rect(players[0].x, players[0].y, blockWidth, blockHeight);
     rectMode(CENTER);
    stroke(81,209,224);
    strokeWeight(3);
     fill(143,10,240);
     rect(players[1].x, players[1].y, blockWidth, blockHeight);
    } else {
    stroke(81,209,224);
    strokeWeight(3);
    rectMode(CENTER);
     fill(240,121,10);
     rect(players[0].x, players[0].y, blockWidth, blockHeight);
     rectMode(CENTER);
     noStroke();
     fill(255);
     rect(players[1].x, players[1].y, blockWidth, blockHeight);
    }
    
  }

 boolean updatePlayerBlocks(){
  for(int k = 0; k < players.length; k++) {
    
    //
    if(velocity[k].y == 0) {
     if(!intersectsLand(players[k],k)) {
       setForce(gravity,k);
       velocity[k].add(acceleration[k]);
       players[k].add(velocity[k]);
       acceleration[k].mult(0);
     }
    } else { 
    //
  if(intersectsLand(players[k],k)) {
     if((round(abs(velocity[k].y)) != 0) && noOfBounces[k] < 5){ //sometimes the for loops goes to infinite, so providing an upper limit for the bounces
        noOfBounces[k]++;
         players[k].sub(distanceFromLand); //subtracting the pixels passed while calculating whether the clokcs collided.If this is not done, the bouncing will not work effectively
         distanceFromLand.mult(0);
         velocity[k].mult(-1);
         PVector dampener = new PVector(velocity[k].x,velocity[k].y);
         dampener.mult(-0.4);  //damping factor.
         velocity[k].add(dampener);
         setForce(gravity,k);
         velocity[k].add(acceleration[k]);
         players[k].add(velocity[k]);
         acceleration[k].mult(0);
         dampener.mult(0);
     } else if(round(abs(velocity[k].y)) == 0 || noOfBounces[k] >= 5){ //stop bouncing if the round of velocity is zero
        velocity[k].mult(0);
     }
   } else if (!intersectsLand(players[k],k)) {
       setForce(gravity,k);
       velocity[k].add(acceleration[k]);
       players[k].add(velocity[k]);
       acceleration[k].mult(0);
      }
    }
 }
    //
    
    //
    if(velocity[0].y == 0 && velocity[1].y == 0){
       noOfBounces[0] = 0;
       noOfBounces[1] = 0; //resetting the bounces after each fall
       //println("returning");
      return true; 
      
    } else {
     return false; 
    }
  }
 
 //checks whether the given player and land intersects
 boolean intersectsLand(PVector player, int k){
   if(player.y + blockHeight/2 >= height) {
     float d = dist(player.x,player.y,player.x,height);
    if(velocity[k].y != 0){
       PVector tempDistance = new PVector(0.0,blockHeight - d);
        distanceFromLand.add(tempDistance);
      }
     return true;
   } else {
    for(int i = 0; i < gridCols.size(); i++) {
      if(gridCols.get(i).size()>0){
      if(player.x == gridCols.get(i).get(0).x) {
         for(int j = 0; j < gridCols.get(i).size(); j++){
           float d = dist(player.x,player.y,gridCols.get(i).get(j).x,gridCols.get(i).get(j).y);
          if(d <= blockHeight) {
            if(velocity[k].y != 0){
            PVector tempDistance = new PVector(0.0,blockHeight - d);
            distanceFromLand.add(tempDistance);
            }
             return true;
          }
        }
    }
    }
      }
   }
    return false;
 }
 
 void setForce(PVector force, int player) {
  acceleration[player].add(force);   
 }
 
 void addForce(PVector force, int player) {
  acceleration[player].add(force); 
 }
 
 
 void updateBlocks(){
       for(int i = 0; i < gridCols.size(); i++) {
         ArrayList tempList = gridCols.get(i);
       for(int j = tempList.size() - 1 ; j >= 0; j--){
         //
         if(j == 0){
                  PVector temp = gridCols.get(i).get(0);
       float d = dist(gridCols.get(i).get(0).x,gridCols.get(i).get(0).y,gridCols.get(i).get(0).x,height);
          if(d > blockHeight/2) {
          velocityLand.add(gravityLand);
           temp.add(velocityLand);
           velocityLand.mult(0);
         }
         } else{
         PVector temp = gridCols.get(i).get(j);
         float d = dist(gridCols.get(i).get(j-1).x,gridCols.get(i).get(j-1).y,gridCols.get(i).get(j).x,gridCols.get(i).get(j).y);
         if(d > blockHeight) {
          velocityLand.add(gravityLand);
           temp.add(velocityLand);
           velocityLand.mult(0);
         }
        }
       }
 }
  }
 
 //to check if the land blocks intersect or not
boolean landIntersects(PVector land){
   if(land.y + blockHeight/2 >= height) {
     return true;
   }
    for(int i = 0; i < gridCols.size(); i++) {
      //if(land.x == gridCols.get(i).get(0).x) {
         for(int j = 0; j < gridCols.get(i).size() - 1; j++){
           for(int k = j + 1; k <gridCols.get(i).size();k++){
           float d = dist(gridCols.get(i).get(k).x,gridCols.get(i).get(k).y,gridCols.get(i).get(j).x,gridCols.get(i).get(j).y);
          if(d > blockHeight) {
             return false;
          } else if(d<=blockHeight) {
           return true; 
          }
         }
      }
    //}
      }
    return true;
 }
  }
