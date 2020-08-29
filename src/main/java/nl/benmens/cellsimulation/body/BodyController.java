package nl.benmens.cellsimulation.body;

import nl.benmens.cellsimulation.ViewBase;
import nl.benmens.cellsimulation.cell.CellController;
import nl.benmens.cellsimulation.cell.CellModel;
import nl.benmens.cellsimulation.codon.ControllerBase;
import nl.benmens.cellsimulation.particle.ParticleBaseModel;
import nl.benmens.cellsimulation.particle.ParticleController;

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