package nl.benmens.cellsimulation;

import java.awt.geom.Rectangle2D;

import nl.benmens.processing.mvc.View;
import processing.core.PApplet;
import processing.core.PVector;

class ZoomView extends View {
  final float MAX_SCALE_FACTOR = 1.f / 100;
  float scaleMin;
  float scaleMax;
  View zoomView = null;
  Rectangle2D.Float zoomViewFrameRect;

  float mouseScrollSensetivity = 1.1f;

  ZoomView(View parentView) {
    super(parentView);

    shouldClip = true;
  }

  public void onFrameRectChange(Rectangle2D.Float oldRect) {
    if (zoomView != null && (zoomViewFrameRect == null || zoomView.frameRect.width != zoomViewFrameRect.width
        || zoomView.frameRect.height != zoomViewFrameRect.height)) {
      setBoundsRect(0, 0, getFrameRect().width, getFrameRect().height);

      zoomViewFrameRect = (Rectangle2D.Float) zoomView.frameRect.clone();

      scaleMin = getFrameRect().width / zoomView.getFrameRect().width;
      scaleMax = getFrameRect().width * MAX_SCALE_FACTOR;

      zoomView.setScale(scaleMin);
    }
  }

  public void setZoomView(View zoomView) {
    this.zoomView = zoomView;
  }


  public boolean onKeyEvent(boolean pressed, int key) {
    if (pressed && key == 'c') {
      zoomView.setScale(scaleMin);
      zoomView.frameRect.x = 0;
      zoomView.frameRect.y = 0;

      return true;
    }

    return false;
  }


  @Override
  public void mouseDragged(float mouseX, float mouseY, float pmouseX, float pmouseY) {
    zoomView.frameRect.x += (mouseX - pmouseX);
    zoomView.frameRect.y += (mouseY - pmouseY);

    clipMovement();
  }


  public boolean onScroll(float mouseX, float mouseY, float mouseScroll) {
    PVector screenPos = viewPosToScreenPos(new PVector(mouseX, mouseY));

    PVector mouseBodyPosPre = zoomView.screenPosToViewPos(screenPos);

    float scale = zoomView.getScale().x;

    scale *= PApplet.pow(mouseScrollSensetivity, mouseScroll);
    zoomView.setScale(PApplet.constrain(scale, (float) scaleMin, (float) scaleMax));

    PVector mouseBodyPosPost = zoomView.viewPosToScreenPos(mouseBodyPosPre);

    PVector deltaScreenMove = mouseBodyPosPost.sub(screenPos.x, screenPos.y);

    deltaScreenMove.x *= composedScale().x;
    deltaScreenMove.y *= composedScale().y;

    zoomView.frameRect.x -= deltaScreenMove.x;
    zoomView.frameRect.y -= deltaScreenMove.y;

    clipMovement();

    return true;
  }

  public void clipMovement() {
    PVector scale = zoomView.getScale();

    float x, y;

    x = PApplet.max(zoomView.frameRect.x, -zoomView.getFrameRect().width * scale.x + getFrameRect().width);
    x = PApplet.min(x, 0);

    y = PApplet.max(zoomView.frameRect.y, -zoomView.getFrameRect().height * scale.y + getFrameRect().height);
    y = PApplet.min(y, 0);

    zoomView.setFrameRect(x, y, zoomView.getFrameRect().width, zoomView.getFrameRect().width);
  }

}