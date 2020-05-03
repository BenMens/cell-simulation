PApplet applet = this;

BodyModel bodyModel;
BodyController bodyController;

ViewFactory viewFactory = new DefaultViewFactory();

PVector totalGridSize;
float baseScaling;
float scaling;
PVector baseTranslation;
PVector translation;

boolean[] keysPressed = new boolean[128];
boolean pmousePressed;
float mouseScroll;
float mouseScrollSensetivity = 1.1;
float dragSpeed = 1.2;

int lastTickTimestamp;
int millisBetweenTicks = 40;


void setup() {
    size(2500, 1545);

    bodyModel = new BodyModel(new PVector(10, 10));
    bodyController = new BodyController(bodyModel);

    totalGridSize = PVector.mult(bodyModel.gridSize, 100);
    baseScaling = min(width * 0.9 / (totalGridSize.x + 30), height * 0.9 / (totalGridSize.y + 30));
    scaling = baseScaling;
    baseTranslation = new PVector(width * -0.45 / scaling + 15, height * -0.45 / scaling + 15);
    translation = baseTranslation;
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
}


void updateMovement() {

    if(mousePressed) {
        translation.x += (mouseX - pmouseX) * dragSpeed / scaling;
        translation.y += (mouseY - pmouseY) * dragSpeed / scaling;
    }
    if(mouseScroll != 0) {
        scaling *= pow(mouseScrollSensetivity, mouseScroll);
        scaling = constrain(scaling, baseScaling * 0.8, baseScaling * 25);

        mouseScroll = 0;
    }

    if(keysPressed['c'] == true) {
        scaling = baseScaling;
        translation = baseTranslation;
    }

    if(translation.x < width * 0.45 / scaling - 10 - totalGridSize.x) {
        translation.x = width * 0.45 / scaling - 10 - totalGridSize.x;
    }
    if(translation.x > width * -0.45 / scaling + 10) {
        translation.x = width * -0.45 / scaling + 10;
    }
    if(translation.y < height * 0.45 / scaling - 10 - totalGridSize.y) {
        translation.y = height * 0.45 / scaling - 10 - totalGridSize.y;
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
