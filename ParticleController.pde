class ParticleController {
    ParticleBaseModel particleModel;
    ParticleView particleView;

    ParticleController(ParticleBaseModel particleModel) {
        this.particleModel = particleModel;
        this.particleView = viewFactory.createView(particleModel);
    }

}
