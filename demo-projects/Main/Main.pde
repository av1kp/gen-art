/*
Generative Art Demo: Fill with lines.
===================================================
*/

public void setup() {
  size(800, 800);
  noLoop();
}

color[] palette = new color[] {#FFD35C, #FD4A8E, #08A9E5, #f0f0f0 , #202020};
int SEED = floor(random(0, 100) * 10000);

public void draw() {
  int numpoints = 150;
  
  final float anglestep = TWO_PI / numpoints;
  final float radius = 350;
  
  translate(400, 400);
  noFill();
  float prevx = 0;
  float prevy = 0;
  float prevxcontrol = 0;
  float prevycontrol = 0;
  for (int i = 0; i <= numpoints; ++i) {
    float theta = i * anglestep;
    float x = radius * cos(theta) * noise(i * 0.02);
    float y = radius * sin(theta) *  noise(i * 0.02);
    
    float xcontrol = x; //(radius - 0) * cos(theta + anglestep * 0);
    float ycontrol = y; //(radius - 0) * sin(theta + anglestep * 0);
    strokeWeight(2);
    //circle(x, y, 5);
    strokeWeight(1);
    //circle(xcontrol, ycontrol, 2);
    
    if (i > 0) {
      bezier(prevx, prevy, prevxcontrol, prevycontrol, xcontrol, ycontrol, x, y);
    }
    prevx = x;
    prevy = y;
    prevxcontrol = xcontrol;
    prevycontrol = ycontrol;
  }
  
  
  // For loop gets repeated till right edge is reached
  /*
  for(int i = 1; i < 11; i++) {
   
    // Updatet x positino and create a new random Y value
    float x = i * 40;
    float y = 100 + 250 * noise(x * 20.0);
    
    // Draw a bezier line from the previous to the current point
    // Comment: replace "15" to adjust the handles
    bezier(prevX, prevY, prevX+15, prevY, x-15, y, x, y);
    
    
    // Make the current point the previous one.
    prevX = x;
    prevY = y;
  }*/
}










private void DrawCell(int i, int j) {
  pushMatrix();
  pushStyle();
  translate(i * 50, j * 50);

  rotate(radians(random(-12, 12)));
  strokeWeight(1);
  stroke(0);
  fill(#27C0FE);
  rect(0, 0, 50, 50);
  fill(#FFFFFF);
  if ((i + j) % 2 == 0) {
    arc(50, 0, 50, 50, HALF_PI, 2 * HALF_PI);
    arc(0, 50, 50, 50, 3 * HALF_PI, 4 * HALF_PI);
  } else {
    arc(0, 0, 50, 50, 0, HALF_PI);
    arc(50, 50, 50, 50, 2 * HALF_PI, 3 * HALF_PI);
  }
  noFill();
  rect(0, 0, 50, 50);
  popStyle();
  popMatrix();  
}
