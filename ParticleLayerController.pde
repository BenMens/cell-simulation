class ParticleLayerController implements BodyModelClient {
    BodyModel bodyModel;
    ParticleLayerView particleLayerView;
    
    ArrayList<ParticleController> particleControllers = new ArrayList<ParticleController>();

    ParticleLayerController(BodyModel bodyModel) {
        this.bodyModel = bodyModel;
        this.particleLayerView = new ParticleLayerView();


        for (int i = 1; i < 100; i++) {
            ParticleBaseModel particleModel = new FoodParticleModel(bodyModel);

            particleModel.setPosition(new PVector(random(bodyModel.gridSize.x * 100), random(bodyModel.gridSize.y * 100)));
            particleModel.setSpeed(new PVector(random(10) - 5, random(10) - 5));
        }

        this.bodyModel.registerClient(this);
    }

    void onAddCell(BodyModel bodyModel, CellModel cellModel) {}

    void onAddParticle(BodyModel bodyModel, ParticleBaseModel particleModel) { 
        ParticleController particleController = new ParticleController(particleModel);
 
        particleControllers.add(particleController);
        particleLayerView.addChildView(particleController.particleView);
    }

    void tick() {
        for (ParticleController particleController: particleControllers) {
            particleController.tick();
        }
    }
}
