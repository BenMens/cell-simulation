class ParticleController implements ParticleModelClient, ParticleViewClient {
    ParticleBaseModel particleModel;
    ParticleView particleView;

    ParticleController(ParticleBaseModel particleModel) {
        this.particleModel = particleModel;
        this.particleView = new ParticleView(particleModel);

        this.particleModel.registerClient(this);
        this.particleView.registerClient(this);
    }


    void destroy() {
        particleView.setParentView(null);
        particleView.unregisterClient(this);
        particleModel.unregisterClient(this);
    }
}
