PApplet applet = this;

ViewFactory viewFactory = new DefaultViewFactory();

BodyModel bodyModel;
GuiController guiController;

boolean[] keysPressed = new boolean[128];
float mouseScroll;

int lastTickTimestamp = millis();
int millisBetweenTicks;


void setup() {
    size(2500, 1545, P2D);

    frameRate(60);

    bodyModel = new BodyModel(new PVector(10, 10));
    bodyModel.addCell(new CellModel(new PVector(0, 0)));
    bodyModel.addCell(new CellModel(new PVector(2, 1)));

    guiController = new GuiController(bodyModel);
    lastTickTimestamp = millis();

}


void draw() {
    background(255);

    guiController.updateMovement();

    if (millis() - lastTickTimestamp >= millisBetweenTicks) {
        bodyModel.tick();
        lastTickTimestamp += millisBetweenTicks;
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
