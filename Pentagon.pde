class Pentagon {
  PVector center;      // Center of the pentagon
  List<Edge> edges;    // list of edges that make up the pentagon
  
  Pentagon() {
    edges = new LinkedList<Edge>();
  }
  
  void draw() {
    beginShape();
      for(Edge e : edges) {
        vertex(e.a.x, e.a.y, e.a.z);
      }
    endShape(CLOSE);  
  }
}

