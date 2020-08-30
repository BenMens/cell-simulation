package nl.benmens.cellsimulation.body;

import java.util.ArrayList;
import processing.core.PVector;
import nl.benmens.cellsimulation.cell.CellModel;
import nl.benmens.cellsimulation.particle.ParticleBaseModel;
import nl.benmens.cellsimulation.particle.ParticleFactory;
import nl.benmens.processing.PApplet;
import nl.benmens.processing.SharedPApplet;
import nl.benmens.processing.mvc.Model;
import nl.benmens.processing.observer.Subject;
import nl.benmens.processing.observer.Subscription;
import nl.benmens.processing.observer.SubscriptionManager;

public class BodyModel extends Model {

  private Subject<BodyModelClient> bodyModelEvents = new Subject<BodyModelClient>(this);

  ArrayList<CellModel> cellModels = new ArrayList<CellModel>();
  private CellModel selectedCell = null;

  ArrayList<ParticleBaseModel> particleModels = new ArrayList<ParticleBaseModel>();

  public PVector gridSize;

  int lastTickTimestamp = SharedPApplet.millis();
  int millisPerTick = 20;

  public boolean pauzed = false;

  public BodyModel(PVector gridSize) {
    this.gridSize = gridSize;

    lastTickTimestamp = SharedPApplet.millis();

    for (int i = 0; i < 25; i++) {
      ParticleFactory.sharedFactory().createParticle("food", this);
    }

    for (int i = 0; i < 25; i++) {
      ParticleFactory.sharedFactory().createParticle("waste", this);
    }

    for (int i = 0; i < 25; i++) {
      ParticleFactory.sharedFactory().createParticle("oxygene", this);
    }

    for (int i = 0; i < 25; i++) {
      ParticleFactory.sharedFactory().createParticle("co2", this);
    }

    boolean[][] occupiedSpaces = new boolean[PApplet.parseInt(gridSize.x)][PApplet.parseInt(gridSize.y)];
    for (int i = 0; i < 25; i++) {
      for (int j = 0; j < 10; j++) {
        int x = PApplet.floor(SharedPApplet.random(gridSize.x));
        int y = PApplet.floor(SharedPApplet.random(gridSize.y));

        if (!occupiedSpaces[x][y]) {
          new CellModel(this, new PVector(x, y));
          occupiedSpaces[x][y] = true;
          break;
        }
      }
    }

  }

  public void addCell(CellModel cellModel) {
    cellModels.add(cellModel);

    for (BodyModelClient client : bodyModelEvents.getSubscribers()) {
      client.onAddCell(cellModel);
    }
  }

  public void removeCell(CellModel cellModel) {
    cellModels.remove(cellModel);

    if (selectedCell == cellModel) {
      unSelectCell(selectedCell);
    }
  }

  public void addParticle(ParticleBaseModel particleModel) {

    particleModels.add(particleModel);

    for (BodyModelClient client : bodyModelEvents.getSubscribers()) {
      client.onAddParticle(particleModel);
    }
  }

  public void removeParticle(ParticleBaseModel particleModel) {
    particleModels.remove(particleModel);
  }

  public CellModel getSelectedCell() {
    return selectedCell;
  }

  public void selectCell(CellModel cell) {
    selectedCell = cell;

    for (BodyModelClient client : bodyModelEvents.getSubscribers()) {
      client.onSelectCell(selectedCell);
    }
  }

  public void unSelectCell(CellModel cell) {
    if (cell == selectedCell) {
      selectedCell = null;

      for (BodyModelClient client : bodyModelEvents.getSubscribers()) {
        client.onSelectCell(selectedCell);
      }
    }
  }

  public CellModel findCellAtPosition(int x, int y) {
    for (CellModel cellModel : cellModels) {
      if (cellModel.getPosition().x == x && cellModel.getPosition().y == y) {
        return cellModel;
      }
    }

    return null;
  }

  public void loop() {
    while (SharedPApplet.millis() - lastTickTimestamp >= millisPerTick) {
      if (!pauzed) {
        tick();
      }
      lastTickTimestamp += millisPerTick;
    }
  }

  public void tick() {
    for (ParticleBaseModel particle : particleModels) {
      particle.tick();
    }

    for (CellModel cell : cellModels) {
      cell.tick();
    }

    for (int i = particleModels.size() - 1; i >= 0; i--) {
      particleModels.get(i).cleanUpTick();
    }

    for (int i = cellModels.size() - 1; i >= 0; i--) {
      cellModels.get(i).cleanUpTick();
    }
  }

  public Subscription<?> subscribe(BodyModelClient observer, SubscriptionManager subscriptionManager) {
    boolean newObserver = !bodyModelEvents.getSubscribers().contains(observer);
    Subscription<?> result = bodyModelEvents.subscribe(observer, subscriptionManager);

    if (newObserver) {
      for (CellModel cellModel : cellModels) {
        observer.onAddCell(cellModel);
      }

      for (ParticleBaseModel particleModel : particleModels) {
        observer.onAddParticle(particleModel);
      }
    }

    return result;
  }
}