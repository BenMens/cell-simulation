PApplet applet = this;

ViewBase rootView;
BodyModel bodyModel;
GuiController guiController;

boolean[] keysPressed = new boolean[128];

ParticleFactory particleFactory = new ParticleFactory();

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

    guiController = new GuiController(null, rootView, bodyModel);

    createFont("courrier.dfont", 24);
}


void draw() {
    noClip();
    background(255);

    bodyModel.loop();

    rootView.draw();
}


void mouseWheel(MouseEvent event) {
    rootView.processScrollEvent(mouseX, mouseY, -event.getCount());
}


void keyPressed() {
    if(key < keysPressed.length) {
        keysPressed[key] = true;
    }

    rootView.processKeyEvent(true, key);
}


void keyReleased() {
    if(key < keysPressed.length) {
        keysPressed[key] = false;
    }

    rootView.processKeyEvent(false, key);
}


void mousePressed() {
    rootView.processMouseButtonEvent(mouseX, mouseY, true, mouseButton);
}


void mouseReleased() {
    rootView.processMouseButtonEvent(mouseX, mouseY, false, mouseButton);
}


void mouseMoved() {
    rootView.processMouseMoveEvent(mouseX, mouseY, pmouseX, pmouseY);
}


void mouseDragged() {
    rootView.processMouseDraggedEvent(mouseX, mouseY, pmouseX, pmouseY);
}
