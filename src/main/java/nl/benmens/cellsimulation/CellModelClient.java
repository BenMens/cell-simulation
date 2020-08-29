package nl.benmens.cellsimulation;

public interface CellModelClient {
  public void onAddCodon(CodonBaseModel codonModel);

  public void onDestroy(CellModel cellModel);

  public void onRemoveCodon(CodonBaseModel codonModel);
}
