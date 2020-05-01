BodyModel bodyModel;


void setup() {
  size(500, 500);
  
  bodyModel = new BodyModel();
}


void draw() {
  background(255);
  
  noStroke();
  fill(0);
  textSize(30);
  textAlign(LEFT, TOP);
  
  text("Hello world!!!!", 0, 0);
}
