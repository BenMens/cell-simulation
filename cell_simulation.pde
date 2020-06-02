PApplet applet = this;

ViewBase rootView;
BodyModel bodyModel;
GuiController guiController;

boolean[] keysPressed = new boolean[128];

ParticleFactory particleFactory = new ParticleFactory();

void setup() {

    fullScreen(P2D);

    rootView = new ViewBase(null);
    rootView.hasBackground = true;
    rootView.backgroundColor = color(255);
    bodyModel = new BodyModel(new PVector(10, 10));

    guiController = new GuiController(null, rootView, bodyModel);

    createFont("courrier.dfont", 24);

    frameRate(30);
}


void draw() {
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
