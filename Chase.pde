/* So cool news, fullScreen makes the frame fullscreen.
AND it stores the dimensions to width/height.
*/
void setup() {
  // size(1024,768);
  fullScreen();
  frameRate(60);
  background(0);
  stroke(255);
  startPOS();
}

// default init for vars
void startPOS() {
    playerX = random(0, width);
    playerY = random(0, height);
    playerSize = 40;
    playerSpeed = DEFAULT_PLAYER_SPEED;

    coinX = random(0,width);
    coinY = random(0,height);
    coinSize = 20;
    while (dist(playerX,playerY,coinX,coinY) <= 150) {
      coinX = random(0,width);
      coinY = random(0,height);
    }

    blobX = random(0,width);
    blobY = random(0,height);
    blobSize = 55;
    blobSpeed = 3;
    while (dist(playerX,playerY,blobX,blobY) <= 200) {
      blobX = random(0,width);
      blobY = random(0,height);
    }
}

final float DEFAULT_PLAYER_SPEED = 5;
final float DEFAULT_PLAYER_DASH = 10;

float playerX, playerY;
color playerColor = #555050;
float playerSpeed, playerSize;

float coinX, coinY;
float coinSize;
color coinColor = color(255,255,0);

float blobX, blobY;
float blobSpeed, blobSize;
color blobColor = color(255,0,0);

float bearing = 0.0;
int score = 0;

void draw() {
  background(0);
  playerDraw();
  coinDraw();
  blobDraw();
  collision();
  updatePOS();
}

// Draws the player circle
void playerDraw() {
  fill(playerColor);
  ellipse(playerX,playerY, playerSize, playerSize);
  noFill();
}

// draws the coin circle
void coinDraw() {
  fill(coinColor);
  ellipse(coinX,coinY,coinSize,coinSize);
  noFill();
}

// draws the blob circle
void blobDraw() {
  fill(blobColor);
  ellipse(blobX,blobY,blobSize,blobSize);
  noFill();
}

// Wrapper function for position of objects
void updatePOS() {
  playerPOS();
  blobPOS();
}

/* BUG: Jerky overmove if too close to mouse?
SOLVED: Added a distance check to see if default move is too big.
*/

// The try/catch is there b/c mouseY is default 0 when not on screen

// Moves the player towards the mouse
void playerPOS() {
  if (dist(playerX,playerY,mouseX,mouseY) <= playerSpeed) {
    playerX = mouseX;
    playerY = mouseY;
  } else{
    try {
      bearing = atan2(mouseY-playerY,mouseX-playerX);
      playerX += playerSpeed * cos(bearing);
      playerY += playerSpeed * sin(bearing);
    }
    catch (ArithmeticException e) {}
  }
}

// Not sure if have to check for blob overmove, but just to be safe.

// Moves the blob towards the player
void blobPOS() {
  if (dist(blobX,blobY,playerX,playerY) <= blobSpeed) {
    blobX = playerX;
    blobY = playerY;
  } else {
    try {
      bearing = atan2(playerY-blobY,playerX-blobX);
      blobX += blobSpeed * cos(bearing);
      blobY += blobSpeed * sin(bearing);
    }
    catch (ArithmeticException e) {}
  }
}

// Check if the player grabs coin or if blob grabs player
void collision() {
  if (dist(coinX,coinY,playerX,playerY) <= (coinSize+playerSize)/2) {
    updateCoin();
    updateBlob();
    score++;
  }
  if (dist(blobX,blobY,playerX,playerY) <= (blobSize+playerSize)/2) {
    println("GAME OVER: Score " + score);
    noLoop();
  }
}

/* BUG: Invisible coin? Probably drawn at the borders...
SOLVED: Added checks if the coin is too close to borders
*/

/* BUG: Crashes sometimes when about to grab a coin?
SOLVED: Infinite loop on coinY removed. D'oh.
*/
void updateCoin() {
  coinX = random(0,width);
  while ((coinX+10<coinSize) || (width-coinX-10<coinSize)) {
    coinX = random(0,width);
  }
  coinY = random(0,height);
  while ((coinY+10<coinSize) || (height-coinY-10<coinSize)) {
    coinY = random(0,height);
  }
}

// Idea: Maybe flash the blob? Like it was angry or something.

// Hm, for now the blob just gets a bit faster on each pass.
void updateBlob() {
  blobSpeed += .5;
}

// So these two following functions change the player speed:

/* MousePressed() gets called when the mouse is pressed.
Changes the player speed to go faster.
*/
void mousePressed() {
  playerSpeed = DEFAULT_PLAYER_DASH;
}

/* MouseReleased() gets called when the mouse is no longer pressed.
Changes the player speed back to slow.
*/
void mouseReleased() {
  playerSpeed = DEFAULT_PLAYER_SPEED;
}
