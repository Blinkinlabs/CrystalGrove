// Representation of one of the edges of a Pentagon
// Geometically, this is a line and should have magnitude 1
// Topologically, this represents 0 or more edges (with each pentagon forming a node)
class Edge {
  Vec3D a;    // First point. Points are interchangable
  Vec3D b;    // Second point. Points are interchangable
  
  color c;    // Color to draw the edge
//  List<Pentagon> Pentagons;    // List of pentagons that contain this Edge
  
  // Create a new edge
  Edge(Vec3D a_, Vec3D b_) {
    a = a_;
    b = b_;
    
    c = color(0,0,0);
  }
  
  // Test if an edge touches (shares a common endpoint) with another edge
  // Returns the intersection point if they touch, or null if they do not
  Vec3D touches(Edge e) {
    final float SMALL_DISTANCE = .0001; 
    
    if(a.distanceTo(e.a) < SMALL_DISTANCE |
       a.distanceTo(e.b) < SMALL_DISTANCE) {
      return a;
    }
    else if(b.distanceTo(e.a) < SMALL_DISTANCE |
            b.distanceTo(e.b) < SMALL_DISTANCE) {
      return b;
    }
    else {
      return null;
    }
  }
  
  Boolean equals(Edge e) {
    final float SMALL_DISTANCE = .0001; 
    
    if((a.distanceTo(e.a) < SMALL_DISTANCE & b.distanceTo(e.b) < SMALL_DISTANCE)
       | (a.distanceTo(e.b) < SMALL_DISTANCE & b.distanceTo(e.a) < SMALL_DISTANCE)) {
      return true;
    }
    
    return false;
  }
}
