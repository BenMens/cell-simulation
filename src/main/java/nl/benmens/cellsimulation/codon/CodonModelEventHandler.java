package nl.benmens.cellsimulation.codon;

public interface CodonModelEventHandler {
  default public void onDestroy(CodonBaseModel codonModel) {};
}
