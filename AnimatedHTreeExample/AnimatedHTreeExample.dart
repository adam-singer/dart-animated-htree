#import('dart:html');
#source('Line.dart');
// http://introcs.cs.princeton.edu/java/23recursion/AnimatedHtree.java.html
class AnimatedHTreeExample {
  List<Line> lines;
  CanvasRenderingContext2D context;
  CanvasElement canvas;
  var xmin = 0;
  var xmax = 0;
  var ymin = 0;
  var ymax = 0;
  num drawLineIndex = 0; 
  num N = 5;
  num drawSpeed = 25;
  int intervalId;
  InputElement stopStartButton;
  AnimatedHTreeExample() {
  }

  scaleX(double x) { return canvas.width  * (x - xmin) / (xmax - xmin); }
  scaleY(double y) { return canvas.height * (ymax - y) / (ymax - ymin); }
  
  
  void run() {
    InputElement iterationsInput = document.query('#iterationsInput');
    InputElement drawSpeedInput = document.query('#drawSpeedInput');
    stopStartButton = document.query('#StopStart');
    lines = new List<Line>();
    canvas = document.query('#canvas');
    
    xmax = canvas.width;
    ymax = canvas.height;
   

    context = canvas.getContext('2d');
    
    iterationsInput.on.change.add((var event) {
      if (iterationsInput.valueAsNumber>0) {
        N = iterationsInput.valueAsNumber;
      }
    }, false);
    drawSpeedInput.on.change.add((var event) {
      if (drawSpeedInput.valueAsNumber>0) {
        drawSpeed = drawSpeedInput.valueAsNumber;
      }
    }, false);
    stopStartButton.on.click.add((var event) {
      
      context.clearRect(0, 0, canvas.width, canvas.height);
      draw(N, xmax/2, ymax/2, xmax/2);
      intervalId = window.setInterval(() {
        drawLine();
      }, drawSpeed);
      
      stopStartButton.disabled = true;
    }, false);
  }
  
  
  drawLine() {
    if (drawLineIndex < lines.length) {
      context.beginPath();
      context.moveTo(lines[drawLineIndex].x0, lines[drawLineIndex].y0);
      context.lineTo(lines[drawLineIndex].x1, lines[drawLineIndex].y1);
      context.stroke();
      drawLineIndex++;
    }
    else {
      drawLineIndex = 0;
      lines.clear();
      window.clearInterval(intervalId);
      stopStartButton.disabled = false;
    }
  }
  
  line(var x0, y0, x1, y1) {
    lines.add(new Line(scaleX(x0), scaleY(y0), scaleX(x1), scaleY(y1)));
  }
  
  draw(var n, var x, var y, var size) {
    if (n == 0) {
      return;
    }
    
    var x0 = x - size / 2;
    var x1 = x + size / 2;
    var y0 = y - size / 2;
    var y1 = y + size / 2;
    
    // draw the H, centered on (x, y) of the given side length
    line(x0,  y, x1,  y);
    line(x0, y0, x0, y1);
    line(x1, y0, x1, y1);
    
    draw(n-1, x0, y0, size/2);   // lower left
    draw(n-1, x0, y1, size/2);   // upper left
    draw(n-1, x1, y0, size/2);   // lower right
    draw(n-1, x1, y1, size/2);   // upper right
  }
}

void main() {
  new AnimatedHTreeExample().run();
}
