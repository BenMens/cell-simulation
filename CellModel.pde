class CellModel {
    ArrayList<CellModelClient> clients = new ArrayList<CellModelClient>();
    BodyModel bodyModel;

    PVector position;

    float wallHealth = 1;


    CellModel(BodyModel bodyModel, PVector position) {
        this.bodyModel = bodyModel;
        bodyModel.addCell(this);

        this.position = position;
    }


    void registerClient(CellModelClient client) {
        if(!clients.contains(client)) {
            clients.add(client);
        }
    }

    void unregisterClient(CellModelClient client) {
        clients.remove(client);
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
