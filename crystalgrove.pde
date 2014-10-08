import java.util.*;
import toxi.geom.*;
import peasy.*;
PeasyCam g_pCamera;

List<Edge> edges;
List<Pentagon> pentagons;



void setup() {
  size(500, 500, OPENGL);
  frameRate(30);

  g_pCamera = new PeasyCam(this, 0, 0, 0, 100);
  g_pCamera.setMinimumDistance(2);
  g_pCamera.setMaximumDistance(20);
  g_pCamera.setWheelScale(.05);
  
  // Fix the front clipping plane
  float fov = PI/3.0;
  float cameraZ = (height/2.0) / tan(fov/2.0);
  perspective(fov, float(width)/float(height), 
  cameraZ/1000.0, cameraZ*10.0);
  
  g_pCamera.rotateX(-1);
  
  edges = new LinkedList<Edge>();
  pentagons = new LinkedList<Pentagon>();
  
  // Seed the structure with an initial set of edges, that define one pentagonp
  for(int i = 0; i < 5; i++) {
    //we want a pentagon edge to be of length one, so we should scale the hypotenuse here.
    // O/H = sin(a)
    // H = O/sin(a)
    // a = 2*PI/10, O = .5
    final float innerMagnitude = .5/sin(2*PI/10);
    Vec3D A = new Vec3D(cos(2*PI*(i  )/5), sin(2*PI*(i  )/5), 0);
    Vec3D B = new Vec3D(cos(2*PI*(i+1)/5), sin(2*PI*(i+1)/5), 0);
    A.getLimited(innerMagnitude);  // TODO: normalize this first?
    B.getLimited(innerMagnitude);
    edges.add(new Edge(A, B));
  }
}

int countdown = 1;

void draw() {
  background(255,255,255);
  
  List<Edge> newEdges = new LinkedList<Edge>();
  

  // Draw all edges
  pushStyle();
    strokeWeight(1);
    stroke(0,0,0);
    for(Edge edge : edges) {
      line(edge.a.x, edge.a.y, edge.a.z,
           edge.b.x, edge.b.y, edge.b.z);
    }
  popStyle();
  
  // For each intersection, draw the potential edges that could be built on it
  pushStyle();
    for(Edge edgeA : edges) {
      for(Edge edgeB : edges) {
        if(edgeA == edgeB) {
          continue;
        }
      
        Vec3D intersection = edgeA.touches(edgeB);
        if(intersection != null) {
          
          // Draw the intersection point
          strokeWeight(10);
          stroke(0,0,255);
          point(intersection.x, intersection.y, intersection.z);
                    
          final float dihedralAngle = acos(-1/sqrt(5));
          Vec3D C;
          if(edgeA.b == intersection) {
            Vec3D A = edgeA.a.sub(edgeA.b);
            Vec3D B = edgeB.a.sub(edgeB.b);
            C = A.getRotatedAroundAxis(B,dihedralAngle).normalize();
          }
          else {
            Vec3D A = edgeA.b.sub(edgeA.a);
            Vec3D B = edgeB.b.sub(edgeB.a);
            C = A.getRotatedAroundAxis(B,dihedralAngle).normalize();
          }
          
          Edge newEdge = new Edge(C.add(intersection), intersection);
          Boolean duplicate = false;
          for(Edge edge : edges) {
            if(edge.equals(newEdge)) {
              duplicate = true;
              break;
            }
          }
          if(!duplicate) {
            if(countdown > 0) {
              newEdges.add(new Edge(C.add(intersection), intersection));
            }
            
            strokeWeight(2);
            stroke(255,0,0);
            line(intersection.x, intersection.y, intersection.z,
                 intersection.x + C.x, intersection.y + C.y, intersection.z + C.z);
          }
        }
      }
    }
  popStyle();
  
  if(countdown > 0) {
    for(Edge newEdge : newEdges) {
      edges.add(newEdge);
    }
    countdown = countdown - 1;
  }
}

void keyPressed() {
  if(key == 'a') {
    countdown++;
  }
}

//void drawPentagon() {
//  beginShape();
//    for(int i = 0; i < 5; i++) {
//      vertex(cos(2*PI*i/5), sin(2*PI*i/5), 0);
//    }
//  endShape(CLOSE);  
//}

//List<Vec3D> findEdgeIntersections() {
//  List<Vec3D> intersections = new LinkedList<Vec3D>();
//  
//  for(Edge edgeA : edges) {
//    for(Edge edgeB : edges) {
//      if(edgeA == edgeB) {
//        continue;
//      }
//      
//      Vec3D intersection = edgeA.touches(edgeB);
//      if(intersection != null) {
//        intersections.add(intersection);
//        
//      }
//    }
//  }
//  
//  return intersections;
//}
