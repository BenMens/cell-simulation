class CodonRemoveModel extends CodonBaseModel {
    int removeCodonsFirstPoint = floor(random(5) - 2);
    int removeCodonsSecondPoint = floor(random(5) - 2);


    CodonRemoveModel(CodonModelParent parentModel) {
        super(parentModel);

        mainColor = color(255, 190, 35);
        possibleCodonParameters.add("none");
        possibleCodonParameters.add("wall");
        possibleCodonParameters.add("energy");
        possibleCodonParameters.add("codons");
    }


    float getEnergyCost() {
        switch (codonParameter) {
            case "codons" :
                return baseEnergyCost + baseEnergyCost * abs(removeCodonsFirstPoint - removeCodonsSecondPoint);
            default :
                return baseEnergyCost;
        }
    }


    void executeCodon() {
        switch (codonParameter) {
            case "wall":
                parentModel.setWallHealth(0);
                break;
            case "energy":
                parentModel.setEnergyLevel(0);
                break;
            case "codons":
                ArrayList<CodonBaseModel> codonList = parentModel.getCodonList();
                int index = codonList.indexOf(this);
                for (int i = index + min(removeCodonsFirstPoint, removeCodonsSecondPoint); i < index + max(removeCodonsFirstPoint, removeCodonsSecondPoint); i++) {
                    codonList.get(abs(i % codonList.size())).isDead = true;
                }
                break;
        }
        if (codonParameter != "none") {
            parentModel.subtractEnergyLevel(getEnergyCost());
        }
    }
}
