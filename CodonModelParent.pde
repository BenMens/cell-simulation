interface CodonModelParent {
    void addCodon(CodonBaseModel codonModel);

    void removeCodon(CodonBaseModel codonModel);


    PVector getPosition();


    ArrayList<CodonBaseModel> getCodonList();


    int getCodonHandPosition();

    void setCodonHandPosition(int codonHandPosition);


    int getExecuteHandPosition();

    boolean getIsExecuteHandPointingOutward();

    void setExecuteHandPosition(int executeHandPosition);

    void setIsExecuteHandPointingOutward(boolean isExecuteHandPointingOutward);


    void replaceCodon(CodonBaseModel oldCodon, CodonBaseModel newCodon);


    float getWallHealth();

    void setWallHealth(float health);

    void addWallHealth(float health);

    void subtractWallHealth(float health);


    float getEnergyLevel();

    void setEnergyLevel(float energy);

    void addEnergyLevel(float energy);

    void subtractEnergyLevel(float energy);
}
