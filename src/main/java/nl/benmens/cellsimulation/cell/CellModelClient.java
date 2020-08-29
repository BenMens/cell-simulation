package nl.benmens.cellsimulation.cell;

import nl.benmens.cellsimulation.codon.CodonBaseModel;

public interface CellModelClient {
  public void onAddCodon(CodonBaseModel codonModel);

  public void onDestroy(CellModel cellModel);

  public void onRemoveCodon(CodonBaseModel codonModel);
}
