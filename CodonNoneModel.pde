class CodonNoneModel extends CodonBaseModel {
    CodonNoneModel(CodonModelParent parentModel) {
        super(parentModel);

        mainColor = color(0);
        possibleCodonParameters.add("none");
        possibleCodonParameters.add("wall");
        possibleCodonParameters.add("energy");
        possibleCodonParameters.add("codons");
    }


    float getEnergyCost() {
        return 0;
    }


    void executeCodon() {}
}
