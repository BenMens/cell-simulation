package nl.benmens.cellsimulation.codon;

import nl.benmens.cellsimulation.ViewBase;
import nl.benmens.processing.SharedPApplet;
import processing.core.PApplet;

import java.awt.geom.Rectangle2D;


public class CodonDetailsView extends ViewBase {
  CodonBaseModel codonModel;

  boolean isSelected = false;

  public CodonDetailsView(ViewBase parentView, CodonBaseModel codonModel) {
    super(parentView);

    this.codonModel = codonModel;

    this.shouldClip = true;
  }

  public boolean onMouseButtonEvent(float mouseX, float mouseY, boolean mousePressed, int mouseButton) {
    if (mousePressed) {
      this.isSelected = !this.isSelected;

      return true;
    }

    return false;
  }

  public void beforeDrawChildren() {
    Rectangle2D.Float boundsRect = getBoundsRect();

    // if (isSelected) {
    // fill(255);
    // background(10, 10, 100);
    // } else {
    // fill(255);
    // background(10, 100, 10);
    // }

    SharedPApplet.background(0);

    float xOffset = codonModel.degradation * boundsRect.width / 2;

    SharedPApplet.fill(codonModel.getMainColor());
    SharedPApplet.rect(xOffset, 0, boundsRect.width / 2 - xOffset, boundsRect.height);

    SharedPApplet.fill(codonModel.getSecondaryColor());
    SharedPApplet.rect(boundsRect.width / 2, 0, boundsRect.width / 2 - xOffset, boundsRect.height);

    SharedPApplet.textAlign(PApplet.CENTER, PApplet.CENTER);

    SharedPApplet.fill(255);

    SharedPApplet.text(codonModel.getDisplayName(), boundsRect.width / 4, boundsRect.height / 2);

    SharedPApplet.text(codonModel.codonParameter, boundsRect.width * 3 / 4, boundsRect.height / 2);
  }

  public void onFrameRectChange(Rectangle2D.Float oldRect) {
    setBoundsRect(0, 0, this.getFrameRect().width, this.getFrameRect().height);
  }

}