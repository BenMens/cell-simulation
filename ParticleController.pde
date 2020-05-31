class ParticleController extends ControllerBase implements ParticleModelClient, ParticleViewClient {
    ParticleBaseModel particleModel;
    ParticleView particleView;

    ParticleController(ControllerBase parentController, ViewBase parentView, ParticleBaseModel particleModel) {
        super(parentController);
        
        this.particleModel = particleModel;
        this.particleView = new ParticleView(parentView, particleModel);

        this.particleModel.registerClient(this);
        this.particleView.registerClient(this);
    }


    void onDestroy() {
        particleView.destroy();
        particleView.unregisterClient(this);
        particleModel.unregisterClient(this);
    }


    void onDestroy(ParticleBaseModel particleModel) {}

}
