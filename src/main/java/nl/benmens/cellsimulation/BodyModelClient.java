package nl.benmens.cellsimulation;

interface BodyModelClient {
  public void onAddCell(CellModel cellModel);

  public void onAddParticle(ParticleBaseModel particleModel);

  public void onSelectCell(CellModel selectedCell);
}
