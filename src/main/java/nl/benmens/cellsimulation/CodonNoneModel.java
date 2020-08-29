package nl.benmens.cellsimulation;

import nl.benmens.processing.SharedPApplet;

public class CodonNoneModel extends CodonBaseModel {
  CodonNoneModel(CodonModelParent parentModel) {
    super(parentModel);

    baseEnergyCost = 0;
    mainColor = SharedPApplet.color(0);
    possibleCodonParameters.add("none");
    possibleCodonParameters.add("wall");
    possibleCodonParameters.add("energy");
    possibleCodonParameters.add("codons");
  }

  public float getEnergyCost() {
    return baseEnergyCost;
  }

  public void executeCodon() {
  }

  public String getDisplayName() {
    return "none";
  };

}