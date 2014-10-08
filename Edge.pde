// Representation of one of the edges of a Pentagon
// Geometically, this is a line and should have magnitude 1
// Topologically, this represents 0 or more edges (with each pentagon forming a node)
class Edge {
  Vec3D a;    // First point. Points are interchangable
  Vec3D b;    // Second point. Points are interchangable
//  List<Pentagon> Pentagons;    // List of pentagons that contain this Edge
  
  // Create a new edge
  Edge(Vec3D a_, Vec3D b_) {
    a = a_;
    b = b_;
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
  
//  // Get a cross product for the two edges.
//  // Returns a cross vector if they touch, or null if they do not
//  Vec3D cross(Edge e) {
//    Vec3D touches = touches(e);
//    if(touches == null) {
//      return touches;
//    }
//    
//    Vec3D A = a.sub(b);
//    Vec3D B = e.a.sub(e.b);
//    return A.cross(B);
//  }
//  
//  // Calculate a normal vector for the intersection of two edges.
//  // Returns a normal vector if they touch, or null if they do not
//  Vec3D normal(Edge e) {
//    Vec3D touches = touches(e);
//    if(touches == null) {
//      return touches;
//    }
//    
//    Vec3D A = a.sub(b);
//    Vec3D B = e.a.sub(e.b);
//    if(a == touches) {
//      return A.sub(B);
//    }
//    else {
//      return B.sub(A);
//    }
//  }
//  
//  Vec3D dihedralSprue(Edge e) {
//    Vec3D touches = touches(e);
//    if(touches == null) {
//      return touches;
//    }
//    
//    Vec3D normal = normal(e);
//    Vec3D cross = cross(e);
//    normal.normalize();
//    cross.normalize();
//    
//    // TODO: replace with matrix code for rotating a vector about another vector.
//    //normal.div(1.6180335);  // determined experimentally, by printing out the angle.
//    normal = normal.getLimited(0.6180341754);
//    
//    Vec3D rotated = normal.sub(cross);
//    rotated.normalize();
//    
////    if(a == touches) {
////      println(degrees(Vec3D.angleBetween(rotated, Vec3D.sub(b, a))));
////    }
////    else {
////      println(degrees(Vec3D.angleBetween(rotated, Vec3D.sub(a, b))));
////    }    
//    return rotated;
//  }
}
