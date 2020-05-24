class CellModel implements CodonModelParent {
    ArrayList<CellModelClient> clients = new ArrayList<CellModelClient>();
    BodyModel bodyModel;

    ArrayList<CodonBaseModel> codonModels = new ArrayList<CodonBaseModel>();

    float ticksPerCodonTick = 50;
    float ticksSinceLastCodonTick;

    boolean isDead = false;

    private PVector position;
    float wallHealth = 1;
    float energyLevel = 1;
    float energyCostPerTick = 0.03;

    int currentCodon;

    boolean edited = false;


    CellModel(BodyModel bodyModel, PVector position) {
        this.bodyModel = bodyModel;
        bodyModel.addCell(this);

        this.position = position;

        for(int i = 0; i < 10; i++) {
            new CodonBaseModel(this);
        }
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


    ArrayList<CodonBaseModel> getCodonList() {
        return codonModels;
    }


    PVector getPosition() {
        return position;
    }


    void tick() {
        while (ticksSinceLastCodonTick >= ticksPerCodonTick) {
            codonTick();
            ticksSinceLastCodonTick -= ticksPerCodonTick;
        }
        ticksSinceLastCodonTick++;

        for(CodonBaseModel codonModel : codonModels) {
            codonModel.tick();
        }

        if (wallHealth <= 0) {
            isDead = true;
        }
    }

    void codonTick() {
        energyLevel = max(energyLevel - energyCostPerTick, 0);

        currentCodon = (currentCodon + 1) % codonModels.size();
    }


    void cleanUpTick() {
        if (isDead) {
            for (CodonBaseModel codonModel : codonModels) {
                new ParticleWasteModel(bodyModel, codonModel.getPosition().x, codonModel.getPosition().y);
            }

            bodyModel.removeCell(this);
        }
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
        wallHealth -= particle.cellWallHarmfulness;
    }

}
