import java.awt.geom.Rectangle2D;


class GuiController {
    BodyModel bodyModel;
    BodyController bodyController;
    ZoomView bodyContainerView;


    GuiController(ViewBase parentView, BodyModel bodyModel) {
        bodyContainerView = new ZoomView(parentView);
        bodyContainerView.frameRect = new Rectangle2D.Float(20, 20, 700, 700);
        bodyContainerView.boundsRect = new Rectangle2D.Float(0, 0, 700, 700);
        bodyContainerView.hasClip = true;

        bodyController = new BodyController(bodyContainerView, bodyModel);

        bodyContainerView.setZoomView(bodyController.bodyView);
    }

}
