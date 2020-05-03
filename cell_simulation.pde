PApplet applet = this;

ViewFactory viewFactory = new DefaultViewFactory();

BodyModel bodyModel;
GuiController guiController;

boolean[] keysPressed = new boolean[128];
float mouseScroll;

int lastTickTimestamp;
int millisBetweenTicks = 40;


void setup() {
    size(2500, 1545);

    bodyModel = new BodyModel(new PVector(10, 10));
    bodyModel.addCell(new CellModel(new PVector(0, 0)));
    bodyModel.addCell(new CellModel(new PVector(2, 1)));

    guiController = new GuiController(bodyModel);

}


void draw() {
    background(255);

    guiController.updateMovement();


    if(millis() - lastTickTimestamp >= millisBetweenTicks) {
        bodyModel.tick();
        lastTickTimestamp = millis();
    }

    guiController.guiView.draw();
}


void mouseWheel(MouseEvent event) {
    mouseScroll -= event.getCount();
}


void keyPressed() {
    if(key < keysPressed.length) {
        keysPressed[key] = true;
    }
}


void keyReleased() {
    if(keyPressed) {
        if(key < keysPressed.length) {
            keysPressed[key] = false;
        }
    } else {
        keysPressed = new boolean[128];
    }
}
