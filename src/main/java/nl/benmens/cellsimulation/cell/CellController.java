package nl.benmens.cellsimulation.cell;

import nl.benmens.cellsimulation.codon.CodonBaseModel;
import nl.benmens.cellsimulation.codon.CodonController;
import nl.benmens.cellsimulation.codon.ControllerBase;
import nl.benmens.processing.mvc.View;

public class CellController extends ControllerBase implements CellModelClient {


  CellModel cellModel;
  CellView cellView;


  public CellController(ControllerBase parentController, View parentView, CellModel cellModel) {
    super(parentController);

    this.cellModel = cellModel;
    this.cellView = new CellView(parentView, cellModel);

    this.cellView.setFrameRect(cellModel.position.x * 100, cellModel.position.y * 100, 100, 100);

    this.cellModel.registerClient(this);
  }

  public void onDestroy() {
    cellView.destroy();
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