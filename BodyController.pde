class BodyController extends ControllerBase implements BodyModelClient, BodyViewClient {
    BodyModel bodyModel;
    BodyView bodyView;


    BodyController(ControllerBase parentController, ViewBase parentView, BodyModel bodyModel) {
        super (parentController);
        
        this.bodyModel = bodyModel;
        this.bodyView = new BodyView(parentView, bodyModel);

        this.bodyModel.registerClient(this);
        this.bodyView.registerClient(this);
    }


    void onAddCell(CellModel cellModel) {
        new CellController(this, bodyView.cellLayerView, cellModel);
    }

    void onAddParticle(ParticleBaseModel particleModel) { 
        new ParticleController(this, bodyView.particleLayerView, particleModel);
    }
    
    void onSelectCell(CellModel selectedCell) {}
}
