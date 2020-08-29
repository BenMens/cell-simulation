package nl.benmens.cellsimulation;

class BodyController extends ControllerBase implements BodyModelClient, BodyViewClient {
  BodyModel bodyModel;
  BodyView bodyView;

  BodyController(ControllerBase parentController, ViewBase parentView, BodyModel bodyModel) {
    super(parentController);

    this.bodyModel = bodyModel;
    this.bodyView = new BodyView(parentView, bodyModel);

    this.bodyModel.registerClient(this);
    this.bodyView.registerClient(this);
  }

  public void onAddCell(CellModel cellModel) {
    new CellController(this, bodyView.cellLayerView, cellModel);
  }

  public void onAddParticle(ParticleBaseModel particleModel) {
    new ParticleController(this, bodyView.particleLayerView, particleModel);
  }

  public void onSelectCell(CellModel selectedCell) {
  }
}