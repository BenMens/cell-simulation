package nl.benmens.cellsimulation.body;

import nl.benmens.cellsimulation.cell.CellModel;
import nl.benmens.cellsimulation.particle.ParticleBaseModel;

public interface BodyModelEventHandler {
  public default void onAddCell(CellModel cellModel) {}

  public default void onRemoveCell(CellModel cellModel) {}

  public default void onAddParticle(ParticleBaseModel particleModel) {}

  public default void onRemoveParticle(ParticleBaseModel particleModel) {}

  public default void onSelectCell(CellModel selectedCell) {}
}
