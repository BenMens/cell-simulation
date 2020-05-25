class ParticleController implements ParticleModelClient, ParticleViewClient {
    ParticleBaseModel particleModel;
    ParticleView particleView;

    ParticleController(ViewBase parentView, ParticleBaseModel particleModel) {
        this.particleModel = particleModel;
        this.particleView = new ParticleView(parentView, particleModel);

        this.particleModel.registerClient(this);
        this.particleView.registerClient(this);
    }


    void destroy() {
        particleView.unregisterClient(this);
        particleModel.unregisterClient(this);
    }


    void onDestroy(ParticleBaseModel particleModel) {}

}
