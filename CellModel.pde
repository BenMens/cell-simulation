class CellModel implements ActionModelParent {
    ArrayList<CellModelClient> clients = new ArrayList<CellModelClient>();
    BodyModel bodyModel;

    ArrayList<ActionBaseModel> actionModels = new ArrayList<ActionBaseModel>();

    float ticksPerActionTick = 50;
    float ticksSinceLastActionTick;

    boolean isDead = false;

    private PVector position;
    float wallHealth = 1;
    float energyLevel = 1;
    float energyCostPerTick = 0.03;

    int currentAction;

    boolean edited = false;


    CellModel(BodyModel bodyModel, PVector position) {
        this.bodyModel = bodyModel;
        bodyModel.addCell(this);

        this.position = position;

        for(int i = 0; i < 10; i++) {
            new ActionBaseModel(this);
        }
    }


    void registerClient(CellModelClient client) {
        if(!clients.contains(client)) {
            clients.add(client);

            for (ActionBaseModel actionModel: actionModels) {
                client.onAddAction(actionModel);
            }
        }
    }

    void unregisterClient(CellModelClient client) {
        clients.remove(client);
    }


    void addAction(ActionBaseModel newActionModel) {
        actionModels.add(newActionModel);

        for(CellModelClient client : clients) {
            client.onAddAction(newActionModel);
        }

        for (ActionBaseModel actionModel : actionModels) {
            actionModel.updatePosition();
        }
    }


    ArrayList<ActionBaseModel> getActionList() {
        return actionModels;
    }


    PVector getPosition() {
        return position;
    }


    void tick() {
        while (ticksSinceLastActionTick >= ticksPerActionTick) {
            actionTick();
            ticksSinceLastActionTick -= ticksPerActionTick;
        }
        ticksSinceLastActionTick++;

        for(ActionBaseModel actionModel : actionModels) {
            actionModel.tick();
        }

        if (wallHealth <= 0) {
            isDead = true;
        }
    }

    void actionTick() {
        energyLevel = max(energyLevel - energyCostPerTick, 0);

        currentAction = (currentAction + 1) % actionModels.size();
    }


    void cleanUpTick() {
        if (isDead) {
            for (ActionBaseModel actionModel : actionModels) {
                new ParticleWasteModel(bodyModel, actionModel.getPosition().x, actionModel.getPosition().y);
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
