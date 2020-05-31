class ParticleOxygeneModel extends ParticleBaseModel {

    ParticleOxygeneModel(BodyModel bodyModel) {
        super(bodyModel);
    }
    ParticleOxygeneModel(BodyModel bodyModel, float positionX, float positionY) {
        super(bodyModel, positionX, positionY);
    }
    ParticleOxygeneModel(BodyModel bodyModel, float positionX, float positionY, float speedX, float speedY) {
        super(bodyModel, positionX, positionY, speedX, speedY);
    }
    

    String getImageName() {
        return "oxygene";
    }

    float getImageScale() {
        return 1.5;
    };


    String getTypeName() {
        return "oxygene";
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
