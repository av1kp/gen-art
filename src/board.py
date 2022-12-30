

class Cell:
    def __init__(self, index, xmin, ymin, width, height):
        self.index = index
        self.xmin = xmin
        self.ymin = ymin
        self.xmax = xmin + width
        self.ymax = ymin + height
        self.width = width
        self.height = height


class Board:
     ''' A Board is a grid of cells

     Supports iterate over the cells.'''
     def __init__(self, width, height):
        assert float(width) == width
        assert float(height) == height
        self.width = width
        self.height = height
        self.num_rows = None
        self.num_cols = None
        
     def set_shape(self, num_rows, num_cols):
        self.num_rows = num_rows
        self.num_cols = num_cols

     def all_cells(self):
        assert (self.num_rows is not None)
        assert (self.num_cols is not None)
        width = self.width / self.num_cols
        height = self.height / self.num_rows
        for i in range(self.num_rows):
            y0 = - (self.num_rows * 0.5 * height) + (i * height)
            for j in range(self.num_cols):
                index = [i, j]
                x0 = - (self.num_cols * 0.5 * width) + (j * width)
                c = Cell(index, x0, y0, width, height)
                yield c
        pass
