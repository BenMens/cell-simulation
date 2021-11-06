package nl.benmens.cellsimulation.particle.co2;

import nl.benmens.cellsimulation.body.BodyModel;
import nl.benmens.cellsimulation.cell.CellModel;
import nl.benmens.cellsimulation.particle.ParticleBaseModel;

public class CO2ParticleModel extends ParticleBaseModel {

  public CO2ParticleModel(BodyModel bodyModel) {
    super(bodyModel);
  }

  public CO2ParticleModel(BodyModel bodyModel, float positionX, float positionY) {
    super(bodyModel, positionX, positionY);
  }

  public CO2ParticleModel(BodyModel bodyModel, float positionX, float positionY, float speedX, float speedY) {
    super(bodyModel, positionX, positionY, speedX, speedY);
  }

  public String getImageName() {
    return "co2";
  }

  public float getImageScale() {
    return 1.5f;
  };

  public String getTypeName() {
    return "co2";
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