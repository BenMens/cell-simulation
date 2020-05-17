class ParticleController {
    ParticleBaseModel particleModel;
    ParticleView particleView;

    ParticleController(ParticleBaseModel particleModel) {
        this.particleModel = particleModel;
        this.particleView = new ParticleView(particleModel);
    }

}
