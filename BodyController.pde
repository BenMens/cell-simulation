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
            ParticleBaseModel particleModel = new ParticleFoodModel(bodyModel);
        }   

        for (int i = 0; i < 50; i++) {
            ParticleBaseModel particleModel = new ParticleWasteModel(bodyModel);
        }

    }


    void onAddCell(CellModel cellModel) {
        CellController newCellController = new CellController(cellModel);
        bodyView.cellLayerView.addChildView(newCellController.cellView);

        cellControllers.add(newCellController);
    }


    void onAddParticle(ParticleBaseModel particleModel) { 
        ParticleController newParticleController = new ParticleController(particleModel);
        bodyView.particleLayerView.addChildView(newParticleController.particleView);
 
        particleControllers.add(newParticleController);
    }

}
