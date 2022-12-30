public static class FloatRect2D {
    private final float xstart;
    private final float xend;
    private final float ystart;
    private final float yend;

    public FloatRect2D(float xstart, float ystart, float xend, float yend) {
        this.xstart = xstart;
        this.ystart = ystart;
        this.xend = xend;
        this.yend = yend;
    }
    
    @Override
    public String toString() {
      return String.format("[(%f, %f) - (%f, %f)]", xstart, ystart, xend, yend);
    }
}

public static class IntRect2D {
    private final int xstart;
    private final int xend;
    private final int ystart;
    private final int yend;

    public IntRect2D(int xstart, int ystart, int xend, int yend) {
        this.xstart = xstart;
        this.ystart = ystart;
        this.xend = xend;
        this.yend = yend;
    }
    
    @Override
    public String toString() {
      return String.format("[(%d, %d) - (%d, %d)]", xstart, ystart, xend, yend);
    }
}
