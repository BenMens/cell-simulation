BodyModel bodyModel;
BodyView bodyView;
BodyController bodyController;


void setup() {
  size(500, 500);
  
  bodyModel = new BodyModel("Marvin");
  bodyView = new BodyView();
  bodyController = new BodyController(bodyModel, bodyView);
}


void draw() {
  background(255);
  
  bodyView.draw();
}
