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
  
  int COUNT = 60;
  int currentCount;
  num countTime = 0;
  num FPS = 0;
  
  Set<int> currentlyPressedKeys = new Set<int>();
  
  Ad(String canvasID, State state) {
    currentCount = COUNT;
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
    
    countTime += elapsed;
    currentCount -= 1;
    
    if(currentCount == 0) {
      num seconds = countTime / 1000.0;
      FPS = 1.0 * COUNT / seconds;
      countTime = 0.0;
      currentCount = COUNT;
    }
    
    state.update(elapsed);
    state.render(ctx);
    window.requestAnimationFrame(update); 
  }
}