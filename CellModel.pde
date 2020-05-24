class CellModel implements CodonModelParent {
    ArrayList<CellModelClient> clients = new ArrayList<CellModelClient>();
    BodyModel bodyModel;

    ArrayList<CodonBaseModel> codonModels = new ArrayList<CodonBaseModel>();

    float ticksPerCodonTick = 50;
    float ticksSinceLastCodonTick;

    boolean isDead = false;

    private PVector position;
    private float wallHealth = 1;
    private float energyLevel = 1;
    float energyCostPerTick = 0.01;

    int currentCodon;

    boolean edited = false;


    CellModel(BodyModel bodyModel, PVector position) {
        this.bodyModel = bodyModel;
        bodyModel.addCell(this);

        this.position = position;

        for(int i = 0; i < 10; i++) {
            new CodonNoneModel(this);
        }

        CodonBaseModel removeCodon = new CodonRemoveModel(this);
        removeCodon.setCodonParameter(removeCodon.possibleCodonParameters.get(floor(random(removeCodon.possibleCodonParameters.size()))));
    }


    void registerClient(CellModelClient client) {
        if(!clients.contains(client)) {
            clients.add(client);

            for (CodonBaseModel codonModel: codonModels) {
                client.onAddCodon(codonModel);
            }
        }
    }

    void unregisterClient(CellModelClient client) {
        clients.remove(client);
    }


    void addCodon(CodonBaseModel newCodonModel) {
        codonModels.add(newCodonModel);

        for(CellModelClient client : clients) {
            client.onAddCodon(newCodonModel);
        }

        for (CodonBaseModel codonModel : codonModels) {
            codonModel.updatePosition();
        }
    }

    void removeCodon(CodonBaseModel oldCodonModel) {
        codonModels.remove(oldCodonModel);

        if (currentCodon >= codonModels.indexOf(oldCodonModel)) {
            currentCodon--;
        }

        for(CellModelClient client: clients) {
            client.onRemoveCodon(oldCodonModel);
        }

        for (CodonBaseModel codonModel : codonModels) {
            codonModel.updatePosition();
        }
    }


    ArrayList<CodonBaseModel> getCodonList() {
        return codonModels;
    }


    PVector getPosition() {
        return position;
    }


    void tick() {
        if (energyLevel > energyCostPerTick) {
            while (ticksSinceLastCodonTick >= ticksPerCodonTick) {
                codonTick();
                ticksSinceLastCodonTick -= ticksPerCodonTick;
            }
            ticksSinceLastCodonTick++;
        }

        for(CodonBaseModel codonModel : codonModels) {
            codonModel.tick();
        }

        if (wallHealth <= 0) {
            isDead = true;
        }
    }

    void codonTick() {
        energyLevel = max(energyLevel - energyCostPerTick, 0);

        if (energyLevel > codonModels.get(currentCodon).getEnergyCost()) {
            currentCodon = (currentCodon + 1) % codonModels.size();
            codonModels.get(currentCodon).executeCodon();
        }
    }


    void cleanUpTick() {
        for (int i = codonModels.size() - 1; i >= 0; i--) {
            codonModels.get(i).cleanUpTick();
        }

        if (isDead) {
            for (int i = codonModels.size() - 1; i >= 0; i--) {
                CodonBaseModel codonModel = codonModels.get(i);

                new ParticleWasteModel(bodyModel, codonModel.getPosition().x, codonModel.getPosition().y);

                codonModel.isDead = true;
                codonModel.cleanUpTick();
            }

            bodyModel.removeCell(this);
        }
    }


    float getWallHealth() {
        return wallHealth;
    }

    void setWallHealth(float health) {
        wallHealth = health;
    }

    void addWallHealth(float health) {
        wallHealth += health;
    }

    void subtractWallHealth(float health) {
        wallHealth -= health;
    }


    float getEnergyLevel() {
        return energyLevel;
    }

    void setEnergyLevel(float energy) {
        energyLevel = energy;
    }

    void addEnergyLevel(float energy) {
        energyLevel += energy;
    }

    void subtractEnergyLevel(float energy) {
        energyLevel -= energy;
    }


    boolean isSelected() {
        return bodyModel.getSelectedCell() == this;
    }

    CellModel getSelected() {
        return bodyModel.getSelectedCell();
    }

    void selectCell() {
        bodyModel.selectCell(this);
    }

    void unSelectCell() {
        bodyModel.unSelectCell(this);
    }


    void handleCollision(ParticleBaseModel particle) {
        //wallHealth -= particle.cellWallHarmfulness;
    }

}
