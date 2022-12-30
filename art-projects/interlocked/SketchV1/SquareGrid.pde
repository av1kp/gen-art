import java.util.HashSet;

public static interface GridEventHandler {
};

public class SquareGrid {
  private GridEventHandler eventHandler = null;

  // Board size.
  private final int numrows;
  private final int numcols;
  private final float cellwidth;
  private final float cellheight;
  
  private boolean displaying = false;
  
  // Computed xstart, ystart, xend, ysend.
  private float[] bounds = new float[4];
 
  // Selected cell ids, each id computed as (x * numcols + y)
  private final HashSet<Integer> selectedCellIds = new HashSet<Integer>();
  
  public SquareGrid(int numrows, int numcols, int cellwidth, int cellheight) {
    this.numrows = numrows;
    this.numcols = numcols;
    this.cellwidth = (float) cellwidth;
    this.cellheight = (float) cellheight;
    
    bounds[0] = ((float) width - this.numcols * this.cellwidth) * 0.5;  // x-start
    bounds[1] = ((float) height - this.numrows * this.cellheight) * 0.5;  // y-start
    bounds[2] = bounds[0] + (this.numcols * this.cellwidth);  // x-end.
    bounds[3] = bounds[1] + (this.numrows * this.cellheight);  // y-end.
    
    println("GridSquare bounds: (" + bounds[0] + ", " + bounds[1] + ") - (" + bounds[2] + ", " + bounds[3] + ")"
      + "; rows:" + this.numrows + ", cols:" + this.numcols);
  }

  public void SetEventHandler(GridEventHandler eventHandler) {
    this.eventHandler = eventHandler;
  }
  
  public void ToggleGridLines() {
    displaying = !displaying;
  }

  public void ToggleSelectedCellIds(int[] ids) {
    for (int id : ids) {
      if (id < 0 || id >= (numrows * numcols)) {
        continue;
      }      
      if (selectedCellIds.contains(id)) {
        selectedCellIds.remove(id);
      } else {
        selectedCellIds.add(id);
      }
    }
  }

  public void DrawGridLinesIfEnabled() {
    if (!this.displaying) return;
    float xstart = bounds[0];
    float ystart = bounds[1];
    float xend = bounds[2];
    float yend = bounds[3];
    stroke(126);
    strokeWeight(0.2);
    // Vertical grid lines.
    float x = xstart;
    for (int i = 0; i <= numcols; ++i) {
      line(x, ystart, x, yend);
      x += this.cellwidth;
    }
    // Horizontal grid lines.
    float y = ystart;
    for (int i = 0; i <= numrows; ++i) {
      line(xstart, y, xend, y);
      y += this.cellheight;
    }
  }
  
    public void MaybeDrawSelections() {
      stroke(225, 0, 0);
      strokeWeight(1.5);
      for (int cellid : selectedCellIds) {
        final int[] xyindex = fromIdToCellXYIndex(cellid);
        final float cellxstart = bounds[0] + xyindex[0] * cellwidth;
        final float cellystart = bounds[1] + xyindex[1] * cellheight;
        rect(cellxstart, cellystart, cellwidth, cellheight);
      }
    }
    
    private int[] fromIdToCellXYIndex(int cellid) {
      final int xindex = cellid % numcols;
      final int yindex = int(cellid / numcols);
      return new int[] {xindex, yindex};
    }
    
    public void FillGridCell(int x, int y) {
      float xstart = bounds[0] + x * cellwidth;
      float ystart = bounds[1] + y * cellheight;
      rect(xstart, ystart, cellwidth, cellheight);
    }
};
