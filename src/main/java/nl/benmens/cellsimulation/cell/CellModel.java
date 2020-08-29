package nl.benmens.cellsimulation.cell;

import java.util.ArrayList;

import nl.benmens.cellsimulation.CodonBaseModel;
import nl.benmens.cellsimulation.CodonModelParent;
import nl.benmens.cellsimulation.CodonNoneModel;
import nl.benmens.cellsimulation.CodonRemoveModel;
import nl.benmens.cellsimulation.body.BodyModel;
import nl.benmens.cellsimulation.particle.ParticleBaseModel;
import nl.benmens.cellsimulation.particle.ParticleWasteModel;
import nl.benmens.processing.PApplet;
import nl.benmens.processing.SharedPApplet;
import processing.core.PVector;

public class CellModel implements CodonModelParent {
  ArrayList<CellModelClient> clients = new ArrayList<CellModelClient>();
  BodyModel bodyModel;

  ArrayList<CodonBaseModel> codonModels = new ArrayList<CodonBaseModel>();

  private ArrayList<ParticleBaseModel> containingParticles = new ArrayList<ParticleBaseModel>();

  float ticksPerCodonTick = 50;
  float ticksSinceLastCodonTick;

  boolean isDead = false;

  public PVector position;
  public float wallHealth = 1;
  public float energyLevel = 1;
  float energyCostPerTick = 0.01f;

  int currentCodon = 0;
  int executeHandPosition = 0;
  boolean isExecuteHandPointingOutward = false;
  int previousExecuteHandPosition = 0;
  boolean previousIsExecuteHandPointingOutward = false;

  boolean edited = false;

  public CellModel(BodyModel bodyModel, PVector position) {
    this.bodyModel = bodyModel;
    bodyModel.addCell(this);

    this.position = position;

    for (int i = 0; i < 10; i++) {
      new CodonNoneModel(this);
    }

    CodonBaseModel removeCodon = new CodonRemoveModel(this);
    removeCodon.setCodonParameter(
        removeCodon.possibleCodonParameters.get(PApplet.floor(SharedPApplet.random(removeCodon.possibleCodonParameters.size()))));
  }

  public void registerClient(CellModelClient client) {
    if (!clients.contains(client)) {
      clients.add(client);

      for (CodonBaseModel codonModel : codonModels) {
        client.onAddCodon(codonModel);
      }
    }
  }

  public void unregisterClient(CellModelClient client) {
    clients.remove(client);
  }

  public void addCodon(CodonBaseModel newCodonModel) {
    codonModels.add(newCodonModel);

    for (CellModelClient client : new ArrayList<CellModelClient>(clients)) {
      client.onAddCodon(newCodonModel);
    }

    for (CodonBaseModel codonModel : codonModels) {
      codonModel.updatePosition();
    }

    executeHandPosition = PApplet.floor(SharedPApplet.random(codonModels.size()));
  }

  public void removeCodon(CodonBaseModel oldCodonModel) {
    codonModels.remove(oldCodonModel);

    for (CellModelClient client : clients) {
      client.onRemoveCodon(oldCodonModel);
    }

    for (CodonBaseModel codonModel : codonModels) {
      codonModel.updatePosition();
    }

    if (currentCodon >= codonModels.size()) {
      currentCodon = codonModels.size() - 1;
    }

    if (previousExecuteHandPosition >= codonModels.size() || executeHandPosition >= codonModels.size()) {
      previousExecuteHandPosition = PApplet.floor(SharedPApplet.random(codonModels.size()));
      executeHandPosition = PApplet.floor(SharedPApplet.random(codonModels.size()));
    }
  }

  public void tick() {
    if (energyLevel > energyCostPerTick) {
      while (ticksSinceLastCodonTick >= ticksPerCodonTick) {
        codonTick();
        ticksSinceLastCodonTick -= ticksPerCodonTick;
      }
      ticksSinceLastCodonTick++;
    }

    ArrayList<CodonBaseModel> codonModelsCopy = (ArrayList<CodonBaseModel>) codonModels.clone();
    for (CodonBaseModel codonModel : codonModelsCopy) {
      codonModel.tick();
    }

    if (wallHealth <= 0) {
      isDead = true;
    }
  }

