package nl.benmens.cellsimulation.particle.oxygene;

import nl.benmens.cellsimulation.body.BodyModel;
import nl.benmens.cellsimulation.cell.CellModel;
import nl.benmens.cellsimulation.particle.ParticleBaseModel;

public class OxygeneParticleModel extends ParticleBaseModel {

  public OxygeneParticleModel(BodyModel bodyModel) {
    super(bodyModel);
  }

  public OxygeneParticleModel(BodyModel bodyModel, float positionX, float positionY) {
    super(bodyModel, positionX, positionY);
  }

  public OxygeneParticleModel(BodyModel bodyModel, float positionX, float positionY, float speedX, float speedY) {
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