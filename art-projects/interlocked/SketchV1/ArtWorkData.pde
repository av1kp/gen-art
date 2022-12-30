/*
The data specifying the artwork.
*/

public static class ArtWorkData {
  public static class Block {
    private IntRect2D bound;
    private IntRect2D[] gaps;
  };
 
  private String id;
  private Block[] blocks;

  public static ArtWorkData DeserializeFromJson(PApplet applet, String jsonString) {
    JSONObject json = applet.parseJSONObject(jsonString);
    if (json == null) {
      println("JSONObject could not be parsed");
      return null;
    }
    ArtWorkData result = new ArtWorkData();
    try {
      result.blocks = parseBlocks(json.getJSONArray("blocks"));
    } catch (NullPointerException e) {
      println("NPE parsing payload: " + jsonString);
      return null;
    }
    return result;
  }

  private static Block[] parseBlocks(JSONArray jsons) {
    final int size = jsons.size();
    Block[] result = new Block[size];
    for (int i = 0; i < size; ++i) {
      result[i] = parseBlock(jsons.getJSONObject(i));
    }
    return result;
  }

  private static Block parseBlock(JSONObject json) {
    Block result = new Block();
    result.bound = parseCompactIntRect(json.getString("bound"));
    result.gaps = parseListOfIntRects(json.getJSONArray("gaps"));
    return result;
  }

  private static IntRect2D[] parseListOfIntRects(JSONArray jsons) {
    final int size = jsons.size();
    IntRect2D[] result = new IntRect2D[size];
    for (int i = 0; i < size; ++i) {
      result[i] = parseCompactIntRect(jsons.getString(i));
    }
    return result;
  }

  private static IntRect2D parseCompactIntRect(String compactRep) {
    String[] parts = compactRep.split(",");
    int[] values = new int[parts.length];
    for (int i = 0; i < parts.length; ++i) {
      values[i] = Integer.parseInt(parts[i]);
    }
    return new IntRect2D(values[0], values[1], values[2], values[3]);
  }

};
