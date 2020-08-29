package nl.benmens.cellsimulation.codon;

import nl.benmens.processing.mvc.View;

public class CodonController extends ControllerBase implements CodonModelClient {
  CodonBaseModel codonModel;
  CodonView codonView;

  public CodonController(ControllerBase parentController, View parentView, CodonBaseModel codonModel) {
    super(parentController);

    this.codonModel = codonModel;
    this.codonView = new CodonView(parentView, codonModel);

    this.codonModel.registerClient(this);
  }

  public void onDestroy() {
    codonView.destroy();
    codonModel.unregisterClient(this);
  }

  public void onDestroy(CodonBaseModel codonModel) {
    destroy();
  }
}