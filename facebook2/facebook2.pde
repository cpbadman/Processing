Node[] nodes;
Link[] links;

float mass = 0.3;
float damping = 0.6;
float springConstant = 0.000038;
float charge = 2.5;
boolean nodeSelected;
int currentProp = 0;
PFont h2;
PFont h1;
void setup(){
  //size(700,700,P2D);
  h1 = createFont("Montserrat-ExtraLight.tff",30);
  h2 = createFont("Montserrat-ExtraLight.tff",8);
  textFont(h1);
  fullScreen(P3D);
  pixelDensity(2);
  translate(width/2,height/2);
  background(20);
  //textFont(h1);
  loadData("AliHerbs.json");
  
  colorMode(HSB,100);
  fill(0,80,100,30);
  stroke(50,40,50,10);
  
  
  
  for (Link l: links){
    if(!nodes[l.n1].neighbours.hasValue(l.n2) && nodes[l.n1].name != null){
      nodes[l.n1].addNeighbour(l.n2);
    }
    
    if(!nodes[l.n2].neighbours.hasValue(l.n1) && nodes[l.n2].name != null){
      nodes[l.n2].addNeighbour(l.n1);
    }
    
  }
  
  for(Node n: nodes){
    
  }
}

void draw(){
  
  translate(width/2,height/2);
  
  for (Node n: nodes){
    
    n.update(nodes);
    if(n.name != null){
      n.show();
    }
  }
  background(0);
  for (Link l: links){
    l.update(nodes[l.n1].worldPos,nodes[l.n2].worldPos);
    l.show();
  }
  pushStyle();
  fill(0,0,0,30);
  rect(-width/2,-height/2,width,height);
  popStyle();
  nodeSelected = false;
  for (Node n: nodes){

    if(abs(mouseX- width/2 - n.worldPos.x)<5 && abs(mouseY-height/2 - n.worldPos.y)<5 && nodeSelected == false){
      nodeSelected = true;
      n.show(nodes);
    }
    else if(n.name != null){
      n.show();
    }
    
  }
  
  //noLoop();
}

void keyPressed(){
  switch(key){
    case 'w': 
      switch(currentProp){
        case 0: mass+=0.1; println("mass="+mass);break;
        case 1: damping +=0.01;println("damp="+damping);break;
        case 2: springConstant +=0.000001;println("spring="+springConstant);break;
        case 3: charge += 0.5;println("charge="+charge);break;
      }
      break;
    case 'a': 
      currentProp=constrain(currentProp-1,0,3); 
      println(currentProp);
      break;
    case 's': 
      switch(currentProp){
        case 0: mass-=0.1; println("mass="+mass);break;
        case 1: damping -=0.01;println("damp="+damping);break;
        case 2: springConstant -=0.000001;println("spring="+springConstant);break;
        case 3: charge -= 0.5;println("charge="+charge);break;
      }
      break; 
    case 'd': 
      currentProp=constrain(currentProp+1,0,3);  
      println(currentProp);
      break;
  }
}
  
void mousePressed(){
  for(Node n: nodes){
    if(abs(mouseX- width/2 - n.worldPos.x)<5 && abs(mouseY-height/2 - n.worldPos.y)<5){
      if(n.selected){
        nodeSelected = false;
        n.selected = false;
      }
      else{
        nodeSelected = true;
        n.selected = true;
      }
    }
  }
}
void loadData(String file){
  JSONObject allMyFriends = loadJSONObject(file);
  JSONArray nodesRaw = allMyFriends.getJSONArray("nodes");
  JSONArray linksRaw = allMyFriends.getJSONArray("links");

  nodes = new Node[nodesRaw.size()];
  links = new Link[linksRaw.size()];
  
  for(int i = 0; i<nodesRaw.size();i++){
    nodes[i] = new Node(i, nodesRaw.getJSONObject(i));
  }
  
  for(int i = 0; i<linksRaw.size();i++){
    links[i] = new Link(linksRaw.getJSONObject(i).getInt("source"), linksRaw.getJSONObject(i).getInt("target"));
  }

}
