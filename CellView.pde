class CellView extends ViewBase {
    ArrayList<CellViewClient> clients = new ArrayList<CellViewClient>();
    CellModel cellModel;


    CellView(CellModel cellModel) {
        this.cellModel = cellModel;
    }


    void registerClient(CellViewClient client) {
        if(!clients.contains(client)) {
            clients.add(client);
        }
    }

    void unregisterClient(CellViewClient client) {
        clients.remove(client);
    }


    void beforeDrawChildren() {
        noStroke();
        fill(255, 165, 135);
        rect(cellModel.position.x, cellModel.position.y, 100, 100);
    }
}
