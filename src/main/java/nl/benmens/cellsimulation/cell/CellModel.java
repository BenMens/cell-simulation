package nl.benmens.cellsimulation.cell;

import java.util.ArrayList;

import nl.benmens.cellsimulation.body.BodyModel;
import nl.benmens.cellsimulation.codon.CodonBaseModel;
import nl.benmens.cellsimulation.codon.CodonModelParent;
import nl.benmens.cellsimulation.codon.CodonNoneModel;
import nl.benmens.cellsimulation.codon.CodonRemoveModel;
import nl.benmens.cellsimulation.particle.ParticleBaseModel;
import nl.benmens.cellsimulation.particle.ParticleWasteModel;
import nl.benmens.processing.PApplet;
import nl.benmens.processing.SharedPApplet;
import nl.benmens.processing.mvc.Model;
import nl.benmens.processing.observer.Subject;
import nl.benmens.processing.observer.Subscription;
import nl.benmens.processing.observer.SubscriptionManager;
import processing.core.PVector;

public class CellModel extends Model implements CodonModelParent {
  static final float TICKS_PER_CODON_TICK = 50;

  private Subject<CellModelClient> cellModelEvents = new Subject<CellModelClient>(this);
  private BodyModel bodyModel;

  private ArrayList<CodonBaseModel> codonModels = new ArrayList<CodonBaseModel>();

  private ArrayList<ParticleBaseModel> containingParticles = new ArrayList<ParticleBaseModel>();

  private float ticksSinceLastCodonTick;

  private boolean isDead = false;

  private PVector position;
  private float wallHealth = 1;
  private float energyLevel = 1;
  private float energyCostPerTick = 0.01f;

  private int currentCodon = 0;
  private int executeHandPosition = 0;
  private boolean isExecuteHandPointingOutward = false;
  private int previousExecuteHandPosition = 0;

  private boolean isPreviousExecuteHandPointingOutward = false;
  private boolean isEdited = false;

  public CellModel(BodyModel bodyModel, PVector position) {
    this.bodyModel = bodyModel;
    bodyModel.addCell(this);

    this.position = position;

    for (int i = 0; i < 10; i++) {
      new CodonNoneModel(this);
    }

    CodonBaseModel removeCodon = new CodonRemoveModel(this);
    removeCodon.setCodonParameter(removeCodon.possibleCodonParameters
        .get(PApplet.floor(SharedPApplet.random(removeCodon.possibleCodonParameters.size()))));
  }

  public Subscription<?> subscribe(CellModelClient observer, SubscriptionManager subscriptionManager) {
    boolean isNewClient = !cellModelEvents.getSubscribers().contains(observer);

    Subscription<?> result = cellModelEvents.subscribe(observer, subscriptionManager);

    if (isNewClient) {
      for (CodonBaseModel codonModel : getCodonModels()) {
        observer.onAddCodon(codonModel);
      }
    }

    return result;
  }

  public void addCodon(CodonBaseModel newCodonModel) {
    getCodonModels().add(newCodonModel);

    for (CellModelClient client : cellModelEvents.getSubscribers()) {
      client.onAddCodon(newCodonModel);
    }

    for (CodonBaseModel codonModel : getCodonModels()) {
      codonModel.updatePosition();
    }

    executeHandPosition = PApplet.floor(SharedPApplet.random(getCodonModels().size()));
  }

  public void removeCodon(CodonBaseModel oldCodonModel) {
    getCodonModels().remove(oldCodonModel);

    for (CellModelClient client : cellModelEvents.getSubscribers()) {
      client.onRemoveCodon(oldCodonModel);
    }

    for (CodonBaseModel codonModel : getCodonModels()) {
      codonModel.updatePosition();
    }

    if (currentCodon >= getCodonModels().size()) {
      currentCodon = getCodonModels().size() - 1;
    }

    if (previousExecuteHandPosition >= getCodonModels().size() || executeHandPosition >= getCodonModels().size()) {
      previousExecuteHandPosition = PApplet.floor(SharedPApplet.random(getCodonModels().size()));
      executeHandPosition = PApplet.floor(SharedPApplet.random(getCodonModels().size()));
    }
  }

  public void tick() {
    if (energyLevel > energyCostPerTick) {
      while (getTicksSinceLastCodonTick() >= TICKS_PER_CODON_TICK) {
        codonTick();
        setTicksSinceLastCodonTick(getTicksSinceLastCodonTick() - TICKS_PER_CODON_TICK);
      }
      setTicksSinceLastCodonTick(getTicksSinceLastCodonTick() + 1);
    }

    ArrayList<CodonBaseModel> codonModelsCopy = new ArrayList<CodonBaseModel>(getCodonModels());
    for (CodonBaseModel codonModel : codonModelsCopy) {
      codonModel.tick();
    }

    if (wallHealth <= 0) {
      isDead = true;
    }
  }

  public void codonTick() {
    if (getCodonModels().size() != 0) {
      energyLevel = PApplet.max(energyLevel - energyCostPerTick, 0);

      if (energyLevel > getCodonModels().get(currentCodon).getEnergyCost()) {
        currentCodon = (currentCodon + 1) % getCodonModels().size();
        getCodonModels().get(currentCodon).executeCodon();
      }
    }

    previousExecuteHandPosition = executeHandPosition;
    isPreviousExecuteHandPointingOutward = isExecuteHandPointingOutward;
  }

  public void cleanUpTick() {
    for (int i = getCodonModels().size() - 1; i >= 0; i--) {
      getCodonModels().get(i).cleanUpTick();
    }

    if (isDead) {
      for (int i = getCodonModels().size() - 1; i >= 0; i--) {
        CodonBaseModel codonModel = getCodonModels().get(i);

        new ParticleWasteModel(bodyModel, codonModel.getPosition().x, codonModel.getPosition().y);

        codonModel.isDead = true;
        codonModel.cleanUpTick();
      }

      for (CellModelClient client : cellModelEvents.getSubscribers()) {
        client.onDestroy(this);
      }

      bodyModel.removeCell(this);
    }
  }

  public ArrayList<CodonBaseModel> getCodonList() {
    return getCodonModels();
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
    wallHealth -= particle.getCellWallHarmfulness();
  }

  public void replaceCodon(CodonBaseModel oldCodon, CodonBaseModel newCodon) {
    oldCodon.isDead = true;
    getCodonModels().remove(newCodon);
    getCodonModels().add(getCodonModels().indexOf(oldCodon), newCodon);
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
    return new ArrayList<ParticleBaseModel>(containingParticles) ;
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

  public boolean isPreviousExecuteHandPointingOutward() {
    return isPreviousExecuteHandPointingOutward;
  }

  public boolean isEdited() {
    return isEdited;
  }

  public void setEdited(boolean isEdited) {
    this.isEdited = isEdited;
  }

  public float getTicksSinceLastCodonTick() {
    return ticksSinceLastCodonTick;
  }
  
  private void setTicksSinceLastCodonTick(float ticksSinceLastCodonTick) {
    this.ticksSinceLastCodonTick = ticksSinceLastCodonTick;
  }
  
  public ArrayList<CodonBaseModel> getCodonModels() {
    return codonModels;
  }

  
}