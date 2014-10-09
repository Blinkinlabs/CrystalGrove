import java.util.*;
import toxi.geom.*;
import peasy.*;
PeasyCam g_pCamera;

// Display variables
boolean displayEdges = true;
boolean displayNodes = true;
boolean displayEdgeCandidates = false;
boolean displayPentagonCandidates = false;
boolean displayPentagons = true;

List<Edge> edges;
List<Pentagon> pentagons;

// True if the list contains the specificed edge
// TODO: Use a container that has this built in?
// TODO: Not a global variable here.
boolean listContains(List<Edge> edges, Edge newEdge) {
  boolean duplicate = false;
  for(Edge edge : edges) {
    if(edge.equals(newEdge)) {
      return true;
    }
  }
  return false;
}

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
  
  resetWorld();
}

// Reset to some default state
void resetWorld() {
  edges = new LinkedList<Edge>();
  pentagons = new LinkedList<Pentagon>();
  
  // Seed the structure with an initial set of edges, that define one pentagonp
  for(int i = 0; i < 5; i++) {
    //we want a pentagon edge to be of length one, so we should scale the hypotenuse here.
    // O/H = sin(a)
    // H = O/sin(a)
    // a = 2*PI/10, O = .5
    final float innerMagnitude = .5/sin(2*PI/10);
    Vec3D A = new Vec3D(cos(2*PI*(i  )/5), sin(2*PI*(i  )/5), 0).getNormalizedTo(innerMagnitude);
    Vec3D B = new Vec3D(cos(2*PI*(i+1)/5), sin(2*PI*(i+1)/5), 0).getNormalizedTo(innerMagnitude);
    edges.add(new Edge(A, B));
  }
}

// Construct a pentagon given two of it's edges
// Note that the edges have to be congruent, and with the proper angle.
Pentagon constructPentagon(Edge first, Edge second) {
  // Find the centerpoint
  Vec3D intersection = first.touches(second);
  if(intersection == null) {
    return null;
  }
  
  // Try to fix the orientation. This probably has bugs.
  Vec3D A;
  Vec3D B;

  if(first.b == intersection) {
    A = first.a.sub(first.b);
  }
  else {
    A = first.b.sub(first.a).getInverted();
  }
  
  if(second.b == intersection) {
    B = second.a.sub(second.b);
  }
  else {
    B = second.b.sub(second.a).getInverted();
  }
  
  // Reject this pairing if the angle between the nodes is not correct
  final float betweenAngle = (2*(PI/2 - 2*PI/10));
  final float SMALL_AMOUNT = .0001;
  if(abs(A.angleBetween(B) - betweenAngle) > SMALL_AMOUNT) {
    return null;
  }
  
  // First, take the cross product of the two edges to find the normal to the pentagon surface
  Vec3D cross = A.cross(B).normalize();
  
  // Now, rotate one of the original edges about the normal so that its end lands in the center of the pentagon.
  final float centerRotateAngle = PI/2 - (2*PI/10);
  final float innerMagnitude = .5/sin(2*PI/10);
  Vec3D centerline = A.getRotatedAroundAxis(cross, centerRotateAngle).getNormalizedTo(innerMagnitude);
  
  // Use that to calculate the center of the pentagon
  Vec3D center = intersection.add(centerline);
  
  Pentagon newPentagon = new Pentagon();
  
  final float rotationAngle = 2*PI/5;
  for(float i = 0; i < 5; i++) {
    // Now that we have those, we can rotate one of the original edges about the center point.
    
    Vec3D pointA = second.a.sub(center).getRotatedAroundAxis(cross, rotationAngle*i).add(center);
    Vec3D pointB = second.b.sub(center).getRotatedAroundAxis(cross, rotationAngle*i).add(center);
    newPentagon.edges.add(new Edge(pointA, pointB));
  
    if(displayPentagonCandidates) {
      strokeWeight(2);
      stroke(0,200,200);
      line(pointA.x, pointA.y, pointA.z,
           pointB.x, pointB.y, pointB.z);
    }
  }
  
  return newPentagon;
}

int depthCount = 0;  // Number of iterations to build the edge structures

