package nl.benmens.cellsimulation.particle;

import nl.benmens.cellsimulation.CellModel;
import nl.benmens.cellsimulation.body.BodyModel;

public class ParticleCO2Model extends ParticleBaseModel {

  ParticleCO2Model(BodyModel bodyModel) {
    super(bodyModel);
  }

  ParticleCO2Model(BodyModel bodyModel, float positionX, float positionY) {
    super(bodyModel, positionX, positionY);
  }

  ParticleCO2Model(BodyModel bodyModel, float positionX, float positionY, float speedX, float speedY) {
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