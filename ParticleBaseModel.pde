class ParticleBaseModel {
    PVector position = new PVector(0, 0);
    PVector speed = new PVector(0, 0);
    BodyModel bodyModel;

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
}