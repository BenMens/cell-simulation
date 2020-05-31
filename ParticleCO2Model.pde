class ParticleCO2Model extends ParticleBaseModel {

    ParticleCO2Model(BodyModel bodyModel) {
        super(bodyModel);
    }
    ParticleCO2Model(BodyModel bodyModel, float positionX, float positionY) {
        super(bodyModel, positionX, positionY);
    }
    ParticleCO2Model(BodyModel bodyModel, float positionX, float positionY, float speedX, float speedY) {
        super(bodyModel, positionX, positionY, speedX, speedY);
    }
    

    String getImageName() {
        return "co2";
    }

    float getImageScale() {
        return 1.5;
    };


    String getTypeName() {
        return "co2";
    }


    void onCellCollide(CellModel currendTouchedCell, CellModel previousTouchedCell) {
        if (previousTouchedCell != null) {
            previousTouchedCell.handleCollision(this);
        }

        if (currendTouchedCell != null) {
            currendTouchedCell.handleCollision(this);
        }
    }

}
