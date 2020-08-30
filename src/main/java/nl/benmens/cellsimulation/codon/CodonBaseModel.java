package nl.benmens.cellsimulation.codon;

import java.util.ArrayList;
import java.util.HashMap;

import nl.benmens.cellsimulation.codon.none.CodonNoneModel;
import nl.benmens.processing.SharedPApplet;
import nl.benmens.processing.mvc.Model;
import processing.core.PApplet;
import processing.core.PVector;

public abstract class CodonBaseModel extends Model {
  final float SEGMENT_CIRCLE_RADIUS = 0.15f;

  protected ArrayList<CodonModelEventHandler> clients = new ArrayList<CodonModelEventHandler>();
  protected CodonModelParent parentModel;

  public boolean isDead = false;

  protected int indexInCodonArray;
  protected float segmentSizeInCodonCircle;
  private  float segmentAngleInCodonCircle;
  protected PVector position = new PVector();

  private  ArrayList<String> possibleCodonParameters = new ArrayList<String>();
  protected String codonParameter = "none";

  protected float baseEnergyCost = 0.01f;
  protected float degradation = 0;
  protected float degradationRate = 0.0002f;

  protected int mainColor = SharedPApplet.color(0);
  protected HashMap<String, Integer> secondaryColors = new HashMap<String, Integer>();

  public CodonBaseModel(CodonModelParent parentModel) {
    this.parentModel = parentModel;
    parentModel.addCodon(this);

    updatePosition();

    secondaryColors.put("none", SharedPApplet.color(0));
    secondaryColors.put("wall", SharedPApplet.color(250, 90, 70));
    secondaryColors.put("energy", SharedPApplet.color(245, 239, 50));
    secondaryColors.put("codons", SharedPApplet.color(45, 240, 190));
  }

  public float getSegmentAngleInCodonCircle() {
    return segmentAngleInCodonCircle;
  }

  public void setSegmentAngleInCodonCircle(float segmentAngleInCodonCircle) {
    this.segmentAngleInCodonCircle = segmentAngleInCodonCircle;
  }

  public ArrayList<String> getPossibleCodonParameters() {
    return possibleCodonParameters;
  }

  public void setPossibleCodonParameters(ArrayList<String> possibleCodonParameters) {
    this.possibleCodonParameters = possibleCodonParameters;
  }

  public void registerClient(CodonModelEventHandler client) {
    if (!clients.contains(client)) {
      clients.add(client);
    }
  }

  public void unregisterClient(CodonModelEventHandler client) {
    clients.remove(client);
  }

  public ArrayList<CodonBaseModel> getParentCodonList() {
    return parentModel.getCodonList();
  }

  public void updatePosition() {
    ArrayList<CodonBaseModel> codonArray = getParentCodonList();

    segmentSizeInCodonCircle = PApplet.TWO_PI / codonArray.size();
    indexInCodonArray = codonArray.indexOf(this);

    setSegmentAngleInCodonCircle(indexInCodonArray * segmentSizeInCodonCircle);

    position.x = parentModel.getPosition().x + 0.5f + PApplet.sin(getSegmentAngleInCodonCircle()) * SEGMENT_CIRCLE_RADIUS;
    position.y = parentModel.getPosition().y + 0.5f + -PApplet.cos(getSegmentAngleInCodonCircle()) * SEGMENT_CIRCLE_RADIUS;
  }

  public PVector getPosition() {
    return position;
  }

  public void setCodonParameter(String parameter) {
    if (getPossibleCodonParameters().contains(parameter)) {
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
      destroy();
    }
  }

  @Override
  public void onDestroy() {
    super.onDestroy();

    parentModel.removeCodon(this);

    for (CodonModelEventHandler client : new ArrayList<CodonModelEventHandler>(clients)) {
      client.onDestroy(this);
    }
}

  public abstract float getEnergyCost();

  public abstract void executeCodon();

  public abstract String getDisplayName();
}