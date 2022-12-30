/*
Generative Art Project: Client server communication demo.
===================================================
*/

import processing.net.Client;
import processing.net.Server;
import java.lang.Thread;

// Declare a server
Server server;

public void setup() {
  thread("handleClientComm");

  size(600, 800);
  noLoop();
}

public void draw() {
  // Draw some placeholder graphics.
  background(#DDDEE6);
  pushMatrix();
  translate(300, 400);
  pushStyle();
  strokeWeight(20);
  fill(#27C0FE);
  stroke(#8DB0E5);
  circle(0, 0, 240);
  stroke(#9ADAEF);
  circle(0, 0, 200);
  popStyle();
  popMatrix();
}


// This method is run from thread, hence public.
public void handleClientComm() {
  // Create the Server on port 5204
  server = new Server(this, 5204); 
  while (true) {
    if (!server.active()) {
      println("Server not yet active ...");
    }
    // Get the next available client
    Client thisClient = server.available();
    // If not client is available skip.
    if (thisClient == null) {
      println("No client found, sleeping ...");
      try {
        Thread.sleep(5000);
      } catch (Exception e) {
        println("Exception in sleep... + " + e);
      }
      continue;
    }
    println("Detected client ... + " + thisClient.ip());
    String whatClientSaid = thisClient.readString();
    if (whatClientSaid == null) {
      continue;
    }
    println("Client said: [" + whatClientSaid + "]");
  }
}
