package nl.benmens.cellsimulation;

import java.util.ArrayList;

import processing.core.PVector;

public interface CodonModelParent {
  public void addCodon(CodonBaseModel codonModel);

  public void removeCodon(CodonBaseModel codonModel);

  public ArrayList<CodonBaseModel> getCodonList();

  public PVector getPosition();

  public int getCurrentCodon();

  public int getExecuteHandPosition();

  public boolean getIsExecuteHandPointingOutward();

  public void replaceCodon(CodonBaseModel oldCodon, CodonBaseModel newCodon);

  public float getWallHealth();

  public void setWallHealth(float health);

  public void addWallHealth(float health);

  public void subtractWallHealth(float health);

  public float getEnergyLevel();

  public void setEnergyLevel(float energy);

  public void addEnergyLevel(float energy);

  public void subtractEnergyLevel(float energy);
}