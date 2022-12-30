/*
Handler for client server communication.
*/

import processing.net.Client;
import processing.net.Server;
import java.lang.Thread;

public static class NetworkHandler {
  private static final int SOCKET_PORT = 5204;
   private static boolean DEBUG = false;

  private Server socketServer = null;
  private PApplet applet;

  public NetworkHandler(PApplet parentApplet) {
    socketServer = new Server(parentApplet, SOCKET_PORT);
    this.applet = parentApplet;
  }

  public void HandleEventsLoop() {
    // Wait for server to be ready.
    long loopCounter = 0;
    while (!socketServer.active() && (++loopCounter < 10)) {
      // "Server (socket) not yet active
      SleepIgnoreException(0.5, null);
      continue;
    }
    if (socketServer.active()) {
      println("Server (socket) is ready ...");
    } else {
      println("Server could not be ready ...");
      return;
    }
    loopCounter = 0;
    while (true) {
      ++loopCounter;
      // Get the next available client
      Client thisClient = socketServer.available();
      // If not client is available skip.
      if (thisClient == null) {
        // TODO: Exponential backoff.
        SleepIgnoreException(0.5, "No client found");
        continue;
      }
      println("Detected client ... + " + thisClient.ip());
      HandleClientInteraction(thisClient);
    }
  }

  private void HandleClientInteraction(Client client) {
    String whatClientSaid = client.readString();
    if (whatClientSaid == null) {
      return;
    }
    println("Client said: [" + whatClientSaid + "]");
    ProcessClientData(whatClientSaid);
  }

  private void SleepIgnoreException(float numSeconds, String message) {
    if (DEBUG && message != null) {
      println("[to-sleep]: " + message);
    }
    try {
      Thread.sleep(int(numSeconds * 1000.0));
    } catch (Exception e) {
      println("Exception in sleep... + " + e);
    }
  }
  
  private void ProcessClientData(String payload) {
    ArtWorkData art = ArtWorkData.DeserializeFromJson(applet, payload);
    if (art == null) {
      println("Failed to parse json into art.");
    } else {
      println("Done parse json into art.");
      ArtWorkChannel.AddClientData(art);
    }
  }
};