void draw() {
  background(255,255,255);
  
  // Draw all edges
  if(displayEdges) {
    pushStyle();
      strokeWeight(1);
      stroke(0,0,0);
      for(Edge edge : edges) {
        line(edge.a.x, edge.a.y, edge.a.z,
             edge.b.x, edge.b.y, edge.b.z);
      }
    popStyle();
  }
  
  // Draw all pentagons
  if(displayPentagons) {
    pushStyle();
      strokeWeight(1);
      fill(100,130,250);
      for(Pentagon pentagon : pentagons) {
        pentagon.draw();
      }
    popStyle();
  }
  
  List<Pentagon> newPentagons = new LinkedList<Pentagon>();
  
  List<Edge> newEdges = new LinkedList<Edge>();
  List<Edge> newPentagonEdges = new LinkedList<Edge>();
  
  // For each intersection, draw the potential edges that could be built on it
  pushStyle();
    for(Edge edgeA : edges) {
      for(Edge edgeB : edges) {
        // If the two edges share an endpoint
        Vec3D intersection = edgeA.touches(edgeB);
        if(intersection == null) {
          continue;
        }
          
        // Draw the intersection point
        if(displayNodes) {
          strokeWeight(10);
          stroke(0,0,255);
          point(intersection.x, intersection.y, intersection.z);
        }
        
        println(edgeA.pentagons.size());
        if(edgeA.pentagons.size() > 1 | edgeB.pentagons.size() > 1) {
          strokeWeight(10);
          stroke(255,0,255);
          point(intersection.x, intersection.y, intersection.z);
          continue;
        }
          
        // Rotate one of the edges about the axis of the other, to form a potential new edge.
        // We rotate to the dihedral angle, because we want to form surfaces that follow
        // the same packing as a natural dodecahedron. Note there are multiple solutions for many
        // of the positions. 
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
        
        // C now contains a vector displacement from the intersection of the two original
        // edges to one of the new ones. We now form a new edge by translating it to the
        // location of the intersection point.
        Edge newEdge = new Edge(C.add(intersection), intersection);
        
        // The edge might be a duplicate, though- if it is, discard it immediately.
        // Otherwise we can schedule it for future addition. Note that we have to check
        // both current edges and new edges, because it's possible to generate the same
        // new edge twice.
        // TODO: It's possible that in the case of a corner, this might not be true.
        if(listContains(edges, newEdge) | listContains(newEdges, newEdge)) {
          continue;
        }
        
        newEdges.add(new Edge(C.add(intersection), intersection));
        
        if(displayEdgeCandidates) {
          strokeWeight(2);
          stroke(255,0,0);
          line(intersection.x, intersection.y, intersection.z,
               intersection.x + C.x, intersection.y + C.y, intersection.z + C.z);
        }
             
        // There are potentially two pentagons that we can construct using the new
        // edge and one of the two original edges. To do so, let's find the center of the potential
        // pentagon first, then rotate a construction line around it to find the edges.
        // Later we will need to fill these in as triangles and perform collision detection against
        // the existing pentagons.         
        Pentagon newPentagon;
       
        newPentagon = constructPentagon(edgeA, newEdge);
        
        // Now, add the new edges to the list if they don't already exist...
        if(depthCount > 0) {
          if(newPentagon != null) {
            newPentagons.add(newPentagon);
            
            for(Edge pentagonEdge : newPentagon.edges) {
              if(!listContains(edges, pentagonEdge)
               & !listContains(newPentagonEdges, pentagonEdge)) {
                 newPentagonEdges.add(pentagonEdge);
               }
            }
          }
        }
        
        newPentagon = constructPentagon(edgeB, newEdge);
        
        // Now, add the new edges to the list if they don't already exist...
        if(depthCount > 0) {
          if(newPentagon != null) {
            newPentagons.add(newPentagon);
            
            for(Edge pentagonEdge : newPentagon.edges) {
              if(!listContains(edges, pentagonEdge)
               & !listContains(newPentagonEdges, pentagonEdge)) {
                 newPentagonEdges.add(pentagonEdge);
               }
            }
          }
        }
      }
    }
  popStyle();
  
  if(depthCount > 0) {
    for(Edge newPentagonEdge : newPentagonEdges) {
      edges.add(newPentagonEdge);
    }
    
    for(Pentagon newPentagon : newPentagons) {
      pentagons.add(newPentagon);
      for(Edge edge : newPentagon.edges) {
        edge.pentagons.add(newPentagon);
      }
    }
    
    depthCount = depthCount - 1;
  }
}

void keyPressed() {
  if(key == '`') {
    resetWorld();
  }
  if(key == 'a') {
    depthCount++;
  }
  if(key == '1') {
    displayEdges = !displayEdges;
  }
  if(key == '2') {
    displayNodes = !displayNodes;
  }
  if(key == '3') {
    displayPentagonCandidates = !displayPentagonCandidates;
  }
  if(key == '4') {
    displayEdgeCandidates = !displayEdgeCandidates;
  }
  if(key == '5') {
    displayPentagons = !displayPentagons;
  }
}

