/*
Generative Art Demo: Squiggles demo.
===================================================
*/

public void setup() {
  size(800, 800);
  noLoop();
}

// color[] palette = new color[] {#FFD35C, #FD4A8E, #08A9E5, #f0f0f0 , #202020};

public void draw() {
  int numpoints = 10;
  
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
    float x = radius * cos(theta);
    float y = radius * sin(theta);
    float xcontrol = (radius - 50) * cos(theta + anglestep * 0.3);
    float ycontrol = (radius - 50) * sin(theta + anglestep * 0.3);
    strokeWeight(1);
    circle(xcontrol, ycontrol, 1);
    if (i > 0) {
      bezier(prevx, prevy, prevxcontrol, prevycontrol, xcontrol, ycontrol, x, y);
    }
    prevx = x;
    prevy = y;
    prevxcontrol = xcontrol;
    prevycontrol = ycontrol;
  }
}

float margin = 50;

public class Squiggle {
  private float x;
  private float y;
  float d;
  float amp;
  
  private ArrayList<PVector> circles = new ArrayList(20);
  
  public Squiggle(float x0, float y0) {
    this.x = x0;
    this.y = y0;
    this.circles.add(new PVector(x0, y0));
    this.d = 4;
    this.amp = random(2, 10);
  }
  
  public boolean Move() {
    float theta = atan2(y - height/2, x - width/2) + sin(dist(x, y, width/2, height/2) / amp);
    float r = 1;
    x += r * cos(theta);
    y += r * sin(theta);
    if (this.x < margin || this.x > width-margin || this.y < margin || this.y > height-margin) {
      return false;
    }
    return false;
  }
};
