package nl.benmens.cellsimulation.cell;

import nl.benmens.cellsimulation.codon.CodonBaseModel;

public interface CellModelClient {
  default public void onAddCodon(CodonBaseModel codonModel) {};

  default public void onDestroy(CellModel cellModel) {};

  default public void onRemoveCodon(CodonBaseModel codonModel) {};
}
