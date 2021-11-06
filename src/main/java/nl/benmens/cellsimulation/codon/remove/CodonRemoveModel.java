package nl.benmens.cellsimulation.codon.remove;

import java.util.ArrayList;

import nl.benmens.cellsimulation.codon.CodonBaseModel;
import nl.benmens.cellsimulation.codon.CodonModelContainer;
import nl.benmens.processing.SharedPApplet;
import processing.core.PApplet;

public class CodonRemoveModel extends CodonBaseModel {
  private int removeCodonsFirstPoint = PApplet.floor(SharedPApplet.random(5) - 2);
  private int removeCodonsSecondPoint = PApplet.floor(SharedPApplet.random(5) - 2);

  public CodonRemoveModel(CodonModelContainer parentModel) {
    super(parentModel);

    mainColor = SharedPApplet.color(255, 190, 35);
    getPossibleCodonParameters().add("none");
    getPossibleCodonParameters().add("wall");
    getPossibleCodonParameters().add("energy");
    getPossibleCodonParameters().add("codons");
  }

  public float getEnergyCost() {
    switch (codonParameter) {
      case "wall":
        if (parentModel.getIsExecuteHandPointingOutward()) {
          return baseEnergyCost;
        } else {
          return 0;
        }
      case "energy":
        if (parentModel.getIsExecuteHandPointingOutward()) {
          return 0;
        } else {
          return baseEnergyCost;
        }
      case "codons":
        if (parentModel.getIsExecuteHandPointingOutward()) {
          return 0;
        } else {
          ArrayList<CodonBaseModel> codonList = parentModel.getCodonList();
          return baseEnergyCost
              + baseEnergyCost * PApplet.min(PApplet.abs(removeCodonsFirstPoint - removeCodonsSecondPoint), codonList.size());
        }
    }

    return 0;
  }

  public void executeCodon() {
    switch (codonParameter) {
      case "wall":
        if (parentModel.getIsExecuteHandPointingOutward()) {
          parentModel.setWallHealth(0);
        }
        break;
      case "energy":
        if (!parentModel.getIsExecuteHandPointingOutward()) {
          parentModel.setEnergyLevel(0);
        }
        break;
      case "codons":
        if (!parentModel.getIsExecuteHandPointingOutward()) {
          ArrayList<CodonBaseModel> codonList = parentModel.getCodonList();
          int index = parentModel.getExecuteHandPosition();
          for (int i = index + PApplet.min(removeCodonsFirstPoint, removeCodonsSecondPoint); i <= index
              + PApplet.max(removeCodonsFirstPoint, removeCodonsSecondPoint); i++) {
            codonList.get(PApplet.abs(i % codonList.size())).isDead = true;
          }
        }
        break;
    }
    parentModel.subtractEnergyLevel(getEnergyCost());
  }

  public String getDisplayName() {
    return "remove";
  };
}