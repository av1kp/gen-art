/*
Holder of art-work data in transit between client and sketch.
*/

import java.util.concurrent.atomic.AtomicReference;

public static class ArtWorkChannel {
  private static AtomicReference clientData = new AtomicReference();

  public static void AddClientData(ArtWorkData artWork) {
    clientData.set(artWork);
  }

  public static ArtWorkData GetClientData() {
    return (ArtWorkData) clientData.get();
  }
};
