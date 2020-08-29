package nl.benmens.cellsimulation.cell;

import nl.benmens.cellsimulation.CodonBaseModel;
import nl.benmens.cellsimulation.CodonController;
import nl.benmens.cellsimulation.ControllerBase;
import nl.benmens.cellsimulation.ViewBase;

public class CellController extends ControllerBase implements CellModelClient, CellViewClient {


  CellModel cellModel;
  CellView cellView;


  public CellController(ControllerBase parentController, ViewBase parentView, CellModel cellModel) {
    super(parentController);

    this.cellModel = cellModel;
    this.cellView = new CellView(parentView, cellModel);

    this.cellView.setFrameRect(cellModel.position.x * 100, cellModel.position.y * 100, 100, 100);

    this.cellModel.registerClient(this);
    this.cellView.registerClient(this);
  }

  public void onDestroy() {
    cellView.destroy();
    cellView.unregisterClient(this);
    cellModel.unregisterClient(this);
  }

  public void onAddCodon(CodonBaseModel codonModel) {
    new CodonController(this, cellView, codonModel);
  }

  public void onDestroy(CellModel cellModel) {
    destroy();
  }

  public void onRemoveCodon(CodonBaseModel codonModel) {
  }
}