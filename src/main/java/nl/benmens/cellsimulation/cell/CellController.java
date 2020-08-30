package nl.benmens.cellsimulation.cell;

import nl.benmens.cellsimulation.codon.CodonBaseModel;
import nl.benmens.cellsimulation.codon.CodonController;
import nl.benmens.cellsimulation.Controller;
import nl.benmens.processing.mvc.View;

public class CellController extends Controller implements CellModelClient {

  private CellModel cellModel;
  private CellView cellView;

  public CellController(Controller parentController, View parentView, CellModel cellModel) {
    super(parentController);

    this.cellModel = cellModel;
    this.cellView = new CellView(parentView, cellModel);

    this.cellView.setFrameRect(cellModel.getPosition().x * 100, cellModel.getPosition().y * 100, 100, 100);

    this.cellModel.subscribe(this, subscriptionManager);
  }

  public void onDestroy() {
    cellView.destroy();
    subscriptionManager.unsubscribeAll(cellModel);
  }

  public void onAddCodon(CodonBaseModel codonModel) {
    new CodonController(this, cellView, codonModel);
  }

  public void onDestroy(CellModel cellModel) {
    destroy();
  }

  public CellModel getCellModel() {
    return cellModel;
  }

  public CellView getCellView() {
    return cellView;
  }  
}