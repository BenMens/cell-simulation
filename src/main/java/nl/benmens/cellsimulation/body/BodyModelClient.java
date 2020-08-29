package nl.benmens.cellsimulation.body;

import nl.benmens.cellsimulation.cell.CellModel;
import nl.benmens.cellsimulation.particle.ParticleBaseModel;

public interface BodyModelClient {
  public void onAddCell(CellModel cellModel);

  public void onAddParticle(ParticleBaseModel particleModel);

  public void onSelectCell(CellModel selectedCell);
}
