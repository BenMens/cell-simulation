package nl.benmens.cellsimulation;

import java.util.ArrayList;
import java.util.HashMap;

import nl.benmens.processing.SharedPApplet;
import processing.core.PApplet;
import processing.core.PVector;

abstract class CodonBaseModel {
  final float SEGMENT_CIRCLE_RADIUS = 0.15f;

  ArrayList<CodonModelClient> clients = new ArrayList<CodonModelClient>();
  CodonModelParent parentModel;

  boolean isDead = false;

  int indexInCodonArray;
  float segmentSizeInCodonCircle;
  float segmentAngleInCodonCircle;
  protected PVector position = new PVector();

  ArrayList<String> possibleCodonParameters = new ArrayList<String>();
  protected String codonParameter = "none";

  float baseEnergyCost = 0.01f;
  float degradation = 0;
  float degradationRate = 0.0002f;

  protected int mainColor = SharedPApplet.color(0);
  protected HashMap<String, Integer> secondaryColors = new HashMap<String, Integer>();

  CodonBaseModel(CodonModelParent parentModel) {
    this.parentModel = parentModel;
    parentModel.addCodon(this);

    updatePosition();

    secondaryColors.put("none", SharedPApplet.color(0));
    secondaryColors.put("wall", SharedPApplet.color(250, 90, 70));
    secondaryColors.put("energy", SharedPApplet.color(245, 239, 50));
    secondaryColors.put("codons", SharedPApplet.color(45, 240, 190));
  }

  public void registerClient(CodonModelClient client) {
    if (!clients.contains(client)) {
      clients.add(client);
    }
  }

  public void unregisterClient(CodonModelClient client) {
    clients.remove(client);
  }

  public ArrayList<CodonBaseModel> getParentCodonList() {
    return parentModel.getCodonList();
  }

  public void updatePosition() {
    ArrayList<CodonBaseModel> codonArray = getParentCodonList();

    segmentSizeInCodonCircle = PApplet.TWO_PI / codonArray.size();
    indexInCodonArray = codonArray.indexOf(this);

    segmentAngleInCodonCircle = indexInCodonArray * segmentSizeInCodonCircle;

    position.x = parentModel.getPosition().x + 0.5f + PApplet.sin(segmentAngleInCodonCircle) * SEGMENT_CIRCLE_RADIUS;
    position.y = parentModel.getPosition().y + 0.5f + -PApplet.cos(segmentAngleInCodonCircle) * SEGMENT_CIRCLE_RADIUS;
  }

  public PVector getPosition() {
    return position;
  }

  public void setCodonParameter(String parameter) {
    if (possibleCodonParameters.contains(parameter)) {
      codonParameter = parameter;
    }
  }

  public int getMainColor() {
    return mainColor;
  }

  public int getSecondaryColor() {
    return secondaryColors.get(codonParameter);
  }

  public void tick() {
    degradation = PApplet.min(degradation + SharedPApplet.random(degradationRate * 2), 1);

    if (degradation >= 1 && !(this instanceof CodonNoneModel)) {
      parentModel.replaceCodon(this, new CodonNoneModel(parentModel));
    }
  }

  public void cleanUpTick() {
    if (isDead) {
      parentModel.removeCodon(this);

      for (CodonModelClient client : new ArrayList<CodonModelClient>(clients)) {
        client.onDestroy(this);
      }
    }
  }

  public abstract float getEnergyCost();

  public abstract void executeCodon();

  public abstract String getDisplayName();
}