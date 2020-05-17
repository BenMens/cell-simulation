class CellModel implements ActionModelParent {
    ArrayList<CellModelClient> clients = new ArrayList<CellModelClient>();
    BodyModel bodyModel;

    ArrayList<ActionBaseModel> actionModels = new ArrayList<ActionBaseModel>();

    PVector position;

    float wallHealth = 1;


    CellModel(BodyModel bodyModel, PVector position) {
        this.bodyModel = bodyModel;
        bodyModel.addCell(this);

        this.position = position;

        new ActionBaseModel(this);
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


    void addAction(ActionBaseModel actionModel) {
        actionModels.add(actionModel);

        for(CellModelClient client : clients) {
            client.onAddAction(actionModel);
        }
    }


    void tick() {}


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
