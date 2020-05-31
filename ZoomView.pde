class ZoomView extends ViewBase {
    final float MAX_SCALE_FACTOR = 1. / 200;
    float scaleMin;
    float scaleMax;
    ViewBase zoomView = null;
    Rectangle2D.Float zoomViewFrameRect;

    float mouseScrollSensetivity = 1.1;


    ZoomView(ViewBase parentView) {
        super(parentView);
    }


    void setZoomView(ViewBase zoomView) {
        this.zoomView = zoomView;

        updateMinMaxScale();
    }


    boolean onKeyEvent(boolean pressed, int key) {
        if (pressed && key == 'c') {
            zoomView.setScale(scaleMin);
            zoomView.frameRect.x = 0;
            zoomView.frameRect.y = 0;

            return true;
        }

        return false;
    }


    boolean onMouseDragged(float mouseX, float mouseY, float pmouseX, float pmouseY) {
        updateMinMaxScale();

        zoomView.frameRect.x += (mouseX - pmouseX);
        zoomView.frameRect.y += (mouseY - pmouseY);
        
        clipMovement();

        return true;
    }


    boolean onScroll(float mouseX, float mouseY, float mouseScroll) {
        PVector screenPos = viewPosToScreenPos(new PVector(mouseX, mouseY));

        PVector mouseBodyPosPre = zoomView.screenPosToViewPos(screenPos);

        float scale = zoomView.getScale().x;
        
        scale *= pow(mouseScrollSensetivity, mouseScroll);
        zoomView.setScale(constrain(scale, (float)scaleMin, (float)scaleMax));

        PVector mouseBodyPosPost = zoomView.viewPosToScreenPos(mouseBodyPosPre);

        PVector deltaScreenMove = mouseBodyPosPost.sub(screenPos.x, screenPos.y);
        
        deltaScreenMove.x *= composedScale().x;
        deltaScreenMove.y *= composedScale().y;

        zoomView.frameRect.x -= deltaScreenMove.x;
        zoomView.frameRect.y -= deltaScreenMove.y;

        clipMovement();

        return true;
    }


    void updateMinMaxScale() {
        if (zoomView != null && (zoomViewFrameRect == null || zoomView.frameRect.width != zoomViewFrameRect.width || zoomView.frameRect.height != zoomViewFrameRect.height)) {
            zoomViewFrameRect = (Rectangle2D.Float)zoomView.frameRect.clone();

            scaleMin = frameRect.width / zoomView.frameRect.width;
            scaleMax = frameRect.width * MAX_SCALE_FACTOR;

            zoomView.setScale(scaleMin);
        }
    }


    void clipMovement() {
        PVector scale = zoomView.getScale();

        zoomView.frameRect.x = max(zoomView.frameRect.x, -zoomView.frameRect.width * scale.x + frameRect.width);
        zoomView.frameRect.y = max(zoomView.frameRect.y, -zoomView.frameRect.height * scale.y + frameRect.height);

        zoomView.frameRect.x = min(zoomView.frameRect.x, 0);
        zoomView.frameRect.y = min(zoomView.frameRect.y, 0);        
    }

}
