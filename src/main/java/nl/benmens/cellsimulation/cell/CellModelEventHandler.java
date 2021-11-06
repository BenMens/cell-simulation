package nl.benmens.cellsimulation.cell;

import nl.benmens.cellsimulation.codon.CodonBaseModel;

public interface CellModelEventHandler {
  default public void onAddCodon(CodonBaseModel codonModel) {};

  default public void onRemoveCodon(CodonBaseModel codonModel) {};

  default public void onDestroy(CellModel cellModel) {};
}
