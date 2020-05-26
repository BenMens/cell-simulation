class BodyController implements BodyModelClient, BodyViewClient {
    BodyModel bodyModel;
    BodyView bodyView;


    BodyController(ViewBase parentView, BodyModel bodyModel) {
        this.bodyModel = bodyModel;
        this.bodyView = new BodyView(parentView, bodyModel);

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
        new CellController(bodyView.cellLayerView, cellModel);
    }

    void onAddParticle(ParticleBaseModel particleModel) { 
        new ParticleController(bodyView.particleLayerView, particleModel);
    }
    
    void onSelectCell(CellModel selectedCell) {}
}
