class BodyController implements BodyModelClient, BodyViewClient {
    BodyModel bodyModel;
    BodyView bodyView;

    ArrayList<CellController> cellControllers = new ArrayList<CellController>();
    ArrayList<ParticleController> particleControllers = new ArrayList<ParticleController>();


    BodyController(BodyModel bodyModel) {
        this.bodyModel = bodyModel;
        this.bodyView = viewFactory.createView(bodyModel);

        this.bodyModel.registerClient(this);
        this.bodyView.registerClient(this);

        for (int i = 0; i < 50; i++) {
            ParticleBaseModel particleModel = new FoodParticleModel(bodyModel);

            particleModel.setPosition(new PVector(random(bodyModel.gridSize.x), random(bodyModel.gridSize.y)));
            particleModel.setSpeed(new PVector(random(0.1) - 0.05, random(0.1) - 0.05));
        }   

        for (int i = 0; i < 50; i++) {
            ParticleBaseModel particleModel = new WasteParticleModel(bodyModel);

            particleModel.setPosition(new PVector(random(bodyModel.gridSize.x), random(bodyModel.gridSize.y)));
            particleModel.setSpeed(new PVector(random(0.1) - 0.05, random(0.1) - 0.05));
        }

    }


    void onAddCell(BodyModel bodyModel, CellModel cellModel) {
        CellController newCellController = new CellController(cellModel);
        bodyView.cellLayerView.addChildView(newCellController.cellView);

        cellControllers.add(newCellController);
    }


    void onAddParticle(BodyModel bodyModel, ParticleBaseModel particleModel) { 
        ParticleController particleController = new ParticleController(particleModel);
 
        particleControllers.add(particleController);
        bodyView.particleLayerView.addChildView(particleController.particleView);
    }

}
