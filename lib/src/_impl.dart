part of ad;

class Ad {
  CanvasElement canvas;
  CanvasRenderingContext2D ctx;
  
  Ad(String canvasID) {
    canvas = querySelector('#' + canvasID);
    ctx = canvas.getContext('2d');
    
    window.requestAnimationFrame(update);
  }
  
  void update(num dt) {
    print(dt);
    
    ctx.fillStyle = '#00ff00';
    ctx.fillRect(0, 0, 32, 32);
    
    window.requestAnimationFrame(update);
    
  }
}