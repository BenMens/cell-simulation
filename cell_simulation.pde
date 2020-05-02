BodyModel bodyModel;
BodyController bodyController;
ParticleLayerController particleLayerController;

ViewFactory viewFactory = new DefaultViewFactory();

float scaling;
PVector translation;

boolean[] keysPressed = new boolean[128];
boolean pmousePressed;
float mouseScroll;
float mouseScrollSensetivity = 1.1;
float dragSpeed = 1.2;

int lastTickTimestamp;
int millisBetweenTicks = 1000;


void setup() {
    size(2500, 1545);

    bodyModel = new BodyModel(new PVector(10, 10));
    bodyController = new BodyController(bodyModel);


    particleLayerController = new ParticleLayerController(bodyModel);

    scaling = min(width * 0.009 / (bodyModel.gridSize.x + 0.3), height * 0.009 / (bodyModel.gridSize.y + 0.3));
    translation = new PVector(width * -0.45 / scaling + 15, height * -0.45 / scaling + 15);
}


void draw() {
    background(255);

    updateMovement();

    translate(width * 0.5, height * 0.5);
    scale(scaling);
    translate(translation.x, translation.y);

    if(millis() - lastTickTimestamp >= millisBetweenTicks) {
        bodyController.tick();
        lastTickTimestamp = millis();
    }

    bodyController.bodyView.draw();

    particleLayerController.particleLayerView.draw();
}


void updateMovement() {

    particleLayerController.updateMovement();    

    if(mousePressed) {
        translation.x += (mouseX - pmouseX) * dragSpeed / scaling;
        translation.y += (mouseY - pmouseY) * dragSpeed / scaling;
    }
    if(mouseScroll != 0) {
        scaling *= pow(mouseScrollSensetivity, mouseScroll);
        mouseScroll = 0;
    }

    if(keysPressed['c'] == true) {
        scaling = min(width * 0.009 / (bodyModel.gridSize.x + 0.3), height * 0.009 / (bodyModel.gridSize.y + 0.3));
        translation = new PVector(width * -0.45 / scaling + 15, height * -0.45 / scaling + 15);
    }

    if(translation.x < width * 0.45 / scaling - 10 - bodyModel.gridSize.x * 100) {
        translation.x = width * 0.45 / scaling - 10 - bodyModel.gridSize.x * 100;
    }
    if(translation.x > width * -0.45 / scaling + 10) {
        translation.x = width * -0.45 / scaling + 10;
    }
    if(translation.y < height * 0.45 / scaling - 10 - bodyModel.gridSize.y * 100) {
        translation.y = height * 0.45 / scaling - 10 - bodyModel.gridSize.y * 100;
    }
    if(translation.y > height * -0.45 / scaling + 10) {
        translation.y = height * -0.45 / scaling + 10;
    }

    pmousePressed = mousePressed;
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
