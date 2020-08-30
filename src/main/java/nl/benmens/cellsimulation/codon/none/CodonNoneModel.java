package nl.benmens.cellsimulation.codon.none;

import nl.benmens.cellsimulation.codon.CodonBaseModel;
import nl.benmens.cellsimulation.codon.CodonModelParent;
import nl.benmens.processing.SharedPApplet;

public class CodonNoneModel extends CodonBaseModel {
  public CodonNoneModel(CodonModelParent parentModel) {
    super(parentModel);

    baseEnergyCost = 0;
    mainColor = SharedPApplet.color(0);
    getPossibleCodonParameters().add("none");
    getPossibleCodonParameters().add("wall");
    getPossibleCodonParameters().add("energy");
    getPossibleCodonParameters().add("codons");
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