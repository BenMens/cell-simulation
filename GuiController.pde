class GuiController {
    BodyModel bodyModel;
    ViewBase guiView;
    BodyController bodyController;
    ViewBase bodyContainer;

    boolean pmousePressed;

    final float MAX_SCALE_FACTOR = 1. / 200;
    float scaleMin;
    float scaleMax;

    float mouseScrollSensetivity = 1.1;


    GuiController(BodyModel bodyModel) {
        guiView = new ViewBase();

        bodyContainer = new ViewBase();
        bodyContainer.position = new PVector(20, 20);
        bodyContainer.size = new PVector(700, 700);
        bodyContainer.hasClip = true;

        guiView.addChildView(bodyContainer);

        bodyController = new BodyController(bodyModel);
        bodyContainer.addChildView(bodyController.bodyView);

        scaleMin = bodyContainer.size.x / bodyController.bodyView.size.x;
        scaleMax = bodyContainer.size.x * MAX_SCALE_FACTOR;

        bodyController.bodyView.scale = scaleMin;
        
        bodyController.bodyView.position.x = 0;
        bodyController.bodyView.position.y = 0;
    }


    void updateMovement() {
        if (mousePressed) {
            Rectangle2D bodyViewBoundary = bodyController.bodyView.getClipBoundary();

            if (bodyViewBoundary.contains(mouseX, mouseY)) {
                bodyController.bodyView.position.x += (mouseX - pmouseX);
                bodyController.bodyView.position.y += (mouseY - pmouseY);
            }
        }

        if (mouseScroll != 0) {
            PVector mouseBodyPosPre = bodyController.bodyView.screenPosToViewPos(new PVector(mouseX, mouseY));

            bodyController.bodyView.scale *= pow(mouseScrollSensetivity, mouseScroll);
            bodyController.bodyView.scale = constrain(bodyController.bodyView.scale, scaleMin, scaleMax);

            PVector mouseBodyPosPost = bodyController.bodyView.viewPosToScreenPos(mouseBodyPosPre);

            PVector deltaScreenMove = mouseBodyPosPost.sub(mouseX, mouseY).mult(bodyContainer.composedScale());

            bodyController.bodyView.position.x -= deltaScreenMove.x;
            bodyController.bodyView.position.y -= deltaScreenMove.y;

            mouseScroll = 0;
        }

        if (keysPressed['c'] == true) {
            bodyController.bodyView.scale = scaleMin;
            bodyController.bodyView.position = new PVector(0, 0);
        }

        bodyController.bodyView.position.x = max(bodyController.bodyView.position.x, -bodyController.bodyView.size.x * bodyController.bodyView.scale + 700);
        bodyController.bodyView.position.y = max(bodyController.bodyView.position.y, -bodyController.bodyView.size.x * bodyController.bodyView.scale + 700);

        bodyController.bodyView.position.x = min(bodyController.bodyView.position.x, 0);
        bodyController.bodyView.position.y = min(bodyController.bodyView.position.y, 0);

        pmousePressed = mousePressed;
    }

}
