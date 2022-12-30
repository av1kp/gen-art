/*
Generative Art Demo: Open sketch.
// Source: https://openprocessing.org/sketch/1363850
===================================================
*/

public void setup() {
  size(800, 800);
}

color[] palette = new color[] {#FFD35C, #FD4A8E, #08A9E5, #f0f0f0 , #C0C020};
final int n = 24;

public void draw() {
  noStroke();
  float t = -TWO_PI * frameCount / 600;
  translate(width / 2 + 80 * cos(-t), height / 2 + 80 * sin(-t));

  final float thetaStep = TWO_PI / n;
  int i = 0;
  for (float theta = 0; theta < TWO_PI + thetaStep; theta += thetaStep) {
    if (theta < TWO_PI) {
      fill(palette[i % palette.length]);
      arc(0, 0, width * 2, width * 2, theta, theta + thetaStep);
    }
    float r = 20 + sq((cos(t + theta + PI)+1)/2)*150;
    println(r);
    float d = map(r, 20, 185, 7, 55);
    fill(palette[(i+1) % palette.length]);
    arc(r * cos(theta), r * sin(theta), d, d, 2 * theta, 2 * theta + PI);
    fill(palette[(i+2) % palette.length]);
    arc(r * cos(theta), r * sin(theta), d, d, 2 * theta + PI, 2 * theta);
    i++;
    
    
  }
}
