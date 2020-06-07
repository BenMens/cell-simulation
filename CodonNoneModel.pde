class CodonNoneModel extends CodonBaseModel {
    CodonNoneModel(CodonModelParent parentModel) {
        super(parentModel);

        baseEnergyCost = 0;
        mainColor = color(0);
        possibleCodonParameters.add("none");
        possibleCodonParameters.add("wall");
        possibleCodonParameters.add("energy");
        possibleCodonParameters.add("codons");
    }


    float getEnergyCost() {
        return baseEnergyCost;
    }


    void executeCodon() {}

    String getDisplayName() {
        return "none";
    };

}
