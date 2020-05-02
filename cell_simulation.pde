BodyModel bodyModel;
BodyController bodyController;
ParticleLayerController particleLayerController;

ViewFactory viewFactory = new DefaultViewFactory();

float scaling = 1;
PVector translation = new PVector(0, 0);

boolean[] keysPressed = new boolean[128];

int lastMovementUpdateTimestamp;
int lastTickTimestamp;
int millisBetweenMovementUpdates = 40;
int millisBetweenTicks = 1000;


void setup() {
    size(2500, 1545);

    bodyModel = new BodyModel(new PVector(10, 10));

    bodyController = new BodyController(bodyModel);

    particleLayerController = new ParticleLayerController(bodyModel);
}


void draw() {
    background(255);
    translate(translation.x, translation.y);
    scale(scaling);

    if(millis() - lastMovementUpdateTimestamp >= millisBetweenMovementUpdates) {
        updateMovement();
        lastMovementUpdateTimestamp = millis();
    }

    if(millis() - lastTickTimestamp >= millisBetweenTicks) {
        bodyController.tick();
        lastTickTimestamp = millis();
    }

    bodyController.bodyView.draw();

    particleLayerController.particleLayerView.draw();
}


void updateMovement() {
    particleLayerController.updateMovement();    
}


void keyPressed(int key) {
    if(key < keysPressed.length) {
        keysPressed[key] = true;
    }
}


void keyReleased(int key, boolean keyPressed) {
    if(keyPressed) {
        if(key < keysPressed.length) {
            keysPressed[key] = false;
        }
    } else {
        keysPressed = new boolean[128];
    }
}
