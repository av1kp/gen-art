import random
import noise
import drawSvg as draw

from board import *


def DrawSampleSVG():
    d = draw.Drawing(200, 200, origin='center', displayInline=False)

    # Bounding box hint rectangle.
    d.append(draw.Rectangle(-100,-100,200,200, fill='rgb(123,123,124)', opacity=0.25))
    d.append(draw.Circle(0, 0, 2, fill='white'))

    # Grid lines.
    # grid_size = 50;
    # Grid lines.
    b = Board(200, 200)
    b.set_shape(20, 20)
    for c in b.all_cells():
        eps = noise.pnoise2(c.index[0], c.index[1], 50)
        print (eps)
        pen = eps
        if pen < 0.5:
            pen = 0.5
        col = 'magenta'
        if (c.index[0] + c.index[1]) % 2 == 0:
            col = 'salmon'
        d.append(draw.Rectangle(c.xmin, c.ymin, c.width, c.height, fill=col, opacity=0.45, stroke_width=pen))
        r: float = random.uniform(0, 1)
        if r <= 0.3:
            d.append(draw.Line(c.xmin, c.ymin, c.xmax, c.ymax, opacity=1, stroke="white", stroke_width=pen))
        elif r <= 0.6:
            d.append(draw.Line(c.xmax, c.ymin, c.xmin, c.ymax, opacity=1, stroke="white", stroke_width=pen))
        elif r <= 0.8:
            d.append(draw.Line(c.xmin, c.ymin, c.xmax, c.ymin, opacity=1, stroke="white", stroke_width=pen))
        else:
            d.append(draw.Line(c.xmin, c.ymin, c.xmin, c.ymax, opacity=1, stroke="white", stroke_width=pen))

    # Draw a rectangle



    # Draw a circle
    d.append(draw.Circle(-40, -10, 30,
                fill='pink', stroke_width=2, stroke='black', opacity=0.01))

    # Draw an arbitrary path (a triangle in this case)
    p = draw.Path(stroke_width=2, stroke='lime',
                fill='black', fill_opacity=0.2)
    p.M(-10, 20)  # Start path at point (-10, 20)
    p.C(30, -10, 30, 50, 70, 20)  # Draw a curve to (70, 20)
    d.append(p)

    # Draw text
    d.append(draw.Text('Basic text', 8, -10, 35, fill='blue'))  # Text with font size 8
    d.append(draw.Text('Path text', 8, path=p, text_anchor='start', valign='middle'))
    d.append(draw.Text(['Multi-line', 'text'], 8, path=p, text_anchor='end'))

    # Draw multiple circular arcs
    d.append(draw.ArcLine(60,-20,20,60,270,
                stroke='red', stroke_width=5, fill='red', fill_opacity=0.2))
    d.append(draw.Arc(60,-20,20,60,270,cw=False,
                stroke='green', stroke_width=3, fill='none'))
    d.append(draw.Arc(60,-20,20,270,60,cw=True,
                stroke='blue', stroke_width=1, fill='black', fill_opacity=0.3))

    d.setPixelScale(5)  # Set number of pixels per geometry unit
    #d.setRenderSize(400,200)  # Alternative to setPixelScale
    d.savePng('example.png')
    d.saveSvg('example.svg')
