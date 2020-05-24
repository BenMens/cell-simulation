import java.awt.geom.Rectangle2D;


class GuiController {
    BodyModel bodyModel;
    BodyController bodyController;
    ViewBase bodyContainer;

    boolean pmousePressed;

    final float MAX_SCALE_FACTOR = 1. / 200;
    float scaleMin;
    float scaleMax;

    float mouseScrollSensetivity = 1.1;


    GuiController(ViewBase parentView, BodyModel bodyModel) {
        bodyContainer = new ViewBase(parentView);
        bodyContainer.frameRect = new Rectangle2D.Float(20, 20, 700, 700);
        bodyContainer.boundsRect = new Rectangle2D.Float(0, 0, 700, 700);
        bodyContainer.hasClip = true;

        bodyController = new BodyController(bodyContainer, bodyModel);

        scaleMin = bodyContainer.frameRect.width / bodyController.bodyView.frameRect.width;
        scaleMax = bodyContainer.frameRect.width * MAX_SCALE_FACTOR;

        bodyController.bodyView.setScale(scaleMin);
    }


    void updateMovement() {
        if (mousePressed) {
            Rectangle2D bodyViewBoundary = bodyController.bodyView.getClipBoundary();

            if (bodyViewBoundary.contains(mouseX, mouseY)) {
                bodyController.bodyView.frameRect.x += (mouseX - pmouseX);
                bodyController.bodyView.frameRect.y += (mouseY - pmouseY);
            }
        }

        if (mouseScroll != 0) {
            PVector mouseBodyPosPre = bodyController.bodyView.screenPosToViewPos(new PVector(mouseX, mouseY));

            PVector scale = bodyController.bodyView.getScale();
            
            scale.x *= pow(mouseScrollSensetivity, mouseScroll);
            bodyController.bodyView.setScale(constrain(scale.x, (float)scaleMin, (float)scaleMax));

            PVector mouseBodyPosPost = bodyController.bodyView.viewPosToScreenPos(mouseBodyPosPre);

            PVector deltaScreenMove = mouseBodyPosPost.sub(mouseX, mouseY);
            
            deltaScreenMove.x *= bodyContainer.composedScale().x;
            deltaScreenMove.y *= bodyContainer.composedScale().y;

            bodyController.bodyView.frameRect.x -= deltaScreenMove.x;
            bodyController.bodyView.frameRect.y -= deltaScreenMove.y;

            mouseScroll = 0;
        }

        if (keysPressed['c'] == true) {
            bodyController.bodyView.setScale(scaleMin);
            bodyController.bodyView.frameRect.x = 0;
            bodyController.bodyView.frameRect.y = 0;
        }

        PVector scale = bodyController.bodyView.getScale();

        bodyController.bodyView.frameRect.x = max(bodyController.bodyView.frameRect.x, -bodyController.bodyView.frameRect.width * scale.x + 700);
        bodyController.bodyView.frameRect.y = max(bodyController.bodyView.frameRect.y, -bodyController.bodyView.frameRect.height * scale.y + 700);

        bodyController.bodyView.frameRect.x = min(bodyController.bodyView.frameRect.x, 0);
        bodyController.bodyView.frameRect.y = min(bodyController.bodyView.frameRect.y, 0);

        pmousePressed = mousePressed;
    }

}
