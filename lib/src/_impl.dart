part of ad;

class Path {
  num dt;
  num currentTime;
  List<Vector> points;
  Vector a, b;
  int a_index = 0;
  bool repeat = true;
  bool active = true;
  
  Path.once(List<Vector> points, num dt) {
    repeat = false;
    
    if(points.length < 2) {
      throw new Exception('must have at least two control points');
    }

    this.points = points;
    this.dt = dt;
    this.currentTime = 0.0;
    this.a = points[0];
    this.b = points[1];
  }

  Path(List<Vector> points, num dt) {
    if(points.length < 2) {
      throw new Exception('must have at least two control points');
    }

    this.points = points;
    this.dt = dt;
    this.currentTime = 0.0;
    this.a = points[0];
    this.b = points[1];
  }

  Vector currentPoint() {
    if(!active) {
      return b;
    }
    
    num t = currentTime / dt;
    return a.lerp(b, t);
  }

  void update(num nextdt) {
    if(!active) {
      return;
    }
    
    currentTime += nextdt;

    if(currentTime > dt) {
      currentTime = 0.0;
      a_index += 1; 
      
      
      if(!repeat && a_index + 1 > points.length - 1) {
        active = false;
        return;
      }
      
      a = points[a_index % points.length];
      b = points[(a_index + 1) % points.length];
    }
  }
}

class Vector {
  num x, y;
  Vector(this.x, this.y);
  
  operator +(Vector other) => new Vector(x + other.x, y + other.y);
  operator -(Vector other) => new Vector(x - other.x, y - other.y);

  Vector lerp(Vector other, num dt) {
    Vector result = new Vector(0, 0);
    result.x = this.x + dt * (other.x - this.x);
    result.y = this.y + dt * (other.y - this.y);
    return result;
  }
}

class Rect {
  num left, top, width, height;

  Rect(this.left, this.top, this.width, this.height);

  num get right             => left + width;
      set right(num value)  => left = value - width;
  num get bottom            => top + height;
      set bottom(num value) => top = value - height;
      
  bool collide(Rect other) {
    bool noverlap = (this.left > other.right || 
                    other.left > this.right || 
                    this.top > other.bottom || 
                        other.top > this.bottom);
    return !noverlap;
  }
}

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
