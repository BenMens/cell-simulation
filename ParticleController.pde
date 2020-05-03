class ParticleController {
    ParticleBaseModel particleModel;
    ParticleView particleView;

    ParticleController(ParticleBaseModel particleModel) {
        this.particleModel = particleModel;
        this.particleView = viewFactory.createView(particleModel);
    }

    void tick() {
        PVector position = particleModel.getPosition();
        PVector speed = particleModel.getSpeed();
        PVector bodySize = particleModel.bodyModel.gridSize.copy().mult(100);

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

    }
}
