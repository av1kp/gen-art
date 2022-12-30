/*
Generative Art Project: Client server communication demo.
===================================================
*/

SquareGrid grid;

public void setup() {
  grid = new SquareGrid(64, 64, 8, 8);
  grid.ToggleGridLines();

  // Start all helper threads.
  thread("handleClientComm");

  size(600, 800);
  frameRate(1);
}

ArtWorkData currentArt = null;
public void draw() {
  boolean updated = false;
  ArtWorkData art = ArtWorkChannel.GetClientData();
  println("Recvd art = " + art);
  if (art != null && art != currentArt) {
     println("Replacing prev art -----> " + currentArt);
    currentArt = art;
    updated = true;
  }
  if (updated) {
    DrawArtWork(currentArt);
  } else if (currentArt == null) {
    DrawPlaceholdertGraphics();
  }
}


// This method is run from thread, hence public.
public void handleClientComm() {
  NetworkHandler nwHandler = new NetworkHandler(this);
  nwHandler.HandleEventsLoop();
}

private void DrawPlaceholdertGraphics() {
  // Draw some placeholder graphics.
  background(#DDDEE6);

  float radius = min(width, height) / 3;
  pushMatrix();
  translate(width / 2, height / 2);
  pushStyle();
  strokeWeight(20);
  fill(#27C0FE);
  stroke(#8DB0E5);
  circle(0, 0, radius);
  stroke(#9ADAEF);
  circle(0, 0, radius - 40);
  popStyle();
  popMatrix();
}

color getRandomColor(){
  int r = floor(random(0, 127)) + 32;
  int g = floor(random(0, 127)) + 32;
  int b = floor(random(0, 127)) + 32;
  return color(r, g, b);
}

private void DrawArtWork(ArtWorkData art) {
  background(#DDDEE6);
  noStroke();
  for (ArtWorkData.Block b : art.blocks) {
    color c = getRandomColor();
    fill(c);
    DrawIntRect(b.bound, grid);
    c = lerpColor(c, #EEEEEE, 0.4);
    for (IntRect2D gap : b.gaps) {
      fill(c);
    }
  }

  grid.DrawGridLinesIfEnabled();
  
}

private void DrawIntRect(IntRect2D r, SquareGrid grid) {
  // rect(r.xstart, r.ystart, r.xend - r.xstart, r.yend - r.ystart);
  /*
  for (int x = r.xstart; x <= r.xend; ++x) {
    for (int y = r.ystart; y <= r.yend; ++y) {
      grid.FillGridCell(x, y);
    }
  }*/
  
  for (int x = r.xstart; x <= r.xend; ++x) {
    grid.FillGridCell(x, r.ystart);
    grid.FillGridCell(x, r.ystart + 1);
    //grid.FillGridCell(x, r.ystart + 2);
    grid.FillGridCell(x, r.yend);
    grid.FillGridCell(x, r.yend - 1);
    //grid.FillGridCell(x, r.yend - 2);
  }
  for (int y = r.ystart; y <= r.yend; ++y) {
    grid.FillGridCell(r.xstart, y);
    grid.FillGridCell(r.xstart + 1, y);
    //grid.FillGridCell(r.xstart + 2, y);
    grid.FillGridCell(r.xend, y);
    grid.FillGridCell(r.xend - 1, y);
    //grid.FillGridCell(r.xend - 2, y);
  }
}
