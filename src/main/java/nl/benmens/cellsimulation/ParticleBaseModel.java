package nl.benmens.cellsimulation;

import java.util.ArrayList;

import nl.benmens.cellsimulation.body.BodyModel;
import nl.benmens.processing.SharedPApplet;
import processing.core.PApplet;
import processing.core.PVector;

public abstract class ParticleBaseModel implements CellModelClient {
  ArrayList<ParticleModelClient> clients = new ArrayList<ParticleModelClient>();
  BodyModel bodyModel;

  float ticksPerMovementTick = 1;
  float ticksSinceLastMovementTick;

  boolean isDead = false;

  private PVector position = new PVector(0, 0);
  private PVector speed = new PVector(0, 0);

  CellModel previousTouchedCell;
  float cellWallHarmfulness = 0.0003f;

  private CellModel containingCell;

  public ParticleBaseModel(BodyModel bodyModel) {
    this(bodyModel, SharedPApplet.random(bodyModel.gridSize.x), SharedPApplet.random(bodyModel.gridSize.y));
  }

  public ParticleBaseModel(BodyModel bodyModel, float positionX, float positionY) {
    this(bodyModel, positionX, positionY, SharedPApplet.random(0.1f) - 0.05f, SharedPApplet.random(0.1f) - 0.05f);
  }

  public ParticleBaseModel(BodyModel bodyModel, float positionX, float positionY, float speedX, float speedY) {
    this.bodyModel = bodyModel;
    this.bodyModel.addParticle(this);

    this.position = new PVector(positionX, positionY);
    this.speed = new PVector(speedX, speedY);
  }

  public void registerClient(ParticleModelClient client) {
    if (!clients.contains(client)) {
      clients.add(client);
    }
  }

  public void unregisterClient(ParticleModelClient client) {
    clients.remove(client);
  }

  public PVector getPosition() {
    return position;
  }

  public void setPosition(PVector newPosition) {
    position = newPosition;
  }

  public PVector getSpeed() {
    return speed;
  }

  public void setSpeed(PVector newSpeed) {
    speed = newSpeed;
  }

  public void tick() {
    while (ticksSinceLastMovementTick >= ticksPerMovementTick) {
      movementTick();
      ticksSinceLastMovementTick -= ticksPerMovementTick;
    }
    ticksSinceLastMovementTick++;
  }

  public void movementTick() {
    PVector bodySize = bodyModel.gridSize.copy();

    position.add(speed);

    if (position.x < 0) {
      position.x = -position.x;
      speed.x = -speed.x;
    }

    if (position.y < 0) {
      position.y = -position.y;
      speed.y = -speed.y;
    }

    if (position.x > bodySize.x) {
      position.x = 2 * bodySize.x - position.x;
      speed.x = -speed.x;
    }

    if (position.y > bodySize.y) {
      position.y = 2 * bodySize.y - position.y;
      speed.y = -speed.y;
    }

    CellModel currendTouchedCell = findContainingCell();

    if (previousTouchedCell != currendTouchedCell) {

      onCellCollide(currendTouchedCell, previousTouchedCell);

      previousTouchedCell = currendTouchedCell;
    }
  }

  public void cleanUpTick() {
    if (isDead) {
      bodyModel.removeParticle(this);
    }
  }

  public void setContainingCell(CellModel newContainingCell) {
    if (this.containingCell == newContainingCell) {
      return;
    }

    if (this.containingCell != null) {
      this.containingCell.unregisterClient(this);
      this.containingCell.expelParticle(this);
    }

    this.containingCell = newContainingCell;

    if (newContainingCell != null) {
      newContainingCell.registerClient(this);
      newContainingCell.receiveParticle(this);
    }
  }

  public CellModel getContainingCell() {
    return this.containingCell;
  }

  public CellModel findContainingCell() {
    return bodyModel.findCellAtPosition(PApplet.floor(position.x), PApplet.floor(position.y));
  }

  public abstract String getImageName();

  public float getImageScale() {
    return 1;
  };

  public abstract String getTypeName();

  public abstract void onCellCollide(CellModel currendTouchedCell, CellModel previousTouchedCell);

  public void onAddCodon(CodonBaseModel codonModel) {
  };

  public void onDestroy(CellModel cellModel) {
    if (containingCell == cellModel) {
      containingCell.expelParticle(this);
      containingCell = null;
    }
  };

  public void onRemoveCodon(CodonBaseModel codonModel) {
  };
}