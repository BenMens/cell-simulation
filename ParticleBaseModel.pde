class ParticleBaseModel {
    BodyModel bodyModel;

    private PVector position = new PVector(0, 0);
    private PVector speed = new PVector(0, 0);

    CellModel containingCell;
    float cellWallHarmfulness = 0.03;


    ParticleBaseModel(BodyModel bodyModel) {
        this.bodyModel = bodyModel;
        bodyModel.addParticle(this);
    }

    PVector getPosition() {
        return position;
    }

    void setPosition(PVector newPosition) {
        position = newPosition;
    }

    PVector getSpeed() {
        return speed;
    }

    void setSpeed(PVector newSpeed) {
        speed = newSpeed;
    }

    void tick() {
        PVector bodySize = bodyModel.gridSize.copy();

        position.add(speed);

        if (position.x < 0) {
            position.x = -position.x;
            speed.x = -speed.x;
        }

        if (position.y < 0) {
            position.y = -position.y;
            speed.y = -speed.y;
        }

        if (position.x > bodySize.x) {
            position.x = 2 * bodySize.x - position.x;
            speed.x = -speed.x;
        }

        if (position.y > bodySize.y) {
            position.y = 2 * bodySize.y - position.y;
            speed.y = -speed.y;
        }

        CellModel newContainingCell = findContainingCell();

        if (containingCell != newContainingCell) {
            if (newContainingCell != null) {
              newContainingCell.handleCollision(this);
            }
            containingCell = newContainingCell;
        }
    }

    CellModel findContainingCell() {
        return bodyModel.findCellAtPosition(floor(position.x), floor(position.y));
    }
}
