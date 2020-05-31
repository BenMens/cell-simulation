class ZoomView extends ViewBase {
    final float MAX_SCALE_FACTOR = 1. / 200;
    float scaleMin;
    float scaleMax;
    ViewBase zoomView = null;
    Rectangle2D.Float zoomViewFrameRect;

    float mouseScrollSensetivity = 1.1;


    ZoomView(ViewBase parentView) {
        super(parentView);
        
        shouldClip = true;
    }

    void onFrameRectChange(Rectangle2D.Float oldRect) {
        if (zoomView != null && (zoomViewFrameRect == null || zoomView.frameRect.width != zoomViewFrameRect.width || zoomView.frameRect.height != zoomViewFrameRect.height)) {
            setBoundsRect(0, 0, getFrameRect().width, getFrameRect().height);

            zoomViewFrameRect = (Rectangle2D.Float)zoomView.frameRect.clone();

            scaleMin = getFrameRect().width / zoomView.getFrameRect().width;
            scaleMax = getFrameRect().width * MAX_SCALE_FACTOR;

            zoomView.setScale(scaleMin);
        }
    }


    void setZoomView(ViewBase zoomView) {
        this.zoomView = zoomView;
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
        clipMovement();

        zoomView.frameRect.x += (mouseX - pmouseX);
        zoomView.frameRect.y += (mouseY - pmouseY);

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


    void clipMovement() {
        PVector scale = zoomView.getScale();
        
        float x,y;

        x = max(zoomView.frameRect.x, -zoomView.getFrameRect().width * scale.x + getFrameRect().width);
        x = min(x, 0);

        y = max(zoomView.frameRect.y, -zoomView.getFrameRect().height * scale.y + getFrameRect().height);
        y = min(y, 0);        
        
        zoomView.setFrameRect(x, y, zoomView.getFrameRect().width, zoomView.getFrameRect().width);
    }

}
