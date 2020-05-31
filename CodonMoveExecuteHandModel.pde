class CodonMoveExecuteHandModel extends CodonBaseModel {
    int moveHandAmount = floor(random(5) - 2);


    CodonMoveExecuteHandModel(CodonModelParent parentModel) {
        super(parentModel);

        mainColor = color(0, 200, 0);
        possibleCodonParameters.add("inward");
        possibleCodonParameters.add("outward");
        possibleCodonParameters.add("amount");
        possibleCodonParameters.add("weakest codon");
    }


    float getEnergyCost() {
        switch (codonParameter) {
            case "inward" :
                if (parentModel.getIsExecuteHandPointingOutward()) {
                    return baseEnergyCost;
                } else {
                    return 0;
                }
            case "outward" :
                if (!parentModel.getIsExecuteHandPointingOutward()) {
                    return baseEnergyCost;
                } else {
                    return 0;
                }
            case "amount" :
                if (moveHandAmount != 0) {
                    return baseEnergyCost;
                } else {
                    return 0;
                }
            case "weakest codon" :
                return baseEnergyCost;
        }

        return 0;
    }


    void executeCodon() {
        switch (codonParameter) {
            case "inward":
                parentModel.setIsExecuteHandPointingOutward(false);
                break;
            case "outward":
                parentModel.setIsExecuteHandPointingOutward(true);
                break;
            case "amount" :
                parentModel.setExecuteHandPosition(parentModel.getExecuteHandPosition() + moveHandAmount);
                break;
            case "weakest codon" :
                ArrayList<CodonBaseModel> codonList = parentModel.getCodonList();
                CodonBaseModel weakestCodon = codonList.get(0);

                for (CodonBaseModel codonModel : codonList) {
                    if (codonModel.getDegradation() > weakestCodon.getDegradation()) {
                        weakestCodon = codonModel;
                    }
                }

                if (weakestCodon != null) {
                    parentModel.setExecuteHandPosition(codonList.indexOf(weakestCodon));
                }
                break;
        }
        parentModel.subtractEnergyLevel(getEnergyCost());
    }
}
