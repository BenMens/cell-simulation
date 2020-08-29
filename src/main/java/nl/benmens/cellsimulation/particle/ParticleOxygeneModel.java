package nl.benmens.cellsimulation.particle;

import nl.benmens.cellsimulation.body.BodyModel;
import nl.benmens.cellsimulation.cell.CellModel;

public class ParticleOxygeneModel extends ParticleBaseModel {

  ParticleOxygeneModel(BodyModel bodyModel) {
    super(bodyModel);
  }

  ParticleOxygeneModel(BodyModel bodyModel, float positionX, float positionY) {
    super(bodyModel, positionX, positionY);
  }

  ParticleOxygeneModel(BodyModel bodyModel, float positionX, float positionY, float speedX, float speedY) {
    super(bodyModel, positionX, positionY, speedX, speedY);
  }

  public String getImageName() {
    return "oxygene";
  }

  public float getImageScale() {
    return 1.5f;
  };

  public String getTypeName() {
    return "oxygene";
  }

  public void onCellCollide(CellModel currendTouchedCell, CellModel previousTouchedCell) {
    if (previousTouchedCell != null) {
      previousTouchedCell.handleCollision(this);
    }

    if (currendTouchedCell != null) {
      currendTouchedCell.handleCollision(this);
    }

  }

}