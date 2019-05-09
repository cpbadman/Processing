class Node{
  
  //Raw
  JSONObject rawData;
  
  //abstract properties
  int index;
  String id;
  String name;
  String profile;
  
  //Visual
  PVector worldPos;
  PVector vel;
  PVector acc;
  PVector netForce;
  
  //Connectedness
  int nodesInGraph;
  IntList neighbours;
  
  //highlight behaviour
  boolean mouseOver;
  boolean selected;
  
  //Dynamics
  //float mass;
  //float damping;
  //float springConstant;
  //float charge;
  ArrayList<PVector> path;
  
  Node(int idx,JSONObject raw){
    rawData = raw;
    index = idx;
    setAllProps();
    neighbours = new IntList();
    
    //mass = 0.2;
    //damping = 0.5;
    //springConstant = -0.00001;
    //charge = 12;
    
  }
  
  void addNeighbour(int n){
    neighbours.append(n);
  }
  
  void setAllProps(){
    if(rawData != null){
      name = rawData.getString("name");
      id = rawData.getString("id");
      profile = rawData.getString("profile");
    }
    else{
      return;
    }
    worldPos = new PVector(random(-width/2,width/2),random(-height/2,height/2));
    acc = new PVector(0,0);
    vel = new PVector(0,0);
    netForce = new PVector(0,0);
    path = new ArrayList<PVector>();
  }
  
  void update(Node[] nodes){
    if(selected){
      worldPos.x = mouseX-width/2;
      worldPos.y = mouseY-height/2;
    }
    else{
      worldPos.x += vel.x;
      worldPos.y += vel.y;
      vel.x += acc.x;
      vel.y += acc.y;
      worldPos.x = constrain(worldPos.x,10 - width/2,width/2 - 10);
      worldPos.y = constrain(worldPos.y,10 - height/2,height/2 - 10);
      acc=(getForce(nodes).mult(1/mass)).sub(new PVector(vel.x,vel.y).mult(damping));
    }
    
  }
  
  PVector getForce(Node[] nodes){
    PVector repulsion = new PVector(0,0);
    PVector attraction = new PVector(0,0);
    
    for(int i : neighbours){
      Node n = nodes[i];
      PVector offset = new PVector(worldPos.x - n.worldPos.x,worldPos.y - n.worldPos.y);
      
      attraction.add(offset.mult(-1*springConstant));
    }
    for(Node n: nodes){
      PVector offset = new PVector(worldPos.x - n.worldPos.x,worldPos.y - n.worldPos.y);
      PVector invOs;
      float fMag = offset.magSq();
      if(fMag < 3){fMag = 3;}
      offset.normalize();
      offset.mult(charge/fMag);
      invOs = new PVector(offset.x,offset.y);
      
      repulsion.add(invOs);
    }
    PVector wallForce;
    float left = 1/sq(worldPos.x - width/2);
    float right = 1/sq(worldPos.x + width/2);
    float top = 1/sq(worldPos.y - height/2);
    float bottom = 1/sq(worldPos.y - height/2);
    wallForce = new PVector(left-right,top-bottom).mult(charge);
    
    
    return new PVector(attraction.x + repulsion.x + random(-0.01,0.01),attraction.y + repulsion.y + random(-0.01,0.01)).add(wallForce);
  }
  
  void show(Node[] nodes){
    
    if(true){
      pushStyle();
      fill(0,80,80,50);
      stroke(0,80,80,100);
      strokeWeight(2);
      ellipse(worldPos.x,worldPos.y,15,15);
      popStyle();
      pushStyle();
      fill(0,80,100,50);
      stroke(0,80,100,50);
      text(name + " :  " + str(neighbours.size()),10-width/2,40-height/2);
      highlightNeighbours(nodes);
      popStyle();
    }

  }
  
  void show(){
    pushStyle();
    fill(0,40,100,100);
    stroke(0,20,80,100);
    strokeWeight(1);
    ellipse(worldPos.x,worldPos.y,5,5);
    popStyle();
  }
  
  void highlight(){
    

    ellipse(worldPos.x,worldPos.y,7,7);
    
  }
  
  void highlightNeighbours(Node[] n){
    String nbr = "";
    int idx = 0;
    for(int i : neighbours){
      Node ni = n[i];
      ni.highlight();
      nbr = nbr + "\n" + ni.name ;
      line(worldPos.x,worldPos.y,ni.worldPos.x,ni.worldPos.y);
      idx++;
    }
    pushStyle();
    textFont(h2);
    println(nbr);
    text(nbr,10-width/2,50-height/2);
    popStyle();
  }
  
  
  
}
