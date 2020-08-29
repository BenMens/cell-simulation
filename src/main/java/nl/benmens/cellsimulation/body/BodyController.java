package nl.benmens.cellsimulation.body;

import nl.benmens.cellsimulation.CellController;
import nl.benmens.cellsimulation.CellModel;
import nl.benmens.cellsimulation.ControllerBase;
import nl.benmens.cellsimulation.ParticleBaseModel;
import nl.benmens.cellsimulation.ParticleController;
import nl.benmens.cellsimulation.ViewBase;

public class BodyController extends ControllerBase implements BodyModelClient, BodyViewClient {
  public BodyModel bodyModel;
  public BodyView bodyView;

  public BodyController(ControllerBase parentController, ViewBase parentView, BodyModel bodyModel) {
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