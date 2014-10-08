class Pentagon {
  PVector center;    // Center of the pentagon
  Edge edges[];      // list of edges that make up the pentagon
  
  Pentagon() {
    edges = new Edge[5];
  }
  
  void draw(int i) {
  }
}



//class Pentagon {  
//  // TODO: Make this like a database, use world coordinates?
//  Pentagon sides[];  // These are the children of the main pentagon.
//  int direction;  // 0 = positive, 1 = negative
//  
//  Pentagon(int d) {
//    direction = d;
//    sides = new Pentagon[5];
//  }
//  
//  // Fill the pentagon with children, and it's n children with children.
//  void addRandomChildren(int depth) {
//    for(int i = 0; i < 5; i++) {
//      if (random(8) < 2) {
//      if(sides[i] == null) {
//        sides[i] = new Pentagon(int(random(2)));
//        if(depth > 0) {
//          sides[i].addRandomChildren(depth - 1);
//        }
//      }
//      }
//    }
//  }
//  
//  // Add one random child, somewhere.
//  void addRandomChild() {
//    int i = int(random(5));
//    if(sides[i] == null) {
//      sides[i] = new Pentagon(int(random(2)));
//    }
//    else {
//      sides[i].addRandomChild();
//    }
//  }
//  
//  // Draw the pentagon and it's children
//  void draw(int depth) {
//    final float circumscribedRadius = 1; 
//    final float inscribedRadius = circumscribedRadius*cos(2*PI/10);
//    final float dihedralAngle = acos(-1/sqrt(5));
//    
//    strokeWeight(1);
//    fill(depth*30,0,0);
//    drawPentagon();
//    
//    
//    for(int i = 0; i < 5; i++) {
//      if(sides[i] != null) {
//        
//        pushMatrix();
//          rotate(2*PI/10 + 2*PI*i/5, 0,0,1);  // align to correct outlet on parent pentagon
//          translate(inscribedRadius,0,0);                 // and push off from the center
//      
//          if (sides[i].direction == 0) {
//            rotate(dihedralAngle,0,1,0);         // then rotate to make the correct angle
//          }
//          else {
//            rotate(-dihedralAngle,0,1,0);         // then rotate to make the correct angle
//          }
//          
//          translate(-inscribedRadius,0,0);                 // and push upwards
//      
//          rotate(2*PI/10, 0,0,1);
//          sides[i].draw(depth+1);
//    
//        popMatrix();
//      }
//    }
//  }
//}
