package nl.benmens.cellsimulation.particle;

import nl.benmens.cellsimulation.body.BodyModel;
import nl.benmens.cellsimulation.cell.CellModel;

public class ParticleFoodModel extends ParticleBaseModel {

  ParticleFoodModel(BodyModel bodyModel) {
    super(bodyModel);
  }

  ParticleFoodModel(BodyModel bodyModel, float positionX, float positionY) {
    super(bodyModel, positionX, positionY);
  }

  ParticleFoodModel(BodyModel bodyModel, float positionX, float positionY, float speedX, float speedY) {
    super(bodyModel, positionX, positionY, speedX, speedY);
  }

  public String getImageName() {
    return "food";
  }

  public String getTypeName() {
    return "food";
  }

  public void onCellCollide(CellModel currendTouchedCell, CellModel previousTouchedCell) {
    if (previousTouchedCell != null) {
      previousTouchedCell.handleCollision(this);
    }

    if (currendTouchedCell != null) {
      currendTouchedCell.handleCollision(this);
    }

    setContainingCell(currendTouchedCell);

  }

}