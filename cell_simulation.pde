PApplet applet = this;

BodyModel bodyModel;
GuiController guiController;

boolean[] keysPressed = new boolean[128];
boolean pmousePressed;
float relativeMousePositionX;
float relativeMousePositionY;
float mouseScroll;

int lastTickTimestamp = millis();
int millisPerTick = 20;

void setup() {

    fullScreen(P2D);

    bodyModel = new BodyModel(new PVector(10, 10));

    boolean[][] occupiedSpaces = new boolean[int(bodyModel.gridSize.x)][int(bodyModel.gridSize.y)];
    for (int i = 0; i < 25; i++) {
        for (int j = 0; j < 10; j++) {
            int x = floor(random(bodyModel.gridSize.x));
            int y = floor(random(bodyModel.gridSize.y));

            if (!occupiedSpaces[x][y]) {
                new CellModel(bodyModel, new PVector(x, y));
                occupiedSpaces[x][y] = true;
                break;
            }
        }
    }

    guiController = new GuiController(bodyModel);
    lastTickTimestamp = millis();
}


void draw() {
    background(255);

    guiController.updateMovement();

    while (millis() - lastTickTimestamp >= millisPerTick) {
        bodyModel.tick();
        lastTickTimestamp += millisPerTick;
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
