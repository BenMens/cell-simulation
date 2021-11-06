package nl.benmens.cellsimulation.celleditor;

import java.util.ArrayList;

import nl.benmens.cellsimulation.cell.CellController;
import nl.benmens.cellsimulation.cell.CellModel;
import nl.benmens.cellsimulation.cell.CellModelEventHandler;
import nl.benmens.cellsimulation.codon.CodonBaseModel;
import nl.benmens.cellsimulation.codon.CodonDetailsView;
import nl.benmens.processing.mvc.Controller;
import nl.benmens.processing.mvc.View;

import java.awt.geom.Rectangle2D;

public class CellEditorController extends Controller implements CellModelEventHandler {
  private CellModel cellModel;
  private CellEditorView cellEditorView;
  private CellController cellController;
  private ArrayList<CodonDetailsView> codonDetailsViews = new ArrayList<CodonDetailsView>();

  public CellEditorController(Controller parentController, View parentView, CellModel cellModel) {
    super(parentController);

    this.cellModel = cellModel;
    cellEditorView = new CellEditorView(parentView, cellModel);

    cellController = new CellController(this, getCellEditorView(), cellModel);
    cellController.getCellView().setDisabled(true);

    cellModel.subscribe(this, subscriptionManager);

    rebuildCodonViews();
  }

  public CellEditorView getCellEditorView() {
    return cellEditorView;
  }

  public void beforeLayoutChildren() {
    Rectangle2D.Float frameRect = getCellEditorView().getFrameRect();

    getCellEditorView().setBoundsRect(0, 0, frameRect.width, frameRect.height);
    cellController.getCellView().setFrameRect(20, 20, 200, 200);

    float codonHeight = getCellEditorView().calculatedCodonsHeight();
    float codonY = getCellEditorView().CODONS_Y_POS;
    for (CodonDetailsView codonView : codonDetailsViews) {
      codonView.setFrameRect(40, codonY, frameRect.width - 80, codonHeight);

      codonY += codonHeight + getCellEditorView().CODONS_SPACING;
    }
  }

  public void onDestroy() {
    getCellEditorView().destroy();
    subscriptionManager.unsubscribeAll(cellModel);

    destroyCodonViews();
  }

  public void onDestroy(CellModel cellModel) {
    destroy();
  }

  public void destroyCodonViews() {
    for (CodonDetailsView codonView : codonDetailsViews) {
      codonView.destroy();
    }

    codonDetailsViews.clear();
  }

  public void rebuildCodonViews() {
    destroyCodonViews();

    for (CodonBaseModel codonModel : cellModel.getCodonModels()) {
      codonDetailsViews.add(new CodonDetailsView(this.getCellEditorView(), codonModel));
    }

    updateLayout();
  }

  public void onAddCodon(CodonBaseModel codonModel) {
    rebuildCodonViews();
  }

  public void onRemoveCodon(CodonBaseModel codonModel) {
    rebuildCodonViews();
  }
}