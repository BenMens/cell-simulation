PApplet applet = this;

ViewBase rootView;
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

    rootView = new ViewBase(null);
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

    guiController = new GuiController(rootView, bodyModel);
    lastTickTimestamp = millis();
}


void draw() {
    noClip();
    background(255);

    guiController.updateMovement();

    while (millis() - lastTickTimestamp >= millisPerTick) {
        bodyModel.tick();
        lastTickTimestamp += millisPerTick;
    }

    rootView.draw();
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
    rootView.mousePressed(mouseX, mouseY);
}
