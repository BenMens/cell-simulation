package nl.benmens.cellsimulation.body;

import nl.benmens.cellsimulation.cell.CellController;
import nl.benmens.cellsimulation.cell.CellModel;
import nl.benmens.cellsimulation.particle.ParticleBaseModel;
import nl.benmens.cellsimulation.particle.ParticleController;
import nl.benmens.processing.mvc.Controller;
import nl.benmens.processing.mvc.View;

public class BodyController extends Controller implements BodyModelEventHandler {
  private BodyModel bodyModel;
  private BodyView bodyView;

  public BodyController(Controller parentController, View parentView, BodyModel bodyModel) {
    super(parentController);

    this.bodyModel = bodyModel;
    this.bodyView = new BodyView(parentView, bodyModel);

    this.bodyModel.subscribe(this, subscriptionManager);
  }

  public BodyView getBodyView() {
	  return bodyView;
  }

  public void onAddCell(CellModel cellModel) {
    new CellController(this, getBodyView().getCellLayerView(), cellModel);
  }

  public void onAddParticle(ParticleBaseModel particleModel) {
    new ParticleController(this, getBodyView().getParticleLayerView(), particleModel);
  }
}