  public void codonTick() {
    if (codonModels.size() != 0) {
      energyLevel = PApplet.max(energyLevel - energyCostPerTick, 0);

      if (energyLevel > codonModels.get(currentCodon).getEnergyCost()) {
        currentCodon = (currentCodon + 1) % codonModels.size();
        codonModels.get(currentCodon).executeCodon();
      }
    }

    previousExecuteHandPosition = executeHandPosition;
    previousIsExecuteHandPointingOutward = isExecuteHandPointingOutward;
  }

  public void cleanUpTick() {
    for (int i = codonModels.size() - 1; i >= 0; i--) {
      codonModels.get(i).cleanUpTick();
    }

    if (isDead) {
      for (int i = codonModels.size() - 1; i >= 0; i--) {
        CodonBaseModel codonModel = codonModels.get(i);

        new ParticleWasteModel(bodyModel, codonModel.getPosition().x, codonModel.getPosition().y);

        codonModel.isDead = true;
        codonModel.cleanUpTick();
      }

      for (CellModelClient client : new ArrayList<CellModelClient>(clients)) {
        client.onDestroy(this);
      }

      bodyModel.removeCell(this);
    }
  }

  public ArrayList<CodonBaseModel> getCodonList() {
    return codonModels;
  }

  public PVector getPosition() {
    return position;
  }

  public int getCurrentCodon() {
    return currentCodon;
  }

  public int getExecuteHandPosition() {
    return executeHandPosition;
  }

  public boolean getIsExecuteHandPointingOutward() {
    return isExecuteHandPointingOutward;
  }

  public void handleCollision(ParticleBaseModel particle) {
    wallHealth -= particle.cellWallHarmfulness;
  }

  public void replaceCodon(CodonBaseModel oldCodon, CodonBaseModel newCodon) {
    oldCodon.isDead = true;
    codonModels.remove(newCodon);
    codonModels.add(codonModels.indexOf(oldCodon), newCodon);
  }

  // ################################################################################################################################################
  // wall health getters and setters
  // ################################################################################################################################################
  public float getWallHealth() {
    return wallHealth;
  }

  public void setWallHealth(float health) {
    wallHealth = PApplet.constrain(health, 0, 1);
  }

  public void addWallHealth(float health) {
    wallHealth = PApplet.constrain(wallHealth + health, 0, 1);
  }

  public void subtractWallHealth(float health) {
    wallHealth = PApplet.constrain(wallHealth - health, 0, 1);
  }

  // ################################################################################################################################################
  // energy level getters and setters
  // ################################################################################################################################################
  public float getEnergyLevel() {
    return energyLevel;
  }

  public void setEnergyLevel(float energy) {
    energyLevel = PApplet.constrain(energy, 0, 1);
  }

  public void addEnergyLevel(float energy) {
    energyLevel = PApplet.constrain(energyLevel + energy, 0, 1);
  }

  public void subtractEnergyLevel(float energy) {
    energyLevel = PApplet.constrain(energyLevel - energy, 0, 1);
  }

  // ################################################################################################################################################
  // functions for the cell selection
  // ################################################################################################################################################
  public boolean isSelected() {
    return bodyModel.getSelectedCell() == this;
  }

  public CellModel getSelected() {
    return bodyModel.getSelectedCell();
  }

  public void selectCell() {
    bodyModel.selectCell(this);
  }

  public void unSelectCell() {
    bodyModel.unSelectCell(this);
  }

  // ################################################################################################################################################
  // containing particles
  // ################################################################################################################################################
  public void receiveParticle(ParticleBaseModel particle) {
    if (!containingParticles.contains(particle)) {
      containingParticles.add(particle);
    }
  }

  public void expelParticle(ParticleBaseModel particle) {
    containingParticles.remove(particle);
  }

  public ArrayList<ParticleBaseModel> getContainingParticles() {
    return (ArrayList<ParticleBaseModel>) containingParticles.clone();
  }

  public ArrayList<ParticleBaseModel> getContainingParticles(String type) {
    ArrayList<ParticleBaseModel> result = new ArrayList<ParticleBaseModel>();

    for (ParticleBaseModel particle : containingParticles) {
      if (particle.getTypeName() == type) {
        result.add(particle);
      }
    }

    return result;
  }

}