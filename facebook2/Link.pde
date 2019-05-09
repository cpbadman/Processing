class Link{
  
  int n1;
  int n2;
  
  PVector p1;
  PVector p2;
  
  Link(int n1, int n2){
    this.n1 = n1;
    this.n2 = n2;
  }
  
  void update(PVector p1, PVector p2){
    this.p1 = p1;
    this.p2 = p2;
  }
  
  void show(){
    line(p1.x,p1.y,p2.x,p2.y);
  }
}
