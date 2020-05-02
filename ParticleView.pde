class ParticleView extends ViewBase {
    ParticleBaseModel particleModel;

    ParticleView(ParticleBaseModel particleModel) {
        this.particleModel = particleModel;
    }

    void beforeDrawChildren() {
        noStroke();
        fill(255, 0, 0);
        circle(particleModel.getPosition().x, particleModel.getPosition().y, 20);
    }

}