package nl.benmens.cellsimulation;

import java.util.ArrayList;

import nl.benmens.processing.SharedPApplet;
import processing.core.PApplet;

public class CodonRemoveModel extends CodonBaseModel {
  int removeCodonsFirstPoint = PApplet.floor(SharedPApplet.random(5) - 2);
  int removeCodonsSecondPoint = PApplet.floor(SharedPApplet.random(5) - 2);

  public CodonRemoveModel(CodonModelParent parentModel) {
    super(parentModel);

    mainColor = SharedPApplet.color(255, 190, 35);
    possibleCodonParameters.add("none");
    possibleCodonParameters.add("wall");
    possibleCodonParameters.add("energy");
    possibleCodonParameters.add("codons");
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