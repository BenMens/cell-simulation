package nl.benmens.cellsimulation;

import processing.core.PImage;
import java.awt.geom.Rectangle2D;

import nl.benmens.processing.SharedPApplet;


class ButtonView extends ViewBase {

  public PImage buttonImage;

  ButtonView(ViewBase parentView) {
    super(parentView);
  }

  public void beforeDrawChildren() {
    if (buttonImage != null) {
      Rectangle2D.Float boundsRect = getBoundsRect();

      SharedPApplet.image(buttonImage, boundsRect.x, boundsRect.y, boundsRect.width, boundsRect.height);
    }
  }

  public boolean onMouseButtonEvent(float mouseX, float mouseY, boolean mousePressed, int mouseButton) {
    for (ButtonViewClient client : getClientsImplementing(ButtonViewClient.class)) {
      client.onClick(this);
    }

    return true;
  }

}