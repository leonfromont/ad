part of ad;

abstract class State {
  void render(CanvasRenderingContext2D ctx);
  void update(num dt);
}

class Ad {
  CanvasElement canvas;
  CanvasRenderingContext2D ctx;
  State state;
  
  Ad(String canvasID, State state) {
    canvas = querySelector('#' + canvasID);
    ctx = canvas.getContext('2d');
    this.state = state;
    
    window.requestAnimationFrame(update);
  }
  
  void update(num dt) {
    state.update(dt);
    state.render(ctx);
    window.requestAnimationFrame(update);
    
  }
}