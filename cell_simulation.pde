PApplet applet = this;

BodyModel bodyModel;
GuiController guiController;

boolean[] keysPressed = new boolean[128];
boolean pmousePressed;
float relativeMousePositionX;
float relativeMousePositionY;
float mouseScroll;

int lastTickTimestamp = millis();
int millisBetweenTicks = 25;

void setup() {

    fullScreen(P2D);

    bodyModel = new BodyModel(new PVector(100, 100));

    new CellModel(bodyModel, new PVector(0, 0));

    for (int i = 0; i < 10000; i++) {
        new CellModel(bodyModel, new PVector(floor(random(bodyModel.gridSize.x)), floor(random(bodyModel.gridSize.y))));
    }

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


void mousePressed() {
    guiController.guiView.mousePressed(mouseX, mouseY);
}
