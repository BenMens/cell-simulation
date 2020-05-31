class CodonMoveCodonHandModel extends CodonBaseModel {
    int moveHandAmount = floor(random(5) - 2);


    CodonMoveCodonHandModel(CodonModelParent parentModel) {
        super(parentModel);

        mainColor = color(200, 0, 0);
        possibleCodonParameters.add("amount");
    }


    float getEnergyCost() {
        switch (codonParameter) {
            case "amount" :
                if (moveHandAmount != 0) {
                    return baseEnergyCost;
                } else {
                    return 0;
                }
        }

        return 0;
    }


    void executeCodon() {
        switch (codonParameter) {
            case "amount" :
                parentModel.setExecuteHandPosition(parentModel.getExecuteHandPosition() + moveHandAmount);
                break;
        }
        parentModel.subtractEnergyLevel(getEnergyCost());
    }
}
