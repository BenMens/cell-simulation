package nl.benmens.cellsimulation.body;

import nl.benmens.processing.SharedPApplet;
import nl.benmens.processing.mvc.View;
import processing.core.PVector;

public class BodyView extends View {
  private BodyModel bodyModel;

  private View cellLayerView;
  private View particleLayerView;

  public BodyView(View parentView, BodyModel bodyModel) {
    super(parentView);

    this.bodyModel = bodyModel;

    cellLayerView = new View(this);

    particleLayerView = new View(this);

    setFrameRect(0, 0, bodyModel.getGridSize().x * 100 + 20, bodyModel.getGridSize().y * 100 + 20);

    setBoundsRect(-10, -10, getFrameRect().width, getFrameRect().height);
  }

  public void beforeDrawChildren() {
    PVector gridSize = bodyModel.getGridSize();

    SharedPApplet.strokeWeight(10);
    SharedPApplet.stroke(0);
    SharedPApplet.noFill();
    SharedPApplet.rect(-5, -5, gridSize.x * 100 + 10, gridSize.y * 100 + 10);

    if (SharedPApplet.keysPressed['g'] == true) {
      SharedPApplet.strokeWeight(4);
      SharedPApplet.stroke(100);
      SharedPApplet.noFill();

      for (int x = 0; x < gridSize.x; x++) {
        for (int y = 0; y < gridSize.y; y++) {
          SharedPApplet.rect(x * 100, y * 100, 100, 100);
        }
      }
    }
  }

  public BodyModel getBodyModel() {
    return bodyModel;
  }

  public View getCellLayerView() {
    return cellLayerView;
  }

  public View getParticleLayerView() {
    return particleLayerView;
  }
}
