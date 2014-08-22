part of ad;

abstract class State {
  Ad parent;
  void render(CanvasRenderingContext2D ctx);
  void update(num dt);
}

class Ad {
  CanvasElement canvas;
  CanvasRenderingContext2D ctx;
  State state;
  num last = null;
  
  Set<int> currentlyPressedKeys = new Set<int>();
  
  Ad(String canvasID, State state) {
    canvas = querySelector('#' + canvasID);
    ctx = canvas.getContext('2d');
    this.state = state;
    this.state.parent = this;
    
    // Hook into the window's onKeyDown and onKeyUp streams to track key states
    window.onKeyDown.listen((KeyboardEvent event) {
      currentlyPressedKeys.add(event.keyCode);
    });

    window.onKeyUp.listen((event) {
      currentlyPressedKeys.remove(event.keyCode);
    });
    
    window.requestAnimationFrame(update);
  }
  
  void update(num dt) {
    if(last == null) {
      last = dt;
    }
    
    num elapsed = dt - last;
    last = dt;
    
    state.update(elapsed);
    state.render(ctx);
    window.requestAnimationFrame(update); 
  }
}