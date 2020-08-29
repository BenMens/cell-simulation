package nl.benmens.cellsimulation.body;

import nl.benmens.cellsimulation.CellModel;
import nl.benmens.cellsimulation.ParticleBaseModel;

public interface BodyModelClient {
  public void onAddCell(CellModel cellModel);

  public void onAddParticle(ParticleBaseModel particleModel);

  public void onSelectCell(CellModel selectedCell);
}
