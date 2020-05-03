class GuiController {
    float mouseScrollSensetivity = 1.1;

    BodyModel bodyModel;

    ViewBase guiView;

    BodyController bodyController;
    ViewBase bodyContainer;

    PVector totalGridSize;
    boolean pmousePressed;

    float scaleMin;
    float scaleMax;
    float dragCompensation;

    GuiController(BodyModel bodyModel) {
        guiView = new ViewBase();

        bodyContainer = new ViewBase();
        guiView.addChildView(bodyContainer);

        bodyController = new BodyController(bodyModel);
        bodyContainer.addChildView(bodyController.bodyView);

        bodyContainer.clipSize = new PVector(500, 500);
        bodyContainer.position = new PVector(20, 20);

        totalGridSize = PVector.mult(bodyModel.gridSize, 100);

        scaleMin = bodyContainer.clipSize.x / (totalGridSize.x + 20);
        scaleMax = bodyContainer.clipSize.x * 25 / (totalGridSize.x + 20);
        dragCompensation = (totalGridSize.x + 20) / bodyContainer.clipSize.x;


        bodyController.bodyView.scale = scaleMin;
        
        bodyController.bodyView.position.x = 0;
        bodyController.bodyView.position.y = 0;

    }

    void updateMovement() {

        if (mousePressed) {
            bodyController.bodyView.position.x += (mouseX - pmouseX) * dragCompensation / bodyController.bodyView.scale;
            bodyController.bodyView.position.y += (mouseY - pmouseY) * dragCompensation / bodyController.bodyView.scale;
        }

        if (mouseScroll != 0) {
            bodyController.bodyView.scale *= pow(mouseScrollSensetivity, mouseScroll);
            bodyController.bodyView.scale = constrain(bodyController.bodyView.scale, scaleMin, scaleMax);

            mouseScroll = 0;
        }

        if (keysPressed['c'] == true) {
            bodyController.bodyView.scale = scaleMin;
            bodyController.bodyView.position = new PVector(0, 0);
        }

        pmousePressed = mousePressed;
        
    }

}
