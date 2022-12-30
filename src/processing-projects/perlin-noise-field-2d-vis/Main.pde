/*
Generative Art Project: Flow field
==============================
*/


public void setup() {
  size(1000, 1200);
  noLoop();
}

public void draw() {
  background(#d5d9ce);
  DrawGrid();
}


private void DrawGrid() {
  int numrows = 50;
  int numcols = 30;
  int cellsize  = 20;
  
  float xstart = ((float) width - numcols * cellsize) * 0.5;  // x-start
  float ystart = ((float) height - numrows * cellsize) * 0.5;  // y-start
  float xend = xstart + numcols * cellsize;
  float yend = ystart + numrows * cellsize;

  // Draw grid lines.
  stroke(126);
  strokeWeight(0.2);
  // Vertical grid lines.
  float x = xstart;
  for (int i = 0; i <= numcols; ++i) {
    line(x, ystart, x, yend);
    x += cellsize;
  }
  // Horizontal grid lines.
  float y = ystart;
  for (int i = 0; i <= numrows; ++i) {
    line(xstart, y, xend, y);
    y += cellsize;
  }
  
  strokeWeight(1);
  y = ystart;
  for (int i = 0; i <= numrows; ++i) {
    x = xstart;
    for (int j = 0; j <= numcols; ++j) {
      // Draw point.
      pushMatrix();
      translate(x, y);
      noStroke();
      fill(#DD0000);
      circle(0, 0, 4.5);
      
      // float r = random(TWO_PI);
      float r = noise(i / 10.0, j / 7.0) * TWO_PI;
      PVector vec = PVectorromAngle(r);
      rotate(vec.heading());
      stroke(#000000);
      line(0, 0, cellsize * 0.6, 0);
      popMatrix();
      x += cellsize;
    }
    y += cellsize;
  }
}
