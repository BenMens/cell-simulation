class ParticleWasteModel extends ParticleBaseModel {

    ParticleWasteModel(BodyModel bodyModel) {
        super(bodyModel);
    }
    ParticleWasteModel(BodyModel bodyModel, float positionX, float positionY) {
        super(bodyModel, positionX, positionY);
    }
    ParticleWasteModel(BodyModel bodyModel, float positionX, float positionY, float speedX, float speedY) {
        super(bodyModel, positionX, positionY, speedX, speedY);
    }
    

    String getImageName() {
        return "waste";
    }

    String getTypeName() {
        return "waste";
    }

    void onCellCollide(CellModel currendTouchedCell, CellModel previousTouchedCell) {
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

            if (max(getPosition().x - reflecCell.getPosition().x, 0) > 0.1) {
                speed.x = -speed.x;
            }

            if (max(1 + reflecCell.getPosition().x - getPosition().x, 0) > 0.1) {
                speed.x = -speed.x;
            }

            if (max(getPosition().y - reflecCell.getPosition().y, 0) > 0.1) {
                speed.y = -speed.y;                        
            }

            if (max(1 + reflecCell.getPosition().y - getPosition().y, 0) > 0.1) {
                speed.y = -speed.y;                        
            }

            setSpeed(speed);
        }

    }

}
