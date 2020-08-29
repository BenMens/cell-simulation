package nl.benmens.cellsimulation;

import nl.benmens.cellsimulation.body.BodyModel;
import processing.core.PApplet;
import processing.core.PVector;

public class ParticleWasteModel extends ParticleBaseModel {

  ParticleWasteModel(BodyModel bodyModel) {
    super(bodyModel);
  }

  ParticleWasteModel(BodyModel bodyModel, float positionX, float positionY) {
    super(bodyModel, positionX, positionY);
  }

  ParticleWasteModel(BodyModel bodyModel, float positionX, float positionY, float speedX, float speedY) {
    super(bodyModel, positionX, positionY, speedX, speedY);
  }

  public String getImageName() {
    return "waste";
  }

  public String getTypeName() {
    return "waste";
  }

  public void onCellCollide(CellModel currendTouchedCell, CellModel previousTouchedCell) {
    if (previousTouchedCell != null) {
      previousTouchedCell.handleCollision(this);
    }

    if (currendTouchedCell != null) {
      currendTouchedCell.handleCollision(this);
    }

    CellModel reflecCell = currendTouchedCell;

    if (this.getContainingCell() == previousTouchedCell && previousTouchedCell != null) {
      reflecCell = previousTouchedCell;
    }

    if (reflecCell != null) {
      PVector speed = getSpeed();

      if (PApplet.max(getPosition().x - reflecCell.getPosition().x, 0) > 0.1f) {
        speed.x = -speed.x;
      }

      if (PApplet.max(1 + reflecCell.getPosition().x - getPosition().x, 0) > 0.1f) {
        speed.x = -speed.x;
      }

      if (PApplet.max(getPosition().y - reflecCell.getPosition().y, 0) > 0.1f) {
        speed.y = -speed.y;
      }

      if (PApplet.max(1 + reflecCell.getPosition().y - getPosition().y, 0) > 0.1f) {
        speed.y = -speed.y;
      }

      setSpeed(speed);
    }

  }

}