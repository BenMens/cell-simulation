package nl.benmens.cellsimulation.body;

import nl.benmens.cellsimulation.cell.CellModel;
import nl.benmens.cellsimulation.particle.ParticleBaseModel;

public interface BodyModelEventHandler {
  default public void onAddCell(CellModel cellModel) {};

  default public void onRemoveCell(CellModel cellModel) {};

  default public void onAddParticle(ParticleBaseModel particleModel) {};

  default public void onRemoveParticle(ParticleBaseModel particleModel) {};

  default public void onSelectCell(CellModel selectedCell) {};
}
