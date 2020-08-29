package nl.benmens.cellsimulation;

interface CellModelClient {
  public void onAddCodon(CodonBaseModel codonModel);

  public void onDestroy(CellModel cellModel);

  public void onRemoveCodon(CodonBaseModel codonModel);
}
