package nl.benmens.cellsimulation.cell;

import nl.benmens.cellsimulation.codon.CodonBaseModel;

public interface CellModelEventHandler {
  public default void onAddCodon(CodonBaseModel codonModel) {}

  public default void onRemoveCodon(CodonBaseModel codonModel) {}

  public default void onDestroy(CellModel cellModel) {}
}
