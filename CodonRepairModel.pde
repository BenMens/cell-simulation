class CodonRepairModel extends CodonBaseModel {
    float energyCostForFullRepair = 0.2;
    float repairPercent = 0.3;


    CodonRepairModel(CodonModelParent parentModel) {
        super(parentModel);

        mainColor = color(50, 240, 95);
        possibleCodonParameters.add("none");
        possibleCodonParameters.add("wall");
        possibleCodonParameters.add("codon");
    }


    float getEnergyCost() {
        switch (codonParameter) {
            case "wall" :
                if (parentModel.getIsExecuteHandPointingOutward()) {
                    return baseEnergyCost + (1 - parentModel.getWallHealth()) * repairPercent * energyCostForFullRepair;
                } else {
                    return 0;
                }
            case "codon" :
                if (!parentModel.getIsExecuteHandPointingOutward()) {
                    CodonBaseModel codonAtExecuteHand = parentModel.getCodonList().get(parentModel.getExecuteHandPosition());
                    return baseEnergyCost + (1 - codonAtExecuteHand.getDegradation()) * repairPercent * energyCostForFullRepair;
                } else {
                    return 0;
                }
        }

        return 0;
    }


    void executeCodon() {
        switch (codonParameter) {
            case "wall":
                if (parentModel.getIsExecuteHandPointingOutward()) {
                    parentModel.setWallHealth(lerp(parentModel.getWallHealth(), 1, repairPercent));
                }
                break;
            case "codon":
                if (!parentModel.getIsExecuteHandPointingOutward()) {
                    CodonBaseModel codonAtExecuteHand = parentModel.getCodonList().get(parentModel.getExecuteHandPosition());
                    codonAtExecuteHand.setDegradation(lerp(codonAtExecuteHand.getDegradation(), 0, repairPercent));
                }
                break;
        }
        parentModel.subtractEnergyLevel(getEnergyCost());
    }
}
