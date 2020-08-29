package nl.benmens.cellsimulation.codon;

interface CodonModelClient {
  default public void onDestroy(CodonBaseModel codonModel) {};
}
