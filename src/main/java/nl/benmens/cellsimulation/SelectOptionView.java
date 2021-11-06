package nl.benmens.cellsimulation;

import nl.benmens.processing.SharedPApplet;
import nl.benmens.processing.mvc.View;

public class SelectOptionView extends View {

  boolean isSelected = false;

  SelectOptionView(View parentView) {
    super(parentView);

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
    if (isSelected) {
      SharedPApplet.background(10, 10, 50);
    } else {
      SharedPApplet.background(10, 50, 10);
    }

    SharedPApplet.text("Action", 5, 30);
  }

}